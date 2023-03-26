#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <PubSubClient.h>

#if CONFIG_FREERTOS_UNICORE
#define ARDUINO_RUNNING_CORE 0
#else
#define ARDUINO_RUNNING_CORE 1
#endif

const char* ssid = "Galaxy A3 Core7828";
const char* password = "qfvy3253";

// Add your MQTT Broker IP address, example:
//const char* mqtt_server = "192.168.1.144";
const char* mqtt_server = "192.168.43.174";

const int pir1 = 19; // GIOP19 pin connected to OUTPUT pin of pir sensor1
const int pir2 = 22; // GIOP22 pin connected to OUTPUT pin of pir sensor2
const int pir3 = 23; // GIOP23 pin connected to OUTPUT pin of pir sensor3
int door = 18; //GPIO18 pin connected to IN2 for door relay
bool pirstate1;
bool pirstate2;
bool pirstate3;
bool doorstate = 1;

WiFiClient espClient;
PubSubClient client(espClient);
long lastMsg = 0;
char msg[50];

const char* pirsensor1_topic = "smarthome/devices/door1pir1";
const char* pirsensor2_topic = "smarthome/devices/door1pir2";
const char* pirsensor3_topic = "smarthome/devices/door1pir3";
const char* doormotortopic = "smarthome/devices/doormotor";

void TaskSensorControl( void *pvParameters );
void TaskHCIControl( void *pvParameters );

void setup() {
  Serial.begin(115200);            // initialize serial
  setup_wifi();
  pinMode(pir1, INPUT); // set ESP32 pin to input mode to read value from OUTPUT pin of sensor
  pinMode(pir2, INPUT);
  pinMode(pir3, INPUT);
  pinMode(door, OUTPUT);

//  #ifdef ESP8266
//    espClient.setInsecure();
//  #else
//    espClient.setCACert(root_ca);
//  #endif
//  
  client.setServer(mqtt_server, 1883);
  client.setCallback(callback);
  digitalWrite(door, HIGH);

    xTaskCreatePinnedToCore(
    TaskSensorControl
    ,  "Sensor Control"
    ,  2048  // Stack size
    ,  NULL  // When no parameter is used, simply pass NULL
    ,  2  // Priority
    ,  NULL // With task handle we will be able to manipulate with this task.
    ,  ARDUINO_RUNNING_CORE // Core on which the task will run
    );

      xTaskCreatePinnedToCore(
    TaskHCIControl
    ,  "HCI Control"
    ,  2048  // Stack size
    ,  NULL  // When no parameter is used, simply pass NULL
    ,  1  // Priority
    ,  NULL // With task handle we will be able to manipulate with this task.
    ,  ARDUINO_RUNNING_CORE // Core on which the task will run
    );
}

void loop() {
  if(!client.connected()) reconnect();
  client.loop();    
}

void TaskSensorControl( void *pvParameters )  // This is a task.
{
  (void) pvParameters;
  
/*
  AnalogReadSerial
  Reads an analog input on pin A3, prints the result to the serial monitor.
  Graphical representation is available using serial plotter (Tools > Serial Plotter menu)
  Attach the center pin of a potentiometer to pin A3, and the outside pins to +5V and ground.

  This example code is in the public domain.
*/

  for (;;)
  {
     pirstate1 = digitalRead(pir1);   // check for motion
     pirstate2 = digitalRead(pir2);   
     pirstate3 = digitalRead(pir3);
     if (pirstate1 == HIGH && pirstate2 == HIGH && pirstate3 == HIGH) {
      Serial.println("Motion detected!");
      Serial.println(pirstate1);
      Serial.println(pirstate2);
      Serial.println(pirstate3);
      vTaskDelay(100);  // one tick delay (15ms) in between reads for stability
      
      pirstate1 = digitalRead(pir1);   // check for motion
      pirstate2 = digitalRead(pir2);   
      pirstate3 = digitalRead(pir3);
    
      Serial.print("Hi");
      Serial.println(pirstate1);
      Serial.print("Hi");
      Serial.println(pirstate2);
      Serial.print("Hi");
      Serial.println(pirstate3);
        
      if (pirstate1 == HIGH && pirstate2 == HIGH && pirstate3 == HIGH) {
      Serial.println("Open door!");
      digitalWrite(door, LOW);
      publishMessage(pirsensor1_topic, String(pirstate1),true);
      publishMessage(pirsensor2_topic, String(pirstate2),true);
      publishMessage(pirsensor3_topic, String(pirstate3),true);
      vTaskDelay(333);
      }
    }
    else {
      digitalWrite(door, HIGH);
      
    }
  }
}

void TaskHCIControl( void *pvParameters )
{
  (void) pvParameters;
  
/*
  AnalogReadSerial
  Reads an analog input on pin A3, prints the result to the serial monitor.
  Graphical representation is available using serial plotter (Tools > Serial Plotter menu)
  Attach the center pin of a potentiometer to pin A3, and the outside pins to +5V and ground.

  This example code is in the public domain.
*/

  for (;;)
  {
    // read the input on analog pin A6
    if(doorstate == 0) {
      digitalWrite(door,LOW);
      vTaskDelay(333)
    }
    else{
      digitalWrite(door,HIGH);
    }
  }
}

void setup_wifi() {
  delay(10);
  Serial.print("\nConnecting to ");
  Serial.println(ssid);

  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
  Serial.println("");

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  //=======
  Serial.println("");
  Serial.print("Connected to ");
  Serial.println(ssid);
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());
  //=======
  randomSeed(micros());
  Serial.println("\nWiFi connected\nIP address: ");
  Serial.println(WiFi.localIP());
}

void publishMessage(const char* topic, String payload, boolean retained){
  if(client.publish(topic,payload.c_str(),true))  Serial.println("Messaqe published [" +String(topic)+ "]: " + payload);
  }

void reconnect() {
  while(!client.connected()){
    Serial.print("Attempting MQTT connection...");
    String clientID = "ESP32DoorClient-";
    clientID += String(random(0xffff), HEX);
    Serial.println(clientID);
    if(client.connect(clientID.c_str())){
      Serial.println("Connected.");
      client.subscribe(doormotortopic);
    }
    else {
      Serial.print("failed,rc=");
      Serial.println(client.state());
      Serial.println("Try again in 5 seconds");
      delay(5000);
    }
  }
}


void callback(char* topic, byte* payload, unsigned int length){
  String incomingMessage="";
  for(int i=0; i< length; i++) {
    incomingMessage += (char)payload[i];
  }
  Serial.print("Message arrived [" + String(topic) + "]" + incomingMessage);
  if(strcmp(topic,doormotortopic) == 0) {
    if(incomingMessage.equals("0")) {
      Serial.println(incomingMessage);
      doorstate = 0;
    }
    else if(incomingMessage.equals("1")){
      doorstate = 1;
    }
    else{
    }
  }
}
