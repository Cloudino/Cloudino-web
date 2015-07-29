#include<Cloudino.h>

Cloudino cdino;

const long time =  1000;     // Time milliseconds
const int ledPin =  13;      // the number of the LED pin
int ledState = LOW;          // ledState used to set the LED

void blink()
{
    // if the LED is off turn it on and vice-versa:
    if (ledState == LOW)
      ledState = HIGH;
    else
      ledState = LOW;
    // set the LED with the ledState of the variable:
    digitalWrite(ledPin, ledState);  
}

void setup() {
  pinMode(ledPin, OUTPUT);  
  cdino.setInterval(time,blink);
  cdino.begin();
}

void loop() {
  cdino.loop();
}
