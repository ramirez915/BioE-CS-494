//size of GUI size(2000, 1200);

void setupSec2(){
  // setting up default time frames
  for(int i = 0; i < 5; i++){
    timeFrames[i] = 0;
    MFNs[i] = 0;
  }
  // loading images to be placed in array
  qmark = loadImage("qmark.jpg");
  heelImg = loadImage("heelImg.jpg");
  tiptoe = loadImage("tiptoe.jpg");
  intoe = loadImage("In-toeing.jpg");
  outtoe = loadImage("Out toeing.jpg");
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
  sec2Cp5 = new ControlP5(this);
  //text("5 FRAME", 1000, 30);  // ("text", x coordinate, y coordinate)
  currFrame = sec2Cp5.addLabel("curr Frame")
    .setText("Current Walking Pattern")
    .setPosition(1000,30)
    .setColorValue(color(255,255,0))
    .setFont(createFont("Cambria",50))
    .show();
    ;
}

// resets the canvas after sec 2 is done
void resetSec2(){
  background(51);
  firstRun = true;
  for(int i = 0; i < 5; i++){
    timeFrames[i] = 0;
    MFNs[i] = 0;
  }
  sec2Cp5.hide();
}

// updates the table according to what is being read from the arduino. so it all depends on what was recognized
// can assume that were getting the walking type
void updateSec2Tbl(int walkingType){
  // place correspinding image depending on the value of the timeframe 
  switch(walkingType){
    // ? mark
    case 0:
      image(footTypes[0],width/2,height/2,width/6,width/6);
      break;
    // heel
    case 1:
      image(footTypes[1],width/2,height/2,width/6,width/6);
      break;
    // tip toe
    case 2:
      image(footTypes[2],width/2,height/2,width/6,width/6);
      break;
    //in toe
    case 3:
      image(footTypes[3],width/2,height/2,width/6,width/6);
      break;
    // out toe
    case 4:
      image(footTypes[4],width/2,height/2,width/6,width/6);
      break;
    // normal
    case 5:
      image(footTypes[5],width/2,height/2,width/6,width/6);
      break;
    }
    
    mfn = sec2Cp5.addLabel("mfnlbl")
        .setText(str(mfnVal))
        .setPosition(800,height/2 - 50)
        .setColorValue(color(255))
        .setFont(createFont("Cambria",50))
        .show();
        ;
}
