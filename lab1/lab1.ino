#include <StopWatch.h>
// ALWAYS CHANGE BEFORE STARTING PROGRAM
const int AGE = 50;


StopWatch watch(StopWatch::SECONDS);    // count time in seconds
long watchTime = 0;

int heartRateTotal = 0;
int avgHeartRate = 0;

int count = 0;

// will be setting 5,6,7,8,9 as color flags for gui to interpret


int getBaseLine(){
    watch.start();
    
    while(watch.elapsed()!= 30){
      Serial.println("NOT 30 YET");
      Serial.println(watch.elapsed());
      // keep adding to total heart rate to later get avg
//      heartRateTotal = heartRateTotal + // reading from sensor
      if(watch.elapsed() == 30){
        Serial.println("30!");
        break;
        // get avg heart rate here
//        avgHeartRate = avgHeartRate / 
      }
    }
}




void setup() {
  // initialize the serial communication:
  Serial.begin(115200);
  pinMode(10, INPUT); // Setup for leads off detection LO +
  pinMode(11, INPUT); // Setup for leads off detection LO -

  // send the age to gui in setup
  Serial.println(AGE);
}

void loop() {
  // TESTING FOR PROCESSING GUI
  if(Serial.available()){  //id data is available to read

    char val = Serial.read();

    if(val == 'f'){       //if y received

      for(int i=0; i<100;i++){
        Serial.print("1-");   // signals gui that this is fitness
        Serial.print(i+10);
        Serial.print("-");
        Serial.println(i+50);
        delay(50);  // sending in this format to processing 10-20\n
      }
    }
    if(val == 's'){       //if s received
      
    }
    if(val == 'm'){       //if m received
      Serial.println("meditation Mode");
    }
    if(val == 'a'){       //if a received
      Serial.print("0-");
      Serial.print("0-");
      Serial.println(0);
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




/*fitness function
 * stress
 * meditation
 * 
 * levels function(state, signla)
 *{switch
 * 
 * baseline fuction
 * 
 * 
 * heart rate signal processing function--->
 * respiratory signal processing funciton
 * 
 * buzzer calling f
 * 
 */





 
 
 int acquire_signals() {

  const int numReadings = 10;

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

  
  while(i<5){
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
  
  
  Serial.println(average);


 
 //respiraotyr signal acquired
 
 
 

 //heart rate acquisition


//INSERT MAX AND MIN FUNCTION TO RECOGNIZE THE INHALATION AND EXHALATION MOMENTS
//RETURN THE RESPIRATION RATE IN PLACE OF THE RESPIRATORY SIGNAL ALONE

 
 //respiraotyr signal acquired
 
  //heart rate acquisition

 
 // analogRead
  //check for signal acquisition
  //pins are D11=LO- and D09=LO+



  //int seg


  double seg

  int bpm

  
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

      R_R=
      
      
    }
      //Serial.println(analogRead(A0));


      
      //getBaseLine();
  }
 }

      R_R=t/1000
      
      //compute bpm as a frequency
      bpm=R_R/60
      
      
    }
      //Serial.println(analogRead(A0))
      
  }

//save values in an array

double output[] = {average,bpm};

return output
  
 }





 void fitness {

  /*  In this function:
   *  
   *  plot baseline heart rate and respiratory (inhalation/exhalation) rates
   *  plot color-coded activity graphs and display activity zones
   *  user performs activity:
   *  display updated graphs, activity zones, respiratory rates
   */
  
  //declaring the fitness level variables
  int colorFlag;
  String activity_zone;
  
  //call acquire_Signal
  respir,bpm=acquire_Signal(time)
  
  //finding the activity zone for current bpm
    while(!esc) {
    
      time=stopwatch()
    
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
 

  
  baseline()

//


  while(!esc) {
  
  time=stopwatch()


  

  respir,bpm=acquire_Signal(time)

//plotter



//fitness


  //keep track of last records and decide the fitness level


  //compare baseline with current sgnals
  

  
 }
 
 }





 void stress {



baseline()

//


  while(!esc) {
  
  time=stopwatch()

  respir,bpm=acquire_Signal(time)





//stress


  //keep track of last records and decide the fitness level


  //compare baseline with current sgnals
  

  
 }
 
 }



 void meditation {



baseline()

//


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
 
 



 void buzzer () {
  
  
  
  }

 
 
 
 
 


















 
 int heart rate() {


 // analogRead
  //check for signal acquisition
  
  if((digitalRead(10) == 1)||(digitalRead(11) == 1)){
    
      Serial.println('!');
  }
  
  else{
      Serial.println(analogRead(A0));
      getBaseLine();
  }




 }

