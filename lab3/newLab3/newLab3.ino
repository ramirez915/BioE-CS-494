#include <StopWatch.h>
#include <Wire.h>
const int MPU = 0x68; // MPU6050 I2C address
float AccX, AccY, AccZ;
float AccErrorX, AccErrorY;
int c = 0;

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
//------------------------------------ end of reset_values()


// will only send section, FSR values, and the direction        done*******
void sendData(){
  //mf
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
  //section 3
  Serial.println(dir);
}
//----------------------------------- end of sendData()

void calculate_IMU_error() {                              done******
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
}
//--------------------------------------- end of calculate_IMU_error()

void read_IMU() {             done******
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
}
//------------------------------------------ end of read_IMU()

void acquire_signal(){
  force[0]=analogRead(A0);
  force[1]=analogRead(A1);
  force[2]=analogRead(A2);
  force[3]=analogRead(A3);

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

//  Serial.println("white-1");
//  Serial.println(mappedForce[0]);
//  Serial.println("green");
//  Serial.println(mappedForce[1]);
//  Serial.println("white-2");
//  Serial.println(mappedForce[2]);
//  Serial.println("red");
//  Serial.println(mappedForce[3]);

  // light LEDs
  analogWrite(9,mappedForce[0]);
  analogWrite(6,mappedForce[1]);
  analogWrite(5,mappedForce[2]);
  analogWrite(3,mappedForce[3]);

  //read IMU data:
  if(sect==3){
    read_IMU();
    smoothing(AccX,AccY,AccZ);
  }
  delay(20);
}
//------------------------------------------------ end of aqcuire_signal()


float smoothing(float accx, float accy, float accz){      //done************
  
  static int readIndex = 0;
  static int readingsx[numReadings];
  static float totalx= 0;
  static int readingsy[numReadings];
  static float totaly= 0;
  static int readingsz[numReadings];
  static float totalz= 0;

  // subtract the last reading:
  totalx = totalx - readingsx[readIndex];
  totaly = totaly - readingsy[readIndex];
  totalz = totalz - readingsz[readIndex];

  readingsx[readIndex] = accx *gain ;
  readingsy[readIndex] = accy *gain ;
  readingsz[readIndex] = accz *gain ;

  totalx  = totalx  + readingsx [readIndex];
  totaly  = totaly  + readingsy [readIndex];
  totalz  = totalz  + readingsz [readIndex];
  // advance to the next position in the array:
  readIndex  = readIndex  + 1;

  // if we're at the end of the array...
  if (readIndex  >= numReadings ){
    // ...wrap around to the beginning:
    readIndex  = 0;
  }

  // calculate the average:
  averagex  = totalx  / numReadings;
  averagey  = totaly  / numReadings;
  averagez  = totalz  / numReadings;

//  Serial.println(averagex);
//  Serial.print(",");
//  Serial.println(averagey);
//  Serial.print(",");
//  Serial.println(averagez);
}
//------------------------------------------------------------------- end of smoothing()

float calcMep(float pmm,float pmf,float plf,float pheel){     // done*****

  float totalMep; // cumulative value
  float MEP; //MEP value taken each step
  float topVal = (pmm + pmf) * 100;
  float bottomVal = (pmf + plf + pmm + pheel + 0.001);

  MEP = topVal / bottomVal; //MEP calculation per step
  
  return MEP;
}


void compute_reset() {    
  float pmm;
  float pmf;
  float plf;
  float pheel;

  for(int i=0; i< 5; i++){
    avg[i]=avg[i]/nacquis;
  }
    
  pmm=avg[1];
  pmf=avg[2];
  plf=avg[3];
  pheel=avg[4];  

//RECOGNIZE THE MODALITIES BASE ON THE AVG VALUES:

    if(pheel>pmm && pheel>pmf && pheel>plf){
      rec[state]=1;//pattern heel
     // Serial.println("heel");
    }

    if(pheel+pmm<plf+pmf){
      rec[state]=2;//pattern tiptoeing
     // Serial.println("tiptoeing");
    }

//or pmf
    if(plf>pmm && plf>pmf && plf>pheel){
      rec[state]=3;//pattern intoeing
     // Serial.println("intoeing");
    }

//or pmf
    if(pmm+pmf>plf+pheel){
      rec[state]=4;//pattern outtoeing
     // Serial.println("outtoeing");
    }

    else {
      rec[state]=5;//normal gait
      //Serial.println("normal");
      
      }
    
    MFN[state]=calcMep(pmm,pmf,plf,pheel);
    reset_values();
    nacquis=0;
    state++;

    //PLOT ON PROCESSING WHAT PHASE IS RECOGNIZED
    sendData();
}



void sect1 (){
  step_timer.start();
  int sec_60=0;
  while(step_timer.elapsed() <= 70000) {
    // Serial.println(step_timer.elapsed());
    acquire_signal();
    sendData();
    if (mf_s == 1 || lf_s == 1 || mm_s == 1 || heel_s == 1){
      if (step_count == 0){
        step_count += 1; //to keep track of the total no. of Step Counts 
      }
      else{
        step_count += 2;
      }
    }
    if (step_timer.elapsed() > 60000 && sec_60==0){
      cadence = step_count;  //to output the Cadence: Number of steps in a minute
      sec_60=1;
    }
  }
//wait for the distance to be inputed in processing
  String distance="";
  while(Serial.read()!='x') {
    distance= distance + String(Serial.read());
  }
  
  step_length = float(distance.toInt()) / step_count; //computing Step Length
  stride_length = step_length * 2; //computing Stride Length
  walking_speed = cadence * step_length; //Computing speed: distance covered in a given time (1 min)
  step_timer.stop();
}
//------------------------------------------------ end of sect1()



void sect2 (){

 gait_timer.start();
 
 int instant=0;

// GENERATE RANDOM ACQUISITION OF PATTERNS:

//for(int i=0; i< 5; i++){
//
//
//  rndstate[i]=functionrandom();
//}

//consider 90000 for recording plus 5*5 between the actions
// while(gait_timer.elapsed() <= 155000 || !Serial.read()=='5')

 //timer for 2 min and 30 sec
 
while (gait_timer.elapsed() <= 150000) {

 // Serial.println("in while of sect 2");
  
  acquire_signal();
  //send data to display the heat map
  sendData();
//save data in array matrix at each iteration

//Serial.println(change);

if(change==1){
  
//Serial.println("in if");
  for(int i=0; i< 4; i++){
    
    //save data in a matrix
    
    //Serial.println(force[i]);
    
  data[i][instant]=force[i];
  instant++;
  avg[i]=avg[i]+force[i];
  
  nacquis++;
  
}

}

  
  if(gait_timer.elapsed()>30000 and state==0){
    
  compute_reset();
    
  }

if(gait_timer.elapsed()>60000){

    compute_reset();
    
  }


  if(gait_timer.elapsed()>90000){

    compute_reset();

    
  }


  if(gait_timer.elapsed()>120000){

    compute_reset();
  
  }
if(gait_timer.elapsed()>150000){

    compute_reset();
    state=0;
  }

    
  }
    
  }




  

void sect3 (){
//THE DATA SHOULD BE ALREADY BIAS CORRECTED BY THE FUNCTION FOR THE IMU ERROR
dir=0;

//detect movement:
while(Serial.read()!='5') {
//while (1){
  acquire_signal();
  
if(abs(averagey)>thrmovem or abs(averagez)>thrmovem) {

if(averagez>0){
  czr++;
  if(czr>thrcount) {
    
  //move right
 // Serial.println("right");
  dir=0.5;
  czr=0;
  czl=0;
  cyb=0;
  cyf=0;
  
  }
 // Serial.println(1/2);
}

if(averagez<0){

  czl++;
  if(czl>thrcount) {
  //move left
 // Serial.println("left");
  dir=-0.5;
  czr=0;
  czl=0;
  cyb=0;
  cyf=0;
 // Serial.println(-1/2);
}
}



if(averagey<0){

  cyf++;
  //move forward
  if(cyf>thrcount) {
 // Serial.println("forward");
  dir=1;
  czr=0;
  czl=0;
  cyb=0;
  cyf=0;
 // Serial.println(1);
}
}

if(averagey>0){
  cyb++;
  if(cyb>thrcount) {
  //move backward
 // Serial.println("backward");
  dir=-1;
  czr=0;
  czl=0;
  cyb=0;
  cyf=0;
 // Serial.println(-1);
}

}

else{
  //Serial.println("stop");
  dir=0;
  }

sendData();

}

}

}


void sect4 (){
 
int speed_age;
//insert age of subject
String inputedAge = "";
while(Serial.read() !='x') {
  //wait for processing to send inserted age
  inputedAge = inputedAge + String(Serial.read());
}

int age = inputedAge.toInt();
//set speed_age
 
if(age>=20 && age<=29){
 
speed_age= 0.18; //in meters per minute
}
 
if(age>=30 && age<=39){
speed_age= 0.11;
}
 
if(age>=40 && age <=49){
speed_age= 0.19;
}
 
if(age>=50 && age<=59){
speed_age= 0.27;
}
 
 
//execute sect 1 to acquire the speed:
sect1();
if(walking_speed < speed_age) {
 
  health=0;
//  diff_speed=speed_age-walking_speed;
//  virt_age=(1+diff_speed/speed_age)*age;
}
else{
  health=1;
 }
  }


void exitmode (){
  reset_values();
}

//void set_readings () {
//    for (int thisReading = 0; thisReading < numReadings; thisReading++) {
//      readings[thisReading] = 0;
//    }
//}


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

  //IMU:
  //SERIAL ALREADY SET
  Wire.begin();                      // Initialize comunication
  Wire.beginTransmission(MPU);       // Start communication with MPU6050 // MPU=0x68
  Wire.write(0x6B);                  // Talk to the register 6B
  Wire.write(0x00);                  // Make reset - place a 0 into the 6B register
  Wire.endTransmission(true);        //end the transmission

  //setting array to 0
  reset_values();

}

void loop() {
  // waiting for section from Processing
  char val = Serial.read();
  
  if(val == '1'){       // section 1
    sect=1;
    sect1();
  }
  else if(val == '2'){       // section 2
    sect=2;
    sect2();
  }
  else if(val == '3'){       // section 3
    sect=3;
    sect3();  
  }
  else if(val == '4'){       // section 3
    sect=4;
    sect4();  
  }
  if(val == '5'){       // exit   
    exitmode();
  }
}

































//-------------------------------- simpler lab3 that only gets FSR
float force[4];
float mappedForce[4];

//--------------acquire_signal
int mf=A0;
int lf=A1;
int mm=A2;
int heel=A3;

int mf_led=9;
int lf_led=6;
int mm_led=5;
int heel_led=3;
//-----------------------
bool heel_s=0;
bool mm_s=0;
bool mf_s=0;
bool lf_s=0;

//int thr_step=100;
int thr_step=500;

void reset_values(){
  for (int i=0; i< 4; i++){
      force[i]=0;
  }
}

void sendData(){
  //mf
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
}

void acquire_signal () {
  
  force[0]=analogRead(mf);
  force[1]=analogRead(lf);
  force[2]=analogRead(mm);
  force[3]=analogRead(heel);

  //Serial.println(force[0]);
//  Serial.println(force[1]);
//  Serial.println(force[2]);
//  Serial.println(force[3]);

  //mapping force_inputs with leds_outputs
  for(int i=0; i< 4; i++){
    mappedForce[i] = map(force[i],0,1023,0,255);
  }
  
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
  //LEDS:
  pinMode(mf_led, OUTPUT); 
  pinMode(lf_led, OUTPUT);
  pinMode(mm_led, OUTPUT); 
  pinMode(heel_led, OUTPUT);

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
