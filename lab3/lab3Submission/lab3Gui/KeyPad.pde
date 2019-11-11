void setupKeypad(){
  numPadCp5 = new ControlP5(this);
  PFont f = createFont("Cambria", 20);
  int bl = 150;    // button length
  int bh = 100;    // button height
  
   numPadCp5.addButton("_0_")
    .setPosition(900,650)
    .setSize(bl,bh)
    .setFont(f)
  ;
  numPadCp5.addButton("_1_")
    .setPosition(700,200)
    .setSize(bl,bh)
    .setFont(f)
  ;
  numPadCp5.addButton("_2_")
    .setPosition(900,200)
    .setSize(bl,bh)
    .setFont(f)
  ;
  
  numPadCp5.addButton("_3_")
    .setPosition(1100,200)
    .setSize(bl,bh)
    .setFont(f)
  ;
  
  numPadCp5.addButton("_4_")
    .setPosition(700,350)
    .setSize(bl,bh)
    .setFont(f)
  ;
  
  numPadCp5.addButton("_5_")
    .setPosition(900,350)
    .setSize(bl,bh)
    .setFont(f)
  ;
  
  numPadCp5.addButton("_6_")
    .setPosition(1100,350)
    .setSize(bl,bh)
    .setFont(f)
  ;
  
  numPadCp5.addButton("_7_")
    .setPosition(700,500)
    .setSize(bl,bh)
    .setFont(f)
  ;
  numPadCp5.addButton("_8_")
    .setPosition(900,500)
    .setSize(bl,bh)
    .setFont(f)
  ;
  
  numPadCp5.addButton("_9_")
    .setPosition(1100,500)
    .setSize(bl,bh)
    .setFont(f)
  ;
  
  numPadCp5.addButton("Done")
    .setPosition(1300,500)
    .setSize(bl,bh)
    .setFont(f)
  ;
}

void showKeypad(){
  background(0,100,255);
  numPadCp5.show();
}

void hideKeypad(){
  background(0,100,255);
  numPadCp5.hide();
}


//-------------------------------------------------------------------- button functions
void _0_(){
  userInputStr = userInputStr + "0";
  println("user input 0");
}

void _1_(){
  userInputStr = userInputStr + "1";
  println("user input 1");
}

void _2_(){
  userInputStr = userInputStr + "2";
  println("user input 2");
}

void _3_(){
  userInputStr = userInputStr + "3";
  println("user input 3");
}

void _4_(){
  userInputStr = userInputStr + "4";
  println("user input 4");
}

void _5_(){
  userInputStr = userInputStr + "5";
  println("user input 5");
}

void _6_(){
  userInputStr = userInputStr + "6";
  println("user input 6");
}

void _7_(){
  userInputStr = userInputStr + "7";
  println("user input 7");
}

void _8_(){
  userInputStr = userInputStr + "8";
  println("user input 8");
}

void _9_(){
  userInputStr = userInputStr + "9";
  println("user input 9");
}

void Done(){
  noUserInput = false;                    // done getting user input
  println("done getting age or userInputStr: " + userInputStr);
  hideKeypad();
  sec1Inst.hide();
  sec4Inst.hide();
}

//----------------------------------------------------------------------------------------- end of button functions
