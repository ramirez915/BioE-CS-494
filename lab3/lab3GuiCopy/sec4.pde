//size of GUI size(2000, 1200);

void setupSec4(){
  sec4Cp5 = new ControlP5(this);
  notHealthLbl = sec4Cp5.addTextlabel("Not_Health")
    .setText("You aren't as healthy as your average age based on your walking speed")
    .setPosition(1000,600)
    .setColorValue(color(255))
    .setFont(createFont("Cambria",30));
  
  healthLbl = sec4Cp5.addTextlabel("Health")
    .setText("You aren't as healthy as your average age based on your walking speed")
    .setPosition(1000,600)
    .setColorValue(color(255))
    .setFont(createFont("Cambria",30));
    
  healthLbl.hide();
  notHealthLbl.hide();
}

void resetSec4(){
  background(69);
  hideKeypad();
  firstRun = true;
  
  healthLbl.hide();
  notHealthLbl.hide();
}
