import controlP5.*; // import ControlP5 library
import grafica.*;    // for graphing
import processing.sound.*;    // for music
import processing.serial.*;

Serial myPort;
ControlP5 cp5; //create ControlP5 object
PFont font;
int x1 = 0;    // starting position of the graph
int xMid = 1;    // pos for histograms
int histLim = 0;
boolean bpmHasVal = false;    // flag to see if bpm has a value (used when resetting)
float ecgRateVal;    // will store the values from readings for heart rate
float bpm;
float modeType = -1;      // used to determine which mode the data is coming from
float dataArr[];      // array that will store the data
String valueFromArduino;  // value from the analog device

// grafica 
GPlot bpmPlot;


// music variable  *************************************************************************************************************** uncomment when ready with the song
SoundFile song;
int songCounter = 0;      // used to play the song when starting the stress mode

void setup(){
  size(2000, 1200);    //window size, (width, height)  1200
  
  printArray(Serial.list());   //prints all available serial ports
  String portName = Serial.list()[2];    // gets port number of arduino      *************************************************** change this to the index where the arduino is connected
  myPort = new Serial(this, portName, 115200);                                //************************************** check whats being printed below when runnning this 
                                                                              //************************************** to see the indecies of the COM ports
                                                                              //************************************ then verify where the arduino is connected in the arduino IDE
                                                                              //************************************ and change the index to the port where the arduino is connected
                                                                              //*** ex: arduino IDE says the arduino is connected to port COM 13
                                                                              //*** when I run this code the printed ports are [0] "COM3", [1] "COM4", [2] "COM13"
                                                                              //*** so I change line 29 to say
                                                                              //*** String portName = Serial.list()[2];
  
  // starts serialEvent function when a newline character is read
  myPort.bufferUntil('\n');
  
  background(0,255,0); // background color of window (r, g, b) or (0 to 255)
  
  // setting song variable    *************************************************************************************************** make sure song is in the same folder as this file
  song = new SoundFile(this,sketchPath("CarelessWhisper2.mp3"));
  
  
  // bpm Plot
  bpmPlot = new GPlot(this,1300,0);
  bpmPlot.setTitleText("BPM Monitor");
  bpmPlot.getXAxis().setAxisLabelText("x axis");
  bpmPlot.getYAxis().setAxisLabelText("AVERAGE BPM");
  bpmPlot.setDim(500,500);
  bpmPlot.setXLim(0,3);      // want to have the changing bpm gauge in the middle
  bpmPlot.setYLim(0,130);   // lim 0 - 130 bpm
  bpmPlot.startHistograms(GPlot.VERTICAL);
  bpmPlot.getHistogram().setBgColors(new color[]{ color(0,0,255,50)});
  
  
  
  // adds buttons to the window
  cp5 = new ControlP5(this);
  font = createFont("Arial", 20);    // custom fonts for buttons and title
  

  
  cp5.addButton("Stress")
    .setPosition(100,150)
    .setSize(120, 70)
    .setFont(font)
  ;
  
  cp5.addButton("Meditation")
    .setPosition(100,250)
    .setSize(120, 70)
    .setFont(font)
  ;
  
  cp5.addButton("MainMenu")     //"alloff" is the name of button
    .setPosition(100, 350)  //x and y coordinates of upper left corner of button
    .setSize(120, 70)      //(width, height)
    .setFont(font)
  ;
}

void draw(){  //same as loop in arduino
  
  //lets give title to our window
  fill(0);               //text color (r, g, b)
  textFont(font);
  text("FITNESS CONTROL", 80, 30);  // ("text", x coordinate, y coordinate)
  
  // fitness mode
  if(modeType == 1.0){
    // prints out data used for debugging
    
    println("bpm val: " + bpm);
    
    //interpret color
    plotData();
  }
  
  // stress mode (mode that will need the song)
  else if(modeType == 2.0){
    // if first time entering stress mode play song
    if(songCounter == 0){
      song.play();
      songCounter++;
      background(0,0,255);
    }
    // else continue and just plot data
    plotData();
  }
  
  //// meditaion mode                    // comment out when ready for meditation mode
  //else if(modeType == 3.0){
  //  plotData();
  //}
  
  // exiting from any mode so clear graphs
  else if(modeType == 0.0){
    resetPlotsAndVars();
  }
}

//lets add some functions to our buttons
//so whe you press any button, it sends perticular char over serial port


void Stress(){
  myPort.write('s');
  println("s");
}

void MainMenu(){
  myPort.write('a');
  //song.stop();
}

// checks what is being printed by the micro controller
void serialEvent (Serial myPort) {
  // check for incoming numbers on the serial monitor
  if (myPort.available() >= 0) {
    valueFromArduino = myPort.readStringUntil('\n');
    
    try{
      dataArr = float(split(valueFromArduino,"-"));
      //println(valueFromArduino);
      if(dataArr.length == 2){    // ----------------------------------------------------------------should have 4 values from arduino mode-bpm
      
        // store values from the analog devices to the a and b values used for height in graph
        modeType = dataArr[0];

        // data is being mapped from 0- 255 given that the data is from 0-1023 max
        //heartRateVal = map(dataArr[2], 0, 1023, 0, 255);    // this gets plotted on y axis
        
        
        bpm = dataArr[1];
      }
    }catch(RuntimeException e){
      e.printStackTrace();
    }
  }
}

// will interpret the color flag to set up the color in GUI


// plots the data on the two graphs
void plotData(){
  // ADDING POINT TO PLOT
  // bpm
  // remove values from bpm plots
  if(x1 != 0){
    bpmPlot.removePoint(0);    // remove current point from bpm
    bpmHasVal = true;
  }
  bpmPlot.addPoint(new GPoint(xMid,bpm));
  bpmPlot.setPoint(histLim,new GPoint(xMid,bpm));
  bpmPlot.getTitle().setText("BPM Monitor     BPM: " + str(bpm));
  

  println("BPM:  " + bpm);
  
  x1++;  // move on to the next x coordinate
  //println("x1 val " + x1);
  
  // Draw bpm hist 
  bpmPlot.beginDraw();
  bpmPlot.drawBackground();
  bpmPlot.drawBox();
  bpmPlot.drawYAxis();
  bpmPlot.drawTitle();
  bpmPlot.drawHistograms();
  bpmPlot.endDraw();
}

// resets the plots and the variables used thoughout
void resetPlotsAndVars(){
  println("exiting");

  if(bpmHasVal){
    bpmPlot.removePoint(0);
    bpmHasVal = false;
    bpm = 0;
  }
  

  x1 = 0;
  
  bpmPlot.setXLim(0,3);    // x axis must stay the same
  bpmPlot.setYLim(0,130);    // y axis
  bpmPlot.updateLimits();

  modeType = -1.0;
  if(songCounter > 0){
    song.stop();
  }
  songCounter = 0;
  
  println("done");
}
