int i = 0;
int colorFlag = 0;
void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
}

void loop() {
  // put your main code here, to run repeatedly:
  //*************************
  // sending data to processing in format
  // "mode-colorFlag-heartRate-respRate\n"
  
  while(Serial.read() != 'a'){
    char val = Serial.read();

    // MODIFY FITNESS MODE WITH THE CODE TO GET THE FITNESS MODE AND COLORS************************************
    // fitness mode
    if(val == 'f'){
      while(Serial.read() != 'a'){
        if(i >= 1000){
          i = 0;
        }

        //adding code for fitness color
        if(i < 600){
          colorFlag = 5;
        }
        else if(i >= 600 && i < 1000){
          colorFlag = 6;
        }
        sendData(1,colorFlag,i,i);

        
//        Serial.print("1-"); //mode
//        Serial.print(colorFlag);
//        Serial.print("-");
//        Serial.print(i); // heart
//        Serial.print("-");
//        Serial.println(i); // resp


        i++;
      }
      // exited the mode so end that to processing
      exitMode();
//      Serial.println("0-0-0-0");

      i = 0;
    }   // end of fitness if stmt

    // stress mode
    else if(val == 's'){
      while(Serial.read() != 'a'){
        
        //------------------------------------------ take out when ready
        if(i >= 1000){
          i = 0;
        }

        //adding code for fitness color
        if(i < 600){
          colorFlag = 5;
        }
        else if(i >= 600 && i < 1000){
          colorFlag = 6;
        }
        //------------------------------------------------- take out wen ready

        // MAYBE HAVE SOMETHING TO CHANGE THE COLOR DEPENDING ON HOW LESS STRESS USER IS
        // SOMETHING SIMILAR TO THE FITNESS MODE COLOR CHANGES BUT FOR STRESS
        
        // mode changed to 2 because stress mode
        sendData(2,colorFlag,i,i);
        // REPLACE ABOVE WITH
//        sendData(2,colorFlag,HEART_RATE,RESP_RATE);
        i++;    // ------------------------------------------------take out
      }
      // exited the mode so end that to processing
      exitMode();
      i = 0; // --------------------------------------------------take out when ready
    }   // end of stress mode if stmt

    // meditaion mode
    // INSERT CODE FOR MEDITATION
    else if(val == 'm'){
      while(Serial.read() != 'a'){
        //---------------------------------------------------------    take out when ready
        if(i >= 1000){
          i = 0;
        }

        //adding code for fitness color
        if(i < 600){
          colorFlag = 5;
        }
        else if(i >= 600 && i < 1000){
          colorFlag = 6;
        }
        
        sendData(3,colorFlag,i,i);
        i++;
        //---------------------------------------------------------
        
        // mode changed to 3 because meditation mode
        // colorFlag = 6 because blue seems to be a good color to have to meditate
        colorFlag = 6                                     //---------------------------------------- this is what should be left
//        sendData(3,colorFlag,HEART_RATE,RESP_RATE);
        //------------------------------------------------------------------------------------------------------------------------
      }
      // exited the mode so end that to processing
      exitMode();
      i = 0;                                    // take out when ready
    }   // end of stress mode if stmt
  }   // end of while val != 'a' (exit mode)
}   // end of loop()

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

// exits the current mode so sends that information to processing
// may need to add in here any other additional things we need to reset
void exitMode(){
  Serial.println("0-0-0-0");
}



