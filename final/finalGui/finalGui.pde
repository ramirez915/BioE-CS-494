import processing.serial.*;  // Serial library makes it possible to talk to Arduino
import controlP5.*; // import ControlP5 library
import grafica.*;    // for graphing
import processing.sound.*;    // for vocal letters

Serial port;
ControlP5 cp5;
String dataArr[] = new String[5];      // array that will store the data
String valueFromArduino;
int counter = 0;
PImage A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z;
PImage hand;

//------------------------------------------------------------------- labels
Textlabel mainLbl;
Button mm;
Button type;
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
  background(255,255,255);
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
  
  hand = loadImage ("hand.png");
  A = loadImage ("A.png");
  B = loadImage ("B.png");
  C = loadImage ("C.png");
  D = loadImage ("D.png");
  E = loadImage ("E.png");
  F = loadImage ("F.png");
  G = loadImage ("G.png");
  H = loadImage ("H.png");
  I = loadImage ("I.png");
  J = loadImage ("J.png");
  K = loadImage ("K.png");
  L = loadImage ("L.png");
  M = loadImage ("M.png");
  N = loadImage ("N.png");
  O = loadImage ("O.png");
  P = loadImage ("P.png");
  Q = loadImage ("Q.png");
  R = loadImage ("R.png");
  S = loadImage ("S.png");
  T = loadImage ("T.png");
  U = loadImage ("U.png");
  V = loadImage ("V.png");
  W = loadImage ("W.png");
  X = loadImage ("X.png");
  Y = loadImage ("Y.png");
  Z = loadImage ("Z.png");
  //S = loadImage ("Space.png");
 // S = loadImage ("Del.png");
}


void draw(){
  if(t9On){
    //hand
    image(hand, 700, 25, 1500, 1100);
    //finger one
    image(A, 1070, 480, 60, 60);
    image(B, 1100, 520, 60, 60);
    image(C, 1120, 570, 60, 60);
    image(D, 1150, 610, 60, 60);
    image(E, 1170, 660, 60, 60);
    //finger two
    image(F, 1274, 200, 60, 60);
    image(G, 1276, 260, 60, 60);
    image(H, 1280, 320, 60, 60);
    image(I, 1283, 380, 60, 60);
    image(J, 1286, 440, 60, 60);
    image(K, 1290, 500, 60, 60);
    //finger three
    image(L, 1440, 150, 60, 60);
    image(M, 1440, 210, 60, 60);
    image(N, 1432, 270, 60, 60);
    image(O, 1430, 330, 60, 60);
    image(P, 1430, 390, 60, 60);
    //finger four
    image(Q, 1540, 200, 60, 60);
    image(R, 1535, 260, 60, 60);
    image(S, 1535, 320, 60, 60);
    image(T, 1530, 380, 60, 60);
    image(U, 1530, 440, 60, 60);
    //finger five
    image(V, 1720, 350, 60, 60);
    image(W, 1700, 400, 60, 60);
    image(X, 1675, 450, 60, 60);
    image(Y, 1650, 500, 60, 60);
    image(Z, 1630, 550, 60, 60);
    
    checkWatches();
    parseData2(dataArr[0]);
    
    userInput.setText(inputStr);
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
