#include <StopWatch.h>

StopWatch step_timer;
void setup() {
  // put your setup code here, to run once:

}

void loop() {
  // put your main code here, to run repeatedly:

}

// Section I: The Step and Stride computations


// 1) Step length
// 2) Stride length
// 3) Cadence (Number of steps per minute)
// 4) Speed (Distance covered in a given amount of time)
// 5) Step Count

int step_stride (boolean mf_sensor, boolean lf_sensor, boolean mm_sensor, boolean heel_sensor){

  int distance = 100; //distance in meters
  int step_count = 0;
  int cadence;

  while (step_timer.elapsed() <= 120000){

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
    
}
