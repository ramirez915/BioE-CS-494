#include <StopWatch.h>

float force[4];
float mappedForce[4];

int f_s0=A0;
int f_s1=A1;
int f_s2=A2;
int f_s3=A3;


int led_w1=9;
int led_g=6;
int led_w2=5;
int led_r=3;

void setup() {
  // initialize the serial communication:
  Serial.begin(115200);
  //outputs for the leds
  pinMode(led_w1, OUTPUT); 
  pinMode(led_g, OUTPUT);
  pinMode(led_w2, OUTPUT); 
  pinMode(led_r, OUTPUT);  

  
  
  //analogue inputs from FRSs
  pinMode(f_s0, INPUT); 
  pinMode(f_s1, INPUT);
  pinMode(f_s2, INPUT); 
  pinMode(f_s3, INPUT); 

}

void loop() {
  force[0]=analogRead(f_s0);
  force[1]=analogRead(f_s1);
  force[2]=analogRead(f_s2);
  force[3]=analogRead(f_s3);

  Serial.println(force[0]);
//  Serial.print(",");
//  Serial.println(force[1]);
//  Serial.print(",");
//  Serial.println(force[2]);
//  Serial.print(",");
//  Serial.println(force[3]);

  
  //mapping force_inputs with leds_outputs
  for(int i=0; i< 4; i++){
    mappedForce[i] = map(force[i],0,1023,0,255);
  }

//  Serial.println("white-1");
//  Serial.println(mappedForce[0]);
//  Serial.println("green");
//  Serial.println(mappedForce[1]);
//  Serial.println("white-2");
//  Serial.println(mappedForce[2]);
//  Serial.println("red");
//  Serial.println(mappedForce[3]);

  
  analogWrite(led_w1,mappedForce[0]);
  analogWrite(led_g,mappedForce[1]);
  analogWrite(led_w2,mappedForce[2]);
  analogWrite(led_r,mappedForce[3]);

  delay(50);
}
