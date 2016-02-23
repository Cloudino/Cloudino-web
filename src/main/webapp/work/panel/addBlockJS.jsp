<%-- 
    Document   : addDataSet
    Created on : 23/09/2015, 07:27:14 PM
    Author     : javier.solis
--%>
<%@page import="java.io.File"%>
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
    String name=request.getParameter("name");
    
    if(name!=null)
    {
        DataObject user=(DataObject)session.getAttribute("_USER_");
        SWBScriptEngine engine=DataMgr.getUserScriptEngine("/cloudino.js",user);
        
        String workPath = DataMgr.getApplicationPath() + "/work/";
        String blockPath = workPath + engine.getScriptObject().get("config").getString("usersWorkPath") + "/" + user.getNumId() + "/cloudinojs/blocks/"+name;
        File dir=new File(blockPath);
        if(!dir.exists())dir.mkdirs();
        
        response.sendRedirect("blockDetailJS?ID="+name+"&_rm=true");
        return;
    }
%>
<!-- Content Header (Page header) -->
<section class="content-header">
    <h1>
        Add JS Block
        <small>Step 1</small>
    </h1>
    <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li><a href="#">Forms</a></li>
        <li class="active">Add Block</li>
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
                <form data-target=".content-wrapper" data-submit="ajax" action="addBlockJS" role="form">
                    <div class="box-body">
                        
                        <!-- text input -->
                        <div class="form-group has-feedback">
                            <label>Name</label>
                            <input name="name" value="" type="text" class="form-control" placeholder="Enter ..." required>
                        </div>

                    </div><!-- /.box-body -->

                    <div class="box-footer">
                        <button type="submit" class="btn btn-primary">Submit</button>
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
    </div>   <!-- /.row -->
</section><!-- /.content -->
