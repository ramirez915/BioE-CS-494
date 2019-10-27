import controlP5.*; // import ControlP5 library
import grafica.*;    // for graphing
import processing.serial.*;

Serial myPort;
ControlP5 cp5; //create ControlP5 object for the main menu buttons

ControlP5 numPadCp5;    // another CP5 object that will conatin all the buttons for the age input and the distance

StopWatchTimer watch = new StopWatchTimer();    // stopWatch
int seconds = 0;
int min = 0;
Textlabel watchVal;                          // label used to display time

PFont font;
float dataArr[] = new float[4];      // array that will store the data      // size determined by the number of data coming in from arduino
String valueFromArduino;  // value from the analog device
Blob[] blobs = new Blob[4];
float[] valueArr = new float[4];    // will contain practice values for heat map
float[] newVals = new float[4];     // new test values
int sec = -1;              // tells us what mode type were going into
int oldSec = -1;          // helps keep track of what sec we're on

boolean firstRun = true;      // used as a flag to set up section display only once


// ------------------------------------------------------------------------------------------------------------------------------------- section 1
// place table in the middle of the screen to display values
float mfVal = 0.0;    // blob[0]
float lfVal = 0.0;    // blob[1]
float mmVal = 0.0;    // blob[2]
float heelVal = 0.0;  // blob[3]
float stepLen = 0.0;
float strideLen = 0.0;
float cadence = 0.0;
float walkingSpd = 0.0;
int stepCount = 0;
boolean twoMin = false;
boolean noUserInput = true;          // used to keep track if the user has finished giving info    //----------------------------------------------------------- should be used for sec 4
String userInputStr = "";            // distance will be converted to an int when needed           //---------------------------------------------------------- should be used for sec 4

boolean calculate = true;            // used to calcluate ONCE


Textlabel sec1Inst;
// labels
Textlabel stepLenLbl;
Textlabel strideLenLbl;
Textlabel cadenceLbl;
Textlabel walkingSpdLbl;
Textlabel stepCountLbl;

// values
Textlabel stepLenVal;
Textlabel strideLenVal;
Textlabel cadenceVal;
Textlabel walkingSpdVal;
Textlabel stepCountVal;

ControlP5 sec1Cp5;
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
boolean startWatch = true;              // starts timer for this part

//--------------------------------------------------------------------------------------------------------------------------------

PShape foot;

//------------------------------------------------------------------------grafica
GPlot mfPlot, lfPlot, mmPlot, heelPlot;
int x1 = 0;    // starting position of the graph

//-------------------------------------------------------------------

void setup(){
  //fullScreen();
  size(2000, 1200);    //window size, (width, height)  1200
  
  
  colorMode(HSB);                                // this needs to be ON so that the heat map works as intended        // not sure how I got the color of the background
  //background(0,100,100);
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
  
  //sec 1
  setupSec1();
  
  //sec 2 variables
  setupSec2();
  
  // setup sec 3
  sec3Cp5 = new ControlP5(this);
 
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
  font = createFont("MS Gothic", 35);    // custom fonts for buttons and title
  
  cp5.addButton("Walking_Stats")     //"red" is the name of button
    .setPosition(1800, 50)  //x and y coordinates of upper left corner of button
    .setSize(220, 70)      //(width, height)
    .setFont(createFont("MS Gothic",30))
  ;
  
  cp5.addButton("sec2")
    .setPosition(1800,150)
    .setSize(120, 70)
    .setFont(font)
  ;
  
  cp5.addButton("sec3")
  .setPosition(1800,250)
    .setSize(120, 70)
    .setFont(font)
  ;
  
  cp5.addButton("sec4")
  .setPosition(1800,350)
    .setSize(120, 70)
    .setFont(font)
    //.setColorActive(60); // color for mouse-over
  ;
  
  cp5.addButton("Main_Menu")     //"alloff" is the name of button
    .setPosition(1800, 450)  //x and y coordinates of upper left corner of button
    .setSize(150, 70)      //(width, height)
    .setFont(font)
  ;
  
  watchVal = cp5.addTextlabel("watchVal")
   .setText("TIME")
   .setPosition(1750,600)
   .setColorValue(color(225,0,0))
   .setFont(createFont("MS Gothic",50))
   .show()
   ;
   
   //---------------------------------------------------------------- grafica
   // Create a new plot and set its position on the screen
  // ecg and respPlots    regular plots to see signal from device
  mfPlot = new GPlot(this,510,50);        //graph positioned at 300,0
  mfPlot.setTitleText("MF Monitor");
  mfPlot.getXAxis().setAxisLabelText("x axis");
  mfPlot.getYAxis().setAxisLabelText("y axis");
  mfPlot.setDim(450,300);     // one graph alone is 1500,500
  mfPlot.setXLim(0,50);    // x axis must stay the same
  mfPlot.setYLim(0,260);    // y axis
  mfPlot.activateZooming(2.0,CENTER,CENTER);
  
  lfPlot = new GPlot(this,1100,50);        //graph positioned at 300,600
  lfPlot.setTitleText("LF Monitor");
  lfPlot.getXAxis().setAxisLabelText("x axis");
  lfPlot.getYAxis().setAxisLabelText("y axis");
  lfPlot.setDim(450,300);
  lfPlot.setXLim(0,50);    // x axis must stay at 300
  lfPlot.setYLim(0,260);
  lfPlot.activateZooming(2.0,CENTER,CENTER);
  
  mmPlot = new GPlot(this,510,480);        //graph positioned at 300,0
  mmPlot.setTitleText("MM Monitor");
  mmPlot.getXAxis().setAxisLabelText("x axis");
  mmPlot.getYAxis().setAxisLabelText("y axis");
  mmPlot.setDim(450,300);              // one graph alone is 1500,500
  mmPlot.setXLim(0,50);    // x axis must stay the same
  mmPlot.setYLim(0,260);    // y axis
  mmPlot.activateZooming(2.0,CENTER,CENTER);
  
  heelPlot = new GPlot(this,1100,480);        //graph positioned at 300,600
  heelPlot.setTitleText("HEEL Monitor");
  heelPlot.getXAxis().setAxisLabelText("x axis");
  heelPlot.getYAxis().setAxisLabelText("y axis");
  heelPlot.setDim(450,300);
  heelPlot.setXLim(0,50);    // x axis must stay at 300
  heelPlot.setYLim(0,260);
  heelPlot.activateZooming(2.0,CENTER,CENTER);
   
  //---------------------------------------------------------------------------------
   
  setDataArrZeros();
}  // end of setup

void draw(){  //same as loop in arduino
  //get data from serial event then draw on heat map
  
  //-------------------------------------------------------------------------------------------------------------------------------------------- SECTION 1
  if(sec == 1){
    if(firstRun){
      showSec1Vals();
      firstRun = false;
      oldSec = 1;
      watch.start();
    }
    if(!twoMin){
      drawHeatMap();
      plotData();
      waitingLbl.show();
      
      //update watch time on screen
      seconds = watch.second();
      min = watch.minute();
      watchVal.setValue(Integer.toString((min)) + " min " + Integer.toString((seconds))+"s");
      watchVal.show();
      println("time: " + min + " min " + seconds + "s");
    }
    
    // for testing... change min == 2 to seconds == 2 ro something low
    if(seconds == 5 && twoMin == false){        //-------------------------------------------------------------- if were at 2 minutes... min== 2
      twoMin = true;
      
      resetPlots();    // reset plots and hide them in order to have space for the number pad
      waitingLbl.hide();
      showKeypad();
      sec1Inst.show();
      delay(700);
    }
    if(twoMin){
      // get input
      // this if is only for testing
      if(noUserInput){
        println("waiting for distance");
      }

      //calculate the stuff with the distance when user input is acquired**************
      if(!noUserInput){          // if user input something by hitting done on the keypad
        println("done! distance is: " + int(userInputStr));
        
        if(calculate){     //---------------------------------------------------------------------------------------------------------------------------------- finish calcuations******
          
          calculate = false;
        }
        println("we are out of the calculate");
        showSec1Vals();          // to update values with the calculated values
      }
    }
  }
  //---------------------------------------------------------------------------------------------------------------------------- END OF SECTION 1
  
  //------------------------------------------------------------------------------------------------------------------------------------------------ SECTION 2
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
  //------------------------------------------------------------------------------------------------------------------------------------------ END OF SECTION 2
  
  //-------------------------------------------------------------------------------------------------------------------------------------------------------------- SECION 3
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
  //------------------------------------------------------------------------------------------------------------------------------------ END OF SECTION 3

  //------------------------------------------------------------------------------------------------------------------------------------------------ SECTION 4
  else if(sec == 4){
    if(firstRun){
      showKeypad();
      sec4Inst.show();
      firstRun = false;
      oldSec = 4;
    }
    //------------------------------------------------------------------------------------------------ will not go in until we get user age (got agee so start doing what we have to do)
    if(!noUserInput){          // if user input something by hitting done on the keypad
      
      // start 2 minute timer
      if(startWatch){
        println("done! age is: " + int(userInputStr));
        watch.start();
        startWatch = false;
      }
      
      if(!twoMin){
        drawHeatMap();              // draw heat map and get data to calculate sec 4 stuff
        seconds = watch.second();
        min = watch.minute();
        watchVal.setValue(Integer.toString((min)) + " min " + Integer.toString((seconds))+"s");
        watchVal.show();
        // *********************************************************************************************collect data for sec 4
        println("collecting data for sec4");
      }
      // if at two minutes
      if(seconds == 5 && twoMin == false){      // change back to min == 2
        twoMin = true;
        println("done! calculating");
        // calculate sec4 stuff and display results**************************************************************
        
        if(health == 1){
          waitingLbl.hide();
          healthLbl.show();
        }
        else if(health == 0){
          notHealthLbl.show();
        }
      }
    }
  }
  
  //-------------------------------------------------------------------------------------------------------------------------------------------------------- SECTION 4
  // resets any given mode              // mode reset
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
//      //should have 22 values from arduino           sec-mf-lf-mm-heel
//      if(dataArr.length == 4){
//        int sec = int(dataArr[0]);
        
//        // parse out data according to section
//        if(sec == 1){
//          setSec1Data();
//          println("sec1");
//          //delay(100);
//        }
//        else if(sec == 2){
//          setSec2Data();
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


// resets a given mode based on the current mode
void resetGivenMode(int oldSec){
  switch(oldSec){
    //resetting sec 1
    case 1:
      resetSec1();
      resetPlots();
      waitingLbl.hide();
      twoMin = false;
      break;
    case 2:
      resetSec2();
      break;
    case 3:
      resetSec3();
      println("exiting sec 3");
      break;
    case 4:
      resetSec4();
      startWatch = true;
      break;
  }
  userInputStr = "";              // reset user str
  // resetting stopwatch variables
  seconds = 0;
  min = 0;
  watch.stop();
  watch.reset();
  watchVal.setValue("TIME");
  watchVal.hide();
}
