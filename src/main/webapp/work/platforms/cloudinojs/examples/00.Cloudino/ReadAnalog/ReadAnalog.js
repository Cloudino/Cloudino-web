/*
  ReadAnalog

  Read Analog Data and Post the data to defined IoT Server

  This example code is in the public domain.

  Created 2 Feb 2016 by Javier Solis
*/

//import Cloudino, Timer and GPIO
require("Cloudino");
require("Timer");
require("GPIO");

function read() {
    //read analog data
    //return 10 bits value (0 - 1024) 
    //analog signal from (0 - 1 volts)
    var s = analogRead();
    //Post Analog data to defined Server
    Cloudino.post("analog", s);
}

//Create timer every second (1000ms)
setInterval(read, 1000);