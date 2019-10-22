void setupKeypad(){
  numPadCp5 = new ControlP5(this);
  PFont f = createFont("Cambria", 20);
   numPadCp5.addButton("_0_")
    .setPosition(100,50)
    .setSize(100,70)
    .setFont(f)
  ;
  numPadCp5.addButton("_1_")
    .setPosition(250,50)
    .setSize(100,70)
    .setFont(f)
  ;
  numPadCp5.addButton("_2_")
    .setPosition(400,50)
    .setSize(100,70)
    .setFont(f)
  ;
  
  numPadCp5.addButton("_3_")
    .setPosition(550,50)
    .setSize(100,70)
    .setFont(f)
  ;
  
  numPadCp5.addButton("_4_")
    .setPosition(700,50)
    .setSize(100,70)
    .setFont(f)
  ;
  
  numPadCp5.addButton("_5_")
    .setPosition(850,50)
    .setSize(100,70)
    .setFont(f)
  ;
  
  numPadCp5.addButton("_6_")
    .setPosition(1000,50)
    .setSize(100,70)
    .setFont(f)
  ;
  
  numPadCp5.addButton("_7_")
    .setPosition(100,150)
    .setSize(100,70)
    .setFont(f)
  ;
  numPadCp5.addButton("_8_")
    .setPosition(250,150)
    .setSize(100,70)
    .setFont(f)
  ;
  
  numPadCp5.addButton("_9_")
    .setPosition(400,150)
    .setSize(100,70)
    .setFont(f)
  ;
  
  numPadCp5.addButton("Done")
    .setPosition(1200,50)
    .setSize(50,70)
    .setFont(f)
  ;
}

void showKeypad(){
  background(51);
  numPadCp5.show();
}

void hideKeypad(){
  background(51);
  numPadCp5.hide();
}


//-------------------------------------------------------------------- button functions
void _0_(){
  //myPort.write('0');
  println("user input 0");
}

void _1_(){
  //myPort.write('1');
  println("user input 1");
}

void _2_(){
  //myPort.write('2');
  println("user input 2");
}

void _3_(){
  //myPort.write('3');
  println("user input 3");
}

void _4_(){
  //myPort.write('4');
  println("user input 4");
}

void _5_(){
  //myPort.write('5');
  println("user input 5");
}

void _6_(){
  //myPort.write('6');
  println("user input 6");
}

void _7_(){
  //myPort.write('7');
  println("user input 7");
}

void _8_(){
  myPort.write('8');
  println("user input 8");
}

void _9_(){
  myPort.write('9');
  println("user input 9");
}

void Done(){
  //myPort.write('x');  // sends the 'x' to signal that we're done getting the age
  println("done getting age: 24");
  hideKeypad();
}

//----------------------------------------------------------------------------------------- end of button functions
