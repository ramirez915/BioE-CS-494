#include <StopWatch.h>


//declare global variables:
StopWatch bpm_timer; //timer for bpm
StopWatch thirtySec(StopWatch::SECONDS); //timer for 30 sec of baseline
int upper=0;
int baseline=0;
int it=0;

const int age = 50;

double bpmbase = 0;
double respbase=0;

float bpm;

//bpm:
const int numReadings_bpm = 5;
int readings_bpm[numReadings_bpm];      // the readings from the analog input
                              // the index of the current reading
int readIndex_bpm = 0;
int total_bpm = 0;                  // the running total
float average_bpm=0;             // the average

//  Variables
int PulseSensorPurplePin = 0;        // Pulse Sensor PURPLE WIRE connected to ANALOG PIN 0
int LED13 = 13;   //  The on-board Arduion LED


int seg;                // holds the incoming raw data. Signal value can range from 0-1024
int thr = 550;            // Determine which Signal to "count as a beat", and which to ingore.


int colorFlag;

int max_hrt_rate = 220 - age; //to find the max hear rate of the user based on age


//////////////////////////////////////////////////////////////////////////////////////////////

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
       digitalWrite(LED13,HIGH);
       
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
    } 

    else{
      digitalWrite(LED13,LOW); 
    }

    delay(30);
}


///////////////////////////////////////////////////////

int getBaseLine(){
    if(thirtySec.elapsed()< 30){
//      Serial.println("NOT 30 YET");
      // keep adding to total heart rate to later get avg
      acquire_signal();
      
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
//void set_readings () {
//  
//
//    for (int thisReading = 0; thisReading < numReadings_rr; thisReading++) {
//    readings_rr[thisReading] = 0;
//    }
//    
//    for (int thisReading = 0; thisReading < numReadings_bpm; thisReading++) {
//    readings_bpm[thisReading] = 0;
//    }
//
//}

//////////////////////////////////////////////////////
   
  // sounds the buzzer assuming the buzzer is connected to pin 2
 void buzzer (){
  tone(2,1000);
  delay(10);
  noTone(2);
}

//////////////////////////////////////////////////////

// function that sends over the data to processing once it is all collected
void sendData(int mode, int colorFlag, float heartReading, float respReading){
  Serial.print(mode);
  Serial.print("-");
  Serial.print(colorFlag);
  Serial.print("-");
  Serial.print(heartReading);
  Serial.print("-");
  Serial.println(respReading);
}

//////////////////////////////////////////////////////


// exits the current mode so sends that information to processing
// may need to add in here any other additional things we need to reset
void exitMode(){
  Serial.println("0-0-0-0");

  // STOP WATCHES HERE
  thirtySec.stop();
  resp_timer.stop();
  bpm_timer.stop();
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


///////////////////////////////////////////////////////////////

void stress () {
//start a general timer to keep track of the time
//stopwatch resolution is millis as default

 thirtySec.start();
 resp_timer.start();
 bpm_timer.start();

//initialiaze variable of fitness function:

  // a character is the escape button from the gui
  
  while(Serial.read() != 'a') {
    acquire_signal();

//    Serial.println(bpm);                                        // are we to send bpm and r_rate here????????????????????????
//    Serial.println(r_rate);

    sendData(2,9,bpm,r_rate);       // if we are supposed to send data here this is the code  (maybe need to change color)
    
    //if baseline state
    if (baseline==1){
      getBaseLine();
    }


//STRESS STILL TO DO
    /*
    //else it's stress state
    else{
     for ( int i = 0; i < seconds; i ++){                      
        tmp = currentBpm;
        
        if (tmp > currentBpm){
        // BPM lowered, so the music worked
        }
     }
    }
  }
  */
}   // end of stress mode
}

///////////////////////////////////////////////////////////////

void setup() {
  // initialize the serial communication:
  Serial.begin(115200);
  pinMode(LED13,OUTPUT);
}


void loop() {
  //*************************
  // sending data to processing in format
  // "mode-colorFlag-heartRate-respRate\n"
  
  while(Serial.read() != 'a'){
    char val = Serial.read();

    // MODIFY FITNESS MODE WITH THE CODE TO GET THE FITNESS MODE AND COLORS************************************
    // fitness mode


    if(val == 's'){       //if s received
   
      set_readings();
      stress();
      baseline=1;
    }

    
    if(val == 'm'){       //if m received
    
      set_readings();
      meditation();
      baseline=1;
   }
//EXTRA STILL TO WRITE
    if(val == 'a'){       //if a received
   
      set_readings();
      //extra();
      baseline=1;
   }
  }
  
 }
 
