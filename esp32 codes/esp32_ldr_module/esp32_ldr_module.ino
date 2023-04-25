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

#define ADC_REF_VOLTAGE 3.3
#define MAX_ADC_READING 4095
#define REF_RESISTANCE 20000



const int ldrpin1 = 34; // GIOP34 pin connected to D0 pin of ldr sensor 1
const int ldrpin2 = 35; // GIOP35 pin connected to D0 pin of ldr sensor 2
int lightstate = 1; //automatically off
float state1;
float state2;
float resistorVoltage1, resistorVoltage2, ldrVoltage1, ldrVoltage2, ldrResistance1, ldrResistance2;



WiFiClient espClient;
PubSubClient client(espClient);
long lastMsg = 0;
char msg[50];


const char* ldr1_topic = "smarthome/devices/ldr1";
const char* ldr2_topic = "smarthome/devices/ldr2";
const char* lightintensity = "smarthome/devices/lightintensity";

void TaskReadLight( void *pvParameters );

void setup() {
  Serial.begin(115200);            // initialize serial
  setup_wifi();
  client.setServer(mqtt_server, 1883);
  client.setCallback(callback);
  //  pinMode(ldrpin1, INPUT);
  //  pinMode(ldrpin2, INPUT);

  reconnect();

  xTaskCreatePinnedToCore(
    TaskReadLight
    ,  "Read Light Intensity"
    ,  4096  // Stack size
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

void TaskReadLight( void *pvParameters )  // This is a task.
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
    state1 = analogRead(ldrpin1);
    state2 = analogRead(ldrpin2);

    // MAX_ADC_READING is 4095 and ADC_REF_VOLTAGE is 3.3
    ldrVoltage1 = (float)state1 / MAX_ADC_READING * ADC_REF_VOLTAGE;
    ldrVoltage2 = (float)state2 / MAX_ADC_READING * ADC_REF_VOLTAGE;


    resistorVoltage1 = ADC_REF_VOLTAGE - ldrVoltage1;
    resistorVoltage2 = ADC_REF_VOLTAGE - ldrVoltage2;

    ldrResistance1 = ldrVoltage1 / resistorVoltage1 * REF_RESISTANCE; // REF_RESISTANCE is 20 kohm
    ldrResistance2 = ldrVoltage2 / resistorVoltage2 * REF_RESISTANCE; // REF_RESISTANCE is 20 kohm

    Serial.println(ldrResistance1);
    Serial.println(ldrResistance2);


    Serial.println("----------------");
    if (ldrResistance1 > 10000 && ldrResistance2 > 10000) {
      lightstate = 0;
      publishMessage(lightintensity, String(lightstate), true);
    }
    lightstate = 1;

    publishMessage(ldr1_topic, String(ldrResistance1), true);
    publishMessage(ldr2_topic, String(ldrResistance2), true);
    vTaskDelay(1000 / portTICK_PERIOD_MS); //checking light intensity every minute
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
    String clientID = "ESP32LDRClient-";
    clientID += String(random(0xffff), HEX);
    Serial.println(clientID);
    if (client.connect(clientID.c_str())) {
      Serial.println("Connected.");
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
}
