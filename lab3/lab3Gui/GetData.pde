/*
we get the data in the order of
SECTION 1
sec-mf-lf-mm-heel-stepLen-strideLen-cadence-walkingSpeed-stepCount
SECTION 2
-timeWin0-MFN0-timeWin1-MFN1-timeWin2-MFN2-timeWin3-MFN3-timeWin4-MFN4
SECTION 3
-direction
SECTION 4
-health-virtualAge
*/

void setDataArrZeros(){
  for(int i = 0; i < 22; i++){
    dataArr[i] = 0;
  }
}



// parses out data for sec 1
void setSec1Data(float arr[]){
  // map values to be placed as the radius for the blobs
  //for(int i = 1; i < 5; i++){
  //  println(i +" value " + dataArr[i]);
  //  float mappedR = map(dataArr[i],0,1023,0,100);    // max radius 60-100...
  //  //update blobs
  //  blobs[i-1].updateR(mappedR);
  //}
  mfVal = arr[1];
  float mappedR0 = map(dataArr[1],0,1023,0,100);    // max radius 60-100...
  println("0 " + mappedR0);
  //update blobs
  blobs[0].updateR(mappedR0);
  lfVal = arr[2];
  float mappedR1 = map(dataArr[2],0,1023,0,100);    // max radius 60-100...
  println("1 " + mappedR1);
  //update blobs
  blobs[1].updateR(mappedR1);
  mmVal = arr[3];
  float mappedR2 = map(dataArr[3],0,1023,0,100);    // max radius 60-100...
  println("2 " + mappedR2);
  //update blobs
  blobs[2].updateR(mappedR2);
  heelVal = arr[4];
  float mappedR3 = map(dataArr[4],0,1023,0,100);    // max radius 60-100...
  println("3 " + mappedR3);
  //update blobs
  blobs[3].updateR(mappedR3);
  
    stepLen = arr[5];
    strideLen = arr[6];
    cadence = arr[7];
    walkingSpd = arr[8];
    stepCount = int(arr[9]);
}

//parse out data for sec 2
// 10-19
void setSec2Data(float arr[]){
  timeFrames[0] = int(arr[10]);
  MFNs[0] = arr[11];
  timeFrames[1] = int(arr[12]);
  MFNs[1] = arr[13];
  timeFrames[2] = int(arr[14]);
  MFNs[2] = arr[15];
  timeFrames[3] = int(arr[16]);
  MFNs[3] = arr[17];
  timeFrames[4] = int(arr[18]);
  MFNs[4] = arr[19];
}

void setSec3Data(float arr[]){
  
}

void setsec4Data(float arr[]){
  
}




// plots the data on the two graphs
void plotData(){
  // ADDING POINT TO PLOT
  mfPlot.addPoint(new GPoint(x1,mfVal));
  mfPlot.setPoint(x1, new GPoint(x1,mfVal));
  mfPlot.getTitle().setText("MF Monitor     Signal: " + str(mfVal));
  
  lfPlot.addPoint(new GPoint(x1,lfVal));
  lfPlot.setPoint(x1, new GPoint(x1,lfVal));
  lfPlot.getTitle().setText("LF Monitor     Signal: " + str(lfVal));
  
  mmPlot.addPoint(new GPoint(x1,mmVal));
  mmPlot.setPoint(x1, new GPoint(x1,mmVal));
  mmPlot.getTitle().setText("MM Monitor     Signal: " + str(mmVal));
  
  heelPlot.addPoint(new GPoint(x1,heelVal));
  heelPlot.setPoint(x1, new GPoint(x1,heelVal));
  heelPlot.getTitle().setText("HEEL Monitor     Signal: " + str(heelVal));
  
  println("plotted vals: MF "+ mfVal + " LF " + lfVal + " MM "+ mmVal + "HEEL "+ heelVal);
  
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
  println("exiting");
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
