void setupMainButtons(){
  cp5 = new ControlP5(this);
  
  gameSelectLbl = cp5.addLabel("gameSelectLbl")
    .setText("Select Game")
    .setPosition(width/2-250,0)
    .setColorValue(color(0,0,155))
    .setFont(createFont("Cambria",100))
    ;
  
  
  si = cp5.addButton("Space_Invader")     //button to select spaceInvader
    //.setPosition(100, 50)  //x and y coordinates of upper left corner of button
    .setPosition(width/2 - 200,height/2 -300)
    .setSize(400, 85)      //(width, height)
    .setFont(font)
  ;
  
  bb = cp5.addButton("Brick_Breaker")
    //.setPosition(100,250)
    .setPosition(width/2 - 200,height/2 -100)
    .setSize(400,85)
    .setFont(font)
  ;
  
  mm = cp5.addButton("MainMenu")          // stops current game and goes back to main menu
  //.setPosition(100,450)
    .setPosition(1500,1100)
    .setSize(400, 85)
    .setFont(font)
  ;
}

// button functions
void Space_Invader(){
  gameSelectLbl.hide();
  bb.hide();
  si.hide();
  spaceInvaderSetup();
  spaceInvaderOn = true;
}

void Brick_Breaker(){
  gameSelectLbl.hide();
  bb.hide();
  si.hide();
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
  gameSelectLbl.show();
  bb.show();
  si.show();
}
