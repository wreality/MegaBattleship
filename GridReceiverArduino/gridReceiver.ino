#include "SPI.h"
#include <Adafruit_WS2801.h>

#define CLOCK 2
#define DATA 3

Adafruit_WS2801 strip = Adafruit_WS2801((uint16_t)10, (uint16_t)10, CLOCK, DATA);
String inputString = "";
boolean stringComplete = false;

void  setup() {
  Serial.begin(115200);
  strip.begin();
  strip.show();
  Serial.println("OK");
  
}
void loop() {
  // print the string when a newline arrives:
  if (stringComplete) {
    Serial.println(inputString);
    if (inputString.equals("CLEAR\n")) {
      for (int y=0; y<10; y++) {
        for (int x=0; x<10; x++) {
          strip.setPixelColor(x, y, 0, 0, 0);
         // Serial.println(x+", "+y);
         // strip.show();
        }
      }
      strip.show();
    } else {
      int xpos = inputString.substring(0,1).toInt();
      int ypos = inputString.substring(2,3).toInt();
      int redVal = inputString.substring(4,7).toInt();
      int greenVal = inputString.substring(8,11).toInt();
      int blueVal = inputString.substring(12).toInt();

      strip.setPixelColor(xpos, ypos, redVal, greenVal, blueVal);
      strip.show();    
      // clear the string:
    }
    inputString = "";
    stringComplete = false;
  }
}

/*
  SerialEvent occurs whenever a new data comes in the
 hardware serial RX.  This routine is run between each
 time loop() runs, so using delay inside loop can delay
 response.  Multiple bytes of data may be available.
 */
void serialEvent() {
  while (Serial.available()) {
    // get the new byte:
    char inChar = (char)Serial.read(); 
    // add it to the inputString:
    inputString += inChar;
    // if the incoming character is a newline, set a flag
    // so the main loop can do something about it:
    if (inChar == '\n') {
      stringComplete = true;
    } 
  }
}
