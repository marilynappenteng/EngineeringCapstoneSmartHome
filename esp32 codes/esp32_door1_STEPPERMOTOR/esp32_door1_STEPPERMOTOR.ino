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


#define SOUND_SPEED 0.034
#define CM_TO_INCH 0.393701

const char* ssid = "Galaxy A3 Core7828";
const char* password = "qfvy3253";

// Add your MQTT Broker IP address, example:
//const char* mqtt_server = "192.168.1.144";
const char* mqtt_server = "192.168.43.174";

const int door1us1trig = 18; // GPIO18 pin connected to TRIG pin of ultrasonic sensor 1
const int door1us1echo = 19; // GPIO19 pin connected to ECHO pin of ultrasonic sensor 1
const int door1us2trig = 2; // GPIO2 pin connected to TRIG pin of ultrasonic sensor 2
const int door1us2echo = 4; // GPIO4 pin connected to ECHO pin of ultrasonic sensor 2
const int dm1 = 22; // GPIO22 pin connected to IN1 pin of L298N motor driver
const int dm2 = 23; // GPIO23 pin connected to IN2 pin of L298N motor driver
const int dm3 = 32; // GPIO32 pin connected to IN3 pin of L298N motor driver
const int dm4 = 33; // GPIO33 pin connected to IN4 pin of L298N motor driver
int lock = 25; //GPIO25 pin connected to IN2 for door relay
bool doorstatesensor = 1;
int doorstatehci = 2;
bool lockstate = 1;
int overstatus = 2;
bool state;
const int steps_per_rev = 200; //Set to 200 for NEMA 17

long duration1;
float distance1Cm;
long duration2;
float distance2Cm;

WiFiClient espClient;
PubSubClient client(espClient);
long lastMsg = 0;
char msg[50];

ezButton limitSwitch(17);  // create ezButton object that attach to ESP32 pin GPIO17
Stepper motor(steps_per_rev, dm1, dm2, dm3, dm4);

const char* ultrasensor1_topic = "smarthome/devices/door1ultra1";
const char* ultrasensor2_topic = "smarthome/devices/door1ultra2";
const char* doortopic = "smarthome/devices/door";
const char* overridetop = "smarthome/status/override";

void TaskSensorControl( void *pvParameters );
void TaskHCIControl( void *pvParameters );
//void TaskReadLimitSwitch( void *pvParameters );
TaskHandle_t xSensorControl_Handle;
//TaskHandle_t xHCIControl_Handle;
//TaskHandle_t xLimitSwitch_Handle;

void setup() {
  motor.setSpeed(60);
  Serial.begin(115200);            // initialize serial
  setup_wifi();
  pinMode(door1us1trig, OUTPUT); // set ESP32 pin to output mode to read value from OUTPUT pin of sensor
  pinMode(door1us1echo, INPUT);
  pinMode(door1us2trig, OUTPUT);
  pinMode(door1us2echo, INPUT);
  pinMode(lock, OUTPUT);

  //  #ifdef ESP8266
  //    espClient.setInsecure();
  //  #else
  //    espClient.setCACert(root_ca);
  //  #endif
  //
  client.setServer(mqtt_server, 1883);
  client.setCallback(callback);
  digitalWrite(lock, HIGH);

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
    ,  2  // Priority
    ,  NULL // With task handle we will be able to manipulate with this task.
    ,  ARDUINO_RUNNING_CORE // Core on which the task will run
  );
  //
  //    xTaskCreatePinnedToCore(
  //    TaskReadLimitSwitch
  //    ,  "Checking the Limit Switch"
  //    ,  1024  // Stack size
  //    ,  NULL  // When no parameter is used, simply pass NULL
  //    ,  1  // Priority
  //    ,  &xLimitSwitch_Handle // With task handle we will be able to manipulate with this task.
  //    ,  ARDUINO_RUNNING_CORE // Core on which the task will run
  //  );

}

void loop() {
  if (!client.connected()) reconnect();
  client.loop();
  state = limitSwitch.getState();
  //  Serial.println("Loop Switch State: ");
  //  state = limitSwitch.getState();
  //  Serial.println(state);

  //  checkLimitSwitch();
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
  { //vTaskSuspend(xLimitSwitch_Handle);

    limitSwitch.loop(); // MUST call the loop() function first

    state = limitSwitch.getState();
    Serial.println(state);
    digitalWrite(door1us1trig, LOW);
    delayMicroseconds(2);
    // Sets the trigPin on HIGH state for 10 micro seconds
    digitalWrite(door1us1trig, HIGH);
    delayMicroseconds(10);
    digitalWrite(door1us1trig, LOW);



    // Reads the echoPin, returns the sound wave travel time in microseconds
    duration1 = pulseIn(door1us1echo, HIGH);



    // Calculate the distance
    distance1Cm = (duration1 * SOUND_SPEED) / 2;

    Serial.println(distance1Cm);

    digitalWrite(door1us2trig, LOW);
    delayMicroseconds(2);
    digitalWrite(door1us2trig, HIGH);
    delayMicroseconds(10);
    digitalWrite(door1us2trig, LOW);

    duration2 = pulseIn(door1us2echo, HIGH);
    distance2Cm = (duration2 * SOUND_SPEED) / 2;

    Serial.println(distance2Cm);

    if (distance1Cm < 100 && distance2Cm < 100) {

      digitalWrite(door1us1trig, LOW);
      delayMicroseconds(2);
      // Sets the trigPin on HIGH state for 10 micro seconds
      digitalWrite(door1us1trig, HIGH);
      delayMicroseconds(10);
      digitalWrite(door1us1trig, LOW);

      // Reads the echoPin, returns the sound wave travel time in microseconds
      duration1 = pulseIn(door1us1echo, HIGH);



      // Calculate the distance
      distance1Cm = (duration1 * SOUND_SPEED) / 2;


      digitalWrite(door1us2trig, LOW);
      delayMicroseconds(2);
      digitalWrite(door1us2trig, HIGH);
      delayMicroseconds(10);
      digitalWrite(door1us2trig, LOW);

      duration2 = pulseIn(door1us2echo, HIGH);
      distance2Cm = (duration2 * SOUND_SPEED) / 2;


      if (distance1Cm < 80 && distance2Cm < 80) {
        doorstatesensor = 0;
      }
      else {
        doorstatesensor = 1;
      }
    }
    else {
      doorstatesensor = 1;
    }
    state = limitSwitch.getState();
    if (doorstatesensor == 0 && state == LOW) {


      publishMessage(ultrasensor1_topic, String(distance1Cm), true);
      publishMessage(ultrasensor2_topic, String(distance2Cm), true);
      //open door
      digitalWrite(lock, LOW);

      int i = 0;
      while (i < 10) {
        Serial.println(state);
        Serial.println("anticlockwise");
        motor.step(-steps_per_rev);
        i++;
      } //opening door

      
      vTaskDelay(500 / portTICK_PERIOD_MS);
      while (state == HIGH) {
        Serial.println("clockwise");
        motor.step(steps_per_rev);
        vTaskDelay(60 / portTICK_PERIOD_MS);
      }

      Serial.println("Check");
      //when it touches the frame
      digitalWrite(lock, HIGH);
      doorstatesensor = 1;
    }
    else {

    }
    vTaskDelay(500 / portTICK_PERIOD_MS);
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
  { limitSwitch.loop(); // MUST call the loop() function first
    //  vTaskSuspend(xLimitSwitch_Handle);
    state = limitSwitch.getState();
    Serial.print(state);
    

    //  Serial.print("Limit Switch State: ");
    //  Serial.println(state);
    if (doorstatehci == 1 || doorstatehci == 0) {
      Serial.print("Door Command: ");
      Serial.println(doorstatehci);
    }


    if (overstatus == 0) {
      vTaskSuspend(xSensorControl_Handle);
    }
    else if (overstatus == 1) {
      vTaskResume(xSensorControl_Handle);
    }
    else {
    }


    //open door
    state == limitSwitch.getState();
    if (doorstatehci == 0 && state == LOW) {
      digitalWrite(lock, LOW);
      //changing direction code

      //open door
      vTaskSuspend(xSensorControl_Handle);
      int i = 0;
      while (i < 10) {
        Serial.println("anticlockwise");
        motor.step(-steps_per_rev);
        i++;
      } //opening door
      vTaskResume(xSensorControl_Handle);
      doorstatehci = 2;
      state = limitSwitch.getState();


    }
    //close door
    else if (doorstatehci == 1 && state == HIGH) {
      //Serial.println("here");
      digitalWrite(lock, LOW);
      Serial.println("Motor on");
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
      //      vTaskResume(xLimitSwitch_Handle);
      doorstatehci = 2;
      digitalWrite(lock, HIGH);
      vTaskResume(xSensorControl_Handle);
    }
    else {
    }

    vTaskDelay(100 / portTICK_PERIOD_MS);
  }
}

//void TaskReadLimitSwitch( void *pvParameters )
//{
//  (void) pvParameters;
//
//  /*
//    AnalogReadSerial
//    Reads an analog input on pin A3, prints the result to the serial monitor.
//    Graphical representation is available using serial plotter (Tools > Serial Plotter menu)
//    Attach the center pin of a potentiometer to pin A3, and the outside pins to +5V and ground.
//
//    This example code is in the public domain.
//  */
//
//  for (;;) {
//    vTaskSuspend(xHCIControl_Handle);
//    if(state == HIGH) {
//      state = limitSwitch.getState();
//      Serial.println(state);
//      Serial.println("clockwise");
//      motor.step(steps_per_rev);
//    }
//    else if(state == LOW) {
//      vTaskResume(xHCIControl_Handle);
//    }
//  }
//}

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
    String clientID = "ESP32DoorClient-";
    clientID += String(random(0xffff), HEX);
    Serial.println(clientID);
    if (client.connect(clientID.c_str())) {
      Serial.println("Connected.");
      client.subscribe(doortopic);
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
  Serial.println("Didi");
  String incomingMessage = "";
  for (int i = 0; i < length; i++) {
    incomingMessage += (char)payload[i];
  }
  Serial.println("Message arrived [" + String(topic) + "]" + incomingMessage);
  if (strcmp(topic, doortopic) == 0) {
    if (incomingMessage.equals("0")) {
      Serial.println("Turn on motor");
      //open door
      doorstatehci = 0;
    }
    else if (incomingMessage.equals("1")) {
      Serial.println("Turn off motor");
      //close door
      doorstatehci = 1;
    }
    else {
      doorstatehci = 2;
    }
  }
  //Override system
  else if (strcmp(topic, overridetop) == 0) {
    if (incomingMessage.equals("0")) {
      Serial.println("Turn on override");
      //raise blinds
      overstatus = 0;
    }
    else if (incomingMessage.equals("1")) {
      Serial.println("Turn off override");
      //lower blinds
      overstatus = 1;
    }
    else {
      //do nothing
      overstatus = 2;
    }
  }
  else {

  }
}
