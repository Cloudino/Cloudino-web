#include <Cloudino.h>

Cloudino cdino;


//|L|17|hola %d, JAVIER10
//|M5|helloS6|mundo!

void onmessage(String msg)
{
  cdino.post("hola",msg);
}

void post()
{
  cdino.post("hola","mundo");
} 

// the setup function runs once when you press reset or power the board
void setup() {
  cdino.on("hello",onmessage);
  //cdino.setInterval(1000,post);
  cdino.begin();
}

// the loop function runs over and over again forever
void loop() {
  cdino.loop();
}
