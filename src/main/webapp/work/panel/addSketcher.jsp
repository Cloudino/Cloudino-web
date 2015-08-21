<%-- 
    Document   : addSketcher
    Created on : 11/08/2015, 11:59:05 AM
    Author     : juan.fernandez
--%>
<%@page import="java.util.Properties"%>
<%@page import="io.cloudino.compiler.ArdCompiler"%>
<%@page import="io.cloudino.engine.*"%>
<%@page import="java.util.ArrayList"%><%@page import="java.util.Iterator"%><%@page import="java.io.*"%><%@page import="java.net.URLEncoder"%><%@page contentType="text/html" pageEncoding="UTF-8"%><%@page import="org.semanticwb.datamanager.*"%>
<%
    String name=request.getParameter("name");
    String sktname=request.getParameter("skt");
    String act = request.getParameter("act");
    
    boolean isNewFile = Boolean.FALSE;
    if(null!=act&&"newfile".equals(act)){
        isNewFile = Boolean.TRUE;
    }

    if(name!=null) 
    {
        //if(null==sktname) sktname=name;
        // Generar carpeta dentro del FileSystem del usuario
        
        DataObject user=(DataObject)session.getAttribute("_USER_");
        SWBScriptEngine engine=DataMgr.getUserScriptEngine("/cloudino.js",user);
        
        String dir = config.getServletContext().getRealPath("/") + "/work/"  ;
        String msg =null;          
        String userBasePath = dir+engine.getScriptObject().get("config").getString("usersWorkPath")+"/"+user.getId(); 
        File newf = null;
        if(sktname==null){
            //TODO: validar nombre del programa sin espacios
            name = name.replaceAll(" ","_");
            File f = new File(userBasePath+"/sketchers/"+name);
            if(!f.exists()){
                f.mkdirs();
                File flibraries = new File(userBasePath+"/libraries");
                File fbuild = new File(userBasePath+"/build");
                if(!flibraries.exists()){
                    flibraries.mkdirs();
                }
                if(!fbuild.exists()){
                    fbuild.mkdirs();
                }
            } else {
                // error ya existe el Sketcher
                msg = "Existe un Sketcher con el mismo nombre";
                return;
            }
            newf = new File(userBasePath+"/sketchers/"+name+"/"+name+".ino");
            if(!newf.exists()){
                newf.createNewFile();
                newf.setWritable(true);                
            }
            
            File configf = new File(userBasePath+"/sketchers/"+name+"/config.properties");
            if(!configf.exists()){
                configf.createNewFile();
                configf.setWritable(true);    
            }          

        } else {
            newf = new File(userBasePath+"/sketchers/"+sktname+"/"+name);
            if(!newf.exists()){
                newf.createNewFile();
                newf.setWritable(true);                
            } else {
                msg="Existe un Archivo con el mismo nombre.";
                return;
            }
        }
        
        if(newf!=null)
        {
            if(null==sktname)sktname=name;
            response.sendRedirect("sketcherDetail?fn="+newf.getName()+"&skt="+sktname);
            
            return;
        }
    }
    if(name==null)name="";
    
%>
<!-- Content Header (Page header) -->
<section class="content-header">
    <h1>
        <%
    String formName = "Add Sketcher";
        if(null!=sktname&&isNewFile){
            formName="New file";
        }
        
        %>
        <%=formName%>
        <small>Step 1</small>
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
        <div class="col-md-8">

            <div class="box box-primary">
                <div class="box-header">
                    <h3 class="box-title">General Data</h3>
                </div><!-- /.box-header -->
                <!-- form start -->
                <form data-target=".content-wrapper" data-submit="ajax" action="addSketcher" role="form">
                    <div class="box-body">
                        <%
                        if(isNewFile){
                            %>
                            <input type="hidden" name="act" value="addFile"/>
                            <input type="hidden" name="skt" value="<%=sktname%>"/>
                            
                            <%
                        }
                        %>
                        <!-- text input -->
                        <div class="form-group has-feedback">
                            <label>Name</label>
                            <input name="name" value="<%=name%>" type="text" class="form-control" placeholder="Enter ..." required>
                        </div>
    
                    </div><!-- /.box-body -->

                    <div class="box-footer">
                        <button type="submit" class="btn btn-primary">Submit</button>
                    </div>
                </form>
            </div>

        </div>

    </div>   <!-- /.row -->
</section><!-- /.content -->
