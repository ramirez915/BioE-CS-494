#include <StopWatch.h>

float force=[];

int f_s0=A0;
int f_s1=A1;
int f_s2=A2;
int f_s3=A3;

void setup() {
  // initialize the serial communication:
  Serial.begin(115200);
  //outputs for the leds
  pinMode(10, OUTPUT); 
  pinMode(11, OUTPUT); 
  //analogue inputs from FRSs
  pinMode(A0, INPUT); 
  pinMode(A1, INPUT);
  pinMode(A2, INPUT); 
  pinMode(A3, INPUT); 

}

void loop() {
  
    force[i]=analogRead(f_s0);
    fore
    
  }
}
