<%-- 
    Document   : addLink
    Created on : 11/07/2017, 07:27:14 PM
    Author     : javier.solis
--%>
<%@page import="org.semanticwb.datamanager.DataList"%>
<%@page import="io.cloudino.utils.Utils"%>
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
    String name=Utils.nullValidate(request.getParameter("name"),"");
    String type=Utils.nullValidate(request.getParameter("type"),"OCB");
    String description=Utils.nullValidate(request.getParameter("description"),"");
    String device=Utils.nullValidate(request.getParameter("device"),"");
    
    DataObject user=(DataObject)session.getAttribute("_USER_");
    SWBScriptEngine engine=DataMgr.getUserScriptEngine("/cloudino.js",user);
    
    if(name.length()>0)
    {
        SWBDataSource ds=engine.getDataSource("DeviceLinks");
        DataObject data=new DataObject();
        data.put("user", user.getId());
        data.put("name", name);
        data.put("description", description);
        data.put("device", device);
        data.put("type", type);
        data.put("active", false);
        DataObject fields = new DataObject();
        data.put("data", fields);
        DataObject ret=ds.addObj(data);
        //System.out.println(ret);
        DataObject obj=ret.getDataObject("response").getDataObject("data");
        if(obj!=null)
        {
            response.sendRedirect("link"+type+"Detail?ID="+obj.getNumId()+"&_rm=true");
            return;
        }
    }        
%>
<!-- Content Header (Page header) -->
<section class="content-header">
    <h1>
        Add Device Link
        <small>Step 1</small>
    </h1>
    <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Panel</a></li>
        <li class="active">Add Device Link</li>
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
                <form class="form-horizontal" data-target=".content-wrapper" data-submit="ajax" action="addLink" role="form">
                    <div class="box-body">
                        
                        <!-- text input -->
                        <div class="form-group has-feedback">
                            <label class="col-sm-2 control-label">Name</label>
                            <div class="col-sm-10">
                                <input name="name" value="<%=name%>" type="text" class="form-control" placeholder="Enter ..." required>
                                <input name="type" value="<%=type%>" type="hidden">
                            </div>
                        </div>

                        <!-- textarea -->
                        <div class="form-group has-feedback">
                            <label class="col-sm-2 control-label">Description</label>
                            <div class="col-sm-10">
                                <textarea name="description" class="form-control" rows="3" placeholder="Enter ..."><%=description%></textarea>
                            </div>
                        </div>
                        
                        <!-- select -->
                        <div class="form-group has-feedback">
                            <label class="col-sm-2 control-label">Device</label>
                            <div class="col-sm-10">
                                <select name="device" class="form-control">
                                <%
                                    {
                                        SWBDataSource ds = engine.getDataSource("Device");
                                        DataObject query = new DataObject();
                                        query.addSubList("sortBy").add("name");
                                        query.addSubObject("data").addParam("user", user.getId());    
                                        DataObject ret = ds.fetch(query);
                                        //System.out.println(ret);
                                        DataList<DataObject> devices = ret.getDataObject("response").getDataList("data");
                                        if (devices != null) {
                                            for (DataObject dev : devices) {
                                                String id = dev.getNumId();
                                                out.println("<option value=\"" + id + "\" " + (id.equals(device) ? "selected" : "") + ">" + dev.getString("name") + "</option>");
                                            }
                                        }
                                    }
                                %>    
                                </select>
                            </div>
                        </div>                         

                        <div class="box-footer">
                            <button type="submit" class="btn btn-primary">Submit</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
        <div class="col-md-4 callout callout-danger lead">
            <h4>Tip!</h4>
            <p>
                Create a new Device Link...
            </p>
        </div>  
    </div>   <!-- /.row -->
</section><!-- /.content -->
