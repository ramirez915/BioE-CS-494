import processing.serial.*;  // Serial library makes it possible to talk to Arduino
import controlP5.*; // import ControlP5 library
import grafica.*;    // for graphing
import processing.sound.*;

Serial port;
ControlP5 cp5;
String dataArr[] = new String[5];      // array that will store the data
String valueFromArduino;

//--------------------------
boolean C1 = false;
boolean C2 = false;
boolean C3 = false;
//------------------------ capacitors

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


void setup(){
  fullScreen();
  frameRate(60);
  font = createFont("MS Gothic",60);
  listAvailablePorts();
  
  setupMainButtons();
  cp5.hide();
  
  
  
  
  printArray(Serial.list());   //prints all available serial ports
  String portName = Serial.list()[0];    // gets port number of arduino      *************************************************** change this to the index where the arduino is connected
  port = new Serial(this, portName, 115200);
  port.bufferUntil('\n');
}




void draw(){
  if(spaceInvaderOn){
    spaceInvaderDraw();
  }
  
  
  
  
  //if(serialPortFound){
    
    
  //}
  //else { // SCAN BUTTONS TO FIND THE SERIAL PORT

  //  autoScanPorts();
  
  //  if(refreshPorts){
  //    refreshPorts = false;
  //    listAvailablePorts();
  //  }
  
  //  for(int i=0; i<numPorts+1; i++){
  //    button[i].overRadio(mouseX,mouseY);
  //    button[i].displayRadio();
  //  }
  //}
}


// checks what is being printed by the micro controller
void serialEvent (Serial myPort) {
  // check for incoming numbers on the serial monitor
  if (myPort.available() >= 0) {
    valueFromArduino = myPort.readStringUntil('\n');
    
    try{
      dataArr = split(valueFromArduino,"-");
      println(valueFromArduino);
      
      parseData();
      
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
  
  // for each capacitor in the array
  for(String capacitor: dataArr){
    switch(capacitor){
      case "C1":
        C1 = true;
        println("C1 pressed");
        break;
      case "C2":
        C2 = true;
        println("C2 pressed");
        break;
      case "C3":
        C3 = true;
        println("C3 pressed");
        break;
    }
  }
}







void listAvailablePorts(){
  println(Serial.list());    // print a list of available serial ports to the console
  serialPorts = Serial.list();
  fill(0);
  textFont(font,50);
  textAlign(LEFT);
  // set a counter to list the ports backwards
  int yPos = 0;
  int xPos = 150;
  for(int i=numPorts-1; i>=0; i--){
    button[i] = new Radio(xPos, 130+(yPos*75),12,color(180),color(80),color(255),i,button);            // if want to reposition radio buttons change the number being multiplied by ypos
    text(serialPorts[i],xPos+15, 135+(yPos*75));
    yPos++;
    if(yPos > height-30){
      yPos = 0; xPos+=100;
    }
  }
  int p = numPorts;
  fill(233,0,0);
  button[p] = new Radio(xPos, 130+(yPos*75),12,color(180),color(80),color(255),p,button);
  text("Refresh Serial Ports List",xPos+15, 135+(yPos*75));

  textFont(font);
  textAlign(CENTER);
}

 void autoScanPorts(){
  if(Serial.list().length != numPorts){
    if(Serial.list().length > numPorts){
      println("New Ports Opened!");
      int diff = Serial.list().length - numPorts;  // was serialPorts.length
      serialPorts = expand(serialPorts,diff);
      numPorts = Serial.list().length;
    }else if(Serial.list().length < numPorts){
      println("Some Ports Closed!");
      numPorts = Serial.list().length;
    }
    refreshPorts = true;
    return;
  }
 }
