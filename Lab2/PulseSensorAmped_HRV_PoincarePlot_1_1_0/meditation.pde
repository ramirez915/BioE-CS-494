void med_draw(){

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

if(bpm>thr_med) {
  
  count++;
  
  if(count==3) {
    
    text("Calm down, breath slowly",width/600,40);
    
  }

}

}
