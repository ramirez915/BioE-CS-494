//size of GUI size(2000, 1200);

/*
float stepLen = 0.0;
float strideLen = 0.0;
float cadence = 0.0;
float walkingSpd = 0.0;
int stepCount = 0;
*/

void setupSec1(){
  sec1Cp5 = new ControlP5(this);
  color sec1Color = color(255,0,0);
  
//-------------------------------------------------- labels
  stepLenLbl = sec1Cp5.addLabel("stepLen")
    .setText("Step Length")
    .setPosition(500,1000)
    .setColorValue(sec1Color)
    .setFont(createFont("Cambria",50))
    //.show();
    .hide()
    ;
    
  strideLenLbl = sec1Cp5.addLabel("strideLen")
    .setText("Stride Length")
    .setPosition(500,1100)
    .setColorValue(sec1Color)
    .setFont(createFont("Cambria",50))
    //.show();
    .hide()
    ;
    
  cadenceLbl = sec1Cp5.addLabel("cadence")
    .setText("Cadence")
    .setPosition(500,1200)
    .setColorValue(sec1Color)
    .setFont(createFont("Cambria",50))
    //.show();
    .hide()
    ;
    
  walkingSpdLbl = sec1Cp5.addLabel("walkingSpd")
    .setText("Walking Speed")
    .setPosition(1200,1000)
    .setColorValue(sec1Color)
    .setFont(createFont("Cambria",50))
    //.show();
    .hide()
    ;
    
  stepCountLbl = sec1Cp5.addLabel("stepCount")
    .setText("Step Count")
    .setPosition(1200,1100)
    .setColorValue(sec1Color)
    .setFont(createFont("Cambria",50))
    //.show();
    .hide()
    ;
    
//------------------------------------------------------- values
  stepLenVal = sec1Cp5.addLabel("stepLenVal")
    .setText(Float.toString((0.0)))
    .setPosition(900,1000)
    .setColorValue(sec1Color)
    .setFont(createFont("Cambria",50))
    //.show();
    .hide()
    ;
    
  strideLenVal = sec1Cp5.addLabel("strideLenVal")
    .setText(Float.toString((0.0)))
    .setPosition(900,1100)
    .setColorValue(sec1Color)
    .setFont(createFont("Cambria",50))
    //.show();
    .hide()
    ;
    
  cadenceVal = sec1Cp5.addLabel("cadenceVal")
    .setText(Float.toString((0.0)))
    .setPosition(900,1200)
    .setColorValue(sec1Color)
    .setFont(createFont("Cambria",50))
    //.show();
    .hide()
    ;
    
  walkingSpdVal = sec1Cp5.addLabel("walkingSpdVal")
    .setText(Float.toString((0.0)))
    .setPosition(1600,1000)
    .setColorValue(sec1Color)
    .setFont(createFont("Cambria",50))
    //.show();
    .hide()
    ;
    
  stepCountVal = sec1Cp5.addLabel("stepCountVal")
    .setText(Integer.toString((0)))
    .setPosition(1600,1100)
    .setColorValue(sec1Color)
    .setFont(createFont("Cambria",50))
    //.show();
    .hide()
    ;
  
  sec1Inst = sec1Cp5.addTextlabel("sec1Inst")
    .setText("Please enter your total distance traveled")
    .setPosition(500,100)
    .setColorValue(sec1Color)
    .setFont(createFont("Cambria",50))
    .hide();
}

void showSec1Vals(){
  drawFoot();
  
  stepLenLbl.show();
  strideLenLbl.show();
  cadenceLbl.show();
  walkingSpdLbl.show();
  stepCountLbl.show();
  
  // reset values
  stepLenVal.setText(Float.toString(stepLen));
  strideLenVal.setText(Float.toString(strideLen));
  cadenceVal.setText(Float.toString(cadence));
  walkingSpdVal.setText(Float.toString(walkingSpd));
  stepCountVal.setText(Integer.toString(stepCount));
  stepLenVal.show();
  strideLenVal.show();
  cadenceVal.show();
  walkingSpdVal.show();
  stepCountVal.show();
}

void hideSec1Vals(){
  stepLenLbl.hide();
  strideLenLbl.hide();
  cadenceLbl.hide();
  walkingSpdLbl.hide();
  stepCountLbl.hide();
  
  stepLenVal.hide();
  strideLenVal.hide();
  cadenceVal.hide();
  walkingSpdVal.hide();
  stepCountVal.hide();
  
  sec1Inst.hide();
}

//reset
void resetSec1(){
  background(0,100,255);
  firstRun = true;
  noUserInput = true;
  calculate = true;
  stepLenVal.setText(Float.toString(0.0));
  strideLenVal.setText(Float.toString(0.0));
  cadenceVal.setText(Float.toString(0.0));
  walkingSpdVal.setText(Float.toString(0.0));
  stepCountVal.setText(Integer.toString(0));
  
  hideSec1Vals();
  
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
        //sum += 100 * b.r / d;                      // updates depending on the radius
        i++;    // go to next value in array
      }
      i = 0; // start from the beginning
      pixels[index] = color(sum, 255, 255);
    }
  }
  
  updatePixels();
  
  showSec1Vals();
  
  for(Blob b: blobs){
    b.update();
    b.show();
  }
  //showSec1Vals();        // not sure why this was here...
}
