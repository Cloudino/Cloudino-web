<%@page import="java.io.IOException"%><%@page import="java.time.Instant"%><%@page import="java.text.SimpleDateFormat"%><%@page import="io.cloudino.utils.Utils"%><%@page import="java.util.*"%><%@page import="io.cloudino.engine.Device"%><%@page import="io.cloudino.datastreams.*"%><%@page import="io.cloudino.engine.DeviceMgr"%><%@page import="java.io.File"%><%@page import="org.semanticwb.datamanager.*"%><%@page contentType="text/html" pageEncoding="UTF-8"%><%!

%><%
    response.setHeader("Pragma", "No-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);
    
    DataObject user = (DataObject) session.getAttribute("_USER_");
    SWBScriptEngine engine = DataMgr.getUserScriptEngine("/cloudino.js", user);
    String view = request.getParameter("view");
    String did = request.getParameter("ID");
    if (did == null && view==null) {
        response.sendError(404);
        return;
    } else if (did!=null) {
        SWBDataSource ds = engine.getDataSource("Device");
        DataObject obj = ds.fetchObjById(ds.getBaseUri() + did);
        if (obj == null) {
            response.sendError(404);
            return;
        }
    }
    
    String name="Dashboard";
    Device dev=(did!=null)?DeviceMgr.getInstance().getDevice(did):null;
    if(dev!=null)
    {
        name=dev.getData().getString("name");
    }
    
%><!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title><%=name%></title>
        <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>
        
        <link rel="apple-touch-startup-image" href="/photo"> 
        <link rel="apple-touch-icon" href="/photo">   
        <meta name="apple-mobile-web-app-capable" content="yes">
        <meta name="apple-mobile-web-app-status-bar-style" content="black">
        
        <!-- Bootstrap 3.3.4 -->
        <link href="/static/admin/bower_components/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet" type="text/css" />    
        <link href="/static/admin/bower_components/datatables.net-bs/css/dataTables.bootstrap.min.css" rel="stylesheet" type="text/css" />

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
        <!-- iCheck -->
        <link href="/static/admin/plugins/iCheck/flat/blue.css" rel="stylesheet" type="text/css" />
        <!-- Morris chart -->
        <!--        
                <link href="/static/plugins/morris/morris.css" rel="stylesheet" type="text/css" />
        -->
        <!-- jvectormap -->
        <link href="/static/admin/plugins/jvectormap/jquery-jvectormap-1.2.2.css" rel="stylesheet" type="text/css" />
        <!-- Date Picker -->
        <link href="/static/admin/bower_components/bootstrap-datepicker/dist/css/bootstrap-datepicker.min.css" rel="stylesheet" type="text/css" />
        <!-- Daterange picker -->
        <link href="/static/admin/bower_components/bootstrap-daterangepicker/daterangepicker.css" rel="stylesheet" type="text/css" />
        <!-- bootstrap wysihtml5 - text editor -->
        <link href="/static/admin/plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.min.css" rel="stylesheet" type="text/css" />

        <link href="/static/plugins/bootstrap-switch/bootstrap-switch.min.css" rel="stylesheet" type="text/css" />

        <!-- FileInputPlugin -->
        <link href="/css/fileinput.min.css" media="all" rel="stylesheet" type="text/css" />

        <style type="text/css">

            @media (min-width: 768px) {
                .main-header .sidebar-toggle {
                    display: none;
                }
                .main_alert
                {
                    padding-left: 250px
                }
                
                .dl-horizontal dd{
                    text-align: left;
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

            .dash-content{
                padding: 10px;
            }            

            .dash-graph{
                background-color: #ffffff;
                padding: 5px;
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
            
            .infoHead{
                font-weight: bold;
                font-size: 18px;
            }
            
            .infoConnected{
                font-size: 15px;   
                color:green;
            }
<%if(!"ALL".equals(view)){%>            
            .content-wrapper,.main-footer {
                margin-left:0
            }            
<%}%>            
        </style>  

        <script type="text/javascript">
            var onload_data = [];
            var addOnLoad = function (funct) {
                onload_data.push(funct);
            }
            var vars_data={};
        </script>          

    </head>
    <body class="skin-blue sidebar-mini">
        <div class="wrapper">

            <header class="main-header">
                <!-- Logo -->
                <a href="#" class="logo">
                    <img src="/img/cloudino.svg" width="170">
                </a>
                <!-- Header Navbar: style can be found in header.less -->
                <nav class="navbar navbar-static-top" role="navigation">
                    <!-- Sidebar toggle button-->
<%if("ALL".equals(view)){%>
                    <a href="#" class="sidebar-toggle" data-toggle="push-menu" role="button">
                      <span class="sr-only">Toggle navigation</span>
                    </a>
<%}%>                    
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
                                <a href="#">
                                    <img src="/photo" class="user-image" alt="User Image"/>
                                    <span class="hidden-xs"><%=user.getString("fullname")%></span>
                                </a>
                            </li>
                        </ul>
                    </div>
                </nav>
            </header>    
<%if("ALL".equals(view)){%>
            <aside class="main-sidebar">
                <!-- sidebar: style can be found in sidebar.less -->
                <section class="sidebar">
                    <!-- sidebar menu: : style can be found in sidebar.less -->
                    <ul class="sidebar-menu tree" data-widget="tree">
                        <li class="header">Menu</li>
                        <li class="treeview menu-open">
                            <a href="#">
                                <i class="fa fa-gears"></i>
                                <span>Devices</span>
                                <i class="fa fa-angle-left pull-right"></i>
                            </a>
                            <ul class="treeview-menu devices tree" style="display: block;">
<%
    DeviceMgr mgr=DeviceMgr.getInstance();
    SWBDataSource ds = engine.getDataSource("Device");
    DataObject query = new DataObject();
    query.addSubList("sortBy").add("name");
    DataObject data = new DataObject();
    query.put("data", data);
    data.put("user", user.getId());
    DataObject ret = ds.fetch(query);
    
    TreeSet set=new TreeSet();
    SWBDataSource dsc = engine.getDataSource("Control");
    query = new DataObject();
    query.addSubList("sortBy").add("order");
    query.addSubObject("data").addParam("user", user.getId());
    DataObjectIterator rit = dsc.find(query);
    while (rit.hasNext()) {
        DataObject ele = rit.next();
        set.add(ele.getString("device"));
        //System.out.println("ele:"+ele);
    }
    
    DataList<DataObject> devices = ret.getDataObject("response").getDataList("data");
    if (devices != null) {
        for (DataObject _dev : devices) {
            String _id = _dev.getNumId();
            if(!set.contains(_id))continue;
            
            if (mgr.isDeviceConnected(_id)) {
                out.print("<small class=\"label pull-right bg-green\" style=\"margin-top: 7px;\">online</small>");
            }
            out.print("<li dev=\""+_id+"\"><a href=\"dashboard?view=ALL&ID=" + _id + "\" class=\"cdino_text_menu\"><i class=\"fa fa-circle-o\"></i><span>" + _dev.getString("name") + "</span>");
            out.println("</a></li>");
        }
    }
    
%>                                
                            </ul>                                
                        </li>
                    </ul>
                </section>
                <!-- /.sidebar -->
            </aside>     
<%}%>                            

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
<%
    if (dev!=null) 
    {
        out.print("<small>"+name+"</small>");
        if(dev.isConnected()) {
            out.print("<small style=\"margin-top: 5px; color: green; font-weight: bold;\">(online)</small>");
        }
    }
%>                        
                    </h1>
<!--                    
                    <ol class="breadcrumb">
                        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
                        <li class="active">Dashboard</li>
                    </ol>
-->
                </section>

                <!-- Main content -->
                <section class="content">                      
<%
    if("ALL".equals(view) && did==null)
    {
%>                    
                    <!--script type="text/javascript">WS.notify=[];</script-->
                    <div>
                        <div class="row">
                            <div class="col-md-12">         

                            </div>
                        </div>    
                    </div>
<%
    }else{
%>                    
                    <!--script type="text/javascript">WS.notify=[];</script-->
                    <div>
                        <div class="row">
                            <div class="col-md-12">         
                                
                                <script type="text/javascript">        
                                    addOnLoad(function () {
                                        var url="";
                                        var proto=window.location.protocol;        
                                        if(proto=="https:")url+='wss://';
                                        else url+='ws://';
                                        url+=window.location.host+ '/websocket/cdino?ID=<%=dev.getId()%>&time='+new Date().getTime();
                                        WS.disconnect();
                                        WS.connect(url);
                                    });
                                </script> 
                                <script type="text/javascript">
                                    addOnLoad(function () {
                                        loadContent('dashDeviceControls?ID=<%=dev.getId()%>&time='+new Date().getTime(),'#deviceControls');
                                    });
                                </script>
                                <div id="deviceControls"></div>
                            </div>
                        </div>    
                    </div>
<%
    }
%>                    
                </section><!-- /.content -->
            </div><!-- /.content-wrapper -->
            <footer class="main-footer">
                <div class="pull-right hidden-xs">
                    <b>Version</b> 0.1
                </div>
                <strong>Copyright &copy; 2015-2020 <a href="http://cloudino.io">Cloudino</a>.</strong> All rights reserved.
            </footer>

            <!-- Add the sidebar's background. This div must be placed
                 immediately after the control sidebar --
            <div class='control-sidebar-bg'></div>-->
        </div><!-- ./wrapper -->

        <!-- jQuery 2.1.4 -->
        <script src="/static/admin/bower_components/jquery/dist/jquery.min.js"></script>
        <script src="/js/fileinput.min.js"></script>

        <!-- Bootstrap 3.3.2 JS -->
        <script src="/static/admin/bower_components/bootstrap/dist/js/bootstrap.min.js" type="text/javascript"></script>  
        <!-- Sparkline -->
        <script src="/static/admin/bower_components/jquery-sparkline/dist/jquery.sparkline.min.js" type="text/javascript"></script>
        <!-- jQuery Knob Chart -->
        <script src="/static/admin/bower_components/jquery-knob/dist/jquery.knob.min.js" type="text/javascript"></script>

        <!-- AdminLTE App -->
        <script src="/static/admin/dist/js/adminlte.min.js" type="text/javascript"></script>    

        <script src="/static/plugins/validator/validator.min.js" type="text/javascript"></script>
        <script src="/static/plugins/bootstrap-switch/bootstrap-switch.min.js" type="text/javascript"></script>  
        <script src="/static/plugins/fontawesome-iconpicker-1.3.1/js/fontawesome-iconpicker.min.js" type="text/javascript"></script>  

        <script src="/static/admin/bower_components/moment/min/moment.min.js"></script>        
        <script src="/static/admin/bower_components/chart.js/Chart.min.js"></script>        

        <script type="text/javascript" src="/js/websockets.js"></script> 

        <script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDS11cq98QRzhvPbDC-Fsdwd68vIfne5vg"></script>

        <script src="/js/cloudino_utils.js"></script>

        <script type="text/javascript">
                $(document).ready(function () {
                    for (var funct in onload_data) {
                        onload_data[funct]();
                    }
                });
        </script>                     
    </body>
</html>