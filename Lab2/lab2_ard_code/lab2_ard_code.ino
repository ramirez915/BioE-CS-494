#include <StopWatch.h>

#define PROCESSING_VISUALIZER 1
#define SERIAL_PLOTTER  2


StopWatch BPM_timer; //timer for bpm
//  Variables
int PulseSensorPurplePin = 0;        
int LED11 = 11;   


int Signal;                // Signal value can range from 0-1024
int thr = 635;          
volatile int BPM;
volatile int IBI=600;

static int outputType = PROCESSING_VISUALIZER;
//static int outputType = SERIAL_PLOTTER;



// The SetUp Function:
void setup() {
  pinMode(LED11,OUTPUT);          
   Serial.begin(115200);         

BPM_timer.start();
}


void acquire_signal() {

Signal=analogRead(PulseSensorPurplePin);


if(Signal>thr) {
       digitalWrite(LED11,HIGH);
       
      BPM_timer.stop();
      long BPMTimer = BPM_timer.value();
      IBI=BPMTimer;
      BPM_timer.reset();
      BPM_timer.start();
      //compute BPM as a frequency
      float ibif=float(IBI);
      float bpm=float(60)/(ibif/1000);
      if(bpm<200 && bpm>30){
      BPM=int(bpm);
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
