//size of GUI size(2000, 1200);

void sec4setup(){
  sec4Cp5 = new ControlP5(this);
  notHealthLbl = sec4Cp5.addTextlabel("NotHealth")
    .setText("You are not as healthy as\n other people in your age group")
    .setPosition(500,700)
    .setColorValue(color(255))
    .setFont(createFont("MS Gothic",50));
  
  healthLbl = sec4Cp5.addTextlabel("Health")
    .setText("You are as healthy as\n other people in your age group")
    .setPosition(500,700)
    .setColorValue(color(255))
    .setFont(createFont("MS Gothic",50));
    
  waitingLbl = sec4Cp5.addTextlabel("waiting")
    .setText("Please wait walk\n160m in 2 minutes")
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
    .setText("Your predicted speed of walking\n based on your age should be")
    .setPosition(500,300)
    .setColorValue(color(0))
    .setFont(createFont("MS Gothic",50));
    
  speedAgeVal = sec4Cp5.addTextlabel("speedAgeVal")
    .setValue(Float.toString(0.0))
    .setPosition(800,500)
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
  // +-
  if(age>=20 && age<=29){
      speedAge = 5.46; //in meters per minute
  }
     
  else if(age>=30 && age<=39){
    speedAge = 9.31;
  }
   
  else if(age>=40 && age <=49){
    speedAge = 5.35;
  }
   
  else if(age>=50 && age<=59){
    speedAge = 3.65;
  }
  else if(age >= 60 && age <= 69){
    speedAge = 3.98;
  }
  else if(age >= 70){
    speedAge = 4.07;
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
