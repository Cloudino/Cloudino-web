<%-- 
    Document   : addSketcher
    Created on : 11/08/2015, 11:59:05 AM
    Author     : juan.fernandez
--%>
<%@page import="io.cloudino.utils.ParamsMgr"%>
<%@page import="java.util.Properties"%><%@page import="io.cloudino.compiler.ArdCompiler"%><%@page import="io.cloudino.engine.*"%><%@page import="java.util.ArrayList"%><%@page import="java.util.Iterator"%><%@page import="java.io.*"%><%@page import="java.net.URLEncoder"%><%@page contentType="text/html" pageEncoding="UTF-8"%><%@page import="org.semanticwb.datamanager.*"%>
<%
    ParamsMgr params=new ParamsMgr(request.getSession());
    
    String k = request.getParameter("k");
    
    String name = params.getDataValue(k, "name");
    String act = params.getDataValue(k, "act");
    String sktname = params.getDataValue(k,"skt");
    
    //String name=request.getParameter("name");
    //String sktname=request.getParameter("skt");
    //String act = request.getParameter("act");
    
    if(null==act){
        act = request.getParameter("act");
        if(null!=act){
            name = name=request.getParameter("name");
            sktname=request.getParameter("skt");
        } 
    }
    
    if (null==name){
        name = request.getParameter("name");
    }
    
    boolean isNewFile = false;
    if(null!=act&&"newfile".equals(act)){
        isNewFile = true;
    }

    if(name!=null) 
    {
        //if(null==sktname) sktname=name;
        // Generar carpeta dentro del FileSystem del usuario
        
        DataObject user=(DataObject)session.getAttribute("_USER_");
        SWBScriptEngine engine=DataMgr.getUserScriptEngine("/cloudino.js",user);
        
        String dir = config.getServletContext().getRealPath("/") + "/work/"  ;
        String msg =null;          
        String userBasePath = dir+engine.getScriptObject().get("config").getString("usersWorkPath")+"/"+user.getNumId()+"/cloudinojs"; 
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
                msg = "There is a Sketcher with the same name.";
%>
<script type="text/javascript">cdino_alert("Warning",msg,"warning",5000);</script>
<%
                return;
            }
            newf = new File(userBasePath+"/sketchers/"+name+"/"+name+".js");
            if(!newf.exists()){
                newf.createNewFile();
                newf.setWritable(true);                
            }
            
        } else {
            newf = new File(userBasePath+"/sketchers/"+sktname+"/"+name);
            if(!newf.exists()){
                newf.createNewFile();
                newf.setWritable(true);                
            } else {
                msg="There is a file with the same name.";
%>
<script type="text/javascript">cdino_alert("Warning",msg,"warning",5000);</script>
<%                
                return;
            }
        }
        
        if(newf!=null)
        {
            if(null==sktname)sktname=name;
            response.sendRedirect("sketcherDetailJS?k="+params.setDataValues("fn",newf.getName(),"skt",sktname)+"&_rm=true");
            return;
        }
    }
    if(name==null)name="";
    
%>
<!-- Content Header (Page header) -->
<section class="content-header">
    <h1>
        <%
    String formName = "Add JS Sketcher";

        if(null!=sktname&&isNewFile){
            formName="New file";
        }
        
        %>
        <%=formName%>
        <small>Step 1</small>
    </h1>
    <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Panel</a></li>
        <li><a href="#">CloudinoJS</a></li>
        <li><a href="#">Sketchers</a></li>
        <li class="active">Add Sketcher</li>
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
                <form data-target=".content-wrapper" data-submit="ajax" action="addSketcherJS" role="form" >
                    <div class="box-body">
                        <%
                        String placeHolderStr = "Enter Sketcher name ...";
                        
                        if(isNewFile){
                            placeHolderStr = "Enter file name ... (allowed types: js,txt)";
                            %>
                            <input type="hidden" name="act" value="addFile"/>
                            <input type="hidden" name="skt" value="<%=sktname%>"/>                            
                            <%
                        }
                        %>
                        <!-- text input -->
                        <div class="form-group has-feedback">
                            <label>Name</label>
                            <input name="name" id="nombre" value="<%=name%>" type="text" class="form-control" placeholder="<%=placeHolderStr%>" required>
                        </div>
    
                    </div><!-- /.box-body -->

                    <div class="box-footer">
                        <button type="submit" class="btn btn-primary"  <%=(isNewFile?"onclick=\"if(validateFileType()){return true;}else{ return false;}\"":"")%> >Submit</button>
                    </div>
                </form>
                    
                    <%
                    if(isNewFile){
                    %>
                    
                        <script type="text/javascript">
                            
                            function validateFileType(){
                                
                                var nombre = document.getElementById('nombre').value;
                                
                                //console.log(nombre);
                                
                                nombre = nombre.replace(/ /g,'');
                                var indice = nombre.indexOf(".");
//                                alert(nombre+"("+nombre.length+","+indice+")");
                                var isValid = false;

                                if(nombre.length>3 && indice>-1){
                                //validación de la extensión del nombre del archivo
                                
                                    if (nombre.length > 0) {
                                        isValid = valida_docs_type();
                                        if (!isValid) {
                                            alert("Error, " + nombre + " is invalid, allowed extensions are: js, txt");
                                            document.getElementById('nombre').focus();
                                            return isValid;
                                        }
                                    } 
                                    else {
                                        document.getElementById('nombre').value="";
                                        document.getElementById('nombre').focus();
                                        alert("Name is required...");
                                        return isValid;
                                    }
                                    return isValid;
                                } else {
                                    alert("The name of the file is invalid.");
                                    document.getElementById('nombre').value="";
                                    document.getElementById('nombre').focus();
                                    return isValid;
                                }
                                
                            }                                                        
                            
                            function valida_docs_type() {                                
                                var valid = false;
                                var input;
                                nameFile = "nombre";
                                input = document.getElementById(nameFile);
                                //console.log(input);
                                if (input) {
                                    var fileName = input.value;
                                    var ext = fileName.substring(fileName.lastIndexOf('.') + 1);
                                    ext = ext.toLowerCase();
                                    if (ext == "js" || ext == "txt")
                                    {
                                        valid = true;
                                    }
                                }
                                return valid;
                            }
                            
                        </script>
                        <%
                    }
                        %>
            </div>

        </div>

    </div>   <!-- /.row -->
</section><!-- /.content -->
