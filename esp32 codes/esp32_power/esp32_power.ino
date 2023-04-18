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

const int voltpin = 34; // GIOP34 pin connected to OUT pin of voltage sensor
const int currentpin = 35; // GIOP35 pin connected to OUT pin of current sensor
int voltage;
int current;

const int currentpin = 35;


//Current Variables
int   sampling = 500;

double mVperAmp = 66; // use 185 for 5A Module, 100 for 20A Module, and 66 for 30A Module

double RawValue = 0;
double V = 0;
double Vactual = 0;


//Voltage Variables
float adc_voltage = 0.0;
float in_voltage = 0.0;
// Floats for resistor values in divider (in ohms)
float R1 = 30000.0;
float R2 = 7500.0;

// Float for Reference Voltage
float ref_voltage = 5;

// Integer for ADC value
int adc_value = 0;


WiFiClient espClient;
PubSubClient client(espClient);
long lastMsg = 0;
char msg[50];


const char* voltage_topic = "smarthome/devices/voltage";
const char* current_topic = "smarthome/devices/current";

void TaskReadPower( void *pvParameters );

void setup() {
  Serial.begin(115200);            // initialize serial
  setup_wifi();


  client.setServer(mqtt_server, 1883);
  client.setCallback(callback);

  analogReadResolution(12);
  reconnect();

  xTaskCreatePinnedToCore(
    TaskReadPower
    ,  "Read Power"
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

void TaskReadPower( void *pvParameters )  // This is a task.
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
    for (int i = 0; i < sampling; i++)
    {
      RawValue += analogRead(currentpin);
      delay(1);
    }

    RawValue = RawValue / sampling;
    V = (RawValue / 4095.0) * 3300; // Gets you mV
    Vactual = 5.5 * V;
    current = (Vactual / mVperAmp);


    adc_value = analogRead(ANALOG_IN_PIN);

    // Determine voltage at ADC input
    adc_voltage  = (adc_value * ref_voltage) / 4095.0;

    // Calculate voltage at divider input
    voltage = (0.0039) * adc_value - 0.2;

    // Print results to Serial Monitor to 2 decimal places
    Serial.print("Input Voltage = ");
    Serial.println(voltage, 2);

    publishMessage(voltage_topic, String(voltage), true);
    publishMessage(current_topic, String(current), true);
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
    String clientID = "ESP32PowerClient-";
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
