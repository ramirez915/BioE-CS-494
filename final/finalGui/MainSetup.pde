void setupMainButtons(){
  cp5 = new ControlP5(this);
  
  mainLbl = cp5.addLabel("mainLbl")
    .setText("T9")
    .setPosition(width/2-250,0)
    .setColorValue(color(0,0,155))
    .setFont(createFont("Cambria",100))
    ;
  
  mm = cp5.addButton("MainMenu")          // stops current game and goes back to main menu
  //.setPosition(100,450)
    .setPosition(1500,1100)
    .setSize(400, 85)
    .setFont(font)
  ;
}

void MainMenu(){
  // if space invader game was being played
  if(spaceInvaderOn){
    spaceInvaderReset();
    spaceInvaderOn = false;
  }
  else if(brickBreakerOn){
    brickBreakerReset();
    brickBreakerOn = false;
  }
  C1 = false;
  C2 = false;
  C3 = false;
  counter = 0;
  dataArr[0] = "x";
  gameSelectLbl.show();
  bb.show();
  si.show();
}
