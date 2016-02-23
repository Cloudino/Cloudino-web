#include <Cloudino.h>

Cloudino cdino;

const int analogPin = A0;  // Analog input pin that the potentiometer is attached to

void getSensor()
{
  cdino.post("sensor",String(analogRead(analogPin)));
}

void setup() {
  cdino.setInterval(10000,getSensor);
  cdino.begin();
}

void loop() {
  cdino.loop();
}
