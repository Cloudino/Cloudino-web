#include <Cloudino.h>
#include <dht11.h>

#define DHT11PIN 8

Cloudino cdino;
dht11 DHT11;

void getSensor()
{
  int chk = DHT11.read(DHT11PIN);
  String cnt="{\"attributes\":[";
  cnt+="{\"name\":\"temperature\",\"type\":\"xsd:float\",\"value\":\""+String((float)DHT11.temperature,2)+"\"},";
  cnt+="{\"name\":\"humidity\",\"type\":\"xsd:float\",\"value\":\""+String((float)DHT11.humidity,2)+"\"}";
  cnt+="]}";
  cdino.post("$CONTENT",cnt);
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
