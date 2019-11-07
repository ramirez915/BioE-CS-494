//size of GUI size(2000, 1200);

void sec4setup(){
  sec4Cp5 = new ControlP5(this);
  notHealthLbl = sec4Cp5.addTextlabel("NotHealth")
    .setText("So you are not as healthy as\n other people in your age group")
    .setPosition(700,450)
    .setColorValue(color(255))
    .setFont(createFont("MS Gothic",50));
  
  healthLbl = sec4Cp5.addTextlabel("Health")
    .setText("You are as healthy as your\naverage age based on your walking speed")
    .setPosition(700,450)
    .setColorValue(color(255))
    .setFont(createFont("MS Gothic",50));
    
  waitingLbl = sec4Cp5.addTextlabel("waiting")
    .setText("Please wait \n 2 minutes")
    .setPosition(1775,700)
    .setColorValue(color(255))
    .setFont(createFont("MS Gothic",30));
    
  sec4Inst = sec4Cp5.addTextlabel("sec4Inst")
    .setText("Please enter your age")
    .setPosition(725,100)
    .setColorValue(color(0))
    .setFont(createFont("MS Gothic",50))
    .hide();
    
  speedAgeLbl = sec4Cp5.addTextlabel("speedAgeLbl")
    .setText("Your speed age should be")
    .setPosition(600,1000)
    .setColorValue(color(0))
    .setFont(createFont("MS Gothic",50));
    
  speedAgeVal = sec4Cp5.addTextlabel("speedAgeVal")
    .setValue(Float.toString(0.0))
    .setPosition(1300,1000)
    .setColorValue(color(0))
    .setFont(createFont("MS Gothic",50));
    
    
  healthLbl.hide();
  notHealthLbl.hide();
  waitingLbl.hide();
  speedAgeLbl.hide();
  speedAgeVal.hide();
}

void calcSpeedAge(){
  int age = int(userInputStr);
  if(age>=20 && age<=29){
      speedAge = 0.18; //in meters per minute
  }
     
  else if(age>=30 && age<=39){
    speedAge = 0.11;
  }
   
  else if(age>=40 && age <=49){
    speedAge = 0.19;
  }
   
  else if(age>=50 && age<=59){
    speedAge = 0.27;
  }
  
  //update what is displayed on screen
  speedAgeVal.setValue(Float.toString(speedAge) + " meters per minute");
}





void resetSec4(){
  background(0,100,255);
  hideKeypad();
  firstRun = true;
  
  sec4Cp5.hide();
}
