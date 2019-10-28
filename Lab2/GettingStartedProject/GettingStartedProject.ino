
/*  PulseSensor Starter Project and Signal Tester
 *  The Best Way to Get Started  With, or See the Raw Signal of, your PulseSensor.com™ & Arduino.
 *
 *  Here is a link to the tutorial
 *  https://pulsesensor.com/pages/code-and-guide
 *
 *  WATCH ME (Tutorial Video):
 *  https://www.youtube.com/watch?v=RbB8NSRa5X4
 *
 *
-------------------------------------------------------------
1) This shows a live human Heartbeat Pulse.
2) Live visualization in Arduino's Cool "Serial Plotter".
3) Blink an LED on each Heartbeat.
4) This is the direct Pulse Sensor's Signal.
5) A great first-step in troubleshooting your circuit and connections.
6) "Human-readable" code that is newbie friendly."

*/


//  Variables
int PulseSensorPurplePin = 0;        // Pulse Sensor PURPLE WIRE connected to ANALOG PIN 0
int LED11 = 11;   //  The on-board Arduion LED


int Signal;                // holds the incoming raw data. Signal value can range from 0-1024
int thr = 600;            // Determine which Signal to "count as a beat", and which to ingore.


// The SetUp Function:
void setup() {
  pinMode(LED13,OUTPUT);         // pin that will blink to your heartbeat!
   Serial.begin(115200);         // Set's up Serial Communication at certain speed.

}


void acquire_signal() {

  //heart rate acquisition
  //check for signal acquisition
  //pins are D11=LO- and D09=LO+

  float seg;
  float R_R;
//
// 
//  // subtract the last reading:
//  total_bpm = total_bpm - readings_bpm[readIndex_bpm];
//  // read from the sensor:
//  readings_bpm[readIndex_bpm] = analogRead(A0);
//  /*Serial.print("analogueR: ");
//  Serial.println(analogRead(A0));
//  Serial.print("READS: ");
//  Serial.println(readings[readIndex_bpm]);
//  */
//  // add the reading to the total:
//  total_bpm = total_bpm + readings_bpm[readIndex_bpm];
//  // advance to the next position in the array:
//  readIndex_bpm = readIndex_bpm + 1;
//
//  // if we're at the end of the array...
//  if (readIndex_bpm >= numReadings_bpm) {
//    // ...wrap around to the beginning:
//    readIndex_bpm = 0;
//  }
//
//  // calculate the average:
//  average_bpm = total_bpm / numReadings_bpm;
//  //Serial.print("AVG ");
//   //Serial.println(average);
//
//seg=average_bpm;


//if(seg<thr) {
//
//  upper=0;
//}
//Serial.print("Segnal:");
//Serial.println(seg);
//Serial.print(" ");

   // seg=analogRead(A0);
//
 //Serial.println(seg);
    //check for threshold
   
//    if(seg>thr && upper==0){

seg=analogRead(PulseSensorPurplePin);
Serial.println(seg); 

if(seg>thr) {
       digitalWrite(LED11,HIGH);
       
       //R-peak detected, save time instant
      //t must be current time
      bpm_timer.stop();
      long bpmTimer = bpm_timer.value();
       R_R=bpmTimer;
     // R_R= (bpmTimer/float(10));
      //Serial.print("R_R:");
     //Serial.println(R_R);
      //Serial.print(" ");
      bpm_timer.reset();
      bpm_timer.start();
      //compute bpm as a frequency
      bpm=float(60)/(R_R/1000);
      serialOutputWhenBeatHappens();
    } 

    else{
      digitalWrite(LED,LOW); 
    }

send

    delay(30);
}













// The Main Loop Function
void loop() {



delay(10);


}
