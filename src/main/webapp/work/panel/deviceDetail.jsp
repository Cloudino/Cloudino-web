<%-- 
    Document   : deviceDetail
    Created on : 04-ago-2015, 0:03:07
    Author     : javiersolis
--%><%@page contentType="text/html" pageEncoding="UTF-8"%><%@page import="java.net.URLEncoder"%><%@page import="java.io.*"%><%@page import="io.cloudino.compiler.*"%><%@page import="java.util.*"%><%@page import="io.cloudino.engine.*"%><%@page import="org.semanticwb.datamanager.*"%><%
    DataObject user = (DataObject) session.getAttribute("_USER_");
    SWBScriptEngine engine = DataMgr.getUserScriptEngine("/cloudino.js", user);
    SWBDataSource ds = engine.getDataSource("Device");

    String id = request.getParameter("ID");

    Device device = DeviceMgr.getInstance().getDeviceIfPresent(id);
    DataObject data = null;

    if (device != null) {
        data = device.getData();
    } else {
        data = ds.fetchObjByNumId(id);
    }
//    System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
//    System.out.println("id:" + id);
//    System.out.println("device:" + device);
//    System.out.println("data:" + data);
    //Security
    if (data == null || (data != null && !data.getString("user").equals(user.getId()))) {
        response.sendError(404);
        return;
    }

    //Update
    String name = request.getParameter("name");
    if (name != null) {
        String description = request.getParameter("description");
        String type = request.getParameter("type");
        data.put("name", name);
        data.put("description", description);
        data.put("type", type);
        DataObject ret = ds.updateObj(data);
        //System.out.println(ret);
        DataObject obj = ret.getDataObject("response").getDataObject("data");
        if (obj != null) {
            response.sendRedirect("deviceDetail?ID=" + obj.getNumId()+"&_rm=true");
            return;
        } else {
            out.println("Error updating object...");
            return;
        }
        
    }

    name = data.getString("name", "");
    String description = data.getString("description", "");
    String type = data.getString("type");
    String token = data.getString("authToken","");

    boolean isConnected = false;
    long connectedTime = 0;
    long createdTime = 0;
    if (device != null) {
        isConnected = device.isConnected();
        connectedTime = device.getConnectedTime();
        createdTime = device.getCreatedTime();
    }

    // COMPILAR ARCHIVO EDITADO
    String appPath = config.getServletContext().getRealPath("/");
    String dir = appPath + "/work";
    String skt = request.getParameter("skt");
    //String sktPath = dir + engine.getScriptObject().get("config").getString("usersWorkPath") + "/" + user.getNumId() + "/sketchers/" + skt + "/";

    // leer estructura de archivos del usuario
    String userPath = dir + engine.getScriptObject().get("config").getString("usersWorkPath") + "/" + user.getNumId();
    String userBasePath = userPath + "/sketchers";
    String userBuildPath = userPath + "/build";
    File f = new File(userBasePath);
    if (!f.exists()) {
        f.mkdirs();
    }
    String msg = "";
    String compile = request.getParameter("cp");

    if ( compile != null && null != skt) { 

        if(null!=data) data.put("sketcher", skt);
        String sktFile = skt + ".ino";
        String path=userBasePath + "/" + skt + "/" + sktFile;

        try {
            try {
                msg = "";
                
                ArdCompiler com = ArdCompiler.getInstance();
                msg=com.compile(path, type, userBuildPath, userPath);
                msg=msg.replace("\n", "<br>\n");

                File fino = new File(path);
                String fname = fino.getName().split("\\.")[0];
                String compiled = userBuildPath + "/" + fname + ".cpp.hex";

                if (device !=null && device.isConnected()) {
                    CharArrayWriter pout=new CharArrayWriter();
                    if(device.sendHex(new FileInputStream(compiled), pout))
                    {
                        msg = msg + "Device programmed successfully.";
                    }
                } else {
                    msg = msg + "Device offline, could not be programmed."; 
                }

            } catch (Exception e) {
                e.printStackTrace();
                msg = "Error:" + e.getMessage();
                out.print(msg);
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();

            msg = "Error:" + e.getMessage();
            out.print(msg);
            return;
        }
        out.print(msg);
        return;
    }

            /////////////////////////////////////////////////////////////
    
    String sketcherDefault = null; 
    if(null!=data){
        sketcherDefault = data.getString("sketcher", null);
    }
    
    if(request.getParameter("_rm")!=null)
    {
        out.println("<script type=\"text/javascript\">loadContent('/panel/menu?act=dev','.main-sidebar');</script>");
    }    
%>

<section class="content-header">
    <h1>Device<small> <%=name%></small></h1>
    <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Panel</a></li>
        <li><a href="#">Devices</a></li>
        <li class="active"><%=name%></li>
    </ol>
</section>

<section class="content">
    <!-- START CUSTOM TABS -->
    <div class="row">
        <div class="col-md-12">
            <!-- Custom Tabs -->
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <li class="active"><a href="#tab_1" data-toggle="tab" aria-expanded="true">General</a></li>
                    <li class=""><a href="#tab_2" data-toggle="tab" aria-expanded="false">Code</a></li>
                    <li class=""><a href="#tab_3" data-toggle="tab" aria-expanded="false">Messages</a></li>
                    <li class=""><a href="#tab_4" data-toggle="tab" aria-expanded="false">Console</a></li>
                    <li class=""><a href="#tab_5" data-toggle="tab" aria-expanded="false">Controls</a></li>
             <!--               
                    <li class="dropdown">
                        <a class="dropdown-toggle" data-toggle="dropdown" href="#" aria-expanded="false">
                            Actions <span class="caret"></span>
                        </a>
                        <ul class="dropdown-menu">
                            <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Delete</a></li>
                            <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Another action</a></li>
                            <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Something else here</a></li>
                            <li role="presentation" class="divider"></li>
                            <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Separated link</a></li>
                        </ul>
                    </li>
             -->
                    <li class="pull-right"><a class="dropdown-toggle" data-toggle="dropdown" href="#" aria-expanded="false"><i class="fa fa-gear"></i></a>
                        <ul class="dropdown-menu">
                            <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Delete</a></li>
                        </ul>
                    </li>
                </ul>
                <div class="tab-content">
                    <div class="tab-pane active" id="tab_1">

                        <form data-target=".content-wrapper" data-submit="ajax" action="deviceDetail" role="form">
                            <div class="box-body">

                                <div class="form-group has-feedback">
                                    <label>Id</label>
                                    <div><%=id%></div>
                                    <input type="hidden" name="ID" value="<%=id%>">
                                </div>  
                                
                                <div class="form-group has-feedback">
                                    <label>Authentication Token</label>
                                    <div><%=token%></div>
                                </div>                                

                                <!-- text input -->
                                <div class="form-group has-feedback">
                                    <label>Name</label>
                                    <input name="name" value="<%=name%>" type="text" class="form-control" placeholder="Enter ..." required="true">
                                </div>

                                <!-- textarea -->
                                <div class="form-group has-feedback">
                                    <label>Description</label>
                                    <textarea name="description" class="form-control" rows="3" placeholder="Enter ..."><%=description%></textarea>
                                </div>

                                <!-- select -->
                                <div class="form-group has-feedback">
                                    <label>Type</label>
                                    <select name="type" class="form-control">
                                        <option value="cloudino-standalone">Cloudino Connector Standalone</option>
                                        <%
                                            ArdCompiler cmp = ArdCompiler.getInstance();
                                            Iterator<ArdDevice> it = cmp.listDevices();
                                            while (it.hasNext()) {
                                                io.cloudino.compiler.ArdDevice dev = it.next();
                                                out.println("<option value=\"" + dev.key + "\" " + (dev.key.equals(type) ? "selected" : "") + ">" + dev.toString() + "</option>");
                                            }
                                        %>    
                                    </select>
                                </div> 

                                <div class="form-group has-feedback">
                                    <label>Created Time</label>
                                    <div><%=new Date(createdTime)%></div>
                                </div>     

                                <div class="form-group has-feedback">
                                    <label>Connected Time</label>
                                    <div><%=new Date(connectedTime)%></div>
                                </div>                                   

                            </div><!-- /.box-body -->

                            <div class="box-footer">
                                <button type="submit" class="btn btn-primary disabled">Submit</button>
                            </div>
                        </form>                        

                    </div><!-- /.tab-pane -->
                    <div class="tab-pane" id="tab_2">
                        <%


                        %>
                        <form data-target=".content-wrapper" data-submit="ajax" action="deviceDetail" role="form">
                            <input type="hidden" name="ID" value="<%=id%>">
                            <input type="hidden" name="cp" value="compile">
                            <div class="box-body">
                                <!-- select -->
                                <div class="form-group has-feedback">
                                    <div class="col-md-1 pull-left">
                                    <label>Sketcher</label>
                                    </div>
                                    <div class="col-md-10 pull-left">
                                    <select name="skt" id="skt" class="form-control">                                        
                                        <%
                                            File[] listFiles = f.listFiles();
                                            for (File file : listFiles) {
                                                if (file.isDirectory() && !file.isHidden()) {
                                                    String dirName = file.getName();
                                                    if(dirName.indexOf("_")>-1){
                                                        dirName = dirName.substring(0,dirName.indexOf("_"));
                                                    }
                                                    //System.out.println(dirName);
                                                    File[] list = file.listFiles();
                                                    for(File inoFile:list){
                                                        String fileName = inoFile.getName();
                                                        //System.out.println("Revisando..."+dirName+" con: "+fileName);
                                                        if(fileName.startsWith(dirName)&&fileName.endsWith(".ino")){
                                                            out.println("<option value=\"" + fileName + "|"+file.getName()+"\" "+(sketcherDefault!=null&&sketcherDefault.equals(file.getName())?"selected":"")+" >" + file.getName() + "</option>");
                                                        }
                                                    }
                                                }
                                            }
                                        %>    
                                    </select>
                                    </div>
                                    <div class="col-md-1 pull-left">
                                    <a class="btn btn-primary" data-target=".content-wrapper" data-load="ajax" onclick="editSketcher(this);" >Edit</a>
                                    <script type="text/javascript">
                                        function editSketcher(alink){
                                            var sketcher = document.getElementById('skt');
                                            var valSket = sketcher[sketcher.selectedIndex].value;
                                            //alert(valSket);
                                            var urlEdit = 'sketcherDetail?act=edit&fn=' + valSket + '&skt=' + valSket ;
                                            alink.href=urlEdit;
                                            alink.click();
                                        }
                                        
                                    </script>
                                    </div>
                                </div> 

                                <div class="form-group has-feedback">
                                    <div class="col-md-12 pull-left">
                                    <label>Console</label>
                                    <!--
                                    <div><textarea name="consoleLog" id="consoleLog" class="col-md-12" rows="10"></textarea></div>
                                    -->
                                    <div class="callout callout-info">
                                        <div id="ws_cmp"></div>
                                    </div>
                                    </div>
                                </div>     



                            </div><!-- /.box-body -->

                            <div class="box-footer">
                                <input type="button" value="Send" onclick="WS.log('Compiling...','ws_cmp'); getAsynchData('deviceDetail?cp=compile&dev=<%=type%>&skt=' + document.getElementById('skt').value + '&ID=<%=id%>', 'myCodeMirror.getValue()', 'POST',function(data){WS.log(data,'ws_cmp');});" class="btn btn-primary" >
                            </div>
                        </form> 
                    </div><!-- /.tab-pane -->
                    <div class="tab-pane" id="tab_3">
    <script type="text/javascript">
        var url='ws://' + window.location.host+ '/websocket/cdino?ID=<%=id%>';
        WS.disconnect();
        WS.connect(url);
    </script>                        
                        
    <div id="connect-container">
        <div>
            <button class="btn btn-primary btn-flat" id="connect" onclick="WS.connect(url);">Connect</button>
            <button class="btn btn-primary btn-flat" id="disconnect" disabled="disabled" onclick="WS.disconnect();">Disconnect</button>
        </div>
        <div>
            Topic:<br/>
            <input id="topic" type="text" style="width: 350px"/>
        </div>
        <div>
            Message:<br/>
            <textarea id="message" style="width: 350px">Here is a message!</textarea>
        </div>
        <div>
            <button class="btn btn-primary btn-flat" id="send" onclick="WS.send();" disabled="disabled">Send</button>
        </div>
    </div>
    <br/>    
    <div class="callout callout-info">
        <div id="ws_msg"></div>
    </div>
                    </div><!-- /.tab-pane -->
                    <div class="tab-pane" id="tab_4">
    <div class="callout callout-info">
        <div id="ws_log"/>
    </div>
                    </div><!-- /.tab-pane -->
                    <div class="tab-pane" id="tab_5">
                        <jsp:include page="controls.jsp" />
<!--                        <div>
                            <button class="btn btn-primary btn-flat" onclick="WS.post('sir','true')" >Alarm ON</button>
                            <button class="btn btn-primary btn-flat" onclick="WS.post('sir','false')" >Alarm OFF</button>
                            <button class="btn btn-primary btn-flat" onclick="WS.post('mov','true')" >Move On</button>
                            <button class="btn btn-primary btn-flat" onclick="WS.post('mov','false')" >Move Off</button> 
                        </div>-->
                    </div><!-- /.tab-pane -->
                </div><!-- /.tab-content -->
            </div><!-- nav-tabs-custom -->
        </div><!-- /.col -->


    </div> <!-- /.row -->
    <!-- END CUSTOM TABS -->
</section>

<%!
    byte[] readInputStream(InputStream in) throws IOException {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        byte[] buffer = new byte[1024];
        int length = 0;
        while ((length = in.read(buffer)) != -1) {
            baos.write(buffer, 0, length);
        }
        return baos.toByteArray();
    }

    void getFiles(File file, String path, ArrayList<String> files) {
        if (file.isDirectory()) {
            File fd[] = file.listFiles();
            for (int x = 0; x < fd.length; x++) {
                if (path.length() > 0) {
                    path = path + "/";
                }
                getFiles(fd[x], path + fd[x].getName(), files);
            }
        } else {
            files.add(path);
        }
    }
%>