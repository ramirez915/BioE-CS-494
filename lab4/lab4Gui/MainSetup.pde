void setupMainButtons(){
  cp5 = new ControlP5(this);
  
  cp5.addButton("Space_Invader")     //button to select spaceInvader
    .setPosition(100, 50)  //x and y coordinates of upper left corner of button
    .setSize(400, 85)      //(width, height)
    .setFont(font)
  ;
  
  cp5.addButton("Brick_Breaker")
    .setPosition(100,250)
    .setSize(400,85)
    .setFont(font)
  ;
  
  cp5.addButton("MainMenu")          // stops current game and goes back to main menu
  .setPosition(100,450)
    .setSize(300, 85)
    .setFont(font)
  ;
}

// button functions
void Space_Invader(){
  spaceInvaderSetup();
  spaceInvaderOn = true;
}

void Brick_Breaker(){
  brickBreakerSetup();
  brickBreakerOn = true;
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
}
