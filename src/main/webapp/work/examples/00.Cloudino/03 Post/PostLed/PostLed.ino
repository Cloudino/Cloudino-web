#include "Cloudino.h"

Cloudino cdino;

void led(String msg)
{
  if(msg=="on")digitalWrite(13, HIGH);
  else digitalWrite(13, LOW);
  cdino.post("led",msg);
}

void setup()
{
  pinMode(13, OUTPUT);
  cdino.on("led",led);
  cdino.begin();
}

void loop()
{
  cdino.loop();
}
