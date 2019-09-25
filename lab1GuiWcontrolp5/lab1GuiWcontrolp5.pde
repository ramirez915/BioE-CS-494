import controlP5.*; //import ControlP5 library
import processing.serial.*;

Serial myPort;
ControlP5 cp5; //create ControlP5 object
PFont font;
int x1 = 0;    // starting position of the graph
int y1 = 250;
float heartRateVar;    // will store the values from readings for heart rate
float respRateVar;
float dataArr[];      // array that will store the data
String valueFromArduino;  // value from the analog device

void setup(){ //same as arduino program
  size(2000, 1000);    //window size, (width, height)
  
  printArray(Serial.list());   //prints all available serial ports
  String portName = Serial.list()[0];    // gets port number of arduino
  myPort = new Serial(this, portName, 115200);
  
  // starts serialEvent function when a newline character is read
  myPort.bufferUntil('\n');
  
  background(0, 0 , 200); // background color of window (r, g, b) or (0 to 255)
  
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
  
  cp5.addButton("alloff")     //"alloff" is the name of button
    .setPosition(100, 350)  //x and y coordinates of upper left corner of button
    .setSize(120, 70)      //(width, height)
    .setFont(font)
  ;
  
  // box that will contain the graphs
  rect(300,0,1700,500);
  fill(255,255,255);
  
  rect(300,600,1700,500);
  fill(255,255,255);
}

void draw(){  //same as loop in arduino
  
  //lets give title to our window
  fill(0, 255, 0);               //text color (r, g, b)
  textFont(font);
  text("FITNESS CONTROL", 80, 30);  // ("text", x coordinate, y coordinat)
}

//lets add some functions to our buttons
//so whe you press any button, it sends perticular char over serial port

void Fitness(){
  myPort.write('f');
  stroke(0,250,0);
  line(x1,height,x1,height-heartRateVar);
  
  if(x1 >= 250){
    // resetting box for graph
    x1 =0;
    fill(255,255,255);
    rect(300,0,1700,500);
  }
  x1++;    // continuously moves to plot values
  
}

void Stress(){
  myPort.write('s');
}

void Meditation(){
  myPort.write('m');
}

void alloff(){
  myPort.write('a');
}


void serialEvent (Serial myPort) {
  println("waitin");
  // check for incoming numbers on the serial monitor
  if (myPort.available() > 0) {                        // i had >= 0...
    valueFromArduino = myPort.readStringUntil('\n');
    dataArr = float(split(valueFromArduino,"-"));
    println(valueFromArduino);
    // store values from the analog devices to the a and b values used for height in graph
    heartRateVar = map(dataArr[0], 0, 1023, 0, 255);
    //b = map(dataArr[1], 0, 1023, 0, 255);
    
  }
}
