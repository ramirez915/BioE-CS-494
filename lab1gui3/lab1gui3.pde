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
float respRateVal;
float bpm;
float rRate;
float modeType = -1;      // used to determine which mode the data is coming from
float dataArr[];      // array that will store the data
String valueFromArduino;  // value from the analog device

// grafica 
GPlot ecgPlot, respPlot, bpmPlot, rRatePlot;

float fitnessColor = 0.0;    // keep track of the color that is to display while in fitness mode

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
  
  // Create a new plot and set its position on the screen
  // ecg and respPlots    regular plots to see signal from device
  ecgPlot = new GPlot(this,300,0);        //graph positioned at 300,0
  ecgPlot.setTitleText("Heart Monitor");
  ecgPlot.getXAxis().setAxisLabelText("x axis");
  ecgPlot.getYAxis().setAxisLabelText("y axis");
  ecgPlot.setDim(900,500);              // one graph alone is 1500,500
  ecgPlot.setXLim(0,300);    // x axis must stay the same
  ecgPlot.setYLim(0,1000);    // y axis
  ecgPlot.activateZooming(2.0,CENTER,CENTER);
  
  respPlot = new GPlot(this,300,600);        //graph positioned at 300,600
  respPlot.setTitleText("Respiration Monitor");
  respPlot.getXAxis().setAxisLabelText("x axis");
  respPlot.getYAxis().setAxisLabelText("y axis");
  respPlot.setDim(900,500);
  respPlot.setXLim(0,300);    // x axis must stay at 300
  respPlot.setYLim(1900,2050);    // values determined by tests 24000,30000 with raw values
  respPlot.activateZooming(2.0,CENTER,CENTER);
  
  
  // bpm and rRate Plot
  bpmPlot = new GPlot(this,1300,0);
  bpmPlot.setTitleText("BPM Monitor");
  bpmPlot.getXAxis().setAxisLabelText("x axis");
  bpmPlot.getYAxis().setAxisLabelText("AVERAGE BPM");
  bpmPlot.setDim(500,500);
  bpmPlot.setXLim(0,3);      // want to have the changing bpm gauge in the middle
  bpmPlot.setYLim(0,130);   // lim 0 - 130 bpm
  bpmPlot.startHistograms(GPlot.VERTICAL);
  bpmPlot.getHistogram().setBgColors(new color[]{ color(0,0,255,50)});
  
  rRatePlot = new GPlot(this,1300,600);
  rRatePlot.setTitleText("RESP RATE Monitor");
  rRatePlot.getXAxis().setAxisLabelText("x axis");
  rRatePlot.getYAxis().setAxisLabelText("RESP RATE");
  rRatePlot.setDim(500,500);
  rRatePlot.setXLim(0,3);      // want to have the changing bpm gauge in the middle
  rRatePlot.setYLim(0,30);   // lim 0- 30
  rRatePlot.startHistograms(GPlot.VERTICAL);
  rRatePlot.getHistogram().setBgColors(new color[]{ color(0,0,255,50)});
  
  
  // adds buttons to the window
  cp5 = new ControlP5(this);
  font = createFont("Arial", 20);    // custom fonts for buttons and title
  
  cp5.addButton("Fitness")     //"red" is the name of button
    .setPosition(100, 50)  //x and y coordinates of upper left corner of button
    .setSize(120, 70)      //(width, height)
    .setFont(font)
  ;
  
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
    println("ecg val: "+ ecgRateVal);
    println("resp rate val: " + respRateVal);
    
    println("bpm val: " + bpm);
    println("rRate val: " + rRate);
    
    //interpret color
    interpretColor(fitnessColor);
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
  
  // meditaion mode                    // comment out when ready for meditation mode
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
  println("f");
}

void Stress(){
  myPort.write('s');
  println("s");
}

void Meditation(){
  myPort.write('m');
  println("m");
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
      if(dataArr.length == 6){    // ----------------------------------------------------------------should have 6 values from arduino mode-color-ecg-resp-bpm-rRate
      
        // store values from the analog devices to the a and b values used for height in graph
        modeType = dataArr[0];
        // adding fitness color
        fitnessColor = dataArr[1];
        
        // data is being mapped from 0- 255 given that the data is from 0-1023 max
        //heartRateVal = map(dataArr[2], 0, 1023, 0, 255);    // this gets plotted on y axis
        
        // get raw values (actual values)
        ecgRateVal = dataArr[2];      // gets plotted on y axis
        //respRateVal = dataArr[3];      // gets plotted on y axis
        respRateVal = map(dataArr[3], 0, 70000, 0, 5500);    // this gets plotted on y axis

        
        bpm = dataArr[4];
        rRate = dataArr[5];
      }
    }catch(RuntimeException e){
      e.printStackTrace();
    }
  }
}

// will interpret the color flag to set up the color in GUI
void interpretColor(float colorFlag){
  //println("activity zone: ");
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
    background(255);
  }
}

// plots the data on the two graphs
void plotData(){
  // ADDING POINT TO PLOT
  ecgPlot.addPoint(new GPoint(x1,ecgRateVal));
  ecgPlot.setPoint(x1, new GPoint(x1,ecgRateVal));
  
  // center and zoom for resp rate???
  respPlot.addPoint(new GPoint(x1,respRateVal));
  respPlot.setPoint(x1, new GPoint(x1,respRateVal));
  respPlot.getTitle().setText("Respiratory Monitor     Signal: " + str(respRateVal));
  
  // bpm and rRate
  // remove values from bpm and rRate plots
  if(x1 != 0){
    bpmPlot.removePoint(0);    // remove current point from bpm
    rRatePlot.removePoint(0);   // remove current point from r rate
    bpmHasVal = true;
  }
  bpmPlot.addPoint(new GPoint(xMid,bpm));
  bpmPlot.setPoint(histLim,new GPoint(xMid,bpm));
  bpmPlot.getTitle().setText("BPM Monitor     BPM: " + str(bpm));
  
  rRatePlot.addPoint(new GPoint(xMid,rRate));
  rRatePlot.setPoint(histLim,new GPoint(xMid,rRate));
  rRatePlot.getTitle().setText("R Rate Monitor     RRate: " + str(rRate));
  
  println("plotted vals: ecg "+ ecgRateVal + " resp " + respRateVal);
  println("BPM:  " + bpm + " rRate   " + rRate);
  
  x1++;  // move on to the next x coordinate
  //println("x1 val " + x1);
  
  //draw both graphs
  ecgPlot.beginDraw();
  ecgPlot.drawBackground();
  ecgPlot.drawBox();
  ecgPlot.drawXAxis();
  ecgPlot.drawYAxis();
  ecgPlot.drawTitle();
  ecgPlot.drawLines();
  ecgPlot.endDraw();
  
  respPlot.beginDraw();
  respPlot.drawBackground();
  respPlot.drawBox();
  respPlot.drawXAxis();
  respPlot.drawYAxis();
  respPlot.drawTitle();
  respPlot.drawLines();
  respPlot.endDraw();
  
  // Draw bpm hist 
  bpmPlot.beginDraw();
  bpmPlot.drawBackground();
  bpmPlot.drawBox();
  bpmPlot.drawYAxis();
  bpmPlot.drawTitle();
  bpmPlot.drawHistograms();
  bpmPlot.endDraw();
  
  // Draw rRate hist 
  rRatePlot.beginDraw();
  rRatePlot.drawBackground();
  rRatePlot.drawBox();
  rRatePlot.drawYAxis();
  rRatePlot.drawTitle();
  rRatePlot.drawHistograms();
  rRatePlot.endDraw();
  
  
  // at the max so scroll to the side    x axis
  if(x1 >= 300){
    ecgPlot.moveHorizontalAxesLim(3.0);    // if want faster scroll increase this value
    respPlot.moveHorizontalAxesLim(2.0);     // 3.0 seems to be a good value
  }
}

// resets the plots and the variables used thoughout
void resetPlotsAndVars(){
  println("exiting");
  // removes all the points from the graphs
  for(int i = 0; i < x1; i++){
    ecgPlot.removePoint(0);
    respPlot.removePoint(0);
  }
  if(bpmHasVal){
    bpmPlot.removePoint(0);
    rRatePlot.removePoint(0);
    bpmHasVal = false;
    bpm = 0;
  }
  
  // reset limits
  ecgPlot.setXLim(0,300);    // x axis must stay the same
  ecgPlot.setYLim(0,1000);    // y axis
  ecgPlot.updateLimits();
  
  respPlot.setXLim(0,300);    // x axis must stay the same
  respPlot.setYLim(1900,2050);    // y axis
  respPlot.updateLimits();
  x1 = 0;
  
  bpmPlot.setXLim(0,3);    // x axis must stay the same
  bpmPlot.setYLim(0,130);    // y axis
  bpmPlot.updateLimits();
  
  rRatePlot.setXLim(0,3);
  rRatePlot.setYLim(0,30);
  rRatePlot.updateLimits();
  
  ecgPlot.defaultDraw();    
  respPlot.defaultDraw();
  
  modeType = -1.0;
  fitnessColor = -1.0;
  if(songCounter > 0){
    song.stop();
  }
  songCounter = 0;
  interpretColor(fitnessColor);
  
  println("done");
}
