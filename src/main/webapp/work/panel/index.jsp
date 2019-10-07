<%@page import="java.time.format.DateTimeParseException"%><%@page import="java.time.ZonedDateTime"%><%@page import="java.time.format.DateTimeFormatter"%><%@page import="io.cloudino.engine.DeviceMgr"%><%@page import="java.io.File"%><%@page import="org.semanticwb.datamanager.*"%><%@page contentType="text/html" pageEncoding="UTF-8"%><%
    DataObject user = (DataObject) session.getAttribute("_USER_");
    SWBScriptEngine engine = DataMgr.getUserScriptEngine("/cloudino.js", user);
    String since = "No data";
    try {
        ZonedDateTime zdt = ZonedDateTime.parse(user.getString("registeredAt"));
        since = zdt.format(DateTimeFormatter.ofPattern("MMMM'.' yyyy"));
    } catch (DateTimeParseException | NullPointerException noe) {
        SWBDataSource ds = engine.getDataSource("User");
        DataObject dao = ds.fetchObjById(user.getId());
        dao.put("registeredAt", ZonedDateTime.now().toString());
        since = ZonedDateTime.now().format(DateTimeFormatter.ofPattern("MMMM'.' yyyy"));
        ds.updateObj(dao);
    } //If can not parse it doesn't matter, its just aditional info.
%><!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Cloudino | Dashboard</title>
        <meta content='width=device-width, initial-scale=1, maximum-scale=.7, user-scalable=no' name='viewport'>
        <!-- Bootstrap 3.3.4 -->
        <link href="/static/admin/bower_components/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet" type="text/css" />    
        <link href="/static/admin/bower_components/datatables.net-bs/css/dataTables.bootstrap.min.css" rel="stylesheet" type="text/css" />
        <link href="/static/plugins/jquery.scrolling-tabs/jquery.scrolling-tabs.min.css" rel="stylesheet">
        
        <!-- FontAwesome 4.5.0 -->
        <link href="/static/admin/bower_components/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
        <link rel="stylesheet" href="/static/plugins/fontawesome-iconpicker-1.3.1/css/fontawesome-iconpicker.min.css">
        <!-- Ionicons 2.0.0 -->
        <link href="/static/admin/bower_components/Ionicons/css/ionicons.min.css" rel="stylesheet" type="text/css" />    
        <!-- Theme style -->
        <link href="/static/admin/dist/css/AdminLTE.min.css" rel="stylesheet" type="text/css" />
        <!-- AdminLTE Skins. Choose a skin from the css/skins 
             folder instead of downloading all of them to reduce the load. -->
        <link href="/static/admin/dist/css/skins/_all-skins.min.css" rel="stylesheet" type="text/css" />
        
        <link href="/static/admin/plugins/jvectormap/jquery-jvectormap-1.2.2.css" rel="stylesheet" type="text/css" />
        <!-- Date Picker -->
        <link href="/static/admin/bower_components/bootstrap-datepicker/dist/css/bootstrap-datepicker.min.css" rel="stylesheet" type="text/css" />
        <!-- Daterange picker -->
        <link href="/static/admin/bower_components/bootstrap-daterangepicker/daterangepicker.css" rel="stylesheet" type="text/css" />
        <!-- Bootstrap time Picker -->
        <link rel="stylesheet" href="/static/admin/plugins/timepicker/bootstrap-timepicker.min.css">
        <!-- bootstrap wysihtml5 - text editor -->
        <link href="/static/admin/plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.min.css" rel="stylesheet" type="text/css" />
        
        <link href="/static/plugins/bootstrap-switch/bootstrap-switch.min.css" rel="stylesheet" type="text/css" />
        
        <!-- FileInputPlugin -->
        <link href="/css/fileinput.min.css" media="all" rel="stylesheet" type="text/css" />

        <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
        <!--[if lt IE 9]>
            <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
            <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
        <![endif]-->

        <link rel="stylesheet" href="/static/plugins/codemirror/lib/codemirror.css"> 
        <link rel="stylesheet" href="/static/plugins/codemirror/addon/hint/show-hint.css">
        <link rel="stylesheet" href="/static/plugins/codemirror/theme/eclipse.css">   
        <link rel="stylesheet" href="/static/plugins/codemirror/addon/dialog/dialog.css">
        <link rel="stylesheet" href="/static/plugins/codemirror/addon/lint/lint.css">  

        <style type="text/css">
            .CodeMirror {border: 1px solid black; font-size:13px}
            
            /*
            .control-sidebar-bg, .control-sidebar {
                right: -250px;
                width: 250px;  
            }        
            */            

            @media (min-width: 768px) {
                .main-header .sidebar-toggle {
                    display: none;
                }
                .main_alert
                {
                    padding-left: 250px
                }
                .control-text{
                    padding-top: 7px;
                }
                .control-switch{                    
                    top: -20px;
                }
            }
            
            
            
            .cdino_buttons{
                padding-top: 10px;
            }
            
            .cdino_control {
                height: 90px;   
                display: inline-block;
            }
            
            .cdino_control_image {
                display: table;
            }    
            
            .cdino_text_menu{
                overflow:hidden;
                text-overflow:ellipsis;
            }
            
            .cdino_control_image, .cdino_control{
                padding: 10px 5px;
                margin: 0 0 10px 10px;
                min-width: 90px;
                font-size: 14px;
                border-radius: 3px;
                position: relative;
                padding: 15px 5px;
                text-align: center;
                color: #666;
                border: 1px solid #ddd;
                background-color: #f4f4f4;
                -webkit-box-shadow: none;
                box-shadow: none;                
                font-weight: 400;
                line-height: 1.42857143;
                white-space: nowrap;
                vertical-align: middle;
                -ms-touch-action: manipulation;
                touch-action: manipulation;
                cursor: pointer;
                -webkit-user-select: none;
                -moz-user-select: none;
                -ms-user-select: none;
                user-select: none;
            }
            
            /* Welcome content*/
            .boardstart *   { color:#FFF; }
            .boardstart h2  { font-size:50px; margin:0px; font-weight:bold; padding: 10px;}
            .boardstart li  { font-size: 21px; font-weight:300; line-height:40px}
            .seccion-boards,
            .seccion-learn  { padding:0;}
            #boards, #learn { height:780px;}

            /*BOARDS*/
            #boards { background: url( ../img/boards-fondo.png) no-repeat top left; background-size:cover}

            /*START*/
            #learn { background: url( ../img/start-fondo.png) no-repeat center; background-size:cover}
            #learn li.git { background-position:-2px 10px !important;}              
        </style>  


    </head>
    <body class="skin-blue sidebar-mini">
        <div class="wrapper">
            
            <header class="main-header">
                <!-- Logo -->
                <a href="/panel/" class="logo">
                    <img src="/img/cloudino.svg" width="170">
                    <!-- mini logo for sidebar mini 50x50 pixels 
                    <span class="logo-mini"><i class="fa fa-cloud"></i></span>-->
                    <!-- logo for regular state and mobile devices 
                    <span class="logo-lg"><i class="fa fa-cloud"></i> <b>Cloudino</b> Panel</span>-->
                </a>
                <!-- Header Navbar: style can be found in header.less -->
                <nav class="navbar navbar-static-top" role="navigation">
                    <!-- Sidebar toggle button-->
                   
                    <!-- Sidebar toggle button-->
                    <a href="#" class="sidebar-toggle" data-toggle="push-menu" role="button">
                      <span class="sr-only">Toggle navigation</span>
                    </a>
                    
                    <div class="navbar-custom-menu">
                        <ul class="nav navbar-nav">
                            <!-- User Account: style can be found in dropdown.less -->
<!--                            
                            <li>
                                <div style="padding: 8px;">
                                    <i class="fa fa-location-arrow" style="color: #f4f4f4;"></i>
                                    <span style="color: #f4f4f4;">Locations:</span>
                                    <select name="location" class="form-control" style="background-color: rgba(34, 45, 50, 0);width: 150px;/* border-color: rgba(34, 45, 50, 0); */color: #f4f4f4;/* height: 34px; *//* margin-left: -5px; *//* font-weight: 400; *//* font-size: 14px; */display: inline;">
                                        <option>Casa Jei</option>
                                    </select>
                                </div>                                
                            </li>                            
-->                            
                            <li class="dropdown user user-menu">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                                    <img src="/photo" class="user-image" alt="User Image"/>
                                    <span class="hidden-xs"><%=user.getString("fullname")%></span>
                                </a>
                                <ul class="dropdown-menu">
                                    <!-- User image -->
                                    <li class="user-header">
                                        <img src="/photo" class="img-circle" alt="User Image" />
                                        <p>
                                            <%=user.getString("fullname")%>
                                            <small>Member since <%=since%></small>
                                        </p>
                                    </li>
                                    <!-- Menu Body -->
                                    <!--<li class="user-body">
                                      <div class="col-xs-4 text-center">
                                        <a href="#">Followers</a>
                                      </div>
                                      <div class="col-xs-4 text-center">
                                        <a href="#">Sales</a>
                                      </div>
                                      <div class="col-xs-4 text-center">
                                        <a href="#">Friends</a>
                                      </div>
                                    </li>-->
                                    <!-- Menu Footer-->
                                    <li class="user-footer">
                                        <div class="pull-left">
                                            <a href="/profile" class="btn btn-default btn-flat" data-target=".content-wrapper" data-load="ajax">Profile</a>
                                        </div>
                                        <div class="pull-right">
                                            <a href="/panel/logout" class="btn btn-default btn-flat">Sign out</a>
                                        </div>
                                    </li>
                                </ul>
                            </li>
<!--                             
                            <li>
                                <a href="#"><i class="fa fa-gears" style="font-weight: bold;"></i> Settings</a>
                            </li>
-->                            
                            <!-- Control Sidebar Toggle Button -->
                            <li style="background-color: #367FA9;">
                                <a href="#" id="code_button" data-slide_="false" data-toggle="control-sidebar"><i class="fa fa-code" style="font-weight: bold;"></i></a>
                            </li>
                        </ul>
                    </div>
                </nav>
            </header>

            <!-- Left side column. contains the logo and sidebar -->
            <aside class="main-sidebar">
                <jsp:include page="menu.jsp" />
                <!-- /.sidebar -->
            </aside>     
                
            <div id="alert_main" class="alert alert-success main_alert" style="display:none">
                    <button type="button" class="close" onclick="$(this.parentElement).hide(500);" aria-hidden="true">×</button>
                    <h4><i id="alert_icon" class="icon fa fa-check"></i> <span id="alert_title">Alert</span></h4>
                    <span id="alert_content">Success alert preview. This alert is dismissable.</span>                    
            </div>

            <!-- Content Wrapper. Contains page content -->
            <div class="content-wrapper">
                <!-- Content Header (Page header) -->
                <section class="content-header">
                    <h1>
                        Dashboard
                        <small>Control panel</small>
                    </h1>
                    <ol class="breadcrumb">
                        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
                        <li class="active">Dashboard</li>
                    </ol>
                </section>

                <!-- Main content -->
                <section class="content">                                        
                    
                    <section id="learn" class="boardstart seccion-learn">
                      <h2>Getting Started</h2>
                      <ul>
                        <li><a href="https://github.com/Cloudino/Cloudino-Doc">Cloudino Documentation</a></li>  
                        <li><a href="https://github.com/Cloudino/Cloudino-Doc/wiki/Cloudino-Arquitecture">Cloudino Arquitecture</a></li>  
                        <li><a href="https://github.com/Cloudino/Cloudino-Doc/wiki/Cloudino-WiFi-Connector">Cloudino WiFi Cloud Connector</a>
                          <ul>    
                            <li><a href="https://github.com/Cloudino/Cloudino-Doc/wiki/Cloudino-WiFi-Connector-Schema">Cloudino Connector Squema</a></li>
                            <li><a href="https://github.com/Cloudino/Cloudino-Doc/wiki/Make-your-first-Cloudino">Make your first Cloudino </a></li>
                          </ul>
                        </li>  
                        <li>Cloudino with Arduino
                          <ul>    
                            <li><a href="https://github.com/Cloudino/Cloudino-Doc/wiki/Cloudino-with-Arduino-Connection-Squema">Arduino Connection Squema</a></li>
                            <li><a href="https://github.com/Cloudino/Cloudino-Doc/wiki/Cloudino-Library-for-Arduino">Cloudino Library for Arduino</a></li>
                            <li><a href="https://github.com/Cloudino/Cloudino-ArduinoLib">Download Arduino Library</a></li>
                          </ul>
                        </li>    
                        <li>Cloudino with JavaScript
                          <ul>    
                            <li><a href="https://github.com/Cloudino/Cloudino-Doc/wiki/CloudinoJS-Examples">CloudinoJS Examples</a></li>
                            <li><a href="https://github.com/Cloudino/Cloudino-Doc/wiki/CloudinoJS-Language-Reference">CloudinoJS Language Reference</a></li>
                          </ul>
                        </li>    
                    <!--    
                        <li>Cloudino Configuration
                          <ul>
                            <li>Wifi Configuration</li>
                            <li>Cloud Configuration</li>
                          </ul>
                        </li>
                        <li>Programming Arduino using WIFI</li>
                        <li>Programming Arduino using Cloud</li>
                    -->
                        <li><a href="/doc/Connecting_Cloudino_Connector_to_FIWARE_IoT.pdf">Connecting to FIWARE IoT</a></li>
                      </ul>
                    </section>                                          

                </section><!-- /.content -->
            </div><!-- /.content-wrapper -->
            <footer class="main-footer">
                <div class="pull-right hidden-xs">
                    <b>Version</b> 0.1
                </div>
                <strong>Copyright &copy; 2015-2020 <a href="http://cloudino.io">Cloudino</a>.</strong> All rights reserved.
            </footer>

            <!-- Control Sidebar -->      
            <aside class="control-sidebar control-sidebar-dark">                
                <!-- Create the tabs -->
                <ul class="nav nav-tabs nav-justified control-sidebar-tabs">
                    <li class="active"><a href="#arduino" data-toggle="tab">Arduino<!--<i class="fa fa-home"></i>--></a></li>
                    <li><a href="#cloudinojs" data-toggle="tab">CloudinoJS<!--<i class="fa fa-gears"></i>--></a></li>
                </ul>
                <!-- Tab panes -->
                <div class="tab-content" style="padding: 1px 1px;">
                    <!-- Home tab content -->
                    <div class="tab-pane active" id="arduino">
                        <%--jsp:include page="arduino.jsp" /--%>
                        <section class="sidebar">
                            <ul class="sidebar-menu" data-widget="tree">
                                <li class="header">Loading...</li>
                            </ul>
                        </section>                        
                    </div><!-- /.tab-pane -->
                    <!-- Settings tab content -->
                    <div class="tab-pane" id="cloudinojs">            
                        <%--jsp:include page="cloudinojs.jsp" /--%>
                        <section class="sidebar">
                            <ul class="sidebar-menu" data-widget="tree">
                                <li class="header">Loading...</li>
                            </ul>
                        </section>                        
                    </div><!-- /.tab-pane -->
                    
                </div>
            </aside><!-- /.control-sidebar -->
            <!-- Add the sidebar's background. This div must be placed
                 immediately after the control sidebar -->
            <div class='control-sidebar-bg'></div>
        </div><!-- ./wrapper -->

        <script src="/static/admin/bower_components/jquery/dist/jquery.min.js"></script>
        <script src="/js/fileinput.min.js"></script>

        <!-- Bootstrap 3.3.2 JS -->
        <script src="/static/admin/bower_components/bootstrap/dist/js/bootstrap.min.js" type="text/javascript"></script>  
        <!-- Sparkline -->
        <script src="/static/admin/bower_components/jquery-sparkline/dist/jquery.sparkline.min.js" type="text/javascript"></script>
        <!-- jQuery Knob Chart -->
        <script src="/static/admin/bower_components/jquery-knob/dist/jquery.knob.min.js" type="text/javascript"></script>
        
        <!-- bootstrap time picker -->
        <script src="/static/admin/plugins/timepicker/bootstrap-timepicker.min.js"></script>

        <script src="/static/plugins/jquery.scrolling-tabs/jquery.scrolling-tabs.js"></script>

        <!-- AdminLTE App -->
        <script src="/static/admin/dist/js/adminlte.min.js" type="text/javascript"></script>    

        <script src="/static/plugins/validator/validator.min.js" type="text/javascript"></script>
        <script src="/static/plugins/bootstrap-switch/bootstrap-switch.min.js" type="text/javascript"></script>  
        <script src="/static/plugins/fontawesome-iconpicker-1.3.1/js/fontawesome-iconpicker.min.js" type="text/javascript"></script> 
        
        <script src="/static/admin/bower_components/moment/min/moment.min.js"></script>        
        <script src="/static/plugins/Chart.js-2.7.1/dist/Chart.bundle.min.js"></script>        
        <!-- daterangepicker -->
        <script src="/static/admin/bower_components/bootstrap-daterangepicker/daterangepicker.js" type="text/javascript"></script>
        <!-- datepicker -->
        <script src="/static/admin/bower_components/bootstrap-datepicker/dist/js/bootstrap-datepicker.min.js" type="text/javascript"></script>
        
        <script type="text/javascript" src="/js/websockets.js"></script>
        <script src="/static/plugins/codemirror/lib/codemirror.js"></script>  
        <script src="/static/plugins/codemirror/addon/hint/show-hint.js"></script>
        <script src="/static/plugins/codemirror/addon/selection/active-line.js"></script> 
        <script src="/static/plugins/codemirror/addon/lint/lint.js"></script>       
        <script src="/static/plugins/codemirror/addon/search/search.js"></script> 
        <script src="/static/plugins/codemirror/addon/search/searchcursor.js"></script>
        <script src="/static/plugins/codemirror/addon/dialog/dialog.js"></script>

        <script src="/static/plugins/codemirror/addon/edit/matchbrackets.js"></script>  
        <script src="/static/plugins/codemirror/addon/edit/closebrackets.js"></script>  
        <script src="/static/plugins/codemirror/addon/comment/continuecomment.js"></script>
        <script src="/static/plugins/codemirror/addon/comment/comment.js"></script> 

        <script src="/static/plugins/codemirror/mode/clike/clike.js"></script>        


        <script src="/static/plugins/blockly/blockly_compressed.js"></script>
        <script src="/static/plugins/blockly/blocks_compressed.js"></script>
        <script src="/static/plugins/blockly/arduino_compressed.js"></script>
        <script src="/static/plugins/blockly/javascript_compressed.js"></script>
        <script src="/static/plugins/blockly/msg/js/en.js"></script>
        <script src="/js/cloudino_blockly.js"></script>
        
        <script src="/static/plugins/codemirror/mode/javascript/javascript.js"></script>
        <script src="/static/plugins/codemirror/addon/hint/javascript-hint.js"></script>
        <script src="/static/plugins/codemirror/addon/lint/javascript-lint.js"></script>
        <script src="/static/plugins/codemirror/addon/hint/jshint.js"></script>
        
        <script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDS11cq98QRzhvPbDC-Fsdwd68vIfne5vg"></script>
 
        <script src="/js/cloudino_utils.js"></script>
        
        <script type="text/javascript">setInterval(function(){loadContent('/panel/menuDevices','.devices');},10000);</script>
        <script type="text/javascript">
            setTimeout(function(){
                loadContent('/panel/arduino','#arduino');
                loadContent('/panel/cloudinojs','#cloudinojs');
            },0);
        </script>
        
        <style type="text/css">            
            .blocklyToolboxDiv {
                background-color: #F3F3F3;
                overflow-x: visible;
                overflow-y: auto;
                position: absolute;
                color: #212121;
            }
            .blocklyWidgetDiv {
                z-index: 2000;
            }                
        </style> 
    </body>
</html>