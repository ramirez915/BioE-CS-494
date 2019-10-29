void stress_draw(){

//update based on time

//draw graph of bpm
textSize(40);
text("Stress analyzer",width/2,50);

//   GRAPH THE PULSE SENSOR DATA
  //stroke(250,0,0);                                       // use red for the pulse wave
  //beginShape();                                         // beginShape is a fast way to draw lines!
  //for (int i=1; i<bpm_arr.length-1; i++){                   // scroll through the PPG array
  //  int x = width-160+i;
  //  int y = bpm_arr[i];
  //  vertex(x,y);                                        // set the vertex coordinates
  //}
  //endShape();                                           // connect the vertices
  //noStroke();
  
  plotData();      // plot data from grafica
}

void stress_manage(){

 //stress function: get baselinne--->tell if person is stressed--->stressed--->play music at pressing button--->get signal again---->tell if stressed
  
  
  
int passedTime = millis() - savedTime;

if(passedTime<30000){
  getBaseLine();
  textSize(40);
  text("Acquiring baseline: " +int(passedTime/1000),230,850);

}

if(passedTime>=30000 && passedTime<60000) {
  if(play==true){
  song.play();
  play=false;
  }
  textSize(40);
  text("CarelessWhisper: " + int(passedTime/1000-30),200,850);
  text("Baseline: " + int(bpmbase),200,950);
}



if(passedTime>=60000) {
  
  song.stop();

  //tell and display if the person is stressed or not
  //if stressed keep playing music for other 30 sec
 
  
  //otherwise monitor and reset timer 
  if(bpm>bpmbase*1.3){
    //stressed-->play again
    passedTime=30000;
    text("To help calm down some relaxing music will be played again",200,850);

    passedTime=0;
}

else {
  //else it means that the person is fine
  text("You're relaxed",200,850);
}

}

}
