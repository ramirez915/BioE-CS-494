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
