#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <PubSubClient.h>
#include <ezButton.h>
#include <Stepper.h>

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

const int blindsmotorin1 = 18; // GIOP18 pin connected to IN1 pin of L298N motor driver
const int blindsmotorin2 = 19; // GIOP19 pin connected to IN2 pin of L298N motor driver
const int blindsmotorin3 = 32; // GIOP18 pin connected to IN3 pin of L298N motor driver
const int blindsmotorin4 = 33; // GIOP19 pin connected to IN4 pin of L298N motor driver
const int lightbulb = 23; // GIOP22 pin connected to TRIG pin of ultrasonic sensor 2
bool blindstatesensor = 2;
int blindstatehci = 2;
int lightstatehci = 2;
bool lightstatesensor = 2;
int overstatus = 2;
int state;
const int steps_per_rev = 200; //Set to 200 for NEMA 17

WiFiClient espClient;
PubSubClient client(espClient);
long lastMsg = 0;
char msg[50];

ezButton limitSwitch(17);  // create ezButton object that attach to ESP32 pin GPIO17
Stepper motor(steps_per_rev, blindsmotorin1, blindsmotorin2, blindsmotorin3, blindsmotorin4);

const char* lightbulb_topic = "smarthome/devices/lightbulb";
const char* blinds_topic = "smarthome/devices/blindsmotor";
const char* lightintensity = "smarthome/devices/lightintensity";
const char* overridetop = "smarthome/status/override";

void TaskSensorControl( void *pvParameters );
void TaskHCIControl( void *pvParameters );
TaskHandle_t xSensorControl_Handle;

void setup() {
  motor.setSpeed(60);
  Serial.begin(115200);            // initialize serial
  setup_wifi();
  pinMode(lightbulb, OUTPUT);

  //  #ifdef ESP8266
  //    espClient.setInsecure();
  //  #else
  //    espClient.setCACert(root_ca);
  //  #endif
  //
  client.setServer(mqtt_server, 1883);
  client.setCallback(callback);
  digitalWrite(lightbulb, HIGH);

  limitSwitch.setDebounceTime(50); // set debounce time to 50 milliseconds

  state = limitSwitch.getState();
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
  state = limitSwitch.getState();;
}

void TaskSensorControl( void *pvParameters )  // This is a task.
{
  (void) pvParameters;
  for (;;)
  { 
    limitSwitch.loop(); // MUST call the loop() function first
    Serial.println("Blind State Sensor: ");
    Serial.println(blindstatesensor);

    Serial.println("Light State Sensor: ");
    Serial.println(lightstatesensor);

    Serial.println(state);
    state = limitSwitch.getState();

    
    if (blindstatesensor == 0 && lightstatesensor == 0 && state == HIGH) {
      digitalWrite(lightbulb, LOW); //turn on light bulb

      state = limitSwitch.getState();
      Serial.println(state);
      while (state == HIGH) {   //checking if frame has been touched
        Serial.println("clockwise");
        motor.step(steps_per_rev);
        vTaskDelay(60 / portTICK_PERIOD_MS);

      }
      blindstatesensor = 2;
      lightstatesensor = 2;
    }

    
    else if (blindstatesensor == 1 && lightstatesensor == 1 && state == LOW) {
      digitalWrite(lightbulb, HIGH); //turn off light bulb
      int i = 0;
      while(i < 10) {
        motor.step(-steps_per_rev);
        i++;
      }
 //     vTaskDelay(10000 / portTICK_PERIOD_MS);
      blindstatesensor = 2;
      lightstatesensor = 2;
    }

    
    else {
      blindstatesensor = 2;
      lightstatesensor = 2;
    }
    
    vTaskDelay(500 / portTICK_PERIOD_MS);
  }
}

void TaskHCIControl( void *pvParameters )
{
  (void) pvParameters;
  for (;;)
  { limitSwitch.loop(); // MUST call the loop() function first
  state = limitSwitch.getState();


      Serial.println("Blind State Sensor: ");
    Serial.println(blindstatehci);

    Serial.println("Light State Sensor: ");
    Serial.println(lightstatehci);

    Serial.println(state);
    state = limitSwitch.getState();


    
    if(overstatus == 0) {
      vTaskSuspend(xSensorControl_Handle);
    }
    else if(overstatus == 1) {
      vTaskResume(xSensorControl_Handle);
    }
    else {
    }
  
    //lower blinds
    state == limitSwitch.getState();
    if (blindstatehci == 0 && state == HIGH) {
      vTaskSuspend(xSensorControl_Handle);

      state = limitSwitch.getState();
      while (state == HIGH) {
        Serial.println("clockwise");
        motor.step(steps_per_rev);
        vTaskDelay(100/portTICK_PERIOD_MS);
        limitSwitch.loop();
        state = limitSwitch.getState();
        Serial.println(state);
      }
      
      blindstatehci = 2;
      vTaskResume(xSensorControl_Handle);
    }
    //raise blinds
    else if (blindstatehci == 1 && state == LOW) {
      vTaskSuspend(xSensorControl_Handle);
      int i = 0;
      while (i < 10) {
        Serial.println("anticlockwise");
        motor.step(-steps_per_rev);
        i++;
      }
      vTaskResume(xSensorControl_Handle);
      blindstatehci = 2;
      state = limitSwitch.getState();
    }
    else {
    }

    if (lightstatehci == 0 ) {
      vTaskSuspend(xSensorControl_Handle);
      digitalWrite(lightbulb, LOW); //turn on light bulb
      if (lightstatehci == 1) {
        digitalWrite(lightbulb, HIGH); //close tap
        lightstatehci = 2;
        vTaskResume(xSensorControl_Handle);
      }
    }
    else if (lightstatehci == 1) {
      digitalWrite(lightbulb, HIGH); //close tap
      lightstatehci = 2;
    }
    else {
      state = limitSwitch.getState();
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
    String clientID = "ESP32BlindsLightClient-";
    clientID += String(random(0xffff), HEX);
    Serial.println(clientID);
    if (client.connect(clientID.c_str())) {
      Serial.println("Connected.");
      client.subscribe(lightintensity);
      client.subscribe(lightbulb_topic);
      client.subscribe(blinds_topic);
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
  if (strcmp(topic, lightbulb_topic) == 0) {
    if (incomingMessage.equals("0")) {
      //turn on light
      lightstatehci = 0;
    }
    else if (incomingMessage.equals("1")) {
      //turn off light
      lightstatehci = 1;
      Serial.println("Hiii");
    }
    else {
      //do nothing
      lightstatehci = 2;
    }
  }
  else if (strcmp(topic, blinds_topic) == 0) {
    if (incomingMessage.equals("0")) {
      //raise blinds
      blindstatehci = 0;
    }
    else if (incomingMessage.equals("1")) {
      //lower blinds
      blindstatehci = 1;
    }
    else {
      //do nothing
      blindstatehci = 2;
    }
  }

  //Sensor Control
  else if (strcmp(topic, lightintensity) == 0) {
    if (incomingMessage.equals("0")) {
      //raise blinds and turn off light
      blindstatesensor = 1;
      lightstatesensor = 1;

    }
    else if (incomingMessage.equals("1")) {
      //lower blinds and turn on light
      blindstatesensor = 0;
      lightstatesensor = 0;
    }
    else {
      //do nothing
      blindstatesensor = 2;
      lightstatesensor = 2;
    }
  }
  //Override system
  else if (strcmp(topic, overridetop) == 0) {
    if (incomingMessage.equals("0")) {
      //raise blinds
      overstatus = 0;
    }
    else if (incomingMessage.equals("1")) {
      //lower blinds
      overstatus = 1;
    }
    else {
      //do nothing
      overstatus = 2;
    }
  }
  else{
    
  }
}
