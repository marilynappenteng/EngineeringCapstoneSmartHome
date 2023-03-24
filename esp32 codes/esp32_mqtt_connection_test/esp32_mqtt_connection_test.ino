#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <PubSubClient.h>

const char* ssid = "Galaxy A3 Core7828";
const char* password = "qfvy3253";

// Add your MQTT Broker IP address, example:
//const char* mqtt_server = "192.168.1.144";
const char* mqtt_server = "192.168.43.174";

WiFiClient espClient;
PubSubClient client(espClient);
unsigned long lastMsg = 0;
char msg[50];


const char* doormotortopic = "smarthome/devices/doormotor";


void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);            // initialize serial
  setup_wifi();
  client.setServer(mqtt_server, 1883);
  client.setCallback(callback);
}

void loop() {
  // put your main code here, to run repeatedly:
  if(!client.connected()) reconnect();
  client.loop();
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


void reconnect() {
  while(!client.connected()){
    Serial.print("Attempting MQTT connection...");
    String clientID = "ESP32DoorClient-";
    clientID += String(random(0xffff), HEX);
    Serial.println(clientID);
    if(client.connect(clientID.c_str())){
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


void callback(char* topic, byte* payload, unsigned int length){
  String incomingMessage="";
  for(int i=0; i< length; i++) {
    incomingMessage += (char)payload[i];
  }
  Serial.println("Message arrived [" + String(topic) + "]" + incomingMessage);
}
