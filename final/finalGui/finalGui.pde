import processing.serial.*;  // Serial library makes it possible to talk to Arduino
import controlP5.*; // import ControlP5 library
import grafica.*;    // for graphing
import processing.sound.*;

Serial port;
ControlP5 cp5;
String dataArr[] = new String[5];      // array that will store the data
String valueFromArduino;
int counter = 0;

//------------------------------------------------------------------- labels
Textlabel mainLbl;
Button mm;
//--------------------------------------------------------

//----------------------------------------------                      // capacitors
boolean C1 = false;
int c1Counter = 0;        // keeping track of which is pressed
StopWatch c1Watch = new StopWatch();
boolean C2 = false;
int c2Counter = 0;
StopWatch c2Watch = new StopWatch();
boolean C3 = false;
int c3Counter = 0;
StopWatch c3Watch = new StopWatch();
//------------------------------------------------- capacitors

//------------------------ SERIAL PORT STUFF TO HELP YOU FIND THE CORRECT SERIAL PORT
String serialPort;
String[] serialPorts = new String[Serial.list().length];
boolean serialPortFound = false;
Radio[] button = new Radio[Serial.list().length*2];
int numPorts = serialPorts.length;
boolean refreshPorts = false;
PFont font;
//-------------------------------------------- serial port stuff

//------------------------------------------------------- space invader globals
boolean spaceInvaderOn = false;

//---------------------------------

//------------------------------------------------------------ testing for space invader
String[] cmds = new String[] {"C2","C2","C2","C2","C2","C2","C2","C2","C2","C2","C2","C2","C2","C2","C2","C2","x","x","x","x","x","x","x","x","x","x","x","x","x","x","x","x","x","x","x","x","x","x","x","x","x","x","x","C3","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C2","C2","C2","C2","C2","C2","C2","C2","C3"};

//------------------------------------------

//-------------------------------------------------------- brick breaker globals
boolean brickBreakerOn = false;

//-----------------------------------------


void setup(){
  background(192,62,0);
  //fullScreen();
  size(2000,1200);
  frameRate(60);
  font = createFont("MS Gothic",60);
  //listAvailablePorts();
  

  setupMainButtons();

  //cp5.hide();
  
  
  
  
  printArray(Serial.list());   //prints all available serial ports
  String portName = Serial.list()[0];    // gets port number of arduino      *************************************************** change this to the index where the arduino is connected
  port = new Serial(this, portName, 115200);
  port.bufferUntil('\n');
  
  dataArr[0] = "x";
  dataArr[1] = "x";
  dataArr[2] = "x";
  dataArr[3] = "x";
  dataArr[4] = "x";

}




void draw(){
  if(spaceInvaderOn){
    parseData();          // original
    spaceInvaderDraw();
    C1 = false;
    C2 = false;
    C3 = false;
  }
  
  else if(brickBreakerOn){
    parseData();
    brickBreakerDraw();
    C1 = false;
    C2 = false;
    C3 = false;
  }
}


// checks what is being printed by the micro controller
void serialEvent (Serial myPort) {
  // check for incoming numbers on the serial monitor
  if (myPort.available() >= 0) {
    valueFromArduino = myPort.readStringUntil('\n');
    
    try{
      dataArr = split(valueFromArduino,"-");
      println(valueFromArduino);
      
    }catch(RuntimeException e){
      e.printStackTrace();
    }
  }
}
//---------------------------------------------- end of serialEvent



void parseData(){
  // preset all capacitors to false
  C1 = false;
  C2 = false;
  C3 = false;
  
    //if(counter != cmds.length){                // start of if        when ready to test with real values take out
      switch(dataArr[0]){        // cmds[counter]
        case "C1":
          C1 = true;
          println("C1 pressed... abc");
          break;
        case "C2":
          C2 = true;
          println("C2 pressed... def");
          break;
        case "C3":
          C3 = true;
          println("C3 pressed... ghi");
          break;
        case "x":          // do nothing
          println("do nothing");
          break;
      }
      //println(counter);
      //counter++;
    //}                                // end of if
}
