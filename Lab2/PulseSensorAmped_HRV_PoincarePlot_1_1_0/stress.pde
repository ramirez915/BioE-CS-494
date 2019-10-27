void stress_draw(){

//update based on time

//draw graph of bpm

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


if(stressed==true){
  
//display a message to calm down

 text("Calm down",width/600,40);
}

}

void stress_manage(){

int passedTime = millis() - savedTime;

if(passedTime<30000 && songCounter==0) {
  
  song.play();
  
}

if(passedTime>=30000) {
  
  song.stop();


}


if (bpm>thr_stressed){
   stressed=true;
}




//



}
