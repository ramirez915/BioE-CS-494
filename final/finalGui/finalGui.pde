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
Textlabel = userInput;
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

  //cp5.hide();
  
  
  
  
  printArray(Serial.list());   //prints all available serial ports
  //String portName = Serial.list()[0];    // gets port number of arduino      *************************************************** change this to the index where the arduino is connected
  //port = new Serial(this, portName, 115200);
  //port.bufferUntil('\n');
  
  dataArr[0] = "x";
  dataArr[1] = "x";
  dataArr[2] = "x";
  dataArr[3] = "x";
  dataArr[4] = "x";

}




void draw(){
  if(t9On){
    parseData();          // original
    C1 = false;
    C2 = false;
    C3 = false;
    
    userInput.setValue(userStr);
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
  // preset all capacitors to false
  //C1 = false;
  //C2 = false;
  //C3 = false;
  
  
  
  currCap = dataArr[0];        // get the current cap that was tapped
  
  switch(dataArr[0]){        // cmds[counter]
    case "C1":
    // the the watch is not on yet turn on
      if(!c1.watch.running){
        c1.watch.start();
        c1.capState = true;
        // checks for different tap
        //if(currCap != prevCap && prevCap != ""){
        if(currCap.equals(prevCap) == false && prevCap.equals("") == false)
          getCap(prevCap).setLetter();
          println("another cap: " + prevCap + "****** was pressed before c1\n");
        }
        c1.counter++;
        println("c1 pressed for 1st time");
      }
      else{
        // if on and after 2 seconds of inactivity... turn off
        if(c1.watch.second() >= 2){
          c1.setLetter();
        }
        else if(c1.watch.seconds < 2){
          c1.counter++;
        }
      }
      prevCap = "C1";
      break;
    case "C2":
      // the the watch is not on yet turn on
      if(!c2.watch.running){
        c2.watch.start();
        c2.capState = true;
        // checks for different tap
        //if(currCap != prevCap && prevCap != ""){
        if(currCap.equals(prevCap) == false && prevCap.equals("") == false)
          getCap(prevCap).setLetter();
          println("another cap: " + prevCap + "****** was pressed before c2\n");
        }
        c2.counter++;
        println("c2 pressed for 1st time");
      }
      else{
        // if on and after 2 seconds of inactivity... turn off
        if(c2.watch.second() >= 2){
          c2.setLetter();
        }
        else if(c2.watch.seconds < 2){
          c2.counter++;
        }
      }
      prevCap = "C2";
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
}

Cap getCap(String wantedCap){
  switch(wantedCap){
    case "C1":
      return c1;
    case "C2";
      return c2;
  }
}
