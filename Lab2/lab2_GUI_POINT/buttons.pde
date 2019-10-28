
void Stress() {
  stress_f=true;
  savedTime = millis();
  
  songCounter=0;
}

void Meditation() {
  med_f=true;
  savedTime = millis();
}


void MainMenu(){
   stress_f=false;
   med_f=true;
}
