//This sketch reads a thermistor and calculates the correct temperature
//(Assuming the user input the correct constants!)
//It then sends this value over serial so other programs (Like Processing)
//Can log it/
//
//Written by Brandon Pomeroy
//
//Thermistor Equations lifted from SammyD: https://github.com/sammyd


#define baudRate 115200              //This should match what you have in Processing.

double POTENTIAL_DIVIDER_RESISTOR = 4700;   //4.7 kOhms  --Standard for RAMPs 1.4
double THERMISTOR_B_VALUE = 4267;           //Beta for  Semitec 104GT-2
double THERMISTOR_REF_TEMP = 298.15;        //25 C
double THERMISTOR_REF_RESISTANCE = 100000;  //100kOhm Thermistor


int thermistorPin = A13;            //T0 pin on RAMPs 1.4
int ledPin = 13;                    //Blinking status LED
int sensorDelay = 1000;              //How fast we take readings, in ms

void setup(){
  Serial.begin(baudRate);
  pinMode(ledPin, OUTPUT);
}

void loop() {
  double resistance;
  double temperature;
  
  resistance = findThermistorResistance();
  temperature = calculateTemp(resistance);
  //int therm = (int) temperature;
 // Serial.print("Thermistor Resistance: ");
//  Serial.println(resistance);
 // Serial.println();
 // Serial.print("Temperature (C): ");
  Serial.print(temperature - 272.15);
  
  //sendData(temperature);  //Sending our data over Serial
  
  blinkLed();
}


void sendData(double temp){
  int i = (int)temp;
  Serial.println(i);
//  Serial.flush();  // Make sure the data is all sent before we continue
}


double calculateTemp(double resistance){
  double temp;
  double t1 = (1/THERMISTOR_REF_TEMP);
  double t2 = resistance/THERMISTOR_REF_RESISTANCE;
  temp = 1 / (1/THERMISTOR_REF_TEMP + log(resistance / THERMISTOR_REF_RESISTANCE) / THERMISTOR_B_VALUE);
  return temp;
}



double findThermistorResistance(){
  double temp;
  double voltage;
  double resistance;
  
  temp = analogRead(thermistorPin);  //Read ADC Pin
 // Serial.print("ADC: ");
 // Serial.println(temp);
  voltage = temp / 1024 * 5;   //convert analog input to a voltage
 // Serial.print("Voltage: ");
 // Serial.println(voltage);
  resistance = POTENTIAL_DIVIDER_RESISTOR / (5 / voltage - 1);
  return resistance;
}


void blinkLed(){
  digitalWrite(ledPin, HIGH);     // turn the LED on (HIGH is the voltage level)
  delay(sensorDelay/2);       // wait for a second
  digitalWrite(ledPin, LOW);     // turn the LED off by making the voltage LOW
  delay(sensorDelay/2);       // wait for a second
}
