void setupMainButtons(){
  cp5 = new ControlP5(this);
  
  cp5.addButton("Space_Invader")     //button to select spaceInvader
    .setPosition(100, 50)  //x and y coordinates of upper left corner of button
    .setSize(400, 85)      //(width, height)
    .setFont(font)
  ;
  
  cp5.addButton("MainMenu")          // stops current game and goes back to main menu
  .setPosition(100,250)
    .setSize(300, 85)
    .setFont(font)
  ;
}

// button functions
void Space_Invader(){
  spaceInvaderSetup();
  // change boolean for the main draw() so it goes in and draw the game
}

void MainMenu(){
  
}
