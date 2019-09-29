 
#include <StopWatch.h>

StopWatch timer;
StopWatch sec(StopWatch::SECONDS);


float s1=0;
float s2=0;
bool maxf=false;
bool minf=true;
long ex_t, in_t;
float rr=0;

void setup() {
  // put your setup code here, to run once:
Serial.begin(115200);
timer.start();
sec.start();

}

void loop() {

  for(int j=0;j<360;j++)
  {
    s2=s1;
    //sec.elapsed()*
    s1=10*sec.elapsed()*((sin(j*0.0174533)+1));
    //Serial.println(s1);
   // Serial.print(" ");
    if(s1-s2<0 && minf==true) {
      
      maxf=true;
      minf=false;
      float in_t=timer.elapsed();
      //Serial.println(in_t);
      //Serial.print(" ");
      timer.reset();
      timer.start();
      }
      
     if(s1-s2>0 && maxf==true) {
      minf=true;
      maxf=false;
      float ex_t=timer.elapsed();
      //Serial.println(ex_t);
     // Serial.print(" ");
      timer.reset();
      timer.start();
      float breath=(ex_t+in_t)/1000.00;
      float rr=60.00/breath;
      Serial.println(rr);
     }

    
    //Serial.println(1000*(sin(j*0.0174533)+1));

//Serial.println(timer.elapsed());

    delay(15);
  }

  
}
