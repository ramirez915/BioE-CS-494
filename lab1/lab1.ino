
#include <StopWatch.h>


//declare global variables:

StopWatch resp_timer; // default millis, timer for respiration
StopWatch bpm_timer; //timer for bpm
Stopwatch 30sec(StopWatch::SECONDS); //timer for 30 sec of baseline
long watchTime = 0;

int bpmbase = 0;
int respbase=0;
int bpm=0;
int r_rate;
long ex_t,in_t;
int c_r;

//update 3 data
int x0,x1,x2

bool max_fp=false
bool min_fp=true
bool max_f=false
bool min_f=false
int baseline=0

int it=0

const int numReadings = 10;



////////////////////////////////////////////////


int getBaseLine(){

     
    if(watch.elapsed()< 30){
    
      Serial.println("NOT 30 YET");
      // keep adding to total heart rate to later get avg

      acquire_signal();
      
      it=it+1;
      bpmbase = bpmbase + bpm;
      respbase = respbase + r_rate;

    }
      
      if(watch.elapsed() == 30){

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

}

void loop() {
  // TESTING FOR PROCESSING GUI
  if(Serial.available()){  //id data is available to read

    char val = Serial.read();

    int i = 0;      // counter for made up numbers

    if(val == 'f'){       //if y received

      fitness();
      baseline=1

    }
    if(val == 's'){       //if s received
      stress();
      baseline=1
    }
    if(val == 'm'){       //if m received
      Serial.println("meditation Mode");
      meditation();
      baseline=1
    }
    if(val == 'a'){       //if a received
      Serial.println("extra Mode");
      extra();
      baseline=1
    }
  }


  
  // TESTING FOR BASELINE FUNCTION
//    if(count != 1){
//      getBaseLine();
//      count++;
//    }

    //DEFAULT CODE FOR HEART RATE MONITOR
//  if((digitalRead(10) == 1)||(digitalRead(11) == 1)){
//    Serial.println('!');
//  }
//  else{
////     send the value of analog input 0:
//      Serial.println(analogRead(A0));
//      getBaseLine();
//  }

  //Wait for a bit to keep serial data from saturating
  delay(15);
}


 
 
 //////////////////////////////////////////////////////////////////////////////////////////////



int acquire_signals() {

  int readings[numReadings];      // the readings from the analog input
  int readIndex = 0;              // the index of the current reading
  int total = 0;                  // the running total
  int average = 0;                // the average

  //A3 is the respiratory signal input
  int inputPin = A3;

  //initialize readings to 0
  for (int thisReading = 0; thisReading < numReadings; thisReading++) {
    readings[thisReading] = 0;
  }

  
  while(i<numReadings){
     // subtract the last reading:
  total = total - readings[readIndex];
  // read from the sensor:
  readings[readIndex] = analogRead(inputPin);
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
  // send it to the computer as ASCII digits


x2=x1;
x1=x0;

x0=average;

max_min();

ex_in();

 //t_inhal, t_exhal acquired
 //r_rate computed

  //heart rate acquisition
  //check for signal acquisition
  //pins are D11=LO- and D09=LO+

  double seg
  
  if((digitalRead(11) == 1)||(digitalRead(9) == 1)){
    
      Serial.println('!');
  }

  //if everything ok acquire the signal and check for treshold
  else{

    seg=analogRead(A0)

    //check for threshold
    if(seg>thr){

      //R-peak detected, save time instant
      //t must be current time

      R_R=bpm_timer.elapsed()/1000
      bpm_timer.reset()
      bpm_timer.start()
      //compute bpm as a frequency
      bpm=R_R/60

    }
      
  }

 }


///////////////////////////////////////////////////////////////////




void max_min (){

  
//if max
if(x0<x1 && x2<x1){
  max_f=true
  max_f=false
}
  
if(x0>x1 && x2>x1) {
  min_f=true
  max_f=false
}

}


////////////////////////////////////////////////////////



void ex_in (){

  if(max_f && min_fp){
    //found inhalation peak, record inhalation time
    in_t=resp_time.elapsed();
    resp_time.reset()
    resp_time.start()
    min_fp=0
    max_fp=1
  }

  if(!max_f && min_f && max_fp){
    //found exhalation min peak, record exhalation time
    ex_t=resp_time.elapsed();
    resp_time.reset()
    resp_time.start()
    min_fp=1
    max_fp=0

    //when found an exhalation peak it means a full breath is finished
    c_r=c_r+1

    r_rate= 60/r_rate

    
    
  }
  
}
 



//////////////////////////////////////////////////////



 void fitness {
//start a general timer to keep track of the time
//stopwatch resolution is millis as default

 30sec.start();
 resp_timer.start();
 bpm_timer.start();


//initialiaze variable of fitness function:

  while(!esc) {


 acquire_Signal()

//plotter
  //practice code to send to processing
      for(
        int i=0; i<100;i++){
        Serial.print(i+10);
        Serial.print("-");
        Serial.println(i+50);
        delay(50);  // sending in this format to processing 10-20\n
      }



//if baseline state
if (baseline==1){
  
  baseline()
 }


//else it's fitness state
else{

      int max_hrt_rate = 220 - age; //to find the max hear rate of the user based on age

     //to display the activity zone and an activity graph on the GUI using the variables activity_zone and colorFlag
     
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

  
 }

 30sec.reset();
 resp_timer.reset();
 bpm_timer.reset();
 
 
 }





///////////////////////////////////////////////////////////////






 void stress {



baseline()

// int acquire_signals() {
//
//  const int numReadings = 10;
//
//  int readings[numReadings];      // the readings from the analog input
//  int readIndex = 0;              // the index of the current reading
//  int total = 0;                  // the running total
//  int average = 0;                // the average


  while(!esc) {
  
  time=stopwatch()

  respir,bpm=acquire_Signal(time)





//fmedit


  //keep track of last records and decide the fitness level


  //compare baseline with current sgnals



  //if
  buzzer

  
 }
 
 }
 
 




//
//
//
//
//
// void fitness {
//
//  /*  In this function:
//   *  
//   *  plot baseline heart rate and respiratory (inhalation/exhalation) rates
//   *  plot color-coded activity graphs and display activity zones
//   *  user performs activity:
//   *  display updated graphs, activity zones, respiratory rates
//   */
//  
//  //declaring the fitness level variables
//  int colorFlag;
//  String activity_zone;
//  
//  //call acquire_Signal
//  respir,bpm=acquire_Signal(time)
//  
//  //finding the activity zone for current bpm
//    while(!esc) {
//    
//      time=stopwatch()
//    
//      int max_hrt_rate = 220 - age; //to find the max hear rate of the user based on age
//  
//      //to display the activity zone and an activity graph on the GUI using the variables activity_zone and colorFlag
//      
//      if (bpm >= 0.5 * max_hrt_rate && bpm < 0.6 * max_hrt_rate){
//        activity_zone = "very light";
//        colorFlag = 5;
//        Serial.println("activity zone is:" + activity_zone);
//        
//        } 
//      else if (bpm >= 0.6 * max_hrt_rate && bpm < 0.7 * max_hrt_rate){
//        activity_zone = "light";
//        colorFlag = 6;
//  
//        Serial.println("activity zone is:" + activity_zone);
//      }
//      else if (bpm >= 0.7 * max_hrt_rate && bpm < 0.8 * max_hrt_rate){
//        activity_zone = "moderate";
//        colorFlag = 7;
//  
//        Serial.println("activity zone is:" + activity_zone);
//      }
//      else if (bpm >= 0.8 * max_hrt_rate && bpm < 0.9 * max_hrt_rate){
//        activity_zone = "hard";
//        colorFlag = 8;
//  
//        Serial.println("activity zone is:" + activity_zone);
//      }
//      else if (bpm >= 0.9 * max_hrt_rate && bpm <= max_hrt_rate){
//        activity_zone = "maximum";
//        colorFlag = 9;
//  
//        Serial.println("activity zone is:" + activity_zone);
//      }
//    }
//    
// }
// 
//
//  
//  baseline()
//
////
//
//
//  while(!esc) {
//  
//  time=stopwatch()
//
//
//  
//
//  respir,bpm=acquire_Signal(time)
//
////plotter
//
//
//
////fitness
//
//
//  //keep track of last records and decide the fitness level
//
//
//  //compare baseline with current sgnals
//  
//
//  
// }
// 
// }
//
//
//
//
//
// void stress {
//
//
//
//baseline()
//
////
//
//
//  while(!esc) {
//  
//  time=stopwatch()
//
//  respir,bpm=acquire_Signal(time)
//
//
//
//
//
////stress
//
//
//  //keep track of last records and decide the fitness level
//
//
//  //compare baseline with current sgnals
//  
//
//  
// }
// 
// }
//
//
//
// void meditation {
//
//
//
//baseline()
//
////
//
//
//  while(!esc) {
//  
//  time=stopwatch()
//
//  respir,bpm=acquire_Signal(time)
//
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
// 
// 
//
//
//
// void buzzer () {
//  
//  
//  
//  }
