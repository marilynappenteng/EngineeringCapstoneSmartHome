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

const int trig = 22; // GIOP18 pin connected to IN1 pin of L298N motor driver
const int echo = 23; // GIOP19 pin connected to IN2 pin of L298N motor driver
const int flow = 34; // GIOP22 pin connected to TRIG pin of ultrasonic sensor 2
const int valve = 35; // GIOP22 pin connected to TRIG pin of ultrasonic sensor 2
int tapstatehci = 2;
int overstatus = 2;
int waterflow;
float distance, duration;

WiFiClient espClient;
PubSubClient client(espClient);
long lastMsg = 0;
char msg[50];


const char* flowrate_topic = "smarthome/devices/flowrate";
const char* tap_topic = "smarthome/devices/tap";
const char* overridetop = "smarthome/status/override";

void TaskSensorControl( void *pvParameters );
void TaskHCIControl( void *pvParameters );
TaskHandle_t xSensorControl_Handle;

void setup() {
  Serial.begin(115200);            // initialize serial
  setup_wifi();
  pinMode(trig, OUTPUT); // set ESP32 pin to output mode to read value from OUTPUT pin of sensor
  pinMode(echo, INPUT);
  pinMode(flow, INPUT);
  pinMode(valve, OUTPUT);

  //  #ifdef ESP8266
  //    espClient.setInsecure();
  //  #else
  //    espClient.setCACert(root_ca);
  //  #endif
  //
  client.setServer(mqtt_server, 1883);
  client.setCallback(callback);
  digitalWrite(valve, HIGH);

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
    ,  8192  // Stack size
    ,  NULL  // When no parameter is used, simply pass NULL
    ,  1  // Priority
    ,  NULL // With task handle we will be able to manipulate with this task.
    ,  ARDUINO_RUNNING_CORE // Core on which the task will run
  );

}

void loop() {
  if (!client.connected()) reconnect();
  client.loop();
}

void TaskSensorControl( void *pvParameters )  // This is a task.
{
  (void) pvParameters;
  for (;;)
  {
        digitalWrite(trig, LOW);
        delayMicroseconds(2);
        // Sets the trigPin on HIGH state for 10 micro seconds
        digitalWrite(trig, HIGH);
        delayMicroseconds(10);
        digitalWrite(trig, LOW);
        
        // Reads the echoPin, returns the sound wave travel time in microseconds
        duration = pulseIn(echo, HIGH);
        


        // Calculate the distance
        distance = (duration * SOUND_SPEED)/2;
        

    if (distance <= 20 && flow == 0) {
      digitalWrite(valve, LOW); //open tap
    }
    
    else if (distance > 20 && flow > 0) {
      digitalWrite(valve, HIGH); //close tap
    }
    else {
    }
    vTaskDelay(500 / portTICK_PERIOD_MS);
  }
}

void TaskHCIControl( void *pvParameters )
{
  (void) pvParameters;
  for (;;)
  {if(overstatus == 0) {
      vTaskSuspend(xSensorControl_Handle);
    }
    else if(overstatus == 1) {
      vTaskResume(xSensorControl_Handle);
    }
    else {
    }

    if (tapstatehci == 0) {
      vTaskSuspend(xSensorControl_Handle);
      digitalWrite(valve, LOW); //open tap
      tapstatehci = 2;
      vTaskResume(xSensorControl_Handle);
    }
    else if (tapstatehci == 1) {
      vTaskSuspend(xSensorControl_Handle);
      digitalWrite(valve, HIGH); //open tap
      tapstatehci = 2;
      vTaskResume(xSensorControl_Handle);
    }
    else {
      tapstatehci = 2;
    }

    if (lightstatehci == 0 ) {
      vTaskSuspend(xSensorControl_Handle);
      digitalWrite(lightbulb, LOW); //turn on light bulb
      vTaskResume(xSensorControl_Handle);
      lightstatehci = 2;
    }
    else if (lightstatehci == 1) {
      vTaskSuspend(xSensorControl_Handle);
      digitalWrite(lightbulb, HIGH); //turn off light bulb
      vTaskResume(xSensorControl_Handle);
      lightstatehci = 2;
    }
    else {
      lightstatehci = 2;
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

void publishMessage(const char* topic, String payload, boolean retained) {
  if (client.publish(topic, payload.c_str(), true))  Serial.println("Messaqe published [" + String(topic) + "]: " + payload);
}

void reconnect() {
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    String clientID = "ESP32TapClient-";
    clientID += String(random(0xffff), HEX);
    Serial.println(clientID);
    if (client.connect(clientID.c_str())) {
      Serial.println("Connected.");
      client.subscribe(tap_topic);
      client.subscribe(overridetop);
    }
    else {
      Serial.print("failed,rc=");
      Serial.println(client.state());
      Serial.println("Try again in 5 seconds");
      delay(5000);
    }
  }
}


void callback(char* topic, byte * payload, unsigned int length) {
  String incomingMessage = "";
  for (int i = 0; i < length; i++) {
    incomingMessage += (char)payload[i];
  }

  //HCI Control
  Serial.println("Message arrived [" + String(topic) + "]" + incomingMessage);
  if (strcmp(topic, tap_topic) == 0) {
    if (incomingMessage.equals("0")) {
      //open tap
      tapstatehci = 0;
    }
    else if (incomingMessage.equals("1")) {
      //turn off light
      tapstatehci = 1;
    }
    else {
      //do nothing
      tapstatehci = 2;
    }
  }
    //Override system
  else if (strcmp(topic, overridetop) == 0) {
    if (incomingMessage.equals("0")) {
      //activate override
      overstatus = 0;
    }
    else if (incomingMessage.equals("1")) {
      //deactivate override
      overstatus = 1;
    }
    else {
      //do nothing
      overstatus = 2;
    }
  }
}
