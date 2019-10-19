#include <StopWatch.h>
#include<Wire.h>
const int MPU_addr=0x1c;  // I2C address of the MPU-6050
int16_t AcX,AcY,AcZ,Tmp,GyX,GyY,GyZ;


int change=1;
int sect=3;


//sect1 vars:
int distance = 100;
int step_count = 0;
int cadence;
StopWatch step_timer;

float step_length;
float stride_length;
float walking_speed;



//sect2 vars:

int rndstate[5];
int state=0;
int MFN[];

float pmm;
float pmf;
float plf;
float pheel;



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

bool heel_s=0;
bool mm_s=0;
bool mf_s=0;
bool lf_s=0;


//sect 4

float dir;


#include <Wire.h>
const int MPU = 0x68; // MPU6050 I2C address
float AccX, AccY, AccZ;
float GyroX, GyroY, GyroZ;
float accAngleX, accAngleY, gyroAngleX, gyroAngleY, gyroAngleZ;
float roll, pitch, yaw;
float AccErrorX, AccErrorY, GyroErrorX, GyroErrorY, GyroErrorZ;
float elapsedTime, currentTime, previousTime;
int c = 0;



// function that sends over the data to processing once it is all collected
//----------------------------------------------------------------------------------------- mode-color-ecg-resp-bpm-rRate
void sendData(){
  Serial.print(sect);
  Serial.print("-");
  Serial.print(mappedForce[0]);
  Serial.print("-");
  Serial.print(mappedForce[1]);
  Serial.print("-");
  Serial.print(mappedForce[2]);
  Serial.print("-");
  Serial.print(mappedForce[3]);
  Serial.print("-");
  Serial.println(dir);
  Serial.print("-");
  Serial.println(health);
  Serial.print("-");
  Serial.println(diff_health);
}


void calculate_IMU_error() {
  // We can call this funtion in the setup section to calculate the accelerometer and gyro data error. From here we will get the error values used in the above equations printed on the Serial Monitor.
  // Note that we should place the IMU flat in order to get the proper values, so that we then can the correct values
  // Read accelerometer values 200 times
  while (c < 200) {
    Wire.beginTransmission(MPU);
    Wire.write(0x3B);
    Wire.endTransmission(false);
    Wire.requestFrom(MPU, 6, true);
    AccX = (Wire.read() << 8 | Wire.read()) / 16384.0 ;
    AccY = (Wire.read() << 8 | Wire.read()) / 16384.0 ;
    AccZ = (Wire.read() << 8 | Wire.read()) / 16384.0 ;
    // Sum all readings
    AccErrorX = AccErrorX + ((atan((AccY) / sqrt(pow((AccX), 2) + pow((AccZ), 2))) * 180 / PI));
    AccErrorY = AccErrorY + ((atan(-1 * (AccX) / sqrt(pow((AccY), 2) + pow((AccZ), 2))) * 180 / PI));
    c++;
  }
  //Divide the sum by 200 to get the error value
  AccErrorX = AccErrorX / 200;
  AccErrorY = AccErrorY / 200;
  c = 0;
  // Read gyro values 200 times
  while (c < 200) {
    Wire.beginTransmission(MPU);
    Wire.write(0x43);
    Wire.endTransmission(false);
    Wire.requestFrom(MPU, 6, true);
    GyroX = Wire.read() << 8 | Wire.read();
    GyroY = Wire.read() << 8 | Wire.read();
    GyroZ = Wire.read() << 8 | Wire.read();
    // Sum all readings
    GyroErrorX = GyroErrorX + (GyroX / 131.0);
    GyroErrorY = GyroErrorY + (GyroY / 131.0);
    GyroErrorZ = GyroErrorZ + (GyroZ / 131.0);
    c++;
  }
  //Divide the sum by 200 to get the error value
  GyroErrorX = GyroErrorX / 200;
  GyroErrorY = GyroErrorY / 200;
  GyroErrorZ = GyroErrorZ / 200;
  // Print the error values on the Serial Monitor
  Serial.print("AccErrorX: ");
  Serial.println(AccErrorX);
  Serial.print("AccErrorY: ");
  Serial.println(AccErrorY);
  Serial.print("GyroErrorX: ");
  Serial.println(GyroErrorX);
  Serial.print("GyroErrorY: ");
  Serial.println(GyroErrorY);
  Serial.print("GyroErrorZ: ");
  Serial.println(GyroErrorZ);
}



void read_IMU() {
  
  // === Read acceleromter data === //
  Wire.beginTransmission(MPU);
  Wire.write(0x3B); // Start with register 0x3B (ACCEL_XOUT_H)
  Wire.endTransmission(false);
  Wire.requestFrom(MPU, 6, true); // Read 6 registers total, each axis value is stored in 2 registers
  //For a range of +-2g, we need to divide the raw values by 16384, according to the datasheet
  AccX = (Wire.read() << 8 | Wire.read()) / 16384.0; // X-axis value
  AccY = (Wire.read() << 8 | Wire.read()) / 16384.0; // Y-axis value
  AccZ = (Wire.read() << 8 | Wire.read()) / 16384.0; // Z-axis value
  // Calculating Roll and Pitch from the accelerometer data
  accAngleX = (atan(AccY / sqrt(pow(AccX, 2) + pow(AccZ, 2))) * 180 / PI) - 0.58; // AccErrorX ~(0.58) See the calculate_IMU_error()custom function for more details
  accAngleY = (atan(-1 * AccX / sqrt(pow(AccY, 2) + pow(AccZ, 2))) * 180 / PI) + 1.58; // AccErrorY ~(-1.58)
  // === Read gyroscope data === //
  previousTime = currentTime;        // Previous time is stored before the actual time read
  currentTime = millis();            // Current time actual time read
  elapsedTime = (currentTime - previousTime) / 1000; // Divide by 1000 to get seconds
  Wire.beginTransmission(MPU);
  Wire.write(0x43); // Gyro data first register address 0x43
  Wire.endTransmission(false);
  Wire.requestFrom(MPU, 6, true); // Read 4 registers total, each axis value is stored in 2 registers
  GyroX = (Wire.read() << 8 | Wire.read()) / 131.0; // For a 250deg/s range we have to divide first the raw value by 131.0, according to the datasheet
  GyroY = (Wire.read() << 8 | Wire.read()) / 131.0;
  GyroZ = (Wire.read() << 8 | Wire.read()) / 131.0;
  // Correct the outputs with the calculated error values
  GyroX = GyroX + 0.56; // GyroErrorX ~(-0.56)
  GyroY = GyroY - 2; // GyroErrorY ~(2)
  GyroZ = GyroZ + 0.79; // GyroErrorZ ~ (-0.8)
  // Currently the raw values are in degrees per seconds, deg/s, so we need to multiply by sendonds (s) to get the angle in degrees
  gyroAngleX = gyroAngleX + GyroX * elapsedTime; // deg/s * s = deg
  gyroAngleY = gyroAngleY + GyroY * elapsedTime;
  yaw =  yaw + GyroZ * elapsedTime;
  // Complementary filter - combine acceleromter and gyro angle values
  roll = 0.96 * gyroAngleX + 0.04 * accAngleX;
  pitch = 0.96 * gyroAngleY + 0.04 * accAngleY;
  
  // Print the values on the serial monitor
//  Serial.print(roll);
//  Serial.print("/");
//  Serial.print(pitch);
//  Serial.print("/");
//  Serial.println(yaw);

}








void acquire_signal () {
  
  force[0]=analogRead(f_s0);
  force[1]=analogRead(f_s1);
  force[2]=analogRead(f_s2);
  force[3]=analogRead(f_s3);

  Serial.println(force[0]);
//  Serial.println(force[1]);
//  Serial.println(force[2]);
//  Serial.println(force[3]);

  
  //mapping force_inputs with leds_outputs
  for(int i=0; i< 4; i++){
    mappedForce[i] = map(force[i],0,1023,0,255);

    change=0;
    if(mappedForce[i]>thr) {

      if(i==0){
        heel_s=1;
        change=1;
      }
      else if(i==1){
        mm_s=2;
      }
      else if(i==2){
        mf_s=3;
      }
      else if(i==1){
        ml_s=4;
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

  
  analogWrite(mf_led,mappedForce[0]);
  analogWrite(lf_led,mappedForce[1]);
  analogWrite(mm_led,mappedForce[2]);
  analogWrite(heel_led,mappedForce[3]);

//read IMU data:

if(sect==3) {
  
read_IMU();

}

//  delay(50);


}



int calcMep(){

  float totalMep; // cumulative value
  float MEP; //MEP value taken each step

  float topVal = (pmm + pmf) * 100;
  float bottomVal = (pmf + plf + pmm + pheel + 0.001);

  MEP = topVal / bottomVal; //MEP calculation per step
  totalMEP = totalMEP + MEP; // add the MEP value taken per step to the cumulative value

  return totalMEP;
  
}


void compute_reset {

    for(int i=0; i< 5; i++){
  avg[i]=avg[i]/nacquis;
    }
    
  pmm=avg[1];
  pmf=avg[2];
  plf=avg[3];
  pheel=avg[4];  

//RECOGNIZE THE MODALITIES BASE ON THE AVG VALUES:

    if(pmf+plf<thrheel){
      rec[state]=1//pattern heel
    }

    if(pheel<thrtip){
      rec[state]=2//pattern tiptoeing
    }

    if(plf<thrint){
      rec[state]=3//pattern intoeing
    }

    if(pmm+pmf<throut){
      rec[state]=4//pattern outtoeing
    }

    else {
      rec[state]=5//normal gait
      
      }
    }
    
    MFN[state]=calcMep();

    //reset avg and data:
    for(int i=0; i< 5; i++){
      
      avg[i]=0;
      
      for(int j=0; j< nacquis; j++){
      data[i][j]=0;
    }

    nacquis=0;
    
    state++;

    //PLOT ON PROCESSING WHAT PHASE IS RECOGNIZED

}

void sect 1 (){

  
  step_timer.start();
  
  
  while(step_timer.elapsed() <= 120000) {
    

  acquire_signal();
  
    if (mf_sensor == 1 || lf_sensor == 1 || mm_sensor == 1 || heel_sensor == 1){
      if (step_count == 0){
        step_count += 1; //to keep track of the total no. of Step Counts 
      }
      else{
        step_count += 2;
      }
    }
    
   
    if (step_timer.elapsed() == 60000){
      cadence = step_count;  //to output the Cadence: Number of steps in a minute
    }
     
  }
  
  step_length = distance / step_count; //computing Step Length
  
  stride_length = step_length * 2; //computing Stride Length
  
  walking_speed = cadence * step_length; //Computing speed: distance covered in a given time (1 min)

  step_timer.stop();
  

  // DISPLAY IN PROCESSING

  sendData();
  
  }




void sect 2 (){

 5gait_timer.start();
 
 int istant=0;

// GENERATE RANDOM ACQUISITION OF PATTERNS:

//for(int i=0; i< 5; i++){
//
//
//  rndstate[i]=functionrandom();
//}

//consider 90000 for recording plus 5*5 between the actions
 while(5gat_timer.elapsed() <= 155000) {

  acquire_signal();


//save data in array matrix at each iteration
if(change==1){

  for(int i=0; i< 5; i++){
    //save data in a matrix
  data[i][istant]=mappedForce[i];
  istant++;
  avg[i]=avg[i]+mappedForce[i];
  
  nacquis++;
  
}

}

  
  if(5gat_timer.elapsed()>30000 and state==0){
    
  compute_reset();
    
  }

if(5gat_timer.elapsed()>60000){

    compute_reset();
    
  }


  if(5gat_timer.elapsed()>90000){

    compute_reset();

    
  }


  if(5gat_timer.elapsed()>120000){

    compute_reset();
  
  }
if(5gat_timer.elapsed()>150000){

    compute_reset();
    state=0;
  }

    
  }
    
  }




  

void sect 3 (){


//THE DATA SHOULD BE ALREADY BIAS CORRECTED BY THE FUNCTION FOR THE IMU ERROR


//

dir=0;

//detect movement:

if(abs(Accz)>thrmovem or abs(ccAngleY)>thrmovem or abs(ccAngleX)>thrmovem) {


if(AccZ>0){

  //move right
  dir=0.5;
  Serial.println(1/2);
}

if(AccZ<0){

  //move left
  dir=-0.5;
  Serial.println(-1/2);
}



if(accAngleY<0 and aaccAngleX>0){

  //move forward
  dir=1;
  Serial.println(1);
  
}

if(accAngleY>0 and aaccAngleX>0){

  //move backward
  dir=-1;
  Serial.println(-1);
}

}

SendData();

}




void sect4 (){


//insert age of subject

while(!

age=Serial.read();

}

//set speed_age

if(age>){
speed_age= 
}

if(age>){
speed_age= 
}

if(age>){
speed_age= 
}


//execute sect 1 to acquire the speed:
sect1();

//check speed


if(walking_speed < speed_age) {

  health=0;
  diff_speed=speed_age-walking_speed;
  
}


SendData();

//

  
  }


void exitmode (){
  
  }


void setup() {
  // initialize the serial communication:
  Serial.begin(115200);
  //outputs for the leds
  pinMode(mf_led, OUTPUT); 
  pinMode(lf_led, OUTPUT);
  pinMode(mm_led, OUTPUT); 
  pinMode(heel_led, OUTPUT);  

  
  
  //analogue inputs from FRSs
  pinMode(mf, INPUT); 
  pinMode(lf, INPUT);
  pinMode(mm, INPUT); 
  pinMode(heel,NPUT); 

   Serial.begin(19200);
  Wire.begin();                      // Initialize comunication
  Wire.beginTransmission(MPU);       // Start communication with MPU6050 // MPU=0x68
  Wire.write(0x6B);                  // Talk to the register 6B
  Wire.write(0x00);                  // Make reset - place a 0 into the 6B register
  Wire.endTransmission(true);        //end the transmission


}

void loop() {
  
   char val = Serial.read();

    // MODIFY FITNESS MODE WITH THE CODE TO GET THE FITNESS MODE AND COLORS**************
    // fitness mode
    
    if(val == '1'){       // section 1
      sec=1;
      sect1();
    }
    else if(val == '2'){       // section 2
      sec=2;
      sect2();
      
    }
   else if(val == '3'){       // section 3
      
      sect=3;
      sect3();
      
   }

   else if(val == '4'){       // section 3
      sec=4;
      sect4();
      
   }

   
    if(val == '4'){       // exit
      sect=5;
      exitMode();
      
   }

   
 }
