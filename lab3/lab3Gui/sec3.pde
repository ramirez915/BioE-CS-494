//size of GUI size(2000, 1200);
// +1 = up, -1 = down, +0.5 = right, -0.5 = left

//displays data for section 2 as table
void displaySec3Text(){
  text("DIRECTION OF MOVEMENT", 800, 30);  // ("text", x coordinate, y coordinate)
  text("UP",1000,100);
  text("RIGHT",1600,550);
  text("DOWN",1000,1100);
  text("LEFT",500,550);
}

void updateSec3(float dir){
  //reset canvas
  background(51);
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
}
