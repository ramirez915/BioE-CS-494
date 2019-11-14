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
Button t9;
Textlabel userInput;
//--------------------------------------------------------

//----------------------------------------------------------------------------------- keys
// 1 second between taps to determine a char selection                                          // no uppercase nor numbers for now
String[] key1 = new String[] {"a","b","c"};                // key 1 (abc)
String[] key2 = new String[] {"d","e","f"};                // key 2 (def)
String[] key3 = new String[] {"g","h","i"};                // key 3 (ghi)
boolean t9On = false;
//------------------------------------------

//----------------------------------------------                      // capacitors
Cap c1 = new Cap(key1);
Cap c2 = new Cap(key2);
Cap c3 = new Cap(key3);
// update these on the bottom
Cap c4 = new Cap(key2);
Cap c5 = new Cap(key1);
Cap c6 = new Cap(key2);

String tempStr = "";                    // the temp string before it gets appended to the actual string
String inputStr = "";

Cap[] capArr = new Cap[6];
String currCap = "";
String prevCap = "";
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

void setup(){
  background(192,62,0);
  //fullScreen();
  size(2000,1200);
  frameRate(60);
  font = createFont("MS Gothic",60);  

  setupMainButtons();   
  
  printArray(Serial.list());   //prints all available serial ports
  //String portName = Serial.list()[0];    // gets port number of arduino      *************************************************** change this to the index where the arduino is connected
  //port = new Serial(this, portName, 115200);
  //port.bufferUntil('\n');
  
  dataArr[0] = "x";
  dataArr[1] = "x";
  dataArr[2] = "x";
  dataArr[3] = "x";
  dataArr[4] = "x";
  
  capArr[0] = c1;
  capArr[1] = c2;
  capArr[2] = c3;
  capArr[3] = c4;
  capArr[4] = c5;
  capArr[5] = c6;

}


void draw(){
  if(t9On){
    checkWatches();
    parseData();          // original
    
    userInput.setValue(inputStr);
    userInput.show();
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
  currCap = dataArr[0];        // get the current cap that was tapped
  
  switch(dataArr[0]){        // cmds[counter]
    case "C1":
    // the the watch is not on yet turn on
    // turn watch on at the end bc will need to maximize time we can have before setting letter
      if(!c1.watch.running){
        c1.capState = true;
        // checks for different tap
        if(currCap.equals(prevCap) == false && prevCap.equals("") == false) {
          getCap(prevCap).setLetter();
          println("another cap: " + prevCap + "****** was pressed before c1\n");
        }
        
        c1.incCounter();
        c1.watch.start();
        println("c1 pressed for 1st time");
      }
      else{
        // else we are within the time thr so we can go to the next letter
        c1.watch.stop();
        c1.watch.reset();
        c1.incCounter();
        c1.watch.start();
      }
      prevCap = "C1";
      break;
    case "C2":
      // the the watch is not on yet turn on
      if(!c2.watch.running){
        c2.capState = true;
        // checks for different tap
        if(currCap.equals(prevCap) == false && prevCap.equals("") == false){
          getCap(prevCap).setLetter();
          println("another cap: " + prevCap + "****** was pressed before c2\n");
        }
        
        c2.incCounter();
        c2.watch.start();
        println("c2 pressed for 1st time");
      }
      else{
        // else we are within the time thr so we can go to the next letter
        c2.watch.stop();
        c2.watch.reset();
        c2.incCounter();
        c2.watch.start();
      }
      prevCap = "C2";
      println("C2 pressed... def");
      break;
    case "C3":
      c3.capState = true;
      println("C3 pressed... ghi");
      break;
    case "x":          // do nothing
      println("do nothing");
      break;
  }
}

Cap getCap(String wantedCap){
  switch(wantedCap){
    case "C1":
      return c1;
    case "C2":
      return c2;
  }
  return null;
}


// check the watches to know if its time to set a letter or not
// if on and after 2 seconds of inactivity... turn off and set letter
void checkWatches(){
  for(Cap c: capArr){
    // if the watch is active...
    if(c.watch.running){
      // hit the time thr so set letter
      if(c.watch.second() >= 2){
        c2.setLetter();          // this stops and resets the watch
      }
    }
  }
}
