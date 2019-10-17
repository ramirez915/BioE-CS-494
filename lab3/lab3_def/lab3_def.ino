#include <StopWatch.h>
#include<Wire.h>
const int MPU_addr=0x1c;  // I2C address of the MPU-6050
int16_t AcX,AcY,AcZ,Tmp,GyX,GyY,GyZ;


int change=1;



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


//  delay(50);


}



int calcMep(){

  while (!esc){ // loop through code while the option is selected
    
  float totalMep; // cumulative value
  float MEP; //MEP value taken each step

  float topVal = (pmm + pmf) * 100;
  float bottomVal = (pmf + plf + pmm + pheel + 0.001);

  MEP = topVal / bottomVal; //MEP calculation per step
  totalMEP = totalMEP + MEP; // add the MEP value taken per step to the cumulative value
  }

  return totalMEP;
  
}


void compute_reset {
  
    for(int i=0; i< 5; i++){
  avg[i]=avg[i]/nacquis;
    }
    
  pmm=avg[];
  pmf=avg[];
  plf=avg[];
  pheel=avg[];  

//RECOGNIZE THE MODALITIES BASE ON THE AVG VALUES:

    if(pmf+plf<thrheel){
      rec[state]=//pattern heel
    }

    if(pheel<thrtip){
      rec[state]=//pattern tiptoeing
    }

    if(plf<thrint){
      rec[state]=//pattern intoeing
    }

    if(pmm+pmf<throut){
      rec[state]=//pattern outtoeing
    }

    else {
      rec[state]=//normal gait
      
      }
    }
    
    MFN[rnd[state]]=calcMep();

    //reset avg and data:
    for(int i=0; i< 5; i++){
      
      avg[i]=0;
      
      for(int j=0; j< nacquis; j++){
      data[i][j]=0;
    }

    nacquis=0;
    
    state++;

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

  
  }




void sect 2 (){

 5gait_timer.start();

// GENERATE RANDOM ACQUISITION OF PATTERNS:

for(int i=0; i< 5; i++){


  rndstate[i]=functionrandom();
}
//consider 90000 for recording plus 5*5 between the actions
 while(5gat_timer.elapsed() <= 175000) {

  acquire_signal();


//save data in array matrix at each iteration
if(change==1){

  for(int i=0; i< 5; i++){
  data=
  
  avg[i]=avg[i]+mappedForce[i];
  
  nacquis++;
  
}

}

  
  if(5gat_timer.elapsed()>5000 and 5gat_timer.elapsed()<35000 and state==0){
    
  compute_reset();
    
  }

if(5gat_timer.elapsed()>40000 and 5gat_timer.elapsed()<70000){

    compute_reset();
    
  }


  if(5gat_timer.elapsed()>75000 and 5gat_timer.elapsed()<105000){

    compute_reset();

    
  }


  if(5gat_timer.elapsed()>110000 and 5gat_timer.elapsed()<140000){

    compute_reset();

    
  }


  if(5gat_timer.elapsed()>145000 and 5gat_timer.elapsed()<175000){

    compute_reset();

    
  }

    
  }
    
  }




  

void sect 3 (){





  
  
  }


void sect 4 (){
  
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

  Wire.begin();
  Wire.beginTransmission(MPU_addr);
  Wire.write(0x6B);  // PWR_MGMT_1 register
  Wire.write(0);     // set to zero (wakes up the MPU-6050)
  Wire.endTransmission(true);
  Serial.begin(9600);

}

void loop() {
  
   char val = Serial.read();

    // MODIFY FITNESS MODE WITH THE CODE TO GET THE FITNESS MODE AND COLORS************************************
    // fitness mode
    
    if(val == '1'){       // section 1
      
      sect1();
    }
    else if(val == '2'){       // section 2
      
      sect2();
      
    }
   else if(val == '3'){       // section 3
    
      sect3();
     // sendData(3,6,ecgRead,average_rr,bpm,r_rate);
      
   }

   else if(val == '4'){       // section 3
    
      sect4();
     // sendData(3,6,ecgRead,average_rr,bpm,r_rate);
      
   }

   
    if(val == '4'){       // exit
      
      exitMode();
      
   }

   
 }
 
