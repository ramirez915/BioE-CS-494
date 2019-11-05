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
  text("Step Length",750,100);
  text("Stride Length",750,300);
  text("Cadence",750,500);
  text("Walking Speed",750,700);
  text("Step Count",750,900);
  
  // values
  text("0.41m",900,100);
  text("0.83m",900,300);
  text("263.41m",850,500);
  text("108",900,700);
  text("516",900,900);
}

void updateValues(){
  displaySec1Tbl();
}

//reset
void resetSec1(){
  background(100);
  firstRun = true;
}

// draw heat map
void drawHeatMap(){
  loadPixels();
  
  int i = 0;      // counter for test values
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      int index = x + y * width;
      float sum = 0;
      for (Blob b : blobs) {
        float d = dist(x, y, b.pos.x, b.pos.y);
        float w = valueArr[i];                  // get values from valueArr to display
        sum += 100 * w / d;
        //sum += 100 * b.r / d;
        i++;    // go to next value in array
      }
      i = 0; // start from the beginning
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
