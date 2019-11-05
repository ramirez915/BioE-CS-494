void calcMep(){

  while (!esc){ // loop through code while the option is selected
    
  float totalMep; // cumulative value
  float MEP; //MEP value taken each step
  float MF;
  float LF;
  float MM;
  float heel;

  float topVal = (MM + MF) * 100;
  float bottomVal = (MF + LF + MM + heel + 0.001);

  MEP = topVal / bottomVal; //MEP calculation per step
  totalMEP = totalMEP + MEP; // add the MEP value taken per step to the cumulative value
  }

  return totalMEP;
  
}
