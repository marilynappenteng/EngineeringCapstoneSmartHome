// Include the Arduino Stepper Library
#include <Stepper.h>

// Number of steps per output rotation
const int stepsPerRevolution = 200;

// Create Instance of Stepper library
Stepper myStepper(stepsPerRevolution, 22, 23, 32, 33);


void setup()
{ myStepper.setSpeed(60);
  // initialize the serial port:
  Serial.begin(115200);

}

void loop()
{
  int i = 0;
  while (i < 10) {
    Serial.print("Rotation ");
    Serial.println(i);
    myStepper.step(stepsPerRevolution);
    i++;
  } //opening door

  int j = 0;
  while (j < 10) {
    Serial.print("Rotation ");
    Serial.println(j);
    myStepper.step(-stepsPerRevolution);
    j++;
  } //opening door
  delay(500);

}
