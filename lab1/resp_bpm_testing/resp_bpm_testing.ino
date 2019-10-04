#include <StopWatch.h>


//declare global variables:
StopWatch resp_timer; // default millis, timer for respiration
StopWatch bpm_timer; //timer for bpm
StopWatch thirtySec(StopWatch::SECONDS); //timer for 30 sec of baseline
long watchTime = 0;

int baseline=0;
int it=0;
int interv=50;
int upper=0;
const int age = 50;

double bpmbase = 0;
double respbase=0;

float bpm;

double r_rate;
float ex_t,in_t;
//int c_r;


bool maxf=false;
bool minf=true;


float s1=0;
float s2=0;

//rr:
//numreading 40 is the best
const int numReadings_rr= 40;
int readings_rr[numReadings_rr]; 
int readIndex_rr= 0;  
int total_rr = 0;                  // the running total
float average_rr = 0;                // the average
//10 ms is the best waiting time
//int wait_rr=10; //millis for delay in 
//gain 10 is the best
int gain_rr=10;
//int gap=150;


//bpm:
const int numReadings_bpm = 2;
int readings_bpm[numReadings_bpm];      // the readings from the analog input
                              // the index of the current reading
int readIndex_bpm = 0;
int total_bpm = 0;                  // the running total
float average_bpm=0;             // the average

const double thr = 650;


int colorFlag;

int max_hrt_rate = 220 - age; //to find the max hear rate of the user based on age


//PINS:
//A3 is the respiratory signal input
int respPin = A3;


//variables for testing with sinousoid:
//int j=0;
//float x=0;


//////////////////////////////////////////////////////////////////////////////////////////////

 
 
 
 
 
// 
// void gen_sin () {
//
//  x=10*((sin(j*0.0174533)+1));
//  j=j+1;
//  
//  if(j==360) {
//    j=0;
//  }
//
//  //Serial.println(x);
//  //Serial.print(" ");
//}

void acquire_signal() {
  
  // subtract the last reading:
  total_rr = total_rr - readings_rr[readIndex_rr];
  // read from the sensor:
  readings_rr[readIndex_rr] = analogRead(respPin)*gain_rr;
    //x is a sin wave to test;
 // readings_rr[readIndex_rr] = x;
  // add the reading to the total:
  total_rr = total_rr + readings_rr[readIndex_rr];
  // advance to the next position in the array:
  readIndex_rr = readIndex_rr + 1;

  // if we're at the end of the array...
  if (readIndex_rr >= numReadings_rr) {
    // ...wrap around to the beginning:
    readIndex_rr = 0;
  }

  // calculate the average:
  average_rr = total_rr / numReadings_rr;

  Serial.println(average_rr);


    s2=s1;
    //sec.elapsed()*
    s1=average_rr;
    //Serial.println(s1);
   // Serial.print(" ");
    if(s1-s2<0 && minf==true) {
      
      maxf=true;
      minf=false;

      in_t=resp_timer.elapsed();

      //Serial.println(in_t);
      //Serial.print(" ");
      resp_timer.reset();
      resp_timer.start();
      }
      
     if(s1-s2>0 && maxf==true) {
      minf=true;
      maxf=false;
      ex_t=resp_timer.elapsed();
      //Serial.println(ex_t);
     // Serial.print(" ");
      resp_timer.reset();
      resp_timer.start();
      float breath=(ex_t+in_t)/1000.00;
      r_rate=60.00/breath;
      //Serial.println(R_R);
     }






  //heart rate acquisition
  //check for signal acquisition
  //pins are D11=LO- and D09=LO+

  float seg;
  float R_R;
  
  if((digitalRead(11) == 1)||(digitalRead(9) == 1)){
    Serial.println('!');
  }

  //if everything ok acquire the signal and check for treshold
  
  else{
  
  // subtract the last reading:
  total_bpm = total_bpm - readings_bpm[readIndex_bpm];
  // read from the sensor:
  readings_bpm[readIndex_bpm] = analogRead(A0);
  /*Serial.print("analogueR: ");
  Serial.println(analogRead(A0));
  Serial.print("READS: ");
  Serial.println(readings[readIndex_bpm]);
  */
  // add the reading to the total:
  total_bpm = total_bpm + readings_bpm[readIndex_bpm];
  // advance to the next position in the array:
  readIndex_bpm = readIndex_bpm + 1;

  // if we're at the end of the array...
  if (readIndex_bpm >= numReadings_bpm) {
    // ...wrap around to the beginning:
    readIndex_bpm = 0;
  }

  // calculate the average:
  average_bpm = total_bpm / numReadings_bpm;
  //Serial.print("AVG ");
   //Serial.println(average_bpm);

seg=average_bpm;

if(seg<thr) {

  upper=0;
}
//Serial.print("Segnal:");
//Serial.println(seg);
//Serial.print(" ");

   // seg=analogRead(A0);
//
 //Serial.println(seg);
    //check for threshold
//   
    if(seg>thr && upper==0){
      upper=1;
      //R-peak detected, save time instant
      //t must be current time
      bpm_timer.stop();
      float bpmTimer = bpm_timer.value();
      R_R=bpmTimer;
     // R_R= (bpmTimer/float(10));
      //Serial.print("R_R:");
      //Serial.println(R_R);
      //Serial.print(" ");
      bpm_timer.reset();
      bpm_timer.start();
      //compute bpm as a frequency
      bpm=float(60)/(R_R/1000);
    }   // end of thr
 }    // end of else
 //30 bpm is good
 delay(interv);
}


void set_readings () {
  

    for (int thisReading = 0; thisReading < numReadings_rr; thisReading++) {
    readings_rr[thisReading] = 0;
    }
    
    for (int thisReading = 0; thisReading < numReadings_bpm; thisReading++) {
    readings_bpm[thisReading] = 0;
    }

}

void setup() {
  // initialize the serial communication:
  Serial.begin(115200);
  pinMode(10, INPUT); // Setup for leads off detection LO +
  pinMode(11, INPUT); // Setup for leads off detection LO -
  set_readings();
  bpm_timer.start();
  resp_timer.start();
}

void loop() {

      acquire_signal();
        Serial.println(r_rate);
//      Serial.print(" ");
        //Serial.println("bpm");
//        Serial.println(bpm);
//      Serial.print(" ");

}
