#include <StopWatch.h>

float force=[];

int f_s0=A0;
int f_s1=A1;
int f_s2=A2;
int f_s3=A3;

int led_1=10;
int led_1=11;
int led_1=12;
int led_1=13;

void setup() {
  // initialize the serial communication:
  Serial.begin(115200);
  //outputs for the leds
  pinMode(led_0, OUTPUT); 
  pinMode(led_1, OUTPUT);
  pinMode(led_2, OUTPUT); 
  pinMode(led_3, OUTPUT);  
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

    //mapping force_inputs with leds_outputs

    for(i=1





    
    digitalWrite(LED13,HIGH);

    digitalw
    
  }
}
