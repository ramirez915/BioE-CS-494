import controlP5.*; // import ControlP5 library
import grafica.*;    // for graphing
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

int fitnessColor = 0;    // keep track of the color that is to display while in fitness mode
float age = 0.0;          // age of the user

void setup(){ //same as arduino program
  size(2000, 1100);    //window size, (width, height)
  
  printArray(Serial.list());   //prints all available serial ports
  String portName = Serial.list()[2];    // gets port number of arduino
  myPort = new Serial(this, portName, 115200);
  
  // starts serialEvent function when a newline character is read
  myPort.bufferUntil('\n');
  
  background(0, 0 , 200); // background color of window (r, g, b) or (0 to 255)
  
  // Create a new plot and set its position on the screen
  heartPlot = new GPlot(this,300,0);        //graph positioned at 300,0
  heartPlot.setTitleText("Heart Monitor");
  heartPlot.getXAxis().setAxisLabelText("x axis");
  heartPlot.getYAxis().setAxisLabelText("y axis");
  heartPlot.setDim(1500,500);
  heartPlot.setXLim(0,300);
  heartPlot.setYLim(0,100);
  
  // resp 
  respPlot = new GPlot(this,300,600);        //graph positioned at 300,600
  respPlot.setTitleText("Respiration Monitor");
  respPlot.getXAxis().setAxisLabelText("x axis");
  respPlot.getYAxis().setAxisLabelText("y axis");
  respPlot.setDim(1500,500);
  respPlot.setXLim(0,300);
  respPlot.setYLim(0,100);  
  
  
  //lets add buton to empty window
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
    //graph for heart
    println("heart rate val: "+ heartRateVal);
    println("resp rate val: " + respRateVal);
    
    // ADDING POINT WITHOUT ARRAY
    heartPlot.addPoint(new GPoint(x1,heartRateVal));
    heartPlot.setPoint(x1, new GPoint(x1,heartRateVal));
    
    respPlot.addPoint(new GPoint(x1,respRateVal));
    respPlot.setPoint(x1, new GPoint(x1,respRateVal));
    
    x1++;  // move on to the next x coordinate
    //println("x1 val " + x1);
    
    //draw both graphs
    heartPlot.defaultDraw();
    respPlot.defaultDraw();
    
    // at the max so scroll to the side
    if(x1 >= 300){
      heartPlot.moveHorizontalAxesLim(3.0);    // if want faster scroll increase this value
      respPlot.moveHorizontalAxesLim(3.0);
    }
  }
  
  // exiting from any mode so clear graphs
  else if(modeType == 0.0){
    println("exiting");
    
    // removes all the points from the graph
    for(int i = 0; i < x1; i++){
      heartPlot.removePoint(0);
      respPlot.removePoint(0);
    }
    
    // reset limits
    heartPlot.setXLim(0,300);
    heartPlot.setYLim(0,100);
    heartPlot.updateLimits();
    
    respPlot.setXLim(0,300);
    respPlot.setYLim(0,100);
    respPlot.updateLimits();
    x1 = 0;
    
    heartPlot.defaultDraw();    
    respPlot.defaultDraw();
    
    modeType = -1.0;
    println("done");
  }
}

//lets add some functions to our buttons
//so whe you press any button, it sends perticular char over serial port

void Fitness(){
  myPort.write('f');
}

void Stress(){
  myPort.write('s');
}

void Meditation(){
  myPort.write('m');
}

void MainMenu(){
  myPort.write('a');
}


void serialEvent (Serial myPort) {
  //println("waitin");
  // check for incoming numbers on the serial monitor
  if (myPort.available() >= 0) {
    valueFromArduino = myPort.readStringUntil('\n');
    
    //get age of the user
    if(age == 0){
      age = float(valueFromArduino);
      println(age);
    }
    else{
      dataArr = float(split(valueFromArduino,"-"));
      //println(valueFromArduino);
      // store values from the analog devices to the a and b values used for height in graph
      modeType = dataArr[0];
      heartRateVal = map(dataArr[1], 0, 1023, 0, 255);
      respRateVal = map(dataArr[2], 0, 1023, 0, 255);
      
      // get raw values
      //heartRateVal = dataArr[1];
      //respRateVal = dataArr[2];
    }
    
  }
}

//void interpretColor(double colorFlag){
  
//}
