/*
  OnServerMessage

  Turn On Led from Server Message "led"

  This example code is in the public domain.

  Created 2 Feb 2016 by Javier Solis
*/

//import Cloudino and GPIO
require("Cloudino");
require("GPIO");

//initialize digital pin 1 as an output (Internal led)
pinMode(1, OUTPUT);

function onLed(msg) {
    //if received message is "ON"
    if (msg == "ON") {
        //turn the LED ON
        digitalWrite(1, LOW);
    } else {
        //turn the LED OFF
        digitalWrite(1, HIGH);
    }
}

//Register to receive messages with topic "led" 
Cloudino.on("led", onLed);