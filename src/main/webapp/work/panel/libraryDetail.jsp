<%-- 
    Document   : exampleDetail
    Created on : 11/08/2015, 12:00:44 PM
    Author     : juan.fernandez
--%><%@page import="io.cloudino.utils.ParamsMgr"%><%@page import="java.nio.file.Files"%><%@page import="java.nio.file.StandardCopyOption.*"%><%@page import="io.cloudino.compiler.*"%><%@page import="java.net.URLEncoder"%><%@page import="java.util.*"%><%@page import="java.io.*"%><%@page import="io.cloudino.engine.*"%><%@page import="org.semanticwb.datamanager.*"%><%@page contentType="text/html" pageEncoding="UTF-8"%><%
    ParamsMgr params=new ParamsMgr(request.getSession());
    
    String k = request.getParameter("k");
    
    String name = params.getDataValue(k, "fp");
    String act = params.getDataValue(k, "act");
    
    
    System.out.println(name+"->"+act);
            
    if(null==act){
        act="";
    }
    
    String skt = params.getDataValue(k, "skt");
    
    ///////////////////////////////////////////

    String appPath = config.getServletContext().getRealPath("/");
    String dir = appPath + "/work";
    DataObject user = (DataObject) session.getAttribute("_USER_");
    SWBScriptEngine engine = DataMgr.getUserScriptEngine("/cloudino.js", user);
    
    if (name == null) {
        name = "";
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
            System.out.println(path);
        }
    }
    
    if(request.getParameter("_rm")!=null)
    {
        out.println("<script type=\"text/javascript\">loadContent('/panel/menu?act=lib','.main-sidebar');</script>");
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
            String onlyName = "";
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
                <textarea name="code" id="code"><%=code%></textarea>   
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
