/* Learn how to use a potentiometer to fade an LED with Arduino - Tutorial
   More info and circuit schematic: http://www.ardumotive.com/arduino-tutorials/arduino-fade-led
   Dev: Michalis Vasilakis / Date: 25/10/2014                                                   */


//Constants:
const int ledPin = 13;  //pin 9 has PWM funtion
const int potPin = A0; //pin A0 to read analog input
const int L1 = A1;
const int L2 = A2;
const int L3 = A3;
const unsigned char PS_128 = (1 << ADPS2) | (1 << ADPS1) | (1 << ADPS0);

//Variables:
int value; //save analog value
boolean L1Val = 0;


void setup(){
  //Input or output?
  pinMode(ledPin, OUTPUT);
  pinMode(potPin, INPUT); //Optional
  // Serial.begin(9600);
  ADCSRA &= ~PS_128;
  ADCSRA |= (1 << ADPS1) | (1 << ADPS0);
  Serial.begin(115200);
  analogReference(INTERNAL);
  pinMode(L1, INPUT);
  pinMode(L2, INPUT);
  pinMode(L3, INPUT);

}

void loop(){

  value = analogRead(potPin);          //Read and save analog value from potentiometer
  value = map(value, 0, 1023, 0, 255); //Map value 0-1023 to 0-255 (PWM)
  Serial.println(value);
  analogWrite(ledPin, value);          //Send PWM value to led
  if ((analogRead(L1) > 200) && (L1Val == 0)) {
    L1Val = 1;
  }

  if ((L1Val == 1) && (analogRead(L2) > 200)) {
    Serial.println("Counter-clockwise");
    L1Val = 0;
    delay(100);
  }

  if ((L1Val == 1) && (analogRead(L3) > 200)) {
    Serial.println("Clockwise");
    L1Val = 0;
    delay(100);
  }

}
