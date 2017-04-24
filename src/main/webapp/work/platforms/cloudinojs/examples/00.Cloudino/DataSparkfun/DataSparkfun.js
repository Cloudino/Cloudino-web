/*
  DataSparkfun

  Stream data to data.sparkfun.com

  public url: https://data.sparkfun.com/streams/VGxL9RrYW8SmpLdOXyOR

  This example code is in the public domain.

  Created 2 Feb 2016 by Javier Solis
*/

//import Cloudino, Timer, HTTP and DHT11
require("Cloudino");
require("Timer");
require("DHT11");
require("HTTP");

//Create timer every second (1000ms)
setInterval(function() {
    //Read DHT11 on GPIO 14
    var sens = DHT11.read(14);
    //Post temperature an humidity data to data.sparkfun.com
    var ret = HTTP.get("https://data.sparkfun.com/input/VGxL9RrYW8SmpLdOXyOR?private_key=9YdKp5nDqVUkXx2pr7pg&humidity=2" + sens.humidity + "&temp=" + sens.temperature);
    if (ret !== undefined) {
        Cloudino.print(ret);
    } else {
        Cloudino.print("Error getting data");
    }
}, 1000);