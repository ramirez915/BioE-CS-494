#include <StopWatch.h>


//declare global variables:
StopWatch resp_timer; // default millis, timer for respiration
StopWatch bpm_timer; //timer for bpm
StopWatch thirtySec(StopWatch::SECONDS); //timer for 30 sec of baseline
long watchTime = 0;

int baseline=0;
int it=0;

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
const int numReadings_rr= 50;
int readings_rr[numReadings_rr]; 
int readIndex_rr= 0;  
int total_rr = 0;                  // the running total
float average_rr = 0;                // the average
//10 ms is the best waiting time
int wait_rr=10; //millis for delay in 
//gain 10 is the best
int gain_rr=100;
//int gap=150;


//bpm:
const int numReadings_bpm = 5;
int readings_bpm[numReadings_bpm];      // the readings from the analog input
                              // the index of the current reading
int readIndex_bpm = 0;
int total_bpm = 0;                  // the running total
float average_bpm=0;             // the average

const double thr = 700;


int colorFlag;

int max_hrt_rate = 220 - age; //to find the max hear rate of the user based on age


//PINS:
//A3 is the respiratory signal input
int respPin = A3;



////////////////////////////////////////////////


int getBaseLine(){

     
    if(thirtySec.elapsed()< 30){
    
      Serial.println("NOT 30 YET");
      // keep adding to total heart rate to later get avg

      acquire_signals();
      
      it=it+1;
      bpmbase = bpmbase + bpm;
      respbase = respbase + r_rate;

    }
      
      if(thirtySec.elapsed() == 30){

        // get avg heart rate here
        
       bpmbase = bpmbase / it;
       respbase=respbase/it;

       //set baseline=0

       it=0;
       baseline=0;
       
        Serial.println("30! baseline computed");
 
      }
      
}


//////////////////////////////////////////////


void setup() {
  // initialize the serial communication:
  Serial.begin(115200);
  pinMode(10, INPUT); // Setup for leads off detection LO +
  pinMode(11, INPUT); // Setup for leads off detection LO -
 for (int thisReading = 0; thisReading < numReadings; thisReading++) {
    readings[thisReading] = 0;
}
}


void loop() {
  // TESTING FOR PROCESSING GUI
  if(Serial.available()) {  //id data is available to read

    char val = Serial.read();

    int i = 0;      // counter for made up numbers

    if(val == 'f'){       //if y received

      Serial.println("Fitnes Mode");
     /* while(Serial.read() != 'a'){
        
        if(i+50 >= 300){
          i = 0;
        }
        Serial.print("1-");   // flag for processing to know this data is for fitness mode 
        Serial.print(i+10); // heart rate value
        Serial.print("-");
        Serial.println(i+50); // respi
        i++;
        delay(50);  // sending in this format to processing 1-10-20\n
      }

      */

      for (int thisReading = 0; thisReading < numReadings; thisReading++) {
    readings[thisReading] = 0;
}
      fitness();
      baseline=1;

    }


    if(val == 's'){       //if s received
      Serial.println("Stress Mode");
      for (int thisReading = 0; thisReading < numReadings; thisReading++) {
    readings[thisReading] = 0;
}
      stress();
      baseline=1;
    }
    
    if(val == 'm'){       //if m received
      Serial.println("Meditation Mode");
      meditation();
      baseline=1;
      //initialize readings to 0
  for (int thisReading = 0; thisReading < numReadings; thisReading++) {
    readings[thisReading] = 0;
    }
   }

    if(val == 'a'){       //if a received
      Serial.println("Extra Mode");
      extra();
      baseline=1;
      //initialize readings to 0
  for (int thisReading = 0; thisReading < numReadings; thisReading++) {
    readings[thisReading] = 0;
    }
   }
  }
  

}


 //////////////////////////////////////////////////////////////////////////////////////////////

void acquire_signal() {
  
//acquire respiration rate:
  int readings_rr[numReadings_rr];      // the readings from the analog input
  int readIndex_rr = 0;              // the index of the current reading
  int total_rr = 0;                  // the running total
  int average_rr = 0;                // the average

  
  // subtract the last reading:
  total_rr = total_rr - readings_rr[readIndex_rr];
  // read from the sensor:
  readings_rr[readIndex_rr] = analogRead(respPin);
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
//wait 10ms to smooth
  delay(10);

    s2=s1;
    //sec.elapsed()*
    s1=average_rr;
    //Serial.println(s1);
   // Serial.print(" ");
    if(s1-s2<0 && minf==true) {
      
      maxf=true;
      minf=false;
      in_t=timer.elapsed();
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
   //Serial.println(average);

seg=average_bpm;

//Serial.print("Segnal:");
//Serial.println(seg);
//Serial.print(" ");

   // seg=analogRead(A0);
//
 //Serial.println(seg);
    //check for threshold
   
    if(seg>thr){
//
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
     // Serial.print("b                                                         m                                                                pm:");
      -//Serial.println(bpm);    //*2 gives a more reasonable bpm
//Wait for a bit to keep serial data from saturating

      delay(30);
    }
      
 }

}


//////////////////////////////////////////////////////


 //UNCOMMENT WHEN READY WHAT IS ACTIVITY ZONE?
void fitness() {


  /*  In this function:
//   *  
//   *  plot baseline heart rate and respiratory (inhalation/exhalation) rates
//   *  plot color-coded activity graphs and display activity zones
//   *  user performs activity:
//   *  display updated graphs, activity zones, respiratory rates
//   */

  
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

    //plotter
    //practice code to send to processing
    
    for(int i=0; i<100;i++){
      Serial.print(i+10);
      Serial.print("-");
      Serial.println(i+50);
      delay(50);  // sending in this format to processing 10-20\n
    }


    //if baseline state
    if (baseline==1){
      getBaseLine();
    }
    //else it's fitness state
    else{
    //keep track of last records and decide the fitness level
  
     //to display the activity zone and an activity graph on the GUI using the variables activity_zone and colorFlag
     
     String activity_zone = "";
     
     if (bpm >= 0.5 * max_hrt_rate && bpm < 0.6 * max_hrt_rate){
        activity_zone = "very light";
       colorFlag = 5;
       Serial.println("activity zone is:" + activity_zone);
       
       } 
      else if (bpm >= 0.6 * max_hrt_rate && bpm < 0.7 * max_hrt_rate){
        activity_zone = "light";
        colorFlag = 6;
  
        Serial.println("activity zone is:" + activity_zone);
      }
      else if (bpm >= 0.7 * max_hrt_rate && bpm < 0.8 * max_hrt_rate){
        activity_zone = "moderate";
        colorFlag = 7;
  
        Serial.println("activity zone is:" + activity_zone);
      }
      else if (bpm >= 0.8 * max_hrt_rate && bpm < 0.9 * max_hrt_rate){
        activity_zone = "hard";
        colorFlag = 8;
  
        Serial.println("activity zone is:" + activity_zone);
      }
      else if (bpm >= 0.9 * max_hrt_rate && bpm <= max_hrt_rate){
        activity_zone = "maximum";
        colorFlag = 9;
  
        Serial.println("activity zone is:" + activity_zone);
      }
    }
}

//compare baseline and signal

   thirtySec.reset();
   resp_timer.reset();
   bpm_timer.reset();
 
 
 }





///////////////////////////////////////////////////////////////






//void stress {

//start a general timer to keep track of the time
//stopwatch resolution is millis as default

 thirtySec.start();
 resp_timer.start();
 bpm_timer.start();


//initialiaze variable of fitness function:

  // a character is the escape button from the gui
  while(Serial.read() != 'a') {


    acquire_signal();

    Serial.println(bpm);
    Serial.println(r_rate);

    //plotter
    //practice code to send to processing
    
    for(int i=0; i<100;i++){
      Serial.print(i+10);
      Serial.print("-");
      Serial.println(i+50);
      delay(50);  // sending in this format to processing 10-20\n
    }


    //if baseline state
    if (baseline==1){
      getBaseLine();
    }
    //else it's stress state
    else{
//
//
//
//
////fmedit
//
//
//  //keep track of last records and decide the fitness level
//
//
//  //compare baseline with current sgnals
//
//
//
//  //if
//  buzzer
//
//  
// }
// 
// }
 
 */

/*

//
// void meditation {

////start a general timer to keep track of the time
//stopwatch resolution is millis as default

 thirtySec.start();
 resp_timer.start();
 bpm_timer.start();


//initialiaze variable of fitness function:

  // a character is the escape button from the gui
  while(Serial.read() != 'a') {


    acquire_signal();

    Serial.println(bpm);
    Serial.println(r_rate);

    //plotter
    //practice code to send to processing
    
    for(int i=0; i<100;i++){
      Serial.print(i+10);
      Serial.print("-");
      Serial.println(i+50);
      delay(50);  // sending in this format to processing 10-20\n
    }


    //if baseline state
    if (baseline==1){
      getBaseLine();
    }
    //else it's fitness state
    else{
//
//
//  //if
//  buzzer
//
//  
// }
// 
// }
// 
// 
//*/
//
//
 void buzzer (){
  tone(2,1000);
  delay(10);
  noTone(2);
}
