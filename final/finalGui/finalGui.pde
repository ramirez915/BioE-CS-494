import processing.serial.*;  // Serial library makes it possible to talk to Arduino
import controlP5.*; // import ControlP5 library
import grafica.*;    // for graphing
import processing.sound.*;    // for vocal letters

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
Textlabel watchLbl;
//--------------------------------------------------------

//----------------------------------------------------------------------------------- keys
// 1 second between taps to determine a char selection                                          // no uppercase nor numbers for now
String[] key1 = new String[] {"a","b","c","d","e"};                // key 1 thumb
String[] key2 = new String[] {"f","g","h","i","j","k"};            // key 2 pointing finger
String[] key3 = new String[] {"l","m","n","o","p"};
String[] key4 = new String[] {"q","r","s","t","u"};
String[] key5 = new String[] {"v","w","x","y","z"};
String[] key6 = new String[] {" ", "del"};
boolean t9On = false;
//------------------------------------------
SoundFile vocalA = new SoundFile(this,sketchPath("A.wav"));
SoundFile vocalB = new SoundFile(this,sketchPath("B.wav"));
SoundFile vocalC = new SoundFile(this,sketchPath("C.wav"));
SoundFile vocalD = new SoundFile(this,sketchPath("D.wav"));
SoundFile vocalE = new SoundFile(this,sketchPath("E.wav"));
SoundFile vocalF = new SoundFile(this,sketchPath("F.wav"));
SoundFile vocalG = new SoundFile(this,sketchPath("G.wav"));
SoundFile vocalH = new SoundFile(this,sketchPath("H.wav"));
SoundFile vocalI = new SoundFile(this,sketchPath("I.wav"));
SoundFile vocalJ = new SoundFile(this,sketchPath("J.wav"));
SoundFile vocalK = new SoundFile(this,sketchPath("K.wav"));
SoundFile vocalL = new SoundFile(this,sketchPath("L.wav"));
SoundFile vocalM = new SoundFile(this,sketchPath("M.wav"));
SoundFile vocalN = new SoundFile(this,sketchPath("N.wav"));
SoundFile vocalO = new SoundFile(this,sketchPath("O.wav"));
SoundFile vocalP = new SoundFile(this,sketchPath("P.wav"));
SoundFile vocalQ = new SoundFile(this,sketchPath("Q.wav"));
SoundFile vocalR = new SoundFile(this,sketchPath("R.wav"));
SoundFile vocalS = new SoundFile(this,sketchPath("S.wav"));
SoundFile vocalT = new SoundFile(this,sketchPath("T.wav"));
SoundFile vocalU = new SoundFile(this,sketchPath("U.wav"));
SoundFile vocalV = new SoundFile(this,sketchPath("V.wav"));
SoundFile vocalW = new SoundFile(this,sketchPath("W.wav"));
SoundFile vocalX = new SoundFile(this,sketchPath("X.wav"));
SoundFile vocalY = new SoundFile(this,sketchPath("Y.wav"));
SoundFile vocalZ = new SoundFile(this,sketchPath("Z.wav"));
SoundFile vocalSpace = new SoundFile(this,sketchPath("Space.wav"));
SoundFile vocalDelete = new SoundFile(this,sketchPath("Delete.wav"));
 
SoundFile[] vocalKey1 = new SoundFile[] {vocalA,vocalB,vocalC,vocalD,vocalE};
SoundFile[] vocalKey2 = new SoundFile[] {vocalF,vocalG,vocalH,vocalI,vocalJ,vocalK};
SoundFile[] vocalKey3 = new SoundFile[] {vocalL,vocalM,vocalN,vocalO,vocalP};
SoundFile[] vocalKey4 = new SoundFile[] {vocalQ,vocalR,vocalS,vocalT,vocalU};
SoundFile[] vocalKey5 = new SoundFile[] {vocalV,vocalW,vocalX,vocalY,vocalZ};
SoundFile[] vocalKey6 = new SoundFile[] {vocalSpace,vocalDelete};




//----------------------------------------------                      // capacitors
//Cap c1 = new Cap(key1,vocalKey1);
//Cap c2 = new Cap(key2,vocalKey2);
//Cap c3 = new Cap(key3,vocalKey3);
//Cap c4 = new Cap(key4,vocalKey4);
//Cap c5 = new Cap(key5,vocalKey5);
//Cap c6 = new Cap(key6,vocalKey6);

Cap c1 = new Cap(key6,vocalKey6);
Cap c2 = new Cap(key1,vocalKey1);
Cap c3 = new Cap(key2,vocalKey2);
Cap c4 = new Cap(key3,vocalKey3);
Cap c5 = new Cap(key4,vocalKey4);
Cap c6 = new Cap(key5,vocalKey5);

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

//----------------------------------------------------- vocals are on their own tab

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
      counter++;
      
    }catch(RuntimeException e){
      e.printStackTrace();
    }
  }
}
//---------------------------------------------- end of serialEvent

Cap getCap(String wantedCap){
  switch(wantedCap){
    case "C1":
      c1.capState = true;
      return c1;
    case "C2":
      c2.capState = true;
      return c2;
    case "C3":
      c3.capState = true;
      return c3;
    case "C4":
      c4.capState = true;
      return c4;
    case "C5":
      c5.capState = true;
      return c5;
    case "C6":
      c6.capState = true;
      return c6;
  }
  return null;
}

void parseData2(String capAsStr){
  Cap capObj = getCap(capAsStr);
  if(capObj != null && capObj.capState == true){
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
        println("1st inc");
      }
      else{
        // else we are within the time thr so we can go to the next letter
        capObj.watch.stop();
        capObj.watch.reset();
        capObj.incCounter();
        capObj.watch.start();
        println("> 1 inc");
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
      //println("watch time: "+c.watch.second() + "s");
      //println("cap counter: "+c.counter);
      
      // display current letter here*******************************************************************
      
      // hit the time thr so set letter
      if(c.watch.second() >= 2){
        c.setLetter();          // this stops and resets the watch
      }
    }
  }
}
