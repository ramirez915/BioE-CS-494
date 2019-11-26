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
#define CAP1188_SENSITIVITY 0x1F            // added

// Reset Pin is used for I2C or SPI
#define CAP1188_RESET  9

// CS pin is used for software or hardware SPI
#define CAP1188_CS  10

// These are defined for software SPI, for hardware SPI, check your 
// board's SPI pins in the Arduino documentation
#define CAP1188_MOSI  11
#define CAP1188_MISO  12
#define CAP1188_CLK  13

// For I2C, connect SDA to your Arduino's SDA pin, SCL to SCL pin
// On UNO/Duemilanove/etc, SDA == Analog 4, SCL == Analog 5
// On Leonardo/Micro, SDA == Digital 2, SCL == Digital 3
// On Mega/ADK/Due, SDA == Digital 20, SCL == Digital 21

// Use I2C, no reset pin!
Adafruit_CAP1188 cap = Adafruit_CAP1188();

// Or...Use I2C, with reset pin
//Adafruit_CAP1188 cap = Adafruit_CAP1188(CAP1188_RESET);

// Or... Hardware SPI, CS pin & reset pin 
// Adafruit_CAP1188 cap = Adafruit_CAP1188(CAP1188_CS, CAP1188_RESET);

// Or.. Software SPI: clock, miso, mosi, cs, reset
//Adafruit_CAP1188 cap = Adafruit_CAP1188(CAP1188_CLK, CAP1188_MISO, CAP1188_MOSI, CAP1188_CS, CAP1188_RESET);

int counter = 0;

void setup() {
  Serial.begin(115200);
  Serial.println("CAP1188 test!");

  //cap.writeRegister(CAP1188_SENSITIVITY, 0x4F);  // 8x  sensitivity
  //cap.writeRegister(CAP1188_SENSITIVITY, 0x5F);  // 4x  sensitivity
  //cap.writeRegister(CAP1188_SENSITIVITY, 0x6F);  // 2x  sensitivity THIS SEEMS TO WORK THE BEST FOR 3.5" plate sensors
  //cap.writeRegister(CAP1188_SENSITIVITY, 0x7F);  // 1x  sensitivity

  //added
  

  // Initialize the sensor, if using i2c you can pass in the i2c address
  // if (!cap.begin(0x28)) {
  if (!cap.begin()) {
    Serial.println("CAP1188 not found");
    while (1);
  }
  Serial.println("CAP1188 found!");
  cap.writeRegister(CAP1188_SENSITIVITY, 0x6F);  // 5 seemed to work with current wires     // last tested with 6
}

void loop() {
  uint8_t touched = cap.touched();

  if (touched == 0) {
    // No touch detected
    counter = 0;              //added for the 2 tap detection
    return;
  }

  //----------------------------------------------------------------- original working code
//  for (uint8_t i=0; i<8; i++) {
//    if (touched & (1 << i)) {
//      Serial.print("C"); Serial.print(i+1); Serial.print("-");
//    }
//  }
//------------------------------------------------------------------------------

  for (uint8_t i=0; i<8; i++) {
    if (touched & (1 << i)){
      counter++;
      if(counter == 2){
        Serial.print("C"); Serial.print(i+1); Serial.print("-");
        counter = 0;
      }
    }
  }

  Serial.println("x");
//  delay(50);    // original
//  delay(600);     // 600 seemed good
  delay(500);  //100 seems good with counter
}


/*
 *  MIGHT NEED TO ADD A COUNTER TO THIS CODE TO ONLY SEND 1 VALUE AT A TIME
 *  ON THE PROCESSING SIDE BECAUSE THE ONLY ISSUE SEEMS TO BE FOR THE FIRST TAP...?
 */ 
