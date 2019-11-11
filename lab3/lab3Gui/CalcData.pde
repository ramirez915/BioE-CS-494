/*
SECTION 1
sec-mf-lf-mm-heel-stepLen-strideLen-cadence-walkingSpeed-stepCount
SECTION 2
MFN and footType
SECTION 3
direction
SECTION 4
health
*/

//void setDataArrZeros(){
//  for(int i = 0; i < 4; i++){
//    dataArr[i] = 0.0;
//  }
//}

// parses out data for sec 1
void parseDataRcvd(){
  // check for valid step
  // based on values from FSR and thr_step
  for(int i = 0; i < 4; i++){
    if(!foundStep){
      if(dataArr[i] > thr_step){
        // if just starting add one
        if(stepCount == 0){
          stepCount++;
        }
        // else add 2 steps
        else{
          stepCount += 2;
        }
        foundStep = true;
        break;
      }
    }
  }
  foundStep = false;
  
  // now set values to blobs and dir to be used
  // map values to be placed as the radius for the blobs
  
  for(int i = 0; i < 4; i++){
    //println(i +" value " + dataArr[i]);
    float mappedR = map(dataArr[i],0,1023,0,100);    // max radius 60-100...
    //update blobs
    blobs[i].updateR(mappedR);
    footSens[i] = mappedR;
  }
  // lastly get the direction
  mfVal = dataArr[0];
  lfVal = dataArr[1];
  mmVal = dataArr[2];
  heelVal = dataArr[3];
  //println("mf "+ mfVal + " lf "+ lfVal + " mm "+ mmVal + " heel "+ heelVal);
  dir = dataArr[4];
  //println("new dir: " + dir);
}


//----------------------------------------------------------------------------------------------------------------------- plotting data on graphs

// plots the data on the two graphs
void plotData(){
  // ADDING POINT TO PLOT
  mfPlot.addPoint(new GPoint(x1,footSens[0]));
  mfPlot.setPoint(x1, new GPoint(x1,footSens[0]));
  mfPlot.getTitle().setText("MF Monitor     Signal: " + str(footSens[0]));
  
  lfPlot.addPoint(new GPoint(x1,footSens[1]));
  lfPlot.setPoint(x1, new GPoint(x1,footSens[1]));
  lfPlot.getTitle().setText("LF Monitor     Signal: " + str(footSens[1]));
  
  mmPlot.addPoint(new GPoint(x1,footSens[2]));
  mmPlot.setPoint(x1, new GPoint(x1,footSens[2]));
  mmPlot.getTitle().setText("MM Monitor     Signal: " + str(footSens[2]));
  
  heelPlot.addPoint(new GPoint(x1,footSens[3]));
  heelPlot.setPoint(x1, new GPoint(x1,footSens[3]));
  heelPlot.getTitle().setText("HEEL Monitor     Signal: " + str(footSens[3]));
  
  println("plotted vals: MF "+ footSens[0] + " LF " + footSens[1] + " MM "+ footSens[2] + "HEEL "+ footSens[3]);
  
  x1++;  // move on to the next x coordinate
  
  //draw graphs
  mfPlot.beginDraw();
  mfPlot.drawBackground();
  mfPlot.drawBox();
  mfPlot.drawXAxis();
  mfPlot.drawYAxis();
  mfPlot.drawTitle();
  mfPlot.drawLines();
  mfPlot.endDraw();
  
  lfPlot.beginDraw();
  lfPlot.drawBackground();
  lfPlot.drawBox();
  lfPlot.drawXAxis();
  lfPlot.drawYAxis();
  lfPlot.drawTitle();
  lfPlot.drawLines();
  lfPlot.endDraw();
  
  mmPlot.beginDraw();
  mmPlot.drawBackground();
  mmPlot.drawBox();
  mmPlot.drawXAxis();
  mmPlot.drawYAxis();
  mmPlot.drawTitle();
  mmPlot.drawLines();
  mmPlot.endDraw();
  
  heelPlot.beginDraw();
  heelPlot.drawBackground();
  heelPlot.drawBox();
  heelPlot.drawXAxis();
  heelPlot.drawYAxis();
  heelPlot.drawTitle();
  heelPlot.drawLines();
  heelPlot.endDraw();
  
  
  // at the max so scroll to the side    x axis
  if(x1 >= 50){
    mfPlot.moveHorizontalAxesLim(3.0);    // if want faster scroll increase this value
    lfPlot.moveHorizontalAxesLim(3.0);     // 3.0 seems to be a good value
    mmPlot.moveHorizontalAxesLim(3.0);
    heelPlot.moveHorizontalAxesLim(3.0);
  }
}

void resetPlots(){
  println("restting plots...");
  // removes all the points from the graphs
  for(int i = 0; i < x1; i++){
    mfPlot.removePoint(0);
    lfPlot.removePoint(0);
    mmPlot.removePoint(0);
    heelPlot.removePoint(0);
  }
  
  // reset limits
  mfPlot.setXLim(0,50);    // x axis must stay the same
  mfPlot.setYLim(0,260);    // y axis
  mfPlot.updateLimits();
  
  lfPlot.setXLim(0,50);    // x axis must stay the same
  lfPlot.setYLim(0,260);    // y axis
  lfPlot.updateLimits();
  
  mmPlot.setXLim(0,50);    // x axis must stay the same
  mmPlot.setYLim(0,260);    // y axis
  lfPlot.updateLimits();
  
  heelPlot.setXLim(0,50);    // x axis must stay the same
  heelPlot.setYLim(0,260);    // y axis
  heelPlot.updateLimits();
  x1 = 0;
  
  println("done");
}

//------------------------------------------------------------------------------------------------------------ end of plotting data
