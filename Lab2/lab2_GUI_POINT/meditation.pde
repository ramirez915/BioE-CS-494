void med_draw(){

  
  text("Meditation analyzer",width/2,50);
  
  plotData(); 

}


void med_manage(){
  
    
int passedTime = millis() - savedTime;

if(passedTime<30000){
  getBaseLine();
  textSize(40);
  text("Acquiring baseline: "+passedTime,240,850);
//  text(passedTime);
}

if(bpm>70 && passedTime>30){
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
