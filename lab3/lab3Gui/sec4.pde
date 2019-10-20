//size of GUI size(2000, 1200);

void setupSec4(){
  numPadCp5 = new ControlP5(this);
  
  numPadCp5.addButton("_0_")
    .setPosition(200,50)
    .setSize(100,70)
    //.setFont(font)
  ;
  numPadCp5.addButton("_1_")
    .setPosition(300,50)
    .setSize(100,70)
    //.setFont(font)
  ;
  numPadCp5.addButton("_2_")
    .setPosition(400,50)
    .setSize(80,70)
    //.setFont(font)
  ;
  numPadCp5.addButton("Done")
    .setPosition(500,50)
    .setSize(50,70)
    //.setFont(font)
  ;
}

void _0_(){
  
}

void Done(){
  //myPort.write('x');  // sends the 'x' to signal that we're done getting the age
  println("done getting age");
  hideSec4Buttons();
}


void showSec4Buttons(){
  background(51);
  numPadCp5.show();
}

void hideSec4Buttons(){
  background(51);
  numPadCp5.hide();
}

void resetSec4(){
  background(100);
  hideSec4Buttons();
  firstRun = true;
}
