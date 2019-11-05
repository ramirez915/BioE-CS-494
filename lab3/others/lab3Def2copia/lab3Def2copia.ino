#include <StopWatch.h>

int change=0;
int sect=0;

float force[4];
float mappedForce[4];

//acquire_signal

//int mf=A0;
//int lf=A1;
//int mm=A2;
//int heel=A3;
//
//int mf_led=9;
//int lf_led=6;
//int mm_led=5;
//int heel_led=3;

bool heel_s=0;
bool mm_s=0;
bool mf_s=0;
bool lf_s=0;

//sect1 vars:
int distance = 100;
int step_count = 0;
float cadence=0;
StopWatch step_timer;

float step_length=0;
float stride_length=0;
float walking_speed=0;
//int thr_step=100;
int thr_step=500;

//sect2 vars:
StopWatch gait_timer;
int rec[5];
int state=0;
float MFN[5];
const int max_steps=60;
float data[4][max_steps];
float avg[4];

//const int thrheel;
//const int thrint;
//int throut;
//int thrtip;

//sect 3 vars:
const int gain=10;
const int numReadings = 10;
int nacquis=0;
float dir=0;
float thrmovem=7;
float averagex=0; 
float averagey=0; 
float averagez=0; 

int cyf=0;
int cyb=0;
int czl=0;
int czr=0;
int thrcount=5;

//sect 4:
bool health=0;
bool virt_age=0;
int age;


void reset_values(){
  for (int i=0; i< 4; i++){
    avg[i]=0;
    for (int j=0; j<max_steps ; j++){
      data[i][j]=0;
    }
  }
  for (int i=0; i< 5; i++){
    MFN[i]=0;
  }
  for (int i=0; i< 5; i++){
    rec[i]=0;
  }
  for (int i=0; i< 4; i++){
      force[i]=0;
  }
}


void sendData(){
  Serial.print("-");
  Serial.print(force[0]);
  Serial.print("-");
  //lf
  Serial.print(force[1]);
  Serial.print("-");
  //mm
  Serial.print(force[2]);
  Serial.print("-");
  //heel
  Serial.print(force[3]);
  Serial.print("-");
}

void acquire_signal () {

  //Serial.print("in acquire");
  
  force[0]=analogRead(A0);
  force[1]=analogRead(A1);
  force[2]=analogRead(A2);
  force[3]=analogRead(A3);

  //Serial.println(force[0]);
//  Serial.println(force[1]);
//  Serial.println(force[2]);
//  Serial.println(force[3]);

  change=0;
  //mapping force_inputs with leds_outputs
  for(int i=0; i< 4; i++){
    mappedForce[i] = map(force[i],0,1023,0,255);

    if(force[i]>thr_step) {

      if(i==0){
        mf_s=1;
        change=1;
        //Serial.println("mf");
      }
      else if(i==1){
        lf_s=1;
        change=1;
        //Serial.println("lf");
      }
      else if(i==2){
        mm_s=1;
        change=1;
        //Serial.println("mm");
      }
      else if(i==3){
        heel_s=1;
        change=1;
        //Serial.println("heel");
      }
  }
  }
  
  //write function to send data to processing

//  Serial.println("white-1");
//  Serial.println(mappedForce[0]);
//  Serial.println("green");
//  Serial.println(mappedForce[1]);
//  Serial.println("white-2");
//  Serial.println(mappedForce[2]);
//  Serial.println("red");
//  Serial.println(mappedForce[3]);

  
  analogWrite(9,mappedForce[0]);
  analogWrite(6,mappedForce[1]);
  analogWrite(5,mappedForce[2]);
  analogWrite(3,mappedForce[3]);

//read IMU data:

  delay(20);
}



void setup() {
  // initialize the serial communication:
  Serial.begin(115200);
  //Serial.begin(19200);
  //LEDS:
  pinMode(9, OUTPUT); 
  pinMode(6, OUTPUT);
  pinMode(5, OUTPUT); 
  pinMode(3, OUTPUT);  

  //FRSs:
  pinMode(A0, INPUT); 
  pinMode(A1, INPUT);
  pinMode(A2, INPUT); 
  pinMode(A3,INPUT); 

  //setting array to 0
  reset_values();

}

void loop() {
  
   acquire_signal();
   sendData();
 }
