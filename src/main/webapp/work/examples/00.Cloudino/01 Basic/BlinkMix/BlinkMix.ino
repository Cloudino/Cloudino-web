#include<Cloudino.h>

Cloudino cdino;

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

void setBlink1()
{
  cdino.setTimer(200,blink,4,setBlink2);
}

void setBlink2()
{
  cdino.setTimer(50,blink,4,setBlink1);
}

void setup() {
  pinMode(ledPin, OUTPUT);  
  setBlink1();
  cdino.begin();
}

void loop() {
  cdino.loop();
}
