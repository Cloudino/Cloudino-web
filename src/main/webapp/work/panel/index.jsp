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
        <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>
        <!-- Bootstrap 3.3.4 -->
        <link href="/static/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />    
        <!-- FontAwesome 4.5.0 -->
        <link href="/static/plugins/font-awesome-4.5.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
        <link rel="stylesheet" href="/static/plugins/fontawesome-iconpicker-1.0.0/css/fontawesome-iconpicker.min.css">
        <!-- Ionicons 2.0.0 -->
        <link href="/static/plugins/ionicons-2.0.1/css/ionicons.min.css" rel="stylesheet" type="text/css" />    
        <!-- Theme style -->
        <link href="/static/dist/css/AdminLTE.min.css" rel="stylesheet" type="text/css" />
        <!-- AdminLTE Skins. Choose a skin from the css/skins 
             folder instead of downloading all of them to reduce the load. -->
        <link href="/static/dist/css/skins/_all-skins.min.css" rel="stylesheet" type="text/css" />
        <!-- iCheck -->
        <link href="/static/plugins/iCheck/flat/blue.css" rel="stylesheet" type="text/css" />
        <!-- Morris chart -->
        <link href="/static/plugins/morris/morris.css" rel="stylesheet" type="text/css" />
        <!-- jvectormap -->
        <link href="/static/plugins/jvectormap/jquery-jvectormap-1.2.2.css" rel="stylesheet" type="text/css" />
        <!-- Date Picker -->
        <link href="/static/plugins/datepicker/datepicker3.css" rel="stylesheet" type="text/css" />
        <!-- Daterange picker -->
        <link href="/static/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet" type="text/css" />
        <!-- bootstrap wysihtml5 - text editor -->
        <link href="/static/plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.min.css" rel="stylesheet" type="text/css" />
        
        <link href="/static/plugins/bootstrap-switch/bootstrap-switch.min.css" rel="stylesheet" type="text/css" />
        
        <!-- FileInputPlugin -->
        <link href="/css/fileinput.min.css" media="all" rel="stylesheet" type="text/css" />

        <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
        <!--[if lt IE 9]>
            <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
            <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
        <![endif]-->

        <link rel="stylesheet" href="/plugins/codemirror/lib/codemirror.css"> 
        <link rel="stylesheet" href="/plugins/codemirror/addon/hint/show-hint.css">
        <link rel="stylesheet" href="/plugins/codemirror/theme/eclipse.css">   
        <link rel="stylesheet" href="/plugins/codemirror/addon/dialog/dialog.css">
        <link rel="stylesheet" href="/plugins/codemirror/addon/lint/lint.css">  

        <style type="text/css">
            .CodeMirror {border: 1px solid black; font-size:13px}
            
            .control-sidebar-bg, .control-sidebar {
                right: -250px;
                width: 250px;
            }                        
            
            @media (min-width: 768px) {
                .main-header .sidebar-toggle {
                    display: none;
                }
                .main_alert
                {
                    padding-left: 250px
                }
            }
            
            .cdino_buttons{
                padding-top: 10px;
            }
            
            .cdino_control {
                padding: 10px 5px;
                margin: 0 0 10px 10px;
                min-width: 90px;
                height: 90px;
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
                display: inline-block;
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
                   
                    <a href="#" class="sidebar-toggle" data-toggle="offcanvas" role="button">
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
                                            <a href="/login?logout=true" class="btn btn-default btn-flat">Sign out</a>
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
                                <a href="#" data-toggle="control-sidebar"><i class="fa fa-code" style="font-weight: bold;"></i></a>
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
                    <li>Arduino Connection Squema</li>
                    <li>Cloudino Configuration
                      <ul>
                        <li>Wifi Configuration</li>
                        <li>Cloud Configuration</li>
                      </ul>
                    </li>
                    <li>Programming Arduino using WIFI</li>
                    <li>Programming Arduino using Cloud</li>
                    <li><a target="_blank" href="/doc/Connecting_Cloudino_Connector_to_FIWARE_IoT.pdf">Connecting to FIWARE IoT</a></li>
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
                        <jsp:include page="arduino.jsp" />
                    </div><!-- /.tab-pane -->
                    <!-- Settings tab content -->
                    <div class="tab-pane" id="cloudinojs">            
                        <jsp:include page="cloudinojs.jsp" />
                    </div><!-- /.tab-pane -->
                </div>
            </aside><!-- /.control-sidebar -->
            <!-- Add the sidebar's background. This div must be placed
                 immediately after the control sidebar -->
            <div class='control-sidebar-bg'></div>
        </div><!-- ./wrapper -->

        <!-- jQuery 2.1.4 -->
        <!--<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>-->
        <script src="/static/plugins/jQuery/jQuery-2.1.4.min.js"></script>
        <!-- jQuery UI 1.11.2 --
        <script src="http://code.jquery.com/ui/1.11.2/jquery-ui.min.js" type="text/javascript"></script>
        <!-- Resolve conflict in jQuery UI tooltip with Bootstrap tooltip --
        <script>
          $.widget.bridge('uibutton', $.ui.button);
        </script>
        <!-- Just needed for resize --
        <script src="path/to/js/plugins/canvas-to-blob.min.js" type="text/javascript"></script>
        <!-- FileInputPlugin -->
        <script src="/js/fileinput.min.js"></script>

        <!-- Bootstrap 3.3.2 JS -->
        <script src="/static/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>  
        <!-- Sparkline -->
        <script src="/static/plugins/sparkline/jquery.sparkline.min.js" type="text/javascript"></script>
        <!-- jQuery Knob Chart -->
        <script src="/static/plugins/knob/jquery.knob.js" type="text/javascript"></script>
        
        <!--
        <!-- Morris.js charts --
        <script src="http://cdnjs.cloudflare.com/ajax/libs/raphael/2.1.0/raphael-min.js"></script>
        <script src="/static/plugins/morris/morris.min.js" type="text/javascript"></script>
        <!-- jvectormap --
        <script src="/static/plugins/jvectormap/jquery-jvectormap-1.2.2.min.js" type="text/javascript"></script>
        <script src="/static/plugins/jvectormap/jquery-jvectormap-world-mill-en.js" type="text/javascript"></script>
        <!-- daterangepicker --
        <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.10.2/moment.min.js" type="text/javascript"></script>
        <script src="/static/plugins/daterangepicker/daterangepicker.js" type="text/javascript"></script>
        <!-- datepicker --
        <script src="/static/plugins/datepicker/bootstrap-datepicker.js" type="text/javascript"></script>
        <!-- Bootstrap WYSIHTML5 --
        <script src="/static/plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.all.min.js" type="text/javascript"></script>
        <!-- Slimscroll --
        <script src="/static/plugins/slimScroll/jquery.slimscroll.min.js" type="text/javascript"></script>
        <!-- FastClick --
        <script src='/static/plugins/fastclick/fastclick.min.js'></script>
        -->
        <!--<script src="/static/bootstrap/js/bootbox.min.js" type="text/javascript"></script>  -->

        <!-- AdminLTE App -->
        <script src="/static/dist/js/app.min.js" type="text/javascript"></script>    

        <!-- AdminLTE dashboard demo (This is only for demo purposes) -->
        <!--    
            <script src="/static/dist/js/pages/dashboard.js" type="text/javascript"></script> 
            <script src="/static/dist/js/demo.js" type="text/javascript"></script>
        -->   

        <script src="/static/plugins/validator/validator.min.js" type="text/javascript"></script>
        <script src="/static/plugins/bootstrap-switch/bootstrap-switch.min.js" type="text/javascript"></script>  
        <script src="/static/plugins/fontawesome-iconpicker-1.0.0/js/fontawesome-iconpicker.min.js" type="text/javascript"></script>  
        
        <script type="text/javascript" src="/js/websockets.js"></script>
        <script src="/plugins/codemirror/lib/codemirror.js"></script>  
        <script src="/plugins/codemirror/addon/hint/show-hint.js"></script>
        <script src="/plugins/codemirror/addon/selection/active-line.js"></script> 
        <script src="/plugins/codemirror/addon/lint/lint.js"></script>       
        <script src="/plugins/codemirror/addon/search/search.js"></script> 
        <script src="/plugins/codemirror/addon/search/searchcursor.js"></script>
        <script src="/plugins/codemirror/addon/dialog/dialog.js"></script>

        <script src="/plugins/codemirror/addon/edit/matchbrackets.js"></script>  
        <script src="/plugins/codemirror/addon/edit/closebrackets.js"></script>  
        <script src="/plugins/codemirror/addon/comment/continuecomment.js"></script>
        <script src="/plugins/codemirror/addon/comment/comment.js"></script> 

        <script src="/plugins/codemirror/mode/clike/clike.js"></script>        


        <script src="/plugins/blockly/blockly_compressed.js"></script>
        <script src="/plugins/blockly/blocks_compressed.js"></script>
        <script src="/plugins/blockly/arduino_compressed.js"></script>
        <script src="/plugins/blockly/javascript_compressed.js"></script>
        <script src="/plugins/blockly/msg/js/en.js"></script>
        <script src="/js/cloudino_blockly.js"></script>
        
        <script src="/plugins/codemirror/mode/javascript/javascript.js"></script>
        <script src="/plugins/codemirror/addon/hint/javascript-hint.js"></script>
        <script src="/plugins/codemirror/addon/lint/javascript-lint.js"></script>
        <script src="/plugins/codemirror/addon/hint/jshint.js"></script>
 
        <script src="/js/cloudino_utils.js"></script>
        <script type="text/javascript">setInterval(function(){loadContent('/panel/devices','.devices');},10000);</script>
        
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