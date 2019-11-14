/*************************************************** 
  This is a library for the CAP1188 I2C/SPI 8-chan Capacitive Sensor

  Designed specifically to work with the CAP1188 sensor from Adafruit
  ----> https://www.adafruit.com/products/1602

  These sensors use I2C/SPI to communicate, 2+ pins are required to  
  interface
  Adafruit invests time and resources providing this open source code, 
  please support Adafruit and open-source hardware by purchasing 
  products from Adafruit!

  Written by Limor Fried/Ladyada for Adafruit Industries.  
  BSD license, all text above must be included in any redistribution
 ****************************************************/
 
#include <Wire.h>
#include <SPI.h>
#include <Adafruit_CAP1188.h>
#define CAP1188_SENSITIVITY 0x1F

// Reset Pin is used for I2C or SPI
#define CAP1188_RESET  9

// CS pin is used for software or hardware SPI
#define CAP1188_CS  10

// These are defined for software SPI, for hardware SPI, check your 
// board's SPI pins in the Arduino documentation
#define CAP1188_MOSI  11
#define CAP1188_MISO  12
#define CAP1188_CLK  13

// Use I2C, no reset pin!
Adafruit_CAP1188 cap = Adafruit_CAP1188();

void setup() {
  Serial.begin(115200);
  Serial.println("CAP1188 test!");

  
  //cap.writeRegister(CAP1188_SENSITIVITY, 0x4F);  // 8x  sensitivity
  //cap.writeRegister(CAP1188_SENSITIVITY, 0x5F);  // 4x  sensitivity
  //cap.writeRegister(CAP1188_SENSITIVITY, 0x6F);  // 2x  sensitivity THIS SEEMS TO WORK THE BEST FOR 3.5" plate sensors
  //cap.writeRegister(CAP1188_SENSITIVITY, 0x7F);  // 1x  sensitivity

  // Initialize the sensor, if using i2c you can pass in the i2c address
  if (!cap.begin(0x29)) {
  //if (!cap.begin()) {
    Serial.println("CAP1188 not found");
    while (1);
  }
  //Serial.println("CAP1188 found!");
  cap.writeRegister(CAP1188_SENSITIVITY, 0x3F);  // 16x sensitivity
}

void loop() {
  uint8_t touched = cap.touched();
  int data[]  = {0, 0, 0, 0, 0, 0, 0, 0};
  
  for (uint8_t i=0; i<8; i++) {
    if (touched & (1 << i)) { // 00000000  (bits for c1 - c8 (c1 is rightmost bit)
      //Serial.print("C"); Serial.print(i+1); Serial.print("\t");
      data[i] = 1; // touched 
    }
  }
  String dataToSend = concatIntToString(data, 8, ",");
  Serial.println(dataToSend);
  delay(50);
}

String concatIntToString(int data[], int dataLength, String delimiter){
  String out = "";
  for(int i = 0; i < dataLength; i++){
    out += data[i];
    if((i + 1) < dataLength){
      out += delimiter;
    }
  }
  return out;
}
