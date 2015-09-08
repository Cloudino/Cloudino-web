<%-- 
    Document   : exampleDetail
    Created on : 11/08/2015, 12:00:44 PM
    Author     : juan.fernandez
--%><%@page import="io.cloudino.compiler.*"%><%@page import="java.net.URLEncoder"%><%@page import="java.util.*"%><%@page import="java.io.*"%><%@page import="io.cloudino.engine.*"%><%@page import="org.semanticwb.datamanager.*"%><%@page contentType="text/html" pageEncoding="UTF-8"%><%
    String name = request.getParameter("fp");
    String newname = request.getParameter("name");
    String act = request.getParameter("act");
    String skt = request.getParameter("skt");
    // Para guardar archivo
    String upload = request.getParameter("up");
    // Para compilar archivo editado
    String compile = request.getParameter("cp");
    
    String dev_type = request.getParameter("dev");
    
    String devtype = null;
    String deviceID = null;
    
    if(null!=dev_type){
        devtype = dev_type.substring(0,dev_type.indexOf("|"));
        deviceID = dev_type.substring(dev_type.indexOf("|")+1);
    }
    
    ///////////////////////////////////////////

    String appPath = config.getServletContext().getRealPath("/");
    String dir = appPath + "/work";
    DataObject user = (DataObject) session.getAttribute("_USER_");
    SWBScriptEngine engine = DataMgr.getUserScriptEngine("/cloudino.js", user);
    String userBasePath = dir + engine.getScriptObject().get("config").getString("usersWorkPath") + "/" + user.getNumId();
    String sktPath = userBasePath + "/sketchers/" + skt + "/";
    String arduinoPath = engine.getScriptObject().get("config").getString("arduinoPath"+"/");
    String buildPath = userBasePath + "/build/";
    Device device = null;
    if(null!=deviceID){
        device = DeviceMgr.getInstance().getDeviceIfPresent(deviceID);
        //devtype = device.getData().getString("type", "uno");
        
    }
    boolean isConnected = false;
    long connectedTime = 0;
    long createdTime = 0;
    if (device != null) {
        isConnected = device.isConnected();
        connectedTime = device.getConnectedTime();
        createdTime = device.getCreatedTime();
    }
    
    String msg = null;
    if (name != null && null != act && "rename".equals(act) && null != newname) {
        File oldfile = new File(sktPath + name);
        File newfile = new File(sktPath + newname);
        boolean hasError = Boolean.FALSE;
        if (!oldfile.exists()) {
            msg = "Error. No such file \"" + name + "\"";
            hasError = Boolean.TRUE;
        } else {
            oldfile.setWritable(true);
        }
        if (newfile.exists() && !hasError) {
            msg = "Error. File already exists \"" + newname + "\"";
            hasError = Boolean.TRUE;
        }

        if (!hasError) {
            boolean success = oldfile.renameTo(newfile);
            //System.out.println(oldfile.getName());
            if (!success) {
                msg = "Error trying to change the file name \"" + name + "\".";
            } else {
                msg = "File name was changed successfully.";
                name = newname;
            }
        }
    }
    if (name == null) {
        name = "";
    }
    
    if(compile!=null)upload=compile;

    // COMPILAR ARCHIVO EDITADO
    if (devtype != null && compile != null) {
        String retmsg = "OK\n\rFile compiled.";
        //byte code[] = readInputStream(request.getInputStream());
        
        try {
            try {
                String type = devtype;
                String build = buildPath; //"/Users/javiersolis/Documents/Arduino/build";
                String path = sktPath + compile;
                ArdCompiler com = ArdCompiler.getInstance();
                
                retmsg=com.compile(path, type, build, userBasePath);
                retmsg=msg.replace("\n", "<br>\n");

                File fino = new File(path);
                String fname = fino.getName().split("\\.")[0];
                String compiled = build + "/" + fname + ".cpp.hex";
        
                if (device !=null && device.isConnected()) {
                    CharArrayWriter pout=new CharArrayWriter();
                    if(device.sendHex(new FileInputStream(compiled), pout))
                    {
                        retmsg = retmsg + "Device programmed successfully.";
                    }
                } else {
                    retmsg = retmsg + "Device offline, could not be programmed."; 
                }
                
            } catch (Exception e) {
                retmsg = retmsg +"Error:" + e.getMessage();
                e.printStackTrace(response.getWriter());
            }
        } catch (Exception e) {
            retmsg = retmsg +"Error:" + e.getMessage();
            e.printStackTrace(response.getWriter());
        }
        out.print(retmsg);
        
        return;
    }

    /////////////////////////////////////////////////////////////
    String filename = name; //request.getParameter("fn");
    System.out.println("=============================================================");
    System.out.println(name);
    boolean lint = false;
    String mode = "text/html";
    if (filename != null) {
        if (filename.endsWith(".js")) {
            mode = "text/javascript";
            lint = true;
        } else if (filename.endsWith(".json")) {
            mode = "application/json";
            lint = true;
        } else if (filename.endsWith(".html")) {
            mode = "text/html";
        } else if (filename.endsWith(".jsp")) {
            mode = "application/x-jsp";
        } else if (filename.endsWith(".css")) {
            mode = "text/css";
            lint = true;
        } else if (filename.endsWith(".xml")) {
            mode = "text/xml";
        } else if (filename.endsWith(".rdf")) {
            mode = "text/xml";
        } else if (filename.endsWith(".owl")) {
            mode = "text/xml";
        } else if (filename.endsWith(".c")) {
            mode = "text/x-csrc";
        } else if (filename.endsWith(".h")) {
            mode = "text/x-csrc";
        } else if (filename.endsWith(".cpp")) {
            mode = "text/x-c++src";
        } else if (filename.endsWith(".hpp")) {
            mode = "text/x-c++src";
        } else if (filename.endsWith(".ino")) {
            mode = "text/x-c++src";
        } else if (filename.endsWith(".java")) {
            mode = "text/x-java";
        }
    }

    String path = null;
    if (filename != null) {
        //path = sktPath + filename;
        path=filename;
    }

    String code = "";

    if (path != null) {
        try {
            FileInputStream in = new FileInputStream(path);
            code = new String(readInputStream(in), "utf-8");
            code = code.replace("<", "&lt;").replace(">", "&gt;");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    if(request.getParameter("_rm")!=null)
    {
        out.println("<script type=\"text/javascript\">loadContent('/panel/menu?act=sket','.main-sidebar');</script>");
    }      
%>

<script type="text/javascript">
    <%if (null != msg) {%>
    alert('<%=msg%>');
    $('body').removeClass('modal-open');

    $('.modal-backdrop').remove();
    <%}%>

</script>
<!-- Content Header (Page header) -->
<section class="content-header">
    <h1>
        Sketcher
        <small>Code Editor</small>
    </h1>
    <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li><a href="#">Forms</a></li>
        <li class="active">General Elements</li>
    </ol>
</section>

<!-- Main content -->
<section class="content">
    <div class="row">
        <div class="col-md-12">

            <%
            String onlyName = null;
            if(name.lastIndexOf("\\")!=-1){
                onlyName = name.substring(name.lastIndexOf("\\")+1);
            } else if(name.lastIndexOf("/")!=-1){
                onlyName = name.substring(name.lastIndexOf("/")+1);
            }
            
            %>
            
            <div class="box box-primary">
                <div class="box-header">
                    <h3 class="box-title"><%=skt%> - <%=onlyName%></h3>
                </div>
                <%

        String defaultBoard = "uno";
        if (code != null) {

                %>
                <div class="form-group has-feedback">
                    <div class="col-md-1"><label>&nbsp;&nbsp;Devices</label></div>                    
                    <div class="col-md-6 pull-left">
                        <%
                        SWBDataSource ds = engine.getDataSource("Device");
                        DataObject query = new DataObject();
                        DataObject data = new DataObject();
                        query.put("data", data);
                        data.put("user", user.getId());
                        DataObject ret = ds.fetch(query);
                        DataList<DataObject> devices = ret.getDataObject("response").getDataList("data");
                        if (devices != null) {
                            %>
                            <select name="type" id="type" class="form-control">
                            <!-- option value="cloudino-standalone">Cloudino Connector Standalone</option -->
                            <%
                            for (DataObject dev : devices) {
                                String id = dev.getNumId();
                                String boardType = dev.getString("type", null);
                                if(null!=boardType){
                                    out.println("<option value=\"" +boardType+"|"+id + "\" >" + dev.getString("name") + "</option>");
                                }
                            }
                            %>
                            </select>
                            <%
                        } else {
                            %>    
                        <label>No devices found.</label>
                        <%
                        }
                        %>
                    </div><div class="col-md-3 pull-left">
                
                <%
                    String skt_mainFile = skt + ".ino";
                    if (onlyName.equals(skt_mainFile)) {
                %>
                <input type="button" value="Compile" onclick="document.getElementById('consoleLog').value = 'Compiling...\n\r';getAsynchData('exampleDetail?cp=<%=filename != null ? URLEncoder.encode(filename) : ""%>&dev=' + document.getElementById('type').value + '&skt=<%=skt%>&fn=<%=filename%>', myCodeMirror.getValue(), 'POST',function(data){document.getElementById('consoleLog').value = data;});" class="btn btn-primary" >
                <input type="button" value="Clone to Sketchers" onclick="document.getElementById('consoleLog').value = 'Saving File...\n\r';getAsynchData('sketcherDetail?up=<%=filename != null ? URLEncoder.encode(filename) : ""%>&skt=<%=skt%>&fn=<%=filename%>', myCodeMirror.getValue(), 'POST',function(data){document.getElementById('consoleLog').value = data;});" class="btn btn-primary">
                <%
                    }
                %>
                
                    </div>
                    <br/>
                </div> 
                <textarea name="code" id="code"><%=code%></textarea>   
                <div class="form-group has-feedback">
                    <label>Console</label>
                    <div><textarea id="consoleLog" name="consoleLog" class="col-md-12" rows="10"></textarea></div>
                </div>  
                <script type="text/javascript">

                    var myCodeMirror = CodeMirror.fromTextArea(code, {
                        //mode: "application/x-jsp",
                        mode: "<%=mode%>",
                        smartIndent: true,
                        lineNumbers: true,
                        styleActiveLine: true,
                        matchBrackets: true,
                        autoCloseBrackets: true,
                        completeSingle: true,
                        theme: "eclipse",
                        continueComments: "Enter",
                        extraKeys: {"Ctrl-Space": "autocomplete", "Ctrl-Q": "toggleComment", "Ctrl-J": "toMatchingTag", "F11": function (cm) {
                                cm.setOption("fullScreen", !cm.getOption("fullScreen"));
                            },
                            "Esc": function (cm) {
                                if (cm.getOption("fullScreen"))
                                    cm.setOption("fullScreen", false);
                            }},
                        matchTags: {bothTags: true},
                    <%if (lint) {%>
                        gutters: ["CodeMirror-lint-markers"],
                        lint: true,
                    <%}%>
                    });
                    myCodeMirror.setSize("100%", 500);
                    //# set readOnly mode
                    myCodeMirror.setOption("readOnly", true);
                </script>      
                <%
                    }
                %>
            </div>
        </div>

    </div>   <!-- /.row -->
</section><!-- /.content -->

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
%>
