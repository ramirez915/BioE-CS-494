void setupMainButtons(){
  cp5 = new ControlP5(this);
  
  mainLbl = cp5.addLabel("mainLbl")
    .setText("Keyboard")
    .setPosition(900,50)
    .setColorValue(color(0,0,0))
    .setFont(createFont("Cambria",100))
    ;
  
  mm = cp5.addButton("MainMenu")          // stops current game and goes back to main menu
    .setPosition(100,height/2-300)
    .setSize(400, 85)
    .setFont(font)
    ;
  
  type = cp5.addButton("type")
    .setPosition(100,height/2-150)
    .setSize(400,85)
    .setFont(font)
    ;
    
  userInput = cp5.addLabel("user chars")
    .setPosition(width/2-600,height/2+100)
    .setValue(inputStr)
    .setColorValue(color(0,0,0))
    .setFont(createFont("Cambria",120))
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

void type(){
  t9On = true;
  println("t9 pressed");
}
