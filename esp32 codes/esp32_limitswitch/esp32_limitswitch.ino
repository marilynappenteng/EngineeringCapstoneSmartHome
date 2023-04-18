#include <ezButton.h>

ezButton limitSwitch(17);  // create ezButton object that attach to ESP32 pin GIOP17

void setup() {
  Serial.begin(115200);
  limitSwitch.setDebounceTime(50); // set debounce time to 50 milliseconds
}

void loop() {
  limitSwitch.loop(); // MUST call the loop() function first


  int state = limitSwitch.getState();
  if(state == HIGH)
    Serial.println("The limit switch: UNTOUCHED");
  else
    Serial.println("The limit switch: TOUCHED");
}
