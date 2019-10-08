#include <StopWatch.h>

//declare global variables:
StopWatch resp_timer; // default millis, timer for respiration
StopWatch bpm_timer; //timer for bpm
StopWatch thirtySec(StopWatch::SECONDS); //timer for 30 sec of baseline
long watchTime = 0;
int upper=0;
int baseline=0;
int it=0;
int interv = 30;
int not_med=0;

const int age = 50;

float bpmbase = 0;
float respbase=0;

float bpm = 0;

float r_rate = 0;
float ex_t,in_t = 0;
//int c_r;


bool maxf=false;
bool minf=true;


float s1=0;
float s2=0;

//rr:
//numreading 40 is the best
const int numReadings_rr= 50;
int readings_rr[numReadings_rr]; 
int readIndex_rr= 0;  
float total_rr = 0;                  // the running total
float average_rr = 0;                // the average
//10 ms is the best waiting time
//int wait_rr=10; //millis for delay in 
//gain 10 is the best
float gain_rr=100;  // was int
//int gap=150;


//bpm:
const int numReadings_bpm = 5;
int readings_bpm[numReadings_bpm];      // the readings from the analog input
                              // the index of the current reading
int readIndex_bpm = 0;
float total_bpm = 0;                  // the running total
float average_bpm=0;             // the average

float thr = 0;    // was 800

int colorFlag = 1;

float max_hrt_rate = 220 - age; //to find the max hear rate of the user based on age


//PINS:
//A3 is the respiratory signal input
int respPin = A3;



// testing variables
float ecgRead = 0;        // reading from ecg
int maxBpmCounter = 0;      // will be used to determine the max bpm

//////////////////////////////////////////////////////////////////////////////////////////////

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

  //Serial.println(average_rr);


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
//    Serial.println('!');
  }

  //if everything ok acquire the signal and check for treshold
  
  else{
  
  // subtract the last reading:
  total_bpm = total_bpm - readings_bpm[readIndex_bpm];
  // read from the sensor:
  
  ecgRead = analogRead(A0);          // added to send this value to processing********************
  readings_bpm[readIndex_bpm] = ecgRead; //analogRead(A0);
  /*Serial.print("analogueR: ");
  Serial.println(analogRead(A0));
  Serial.print("READS: ");
  Serial.println(readings[readIndex_bpm]);
  */
  // check for the higest peak to make threshold
  // 250 seems like a good amount of reading to look through
  if(maxBpmCounter < 250){
    if(ecgRead > thr){
      // filtering out outliers
      if(ecgRead < 650){
        thr = ecgRead;
//        Serial.print("new thr ");
//        Serial.println(thr);
      }
    }
    maxBpmCounter++;
  }
  
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
//    Serial.print("Segnal:");
//    Serial.println(seg);
//    Serial.print(" thr ");
//    Serial.println(thr);

    //check for threshold
    if(seg>thr && upper==0){
//      Serial.println("********************************************* SEG > THR");
//      Serial.print("seg ");
//      Serial.print(seg);
//      Serial.print(" thr ");
//      Serial.println(thr);
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
      upper = 1;
    }
 }
 delay(interv);
} // end of function

///////////////////////////////////////////////////////

int getBaseLine(){
    if(thirtySec.elapsed()< 30){
//      Serial.println("NOT 30 YET");
      // keep adding to total heart rate to later get avg
      
      it=it+1;
      bpmbase = bpmbase + bpm;
      respbase = respbase + r_rate;
    }
    // get avg heart rate here
    if(thirtySec.elapsed() == 30){
     bpmbase = bpmbase / it;
     respbase=respbase/it;
     
     //set baseline=0

     it=0;
     baseline=0;
//     Serial.println("30! baseline computed");
    }
}

//////////////////////////////////////////////
void set_readings () {
    for (int thisReading = 0; thisReading < numReadings_rr; thisReading++) {
      readings_rr[thisReading] = 0;
    }
    
    for (int thisReading = 0; thisReading < numReadings_bpm; thisReading++) {
      readings_bpm[thisReading] = 0;
    }
}

//////////////////////////////////////////////////////

 void stress_monitoring(){

  //baseline already computed

  //music:
  //switch a flag variable called music=1;
  //we play the music after the baseline, measure the heart rate average and respiration rate average during music_flag=1
  //we measure music duration through a timer or we make the music_flag=0 from processing
  //after music is ended compare the baseline with the avrage heart and respiration rate
  //display on processing the difference between the 2, and say if the person is stressed or not

  //hard task
  ////we play an hard task, measure the heart rate average and respiration rate average during play_flag=1
  //measure the time of playing wirth a timer
  //after play is ended compare the baseline with the avrage heart and respiration rate acquired
  //display on processing the difference between the 2, and say if the person is stressed or not
  
 }

//////////////////////////////////////////////////////
 void breathPattern(){
    int count = 0;

    if (ex_t < 3*in_t) {
    not_med++;

    if(not_med==3) {
      buzzer();
      not_med=0;
    }
    }

 }

    

//////////////////////////////////////////////////////
   
  // sounds the buzzer assuming the buzzer is connected to pin 2
 void buzzer (){
  tone(2,1000);
  delay(10);
  noTone(2);
}

//////////////////////////////////////////////////////

// function that sends over the data to processing once it is all collected
//----------------------------------------------------------------------------------------- mode-color-ecg-resp-bpm-rRate
void sendData(int mode, int colorFlag, float ecgReading, float respReading, float bpmVal, float rRateVal){
  Serial.print(mode);
  Serial.print("-");
  Serial.print(colorFlag);
  Serial.print("-");
  Serial.print(ecgReading);
  Serial.print("-");
  Serial.print(respReading);
  Serial.print("-");
  Serial.print(bpmVal);
  Serial.print("-");
  Serial.println(rRateVal);
}

//////////////////////////////////////////////////////


// exits the current mode so sends that information to processing
// may need to add in here any other additional things we need to reset
void exitMode(){
  Serial.println("0-0-0-0-0-0");

  // STOP WATCHES HERE
  thirtySec.stop();
  resp_timer.stop();
  bpm_timer.stop();

  maxBpmCounter = 0;
  thr = 0;
  average_rr = 0;
  total_rr = 0;
}

 //////////////////////////////////////////////////////

void meditation() {

////start a general timer to keep track of the time
//stopwatch resolution is millis as default

 thirtySec.start();
 resp_timer.start();
 bpm_timer.start();


//initialiaze variable of fitness function:

  // a character is the escape button from the gui
  while(Serial.read() != 'a') {

    acquire_signal();

   // Serial.println(bpm);
    //Serial.println(r_rate);

    //if baseline state
    if (baseline==1){
      getBaseLine();
    }
    //else it's meditation state
    else{
      breathPattern();   
    }
 }

 }


/////////////////////////////////////////////////////

void fitness() {

  /*  In this function:
   *  
   *  plot baseline heart rate and respiratory (inhalation/exhalation) rates
   *  plot color-coded activity graphs and display activity zones
   *  user performs activity:
   *  display updated graphs, activity zones, respiratory rates
   */
//start a general timer to keep track of the time
//stopwatch resolution is millis as default

 thirtySec.start();
 resp_timer.start();
 bpm_timer.start();

//initialiaze variable of fitness function:

  // a character is the escape button from the gui
  while(Serial.read() != 'a') {

    acquire_signal();

    //Serial.println(bpm);
    //Serial.println(r_rate);

    //if baseline state
    if (baseline==1){
      getBaseLine();
    }
    //else it's fitness state
    else{
    //keep track of last records and decide the fitness level
     
     if (bpm >= 0.5 * max_hrt_rate && bpm < 0.6 * max_hrt_rate){
       colorFlag = 5;       
       } 
      else if (bpm >= 0.6 * max_hrt_rate && bpm < 0.7 * max_hrt_rate){
        colorFlag = 6;  
      }
      else if (bpm >= 0.7 * max_hrt_rate && bpm < 0.8 * max_hrt_rate){
        colorFlag = 7;
      }
      else if (bpm >= 0.8 * max_hrt_rate && bpm < 0.9 * max_hrt_rate){
        colorFlag = 8;  
      }
      else if (bpm >= 0.9 * max_hrt_rate && bpm <= max_hrt_rate){
        colorFlag = 9;  
      }
    }
 sendData(1,colorFlag,ecgRead,average_rr,bpm,r_rate);
 delay(interv); 
  }
 }



///////////////////////////////////////////////////////////////

void stress () {
//start a general timer to keep track of the time
//stopwatch resolution is millis as default
 thirtySec.start();
 resp_timer.start();
 bpm_timer.start();
 
  // a character is the escape button from the gui
  while(Serial.read() != 'a') {
    acquire_signal();

//    Serial.println(bpm);                                        // are we to send bpm and r_rate here????????????????????????
//    Serial.println(r_rate);
    
    //if baseline state
    if (baseline==1){
      getBaseLine();
    }
    sendData(2,6,ecgRead,average_rr,bpm,r_rate);       // if we are supposed to send data here this is the code

    // else{
    //stress_monitoring
  }

  
}   
}

///////////////////////////////////////////////////////////////

void setup() {
  // initialize the serial communication:
  Serial.begin(115200);
  pinMode(9, INPUT); // Setup for leads off detection LO +
  pinMode(11, INPUT); // Setup for leads off detection LO -
}


void loop() {
  //*************************
  // sending data to processing in format
  // "mode-colorFlag-heartRate-respRate\n"
//  Serial.println("loop");

   char val = Serial.read();

    // MODIFY FITNESS MODE WITH THE CODE TO GET THE FITNESS MODE AND COLORS************************************
    // fitness mode
    if(val == 'f'){       // fitness
      set_readings();
      fitness();
      baseline=1;
    }
    else if(val == 's'){       // stress
      set_readings();
      stress();
      baseline=1;
    }
   else if(val == 'm'){       // meditation
      set_readings();
      meditation();
      baseline=1;
   }
    if(val == 'a'){       // exiting
      exitMode();
      baseline=1;
   }
 }
 