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

const int door1us1trig = 18; // GIOP18 pin connected to TRIG pin of ultrasonic sensor 1
const int door1us1echo = 19; // GIOP19 pin connected to ECHO pin of ultrasonic sensor 1
const int door1us2trig = 2; // GIOP22 pin connected to TRIG pin of ultrasonic sensor 2
const int door1us2echo = 4; // GIOP23 pin connected to ECHO pin of ultrasonic sensor 2
const int doormotor1 = 22; // GIOP18 pin connected to IN1 pin of L298N motor driver
const int doormotor2 = 23; // GIOP19 pin connected to IN2 pin of L298N motor driver
const int doormotor3 = 32; // GIOP18 pin connected to IN3 pin of L298N motor driver
const int doormotor4 = 33; // GIOP19 pin connected to IN4 pin of L298N motor driver
int lock = 34; //GPIO334 pin connected to IN2 for door relay
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
Stepper motor(steps_per_rev, doormotor1, doormotor2, doormotor3, doormotor4);

const char* ultrasensor1_topic = "smarthome/devices/door1ultra1";
const char* ultrasensor2_topic = "smarthome/devices/door1ultra2";
const char* doortopic = "smarthome/devices/door";
const char* overridetop = "smarthome/status/override";

void TaskSensorControl( void *pvParameters );
void TaskHCIControl( void *pvParameters );
TaskHandle_t xSensorControl_Handle;

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
    ,  8192  // Stack size
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
  // put your main code here, to run repeatedly:
  if (!client.connected()) reconnect();
  client.loop();
  checkLimitSwitch();
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
  Serial.println("Trigger 1 start");
    digitalWrite(door1us1trig, LOW);
    delayMicroseconds(2);
    // Sets the trigPin on HIGH state for 10 micro seconds
    digitalWrite(door1us1trig, HIGH);
    delayMicroseconds(10);
    digitalWrite(door1us1trig, LOW);


    Serial.println("Trigger 1 done");
    // Reads the echoPin, returns the sound wave travel time in microseconds
    duration1 = pulseIn(door1us1echo, HIGH);
    Serial.println("Echo 1");


    // Calculate the distance
    distance1Cm = (duration1 * SOUND_SPEED) / 2;
    Serial.println(distance1Cm);

//    Serial.println("Trigger 2 start");
//    digitalWrite(door1us2trig, LOW);
//    delayMicroseconds(2);
//    digitalWrite(door1us2trig, HIGH);
//    delayMicroseconds(10);
//    digitalWrite(door1us2trig, LOW);
//    Serial.println("Trigger 2 done");
//
//    duration2 = pulseIn(door1us2echo, HIGH);
//    Serial.println("Echo 2");
//
//    distance2Cm = (duration2 * SOUND_SPEED) / 2;

    state = limitSwitch.getState();
    //Serial.println(state);

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

    if (overstatus == 0) {
      vTaskSuspend(xSensorControl_Handle);
    }
    else if (overstatus == 1) {
      vTaskResume(xSensorControl_Handle);
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
        motor.step(-steps_per_rev);
        i++;
      } //opening door
      vTaskResume(xSensorControl_Handle);
      doorstatehci = 2;
      state == limitSwitch.getState();

    }
    //close door
    else if (doorstatehci == 1 && state == HIGH) {
      Serial.println("here");
      digitalWrite(lock, LOW);
      Serial.println("Motor on");
      vTaskSuspend(xSensorControl_Handle);
      //changing direction code

      //when it touches the frame
      state = limitSwitch.getState();
      Serial.println(state);
      while (state == HIGH) {
        state = limitSwitch.getState();
        motor.step(steps_per_rev);
      }
      doorstatehci = 2;
      digitalWrite(lock, HIGH);
      vTaskResume(xSensorControl_Handle);
    }
    else {
      state = limitSwitch.getState();
    }
  }
}


void checkLimitSwitch() {
  state = limitSwitch.getState();
  while (state == HIGH) {
    state = limitSwitch.getState();

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
    String clientID = "ESP32DoorClient-";
    clientID += String(random(0xffff), HEX);
    Serial.println(clientID);
    if (client.connect(clientID.c_str())) {
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


void callback(char* topic, byte* payload, unsigned int length) {
  String incomingMessage = "";
  for (int i = 0; i < length; i++) {
    incomingMessage += (char)payload[i];
  }
  Serial.println("Message arrived [" + String(topic) + "]" + incomingMessage);
  if (strcmp(topic, doortopic) == 0) {
    if (incomingMessage.equals("0")) {
      //open door
      doorstatehci = 0;
    }
    else if (incomingMessage.equals("1")) {
      //close door
      doorstatehci = 1;
      Serial.println("Hiii");
    }
    else {
      doorstatehci = 2;
    }
  }
  //Override system
  else if (strcmp(topic, overridetop) == 0) {
    if (incomingMessage.equals("0")) {
      //override system
      overstatus = 0;
    }
    else if (incomingMessage.equals("1")) {
      //stop override
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
