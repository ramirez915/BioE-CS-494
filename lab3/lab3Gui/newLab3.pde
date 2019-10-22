//float x,y, xmouse, ymouse;
//Blob[] blobs = new Blob[4];
//PShape bot;

//int count = 0;
//int counter=1;
//int[] pressure_MFP_cadence_velocity = new int [8];

//int step_count_read = 0;
//int pressure_heel_read = 0;
//int pressure_mm_read = 0;
//int pressure_mf_read = 0;
//int pressure_lf_read = 0;
//int cadence_read = 0;
//float velocity_read = 0;
//float mfp_read = 0;

//int calib=1;

//Textlabel cadence_label;
//Textlabel cadence_value;
//Textlabel speed_label;
//Textlabel speed_value;
//Textlabel step_count_label;
//Textlabel step_count_value;
//Textlabel MFP_label;
//Textlabel MFP_value;

//Textlabel Pressure_heel;
//Textlabel Pressure_mm;
//Textlabel Pressure_mf;
//Textlabel Pressure_lf;

//Textlabel Random_label;

//Button gait_calibration;

//Textlabel timer_value;

//Textlabel Normal_label;
//Textlabel Intoeing_label;
//Textlabel Outtoeing_label;
//Textlabel Tiptoeing_label;
//Textlabel Walking_heel_label;


//void setup() {
//  // List all the available serial ports
// printArray(Serial.list());
//  // Open the port you are using at the rate you want:
// myPort = new Serial(this, Serial.list()[2], 115200);
// myPort.clear();
//  // Throw out the first reading, in case we started reading 
//  // in the middle of a string from the sender.
// myPort.bufferUntil(lf);
  
//  size(1200, 650); // first one is the horizontal, second one is vertical
 
//  colorMode(HSB);
//    blobs[0] = new Blob(370,300); //heel: 0
//    blobs[1] = new Blob(635,260); //mm: 1
//    blobs[2] = new Blob(705,370); //lf: 2
//    blobs[3] = new Blob(800,290); //mf: 3
//// +290 +125
//    bot = loadShape("Sole.svg");
    
//  cp5 = new ControlP5(this);
  
//  cadence_label = cp5.addTextlabel("cadence_label")
//                 .setText("Cadence")
//                 .setPosition(50,50)
//                 .setColorValue(color( 61))
//                 .setFont(createFont("Helvetica",18))
//                 ;
//  cadence_value = cp5.addTextlabel("cadence_value")
//                 .setText("00")
//                 .setPosition(128,47)
//                 .setColorValue(color( 61))
//                 .setFont(createFont("Helvetica",24))
//                 ;
//  speed_label = cp5.addTextlabel("speed_label")
//                 .setText("Speed")
//                 .setPosition(50,85)
//                 .setColorValue(color( 61))
//                 .setFont(createFont("Helvetica",18))
//                 ; 
//  speed_value = cp5.addTextlabel("speed_value")
//                 .setText("00")
//                 .setPosition(108,80)
//                 .setColorValue(color( 61))
//                 .setFont(createFont("Helvetica",24))
//                 ;               
//  step_count_label = cp5.addTextlabel("step_count_label")
//                 .setText("Step Count")
//                 .setPosition(50,120)
//                 .setColorValue(color( 61))
//                 .setFont(createFont("Helvetica",18))
//                 ;
//  step_count_value = cp5.addTextlabel("step_count_value")
//                 .setText("00")
//                 .setPosition(147,115)
//                 .setColorValue(color( 61))
//                 .setFont(createFont("Helvetica",24))  
//                 ;
//  MFP_label = cp5.addTextlabel("MFP_label")
//                 .setText("MFP")
//                 .setPosition(530,85)
//                 .setColorValue(color( 61))
//                 .setFont(createFont("Helvetica",30))
//                 ; 
//  MFP_value = cp5.addTextlabel("MFP_value")
//                 .setText("00")
//                 .setPosition(600,80)
//                 .setColorValue(color( 61))
//                 .setFont(createFont("Helvetica",38))
//                 ;     
//  Pressure_heel = cp5.addTextlabel("Pressure_heel")
//                 .setText("00")
//                 //.setPosition(600,80)
//                 //.setColorValue(color( 61))
//                 //.setFont(createFont("Helvetica",38))
//                 ;    
//  Pressure_mm = cp5.addTextlabel("Pressure_mm")
//                 .setText("00")
//                 //.setPosition(600,80)
//                 //.setColorValue(color( 61))
//                 //.setFont(createFont("Helvetica",38))
//                 ;   
//  Pressure_mf = cp5.addTextlabel("Pressure_mf")
//                 .setText("00")
//                 //.setPosition(600,80)
//                 //.setColorValue(color( 61))
//                 //.setFont(createFont("Helvetica",38))
//                 ; 
//  Pressure_lf = cp5.addTextlabel("Pressure_lf")
//                 .setText("00")
//                 //.setPosition(600,80)
//                 //.setColorValue(color( 61))
//                 //.setFont(createFont("Helvetica",38))
//                 ;  
//  Normal_label = cp5.addTextlabel("Normal_label")
//                 .setText("NORMAL")
//                 .setPosition(523,450)
//                 .setColorValue(color(240,45, 61))
//                 .setFont(createFont("Helvetica",34))
//                 .hide();
//                 ; 
//  Intoeing_label = cp5.addTextlabel("Intoeing_label")
//                 .setText("IN-TOEING")
//                 .setPosition(525,450)
//                 .setColorValue(color(240,45, 61))
//                 .setFont(createFont("Helvetica",34))
//                 .hide();
//                 ; 
//  Outtoeing_label = cp5.addTextlabel("Outtoeing_label")
//                 .setText("OUT-TOEING")
//                 .setPosition(515,450)
//                 .setColorValue(color(240,45, 61))
//                 .setFont(createFont("Helvetica",34))
//                 .hide();
//                 ;    
//  Tiptoeing_label = cp5.addTextlabel("Tiptoeing_label")
//                 .setText("TIP-TOEING")
//                 .setPosition(515,450)
//                 .setColorValue(color(240,45, 61))
//                 .setFont(createFont("Helvetica",34))
//                 .hide();
//                 ; 
//  Walking_heel_label= cp5.addTextlabel("Walking_heel_label")
//                 .setText("WALKING ON THE HEEL")
//                 .setPosition(470,450)
//                 .setColorValue(color(240,45, 61))
//                 .setFont(createFont("Helvetica",34))
//                 .hide();
//                 ; 
//  Random_label= cp5.addTextlabel("Random")
//                 .setText("RANDOM")
//                 .setPosition(525,450)
//                 .setColorValue(color(240,45, 61))
//                 .setFont(createFont("Helvetica",34))
//                 .hide();
//                 ;                               
//  cp5.addButton("Gait Calibration")
//     .setValue(100)
//     .setPosition(40,180)
//     .setSize(200,80)
//     .setFont(createFont("Helvetica",20))
//     .setColorBackground(color(80))
//     .setColorForeground(color(100))
//     .setColorActive(color(140))
//     .activateBy(ControlP5.RELEASE)
//     ;    
//  cp5.addButton("Motion")
//     .setValue(100)
//     .setPosition(40,280)
//     .setSize(200,80)
//     .setFont(createFont("Helvetica",20))
//     .setColorBackground(color(80))
//     .setColorForeground(color(100))
//     .setColorActive(color(140))
//     .activateBy(ControlP5.RELEASE)
//     ;      
     
//  timer = new ControlTimer();
//  timer.setSpeedOfTime(1);
  
//  timer_value = cp5.addTextlabel("timer_value")
//                 .setText("30"+"s")
//                 .setPosition(550,520)
//                 .setColorValue(color(61))
//                 .setFont(createFont("Helvetica",50))
//                 .hide()
//                 ;
                 
//}

//void draw() {
//  background(900);
  
//  //Live Step count/
//  step_count_value.setText(str(step_count_read));
//  //Live Pressure values/
//  Pressure_heel.setText(str(pressure_heel_read));
//  Pressure_mm.setText(str(pressure_mm_read));
//  Pressure_mf.setText(str(pressure_mf_read));
//  Pressure_lf.setText(str(pressure_lf_read));
//  ///Live MFP/
//  MFP_value.setText(str(mfp_read));
//  ///Live Cadence/
//  cadence_value.setText(str(cadence_read));
//  //Live Speed/
//  speed_value.setText(str(velocity_read));

  
//   int time= (int)timer.time()/1000;
//   timer_value.show();
//  if(time<31)
//   timer_value.setValue(Integer.toString((30-time))+"s");
// if(time > 30){
//   counter++;
//    timer.reset(); 
//  }
  
//  if(counter==1)
//  {
//    Normal_label.show();
    
//  }
//  if(counter==2)
//  {
//    Normal_label.hide();
//    Intoeing_label.show();
    
//  }
//  if(counter==3)
//  {
//    Normal_label.hide();
//     Intoeing_label.hide();
//    Outtoeing_label.show();
    
//  }
// if(counter==4)
//  {
//    Normal_label.hide();
//    Intoeing_label.hide();
//    Outtoeing_label.hide();
//    Tiptoeing_label.show();
    
//  }
//  if(counter==5)
//  {
//    Normal_label.hide();
//    Intoeing_label.hide();
//    Outtoeing_label.hide();
//    Tiptoeing_label.hide();
//    Walking_heel_label.show();
    
//  }
//  if(counter==6)
//  {
//    Normal_label.hide();
//    Intoeing_label.hide();
//    Outtoeing_label.hide();
//    Tiptoeing_label.hide();
//    Walking_heel_label.hide();
//    Random_label.show();
    
//  }
//  if(counter==7)
//  {
//    Normal_label.hide();
//    Intoeing_label.hide();
//    Outtoeing_label.hide();
//    Tiptoeing_label.hide();
//    Walking_heel_label.hide();
//    MFP_label.hide();
//    MFP_value.hide();
//    timer_value.hide();
//    cadence_label.hide();
//    cadence_value.hide();
//    speed_label.hide();
//    speed_value.hide();
//    step_count_label.hide();
//    step_count_value.hide();
//  }
  
//  //xmouse = mouseX;
//  //ymouse = mouseY;
//  loadPixels();
//  for (int x = 0; x < width; x++) {
//    for (int y = 0; y < height; y++) {
//      int index = x + y * width;
//      float sum = 0;
//      for (Blob b : blobs) {
//        float d = dist(x, y, b.pos.x, b.pos.y);    
        
//        sum += 10 * b.r / d;    //add assing, which means sum + what comes next the = 
//      }
//      pixels[index] = color(255, sum, 255);
//    }
//  }

//  updatePixels();
// shape(bot, 200, 75, 800, 450);
 
// //blobs[0].setRadius((int)map(pressure_heel_read, 0, 255, 0, 80));
// if(pressure_mm_read == 0){
// blobs[0].setRadius((int)map(pressure_mm_read, 0, 255, 0, 80));
// }else{
// blobs[0].setRadius((int)map(pressure_mm_read + random(35,50), 0, 255, 0, 80));
// }
// blobs[1].setRadius((int)map(pressure_mm_read, 0, 255, 0, 80));
// if(pressure_mf_read == 0){
// blobs[2].setRadius((int)map(pressure_lf_read, 0, 255, 0, 80));
// }else{ blobs[2].setRadius((int)map(pressure_mf_read + random(35,50), 0, 255, 0, 80));}
// blobs[3].setRadius((int)map(pressure_mf_read, 0, 255, 0, 80));
 
//  for (Blob b : blobs) {
//    b.update();
//    b.show(); 
//  }
//  println(calib);
//  if(calib==0){
    
  
//  }
 
//   //drawArrow(int cx, int cy, int len, float angle, int weight, float[] arrow_color)
//   float [] color_up = {0, 0, 0}; 
//   drawArrow(140, 500, 50, 270, 6, color_up);
   
//   float [] color_down = {0, 0, 0}; 
//   drawArrow(140, 500, 50, 90, 6, color_down);
   
//   float [] color_left = {0, 0, 0}; 
//   drawArrow(140, 500, 50, 0, 6, color_left);
   
//   float [] color_right = {0, 0, 0}; 
//   drawArrow(140, 500, 50, 180, 6, color_right);
//}

//void serialEvent(Serial myPort) 
//{ 
//  try {
//  // read the serial buffer:
//  String myString = myPort.readStringUntil(lf);
 
//  // if we get any bytes other than the linefeed:
//  if (myString != null) 
//  {
//    // remove the linefeed
//    myString = trim(myString);
 
//    // split the string at the tabs and convert the sections into integers:
//    String myreading[] = split(myString, '\t');
//    count = myreading.length;
 
//    for (int i=0; i<count; i++)
//    {
//      switch(i){
//        case 0: 
//          step_count_read = int(myreading[i]);
//          break;
//        case 1:
//          pressure_heel_read = int(myreading[i]);
//          break;
//        case 2: 
//          pressure_mm_read = int(myreading[i]);
//          break;
//        case 3:
//          pressure_mf_read = int(myreading[i]);
//          break;
//        case 4:
//          pressure_lf_read = int(myreading[i]);
//          break;
//        case 5:
//          cadence_read = int(myreading[i]);
//          break;
//        case 6:
//          velocity_read = float(myreading[i]);
//          break;
//        case 7:
//          mfp_read = float(myreading[i]);
//          break;
//      }
//    }
//  }
//  }
  
//  catch(RuntimeException e) {
//    //e.printStackTrace();
//  }
  
//}

////boolean isMotion = false;
////public void Motion(int value){
////   Normal_label.hide();
////  Intoeing_label.hide();
////  Outtoeing_label.hide();
////  Tiptoeing_label.hide();
////  Walking_heel_label.hide();
////}
  
//void drawArrow(int cx, int cy, int len, float angle, int weight, float[] arrow_color){
//  strokeWeight(weight);
//  stroke(arrow_color[0], arrow_color[1], arrow_color[2]);
//  pushMatrix();
//  translate(cx, cy);
//  rotate(radians(angle));
//  line(0,0,len, 0);
//  line(len, 0, len - 8, -8);
//  line(len, 0, len - 8, 8);
//  popMatrix();
//}
