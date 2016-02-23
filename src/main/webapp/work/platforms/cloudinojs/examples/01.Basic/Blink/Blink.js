/*
  Blink
  Turns on an LED on for one second, then off for one second, repeatedly.

  Most Cloudino have an on-board LED you can control, 
  it is attached to digital pin 1. 

  This example code is in the public domain.

  modified 2 Feb 2016
  by Javier Solis
 */
require("GPIO");
require("Timer");

var led=false;
pinMode(1, OUTPUT);

setInterval(function(){
  if(led)digitalWrite(1, HIGH);
  else digitalWrite(1, LOW);
  led=!led;
},1000);