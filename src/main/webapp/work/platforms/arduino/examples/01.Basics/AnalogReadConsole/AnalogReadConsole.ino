/*
  AnalogReadConsole
  Reads an analog input on pin 0, prints the result to the Cloudino Console.
  Attach the center pin of a potentiometer to pin A0, and the outside pins to +5V and ground.

 This example code is in the public domain.

 modify for Cloudino, 23 September 2015
 by Javier Solis, javier.solis@infotec.mx, softjei@gmail.com
 */

#include<Cloudino.h>

Cloudino cdino;

// the setup routine runs once when you press reset:
void setup() {
  // initialize cloudino:
  cdino.begin();
}

// the loop routine runs over and over again forever:
void loop() {
  // read the input on analog pin 0:
  int sensorValue = analogRead(A0);
  // print out the value you read:
  cdino.println(sensorValue);
  delay(500);        // delay in between reads for stability
}
