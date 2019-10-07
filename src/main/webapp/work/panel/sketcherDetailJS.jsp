<%-- 
    Document   : sketcherDetail
    Created on : 11/08/2015, 12:00:44 PM
    Author     : juan.fernandez
--%><%@page import="org.apache.commons.io.FileUtils"%>
<%@page import="io.cloudino.utils.ParamsMgr"%><%@page import="io.cloudino.compiler.*"%><%@page import="java.net.URLEncoder"%><%@page import="java.util.*"%><%@page import="java.io.*"%><%@page import="io.cloudino.engine.*"%><%@page import="org.semanticwb.datamanager.*"%><%@page contentType="text/html" pageEncoding="UTF-8"%><%
    ParamsMgr params = new ParamsMgr(request.getSession());

    String k = request.getParameter("k");

    String name = params.getDataValue(k, "fn");
    String act = params.getDataValue(k, "act");
    String _rm = request.getParameter("_rm");

    String skt = params.getDataValue(k, "skt");
    // Para guardar archivo
    //String upload = request.getParameter("up");
    String upload = params.getDataValue(k, "up");
    // Para compilar archivo editado
    //String compile = request.getParameter("cp");
    String compile = params.getDataValue(k, "cp");
    //String devtype = request.getParameter("dev");
    String devtype = params.getDataValue(k, "dev");

    if (null == act) {
        act = request.getParameter("act");
        if (null != act && "rename".equals(act)) {
            skt = request.getParameter("skt");
            _rm = request.getParameter("_rm");
            name = request.getParameter("fn");

        } else if (null != act && "compile".equals(act)) {
            compile = request.getParameter("cp");
            skt = request.getParameter("skt");
            name = request.getParameter("fn");
            devtype = request.getParameter("dev");
        } else if (null != act && "edit".equals(act)) {
            skt = request.getParameter("skt");
            name=skt + ".js";            
            act = "";
            _rm = "true";
        } 
    }

    String newname = request.getParameter("name");

    //System.out.println("A C T I O N : "+act+" ==============================================================================");
    ///////////////////////////////////////////
    String appPath = config.getServletContext().getRealPath("/");
    String dir = appPath + "/work";
    DataObject user = (DataObject) session.getAttribute("_USER_");
    SWBScriptEngine engine = DataMgr.getUserScriptEngine("/cloudino.js", user);
    String userBasePath = dir + engine.getScriptObject().get("config").getString("usersWorkPath") + "/" + user.getNumId() + "/cloudinojs";
    String sktPath = userBasePath + "/sketchers/" + skt + "/";
    String buildPath = userBasePath + "/build/";
    String msg = null;
    
    if ("remove".equals(act) && name==null) 
    {
        File file = new File(sktPath);      
        FileUtils.deleteDirectory(file);
        //System.out.println("remove:"+skt+"->"+file+"->"+act);   
%>
<!-- Custom Tabs -->
<div class="nav-tabs-custom">
    <div class="tab-content">
        <div class="tab-pane active" id="tab_1">
            <h3>Sketch was delete successfully...</h3>
        </div><!-- /.tab-pane -->
    </div>    
</div>
<%        
        out.println("<script type=\"text/javascript\">loadContent('/panel/cloudinojs?act=sket','#cloudinojs');</script>");
        return;
    }else if ("remove".equals(act) && name!=null) 
    {
        File file = new File(sktPath+name);      
        file.delete();
        //System.out.println("remove:"+skt+"->"+file+"->"+act);   
%>
<!-- Custom Tabs -->
<div class="nav-tabs-custom">
    <div class="tab-content">
        <div class="tab-pane active" id="tab_1">
            <h3>File was delete successfully...</h3>
        </div><!-- /.tab-pane -->
    </div>    
</div>
<%        
        out.println("<script type=\"text/javascript\">loadContent('/panel/cloudinojs?act=sket','#cloudinojs');</script>");
        return;
    }else if (name != null && null != act && "rename".equals(act) && null != newname) 
    {
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

    if (compile != null) {
        upload = compile;
    }

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

        out.println("File saved.");
        if (compile == null) {
            return;
        }
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
                retmsg = com.compile(path, type, build, userBasePath);
            } catch (Exception e) {
                retmsg = "Error:" + e.getMessage();
                e.printStackTrace(response.getWriter());
            }
        } catch (Exception e) {
            retmsg = "Error:" + e.getMessage();
            e.printStackTrace(response.getWriter());
        }
        out.print(retmsg);

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

    if (_rm != null) {
        out.println("<script type=\"text/javascript\">loadContent('/panel/cloudinojs?act=sket','#cloudinojs');</script>");
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
        <small><%=skt%></small>
    </h1>
    <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Panel</a></li>
        <li><a href="#">CloudinoJS</a></li>
        <li><a href="#">Sketchers</a></li>
        <li class="active"><%=skt%></li>
    </ol>
</section>
<%
    if (null == act || null != act && act.equals("")) {
%>
<!-- Main content -->
<section class="content">
    <div class="row">
        <div class="col-md-12" id="main_content">

            <div class="box box-primary">
                <div class="box-header">
                    <h3 class="box-title"><%=name%></h3>
                </div>
                <%
                    if (code != null) {
                %>
                <textarea name="code" id="code"><%=code%></textarea> 
                <div class="form-group has-feedback">
                    <div class="col-sm-12 pull-left" style="padding: 5px">
                        <input type="button" value="Save Sketch" onclick="document.getElementById('consoleLog').innerHTML = 'Saving File...\n\r';
                                getAsynchData('sketcherDetailJS?k=<%=params.setDataValues("up", (filename != null ? URLEncoder.encode(filename) : ""), "skt", skt, "fn", filename)%>', myCodeMirror.getValue(), 'POST', function(data) {
                                    document.getElementById('consoleLog').innerHTML = data;
                                });" class="btn btn-primary">
                        <%
                            String skt_mainFile = skt + ".js";
                            if (false)//filename.equals(skt_mainFile)) 
                            {
                        %>
                        <input type="button" value="Compile Sketch" onclick="document.getElementById('consoleLog').innerHTML = 'Compiling...\n\r';
                                getAsynchData('sketcherDetailJS?act=compile&cp=<%=filename != null ? URLEncoder.encode(filename) : ""%>&dev=' + document.getElementById('type').value + '&skt=<%=skt%>&fn=<%=filename%>', myCodeMirror.getValue(), 'POST', function(data) {
                                    document.getElementById('consoleLog').innerHTML = data;
                                });" class="btn btn-primary" >

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
                                    <form data-target=".content-wrapper" data-submit="ajax" action="sketcherDetailJS" role="form" >
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
<%
                            }
                            if (filename.equals(skt_mainFile)) 
                            {
%>
                        <button class="btn btn-danger" onclick="return removeBlock(this);">Delete Sketch</button>
                            <script type="text/javascript">
                                function removeBlock(alink) {
                                    if (confirm('Are you sure to remove this Sketch?')) {
                                        var urlRemove = 'sketcherDetailJS?k=<%=params.setDataValues("skt",skt,"act","remove")%>';
                                        loadContent(urlRemove, "#main_content");
                                    }
                                    return false;
                                }
                            </script>
<%
                            }else
                            {
%>
                            <button class="btn btn-danger" onclick="return removeBlock(this);">Delete File</button>
                            <script type="text/javascript">
                                function removeBlock(alink) {
                                    if (confirm('Are you sure to remove this File?')) {
                                        var urlRemove = 'sketcherDetailJS?k=<%=params.setDataValues("skt",skt,"act","remove","fn",filename)%>';
                                        loadContent(urlRemove, "#main_content");
                                    }
                                    return false;
                                }
                            </script>
<%                                
                            }
%>
                    </div>
                    <br/>
                </div>   
                <hr/>
                <div class_="form-group has-feedback">
                    <label>Console</label>
                    <div class="callout callout-info">
                        <div id="consoleLog"></div>
                    </div>
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
                        extraKeys: {"Ctrl-Space": "autocomplete", "Ctrl-Q": "toggleComment", "Ctrl-J": "toMatchingTag", "F11": function(cm) {
                                cm.setOption("fullScreen", !cm.getOption("fullScreen"));
                            },
                            "Esc": function(cm) {
                                if (cm.getOption("fullScreen"))
                                    cm.setOption("fullScreen", false);
                            }},
                        matchTags: {bothTags: true},
                    <%if (lint) {%>
                        gutters: ["CodeMirror-lint-markers"],
                        lint: true,
                    <%}%>
                    });
                    myCodeMirror.setSize("100%", 400);
                </script>      
                <%
                    }
                %>
            </div>
        </div>

    </div>   <!-- /.row -->
</section><!-- /.content -->
<%
} else if (null != act && act.equals("showImage")) {

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
                            if (null != name && (name.endsWith(".png") || name.endsWith(".jpg") || name.endsWith(".gif"))) {

                        %>
                        <img src="<%="/panel/image?k=" + k%>"/>
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
