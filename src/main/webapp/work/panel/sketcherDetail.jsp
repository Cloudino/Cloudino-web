<%-- 
    Document   : sketcherDetail
    Created on : 11/08/2015, 12:00:44 PM
    Author     : juan.fernandez
--%><%@page import="io.cloudino.utils.ParamsMgr"%><%@page import="io.cloudino.compiler.*"%><%@page import="java.net.URLEncoder"%><%@page import="java.util.*"%><%@page import="java.io.*"%><%@page import="io.cloudino.engine.*"%><%@page import="org.semanticwb.datamanager.*"%><%@page contentType="text/html" pageEncoding="UTF-8"%><%
    ParamsMgr params=new ParamsMgr(request.getSession());
    
    String k = request.getParameter("k");
    
    String name = params.getDataValue(k, "fn");
    String act = params.getDataValue(k, "act");
    String _rm = params.getDataValue(k,"_rm");

    String skt = params.getDataValue(k,"skt");
    // Para guardar archivo
    //String upload = request.getParameter("up");
    String upload = params.getDataValue(k,"up");
    // Para compilar archivo editado
    //String compile = request.getParameter("cp");
    String compile = params.getDataValue(k,"cp");
    //String devtype = request.getParameter("dev");
    String devtype = params.getDataValue(k,"dev");
    
    if(null==act){
        act = request.getParameter("act");
        if(null!=act&&"rename".equals(act)){
            skt = request.getParameter("skt");
            _rm = request.getParameter("_rm");
            name= request.getParameter("fn");
            
        } else if(null!=act&&"compile".equals(act)){
            compile = request.getParameter("cp");
            skt = request.getParameter("skt");
            name = request.getParameter("fn");
            devtype = request.getParameter("dev");
        } else if(null!=act&&"edit".equals(act)){
            skt = request.getParameter("skt");
            name = skt.substring(0,skt.lastIndexOf("|"));
            skt = skt.substring(skt.lastIndexOf("|")+1);
        } else if(null!=act&&"edit".equals(act)){
            skt = request.getParameter("skt");
            name = skt.substring(0,skt.lastIndexOf("|"));
            skt = skt.substring(skt.lastIndexOf("|")+1);
        }
    }
    
    String newname = request.getParameter("name");

    
    System.out.println("A C T I O N : "+act+" ==============================================================================");
    ///////////////////////////////////////////

    String appPath = config.getServletContext().getRealPath("/");
    String dir = appPath + "/work";
    DataObject user = (DataObject) session.getAttribute("_USER_");
    SWBScriptEngine engine = DataMgr.getUserScriptEngine("/cloudino.js", user);
    String userBasePath = dir + engine.getScriptObject().get("config").getString("usersWorkPath") + "/" + user.getNumId();
    String sktPath = userBasePath + "/sketchers/" + skt + "/";
    String buildPath = userBasePath + "/build/";
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

    if (upload != null) {
        //System.out.println("up:" + upload);
        byte code[] = readInputStream(request.getInputStream());

        try {
            FileOutputStream os = new FileOutputStream(sktPath + upload);
            os.write(code);
            os.flush();
            os.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        Properties properties = new Properties();
        OutputStream outstream = null;
        try {
            File conff = new File(sktPath + "/config.properties");
            if (!conff.exists()) {
                conff.createNewFile();
                conff.setWritable(true);
            } else {
                System.out.print("si existe");
            }
            outstream = new FileOutputStream(sktPath + "/config.properties");
            properties.setProperty("compile", devtype);
            properties.store(outstream, "Default Sketcher board type");
        } catch (IOException e) {
            e.printStackTrace();
            out.println(e.getMessage());
        } finally {
            if (outstream != null) {
                try {
                    outstream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                    out.println(e.getMessage());
                }
            }

        }

        out.println("File saved.");
        if(compile == null)
            return;
    }

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
                retmsg=com.compile(path, type, build,userBasePath);
            } catch (Exception e) {
                retmsg = "Error:" + e.getMessage();
                e.printStackTrace(response.getWriter());
            }
        } catch (Exception e) {
            retmsg = "Error:" + e.getMessage();
            e.printStackTrace(response.getWriter());
        }
        out.print(retmsg);
        
        
        Properties properties = new Properties();
        OutputStream outstream = null;
        try {
            File conff = new File(sktPath + "/config.properties");
            if (!conff.exists()) {
                conff.createNewFile();
                conff.setWritable(true);
            } 
            outstream = new FileOutputStream(sktPath + "/config.properties");
            properties.setProperty("compile", devtype);
            properties.store(outstream, "Default Sketcher board type");
        } catch (IOException e) {
            e.printStackTrace();
            out.println(e.getMessage());
        } finally {
            if (outstream != null) {
                try {
                    outstream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                    out.println(e.getMessage());
                }
            }
        }
        return;
    }

    /////////////////////////////////////////////////////////////
    String filename = name; //request.getParameter("fn");
    
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
        path = sktPath + filename;
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
    
    if(_rm!=null)
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
<%
    if(null!=act&&act.equals("")){
%>
<!-- Main content -->
<section class="content">
    <div class="row">
        <div class="col-md-12">

            <div class="box box-primary">
                <div class="box-header">
                    <h3 class="box-title"><%=skt%> - <%=name%></h3>
                </div>
                <%

        String defaultBoard = "uno";

        Properties properties = new Properties();
        InputStream inputstream = null;
        try {
            File conff = new File(sktPath + "/config.properties");
            if (!conff.exists()) {
                conff.createNewFile();
                conff.setWritable(true);
            } 

            inputstream = new FileInputStream(sktPath + "/config.properties");
            properties.load(inputstream);
            defaultBoard = properties.getProperty("compile", "uno");

        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (inputstream != null) {
                try {
                    inputstream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        if (code != null) {
                %>
                <div class="form-group has-feedback">
                    <div class="col-md-1"><label>&nbsp;&nbsp;Board</label></div>                    
                    <div class="col-md-6 pull-left">
                        <select name="type" id="type" class="form-control">
                            <option value="cloudino-standalone">Cloudino Connector Standalone</option>
                            <%
                                ArdCompiler cmp = ArdCompiler.getInstance();
                                Iterator<ArdDevice> it = cmp.listDevices();
                                while (it.hasNext()) {
                                    io.cloudino.compiler.ArdDevice dev = it.next();
                                    out.println("<option value=\"" + dev.key + "\" " + (defaultBoard.equals(dev.key) ? "selected" : "") + " >" + dev.toString() + "</option>");
                                }
                            %>    
                        </select>
                    </div><div class="col-md-3 pull-left">
                        <input type="button" value="Save" onclick="document.getElementById('consoleLog').value = 'Saving File...\n\r';getAsynchData('sketcherDetail?k=<%=params.setDataValues("up",(filename != null ? URLEncoder.encode(filename) : ""),"skt",skt,"fn",filename)%>', myCodeMirror.getValue(), 'POST',function(data){document.getElementById('consoleLog').value = data;});" class="btn btn-primary">
                <%
                    String skt_mainFile = skt + ".ino";
                    if (filename.equals(skt_mainFile)) {
                %>
                <input type="button" value="Compile" onclick="document.getElementById('consoleLog').value = 'Compiling...\n\r';getAsynchData('sketcherDetail?act=compile&cp=<%=filename != null ? URLEncoder.encode(filename) : ""%>&dev=' + document.getElementById('type').value + '&skt=<%=skt%>&fn=<%=filename%>', myCodeMirror.getValue(), 'POST',function(data){document.getElementById('consoleLog').value = data;});" class="btn btn-primary" >
                
                <%
                    }
                    if (null != skt && null != name && !name.equals(skt_mainFile)) {
                %>
                        <button type="submit" class="btn btn-primary" data-toggle="modal" data-target="#ModalForm">Rename</button>

                        <!-- Modal -->
                        <div class="modal fade" id="ModalForm" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header no-border">
                                        <button id="buttonClose" type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                                        <h4 class="modal-title" id="myModalLabel"><i class="fa fa-edit"></i> Rename File</h4>
                                    </div>
                                    <form data-target=".content-wrapper" data-submit="ajax" action="sketcherDetail" role="form" >
                                        <div class="modal-body no-padding">


                                            <input type="hidden" name="skt" value="<%=skt%>"/>
                                            <input type="hidden" name="fn" value="<%=name%>"/>
                                            <input type="hidden" name="act" value="rename"/>
                                            <input type="hidden" name="_rm" value="true"/>
                                            <!-- text input -->
                                            <div class="form-group">
                                                <label>   Name</label>
                                                <input name="name" value="<%=name%>" type="text" class="form-control" placeholder="Enter ..." required>
                                            </div>

                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-warning pull-left" data-dismiss="modal">Cancel</button>
                                            <button type="submit" class="btn btn-success btn-primary" onsubmit="$('#ModalForm').modal('hide');">Rename</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                        <%}%>
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
                </script>      
                <%
                    }
                %>
            </div>
        </div>

    </div>   <!-- /.row -->
</section><!-- /.content -->
<%
    } else if(null!=act&&act.equals("showImage")){

%>
<!-- Main content -->
<section class="content">
    <div class="row">
        <div class="col-md-12">

            <div class="box box-primary">
                <div class="box-header">
                    <h3 class="box-title"><%=skt%> - <%=name%></h3>
                </div>
                <div class="form-group has-feedback">
                    <div _class="col-md-12">
                        <%
    if(null!=name&&(name.endsWith(".png")||name.endsWith(".jpg")||name.endsWith(".gif"))){
        
%>
<img src="<%="/panel/image?k="+k%>"/>
<%
    }
%>
                        </div> 
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
