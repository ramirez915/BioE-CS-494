/*
we get the data in the order of
sec-mf-lf-mm-heel-stepLen-strideLen-cadence-walkingSpeed-stepCount-timeWin0-MFN0-timeWin1-MFN1-timeWin2-MFN2-timeWin3-MFN3-timeWin4-MFN4-direction-health-virtualAge
*/


// parses out data for sec 1
void setSec1Data(float arr[]){
  // map values to be placed as the radius for the blobs
  for(int i = 1; i < 5; i++){
    float mappedR = map(dataArr[i],0,1023,0,80);    // max radius 60-100...
    //update blobs
    blobs[i-1].updateR(mappedR);
  }
  //mf = arr[1];
  //lf = arr[2];
  //mm = arr[3];
  //heel = arr[4];
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
