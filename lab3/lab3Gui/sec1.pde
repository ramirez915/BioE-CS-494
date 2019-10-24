//size of GUI size(2000, 1200);

/*
float stepLen = 0.0;
float strideLen = 0.0;
float cadence = 0.0;
float walkingSpd = 0.0;
int stepCount = 0;
*/

// display the text
void displaySec1Tbl(){
  drawFoot();
  // labels
  text("Step Length",500,100);
  text("Stride Length",500,300);
  text("Cadence",500,500);
  text("Walking Speed",500,700);
  text("Step Count",500,900);
  
  // values
  text(stepLen,900,100);
  text(strideLen,900,300);
  text(cadence,850,500);
  text(walkingSpd,900,700);
  text(stepCount,900,900);
}

void updateValues(){
  displaySec1Tbl();
}

//reset
void resetSec1(){
  background(0,100,255);
  firstRun = true;
  waitingLbl.hide();
  
}

// draw heat map
void drawHeatMap(){
  loadPixels();
  
  //int i = 0;      // counter for test values
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      int index = x + y * width;
      float sum = 0;
      for (Blob b : blobs) {
        float d = dist(x, y, b.pos.x, b.pos.y);
        //float w = valueArr[i];                  // get values from valueArr to display
        //sum += 100 * w / d;
        sum += 100 * b.r / d;                      // updates depending on the radius
        //i++;    // go to next value in array
      }
      //i = 0; // start from the beginning
      pixels[index] = color(sum, 255, 255);
    }
  }
  
  updatePixels();
  
  updateValues();
  //setDataArrZeros();
  
  for(Blob b: blobs){
    b.update();
    b.show();
  }
  updateValues();
}
