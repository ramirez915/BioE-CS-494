import controlP5.*; // import ControlP5 library
import grafica.*;    // for graphing
import processing.sound.*;    // for music
import processing.serial.*;

Serial myPort;
ControlP5 cp5; //create ControlP5 object for the main menu buttons

ControlP5 numPadCp5;    // another CP5 object that will conatin all the buttons for the age input and the distance

StopWatchTimer watch = new StopWatchTimer();    // stopWatch
Textlabel watchVal;                          // label used to display time

PFont font;
float dataArr[] = new float[22];      // array that will store the data      // size determined by the number of data coming in from arduino
String valueFromArduino;  // value from the analog device
Blob[] blobs = new Blob[4];
float[] valueArr = new float[4];    // will contain practice values for heat map
float[] newVals = new float[4];     // new test values
int sec = -1;              // tells us what mode type were going into
int oldSec = -1;          // helps keep track of what sec we're on

boolean firstRun = true;      // used as a flag to set up section display only once


// ------------------------------------------------------------------------------------------------------------------------------------- section 1
// place table in the middle of the screen to display values
float mf = 0.0;    // blob[0]
float lf = 0.0;    // blob[1]
float mm = 0.0;    // blob[2]
float heelSens = 0.0;  // blob[3]
float stepLen = 0.0;
float strideLen = 0.0;
float cadence = 0.0;
float walkingSpd = 0.0;
int stepCount = 0;
boolean twoMin = false;
boolean noValues = true;

Textlabel sec1Inst;
//---------------------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------------------------------------------------- section 2
// display images corresponding to step pattern
/*
recieving flags form arduino so just display image
0 = still waiting      will display all 5 parts and will have a ? to display that. images will update live.... 1 2 3 4 5
1 = heel                                                                                                       ? ? ? ? ?
2 = tiptoeing                                                                                                  I O N
3 = intoeing
4 = out toeing
5 = normal
*/

ControlP5 sec2Cp5;
Textlabel currFrame;

Textlabel qmarkLbl;
Textlabel mfn;
float mfnVal;

int timeFrames[] = new int[5];  // contains all the time frames
float MFNs[] = new float[5];
PImage footTypes[] = new PImage[6];    // contains all images to be displayed
PImage qmark;
PImage heelImg;
PImage tiptoe;
PImage intoe;
PImage outtoe;
PImage normal;
PImage arrowLeft;
PImage arrowRight;
PImage arrowUp;
PImage arrowDown;
PImage greenArrowDown;
PImage greenArrowUp;
PImage greenArrowLeft;
PImage greenArrowRight;



int testCount = 0;        // for testing the live update of the time frames

// place the x and y pos of the images in arrays
int[] x = new int[5];
int[] y = new int[5];

//---------------------------------------------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------------------------------------------------------------- section 3
// have moving image in direction of travel determined by dir
// have a matrix in the middle and move image depending on where we're going
// +1 = up, -1 = down, +0.5 = right, -0.5 = left
float dir = 0.0;
float[] testDir = new float[5];

ControlP5 sec3Cp5;                // sec3 labels
Textlabel sec3Lbl;
Textlabel up;
Textlabel right;
Textlabel down;
Textlabel left;

//----------------------------------------------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------------------------------------------------------------- section 4
// used to display user health
int health = -1;          // -1 by default
ControlP5 sec4Cp5;
Textlabel healthLbl;
Textlabel notHealthLbl;
Textlabel waitingLbl;
Textlabel sec4Inst;

//--------------------------------------------------------------------------------------------------------------------------------

PShape foot;

void setup(){
  fullScreen();
  //size(2000, 1200);    //window size, (width, height)  1200
  
  
  //colorMode(HSB);
  background(0,100,100);
  blobs[0] = new Blob(200,200);      // mf
  blobs[1] = new Blob(360,400);      //lf
  blobs[2] = new Blob(160,550);      //mm
  blobs[3] = new Blob(230,1000);     //heel
  
  // place values from sensors here*******************
  valueArr[0] = 10;
  valueArr[1] = 5;
  valueArr[2] = 20;
  valueArr[3] = 100;
  
  // values that will be used for practice second values
  newVals[0] = 100;
  newVals[1] = 20;
  newVals[2] = 0;
  newVals[3] = 0;
  
  //sec 2 variables
  setupSec2();
 
  // test sec 3
  testDir[0] = 0.0;
  testDir[1] = 1.0;
  testDir[2] = -1.0;
  testDir[3] = 0.5;
  testDir[4] = -0.5;
  
  //setup keypad
  setupKeypad();
  hideKeypad();
  
  // sec4 set up
  sec4setup();
  
  drawFoot();
  
  printArray(Serial.list());   //prints all available serial ports
  //String portName = Serial.list()[0];    // gets port number of arduino      *************************************************** change this to the index where the arduino is connected
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
  cp5 = new ControlP5(this);
  font = createFont("Arial", 20);    // custom fonts for buttons and title
  
  cp5.addButton("Walking_Stats")     //"red" is the name of button
    .setPosition(1600, 50)  //x and y coordinates of upper left corner of button
    .setSize(220, 70)      //(width, height)
    .setFont(font)
  ;
  
  cp5.addButton("sec2")
    .setPosition(1600,150)
    .setSize(120, 70)
    .setFont(font)
  ;
  
  cp5.addButton("sec3")
  .setPosition(1600,250)
    .setSize(120, 70)
    .setFont(font)
  ;
  
  cp5.addButton("sec4")
  .setPosition(1600,350)
    .setSize(120, 70)
    .setFont(font)
  ;
  
  cp5.addButton("Main_Menu")     //"alloff" is the name of button
    .setPosition(1600, 450)  //x and y coordinates of upper left corner of button
    .setSize(150, 70)      //(width, height)
    .setFont(font)
  ;
  
  watchVal = cp5.addTextlabel("watchVal")
   .setText("TIME")
   .setPosition(1700,900)
   .setColorValue(color(225,0,0))
   .setFont(createFont("Cambria",50))
   .show()
   ;
  
  setDataArrZeros();
}  // end of setup

void draw(){  //same as loop in arduino
  //get data from serial event then draw on heat map
  
  if(sec == 1){
    if(firstRun){
      displaySec1Tbl();
      firstRun = false;
      oldSec = 1;
      //timer.reset();
    }
    else{
      if(!twoMin){
        drawHeatMap();
        waitingLbl.show();
      }
    }
    
    //update watch time on screen
    int time= watch.second();
    watchVal.setValue(Integer.toString((time))+"s");
    watchVal.show();
    
    println("time " + time);
    if(time == 120){
      twoMin = true;
    }
    if(twoMin){
      waitingLbl.hide();
      showKeypad();
      sec1Inst.show();
      displaySec1Tbl();
    }
    setDataArrZeros();
  }
  
  else if(sec == 2){
    if(firstRun){
      displaySec2Tbl();
      firstRun = false;
      oldSec = 2;
    }
    else{
      updateSec2Tbl(1);
      //------------------------------------------------ testing image change
      println("wait for update");
      timeFrames[testCount] = int(random(1,6));
      testCount++;
      if(testCount == 5){
        testCount = 0;
      }
      delay(1000);
      //--------------------------------------------------------------
    }
  }
  
  else if(sec == 3){
    if(firstRun){
      displaySec3Text();
      firstRun = false;
      oldSec = 3;
    }
    else{
      updateSec3(dir);
      //------------------------------------------ testing moving image (actual dir value will be updated in the serialEvent
      dir = testDir[int(random(0,5))];
      delay(1000);
      //----------------------------------------------------
    }
  }
  
  else if(sec == 4){
    if(firstRun){
      showKeypad();
      sec4Inst.show();
      firstRun = false;
      oldSec = 4;
    }
    // do what is meant to do in sec 4
    else{
      if(health == 1){
        waitingLbl.hide();
        healthLbl.show();
      }
      else if(health == 0){
        notHealthLbl.show();
      }
      else{
        waitingLbl.show();
      }
    }
  }
  // resets any given mode
  else if(sec == -2){
    resetGivenMode(oldSec);
    oldSec = -1;
  }
}

//lets add some functions to our buttons
//so whe you press any button, it sends perticular char over serial port

void Walking_Stats(){
  //myPort.write('1');
  sec = 1;
  println("Walking Stats");
}

void sec2(){
  //myPort.write('2');
  sec = 2;
  println("sec2");
}

void sec3(){
  //myPort.write('3');
  sec = 3;
  println("sec3");
}

void sec4(){
  //myPort.write('4');
  sec = 4;
  println("sec4");
}
void Main_Menu(){
  sec = -2;
  testCount = 0;
  //myPort.write('5');
  println("exiting");
  hideKeypad();
}

//// checks what is being printed by the micro controller
//void serialEvent (Serial myPort) {
//  // check for incoming numbers on the serial monitor
//  if (myPort.available() >= 0) {
//    valueFromArduino = myPort.readStringUntil('\n');
    
//    try{
//      setDataArrZeros();
//      dataArr = float(split(valueFromArduino,"-"));
//      println(valueFromArduino);
//      //should have 22 values from arduino
////sec-mf-lf-mm-heel-stepLen-strideLen-cadence-walkingSpeed-stepCount-timeWin0-MFN0-timeWin1-MFN1-timeWin2-MFN2-timeWin3-MFN3-timeWin4-MFN4-dir-health
//      if(dataArr.length == 22){
//        int sec = int(dataArr[0]);
        
//        // parse out data according to section
//        if(sec == 1){
//          setSec1Data(dataArr);
//          println("sec1");
//          //delay(100);
//        }
//        else if(sec == 2){
//          setSec2Data(dataArr);
//          println("sec2");
//        }
//        else if(sec == 3){
//          dir = dataArr[20];
//          println("dir: " + dir);
//        }
//        else if(sec == 4){
//          health = int(dataArr[21]);
//          println("health is " + health);
//        }
//      }
//      setDataArrZeros();
//    }catch(RuntimeException e){
//      e.printStackTrace();
//    }
//  }
//}


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

void resetValues(){
  for(Blob b: blobs){
    b.reset();
  }
  sec = -1;
}


void resetGivenMode(int oldSec){
  switch(oldSec){
    //resetting sec 1
    case 1:
      resetSec1();
      twoMin = false;
      break;
    case 2:
      resetSec2();
      break;
    case 3:
      resetSec3();
      break;
    case 4:
      resetSec4();
      break;
  }
  watch.stop();
  watch.reset();
  watchVal.setValue("TIME");
  watchVal.hide();
}
