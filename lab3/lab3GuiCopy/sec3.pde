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
    ;
  //text("UP",1000,100);
  up = sec3Cp5.addLabel("up")
    .setText("UP")
    .setPosition(1000,100)
    .setColorValue(color(255))
    .setFont(createFont("Cambria",50))
    .show();
    ;
  //text("RIGHT",1600,550);
  right = sec3Cp5.addLabel("right")
    .setText("RIGHT")
    .setPosition(1600,550)
    .setColorValue(color(255))
    .setFont(createFont("Cambria",50))
    .show();
    ;
  //text("DOWN",1000,1100);
  down = sec3Cp5.addLabel("down")
    .setText("DOWN")
    .setPosition(1000,1100)
    .setColorValue(color(255))
    .setFont(createFont("Cambria",50))
    .show();
    ;
  //text("LEFT",500,550);
  left = sec3Cp5.addLabel("left")
    .setText("LEFT")
    .setPosition(500,550)
    .setColorValue(color(255))
    .setFont(createFont("Cambria",50))
    .show();
    ;
}

void updateSec3(float dir){
  //reset canvas
  background(100);
  displaySec3Text();
  // standing still
  if(dir == 0.0){
    image(footTypes[5],900,425,width/8,width/8);
  }
  // up
  else if(dir == 1.0){
    image(footTypes[5],900,200,width/8,width/8);
  }
  // right
  else if(dir == 0.5){
    image(footTypes[5],1300,450,width/8,width/8);
  }
  //down
  else if(dir == -1.0){
    image(footTypes[5],900,800,width/8,width/8);
  }
  //left
  else if(dir == -0.5){
    image(footTypes[5],600,450,width/8,width/8);
  }
}

void resetSec3(){
  background(100);
  firstRun = true;
  sec3Cp5.hide();
}
