void setupMainButtons(){
  cp5 = new ControlP5(this);
  
  mainLbl = cp5.addLabel("mainLbl")
    .setText("T9")
    .setPosition(900,50)
    .setColorValue(color(0,0,155))
    .setFont(createFont("Cambria",100))
    ;
  
  mm = cp5.addButton("MainMenu")          // stops current game and goes back to main menu
    .setPosition(100,200)
    .setSize(400, 85)
    .setFont(font)
    ;
  
  t9 = cp5.addButton("t9")
    .setPosition(100,320)
    .setSize(400,85)
    .setFont(font)
    ;
    
  userInput = cp5.addLabel("user chars")
    .setPosition(width/2,height/2)
    .setValue(inputStr)
    .setColorValue(color(0,0,155))
    .setFont(createFont("Cambria",50))
    ;
    
  watchLbl = cp5.addLabel("watch label")
    .setPosition(width/2 - 200,height/2 - 200)
    .setText("Watch")
    .setColorValue(color(0,0,155))
    .setFont(createFont("Cambria",50))
    .hide()
    ;
}

void MainMenu(){
  counter = 0;
  dataArr[0] = "x";
  
  t9On = false;
}

void t9(){
  t9On = true;
  println("t9 pressed");
}
