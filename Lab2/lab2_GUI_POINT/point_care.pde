void point_care(){
//    DRAW THE POINCARE PLOT
  if (pulse == true){                    // check for new data from arduino
    pulse = false;                       // drop the pulse flag. it gets set in serialEvent
    for (int i=numPoints-1; i>0; i--){   // shift the data in n and n-1 arrays
      beatTimeY[i] = beatTimeY[i-1];
      beatTimeX[i] = beatTimeX[i-1];     // shift the data point through the array
    }
      beatTimeY[0] = beatTimeX[1];       // toss the old n into the n-1 spot
      beatTimeX[0] = IBI;                // update n with the current IBI value
    }

  fill(0,0,255);                         //  draw a history of the data points as blue dots
  for (int i=1; i<numPoints; i++){
    beatTimeX[i] = constrain(beatTimeX[i],0,1500);  // keep the values from escaping the Plot window!
    beatTimeY[i] = constrain(beatTimeY[i],0,1500);
    //float  x = map(beatTimeX[i],0,1500,75,600);  // scale the data to fit the screen
    float  x = map(beatTimeX[i],0,1500,width/2-50-225,width/2-50+225);
    float  y = map(beatTimeY[i],0,1500,height/2+15+225,height/2+15-225);  // invert Y so it looks normal
    ellipse(x,y,2,2);                            // print datapoints as dots 2 pixel diameter
 }
   fill(250,0,0);                               // draw the most recent data point as a red dot
   float  x = map(beatTimeX[0],0,1500,width/2-50-225,width/2-50+225);  // scale the data to fit the screen
   float  y = map(beatTimeY[0],0,1500,height/2+15+225,height/2+15-225);  // invert Y so it looks normal
   ellipse(x,y,7,7);                            // print datapoint as a dot 5 pixel diameter
   fill(255,253,248);                           // eggshell white
   text("n: "+IBI+"mS",width-85,50);            // print the latest IBI value

//  TRACE THE LAST 20 DATAPOINTS IF THE OPTION IS SELECTED
  if(makeLine){                                         // toggle the makeLine flag by pressing 'L'
  stroke(0,0,255);                                      // trace the points in blue line
  noFill();
  beginShape();
  for (int i=0; i<20; i++){                             // trace the arc of n/n-1 for the last 20 points
    if(beatTimeX[i] == 0 || beatTimeY[i] == 0){break;}  // this solves for small data sets or long lines
    x = map(beatTimeX[i],0,1500,width/2-50-225,width/2-50+225);                // scale the data to fit the screen
    y = map(beatTimeY[i],0,1500,height/2+15+225,height/2+15-225);                // invert Y so it looks normal
    vertex(x,y);                                        // set the vertex coordinates
  }
  endShape();                                           // connect the vertices
  }

//   GRAPH THE PULSE SENSOR DATA


 stroke(250,0,0);                                       // use red for the pulse wave
  beginShape();                                         // beginShape is a fast way to draw lines!
  for (int i=1; i<PPG.length-1; i++){                   // scroll through the PPG array
    x = width-160+i;
    y = PPG[i];
    vertex(x,y);                                        // set the vertex coordinates
  }

  endShape();                                           // connect the vertices
  noStroke();

}
