void getBaseLine(){
  
      it=it+1;
      bpmbase = bpmbase + bpm;
      
    // get avg heart rate here
    
    if(passedTime > 30000){
      
     //bpmbase = bpmbase / it;
     it=0;
     play=true;
     bpmbase=70;
     //tell if stressed:
     if (bpmbase>thr_stressed){
         stressed=true;
    }
    
    
//     Serial.println("30! baseline computed");
}

}
