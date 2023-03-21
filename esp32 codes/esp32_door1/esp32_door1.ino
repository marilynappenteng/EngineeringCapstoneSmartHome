/*
 * This ESP32 code is created by esp32io.com
 *
 * This ESP32 code is released in the public domain
 *
 * For more detail (instruction and wiring diagram), visit https://esp32io.com/tutorials/esp32-motion-sensor
 */

const int pir1 = 19; // GIOP19 pin connected to OUTPUT pin of pir sensor1
const int pir2 = 22; // GIOP22 pin connected to OUTPUT pin of pir sensor2
const int pir1 = 23; // GIOP23 pin connected to OUTPUT pin of pir sensor3
int door = 18; //GPIO18 pin connected to IN2 for door relay

void setup() {
  Serial.begin(9600);            // initialize serial
  pinMode(pir1, INPUT); // set ESP32 pin to input mode to read value from OUTPUT pin of sensor
  pinMode(pir2, INPUT);
  pinMode(pir3, INPUT);
  pinMode(door, OUTPUT);
}

void loop() {
  pirstate1 = digitalRead(pir1);   // check for motion
  pirstate2 = digitalRead(pir2);   
  pirstate3 = digitalRead(pir3);

  Serial.println(pirstate1);
  Serial.println(pirstate2);
  Serial.println(pirstate3);

  if (pirstate1 == HIGH && pirstate2 == HIGH && pirstate3 = HIGH) {
    Serial.println("Motion detected!");
    delay(2000);
    pirstate1 = digitalRead(pir1);   // check for motion
    pirstate2 = digitalRead(pir2);   
    pirstate3 = digitalRead(pir3);

    if (pirstate1 == HIGH && pirstate2 == HIGH && pirstate3 = HIGH) {
    Serial.println("Open door!");
    digitalWrite(door, 0);
    
    } 
  }

}
