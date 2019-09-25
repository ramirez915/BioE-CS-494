#include <StopWatch.h>

StopWatch watch(StopWatch::SECONDS);    // count time in seconds
long watchTime = 0;

int heartRateTotal = 0;
int avgHeartRate = 0;

int count = 0;


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

}

void loop() {
  // TESTING FOR PROCESSING GUI
  if(Serial.available()){  //id data is available to read

    char val = Serial.read();

    if(val == 'f'){       //if y received
      Serial.println("fitness Mode");
    }
    if(val == 's'){       //if s received
      Serial.println("stress Mode");
    }
    if(val == 'm'){       //if m received
      Serial.println("meditation Mode");
    }
    if(val == 'a'){       //if a received
      Serial.println("extra Mode");
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
<<<<<<< Updated upstream
}
=======
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
 
 // analogRead
  //check for signal acquisition
  //pins are D11=LO- and D09=LO+


  int seg
 
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
 }


 void fitness {
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
  getBaseLine()
  
  while(!esc) {
  time=stopwatch()
  respir,bpm=acquire_Signal(time)
  
  breathPattern();

    }
 }

 void breathPattern(){
    int count = 0;
    int topValue; // Max value taken from ECG reader
    int bottomValue; // Min value taken from ECG
    
    while(!esc){
    int dif = topValue - bottomValue;
    if ( dif < 3.0 ){
      count++
      if (count = 3){
        buzzer();
      }
    }
    else{
      count = 0;
      break;
    }
   }
 }

void buzzer(){
  cout<<"Buzz";
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
>>>>>>> Stashed changes
