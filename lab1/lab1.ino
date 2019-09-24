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
}
