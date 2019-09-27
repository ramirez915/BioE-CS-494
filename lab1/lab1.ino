#include <StopWatch.h>


//declare global variables:
const int age = 50;
StopWatch resp_timer; // default millis, timer for respiration
StopWatch bpm_timer; //timer for bpm
StopWatch thirtySec(StopWatch::SECONDS); //timer for 30 sec of baseline
long watchTime = 0;

int bpmbase = 0;
int respbase=0;
int bpm=0;
int r_rate;
long ex_t,in_t;
int c_r;

//update 3 data
int x0,x1,x2;

bool max_fp=false;
bool min_fp=true;
bool max_f=false;
bool min_f=false;
int baseline=0;

int it=0;

const int numReadings = 10;

const double thr = 700;



////////////////////////////////////////////////


int getBaseLine(){

     
    if(thirtySec.elapsed()< 30){
    
      Serial.println("NOT 30 YET");
      // keep adding to total heart rate to later get avg

//      acquire_signals();
      
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

}

void loop() {
  // TESTING FOR PROCESSING GUI
  if(Serial.available()){  //id data is available to read

    char val = Serial.read();

    int i = 0;      // counter for made up numbers

    if(val == 'f'){       //if y received
      while(Serial.read() != 'a'){
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
      
//      fitness();
      baseline=1;

    }
    else if(val == 's'){       //if s received
//      stress();
      baseline=1;
    }
    else if(val == 'm'){       //if m received
//      meditation();
      baseline=1;
    }
    else if(val == 'a'){       //if a received
//      extra();
      baseline=1;
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



int acquire_signal() {

  int readings[numReadings];      // the readings from the analog input
  int readIndex = 0;              // the index of the current reading
  int total = 0;                  // the running total
  int average = 0;                // the average

  //A3 is the respiratory signal input
  int respPin = A3;

  //initialize readings to 0
  for (int thisReading = 0; thisReading < numReadings; thisReading++) {
    readings[thisReading] = 0;
  }

  int i = 0;
  while(i<5){
    // subtract the last reading:
    total = total - readings[readIndex];
    // read from the sensor:
    readings[readIndex] = analogRead(respPin);
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

  float seg;
  float R_R;
  
  if((digitalRead(11) == 1)||(digitalRead(9) == 1)){
    
      Serial.println('!');
  }

  //if everything ok acquire the signal and check for treshold
  else{

    seg=analogRead(A0);

    //check for threshold
    if(seg>thr){

      //R-peak detected, save time instant
      //t must be current time
      
      R_R=float(bpm_timer.elapsed()/1000);
      bpm_timer.reset();
      bpm_timer.start();
      //compute bpm as a frequency
      bpm=R_R/float(60);

    }
      
  }

 }
}


///////////////////////////////////////////////////////////////////




void max_min (){
  //if max
  if(x0<x1 && x2<x1){
    max_f=true;
    max_f=false;
  }
    
  if(x0>x1 && x2>x1) {
    min_f=true;
    max_f=false;
  }
}


////////////////////////////////////////////////////////



void ex_in (){

  if(max_f && min_fp){
    //found inhalation peak, record inhalation time
    in_t=resp_timer.elapsed();
    resp_timer.reset();
    resp_timer.start();
    min_fp=false;
    max_fp=true;
  }

  if(!max_f && min_f && max_fp){
    //found exhalation min peak, record exhalation time
    ex_t=resp_timer.elapsed();
    resp_timer.reset();
//    resp_timer.start();
    min_fp=true;
    max_fp=false;

    //when found an exhalation peak it means a full breath is finished
//    c_r=c_r+1;

    r_rate= 60/(ex_t + in_t);
    
    
  }
  
}
 



//////////////////////////////////////////////////////


// UNCOMMENT WHEN READY WHAT IS ACTIVITY ZONE?
//void fitness() {
////start a general timer to keep track of the time
////stopwatch resolution is millis as default
//
// thirtySec.start();
// resp_timer.start();
// bpm_timer.start();
//
//
////initialiaze variable of fitness function:
//
//  // a character is the escape button from the gui
//  while(Serial.read() != 'a') {
//
//
//    acquire_signal();
//
//    //plotter
//    //practice code to send to processing
//    for(int i=0; i<100;i++){
//      Serial.print(i+10);
//      Serial.print("-");
//      Serial.println(i+50);
//      delay(50);  // sending in this format to processing 10-20\n
//    }
//
//    int max_hrt_rate = 220 - age; //to find the max hear rate of the user based on age
//
//    //if baseline state
//    if (baseline==1){
//      getBaseLine();
//    }
//    //else it's fitness state
//    else{
//    //keep track of last records and decide the fitness level
//  
//     //to display the activity zone and an activity graph on the GUI using the variables activity_zone and colorFlag
//     
//     if (bpm >= 0.5 * max_hrt_rate && bpm < 0.6 * max_hrt_rate){
//        activity_zone = "very light";
//       colorFlag = 5;
//       Serial.println("activity zone is:" + activity_zone);
//       
//       } 
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
//}
//  
//    //compare baseline with current sgnals
//    }
//
//   thirtySec.reset();
//   resp_timer.reset();
//   bpm_timer.reset();
// 
// 
// }
//}





///////////////////////////////////////////////////////////////






//void stress {
//
//
//
//baseline();
//
//// int acquire_signals() {
////
////  const int numReadings = 10;
////
////  int readings[numReadings];      // the readings from the analog input
////  int readIndex = 0;              // the index of the current reading
////  int total = 0;                  // the running total
////  int average = 0;                // the average
//
//
//  while(!esc) {
//  
//  time=stopwatch();
//
//  respir,bpm=acquire_Signal(time);
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
