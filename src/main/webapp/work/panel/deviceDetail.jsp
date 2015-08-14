<%-- 
    Document   : deviceDetail
    Created on : 04-ago-2015, 0:03:07
    Author     : javiersolis
--%><%@page import="java.net.URLEncoder"%>
<%@page import="java.io.*"%><%@page import="io.cloudino.compiler.*"%><%@page import="java.util.*"%><%@page import="io.cloudino.engine.*"%><%@page import="org.semanticwb.datamanager.*"%><%
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
            response.sendRedirect("deviceDetail?ID=" + obj.getNumId());
            return;
        } else {
            out.println("Error updating object...");
            return;
        }
    }

    name = data.getString("name", "");
    String description = data.getString("description", "");
    String type = data.getString("type");

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
    String sktPath = dir + engine.getScriptObject().get("config").getString("usersWorkPath") + "/" + user.getId() + "/sketchers/" + skt + "/";

    // leer estructura de archivos del usuario
    String userBasePath = dir + engine.getScriptObject().get("config").getString("usersWorkPath") + "/" + user.getId() + "/sketchers";
    String userBuildPath = dir + engine.getScriptObject().get("config").getString("usersWorkPath") + "/" + user.getId() + "/build";
    File f = new File(userBasePath);
    if (!f.exists()) {
        f.mkdirs();
    }
    String msg = "";
    String compile = request.getParameter("cp");

    if ( compile != null && null != skt) { //device != null &&

        String sktFile = skt + ".ino";
        File fin = new File(userBasePath + "/" + skt + "/" + sktFile);
        FileInputStream in = new FileInputStream(fin);
        byte code[] = readInputStream(in);
        try {
            try {
                //String type=device.getData().getString("type");
                //System.out.println("device.getData():" + device.getData());
                String build = userBuildPath;//"/Users/javiersolis/Documents/Arduino/build";
                String path = sktPath + sktFile;

                ArdCompiler com = ArdCompiler.getInstance();
                com.compileCode(new String(code, "utf8"), path, type, build);

                msg = "Ok\n\rArchivo compilado\n\r";
                
                File fino = new File(path);
                String fname = fino.getName().split("\\.")[0];
                String compiled = build + "/" + fname + ".cpp.hex";

                if (device !=null && device.isConnected()) {
                    device.sendHex(new FileInputStream(compiled), out);
                    msg = msg + "Device programmed successfully.";
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
%>

<section class="content-header">
    <h1>Device<small>Name</small></h1>
    <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li><a href="#">Forms</a></li>
        <li class="active">General Elements</li>
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
                    <li class="dropdown">
                        <a class="dropdown-toggle" data-toggle="dropdown" href="#" aria-expanded="false">
                            Dropdown <span class="caret"></span>
                        </a>
                        <ul class="dropdown-menu">
                            <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Action</a></li>
                            <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Another action</a></li>
                            <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Something else here</a></li>
                            <li role="presentation" class="divider"></li>
                            <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Separated link</a></li>
                        </ul>
                    </li>
                    <li class="pull-right"><a href="#" class="text-muted"><i class="fa fa-gear"></i></a></li>
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
                                    <label>Sketcher</label>
                                    <select name="skt" id="skt" class="form-control">                                        
                                        <%
                                            File[] listFiles = f.listFiles();
                                            for (File file : listFiles) {
                                                if (file.isDirectory() && !file.isHidden()) {
                                                    out.println("<option value=\"" + file.getName() + "\" >" + file.getName() + "</option>");
                                                }
                                            }
                                        %>    
                                    </select>
                                </div> 

                                <div class="form-group has-feedback">
                                    <label>Console</label>
                                    <div><textarea name="consoleLog" id="consoleLog" class="col-md-12" rows="10"></textarea></div>
                                </div>     


                            </div><!-- /.box-body -->

                            <div class="box-footer">
                                <input type="button" value="Compilar" onclick="document.getElementById('consoleLog').value = 'Compilando...\n\r';
                                        r = getSynchData('?cp=compile&dev=<%=type%>&skt=' + document.getElementById('skt').value + '&ID=<%=id%>', ' myCodeMirror.getValue()', 'POST');
                                        console.log(r);
                                        document.getElementById('consoleLog').value = 'Compilando...\n\r' + r.response;
                                        //if (r.response === 'OK'){
                                        //    alert('Archivo Compilado');
                                        //}
                                        //else
                                        //    alert(r.response)" class="btn btn-primary" >

                            </div>
                        </form> 
                        <script type="text/javascript">

                            var getSynchData = function (url, data, method)
                            {

                                //alert(url + '\n\r' + data + '\n\r' + method);
                                if (typeof XMLHttpRequest === "undefined")
                                {
                                    XMLHttpRequest = function () {
                                        try {
                                            return new ActiveXObject("Msxml2.XMLHTTP.6.0");
                                        }
                                        catch (e) {
                                        }
                                        try {
                                            return new ActiveXObject("Msxml2.XMLHTTP.3.0");
                                        }
                                        catch (e) {
                                        }
                                        try {
                                            return new ActiveXObject("Microsoft.XMLHTTP");
                                        }
                                        catch (e) {
                                        }
                                        // Microsoft.XMLHTTP points to Msxml2.XMLHTTP and is redundant
                                        throw new Error("This browser does not support XMLHttpRequest.");
                                    };
                                }

                                var aRequest = new XMLHttpRequest();
                                if (!data)
                                {
                                    if (!method)
                                        method = "GET";
                                    aRequest.open(method, "deviceDetail" + url, false);
                                    aRequest.send();
                                } else
                                {
                                    //alert('post>>>>>>>>>>>>> ' + url);
                                    if (!method)
                                        method = "POST";
                                    aRequest.open(method, "deviceDetail" + url, false);
                                    aRequest.send(data);
                                }
                                return aRequest;
                            };


                        </script>   
                    </div><!-- /.tab-pane -->
                    <div class="tab-pane" id="tab_3">
                        Lorem Ipsum is simply dummy text of the printing and typesetting industry.
                        Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,
                        when an unknown printer took a galley of type and scrambled it to make a type specimen book.
                        It has survived not only five centuries, but also the leap into electronic typesetting,
                        remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset
                        sheets containing Lorem Ipsum passages, and more recently with desktop publishing software
                        like Aldus PageMaker including versions of Lorem Ipsum.
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