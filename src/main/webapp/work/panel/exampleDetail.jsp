<%-- 
    Document   : exampleDetail
    Created on : 11/08/2015, 12:00:44 PM
    Author     : juan.fernandez
--%><%@page import="io.cloudino.utils.ParamsMgr"%><%@page import="java.nio.file.Files"%><%@page import="java.nio.file.StandardCopyOption.*"%><%@page import="io.cloudino.compiler.*"%><%@page import="java.net.URLEncoder"%><%@page import="java.util.*"%><%@page import="java.io.*"%><%@page import="io.cloudino.engine.*"%><%@page import="org.semanticwb.datamanager.*"%><%@page contentType="text/html" pageEncoding="UTF-8"%><%
    ParamsMgr params=new ParamsMgr(request.getSession());
    
    String k = request.getParameter("k");
    
    String name = params.getDataValue(k, "fp");
    String act = params.getDataValue(k, "act");
    
    if(null==act){
        act="";
    }
    
    String skt = params.getDataValue(k, "skt");
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
                retmsg=retmsg.replace("\n", "<br>\n");

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
    
    String clone = request.getParameter("clone");
    if(null!=clone){

        //Revisar que no exista un Sketcher con el mismo nombre
        File fskt = new File(sktPath);
        
        if(fskt.exists()){
            //buscar nombre con un skt_[num] diferente
            String rootSkts = userBasePath + "/sketchers/"+skt;
            boolean busca = true;
            int i=0;
            while(busca){
                i++;
                fskt = new File(rootSkts+"_"+i+"/");
                if(!fskt.exists()){
                    fskt.mkdirs();
                    busca=false;
                }
            }
        } else {
           fskt.mkdirs(); 
        }
        
        String toDir = fskt.getPath();
        String srcDir = null;
        if(clone.indexOf("\\")>-1){
            srcDir = clone.substring(0, clone.lastIndexOf("\\"));
        } else if(clone.indexOf("/")>-1){
            srcDir = clone.substring(0, clone.lastIndexOf("/"));
        }
        
//        System.out.println("Source DIR: "+srcDir);
//        System.out.println("Target DIR: "+fskt.getPath());
        File srcpath = new File(srcDir);
        
        File[] flist = srcpath.listFiles();
        for(File f:flist){
            File tof = new File(toDir+"/"+f.getName());          
            Files.copy(f.toPath(),tof.toPath(),java.nio.file.StandardCopyOption.REPLACE_EXISTING);
        }
        response.sendRedirect("sketcherDetail?fn=" + skt + ".ino&skt=" + skt+"&_rm=true");
        return;
    }

    /////////////////////////////////////////////////////////////
    String filename = name; //request.getParameter("fn");
//    System.out.println("=============================================================");
//    System.out.println(name);
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

<!-- Content Header (Page header) -->
<section class="content-header">
    <h1>
        Examples
        <small></small>
    </h1>
    <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li><a href="#">Forms</a></li>
        <li class="active">General Elements</li>
    </ol>
</section>
<%
    if("".equals(act)){
%>
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
                <input type="button" value="Send" onclick="document.getElementById('consoleLog').value = 'Compiling...\n\r';getAsynchData('exampleDetail?cp=<%=filename != null ? URLEncoder.encode(filename) : ""%>&dev=' + document.getElementById('type').value + '&skt=<%=skt%>&fn=<%=filename%>', myCodeMirror.getValue(), 'POST',function(data){document.getElementById('consoleLog').value = data;});" class="btn btn-primary" >
                <a class="btn btn-primary" data-target=".content-wrapper" data-load="ajax" href="exampleDetail?clone=<%=filename != null ? URLEncoder.encode(filename) : ""%>&skt=<%=skt%>&fn=<%=filename%>'">Clone to Sketchers</a>
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

<%
} else if("showImage".equals(act)) {  
    
    // elimina los archivos temporales que se muestran de las imágenes de los ejemplos
    File tmpfolder = new File(dir+"/tmp/");
    if(tmpfolder.exists()){
        if(tmpfolder.isDirectory()){
            File[] files = tmpfolder.listFiles();
            for(File f:files){
                f.delete();
            }
        }
    }

%>
<!-- Main content -->
<section class="content">
    <div class="row">
        <div class="col-md-12">

            <%
    
            String onlyName = null;
            if (name.lastIndexOf("\\") != -1) {
                onlyName = name.substring(name.lastIndexOf("\\") + 1);
            } else if (name.lastIndexOf("/") != -1) {
                onlyName = name.substring(name.lastIndexOf("/") + 1);
            }
            %>

            <div class="box box-primary">
                <div class="box-header">
                    <h3 class="box-title"><%=skt%> - <%=onlyName%></h3>
                </div>
                    <div class="form-group has-feedback"></div>
                        <div _class="col-md-12 pull-left">
<%
    if(null!=onlyName&&(onlyName.endsWith(".png")||onlyName.endsWith(".jpg")||onlyName.endsWith(".gif"))){
%>
<img src="<%="/panel/image?k="+k%>"/>
<%
    }
%>
                        </div> 
            </div>
        </div>
    </div>   <!-- /.row -->
</section><!-- /.content -->
<%
    }
%>


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
