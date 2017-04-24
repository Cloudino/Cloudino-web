/*
  DHT11

  Read a DHT11 Sensor

  This example code is in the public domain.

  Created 2 Feb 2016 by Javier Solis
*/

//import Cloudino, Timer and DHT11
require("Cloudino");
require("Timer");
require("DHT11");

//Create timer every second (1000ms)
setInterval(function() {
    //Read DHT11 on GPIO 14
    var sens = DHT11.read(14);
    //Post temperature an humidity data to defined Server
    Cloudino.post("temperature", sens.temperature);
    Cloudino.post("humidity", sens.humidity);
}, 1000);