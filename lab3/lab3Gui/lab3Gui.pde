import controlP5.*; // import ControlP5 library
import grafica.*;    // for graphing
import processing.sound.*;    // for music
import processing.serial.*;

Serial myPort;
ControlP5 cp5; //create ControlP5 object
PFont font;
int x1 = 0;    // starting position of the graph

float dataArr[];      // array that will store the data
String valueFromArduino;  // value from the analog device
Blob[] blobs = new Blob[4];
float[] valueArr = new float[4];    // will contain practice values for heat map
float[] newVals = new float[4];

PShape foot;

void setup(){
  size(2000, 1200);    //window size, (width, height)  1200
  
  drawFoot();
  
  colorMode(HSB);
  blobs[0] = new Blob(200,200);
  blobs[1] = new Blob(360,400);
  blobs[2] = new Blob(160,550);
  blobs[3] = new Blob(230,1000);
  
  // place values from sensors here*******************
  valueArr[0] = 0;
  valueArr[1] = 0;
  valueArr[2] = 20;
  valueArr[3] = 100;
  
  // values that will be used for practice second values
  newVals[0] = 100;
  newVals[1] = 20;
  newVals[2] = 0;
  newVals[3] = 0;
  
  
  printArray(Serial.list());   //prints all available serial ports
  //String portName = Serial.list()[2];    // gets port number of arduino      *************************************************** change this to the index where the arduino is connected
  //myPort = new Serial(this, portName, 115200);                                //************************************** check whats being printed below when runnning this 
                                                                              //************************************** to see the indecies of the COM ports
                                                                              //************************************ then verify where the arduino is connected in the arduino IDE
                                                                              //************************************ and change the index to the port where the arduino is connected
                                                                              //*** ex: arduino IDE says the arduino is connected to port COM 13
                                                                              //*** when I run this code the printed ports are [0] "COM3", [1] "COM4", [2] "COM13"
                                                                              //*** so I change line 29 to say
                                                                              //*** String portName = Serial.list()[2];
  
  // starts serialEvent function when a newline character is read
  //myPort.bufferUntil('\n');
    
  // adds buttons to the window
  //cp5 = new ControlP5(this);
  //font = createFont("Arial", 20);    // custom fonts for buttons and title
  
  //cp5.addButton("Display")     //"red" is the name of button
  //  .setPosition(100, 50)  //x and y coordinates of upper left corner of button
  //  .setSize(120, 70)      //(width, height)
  //  .setFont(font)
  //;
  
  //cp5.addButton("Walking Analysis")
  //  .setPosition(100,150)
  //  .setSize(120, 70)
  //  .setFont(font)
  //;
  
  //cp5.addButton("MainMenu")     //"alloff" is the name of button
  //  .setPosition(100, 350)  //x and y coordinates of upper left corner of button
  //  .setSize(120, 70)      //(width, height)
  //  .setFont(font)
  //;
  
  
}

void draw(){  //same as loop in arduino
  
  //lets give title to our window
  //fill(0);               //text color (r, g, b)
  background(51);
  loadPixels();
  
  println("1");
  int i = 0;      // counter for 
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      int index = x + y * width;
      float sum = 0;
      for (Blob b : blobs) {
        float d = dist(x, y, b.pos.x, b.pos.y);
        float w = valueArr[i];                  // get values from valueArr to display
        sum += 100 * w / d;
        i++;    // go to next value in array
      }
      i = 0; // start from the beginning
      pixels[index] = color(sum, 255, 255);
    }
  }
  
  updatePixels();
  drawFoot();

  for (Blob b : blobs) {
    b.update();
    b.show();
  }
  
  //***************************************** everything above this line works as intended
  println("pause");
  delay(2000);
  resetPixels();
  loadPixels();
  
  println("2");
  i = 0;      // counter for 
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      int index = x + y * width;
      float sum = 0;
      for (Blob b : blobs) {
        float d = dist(x, y, b.pos.x, b.pos.y);
        float w = newVals[i];                  // get values from valueArr to display
        sum += 100 * w / d;
        i++;    // go to next value in array
      }
      i = 0; // start from the beginning
      pixels[index] = color(sum, 255, 255);
    }
  }
  
  updatePixels();
  drawFoot();

  for (Blob b : blobs) {
    b.update();
    b.show();
  }
  
  
  
  // POSITION THIS IN ANOTHER SPOT
  //textFont(font);
  //text("FITNESS CONTROL", 80, 30);  // ("text", x coordinate, y coordinate)
  
}

//lets add some functions to our buttons
//so whe you press any button, it sends perticular char over serial port

void Display(){
  //myPort.write('f');
  println("d");
}

void Walking_Analysis(){
  //myPort.write('s');
  println("wa");
}

void MainMenu(){
  //myPort.write('a');
}

//// checks what is being printed by the micro controller
//void serialEvent (Serial myPort) {
//  // check for incoming numbers on the serial monitor
//  if (myPort.available() >= 0) {
//    valueFromArduino = myPort.readStringUntil('\n');
    
//    try{
//      dataArr = float(split(valueFromArduino,"-"));
//      //println(valueFromArduino);
//      if(dataArr.length == 3){    // ----------------------------------------------------------------should have 6 values from arduino mode-color-ecg-resp-bpm-rRate
      
//      }
//    }catch(RuntimeException e){
//      e.printStackTrace();
//    }
//  }
//}






class Blob {

  PVector pos;
  float r;
  PVector vel;
  
  Blob(float x, float y) {
    pos = new PVector(x, y);
    vel = PVector.random2D();
    vel.mult(random(0, 0));
    r = 50; //random(10, 80);
  }

  void update() {
    pos.add(vel); 
    if (pos.x > width || pos.x < 0) {
      vel.x *= -1;
    }

    if (pos.y > height || pos.y < 0) {
      vel.y *= -1;
    }
  }

  void show() {
    noFill();
    stroke(0);
    strokeWeight(3);
    ellipse(pos.x, pos.y, r*2, r*2);
  }
}

void drawFoot(){
  noFill();
  strokeWeight(6);
  
  beginShape();
  curveVertex(124,610);
  curveVertex(124,610);
  curveVertex(92,546);
  curveVertex(74,486);
  curveVertex(56,406);
  curveVertex(46,302);
  curveVertex(72,180);
  curveVertex(110,92);
  curveVertex(184,36);
  curveVertex(280,28);
  curveVertex(352,80);
  curveVertex(408,166);
  curveVertex(444,258);
  curveVertex(446,368);
  curveVertex(442,480);
  curveVertex(418,574);
  curveVertex(382,666);
  curveVertex(376,742);
  curveVertex(392,812);
  curveVertex(390,880);
  curveVertex(380,952);
  curveVertex(350,1016);
  curveVertex(312,1062);
  curveVertex(260,1090);
  curveVertex(176,1090);
  curveVertex(128,1062);
  curveVertex(84,1014);
  curveVertex(60,952);
  curveVertex(52,890);
  curveVertex(64,822);
  curveVertex(86,754);
  curveVertex(108,714);
  curveVertex(122,674);
  curveVertex(124,610);
  curveVertex(124,610);
  endShape();
}


// supposed to reset pixels
void resetPixels(){
  loadPixels();
  int i = 0;      // counter for 
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      int index = x + y * width;
      float sum = 0;
      for (Blob b : blobs) {
        float d = dist(x, y, b.pos.x, b.pos.y);
        float w = newVals[i];                  // get values from valueArr to display
        sum += 100 * 0 / d;
        i++;    // go to next value in array
      }
      i = 0; // start from the beginning
      pixels[index] = color(sum, 255, 255);
    }
  }
  updatePixels();
}
