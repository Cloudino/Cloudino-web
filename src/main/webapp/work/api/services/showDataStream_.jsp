<%@page import="java.util.StringTokenizer"%>
<%@page import="java.time.format.DateTimeParseException"%><%@page import="java.time.ZonedDateTime"%><%@page import="java.time.format.DateTimeFormatter"%><%@page import="io.cloudino.engine.DeviceMgr"%><%@page import="java.io.File"%><%@page import="org.semanticwb.datamanager.*"%><%@page contentType="text/html" pageEncoding="UTF-8"%><%
    DataObject user = (DataObject) session.getAttribute("_USER_");
    SWBScriptEngine engine = DataMgr.getUserScriptEngine("/cloudino.js", user);
    
    String uri=request.getRequestURI();
    StringTokenizer st=new StringTokenizer(uri,"/");
    String api=st.nextToken();
    String serv=st.nextToken();
    String dsid=null;
    String devid=null;
    if(st.hasMoreTokens())dsid=st.nextToken();
    if(st.hasMoreTokens())devid=st.nextToken();    
    if(dsid==null)
    {
        out.println("Cloudino HTTP API:");
        out.println("GET /api/showDataStream/[DataStream ID]/[Device ID]");
        return;
    }    
%><!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Cloudino | Dashboard</title>
        <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>
        <!-- Bootstrap 3.3.4 -->
        <link href="/static/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />    
        <link href="/static/admin/plugins/datatables/dataTables.bootstrap.css" rel="stylesheet" type="text/css" />

        <!-- FontAwesome 4.5.0 -->
        <link href="/static/admin/plugins/font-awesome-4.5.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
        <link rel="stylesheet" href="/static/admin/plugins/fontawesome-iconpicker-1.0.0/css/fontawesome-iconpicker.min.css">
        <!-- Ionicons 2.0.0 -->
        <link href="/static/admin/plugins/ionicons-2.0.1/css/ionicons.min.css" rel="stylesheet" type="text/css" />    
        <!-- Theme style -->
        <link href="/static/admin/dist/css/AdminLTE.min.css" rel="stylesheet" type="text/css" />
        <!-- AdminLTE Skins. Choose a skin from the css/skins 
             folder instead of downloading all of them to reduce the load. -->
        <link href="/static/admin/dist/css/skins/_all-skins.min.css" rel="stylesheet" type="text/css" />
        <!-- iCheck -->
        <link href="/static/admin/plugins/iCheck/flat/blue.css" rel="stylesheet" type="text/css" />
        <!-- Morris chart -->
<!--        
        <link href="/static/admin/plugins/morris/morris.css" rel="stylesheet" type="text/css" />
-->
        <!-- jvectormap -->
        <link href="/static/admin/plugins/jvectormap/jquery-jvectormap-1.2.2.css" rel="stylesheet" type="text/css" />
        <!-- Date Picker -->
        <link href="/static/admin/plugins/datepicker/datepicker3.css" rel="stylesheet" type="text/css" />
        <!-- Daterange picker -->
        <link href="/static/admin/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet" type="text/css" />
        <!-- bootstrap wysihtml5 - text editor -->
        <link href="/static/admin/plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.min.css" rel="stylesheet" type="text/css" />
        
        <link href="/static/admin/plugins/bootstrap-switch/bootstrap-switch.min.css" rel="stylesheet" type="text/css" />
        
        <!-- FileInputPlugin -->
        <link href="/css/fileinput.min.css" media="all" rel="stylesheet" type="text/css" />

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
                height: 90px;   
                display: inline-block;
            }
            
            .cdino_control_image {
                display: table;
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

<!--                             
                            <li>
                                <a href="#"><i class="fa fa-gears" style="font-weight: bold;"></i> Settings</a>
                            </li>
-->                            
                        </ul>
                    </div>
                </nav>
            </header>    
                
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
                    <jsp:include page="/work/dataStreams/dataStreamDash.jsp" />
                </section><!-- /.content -->
            </div><!-- /.content-wrapper -->
            <footer class="main-footer">
                <div class="pull-right hidden-xs">
                    <b>Version</b> 0.1
                </div>
                <strong>Copyright &copy; 2015-2020 <a href="http://cloudino.io">Cloudino</a>.</strong> All rights reserved.
            </footer>

            <!-- Add the sidebar's background. This div must be placed
                 immediately after the control sidebar -->
            <div class='control-sidebar-bg'></div>
        </div><!-- ./wrapper -->

        <!-- jQuery 2.1.4 -->
        <script src="/static/admin/plugins/jQuery/jQuery-2.1.4.min.js"></script>
        <script src="/js/fileinput.min.js"></script>

        <!-- Bootstrap 3.3.2 JS -->
        <script src="/static/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>  
        <!-- Sparkline -->
        <script src="/static/admin/plugins/sparkline/jquery.sparkline.min.js" type="text/javascript"></script>
        <!-- jQuery Knob Chart -->
        <script src="/static/admin/plugins/knob/jquery.knob.js" type="text/javascript"></script>
       
        <!-- AdminLTE App -->
        <script src="/static/admin/dist/js/app.min.js" type="text/javascript"></script>    

        <script src="/static/admin/plugins/validator/validator.min.js" type="text/javascript"></script>
        <script src="/static/admin/plugins/bootstrap-switch/bootstrap-switch.min.js" type="text/javascript"></script>  
        <script src="/static/admin/plugins/fontawesome-iconpicker-1.0.0/js/fontawesome-iconpicker.min.js" type="text/javascript"></script>  
        
        <script src="/static/admin/plugins/moment/2.18.1/moment.min.js"></script>        
        <script src="/static/admin/plugins/chartjs/2.6.0/Chart.min.js"></script>        
        
        <script type="text/javascript" src="/js/websockets.js"></script>
        <script src="/plugins/codemirror/mode/clike/clike.js"></script>        
 
        <script src="/js/cloudino_utils.js"></script>
        
    </body>
</html>