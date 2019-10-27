void main_menu(){
  
  
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
  font = createFont("SignPainter-HouseScriptSemibold", 20);    // custom fonts for buttons and title
  //font = createFont("Arial", 20);    // custom fonts for buttons and title

  
  cp5.addButton("Stress")
    .setPosition(10,50)
    .setSize(120, 70)
    .setFont(font)
  ;
  
  cp5.addButton("Meditation")
    .setPosition(10,150)
    .setSize(120, 70)
    .setFont(font)
  ;
  
  cp5.addButton("MainMenu")     //"alloff" is the name of button
    .setPosition(10, 250)  //x and y coordinates of upper left corner of button
    .setSize(120, 70)      //(width, height)
    .setFont(font)
  ;
}
