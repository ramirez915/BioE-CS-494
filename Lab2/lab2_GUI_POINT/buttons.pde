
void Stress() {
  stress_f=true;
  savedTime = millis();
  bpmbase=0;
}

void Meditation() {
  med_f=true;
  savedTime = millis();
  bpmbase=0;
}


void MainMenu(){
   stress_f=false;
   med_f=true;
}