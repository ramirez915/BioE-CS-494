
#include <StopWatch.h>


//declare global variables:
const int age = 50;
StopWatch resp_timer; // default millis, timer for respiration
StopWatch bpm_timer; //timer for bpm
//StopWatch thirtySec(StopWatch::SECONDS); //timer for 30 sec of baseline
long watchTime = 0;

double bpmbase = 0;
double respbase=0;
float bpm;
double r_rate;
long ex_t,in_t;
int c_r;

//update 3 data
double x0=0;
double x1=0;
double x2=0;

double s1=0;
double s2=0;

bool max_fp=false;
bool min_fp=true;
bool maxf=false;
bool minf=false;
int baseline=0;

int it=0;


float R_R;


//numreading 40 is the best
const int numReadings = 50;
const int numReadings_bpm = 5;
//10 ms is the best waiting time
int wait=10; //millis for delay in 
//gain 10 is the best
int gain=100;
int gap=150;




int readings[numReadings];      // the readings from the analog input
int readIndex = 0;              // the index of the current reading
int readIndex_bpm = 0;
int total = 0;                  // the running total
int average = 0;                // the average

float average_bpm;
const float thr = 800;

int colorFlag;

int max_hrt_rate = 220 - age; //to find the max hear rate of the user based on age



//PINS:
//A3 is the respiratory signal input
int respPin = A3;

// for finding the max and min for respiration
int absMax = -1000000;
int absMin = 1000000;



////////////////////////////////////////////////

//
//int getBaseLine(){
//
//     
//    if(thirtySec.elapsed()< 30){
//    
//      Serial.println("NOT 30 YET");
//      // keep adding to total heart rate to later get avg
//
////      acquire_signals();
//      
//      it=it+1;
//      bpmbase = bpmbase + bpm;
//      respbase = respbase + r_rate;
//
//    }
//      
//      if(thirtySec.elapsed() == 30){
//
//        // get avg heart rate here
//        
//       bpmbase = bpmbase / it;
//       respbase=respbase/it;
//
//       //set baseline=0
//
//       it=0;
//       baseline=0;
//       
//        Serial.println("30! baseline computed");
// 
//      }
//      
//}


//////////////////////////////////////////////


void setup() {
  // initialize the serial communication:
  Serial.begin(115200);
  pinMode(9, INPUT); // Setup for leads off detection LO +
  pinMode(11, INPUT); // Setup for leads off detection LO -
 for (int thisReading = 0; thisReading < numReadings; thisReading++) {
    readings[thisReading] = 0;
}
}




void loop() {
  
      fitness();
      baseline=1;
  //Serial.println(analogRead(respPin));
  //delay(15);

}
//////////////////////////////////////////////////////////////////////////////////////////////




//void max_min (){
//  //if max
//  if(x1-x2>gap && x1-x0>gap){
//    max_f=true;
//    min_f=false;
//    Serial.println("max found");
//    ex_in();
//  }
//    
//  if(x0-x1>gap && x2-x1>gap) {
//    min_f=true;
//    max_f=false;
//    Serial.println("min found");
//    ex_in();
//  }
//}



 //////////////////////////////////////////////////////////////////////////////////////////////

//
//void ex_in (){
//
//  if(max_f && min_fp){
//    //found inhalation peak, record inhalation time
//    in_t=resp_timer.elapsed();
//    //Serial.println("inhalation t:");
//    //Serial.println(in_t);
//    resp_timer.reset();
// //   resp_timer.start();
//    min_fp=false;
//    max_fp=true;
//    max_f=false;
//    min_f=false;
//  }
//  
//  if(min_f && max_fp){
//    //found exhalation min peak, record exhalation time
//    ex_t=resp_timer.elapsed();
//   // Serial.println("inhalation t:");
//    //Serial.println(ex_t);
//    resp_timer.reset();
//  //  resp_timer.start();
//    min_fp=true;
//    max_fp=false;
//    max_f=false;
//    min_f=false;
//
//    //when found an exhalation peak it means a full breath is finished
////    c_r=c_r+1;
//
//    r_rate= 60/(ex_t/1000 + in_t/1000);
//   // Serial.println("r_rate");
//    Serial.println(r_rate);
//    
//  }
//  
//}


 
 //////////////////////////////////////////////////////////////////////////////////////////////


void acquire_signal() {

  
 // subtract the last reading:
  total = total - readings[readIndex];
  // read from the sensor:
  readings[readIndex] = analogRead(respPin)*gain;
  /*Serial.print("analogueR: ");
  Serial.println(analogRead(respPin));
  Serial.print("READS: ");
  Serial.println(readings[readIndex]);
  */
  // add the reading to the total:
  total = total + readings[readIndex];
  // advance to the next position in the array:
  readIndex = readIndex + 1;

  // if we're at the end of the array...
  if (readIndex >= numReadings) {
    // ...wrap around to the beginning:
    readIndex = 0;
  }

  // calculate the average:
  average = total / numReadings;
  
//Serial.print();  // To freeze the lower limit
//Serial.print(" ");
Serial.print(0);  // To freeze the upper limit
Serial.print(" ");
 //To send all three 'data' points to the plotter
 Serial.println(average);
 Serial.print(" ");
 


//wait 10ms to smooth
  delay(wait);

//Serial.println(resp_timer.elapsed());
//
//  // finding max
//  if(average > absMax){
//    absMax = average;
//    Serial.println("found new max***********");
//  }
//  // find min
//  else if(average < absMin){
//    absMin = average;
//    Serial.println("********** found new min");
//  }
//
//  // check if we are exhaling
//  if(absMax > average){
//    Serial.println("EXHALING");
//    // stop inhaling timer
//    // start exhaling timer    
//  }
//  // else we are inhaling
//  else if(absMin < average){
//    Serial.println("INHALING");
//    // stop exhaling timer
//    // start inhaling timer
//    delay(500);
//  }
//
//  x2=x1;
//  x1=x0;
//  
//  x0=average;
//  


     s2=s1;
    //sec.elapsed()*
    s1=average;
    //Serial.println(s1);
   // Serial.print(" ");
    if(s1-s2<0 && minf==true) {
      
      maxf=true;
      minf=false;
      float in_t=resp_timer.elapsed();
      //Serial.println(in_t);
      //Serial.print(" ");
      resp_timer.reset();
      resp_timer.start();
      }
      
     if(s1-s2>0 && maxf==true) {
      minf=true;
      maxf=false;
      float ex_t=resp_timer.elapsed();
      //Serial.println(ex_t);
     // Serial.print(" ");
      resp_timer.reset();
      resp_timer.start();
      float breath=(ex_t+in_t)/1000.00;
      float rr=60.00/breath;
      Serial.println(rr);

     }






//  max_min();
//  
//x_in();

//Serial.print("r_rate");


// //t_inhal, t_exhal acquired
// //r_rate computed
//










  //heart rate acquisition
  //check for signal acquisition
  //pins are D11=LO- and D09=LO+

//  float seg;
//  float R_R;
//  
//  if((digitalRead(11) == 1)||(digitalRead(9) == 1)){
//    
//      Serial.println('!');
//  }

  //if everything ok acquire the signal and check for treshold
  
//  else{
//  
//  // subtract the last reading:
//  total = total - readings[readIndex_bpm];
//  // read from the sensor:
//  readings[readIndex_bpm] = analogRead(A0);
//  /*Serial.print("analogueR: ");
//  Serial.println(analogRead(A0));
//  Serial.print("READS: ");
//  Serial.println(readings[readIndex_bpm]);
//  */
//  // add the reading to the total:
//  total = total + readings[readIndex_bpm];
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
//  average_bpm = total / numReadings_bpm;
//  //Serial.print("AVG ");
//   //Serial.println(average);
//
//seg=average_bpm;
////Serial.print("Segnal:");
//Serial.println(seg);
////Serial.print(" ");
//
//    seg=analogRead(A0);
////
// //Serial.println(seg);
//    //check for threshold
//    if(seg>thr){
//
//      //R-peak detected, save time instant
//      //t must be current time
//      bpm_timer.stop();
//      long bpmTimer = bpm_timer.value();
//       R_R=bpmTimer;
//     // R_R= (bpmTimer/float(10));
//      //Serial.print("R_R:");
//     //Serial.println(R_R);
//      //Serial.print(" ");
//      bpm_timer.reset();
//      bpm_timer.start();
//      //compute bpm as a frequency
//      bpm=float(60)/(R_R/1000);
//     // Serial.print("bpm:");
//      Serial.println(bpm);    //*2 gives a more reasonable bpm
////Wait for a bit to keep serial data from saturating
//      delay(30);
//    }
//      
// }

}



//////////////////////////////////////////////////////


 //UNCOMMENT WHEN READY WHAT IS ACTIVITY ZONE?
void fitness() {
//start a general timer to keep track of the time
//stopwatch resolution is millis as default

 //thirtySec.start();
 resp_timer.start();
 bpm_timer.start();


//initialiaze variable of fitness function:

  // a character is the escape button from the gui
  while(Serial.read() != 'a') {


    acquire_signal();

    //Serial.println(bpm);
    //Serial.println(r_rate);

    //delay(15);
 
 }
}





///////////////////////////////////////////////////////////////
