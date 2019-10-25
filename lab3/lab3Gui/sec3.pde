//size of GUI size(2000, 1200);
// +1 = up, -1 = down, +0.5 = right, -0.5 = left

//displays data for section 2 as table
void displaySec3Text(){
  //text("DIRECTION OF MOVEMENT", 800, 30);  // ("text", x coordinate, y coordinate)
  sec3Lbl = sec3Cp5.addLabel("sec3Lbl")
    .setText("Direction of Movement")
    .setPosition(800,30)
    .setColorValue(color(255))
    .setFont(createFont("Cambria",50))
    .show();
    
  //text("UP",1000,100);
  up = sec3Cp5.addLabel("up")
    .setText("UP")
    .setPosition(1000,100)
    .setColorValue(color(255))
    .setFont(createFont("Cambria",50))
    .show();
    
  //text("RIGHT",1600,550);
  right = sec3Cp5.addLabel("right")
    .setText("RIGHT")
    .setPosition(1500,550)
    .setColorValue(color(255))
    .setFont(createFont("Cambria",50))
    .show();
    
  //text("DOWN",1000,1100);
  down = sec3Cp5.addLabel("down")
    .setText("DOWN")
    .setPosition(960,1000)
    .setColorValue(color(255))
    .setFont(createFont("Cambria",50))
    .show();
    
  //text("LEFT",500,550);
  left = sec3Cp5.addLabel("left")
    .setText("LEFT")
    .setPosition(450,550)
    .setColorValue(color(255))
    .setFont(createFont("Cambria",50))
    .show();
    ;
    
    arrowLeft = loadImage("white_arrow.png");
    image(arrowLeft,600,500);
    
    
    
    arrowRight = loadImage("white_arrowright.png");
    image(arrowRight,1103,500);
    
    
    
    arrowUp = loadImage("white_arrowup.png");
    image(arrowUp,970,170);
    
    
    arrowLeft = loadImage("white_arrowdown.png");
    image(arrowLeft,970,600);
}


void updateSec3(float dir){
  //reset canvas
  background(0,100,255);
  displaySec3Text();
  // standing still
  image(footTypes[5],973,500,width/15,width/15);
  // up
  if(dir == 1.0){
    up.setColorValue(color(0,255,0));
    greenArrowUp = loadImage("green_arrowup.png");
    image(greenArrowUp,970,170);
  }
  
  // right
  else if(dir == 0.5){
    right.setColorValue(color(0,255,0));
    greenArrowRight = loadImage("green_arrowright.png");
    image(greenArrowRight,1103,500);
  }
  //down
  else if(dir == -1.0){
    down.setColorValue(color(0,255,0));
    greenArrowDown = loadImage("green_arrowdown.png");
    image(greenArrowDown,970,600);
  }
  //left
  else if(dir == -0.5){
    left.setColorValue(color(0,255,0));
    greenArrowLeft = loadImage("green_arrowleft.png");
    image(greenArrowLeft,600,500);
  }
}

void resetSec3(){
  background(0,100,255);
  firstRun = true;
  sec3Cp5.hide();
}
