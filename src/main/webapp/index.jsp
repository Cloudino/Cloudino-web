<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="Connect Arduino to the Cloud">
<meta name="keywords" content="arduino, cloud, cloudino, connect, wifi ">
<meta name="author" content="INFOTEC - Centro Publico de Investigacion y Desarrollo Tecnologico">
<link rel="shortcut icon" href="img/cloudino.png">
<title>Cloudino: The easiest way to connect your Arduino to the Cloud</title>

<!-- Bootstrap Core CSS -->
<link href="css/bootstrap.min.css" rel="stylesheet">

<!-- Custom CSS -->
<link href="css/cloudino.css" rel="stylesheet">
<link href="css/cloudino-custom.css" rel="stylesheet">
<!-- Custom Fonts -->
<link href="/static/plugins/font-awesome-4.5.0/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<link href='css/fontgoogleapis.css' rel='stylesheet' type='text/css'>

<!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
<!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

</head>

<body id="page-top" class="index">

<!-- Navigation -->
<nav class="navbar navbar-default navbar-fixed-top">
  <div class="container"> 
    <!-- Brand and toggle get grouped for better mobile display -->
    <div class="navbar-header page-scroll">
      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"> <span class="sr-only">Toggle navigation</span> <span class="icon-bar"></span> <span class="icon-bar"></span> <span class="icon-bar"></span> </button>
      <a class="navbar-brand page-scroll" href="#page-top" title="Cloudino"><img src="img/cloudino.svg" class="img-responsive">
      <h1>Cloudino: The easiest way to connect your Arduino to the Cloud</h1>
      </a> </div>
    
    <!-- Collect the nav links, forms, and other content for toggling -->
    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
      <ul class="nav navbar-nav navbar-right">
        <li class="hidden"> <a href="#page-top"></a> </li>
        <li> <a class="page-scroll" href="#innovation">Innovation</a> </li>
        <li> <a class="page-scroll" href="#components">Components</a> </li>
        <li> <a class="page-scroll" href="#boards">Boards</a> </li>
        <li> <a class="page-scroll" href="#learn">Learn</a> </li>
        <li> <a class="page-scroll" href="#sponsors">Sponsors</a> </li>
        <li> <a class="page-scroll" href="panel/"><span aria-hidden="true" class="glyphicon glyphicon-log-in"></span> Log In</a> 
          <!--<a href="panel/"><i class="glyphicon glyphicon-cog" style="font-size: 30px;position: absolute;padding-top: 10px;"></i></a>--> 
        </li>
      </ul>
    </div>
    <!-- /.navbar-collapse --> 
  </div>
  <!-- /.container-fluid --> 
</nav>

<!-- Header -->
<header> <img src="img/nube-1.svg" class="nube1 hidden-xs"> <img src="img/nube-2.svg" class="nube2 hidden-xs"> <img src="img/nube-3.svg" class="nube3">
  <div class="container seccion-header">
    <div class="row clearfix ">
      <div class="col-xs-12 col-sm-12 col-md-4 col-lg-4 headdiv1">
        <h2><strong>Cloudino</strong> an Internet of Things Platform</h2>
      </div>
      <div class="col-xs-12 col-sm-12 col-md-4 col-lg-4 headdiv2"> <img src="img/header-cloudino.png" class="img-responsive"> </div>
      <div class="col-xs-12 col-sm-12 col-md-4 col-lg-4 headdiv3">
        <h2>The easiest way to connect your <strong>Arduino to the Cloud</strong></h2>
      </div>
    </div>
    <a href="#innovation" class="page-scroll btn btn-xl">Tell Me More</a> </div>
</header>
<div class="x"></div>
<!-- INNOVATION -->
<section id="innovation">
  <div class="container seccion-innovation">
    <div class="row clearfix ">
      <div class="col-xs-10 col-sm-6 col-md-6 col-lg-5">
        <h2 class="visible-xs">Our Innovation:<br/>
          The WiFi Cloud Connector</h2>
        <img src="img/innova-lego.png" class="img-responsive"> </div>
      <div class="col-xs-12 col-sm-6 col-md-6 col-lg-7 seccion-innovation-info">
        <h2 class="hidden-xs">Our Innovation:<br/>
          The WiFi Cloud Connector</h2>
        <p>Connect to the cloud, easy and transparent, differents MCU platforms like Atmel AVR, Microchip PIC, etc.</p>
        <p>The <strong>WiFi Cloud Connector</strong> is not an Arduino shield, is other processor working in parallel dedicated only to the network layer including the IoT protocols, leaving the Arduino dedicated to the connectivity with the sensors and actuators, while allows reprogramming Arduino via WiFi or Cloud.</p>
        <a id="modal-diagrama" href="#modal-container-diagrama" role="button" class="btn page-scroll btn-xl" data-toggle="modal" >How it works?</a> </div>
    </div>
  </div>
</section>

     <!-- COMPONENTS -->
<section id="components">
            <div class="container seccion-components">
                <h2>Components</h2>
                <div class="row clearfix ">
                    <div class="col-xs-12 col-sm-4 col-md-4 col-lg-4">
                        <img class="img-responsive" src="img/compnents-arduino.png">
                        <div id="panel-03" class="panel-group">
                            <div class="panel panel-default">
                                <div class="panel-heading">
                                    <a href="#panel-element-03" data-parent="#panel-03" data-toggle="collapse" class="panel-title collapsed btnUpDown">Arduino API <span class="glyphicon glyphicon-chevron-down" aria-hidden="true"></span><span aria-hidden="true" class="glyphicon glyphicon-chevron-up"></span></a>
                                </div>
                                <div class="panel-collapse collapse" id="panel-element-03" aria-expanded="true" style="">
                                    <div class="panel-body">
                                        <ul>
                                            <li>Simple Message Router</li>
                                            <li>Simple Timer API</li>
                                            <li>Console Messaging</li>
                                        </ul>
                                        <div class="components-download">
                                        <p>Download</p>
                                        <ul>
                                            <li><a href="https://github.com/Cloudino/Cloudino-ArduinoLib">Arduino API</a></li>
                                            <li><a href="https://github.com/Cloudino/Arduino">Arduino IDE (Cloudino Integration)</a></li>
                                        </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                    
                    <div class="col-xs-12 col-sm-4 col-md-4 col-lg-4">
                        <img class="img-responsive" src="img/compnents-wifi.png">
                        <div id="panel-01" class="panel-group">
                            <div class="panel panel-default">
                                <div class="panel-heading">
                                    <a href="#panel-element-01" data-parent="#panel-01" data-toggle="collapse" class="panel-title collapsed btnUpDown">Wifi Cloud Connector <span class="glyphicon glyphicon-chevron-down" aria-hidden="true"></span><span aria-hidden="true" class="glyphicon glyphicon-chevron-up"></span></a>
                                </div>
                                <div class="panel-collapse collapse" id="panel-element-01">
                                    <div class="panel-body">
                                        <ul>
                                            <li>Simple Wifi Configuration (Access Point)</li>
                                            <li>Based on low cost ESP8266</li>
                                            <li>Cloudino Firmware</li>
                                            <li>Arduino IDE Integration</li>
                                            <li>Wifi Arduino Programming</li>
                                            <li>Built in IoT Protocols
                                                <ul>
                                                    <li>Cloudino Protocol</li>
                                                    <li>Orion Context Broker (FIWARE)</li>
                                                    <li>MQTT</li>
                                                    <li>COAP</li>
                                                    <li>Blynk</li>
                                                </ul>
                                            </li>
                                            <li>mDNS Support</li>
                                            <li>Simple Messaging Rest Services</li>
                                        </ul>
                                        <div class="components-download">
                                        <p>Download</p>
                                        <ul>
                                            	<li><a href="https://github.com/Cloudino/Cloudino-Firmware">Cloudino Firmware</a></li>
                                        </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                    <div class="col-xs-12 col-sm-4 col-md-4 col-lg-4">
                        <img class="img-responsive" src="img/compnents-cloud.png">
                        <div id="panel-02" class="panel-group">
                            <div class="panel panel-default">
                                <div class="panel-heading">
                                    <a href="#panel-element-02" data-parent="#panel-02" data-toggle="collapse" class="panel-title collapsed btnUpDown">Cloud Service <span class="glyphicon glyphicon-chevron-down" aria-hidden="true"></span><span aria-hidden="true" class="glyphicon glyphicon-chevron-up"></span></a>
                                </div>
                                <div class="panel-collapse collapse" id="panel-element-02">
                                    <div class="panel-body">
                                        <ul>
                                            <li>Web IDE (based on Arduino IDE)</li>
                                            <li>Cloud Arduino Programming</li>
                                            <li>Cloud Storage</li>
                                            <li>Rule Manager</li>
                                            <li>Message Manager</li>
                                            <li>Device Console</li>
                                            <li>Push Notification</li>
                                        </ul>
                                        <div class="components-download">
                                        	<p>Download</p>
                                        	<ul>
                                            	<li><a href="https://github.com/Cloudino/Cloudino-web">Cloudino Server</a></li>
                                        	</ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>

                </div>

            </div>
        </section>

<!-- SUPPORTED & STARTED -->

<section id="boards" class="boardstart seccion-boards">
  <h2>Supported Devices</h2>
  <ul>
    <li>Arduino Uno</li>
    <li>Arduino Duemilanove or Diecimila</li>
    <li>Arduino Nano</li>
    <li>ATmega1280</li>
    <li>Arduino Mini</li>
    <li>Arduino Fio</li>
    <li>Arduino BT</li>
    <li>LilyPad Arduino</li>
    <li>Arduino Pro or Pro Mini</li>
    <li>Arduino NG or older</li>
  </ul>
</section>
<section id="learn" class="boardstart seccion-learn">
  <h2>Getting Started</h2>
  <ul>
    <li>Arduino Connection Squema</li>
    <li>Cloudino Configuration
      <ul>
        <li>Wifi Configuration</li>
        <li>Cloud Configuration</li>
      </ul>
    </li>
    <li>Programming Arduino using WIFI</li>
    <li>Programming Arduino using Cloud</li>
    <li><a href="/doc/Connecting_Cloudino_Connector_to_FIWARE_IoT.pdf">Connecting to FIWARE IoT</a></li>
  </ul>
</section>


<!-- Sponsors -->
<section id="sponsors">
	<div class="container">
    <!--<h2>Sponsors</h2>-->
	<div class="row clearfix">
    	<div class="col-xs-12 col-sm-4 col-md-4 col-lg-4">
        	<img src="img/sponsor-infotec.png" class="img-responsive">
        </div>
        <div class="col-xs-12 col-sm-4 col-md-4 col-lg-4">
        	<img src="img/sponsor-conacyt.png" class="img-responsive">
        </div>
        <div class="col-xs-12 col-sm-4 col-md-4 col-lg-4">
        	<img src="img/sponsor-fiware.png" class="img-responsive">
        </div>
    </div>
    </div>
</section>

<!-- FOOTER -->
    <footer>
        <div class="container">
            <div class="row clearfix">
                <div class="col-md-12">
                    <p class="foot1"><strong>Cloudino</strong> is developed and maintained by <strong>INFOTEC</strong> (Public Research Center of CONACYT) as an Open Source and Open Hardware Platform.</p>
                    <p class="foot2">Av. San Fernando 37, Toriello Guerra, Mexico City <span>|</span> <a href="mailto:soportewb@infotec.com.mx">soportewb@infotec.com.mx</a></p>
                    <p class="foot3">Copyright &copy; Cloudino 2015-2020. All rights reserved.</p>
                </div>
            </div>
        </div>
    </footer>


<!-- DIAGRAMA-->
<div class="modal fade" id="modal-container-diagrama" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true"><span aria-hidden="true" class="glyphicon glyphicon-remove"></span></button>
        <h4 class="modal-title" id="myModalLabel"> Cloudino Architecture </h4>
      </div>
      <div class="modal-body"> <img src="img/arquitecture.png" class="img-responsive"> </div>
    </div>
  </div>
</div>
<script src="js/jquery.js"></script> 
<script src="js/bootstrap.min.js"></script> 
<script src="js/jquery.easing.min.js"></script> 
<script src="js/classie.js"></script> 
<script src="js/cbpAnimatedHeader.js"></script> 
<script src="js/jqBootstrapValidation.js"></script> 
<script src="js/contact_me.js"></script> 
<script src="js/agency.js"></script>
<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
  ga('create', 'UA-71259031-1', 'auto');
  ga('send', 'pageview');
</script>

<!-- Meetup Link
<a href="http://www.meetup.com/Cloudino-io/events/228352613/" data-event="228352613" class="mu-rsvp-btn">RSVP</a>
<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s); js.id=id;js.async=true;js.src="https://a248.e.akamai.net/secure.meetupstatic.com/s/script/2012676015776998360572/api/mu.btns.js?id=8b62rgeubptp7m2cgors9kn138";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","mu-bootjs");</script>
-->
</body>
</html>
