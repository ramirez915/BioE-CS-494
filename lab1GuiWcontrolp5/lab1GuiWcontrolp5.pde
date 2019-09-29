import controlP5.*; // import ControlP5 library
import grafica.*;    // for graphing
import processing.serial.*;

Serial myPort;
ControlP5 cp5; //create ControlP5 object
PFont font;
int x1 = 0;    // starting position of the graph
int x2 = 0;
float heartRateVal;    // will store the values from readings for heart rate
float respRateVal;
float modeType = -1;      // used to determine which mode the data is coming from
float dataArr[];      // array that will store the data
String valueFromArduino;  // value from the analog device

// grafica 
GPlot heartPlot, respPlot;
int npoints = 300;
GPointsArray heartPoints = new GPointsArray(npoints);
GPointsArray respPoints = new GPointsArray(npoints);



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
  
  //// setting made up values to plot
  //for(int i =0; i< npoints;i++){
  //  heartPoints.add(i,10*noise(0.1*i));
  //  respPoints.add(i,10*noise(0.1*i));
  //}
  
  
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
  
  //// this draws out the made up plots
  //respPlot.setPoints(respPoints);
  //respPlot.defaultDraw();
  //// this draws out the made up plots
  //heartPlot.setPoints(heartPoints);
  //heartPlot.defaultDraw();
  
  
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
    // add points to heart graph
    heartPoints.add(x1,heartRateVal);
    heartPlot.setPoints(heartPoints);
    
    // add points to respiratory graph
    respPoints.add(x2,respRateVal);
    respPlot.setPoints(respPoints);
    
    x1++;  // move on to the next x coordinate
    x2++;
    println("x1 val " + x1 + " x2 val: " + x2);
    
    //draw both graphs
    heartPlot.defaultDraw();
    respPlot.defaultDraw();
    
    //at the max value for the plot so reset
    if(x1 >= 300){
      x1 = 0;
      heartPoints.removeRange(0,300);
      //respPoints.removeRange(0,300);
    }
    
    if (x2 >= 300){
      x2 = 0;
      respPoints.removeRange(0,300);
    }
    
    
  }
  
  // exiting from any mode
  else if(modeType == 0.0){
    println("exiting");
    // clear graphs
    heartPoints.removeRange(0,x1);
    x1 = 0;
    heartPoints.add(x1,heartRateVal);
    heartPlot.setPoints(heartPoints);
    
    heartPlot.defaultDraw();
    
    respPoints.removeRange(0,x2);
    x2= 0;
    respPoints.add(x2,respRateVal);
    respPlot.setPoints(respPoints);
    
    respPlot.defaultDraw();
    
    println("done");
    modeType = -1.0;
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
