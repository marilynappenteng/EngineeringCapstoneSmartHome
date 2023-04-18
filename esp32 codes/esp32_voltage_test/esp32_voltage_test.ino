// Define analog input
#define ANALOG_IN_PIN 34
 
// Floats for ADC voltage & Input voltage
float adc_voltage = 0.0;
float in_voltage = 0.0;
 
// Floats for resistor values in divider (in ohms)
float R1 = 30000.0;
float R2 = 7500.0; 
 
// Float for Reference Voltage
float ref_voltage = 5;
 
// Integer for ADC value
int adc_value = 0;
 
void setup()
{
   // Setup Serial Monitor
   Serial.begin(115200);
   Serial.println("DC Voltage Test");
   analogReadResolution(12);
}
 
void loop(){
   // Read the Analog Input
   adc_value = analogRead(ANALOG_IN_PIN);
   Serial.println(adc_value);
   // Determine voltage at ADC input
   adc_voltage  = (adc_value * ref_voltage) / 4095.0; 
   
   // Calculate voltage at divider input
//   in_voltage = adc_voltage / (R2/(R1+R2)) ; 
   in_voltage = (0.0039)*adc_value - 0.2;
   
   // Print results to Serial Monitor to 2 decimal places
  Serial.print("Input Voltage = ");
  Serial.println(in_voltage, 2);
  
  // Short delay
  delay(500);
}
