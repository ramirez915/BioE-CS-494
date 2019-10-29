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

if(passedTime>30000){
  text("Baseline: " + 70 ,200,900);
  
    if (bpm>1.3*bpmbase){
      count++;
    }

    text("Count bpm stressed= "+count,200,850);

 
    
    if(count==3){
    text("Calm down, breath slowly",200,850);
    }
    //play buzzer
  }
}
