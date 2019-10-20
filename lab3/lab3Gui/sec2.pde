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
  intoe = loadImage("intoeing.jpg");
  outtoe = loadImage("outtoe.jpg");
  normal = loadImage("normal.png");
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
  text("5 FRAME", 1000, 30);  // ("text", x coordinate, y coordinate)
  text("1",800,100);
  text("2",1300,100);
  text("3",800,700);
  text("4",1300,700);
  text("5",1750,700);
}

// resets the canvas after sec 2 is done
void resetSec2(){
  background(51);
  firstRun = true;
  for(int i = 0; i < 5; i++){
    timeFrames[i] = 0;
    MFNs[i] = 0;
  }
}

// updates the table according to what is being read from the arduino. so it all depends on what was recognized
// use the timeFrame[]
void updateSec2Tbl(int timeFrame[]){
  int counter = 0;
  for(int i: timeFrame){
    // place correspinding image depending on the value of the timeframe
    switch(i){
      // ? mark
      case 0:
        image(footTypes[0],x[counter],y[counter],width/6,width/6);
        text(MFNs[counter],x[counter]-100,y[counter] + 50);
        counter++;
        break;
      // heel
      case 1:
        image(footTypes[1],x[counter],y[counter],width/6,width/6);
        text(MFNs[counter],x[counter]-100,y[counter] + 50);
        counter++;
        break;
      case 2:
        image(footTypes[2],x[counter],y[counter],width/6,width/6);
        text(MFNs[counter],x[counter]-100,y[counter] + 50);
        counter++;
        break;
      case 3:
        image(footTypes[3],x[counter],y[counter],width/6,width/6);
        text(MFNs[counter],x[counter]-100,y[counter] + 50);
        counter++;
        break;
      case 4:
        image(footTypes[4],x[counter],y[counter],width/6,width/6);
        text(MFNs[counter],x[counter]-100,y[counter] + 50);
        counter++;
        break;
      case 5:
        image(footTypes[5],x[counter],y[counter],width/6,width/6);
        text(MFNs[counter],x[counter]-100,y[counter] + 50);
        counter++;
        break;
    }
  }
}
