<%-- 
    Document   : sketcherDetail
    Created on : 11/08/2015, 12:00:44 PM
    Author     : juan.fernandez
--%>
<%@page import="io.cloudino.compiler.*"%><%@page import="java.net.URLEncoder"%><%@page import="java.util.*"%><%@page import="java.io.*"%><%@page import="io.cloudino.engine.*"%><%@page import="org.semanticwb.datamanager.*"%><%@page contentType="text/html" pageEncoding="UTF-8"%><%
    String name = request.getParameter("fn");
    String newname = request.getParameter("name");
    String act = request.getParameter("act");
    String skt = request.getParameter("skt");
    String appPath = config.getServletContext().getRealPath("/");
    String dir = appPath + "/work";
    DataObject user = (DataObject) session.getAttribute("_USER_");
    SWBScriptEngine engine = DataMgr.getUserScriptEngine("/cloudino.js", user);
    String sktPath = dir + engine.getScriptObject().get("config").getString("usersWorkPath") + "/" + user.getId() + "/sketchers/" + skt + "/";
    String buildPath = dir + engine.getScriptObject().get("config").getString("usersWorkPath") + "/" + user.getId() + "/build/";
    String msg = null;
    if (name != null && null != act && "rename".equals(act) && null != newname) {
        File oldfile = new File(sktPath + name);

        File newfile = new File(sktPath + newname);

        boolean hasError = Boolean.FALSE;
        System.out.println(sktPath + name);
        System.out.println(sktPath + newname);
        if (!oldfile.exists()) {
            msg = "Error. No existe el archivo \"" + name + "\"";
            hasError = Boolean.TRUE;
        } else {
            oldfile.setWritable(true);
        }
        if (newfile.exists() && !hasError) {
            msg = "Error. Ya existe un archivo \"" + newname + "\"";
            hasError = Boolean.TRUE;
        }

        if (!hasError) {
            boolean success = oldfile.renameTo(newfile);
            System.out.println(oldfile.getName());
            if (!success) {
                msg = "Error intentando cambiar el nombre del archivo \"" + name + "\".";
            } else {
                msg = "Se cambio el nombre del archivo.";
                name = newname;
            }
        }
    }
    if (name == null) {
        name = "";
    }

%><%
            //String dir = config.getServletContext().getRealPath("/") + "/" + request.getRequestURI().substring(1, request.getRequestURI().lastIndexOf("/")) + "/";
            System.out.println("dir:" + sktPath);

            String upload = request.getParameter("up");
            if (upload != null) {
                System.out.println("up:" + upload);
                byte code[] = readInputStream(request.getInputStream());

                try {
                    FileOutputStream os = new FileOutputStream(sktPath + upload);
                    os.write(code);
                    os.flush();
                    os.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }

                out.print("OK\n\rArchivo guardado.");
                return;
            }
            
            // COMPILAR ARCHIVO EDITADO

            String compile = request.getParameter("cp"); 
            //String dev = request.getParameter("dev"); 
            String devtype = request.getParameter("dev"); 
            //Device device=DeviceMgr.getInstance().getDevice(dev);
            //if(device!=null && compile!=null)
            if(devtype != null && compile!=null)
            {
                System.out.println("cp:"+compile);
                byte code[]=readInputStream(request.getInputStream());
                try {
                    try
                    {
                        //String type=device.getData().getString("type");
                        String type=devtype;
                        //System.out.println("device.getData():"+device.getData());
                        String build=buildPath; //"/Users/javiersolis/Documents/Arduino/build";
                        String path=sktPath+compile;
                        
                        ArdCompiler com=ArdCompiler.getInstance();
                        com.compileCode(new String(code,"utf8"),path,type,build);
        
                        File fino=new File(path);
                        String fname=fino.getName().split("\\.")[0];
                        String compiled=build+"/"+fname+".cpp.hex";
                        
//                        if(device.isConnected())
//                        {
//                            device.sendHex(new FileInputStream(compiled), out);
//                        }
                        
                    }catch(Exception e)
                    {
                        e.printStackTrace();
                        out.print("Error:"+e.getMessage());
                        return;
                    }            
                } catch (Exception e) {
                    e.printStackTrace();
                    out.print("Error:"+e.getMessage());
                    return;
                }        
                out.print("OK\n\rArchivo Compilado.");
                return;
            }   
            
            /////////////////////////////////////////////////////////////
            
            String filename = name; //request.getParameter("fn");
            //System.out.println("fn:" + filename);

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

                    //code=ITZFormsUtils.readInputStream(in,"utf-8");
                    code = code.replace("<", "&lt;").replace(">", "&gt;");
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            //if(code==null)code="";
            //if(filename==null)filename="";
        %>

<script type="text/javascript">
    <%if (null != msg) {%>
    alert('<%=msg%>');
    <%}%>
</script>
<!-- Content Header (Page header) -->
<section class="content-header">
    <h1>
        Sketcher
        <small><%=skt%></small>
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

            <div class="box box-primary">
                <div class="box-header">
                    <h3 class="box-title">General Data</h3>
                </div><!-- /.box-header -->
                <!-- form start -->
                <form data-target=".content-wrapper" data-submit="ajax" action="sketcherDetail" role="form">
                    <div class="box-body">
                        <input type="hidden" name="skt" value="<%=skt%>"/>
                        <input type="hidden" name="fn" value="<%=name%>"/>
                        <input type="hidden" name="act" value="rename"/>
                        <!-- text input -->
                        <div class="form-group has-feedback">
                            <label>Name</label>
                            <input name="name" value="<%=name%>" type="text" class="form-control" placeholder="Enter ..." required>
                        </div>

                    </div><!-- /.box-body -->

                    <div class="box-footer">
                        <button type="submit" class="btn btn-primary">Rename</button>
                    </div>
                </form>
            </div>

        </div>
        <!--
                <div class="col-md-4 callout callout-danger lead">
                    <h4>Tip!</h4>
                    <p>
                        If you go through the example pages and would like to copy a component, right-click on
                        the component and choose "inspect element" to get to the HTML quicker than scanning
                        the HTML page.
                    </p>
                </div>
        -->


        

        <!--
                <style type="text/css">
                    .CodeMirror {border: 1px solid black; font-size:13px}
                </style>   
        -->
    </div>
    <div class="row">
        <div class="col-md-12">

            <div class="box box-primary">
                <div class="box-header">
                    <h3 class="box-title">Code Editor</h3>
                </div>

                <form action="" method="post" style="float: left;">   
                    &nbsp;&nbsp;&nbsp;&nbsp;Archivo:&nbsp;&nbsp;<label>   <%=filename%>   </label>&nbsp;&nbsp;&nbsp;
                    <input type="hidden" id="fn" name="fn" value="<%=filename%>">
                    <input type="hidden" name="skt" value="<%=skt%>"/>
                </form>

                <%
                    if (code != null) {
                %>
                <input type="button" value="Guardar" onclick="document.getElementById('consoleLog').value='Guardando Archivo...\n\r';r = getSynchData('?up=<%=filename != null ? URLEncoder.encode(filename) : ""%>&skt=<%=skt%>&fn=<%=filename%>', myCodeMirror.getValue(), 'POST');
                    console.log(r);
                    document.getElementById('consoleLog').value='Guardando Archivo...\n\r'+r.response;
                    //if (r.response === 'OK')
                    //    alert('Archivo Gradado');
                    //else
                    //    alert('Error al guardar archivo')" class="btn btn-primary">&nbsp;&nbsp;&nbsp;
                
                                <div class="form-group has-feedback">
                                    <label>Arduino</label>
                                    <select name="type" id="type" class="form-control">
                                        <option value="cloudino-standalone">Cloudino Connector Standalone</option>
                                        <%
                                        //+ (dev.key.equals(type) ? "selected" : "")
                                            ArdCompiler cmp = ArdCompiler.getInstance();
                                            Iterator<ArdDevice> it = cmp.listDevices();
                                            while (it.hasNext()) {
                                                io.cloudino.compiler.ArdDevice dev = it.next();
                                                out.println("<option value=\"" + dev.key + "\" "  + ">" + dev.toString() + "</option>");
                                            }
                                        %>    
                                    </select>
                                </div> 
                <input type="button" value="Compilar" onclick="document.getElementById('consoleLog').value='Compilando...\n\r';r = getSynchData('?cp=<%=filename != null ? URLEncoder.encode(filename) : ""%>&dev='+document.getElementById('type').value+'&skt=<%=skt%>&fn=<%=filename%>', myCodeMirror.getValue(), 'POST');
                    console.log(r);
                    document.getElementById('consoleLog').value='Compilando...\n\r'+r.response;
                    //if (r.response === 'OK'){
                    //    alert('Archivo Compilado');
                    //}
                    //else
                    //    alert(r.response)" class="btn btn-primary" ><br/><br/>
                <textarea name="code" id="code"><%=code%></textarea>   
                
                <div class="form-group has-feedback">
                                    <label>Console</label>
                                    <div><textarea id="consoleLog" name="consoleLog" class="col-md-12" rows="10"></textarea></div>
                                </div>  
                
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
                            aRequest.open(method, "sketcherDetail" + url, false);
                            aRequest.send();
                        } else
                        {
                            if (!method)
                                method = "POST";
                            aRequest.open(method, "sketcherDetail" + url, false);
                            aRequest.send(data);
                        }
                        return aRequest;
                    };

                    var myCodeMirror = CodeMirror.fromTextArea(code, {
                        //mode: "application/x-jsp",
                        mode: "<%=mode%>",
                        smartIndent: true,
                        lineNumbers: true,
                        styleActiveLine: true,
                        matchBrackets: true,
                        autoCloseBrackets: true,
                        theme: "eclipse",
                        continueComments: "Enter",
                        extraKeys: {"Ctrl-Space": "autocomplete", "Ctrl-Q": "toggleComment", "Ctrl-J": "toMatchingTag"},
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

//    void getFiles(File file, String path, ArrayList<String> files)
//    {
//        if(file.isDirectory())
//        {
//            File fd[]=file.listFiles();
//            for(int x=0;x<fd.length;x++)
//            {
//                if(path.length()>0)path=path+"/";
//                getFiles(fd[x], path+fd[x].getName(), files);
//            }
//        }else
//        {
//            files.add(path);
//        }
//    }
%>