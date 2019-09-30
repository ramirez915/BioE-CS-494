import controlP5.*; // import ControlP5 library
import grafica.*;    // for graphing
import processing.sound.*;    // for music
import processing.serial.*;

Serial myPort;
ControlP5 cp5; //create ControlP5 object
PFont font;
int x1 = 0;    // starting position of the graph
float heartRateVal;    // will store the values from readings for heart rate
float respRateVal;
float modeType = -1;      // used to determine which mode the data is coming from
float dataArr[];      // array that will store the data
String valueFromArduino;  // value from the analog device

// grafica 
GPlot heartPlot, respPlot;

float fitnessColor = 0.0;    // keep track of the color that is to display while in fitness mode
float age = 0.0;          // age of the user

// music variable  *************************************************************************************************************** uncomment when ready with the song
//SoundFile song;
int songCounter = 0;      // used to play the song when starting the stress mode

void setup(){
  size(2000, 1000);    //window size, (width, height)
  
  printArray(Serial.list());   //prints all available serial ports
  String portName = Serial.list()[13];    // gets port number of arduino      *************************************************** change this to the index where the arduino is connected
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
  
  background(0,0,0); // background color of window (r, g, b) or (0 to 255)
  
  // setting song variable    *************************************************************************************************** make sure song is in the same folder as this file
  //song = new SoundFile(this,sketchPath("Careless Whisper.mp3"));
  
  // Create a new plot and set its position on the screen
  heartPlot = new GPlot(this,300,0);        //graph positioned at 300,0
  heartPlot.setTitleText("Heart Monitor");
  heartPlot.getXAxis().setAxisLabelText("x axis");
  heartPlot.getYAxis().setAxisLabelText("y axis");
  heartPlot.setDim(1500,500);
  heartPlot.setXLim(0,300);    // x axis must stay the same
  heartPlot.setYLim(30,120);    // y axis
  
  // resp 
  respPlot = new GPlot(this,300,600);        //graph positioned at 300,600
  respPlot.setTitleText("Respiration Monitor");
  respPlot.getXAxis().setAxisLabelText("x axis");
  respPlot.getYAxis().setAxisLabelText("y axis");
  respPlot.setDim(1500,500);
  respPlot.setXLim(0,300);    // x axis must stay at 300
  respPlot.setYLim(0,100);    // y axis
  
  
  // adds buttons to the window
  cp5 = new ControlP5(this);
  font = createFont("calibri light bold", 20);    // custom fonts for buttons and title
  
  cp5.addButton("Fitness")     //"red" is the name of button
    .setPosition(100, 50)  //x and y coordinates of upper left corner of button
    .setSize(120, 70)      //(width, height)
    .setFont(font)
  ;   

  cp5.addButton("Stress")     //"yellow" is the name of button
    .setPosition(100, 150)  //x and y coordinates of upper left corner of button
    .setSize(120, 70)      //(width, height)
    .setFont(font)
  ;

  cp5.addButton("Meditation")     //"blue" is the name of button
    .setPosition(100, 250)  //x and y coordinates of upper left corner of button
    .setSize(120, 70)      //(width, height)
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
  fill(0, 255, 0);               //text color (r, g, b)
  textFont(font);
  text("FITNESS CONTROL", 80, 30);  // ("text", x coordinate, y coordinate)
  
  // fitness mode
  if(modeType == 1.0){
    // prints out data used for debugging
    println("heart rate val: "+ heartRateVal);
    println("resp rate val: " + respRateVal);
    
    //interpret color
    interpretColor(fitnessColor);
    plotData();
  }
  
  // stress mode (mode that will need the song)
  else if(modeType == 2.0){
    // if first time entering stress mode play song
    if(songCounter == 0){
      //song.play();
      songCounter++;
    }
    // else continue and just plot data
    plotData();
  }
  
  // meditaion mode
  else if(modeType == 3.0){
    plotData();
  }
  
  // exiting from any mode so clear graphs
  else if(modeType == 0.0){
    resetPlotsAndVars();
  }
}

//lets add some functions to our buttons
//so whe you press any button, it sends perticular char over serial port

void Fitness(){
  myPort.write('f');
}

// play song in stress mode
void Stress(){
  myPort.write('s');
}

void Meditation(){
  myPort.write('m');
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
      //get age of the user
      if(age == 0){
        age = float(valueFromArduino);
        println(age);
      }
      else{
        dataArr = float(split(valueFromArduino,"-"));
        println(valueFromArduino);
        // store values from the analog devices to the a and b values used for height in graph
        modeType = dataArr[0];
        // adding fitness color
        fitnessColor = dataArr[1];
        
        // data is being mapped from 0- 255 given that the data is from 0-1023 max
        //heartRateVal = map(dataArr[2], 0, 1023, 0, 255);    // this gets plotted on y axis
        //respRateVal = map(dataArr[3], 0, 1023, 0, 255);    // this gets plotted on y axis
        
        // get raw values (actual values)
        heartRateVal = dataArr[1];      // gets plotted on y axis
        respRateVal = dataArr[2];      // gets plotted on y axis
      }
    }catch(RuntimeException e){
      e.printStackTrace();
    }
  }
}

// will interpret the color flag to set up the color in GUI
void interpretColor(float colorFlag){
  print("activity zone: ");
  if(colorFlag == 5.0){
    println("very light");
    background(169,169,169);
  }
  else if(colorFlag == 6.0){
    println("light");
    background(0,0,255);
  }
  else if(colorFlag == 7.0){
    println("moderate");
    background(0,255,0);
  }
  else if(colorFlag == 8.0){
    println("hard");
    background(255,255,0);
  }
  else if(colorFlag == 9.0){
    println("maximum");
    background(255,0,0);
  }
  // resetting                    ***** CHANGE STOCK COLOR IF NEEDED
  else if(colorFlag == -1.0){
    println("resetting color");
    background(0,0,0);
  }
}

// plots the data on the two graphs
void plotData(){
  // ADDING POINT TO PLOT
  heartPlot.addPoint(new GPoint(x1,heartRateVal));
  heartPlot.setPoint(x1, new GPoint(x1,heartRateVal));
  respPlot.addPoint(new GPoint(x1,respRateVal));
  respPlot.setPoint(x1, new GPoint(x1,respRateVal));
  
  x1++;  // move on to the next x coordinate
  //println("x1 val " + x1);
  
  //draw both graphs
  heartPlot.defaultDraw();
  respPlot.defaultDraw();
  
  // at the max so scroll to the side    x axis
  if(x1 >= 300){
    heartPlot.moveHorizontalAxesLim(5.0);    // if want faster scroll increase this value
    respPlot.moveHorizontalAxesLim(5.0);     // 5.0 seems to be a good value
  }
}

// resets the plots and the variables used thoughout
void resetPlotsAndVars(){
  println("exiting");
  // removes all the points from the graph
  for(int i = 0; i < x1; i++){
    heartPlot.removePoint(0);
    respPlot.removePoint(0);
  }
  
  // reset limits
  heartPlot.setXLim(0,300);    // x axis must stay the same
  heartPlot.setYLim(0,255);    // y axis
  heartPlot.updateLimits();
  
  respPlot.setXLim(0,300);    // x axis must stay the same
  respPlot.setYLim(0,255);    // y axis
  respPlot.updateLimits();
  x1 = 0;
  
  heartPlot.defaultDraw();    
  respPlot.defaultDraw();
  
  modeType = -1.0;
  fitnessColor = -1.0;
  songCounter = 0;
  interpretColor(fitnessColor);
  
  println("done");
}
