#include <Cloudino.h>
#include <dht11.h>

#define DHT11PIN 8

Cloudino cdino;
dht11 DHT11;

void getSensor()
{
  int chk = DHT11.read(DHT11PIN);
  cdino.post("temperature",String((float)DHT11.temperature,2));
  cdino.post("humidity",String((float)DHT11.humidity,2));
}

void setup()
{
  cdino.setInterval(10000,getSensor);
  cdino.begin();
}

void loop()
{
  cdino.loop();
}
