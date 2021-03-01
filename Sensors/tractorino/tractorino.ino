
//Constants:
const int potPin = A0;
const int encoderL1 = A1;
const int encoderL2 = A2;
const int encoderL3 = A3;
const unsigned char PS_128 = (1 << ADPS2) | (1 << ADPS1) | (1 << ADPS0);

//Variables:
int inByte = 0;
int potValue = 0;
int lastPotValue;
int encoderValue = 0;
int encoderDirection = 0;
boolean L1Val = 0;

void setup(){
  Serial.begin(9600);
  ADCSRA &= ~PS_128;
  ADCSRA |= (1 << ADPS1) | (1 << ADPS0);
  analogReference(INTERNAL);
  pinMode(potPin, INPUT);
  pinMode(encoderL1, INPUT);
  pinMode(encoderL2, INPUT);
  pinMode(encoderL3, INPUT);
  establishContact();
}

void loop() {
  // if (Serial.available() > 0) {
  //   inByte = Serial.read();
    lastPotValue = potValue;
    potValue = analogRead(potPin);
    potValue = map(potValue, 0, 1023, 0, 255);
    // encoderValue = analogRead(encoderL1);
    //
    // if ((encoderValue > 200) && (L1Val == 0)) {
    //   L1Val = 1;
    //   delay(100);
    //   // Serial.write(analogRead(encoderL1));
    //   // Serial.write(analogRead(encoderL2));
    //   // Serial.write(analogRead(encoderL3));
    // }
    // if ((L1Val == 1) && (analogRead(encoderL2) > 200)) {
    //   // Serial.println("Counter-Clockwise");
    //   encoderDirection = 1;
    //   L1Val = 0;
    //   delay(100);
    // }
    // if ((L1Val == 1) && (analogRead(encoderL3) > 200)) {
    //   // Serial.println("Clockwise");
    //   encoderDirection = 0;
    //   L1Val = 0;
    //   delay(100);
    // }
    // Serial.write(potValue);
    // Serial.write(encoderValue);
    // Serial.println(encoderDirection);
  // }
  // Serial.print(analogRead(encoderL1));
  // Serial.print("\t");
  // Serial.print(analogRead(encoderL2));
  // Serial.print("\t");
  // Serial.println(analogRead(encoderL3));
  if (potValue != lastPotValue) {
    Serial.write(potValue);
  }
}

void establishContact() {
  while (Serial.available() <= 0) {
    Serial.write('A');
    delay(300);
  }
}
