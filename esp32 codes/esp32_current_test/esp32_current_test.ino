//Measuring Current Using ACS712

const int currentpin = 35;
int   sampling = 500;

double mVperAmp = 66; // use 185 for 5A Module, 100 for 20A Module, and 66 for 30A Module
float ACSoffset = 2500;

double RawValue = 0;
double V = 0;
double Amps = 0;
double Vactual = 0;

void setup() {
  // put your setup code here, to run once:
  // Setup Serial Monitor
  Serial.begin(115200);
  Serial.println("DC Current Test");
  analogReadResolution(12);
}

void loop() {

  for (int i = 0; i < sampling; i++)
  {
    RawValue += analogRead(currentpin);
    delay(1);
  }

  RawValue = RawValue / sampling;
  Serial.println("Reading:");
  Serial.println(RawValue);

  V = (RawValue / 4095.0) * 3300; // Gets you mV

  Vactual = 5.5 * V;
  Serial.println("Voltage:");
  Serial.println(Vactual);
  
  Amps = (Vactual / mVperAmp);
  Serial.println("Amps:");
  Serial.println(Amps);

  //  V = (RawValue / 4095.0) * 3300; // Gets you mV
  //  Vactual = V * (3/2);
  //  Serial.println(Vactual);
  //
  //  Amps = ((ACSoffset - Vactual) / mVperAmp);
  //
  //  Serial.print( "Amps:");
  //  Serial.println( Amps );

}
