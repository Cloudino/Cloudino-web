<%-- 
    Document   : addDevice
    Created on : 03-ago-2015, 21:13:52
    Author     : javiersolis
--%>
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
    String description=request.getParameter("description");     
    String type=request.getParameter("type");
    if(name!=null)
    {
        DataObject user=(DataObject)session.getAttribute("_USER_");
        SWBScriptEngine engine=DataMgr.getUserScriptEngine("/cloudino.js",user);
        SWBDataSource ds=engine.getDataSource("Device");
        DataObject data=new DataObject();
        data.put("user", user.getId());
        data.put("name", name);
        data.put("description", description);
        data.put("type", type);
        DataObject ret=ds.addObj(data);
        //System.out.println(ret);
        DataObject obj=ret.getDataObject("response").getDataObject("data");
        if(obj!=null)
        {
            response.sendRedirect("deviceDetail?ID="+obj.getNumId());
            return;
        }
    }
    if(name==null)name="";
    if(description==null)description="";
%>
<!-- Content Header (Page header) -->
<section class="content-header">
    <h1>
        Add Device
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
                <form data-target=".content-wrapper" action="addDevice" role="form" data-toggle="validator">
                    <div class="box-body">
                        <!-- text input -->
                        <div class="form-group has-feedback">
                            <label>Name</label>
                            <input name="name" value="<%=name%>" type="text" class="form-control" placeholder="Enter ..." required>
                        </div>

                        <!-- textarea -->
                        <div class="form-group has-feedback">
                            <label>Description</label>
                            <textarea name="description" class="form-control" rows="3" placeholder="Enter ..."><%=description%></textarea>
                        </div>

                        <!-- select -->
                        <div class="form-group has-feedback">
                            <label>Type</label>
                            <select name="type" class="form-control">
                                <option value="cloudino-standalone">Cloudino Connector Standalone</option>
                                <%
                                    io.cloudino.compiler.Compiler cmp = io.cloudino.compiler.Compiler.getInstance();
                                    Iterator<io.cloudino.compiler.Device> it = cmp.listDevices();
                                    while (it.hasNext()) {
                                        io.cloudino.compiler.Device dev = it.next();
                                        out.println("<option value=\"" + dev.key + "\">" + dev.toString() + "</option>");
                                    }
                                %>                                
                            </select>
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
