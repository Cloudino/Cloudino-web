/*
  HCSR04

  Read a HC-SR04 Sensor

  This example code is in the public domain.

  Created 2 Feb 2016 by Javier Solis
*/

//import Cloudino, Timer and HCSR04
require("Cloudino");
require("Timer");
require("HCSR04");

//Create timer every second (1000ms)
setInterval(function() {
    //Read HCSR04 on Trigger 5, Hecho 4 
    var dis = HCSR04.read(5, 4);
    //Post distance en centimeters
    Cloudino.post("distance", dis);
}, 1000);