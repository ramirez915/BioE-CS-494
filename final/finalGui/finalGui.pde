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
String[] key1 = new String[] {"a","b","c","d","e"};                // key 1 thumb
String[] key2 = new String[] {"f","g","h","i","j","k"};            // key 2 pointing finger
String[] key3 = new String[] {"l","m","n","o","p"};
String[] key4 = new String[] {"q","r","s","t","u"};
String[] key5 = new String[] {"v","w","x","y","z"};
String[] key6 = new String[] {" ", "\n"};
boolean t9On = false;
//------------------------------------------

//----------------------------------------------                      // capacitors
Cap c1 = new Cap(key1);
Cap c2 = new Cap(key2);
Cap c3 = new Cap(key3);
// update these on the bottom
Cap c4 = new Cap(key4);
Cap c5 = new Cap(key5);
Cap c6 = new Cap(key6);

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
  String portName = Serial.list()[0];    // gets port number of arduino      *************************************************** change this to the index where the arduino is connected
  port = new Serial(this, portName, 115200);
  port.bufferUntil('\n');
  
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
    //parseData();          // original
    parseData2(dataArr[0]);
    
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
      println(valueFromArduino + "counter " + counter);
      counter++;
      
    }catch(RuntimeException e){
      e.printStackTrace();
    }
  }
}
//---------------------------------------------- end of serialEvent


void parseData(){
  currCap = dataArr[0];        // get the current cap that was tapped
  //println("dataArr[0] " + dataArr[0]);
  
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
        println("watch c1 started");
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
      // the the watch is not on yet turn on
      if(!c3.watch.running){
        c3.capState = true;
        // checks for different tap
        if(currCap.equals(prevCap) == false && prevCap.equals("") == false){
          getCap(prevCap).setLetter();
          println("another cap: " + prevCap + "****** was pressed before c3\n");
        }
        
        c3.incCounter();
        c3.watch.start();
        println("c3 pressed for 1st time");
      }
      else{
        // else we are within the time thr so we can go to the next letter
        c3.watch.stop();
        c3.watch.reset();
        c3.incCounter();
        c3.watch.start();
      }
      prevCap = "C3";
      println("C3 pressed... ghi");
      break;
    case "x":          // do nothing
      //println("do nothing");
      break;
  }    // end of switch
  dataArr[0] = "x";
  
}

Cap getCap(String wantedCap){
  switch(wantedCap){
    case "C1":
      return c1;
    case "C2":
      return c2;
    case "C3":
      return c3;
    case "C4":
      return c4;
    case "C5":
      return c5;
    case "C6":
      return c6;
  }
  return null;
}

void parseData2(String capAsStr){
  Cap capObj = getCap(capAsStr);
  if(capObj != null){
    currCap = capAsStr;
    if(!capObj.watch.running){
        capObj.capState = true;
        // checks for different tap
        if(currCap.equals(prevCap) == false && prevCap.equals("") == false) {
          getCap(prevCap).setLetter();
          println("another cap: " + prevCap + "****** was pressed before "+ currCap +"\n");
        }
        
        capObj.incCounter();
        capObj.watch.start();
        println("c1 pressed for 1st time");
      }
      else{
        // else we are within the time thr so we can go to the next letter
        capObj.watch.stop();
        capObj.watch.reset();
        capObj.incCounter();
        capObj.watch.start();
        println("watch " + currCap + "started");
      }
      prevCap = currCap;
  }
  dataArr[0] = "x";
}


// check the watches to know if its time to set a letter or not
// if on and after 2 seconds of inactivity... turn off and set letter
void checkWatches(){
  for(Cap c: capArr){
    // if the watch is active...
    if(c.watch.running){
      println("watch time: "+c.watch.second() + "s");
      println("counter: " + c.counter);
      // hit the time thr so set letter
      if(c.watch.second() >= 2){
        c.setLetter();          // this stops and resets the watch
      }
    }
  }
}
