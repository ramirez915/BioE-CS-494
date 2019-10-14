#include <StopWatch.h>
#include<Wire.h>
const int MPU_addr=0x1c;  // I2C address of the MPU-6050
int16_t AcX,AcY,AcZ,Tmp,GyX,GyY,GyZ;


float force[4];
float mappedForce[4];

int mf=A0;
int lf=A1;
int mm=A2;
int heel=A3;


int mf_led=9;
int lf_led=6;
int mm_led=5;
int heel_led=3;

void setup() {
//  // initialize the serial communication:
//  Serial.begin(115200);
//  //outputs for the leds
//  pinMode(mf_led, OUTPUT); 
//  pinMode(lf_led, OUTPUT);
//  pinMode(mm_led, OUTPUT); 
//  pinMode(heel_led, OUTPUT);  
//
//  
//  
//  //analogue inputs from FRSs
//  pinMode(mf, INPUT); 
//  pinMode(lf, INPUT);
//  pinMode(mm, INPUT); 
//  pinMode(heel,NPUT); 
//
//
//



  Wire.begin();
  Wire.beginTransmission(MPU_addr);
  Wire.write(0x6B);  // PWR_MGMT_1 register
  Wire.write(0);     // set to zero (wakes up the MPU-6050)
  Wire.endTransmission(true);
  Serial.begin(9600);

}

void loop() {
//  force[0]=analogRead(f_s0);
//  force[1]=analogRead(f_s1);
//  force[2]=analogRead(f_s2);
//  force[3]=analogRead(f_s3);
//
//  Serial.println(force[0]);
////  Serial.println(force[1]);
////  Serial.println(force[2]);
////  Serial.println(force[3]);
//
//  
//  //mapping force_inputs with leds_outputs
//  for(int i=0; i< 4; i++){
//    mappedForce[i] = map(force[i],0,1023,0,255);
//  }
//
////  Serial.println("white-1");
////  Serial.println(mappedForce[0]);
////  Serial.println("green");
////  Serial.println(mappedForce[1]);
////  Serial.println("white-2");
////  Serial.println(mappedForce[2]);
////  Serial.println("red");
////  Serial.println(mappedForce[3]);
//
//  
//  analogWrite(mf_led,mappedForce[0]);
//  analogWrite(lf_led,mappedForce[1]);
//  analogWrite(mm_led,mappedForce[2]);
//  analogWrite(heel_led,mappedForce[3]);


  
  Wire.beginTransmission(MPU_addr);
  Wire.write(0x3B);  // starting with register 0x3B (ACCEL_XOUT_H)
  Wire.endTransmission(false);
  Wire.requestFrom(MPU_addr,14,true);  // request a total of 14 registers
  AcX=Wire.read()<<8|Wire.read();  // 0x3B (ACCEL_XOUT_H) & 0x3C (ACCEL_XOUT_L)    
  AcY=Wire.read()<<8|Wire.read();  // 0x3D (ACCEL_YOUT_H) & 0x3E (ACCEL_YOUT_L)
  AcZ=Wire.read()<<8|Wire.read();  // 0x3F (ACCEL_ZOUT_H) & 0x40 (ACCEL_ZOUT_L)
  Tmp=Wire.read()<<8|Wire.read();  // 0x41 (TEMP_OUT_H) & 0x42 (TEMP_OUT_L)
  GyX=Wire.read()<<8|Wire.read();  // 0x43 (GYRO_XOUT_H) & 0x44 (GYRO_XOUT_L)
  GyY=Wire.read()<<8|Wire.read();  // 0x45 (GYRO_YOUT_H) & 0x46 (GYRO_YOUT_L)
  GyZ=Wire.read()<<8|Wire.read();  // 0x47 (GYRO_ZOUT_H) & 0x48 (GYRO_ZOUT_L)
  Serial.print("AcX = "); Serial.print(AcX);
  Serial.print(" | AcY = "); Serial.print(AcY);
  Serial.print(" | AcZ = "); Serial.print(AcZ);
  Serial.print(" | Tmp = "); Serial.print(Tmp/340.00+36.53);  //equation for temperature in degrees C from datasheet
  Serial.print(" | GyX = "); Serial.print(GyX);
  Serial.print(" | GyY = "); Serial.print(GyY);
  Serial.print(" | GyZ = "); Serial.println(GyZ);
  delay(333);



//
//
//
//  
//
//  delay(50);

}
