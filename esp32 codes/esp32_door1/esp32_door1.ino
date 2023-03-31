#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <PubSubClient.h>

#if CONFIG_FREERTOS_UNICORE
#define ARDUINO_RUNNING_CORE 0
#else
#define ARDUINO_RUNNING_CORE 1
#endif


#define SOUND_SPEED 0.034
#define CM_TO_INCH 0.393701

const char* ssid = "Galaxy A3 Core7828";
const char* password = "qfvy3253";

// Add your MQTT Broker IP address, example:
//const char* mqtt_server = "192.168.1.144";
const char* mqtt_server = "192.168.43.174";

const int door1us1trig = 18; // GIOP18 pin connected to TRIG pin of ultrasonic sensor 1
const int door1us1echo = 19; // GIOP19 pin connected to ECHO pin of ultrasonic sensor 1
const int door1us2trig = 2; // GIOP22 pin connected to TRIG pin of ultrasonic sensor 2
const int door1us2echo = 4; // GIOP23 pin connected to ECHO pin of ultrasonic sensor 2
int door = 22; //GPIO34 pin connected to IN2 for door relay
int lock = 23; //GPIO35 pin connected to IN2 for door relay
bool doorstatesensor = 1;
int doorstatehci = 2;
bool lockstate = 1;

long duration1;
float distance1Cm;
long duration2;
float distance2Cm;

WiFiClient espClient;
PubSubClient client(espClient);
long lastMsg = 0;
char msg[50];

const char* ultrasensor1_topic = "smarthome/devices/door1ultra1";
const char* ultrasensor2_topic = "smarthome/devices/door1ultra2";
const char* doortopic = "smarthome/devices/door";

void TaskSensorControl( void *pvParameters );
void TaskHCIControl( void *pvParameters );
TaskHandle_t xSensorControl_Handle;

void setup() {
  Serial.begin(115200);            // initialize serial
  setup_wifi();
  pinMode(door1us1trig, OUTPUT); // set ESP32 pin to output mode to read value from OUTPUT pin of sensor
  pinMode(door1us1echo, INPUT);
  pinMode(door1us2trig, OUTPUT);
  pinMode(door1us2echo, INPUT);
  pinMode(door, OUTPUT);
  pinMode(lock, OUTPUT);

//  #ifdef ESP8266
//    espClient.setInsecure();
//  #else
//    espClient.setCACert(root_ca);
//  #endif
//  
  client.setServer(mqtt_server, 1883);
  client.setCallback(callback);
  digitalWrite(door, HIGH);
  digitalWrite(lock, HIGH);

  reconnect();
  
    xTaskCreatePinnedToCore(
    TaskSensorControl
    ,  "Sensor Control"
    ,  4096  // Stack size
    ,  NULL  // When no parameter is used, simply pass NULL
    ,  3  // Priority
    ,  &xSensorControl_Handle // With task handle we will be able to manipulate with this task.
    ,  ARDUINO_RUNNING_CORE // Core on which the task will run
    );

      xTaskCreatePinnedToCore(
    TaskHCIControl
    ,  "HCI Control"
    ,  4096  // Stack size
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
        digitalWrite(door1us1trig, LOW);
        delayMicroseconds(2);
        // Sets the trigPin on HIGH state for 10 micro seconds
        digitalWrite(door1us1trig, HIGH);
        delayMicroseconds(10);
        digitalWrite(door1us1trig, LOW);
        
        // Reads the echoPin, returns the sound wave travel time in microseconds
        duration1 = pulseIn(door1us1echo, HIGH);
        


        // Calculate the distance
        distance1Cm = (duration1 * SOUND_SPEED)/2;
        

        digitalWrite(door1us2trig, LOW);
        delayMicroseconds(2);
        digitalWrite(door1us2trig, HIGH);
        delayMicroseconds(10);
        digitalWrite(door1us2trig, LOW);

        duration2 = pulseIn(door1us2echo, HIGH);
        distance2Cm = (duration2 * SOUND_SPEED)/2;

        Serial.print("Distance 1:");
        Serial.println(distance1Cm);
        Serial.print("Distance 2:");
        Serial.println(distance2Cm);

        if(distance1Cm < 80 && distance2Cm < 80) {

          digitalWrite(door1us1trig, LOW);
          delayMicroseconds(2);
          // Sets the trigPin on HIGH state for 10 micro seconds
          digitalWrite(door1us1trig, HIGH);
          delayMicroseconds(10);
          digitalWrite(door1us1trig, LOW);
          
          // Reads the echoPin, returns the sound wave travel time in microseconds
          duration1 = pulseIn(door1us1echo, HIGH);
          
  
  
          // Calculate the distance
          distance1Cm = (duration1 * SOUND_SPEED)/2;
          
  
          digitalWrite(door1us2trig, LOW);
          delayMicroseconds(2);
          digitalWrite(door1us2trig, HIGH);
          delayMicroseconds(10);
          digitalWrite(door1us2trig, LOW);
  
          duration2 = pulseIn(door1us2echo, HIGH);
          distance2Cm = (duration2 * SOUND_SPEED)/2;
  
          Serial.print("Distance 1 Again:");
          Serial.println(distance1Cm);
          Serial.print("Distance 2 Again:");
          Serial.println(distance2Cm);
          
          if(distance1Cm < 50 && distance2Cm < 50) {
            doorstatesensor = 0;
          }
          else {
            doorstatesensor = 1;
          }  
        }
        else{
          doorstatesensor = 1;
        }

      if(doorstatesensor == 0) {
          digitalWrite(door, LOW);
          digitalWrite(lock, LOW);
          publishMessage(ultrasensor1_topic, String(distance1Cm),true);
          publishMessage(ultrasensor2_topic, String(distance2Cm),true);
          //open door
          vTaskDelay(10000 / portTICK_PERIOD_MS);

          //close door
          vTaskDelay(10000 / portTICK_PERIOD_MS);
          doorstatesensor = 1;
      }
      else {
          digitalWrite(door, HIGH);
          digitalWrite(lock, HIGH);
      }


        vTaskDelay(500/portTICK_PERIOD_MS);
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
    if(doorstatehci == 0) {
      digitalWrite(lock,LOW);
      digitalWrite(door,LOW);
      Serial.println("Motor on");
      //open door
      vTaskSuspend(xSensorControl_Handle);
      vTaskDelay(10000 / portTICK_PERIOD_MS);
      vTaskResume(xSensorControl_Handle);
      doorstatehci = 2;
      

    }
    else if(doorstatehci == 1){
      digitalWrite(lock,LOW);
      digitalWrite(door,LOW);
      Serial.println("Motor on");
      vTaskSuspend(xSensorControl_Handle);
      vTaskDelay(10000 / portTICK_PERIOD_MS);
      vTaskResume(xSensorControl_Handle);
      doorstatehci = 2;
    }
    else {
      doorstatehci = 2;
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
      client.subscribe(doortopic);
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
  Serial.println("Message arrived [" + String(topic) + "]" + incomingMessage);
  if(strcmp(topic,doortopic) == 0) {
    if(incomingMessage.equals("0")) {
      doorstatehci = 0;
    }
    else if(incomingMessage.equals("1")){
      doorstatehci = 1;
    }
    else{
      doorstatehci = 2;
    }
  }
}
