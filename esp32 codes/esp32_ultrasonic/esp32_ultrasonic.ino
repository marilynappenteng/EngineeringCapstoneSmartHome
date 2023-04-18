#include <Stepper.h>
#include <ezButton.h>

#define SOUND_SPEED 0.034
#define CM_TO_INCH 0.393701


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
int state;

const int steps_per_rev = 200; //Set to 200 for NEMA 17


long duration1;
float distance1Cm;
long duration2;
float distance2Cm;

ezButton limitSwitch(17);  // create ezButton object that attach to ESP32 pin GPIO17
Stepper motor(steps_per_rev, doormotor1, doormotor2, doormotor3, doormotor4);

void setup() {
  // put your setup code here, to run once:
  motor.setSpeed(60);
  Serial.begin(115200);            // initialize serial

  pinMode(door1us1trig, OUTPUT); // set ESP32 pin to output mode to read value from OUTPUT pin of sensor
  pinMode(door1us1echo, INPUT);
  pinMode(door1us2trig, OUTPUT);
  pinMode(door1us2echo, INPUT);
  pinMode(lock, OUTPUT);


  digitalWrite(lock, HIGH);

  limitSwitch.setDebounceTime(50); // set debounce time to 50 milliseconds

  state = limitSwitch.getState();
}

void loop() {       checkLimitSwitch();
  // put your main code here, to run repeatedly:
          Serial.println("Trigger start");
        digitalWrite(door1us1trig, LOW);
        delayMicroseconds(2);
        // Sets the trigPin on HIGH state for 10 micro seconds
        digitalWrite(door1us1trig, HIGH);
        delayMicroseconds(10);
        digitalWrite(door1us1trig, LOW);


        Serial.println("Trigger done");
        // Reads the echoPin, returns the sound wave travel time in microseconds
        duration1 = pulseIn(door1us1echo, HIGH);
        Serial.println("Echo");


        // Calculate the distance
        distance1Cm = (duration1 * SOUND_SPEED)/2;
        
        Serial.println(duration1);
        
        digitalWrite(door1us2trig, LOW);
        delayMicroseconds(2);
        digitalWrite(door1us2trig, HIGH);
        delayMicroseconds(10);
        digitalWrite(door1us2trig, LOW);

        duration2 = pulseIn(door1us2echo, HIGH);
        distance2Cm = (duration2 * SOUND_SPEED)/2;

        Serial.println(duration2);

        if(distance1Cm < 100 && distance2Cm < 100) {

          digitalWrite(door1us1trig, LOW);
          delayMicroseconds(2);
          // Sets the trigPin on HIGH state for 10 micro seconds
          digitalWrite(door1us1trig, HIGH);
          delayMicroseconds(10);
          digitalWrite(door1us1trig, LOW);
          
          // Reads the echoPin, returns the sound wave travel time in microseconds
          duration1 = pulseIn(door1us1echo, HIGH);
          
  
  
          // Calculate the distance
          distance1Cm = (duration1 * SOUND_SPEED)/2;
          
  
          digitalWrite(door1us2trig, LOW);
          delayMicroseconds(2);
          digitalWrite(door1us2trig, HIGH);
          delayMicroseconds(10);
          digitalWrite(door1us2trig, LOW);
  
          duration2 = pulseIn(door1us2echo, HIGH);
          distance2Cm = (duration2 * SOUND_SPEED)/2;
 
          
          if(distance1Cm < 80 && distance2Cm < 80 && state = LOW) {
                      //open door
              digitalWrite(lock, LOW);          
              
              int i = 0;
              while(i < 10) {
                motor.step(-steps_per_rev);
                i++;
              } //opening door
              
              //close door code (reverse direction)
              state = limitSwitch.getState();
              Serial.println(state);
              while(state == HIGH) {
                state = limitSwitch.getState();
                motor.step(steps_per_rev);
              }
              //when it touches the frame
              digitalWrite(lock, HIGH);
              doorstatesensor = 2;
          }
          else {
            doorstatesensor = 2;
          }  
        }
        else{
          doorstatesensor = 2;
        }
      state = limitSwitch.getState();
        delay(500);
      }


void checkLimitSwitch(){
  state = limitSwitch.getState();
  while(state == HIGH) {
    state = limitSwitch.getState();

  }
}
