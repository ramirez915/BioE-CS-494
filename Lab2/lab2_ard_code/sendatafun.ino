
void serialOutput(){   // Decide How To Output Serial.
  switch(outputType){
    case PROCESSING_VISUALIZER:
      sendDataToSerial('S', Signal);     // goes to sendDataToSerial function
      break;
    case SERIAL_PLOTTER:  
        Serial.print(BPM);
//        Serial.print(",");
//        Serial.print(IBI);
        Serial.print(",");
        Serial.println(Signal);
      

      break;
    default:
      break;
  }

}


void serialOutputWhenBeatHappens(){
  switch(outputType){
    case PROCESSING_VISUALIZER:    
      sendDataToSerial('B',BPM);   // BPM with B
      sendDataToSerial('Q',IBI);   // Q ibi
      break;

    default:
      break;
  }
}

void sendDataToSerial(char symbol, int data ){
    Serial.print(symbol);
    Serial.println(data);
  }
