/*
  TimedHelloWorld

  Send Hello World text to the Cloudino Server Console every second

  This example code is in the public domain.

  Created 2 Feb 2016 by Javier Solis
*/

//import Cloudino Object
require("Cloudino");
require("Timer");

var x = 0;
//Create timer every second (1000ms)
setInterval(function() {
    //Send text to Server Console
    Cloudino.print('Hello World ' + x);
    x++;
}, 1000);