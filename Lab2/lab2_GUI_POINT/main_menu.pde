void buttons_draw(){
  
  
  //// bpm Plot
  //bpmPlot = new GPlot(this,1300,0);
  //bpmPlot.setTitleText("BPM Monitor");
  //bpmPlot.getXAxis().setAxisLabelText("x axis");
  //bpmPlot.getYAxis().setAxisLabelText("AVERAGE BPM");
  //bpmPlot.setDim(500,500);
  //bpmPlot.setXLim(0,3);      // want to have the changing bpm gauge in the middle
  //bpmPlot.setYLim(0,130);   // lim 0 - 130 bpm
  //bpmPlot.startHistograms(GPlot.VERTICAL);
  //bpmPlot.getHistogram().setBgColors(new color[]{ color(0,0,255,50)});
  
  
  
  // adds buttons to the window
  cp5 = new ControlP5(this);
  font = createFont("SignPainter-HouseScriptSemibold", 30);    // custom fonts for buttons and title
  //font = createFont("Arial", 20);    // custom fonts for buttons and title

  
  cp5.addButton("Stress")
    .setPosition(20,50)
    .setSize(160, 90)
    .setFont(font);
   // .setColorBackground(100);
  
  cp5.addButton("Meditation")
    .setPosition(20,150)
    .setSize(160, 90)
    .setFont(font);
    //.setColorBackground(100);
}



void main_menu_draw(){
  cp5.addButton("MainMenu")     //"alloff" is the name of button
    .setPosition(20, 250)  //x and y coordinates of upper left corner of button
    .setSize(160, 90)      //(width, height)
    .setFont(font);
    //.setColorBackground(100);
}
