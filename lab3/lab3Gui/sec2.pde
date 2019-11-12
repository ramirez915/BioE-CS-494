//size of GUI size(2000, 1200);

void setupSec2(){
  sec2Cp5 = new ControlP5(this);
  
  // setting up default time frames
  for(int i = 0; i < 5; i++){
    timeFrames[i] = 0;
    MFNs[i] = 0;
  } 
  // loading images to be placed in array
  qmark = loadImage("qmark.jpg");
  heelImg = loadImage("heel toeing.v2.png");
  tiptoe = loadImage("tip toeing.png");
  intoe = loadImage("In-toeing.png");
  outtoe = loadImage("Out toeing.png");
  normal = loadImage("Straight Walking.png");
  footTypes[0] = qmark;
  footTypes[1] = heelImg;
  footTypes[2] = tiptoe;
  footTypes[3] = intoe;
  footTypes[4] = outtoe;
  footTypes[5] = normal;
  
  // x and y position of the images based on the frame they belong to
  x[0] = 700;
  y[0] = 150;
  x[1] = 1200;
  y[1] = 150;
  x[2] = 700;
  y[2] = 750;
  x[3] = 1200;
  y[3] = 750;
  x[4] = 1650;
  y[4] = 750;
}

//displays data for section 2 as table
void displaySec2Tbl(){
  //text("5 FRAME", 1000, 30);  // ("text", x coordinate, y coordinate)
  currFrame = sec2Cp5.addLabel("curr Frame")
    .setText("Current Walking Pattern")
    .setPosition(600,50)
    .setColorValue(color(0,0,0))
    .setFont(createFont("Candara",65))
    .show();
    ;
    
    cp5.addButton("Button 1")
    .setPosition(680,150)
    .setSize(200, 70)
    .setFont(createFont("MS Gothic",35))
  ;
  
  cp5.addButton("Button 2")
    .setPosition(980,150)
    .setSize(200, 70)
    .setFont(createFont("MS Gothic",35))
  ;
  
  mfn = sec1Cp5.addLabel("Mfp Label")
    .setText("MFP Value:")
    .setPosition(550,300)
    .setColorValue(0)
    .setFont(createFont("Cambria",60))
    ;
    
  mfpVal = sec1Cp5.addLabel("MFPVal")
    .setText(Float.toString(MFPVal))
    .setPosition(650,400)
    .setColorValue(0)
    .setFont(createFont("Cambria",60))
    ;
    
  walkType = sec1Cp5.addLabel("Walking Pattern")
    .setText("Walking Type:")
    .setPosition(1000,300)
    .setColorValue(0)
    .setFont(createFont("Cambria",60))
    ;
    
}

// resets the canvas after sec 2 is done
void resetSec2(){
  background(0,100,255);
  firstRun = true;
  
  for(int i = 0; i < 5; i++){
    timeFrames[i] = 0;
    MFNs[i] = 0;
  }
  sec2Cp5.hide();
}

float calcMFP(float pmf,float plf,float pmm,float pheel){    
  float MFP; //MEP value taken each step
  float topVal = (pmm + pmf) * 100;
  float bottomVal = (pmf + plf + pmm + pheel + 0.001);

  MFP = topVal / bottomVal;
  return MFP;
}

int determineWalkingPat(float MFP){
  // normal
  if(MFP <= 20.9 && MFP >= 15.0){
    println("normal");
    return 5;
  }
  // heel
  else if(MFP <= 24.9 && MFP >= 21.0){
    println("heel");
    return 1;
  }
  // out toe
  else if(MFP <= 30.9 && MFP >= 25.0){
    println("out toe");
    return 4;
  }
  //tip toe
  else if(MFP <= 37.9 && MFP >= 31.0){
    println("tip toe");
    return 2;
  }
  // in toe
  else if(MFP <= 40.0 && MFP >= 38.0){
    println("in toe");
    return 3;
  }
// anything else undetermined...
  else{
    println("undetermined");
    return 0;
  }
}

// updates the table according to what is being read from the arduino. so it all depends on what was recognized
// can assume that were getting the walking type
void updateSec2Tbl(int walkingType){  //float pmf,float plf,float pmm,float pheelype){

  MFPVal = calcMFP(mfVal,lfVal,mmVal,heelVal);
  walkingType = determineWalkingPat(MFPVal);
  mfpVal.setText(Float.toString(MFPVal));
  
  seconds = watch.second();
  min = watch.minute();
  watchVal.setValue(Integer.toString((min)) + " min " + Integer.toString((seconds))+"s");
  if(seconds == 30){
    watch.stop();
  // place correspinding image depending on the value of the timeframe
  switch(walkingType){
    // ? mark
    case 0:
      image(footTypes[0],1100,400,900,900);
      qmarkLbl = sec1Cp5.addLabel("undetermined")
      .setText("Unknown Walking Pattern")
      .setPosition(1000,700)
      .setColorValue(0)
      .setFont(createFont("Cambria",50));
      break;
    // heel
    case 1:
      image(footTypes[1],1100,400,900,900);
      heelWalk = sec1Cp5.addLabel("Walking on Heel")
      .setText("Walking on Heel")
      .setPosition(1000,700)
      .setColorValue(0)
      .setFont(createFont("Cambria",50))
      ;
      break;
    // tip toe
    case 2:
      image(footTypes[2],1100,400,900,900);
      tipWalk = sec1Cp5.addLabel("Walking on Toes")
      .setText("Walking on Toes")
      .setPosition(1000,700)
      .setColorValue(0)
      .setFont(createFont("Cambria",50))
      ;
      break;
    //in toe
    case 3:
      image(footTypes[3],1100,400,400,400);
      inWalk = sec1Cp5.addLabel("In Toe Walking Pattern")
      .setText("In Toe Walking Pattern")
      .setPosition(1050,800)
      .setColorValue(0)
      .setFont(createFont("Cambria",50))
      ;
      break;
    // out toe
    case 4:
      image(footTypes[4],1100,400,400,400);
      outWalk = sec1Cp5.addLabel("Out Toe Walking Pattern")
      .setText("Out Toe Walking Pattern")
      .setPosition(1050,800)
      .setColorValue(0)
      .setFont(createFont("Cambria",50))
      ;
      break;
    // normal
    case 5:
      image(footTypes[5],1100,400,400,400);
      normalWalk = sec1Cp5.addLabel("Normal Walking Pattern")
      .setText("Normal Walking Pattern")
      .setPosition(1050,800)
      .setColorValue(0)
      .setFont(createFont("Cambria",50));
      break;
    }
  }
}
