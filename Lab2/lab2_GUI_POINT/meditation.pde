void med_draw(){

  
  text("Meditation analyzer",width/2,50);
  
//   GRAPH THE PULSE SENSOR DATA
  stroke(250,0,0);                                       // use red for the pulse wave
  beginShape();                                         // beginShape is a fast way to draw lines!
  for (int i=1; i<bpm_arr.length-1; i++){                   // scroll through the PPG array
   int x = width-160+i;
   int y = bpm_arr[i];
    vertex(x,y);                                        // set the vertex coordinates
  }
  endShape();                                           // connect the vertices
  noStroke();

}


void med_manage(){
  
    
int passedTime = millis() - savedTime;

if(passedTime<30000){
  getBaseLine();
  textSize(40);
  text("Acquiring baseline: "+passedTime,200,850);
//  text(passedTime);
}

if(bpm<bpmbase*1.3 && passedTime>30){
  text("Baseline: " + int(bpmbase),200,950);
  count=0;
}

else {
  
  count++;
  
  if(count==3) {
    
    text("Calm down, breath slowly",200,850);
    
    
    //play buzzer
  }

}
}
