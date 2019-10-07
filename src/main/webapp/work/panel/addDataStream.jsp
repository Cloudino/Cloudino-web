<%-- 
    Document   : addDataStream
    Created on : 23/09/2015, 07:27:14 PM
    Author     : juan.fernandez
--%>
<%@page import="io.cloudino.datastreams.DataStreamMgr"%>
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
    String topic=request.getParameter("topic");
    String description=request.getParameter("description");
    
    if(name!=null)
    {
        DataObject user=(DataObject)session.getAttribute("_USER_");
        SWBScriptEngine engine=DataMgr.getUserScriptEngine("/cloudino.js",user);
        SWBDataSource ds=engine.getDataSource("DataStream");
        DataObject data=new DataObject();
        data.put("user", user.getId());
        data.put("name", name);
        data.put("topic", topic);
        data.put("description", description);
        DataObject fields = new DataObject();
        data.put("fields", fields);
        DataObject ret=ds.addObj(data);
        
        DataStreamMgr.getInstance().clearCache(user.getId(), topic);
        
        //System.out.println(ret);
        DataObject obj=ret.getDataObject("response").getDataObject("data");
        if(obj!=null)
        {
            response.sendRedirect("dataStreamDetail?ID="+obj.getNumId()+"&_rm=true");
            return;
        }
    }
    if(name==null)name="";
    if(description==null)description="";
    if(topic==null)topic="";
%>
<!-- Content Header (Page header) -->
<section class="content-header">
    <h1>
        Add DataStream
        <small>Step 1</small>
    </h1>
    <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Panel</a></li>
        <li><a href="#">DataStream</a></li>
        <li class="active">Add DataStream</li>
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
                <form class="form-horizontal" data-target=".content-wrapper" data-submit="ajax" action="addDataStream" role="form">
                    <div class="box-body">
                        
                        <!-- text input -->
                        <div class="form-group has-feedback">
                            <label class="col-sm-2 control-label">Name</label>
                            <div class="col-sm-10">
                                <input name="name" value="<%=name%>" type="text" class="form-control" placeholder="Enter the name of the DataStream" required>
                            </div>
                        </div>
                        
                        <!-- text input -->
                        <div class="form-group has-feedback">
                            <label class="col-sm-2 control-label">Topic</label>
                            <div class="col-sm-10">
                                <input name="topic" value="<%=topic%>" type="text" class="form-control" placeholder="Enter the Topic of the DataStream" required>
                            </div>
                        </div>

                        <!-- textarea -->
                        <div class="form-group has-feedback">
                            <label class="col-sm-2 control-label">Description</label>
                            <div class="col-sm-10">
                                <textarea name="description" class="form-control" rows="3" placeholder="Enter description"><% //=description%></textarea>
                            </div>
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
                Create a new Data Stream..              
            </p>
            <p>
                The Data Stream lets store the historical device data..
            </p>
        </div>
    </div>   <!-- /.row -->
</section><!-- /.content -->
