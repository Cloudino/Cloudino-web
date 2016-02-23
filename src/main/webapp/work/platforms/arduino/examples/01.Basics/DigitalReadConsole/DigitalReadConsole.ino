/*
  DigitalReadConsole
 Reads a digital input on pin 2, prints the result to the serial monitor

 This example code is in the public domain.

 modify for Cloudino, 23 September 2015
 by Javier Solis, softjei@gmail.com
 */

#include<Cloudino.h>

Cloudino cdino;

// digital pin 2 has a pushbutton attached to it. Give it a name:
int pushButton = 2;

// the setup routine runs once when you press reset:
void setup() {
  // initialize serial communication at 9600 bits per second:
  cdino.begin();
  // make the pushbutton's pin an input:
  pinMode(pushButton, INPUT);
}

// the loop routine runs over and over again forever:
void loop() {
  // read the input pin:
  int buttonState = digitalRead(pushButton);
  // print out the state of the button:
  cdino.println(buttonState);
  delay(500);        // delay in between reads for stability
}



