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
        String userBasePath = dir+engine.getScriptObject().get("config").getString("usersWorkPath")+"/"+user.getNumId(); 
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
                msg="There is a file with the same name.";
                return;
            }
        }
        
        if(newf!=null)
        {
            if(null==sktname)sktname=name;
            response.sendRedirect("sketcherDetail?k="+params.setDataValues("fn",newf.getName(),"skt",sktname,"_rm","true"));
            return;
        }
    }
    if(name==null)name="";
    
%>
<!-- Content Header (Page header) -->
<script type="text/javascript">
//    window.onload = function () {
//    document.formAddSketcher.name.focus();
//    document.formAddSketcher.addEventListener('submit', validateFileType);
//}
</script>
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
                <form data-target=".content-wrapper" data-submit="ajax" action="addSketcher" role="form" >
                    <div class="box-body">
                        <%
                        String placeHolderStr = "Enter Sketcher name ...";
                        
                        if(isNewFile){
                            placeHolderStr = "Enter file name ... (allowed types: c,cpp,h)";
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
                                nombre = nombre.replace(/ /g,'');
                                var indice = nombre.indexOf(".");
//                                alert(nombre+"("+nombre.length+","+indice+")");
                                var isValid = false;

                                if(nombre.length>4 && indice>-1){
                                //validación de la extensión del nombre del archivo
                                
                                    if (nombre.length > 0) {
                                        isValid = isValidName();
                                        if(!isValid){
                                            alert("The name of the file is invalid.");
                                            document.getElementById('nombre').value="";
                                            document.getElementById('nombre').focus();
                                            return isValid;
                                        }

                                        isValid = valida_docs_type();
                                        if (!isValid) {
                                            alert("Error, " + nombre + " is invalid, allowed extensions are: c, cpp, h");
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
                            
                             function isValidName() {
                                var valid = false;
                                var name = document.getElementById('nombre').value;
                                var filter = /^[\w\d\_]+[.][cph]{1,3}$/;

                                    if (name != null && name != '' && filter.test(name)) {
                                        valid = true;
                                    }

                                return valid;
                            }
                            
                            
                            function valida_docs_type() {
                                var valid = false;
                                var input;
                                nameFile = "nombre";
                                input = document.getElementById(nameFile);
                                if (input) {
                                    var fileName = input.value;
                                    var ext = fileName.substring(fileName.lastIndexOf('.') + 1);
                                    ext = ext.toLowerCase();
                                    if (ext == "c" || ext == "cpp" || ext == "h")
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
