
void serialEvent(Serial port){
try{
   String inData = port.readStringUntil('\n');
   inData = trim(inData);                 // cut off white space (carriage return)



   if (inData.charAt(0) == 'S'){          // leading 'S' means sensor data
     inData = inData.substring(1);        // cut off the leading 'S'
     int newPPG = int(inData);            // convert the ascii string to ppgY
     // move the Y coordinate of the Pulse Sensor data waveform over one pixel left
     for (int i = 0; i < PPG.length-1; i++){
       PPG[i] = PPG[i+1];   // new data enters on the right at pulseY.length-1
     }
     // scale and constrain incoming Pulse Sensor value to fit inside the pulse window
     PPG[PPG.length-1] = int(map(newPPG,50,950,(height/2+15)+225,(height/2+15)-225));
     return;
   }




   if (inData.charAt(0) == 'Q'){          // leading 'Q' means time between beats in milliseconds
     inData = inData.substring(1);        // cut off the leading 'Q'
     IBI = int(inData);                   // convert ascii string to integer IBI
     //println(IBI);
   
     //save values of ibi to compute bpm only if we are in stress and meditation modes:
    
     //if(stress_f==true || med_f==true) {
       
     bpm=60/(IBI/1000);
     println(bpm);
     for (int i = 0; i < bpm_arr.length-1; i++){
       bpm_arr[i] = bpm_arr[i+1];   // new data enters on the right at pulseY.length-1
     }
     
     // scale and constrain incoming Pulse Sensor value to fit inside the pulse window
     bpm_arr[bpm_arr.length-1] = int(map(bpm,10,120,(height/2+15)+225,(height/2+15)-225));

     pulse = true;                        // set the pulse flag
     return;

}
  }catch(Exception e) {
  // println(e.toString());
}

}
