#include <StopWatch.h>

#define PROCESSING_VISUALIZER 1
#define SERIAL_PLOTTER  2


StopWatch BPM_timer; //timer for bpm
//  Variables
int PulseSensorPurplePin = 0;        // Pulse Sensor PURPLE WIRE connected to ANALOG PIN 0
int LED11 = 11;   //  The on-board Arduion LED


int Signal;                // holds the incoming raw data. Signal value can range from 0-1024
int thr = 635;            // Determine which Signal to "count as a beat", and which to ingore.
volatile int BPM;
volatile int IBI=600;

static int outputType = PROCESSING_VISUALIZER;
//static int outputType = SERIAL_PLOTTER;



// The SetUp Function:
void setup() {
  pinMode(LED11,OUTPUT);         // pin that will blink to your heartbeat!
   Serial.begin(115200);         // Set's up Serial Communication at certain speed.

BPM_timer.start();
}


void acquire_signal() {

  //heart rate acquisition
  //check for signal acquisition
  //pins are D11=LO- and D09=LO+

//
// 
//  // subtract the last reading:
//  total_BPM = total_BPM - readings_BPM[readIndex_BPM];
//  // read from the sensor:
//  readings_BPM[readIndex_BPM] = analogRead(A0);
//  /*Serial.print("analogueR: ");
//  Serial.println(analogRead(A0));
//  Serial.print("READS: ");
//  Serial.println(readings[readIndex_BPM]);
//  */
//  // add the reading to the total:
//  total_BPM = total_BPM + readings_BPM[readIndex_BPM];
//  // advance to the next position in the array:
//  readIndex_BPM = readIndex_BPM + 1;
//
//  // if we're at the end of the array...
//  if (readIndex_BPM >= numReadings_BPM) {
//    // ...wrap around to the beginning:
//    readIndex_BPM = 0;
//  }
//
//  // calculate the average:
//  average_BPM = total_BPM / numReadings_BPM;
//  //Serial.print("AVG ");
//   //Serial.println(average);
//
//Signal=average_BPM;


//if(Signal<thr) {
//
//  upper=0;
//}
//Serial.print("Signalnal:");
//Serial.println(Signal);
//Serial.print(" ");

   // Signal=analogRead(A0);
//
 //Serial.println(Signal);
    //check for threshold
   
//    if(Signal>thr && upper==0){

Signal=analogRead(PulseSensorPurplePin);
//Serial.println(Signal); 

if(Signal>thr) {
       digitalWrite(LED11,HIGH);
       
       //R-peak detected, save time instant
      //t must be current time
      BPM_timer.stop();
      long BPMTimer = BPM_timer.value();
       IBI=BPMTimer;
     // IBI= (BPMTimer/float(10));
      //Serial.print("IBI:");
     //Serial.println(IBI);
      //Serial.print(" ");
      BPM_timer.reset();
      BPM_timer.start();
      //compute BPM as a frequency
      float ibif=float(IBI);
      
      float bpm=float(60)/(ibif/1000);
      BPM=int(bpm);

      if(BPM>150){
        BPM=63;
      }
      serialOutputWhenBeatHappens();
  
    } 

    else{
      digitalWrite(LED11,LOW); 
    }

    delay(30);
}













// The Main Loop Function
void loop() {
  
serialOutput();

acquire_signal();

delay(10);


}
