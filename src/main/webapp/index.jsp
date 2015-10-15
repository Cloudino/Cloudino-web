<!DOCTYPE html>
<html lang="en">

    <head>

        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="description" content="">
        <meta name="author" content="">
        <link rel="shortcut icon" href="img/cloudino.png">

        <title>Cloudino: The easiest way to connect your Arduino to the Cloud</title>

        <!-- Bootstrap Core CSS -->
        <link href="css/bootstrap.min.css" rel="stylesheet">

        <!-- Custom CSS -->
        <link href="css/agency.css" rel="stylesheet">
        <link href="css/cloudino.css" rel="stylesheet">
        <link href="css/cloudino-custom.css" rel="stylesheet">
        <!-- Custom Fonts -->
        <link href="font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
        <link href='https://fonts.googleapis.com/css?family=Muli:400,300' rel='stylesheet' type='text/css'>

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
                    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a class="navbar-brand page-scroll" href="#page-top" title="Cloudino"><img src="img/cloudino.svg" class="img-responsive"><h1>Cloudino: The easiest way to connect your Arduino to the Cloud</h1></a>
                </div>

                <!-- Collect the nav links, forms, and other content for toggling -->
                <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                    <ul class="nav navbar-nav navbar-right">
                        <li class="hidden">
                            <a href="#page-top"></a>
                        </li>
                        <li>
                            <a class="page-scroll" href="#innovation">Innovation</a>
                        </li>
                        <li>
                            <a class="page-scroll" href="#components">Components</a>
                        </li>
                        <li>
                            <a class="page-scroll" href="#boards">Boards</a>
                        </li>
                        <li>
                            <a class="page-scroll" href="#learn">Learn</a>
                        </li>
                        <li>
                            <a class="page-scroll" href="#contact">Contact</a>
                        </li>
                        <li>
                            <a class="page-scroll" href="panel/">Log In</a>
                            <!--<a href="panel/"><i class="glyphicon glyphicon-cog" style="font-size: 30px;position: absolute;padding-top: 10px;"></i></a>-->                        
                        </li>                    
                    </ul>
                </div>
                <!-- /.navbar-collapse -->
            </div>
            <!-- /.container-fluid -->
        </nav>

        <!-- Header -->
        <header>
            <img src="img/nube-1.svg" class="nube1">
            <img src="img/nube-2.svg" class="nube2 hidden-xs">
            <img src="img/nube-3.svg" class="nube3 hidden-xs">
            <div class="container seccion-header">
                <div class="row clearfix ">
                    <div class="col-xs-12 col-sm-12 col-md-4 col-lg-4 headdiv1">
                        <h2><strong>Cloudino</strong> an Internet of Things Platform</h2>
                    </div>
                    <div class="col-xs-12 col-sm-12 col-md-4 col-lg-4 headdiv2">
                        <img src="img/header-cloudino.png" class="img-responsive">
                    </div>
                    <div class="col-xs-12 col-sm-12 col-md-4 col-lg-4 headdiv3">
                        <h2>The easiest way to connect your <strong>Arduino to the Cloud</strong></h2> 
                    </div>
                </div>
                <a href="#innovation" class="page-scroll btn btn-xl">Tell Me More</a>
            </div>
        </header>
        <div class="x"></div>
        <!-- INNOVATION -->
        <section id="innovation">
            <div class="container seccion-innovation">
                <div class="row clearfix ">
                    <div class="col-xs-11 col-sm-6 col-md-6 col-lg-5">
                        <img src="img/innova-lego.png" class="img-responsive">
                    </div>
                    <div class="col-xs-12 col-sm-6 col-md-6 col-lg-7">
                        <h2>Our Innovation:<br/> The WiFi Cloud Connector</h2>
                        <p>Connect to the cloud, easy and transparent, differents MCU platforms like Atmel AVR, Microchip PIC, etc.</p>
                        <p>The <strong>WiFi Cloud Connector</strong> is not an Arduino shield, is other processor working in parallel dedicated only to the network layer including the IoT protocols, leaving the Arduino dedicated to the connectivity with the sensors and actuators, while allows reprogramming Arduino via WiFi or Cloud.</p>
                        <a id="modal-diagrama" href="#modal-container-diagrama" role="button" class="btn page-scroll btn-xl" data-toggle="modal">How it works?</a>
                    </div>
                </div>

            </div>
        </section>

        <!-- COMPONENTS -->
        <section id="components">
            <div class="container seccion-components">
                <h2>Components</h2>
                <div class="row clearfix ">
                    <div class="col-xs-12 col-sm-4 col-md-4 col-lg-4">
                        <img src="img/compnents-arduino.png" class="img-responsive">
                        <div class="panel-group" id="panel-03">
                            <div class="panel panel-default">
                                <div class="panel-heading">
                                    <a class="panel-title collapsed btnUpDown" data-toggle="collapse" data-parent="#panel-03" href="#panel-element-03">Arduino API <span aria-hidden="true" class="glyphicon glyphicon-chevron-down"></span><span class="glyphicon glyphicon-chevron-up" aria-hidden="true"></span></a>
                                </div>
                                <div id="panel-element-03" class="panel-collapse collapse">
                                    <div class="panel-body">
                                        <ul>
                                            <li>Simple Message Router</li>
                                            <li>Simple Timer API</li>
                                            <li>Console Messaging</li>
                                            <hr>
                                            <li><a href="https://github.com/Cloudino/Cloudino-ArduinoLib">Arduino API</a></li>
                                            <li><a href="https://github.com/Cloudino/Arduino">Arduino IDE (Cloudino Integration)</a></li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                    <div class="col-xs-12 col-sm-4 col-md-4 col-lg-4">
                        <img src="img/compnents-wifi.png" class="img-responsive">
                        <div class="panel-group" id="panel-01">
                            <div class="panel panel-default">
                                <div class="panel-heading">
                                    <a class="panel-title collapsed btnUpDown" data-toggle="collapse" data-parent="#panel-01" href="#panel-element-01">Wifi Cloud Connector <span aria-hidden="true" class="glyphicon glyphicon-chevron-down"></span><span class="glyphicon glyphicon-chevron-up" aria-hidden="true"></span></a>
                                </div>
                                <div id="panel-element-01" class="panel-collapse collapse">
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
                                            <hr>
                                            <li><a href="https://github.com/Cloudino/Cloudino-Firmware">Cloudino Firmware</a></li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                    <div class="col-xs-12 col-sm-4 col-md-4 col-lg-4">
                        <img src="img/compnents-cloud.png" class="img-responsive">
                        <div class="panel-group" id="panel-02">
                            <div class="panel panel-default">
                                <div class="panel-heading">
                                    <a class="panel-title collapsed btnUpDown" data-toggle="collapse" data-parent="#panel-02" href="#panel-element-02">Cloud Service <span aria-hidden="true" class="glyphicon glyphicon-chevron-down"></span><span class="glyphicon glyphicon-chevron-up" aria-hidden="true"></span></a>
                                </div>
                                <div id="panel-element-02" class="panel-collapse collapse">
                                    <div class="panel-body">
                                        <ul>
                                            <li>Web IDE (based on Arduino IDE)</li>
                                            <li>Cloud Arduino Programming</li>
                                            <li>Cloud Storage</li>
                                            <li>Rule Manager</li>
                                            <li>Message Manager</li>
                                            <li>Device Console</li>
                                            <li>Push Notification</li>
                                            <hr>
                                            <li><a href="https://github.com/Cloudino/Cloudino-web">Cloudino Server</a></li>
                                        </ul>
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
                <li>WIFI Programming</li>
                <li>Cloud Programming</li>
            </ul>
        </section>



        <!-- Contact Us -->
        <section id="contact">
            <div class="container">
                <div class="row">
                    <div class="col-lg-12 text-center">
                        <h2>Contact Us</h2>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-12">
                        <form name="commentform" method="post" action="http://www.cloudino.io/mail/mail.php">
                            <div class="row">
                                <div class="col-md-5">
                                    <div class="form-group">
                                        <input type="text" class="form-control" placeholder="Name" id="name" required data-validation-required-message="Please enter your name.">
                                        <p class="help-block text-danger"></p>
                                    </div>
                                    <div class="form-group">
                                        <input type="email" class="form-control" placeholder="Email" id="email" required data-validation-required-message="Please enter your email address.">
                                        <p class="help-block text-danger"></p>
                                    </div>
                                </div>
                                <div class="col-md-7">
                                    <div class="form-group">
                                        <textarea class="form-control" placeholder="Message..." id="message" required data-validation-required-message="Please enter a message."></textarea>
                                        <p class="help-block text-danger"></p>
                                    </div>
                                </div>
                                <div class="clearfix"></div>
                                <div class="col-lg-12 text-center">
                                    <div id="success"></div>
                                    <button type="submit" value="Submit" class="btn btn-xl">Send Message</button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </section>

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

                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                            ×
                        </button>
                        <h4 class="modal-title" id="myModalLabel">
                            Cloudino Architecture
                        </h4>
                    </div>
                    <div class="modal-body">
                        <img src="img/arquitecture.png" class="img-responsive">
                    </div>

                </div>

            </div>

        </div>




        <script src="js/jquery.js"></script>
        <script src="js/bootstrap.min.js"></script>
        <script src="http://cdnjs.cloudflare.com/ajax/libs/jquery-easing/1.3/jquery.easing.min.js"></script>
        <script src="js/classie.js"></script>
        <script src="js/cbpAnimatedHeader.js"></script>
        <script src="js/jqBootstrapValidation.js"></script>
        <script src="js/contact_me.js"></script>
        <script src="js/agency.js"></script>

    </body>

</html>
