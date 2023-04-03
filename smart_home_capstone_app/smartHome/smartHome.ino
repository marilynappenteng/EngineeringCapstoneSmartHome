#include <WiFi.h>
#include <WiFiClient.h>
#include <WebServer.h>
#include <ESPmDNS.h>
#include <HTTPClient.h>
#include "DHT.h"

#define USE_SERIAL Serial

#define DHTPIN 32
#define DHTTYPE DHT22
DHT dht(DHTPIN, DHTTYPE);

int led = 27;
int state = 1;

float h;


const char* ssid = "MiFi_1FBE89";
const char* password = "12345678";
WebServer server(80);


void handleNotFound() {
  String message = "File Not Found\n\n";
  message += "URI: ";
  message += server.uri();
  message += "\nMethod: ";
  message += (server.method() == HTTP_GET) ? "GET" : "POST";
  message += "\nArguments: ";
  message += server.args();
  message += "\n";
  for (uint8_t i = 0; i < server.args(); i++) {
    message += " " + server.argName(i) + ": " + server.arg(i) + "\n";
  }
  server.send(404, "text/plain", message);
}

void startAC() {
  state = 0;
}

void stopAC() {
  state = 1;
}

void readHumidity() {
  server.send(200, "text/plain", String(h));
}

void setup() {
  // put your setup code here, to run once:
  pinMode(led, OUTPUT);
  Serial.begin(115200);
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
  Serial.println("");

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.print("Connected to ");
  Serial.println(ssid);
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());

  if (MDNS.begin("esp32")) {
    Serial.println("MDNS responder started");
  }

  server.on("/StartAC", startAC);
  server.on("/StopAC", stopAC);
  server.on("/readhumidity", readHumidity);
  server.onNotFound(handleNotFound);

  server.begin();
  Serial.println("HTTP server started");
}

void loop() {
  // put your main code here, to run repeatedly:
  server.handleClient();

  if (state == 0) {
    digitalWrite(led, HIGH);
  } else if (state == 1) {
    digitalWrite(led, LOW);
  }

  h = dht.readHumidity();
  Serial.print(F("Humidity: "));
  Serial.println(h);
}
