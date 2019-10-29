/*     PulseSensor Amped HRV Poincare Plotter v1.1.0

This is an HRV visualizer code for Pulse Sensor.
Use this with PulseSensorAmped_Arduino_1.5.0 Arduino code and the Pulse Sensor Amped hardware.
This code will draw a Poincare Plot of the IBI (InterBeat Interval) passed from Arduino.
The Poincare method of visualizing HRV trends is to plot the current IBI against the last IBI.
key press commands included in this version:
  press 'S' to save a picture of the Processing window (JPG image saved in Sketch folder)
  press 'C' to clear the Poincare Plot
  press 'L' to trace a line through the last 20 data points
Created by Joel Murphy, Early 2013.
Updated Summer 2013 for efficiency and readability
This code released into the public domain without promises that it will work for your intended application.
Or that it will work at all, for that matter. I hereby disclaim.
*/

import processing.serial.*;  // Serial library makes it possible to talk to Arduino
import controlP5.*; // import ControlP5 library
import grafica.*;    // for graphing
import processing.sound.*;    // for music

ControlP5 cp5;
PFont font;                  // we will use text in this sketch
Serial port;                 // instantiate the Serial port

int IBI;                  // length of time between heartbeats in milliseconds (updated in serialEvent)
int[] bpm_arr={60,50,70};
int bpm;
int[] PPG;                // array of live PPG datapoints
int[] beatTimeX;          // array of X coordinates of Poincare Plot
int[] beatTimeY;          // array of Y coordinates of Poincare Plot
int numPoints = 100;      // size of coordinate arrays. ths sets number of displayed datapoints
color eggshell = color(255, 253, 248);
// initializing flags here
boolean pulse = false;    // pulse is made true in serialEvent when arduino sends new IBI value
boolean makeLine = false; // press 'L' to toggle a trace the last 20 dots on the Poincare Plot

// SERIAL PORT STUFF TO HELP YOU FIND THE CORRECT SERIAL PORT
String serialPort;
String[] serialPorts = new String[Serial.list().length];
boolean serialPortFound = false;
Radio[] button = new Radio[Serial.list().length*2];
int numPorts = serialPorts.length;
boolean refreshPorts = false;

//stress/med vars:

boolean stress_f=false;
boolean med_f=false;
int savedTime;
int song_Time=30000;
int songCounter=0;
boolean stressed=false;
int thr_stressed=55; //set to 70
int thr_med=40;
int count=0;
int bpmbase=0;
int it=0;
SoundFile song;
int passedTime=0;

GPlot bpmPlot;        // for grafica plot
int x1 = 0;    // starting position of the graph
int arduinoBPM = 0;

void setup() {                     // do all the sett'n up in the setup
size(2000,1300);                     // Stage size
//fullScreen();

frameRate(60);
beatTimeX = new int[numPoints];    // these two arrays hold the Poincare Plot data
beatTimeY = new int[numPoints];    // size of numPoints determines number of displayed points
PPG = new int[150];                // PPG array that that prints heartbeat waveform
// initialize data traces
resetDataTraces();

font = loadFont("Arial-BoldMT-36.vlw");
textFont(font);                    // general house-keeping in Processing
textAlign(CENTER);                 // text and shapes will be referenced to their center point
rectMode(CENTER);

background(120,0,0);
drawDataWindows();

// GO FIND THE ARDUINO
  fill(eggshell);
  text("Select Your Serial Port",350,50);
  listAvailablePorts();




// ecg and respPlots    regular plots to see signal from device
  bpmPlot = new GPlot(this,510,50);        //graph positioned at 300,0
  bpmPlot.setTitleText("BPM MONITOR");
  bpmPlot.getXAxis().setAxisLabelText("x axis");
  bpmPlot.getYAxis().setAxisLabelText("y axis");
  bpmPlot.setDim(300,300);
  bpmPlot.setXLim(0,50);
  bpmPlot.setYLim(0,120);    // y axis
  bpmPlot.activateZooming(2.0,CENTER,CENTER);


}  // END OF SETUP


void draw(){
  
if(serialPortFound){

   background(150);
//  DRAW THE BACKGROUND ELEMENTS AND TEXT


//it is better to first check the condition and then draw otherwise you draw and then have to modify the window
if(stress_f==true){
  
  stress_draw();
  stress_manage();
  main_menu_draw();
  writeAxisLabels_bpm();
  
}
if(med_f==true){
  
  med_draw();
  med_manage();
  main_menu_draw();
  writeAxisLabels_bpm();
}

else{
  buttons_draw();
}

  drawDataWindows();
  writeAxisLabels();
  
  point_care();



} else { // SCAN BUTTONS TO FIND THE SERIAL PORT

  autoScanPorts();

  if(refreshPorts){
    refreshPorts = false;
    drawDataWindows();
    listAvailablePorts();
  }

  for(int i=0; i<numPorts+1; i++){
    button[i].overRadio(mouseX,mouseY);
    button[i].displayRadio();
  }


}
}  //END OF DRAW

void drawDataWindows(){
  noStroke();
  fill(eggshell);
  rect(width/2-50,height/2+15,550,550,7);     // draw Poincare Plot window  FIRST POSITION THAN SIZE
  rect(width-85,(height/2)+15,150,550,7);     // draw the Pulse Sensor data window

}

void writeAxisLabels(){
  noStroke();
  fill(eggshell);                        // eggshell white
  textSize(32);
  text("HRV Poincare Plot",width/2-50,130);  // title
  fill(200);                                // draw the Plot coordinate values in grey
  
  text("0mS",width/2-50-275,height/2+15+275+15);                 // origin, scaled in mS
  for (int i=500; i<=1500; i+=500){         // print y axis values
    text(i, width/2-50-275,map(i,0,1500,height/2+15+275+15,height/2+15+275+15-550));
  }
  for (int i=500; i<=1500; i+=500){         // print  x axis values
    text(i, width/2-50-275+map(i,0,1500,0,550), height/2+15+275+15);
  }
  stroke(250,30,250);                       // draw gridlines in purple
  for (int i=0; i<1500; i+=100){            // draw grid lines on axes
    line(width/2-50-275,map(i,0,1500,height/2+15+275,height/2+15+275-550),width/2-50-275+10,map(i,0,1500,height/2+15+275,height/2+15+275-550)); //y axis
    line(width/2-50-275+map(i,0,1500,0,549),height/2+15+275+15,width/2-50-275+map(i,0,1500,0,549),height/2+15+275+15-10); // x axis
  }
  noStroke();
  fill(255,253,10);                                    // print axes legend in yellow, for fun
  text("n", width/2-50-275+map(750,0,1500, 0, 550), height/2+15+275+15+30);    // n is the most recent IBI value
  text("n-1",width/2-50-275-30,map(750,0,1500,height/2+15+275+15,height/2+15+275+15-550));               // n-1 is the one we got before n
}

void writeAxisLabels_bpm(){
  noStroke();
  fill(eggshell);                        // eggshell white
  textSize(32);
  text("bpm plot",width-85,(height/2)+15-300);  // title
  fill(200);                                // draw the Plot coordinate values in grey
  
  text("0mS",width/2-85-75,height/2+15+75);                 // origin, scaled in mS
  for (int i=30; i<=120; i+=30){         // print y axis values
    text(i, width-85-75-15,map(i,0,120,height/2+15+225,height/2+15+275-550));
  }
  for (int i=500; i<=1500; i+=500){         // print  x axis values
    text(i, width/2-50-275+map(i,0,1500,0,550), height/2+15+275+15);
  }
  stroke(250,30,250);                       // draw gridlines in purple
  for (int i=0; i<1500; i+=100){            // draw grid lines on axes
    line(width/2-50-275,map(i,0,1500,height/2+15+275,height/2+15+275-550),width/2-50-275+10,map(i,0,1500,height/2+15+275,height/2+15+275-550)); //y axis
    line(width/2-50-275+map(i,0,1500,0,549),height/2+15+275+15,width/2-50-275+map(i,0,1500,0,549),height/2+15+275+15-10); // x axis
  }
  noStroke();
  fill(255,253,10);                                    // print axes legend in yellow, for fun
  text("n", width/2-50-275+map(750,0,1500, 0, 550), height/2+15+275+15+30);    // n is the most recent IBI value
  text("n-1",width/2-50-275-30,map(750,0,1500,height/2+15+275+15,height/2+15+275+15-550));               // n-1 is the one we got before n
}


void listAvailablePorts(){
  println(Serial.list());    // print a list of available serial ports to the console
  serialPorts = Serial.list();
  fill(0);
  textFont(font,16);
  textAlign(LEFT);
  // set a counter to list the ports backwards
  int yPos = 0;
  int xPos = 150;
  for(int i=numPorts-1; i>=0; i--){
    button[i] = new Radio(xPos, 130+(yPos*20),12,color(180),color(80),color(255),i,button);
    text(serialPorts[i],xPos+15, 135+(yPos*20));
    yPos++;
    if(yPos > height-30){
      yPos = 0; xPos+=100;
    }
  }
  int p = numPorts;
  fill(233,0,0);
  button[p] = new Radio(xPos, 130+(yPos*20),12,color(180),color(80),color(255),p,button);
  text("Refresh Serial Ports List",xPos+15, 135+(yPos*20));

  textFont(font);
  textAlign(CENTER);
}

 void autoScanPorts(){
  if(Serial.list().length != numPorts){
    if(Serial.list().length > numPorts){
      println("New Ports Opened!");
      int diff = Serial.list().length - numPorts;	// was serialPorts.length
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

void resetDataTraces(){
  // initialize the PPG
  for (int i=0; i<150; i++){
   PPG[i] = height/2+15;             // initialize PPG widow with dataline at midpoint
  }
  // initialize the poncaire points
  for (int i=numPoints-1; i>=0; i--){  //
    beatTimeY[i] = 0;
    beatTimeX[i] = 0;
  }

}





// plots the data on the graph
void plotData(){
  // ADDING POINT TO PLOT
  bpmPlot.addPoint(new GPoint(x1,arduinoBPM));
  bpmPlot.setPoint(x1, new GPoint(x1,arduinoBPM));
  bpmPlot.getTitle().setText("BPM Monitor     Signal: " + str(arduinoBPM));
  
  println("plotted vals: arduinoBPM "+ arduinoBPM);
  
  x1++;  // move on to the next x coordinate
  
  //draw graphs
  bpmPlot.beginDraw();
  bpmPlot.drawBackground();
  bpmPlot.drawBox();
  bpmPlot.drawXAxis();
  bpmPlot.drawYAxis();
  bpmPlot.drawTitle();
  bpmPlot.drawLines();
  bpmPlot.endDraw();
  
  // at the max so scroll to the side    x axis
  if(x1 >= 50){
    bpmPlot.moveHorizontalAxesLim(3.0);    // if want faster scroll increase this value
  }
}
