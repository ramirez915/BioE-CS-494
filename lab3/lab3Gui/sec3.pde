//size of GUI size(2000, 1200);
// +1 = up, -1 = down, +0.5 = right, -0.5 = left

//displays data for section 2 as table
void displaySec3Text(){
  sec3Cp5 = new ControlP5(this);
  
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
    .setPosition(1600,550)
    .setColorValue(color(255))
    .setFont(createFont("Cambria",50))
    .show();
    
  //text("DOWN",1000,1100);
  down = sec3Cp5.addLabel("down")
    .setText("DOWN")
    .setPosition(1000,1100)
    .setColorValue(color(255))
    .setFont(createFont("Cambria",50))
    .show();
    
  //text("LEFT",500,550);
  left = sec3Cp5.addLabel("left")
    .setText("LEFT")
    .setPosition(500,550)
    .setColorValue(color(255))
    .setFont(createFont("Cambria",50))
    .show();
}

void updateSec3(float dir){
  //reset canvas
  background(0,100,255);
  displaySec3Text();
  // standing still
  if(dir == 0.0){
    image(footTypes[5],900,425,width/10,width/10);
  }
  // up
  else if(dir == 1.0){
    image(footTypes[5],900,200,width/10,width/10);
    up.setColorValue(color(0,255,0));
  }
  // right
  else if(dir == 0.5){
    image(footTypes[5],1300,450,width/10,width/10);
    right.setColorValue(color(0,255,0));
  }
  //down
  else if(dir == -1.0){
    image(footTypes[5],900,800,width/10,width/10);
    down.setColorValue(color(0,255,0));
  }
  //left
  else if(dir == -0.5){
    image(footTypes[5],600,450,width/10,width/10);
    left.setColorValue(color(0,255,0));
  }
}

void resetSec3(){
  background(0,100,255);
  firstRun = true;
  sec3Cp5.hide();
}
