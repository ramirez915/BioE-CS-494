void setup() {
  // initialize the serial communication:
  Serial.begin(115200);
  pinMode(10, INPUT); // Setup for leads off detection LO +
  pinMode(11, INPUT); // Setup for leads off detection LO -
}

void loop() {
  if((digitalRead(10) == 0)&&(digitalRead(11) == 0)){
    Serial.println(analogRead(A0));
  }
  //Wait for a bit to keep serial data from saturating
  delay(15);
}
