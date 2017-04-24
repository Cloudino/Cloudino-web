<%-- 
    Document   : addOCBEntity
    Created on : 09/03/2017, 07:27:14 PM
    Author     : javier.solis
--%>
<%@page import="io.cloudino.utils.Utils"%>
<%@page import="io.cloudino.utils.TokenGenerator"%>
<%@page import="io.cloudino.compiler.ArdCompiler"%>
<%@page import="org.semanticwb.datamanager.SWBDataSource"%>
<%@page import="org.semanticwb.datamanager.DataMgr"%>
<%@page import="org.semanticwb.datamanager.SWBScriptEngine"%>
<%@page import="org.semanticwb.datamanager.DataObject"%>
<%@page import="java.util.Comparator"%>
<%@page import="java.util.TreeSet"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Iterator"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String entityId=Utils.nullValidate(request.getParameter("entityId"),"");
    String entityDef=Utils.nullValidate(request.getParameter("entityDef"),"");
    String active=Utils.nullValidate(request.getParameter("active"),"");
    String dns=Utils.nullValidate(request.getParameter("dns"),"");
    String port=Utils.nullValidate(request.getParameter("port"),"");  
    String authUrl=Utils.nullValidate(request.getParameter("authUrl"),"");
    String user=Utils.nullValidate(request.getParameter("user"),"");
    String passwd=Utils.nullValidate(request.getParameter("passwd"),"");
    
/*    
    if(name!=null)
    {
        DataObject user=(DataObject)session.getAttribute("_USER_");
        SWBScriptEngine engine=DataMgr.getUserScriptEngine("/cloudino.js",user);
        SWBDataSource ds=engine.getDataSource("DataSet");
        DataObject data=new DataObject();
        data.put("user", user.getId());
        data.put("name", name);
        data.put("description", description);
        DataObject fields = new DataObject();
        data.put("fields", fields);
        DataObject ret=ds.addObj(data);
        //System.out.println(ret);
        DataObject obj=ret.getDataObject("response").getDataObject("data");
        if(obj!=null)
        {
            response.sendRedirect("datasetDetail?ID="+obj.getNumId()+"&_rm=true");
            return;
        }
    }
    if(name==null)name="";
    if(description==null)description="";
*/        
%>
<!-- Content Header (Page header) -->
<section class="content-header">
    <h1>
        Add Entity
        <small>Step 1</small>
    </h1>
    <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Panel</a></li>
        <li><a href="#">FIWARE ContextBroker</a></li>
        <li class="active">Add Entity</li>
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
                <form data-target=".content-wrapper" data-submit="ajax" action="addOCBEntity" role="form">
                    <div class="box-body">
                        
                        <!-- text input -->
                        <div class="form-group has-feedback">
                            <label>Entity ID</label>
                            <input name="entityId" value="<%=entityId%>" type="text" class="form-control" placeholder="Enter ..." required>
                        </div>

                        <!-- textarea -->
                        <div class="form-group has-feedback">
                            <label>Entity Definition</label>
                            <textarea name="entityDef" class="form-control" rows="3" placeholder="Enter ..."><%=entityDef%></textarea>
                        </div>
                        
                        <div class="form-group has-feedback">
                            <label>Active</label>
                            <input name="active" type="checkbox" class="checkbox-inline">
                        </div>  
                        
                        <div class="form-group has-feedback">
                            <label>DNS</label>
                            <input name="dns" value="<%=dns%>" type="text" class="form-control" placeholder="Enter ..." required>
                        </div>    
                        
                        <div class="form-group has-feedback">
                            <label>Port</label>
                            <input name="port" value="<%=port%>" type="number" class="form-control" placeholder="Enter ..." required>
                        </div>   
                        
                        <div class="form-group has-feedback">
                            <label>Auth URL</label>
                            <input name="authUrl" value="<%=authUrl%>" type="text" class="form-control" placeholder="Enter ..." required>
                        </div>    
                        
                        <div class="form-group has-feedback">
                            <label>User</label>
                            <input name="user" value="<%=user%>" type="text" class="form-control" placeholder="Enter ..." required>
                        </div> 
                        
                        <div class="form-group has-feedback">
                            <label>Password</label>
                            <input name="passwd" value="<%=passwd%>" type="password" class="form-control" placeholder="Enter ..." required>
                        </div>                         
                    </div><!-- /.box-body -->

                    <div class="box-footer">
                        <button type="submit" class="btn btn-primary">Submit</button>
                    </div>
                </form>
            </div>

        </div>

        <div class="col-md-4 callout callout-danger lead">
            <h4>Tip!</h4>
            <p>
                If you go through the example pages and would like to copy a component, right-click on
                the component and choose "inspect element" to get to the HTML quicker than scanning
                the HTML page.
            </p>
        </div>

    </div>   <!-- /.row -->
</section><!-- /.content -->
