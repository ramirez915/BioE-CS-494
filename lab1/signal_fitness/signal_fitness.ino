
#include <StopWatch.h>


//declare global variables:
const int age = 50;
StopWatch resp_timer; // default millis, timer for respiration
//StopWatch bpm_timer; //timer for bpm
//StopWatch thirtySec(StopWatch::SECONDS); //timer for 30 sec of baseline
long watchTime = 0;

double bpmbase = 0;
double respbase=0;
double bpm=0;
double r_rate;
long ex_t,in_t;
int c_r;

//update 3 data
double x0,x1,x2;

bool max_fp=false;
bool min_fp=true;
bool max_f=false;
bool min_f=false;
int baseline=0;

int it=0;

const int numReadings = 25;


int readings[numReadings];      // the readings from the analog input
int readIndex = 0;              // the index of the current reading
int total = 0;                  // the running total
int average = 0;                // the average

const double thr = 700;

int colorFlag;

int max_hrt_rate = 220 - age; //to find the max hear rate of the user based on age



//PINS:
//A3 is the respiratory signal input
int respPin = A3;



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




void max_min (){
  //if max
  if(x0<x1 && x2<x1){
    max_f=true;
    min_f=false;
    //Serial.println("max found");
    ex_in();
    break;
  }
    
  else if(x0>x1 && x2>x1) {
    min_f=true;
    max_f=false;
    //Serial.println("min found");
    ex_in();
    break;
  }
}



 //////////////////////////////////////////////////////////////////////////////////////////////


void ex_in (){

  if(max_f && min_fp){
    //found inhalation peak, record inhalation time
    in_t=resp_timer.elapsed();
    Serial.println("inhalation t:");
    Serial.println(in_t);
    resp_timer.reset();
    resp_timer.start();
    min_fp=false;
    max_fp=true;
    max_f=false;
    min_f=false;
  }
  
  else if(min_f && max_fp){
    //found exhalation min peak, record exhalation time
    ex_t=resp_timer.elapsed();
    Serial.println("inhalation t:");
    Serial.println(ex_t);
    resp_timer.reset();
//    resp_timer.start();
    min_fp=true;
    max_fp=false;
    max_f=false;
    min_f=false;

    //when found an exhalation peak it means a full breath is finished
//    c_r=c_r+1;

    r_rate= 60/(ex_t/1000 + in_t/1000);
    Serial.println("r_rate");
    Serial.println(r_rate);
    
  }
  
}


 
 //////////////////////////////////////////////////////////////////////////////////////////////



void acquire_signal() {

  
  // subtract the last reading:
  total = total - readings[readIndex];
  // read from the sensor:
  readings[readIndex] = analogRead(respPin)*10;
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
  //Serial.print("AVG ");
  //Serial.println(average);


//wait 10ms to smooth
  delay();

//Serial.println(resp_timer.elapsed());

  x2=x1;
  x1=x0;
  
  x0=average;
  
  max_min();
  
  //x_in();

//Serial.print("r_rate");


// //t_inhal, t_exhal acquired
// //r_rate computed
//


//  //heart rate acquisition
//  //check for signal acquisition
//  //pins are D11=LO- and D09=LO+
//
//  float seg;
//  float R_R;
//  
//  if((digitalRead(11) == 1)||(digitalRead(9) == 1)){
//    
//      Serial.println('!');
//  }
//
//  //if everything ok acquire the signal and check for treshold
//  else{
//
//    seg=analogRead(A0);
//
//    //check for threshold
//    if(seg>thr){
//
//      //R-peak detected, save time instant
//      //t must be current time
//      
//      R_R=float(bpm_timer.elapsed()/1000);
//      bpm_timer.reset();
//      bpm_timer.start();
//      //compute bpm as a frequency
//      bpm=R_R/float(60);
//
//  //Wait for a bit to keep serial data from saturating
// // delay(15);
//    }
//      
//  }

 }



//////////////////////////////////////////////////////


 //UNCOMMENT WHEN READY WHAT IS ACTIVITY ZONE?
void fitness() {
//start a general timer to keep track of the time
//stopwatch resolution is millis as default

 //thirtySec.start();
 resp_timer.start();
 //bpm_timer.start();


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
