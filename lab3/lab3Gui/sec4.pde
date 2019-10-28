//size of GUI size(2000, 1200);

void sec4setup(){
  sec4Cp5 = new ControlP5(this);
  notHealthLbl = sec4Cp5.addTextlabel("NotHealth")
    .setText("You aren't as healthy as your average age based on your walking speed")
    .setPosition(1000,600)
    .setColorValue(color(255))
    .setFont(createFont("MS Gothic",30));
  
  healthLbl = sec4Cp5.addTextlabel("Health")
    .setText("You are as healthy as your average age based on your walking speed")
    .setPosition(1000,600)
    .setColorValue(color(255))
    .setFont(createFont("MS Gothic",30));
    
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
    
  healthLbl.hide();
  notHealthLbl.hide();
  waitingLbl.hide();
}

void calcSec4(){
  
}





void resetSec4(){
  background(0,100,255);
  hideKeypad();
  firstRun = true;
  
  healthLbl.hide();
  notHealthLbl.hide();
  waitingLbl.hide();
  sec4Inst.hide();
}
