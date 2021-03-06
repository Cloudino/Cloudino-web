<%-- 
    Document   : addDevice
    Created on : 03-ago-2015, 21:13:52
    Author     : javiersolis
--%>
<%@page import="org.semanticwb.datamanager.utils.TokenGenerator"%>
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
    String description=request.getParameter("description");     
    String type=request.getParameter("type");
    if(name!=null)
    {
        DataObject user=(DataObject)session.getAttribute("_USER_");
        SWBScriptEngine engine=DataMgr.getUserScriptEngine("/cloudino.js",user);
        SWBDataSource ds=engine.getDataSource("Device");
        String token = TokenGenerator.getNonExistentTokenByUserId(user.getNumId(), ds);
        DataObject data=new DataObject();
        data.put("user", user.getId());
        data.put("name", name);
        data.put("description", description);
        data.put("type", type);
        data.put("authToken", token);
        DataObject ret=ds.addObj(data);
        //System.out.println(ret);
        DataObject obj=ret.getDataObject("response").getDataObject("data");
        if(obj!=null)
        {
            response.sendRedirect("deviceDetail?ID="+obj.getNumId()+"&_rm=true");
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
        <li><a href="#"><i class="fa fa-dashboard"></i> Panel</a></li>
        <li><a href="#">Devices</a></li>
        <li class="active">Add Device</li>
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
                <form class="form-horizontal" data-target=".content-wrapper" data-submit="ajax" action="addDevice" role="form">
                    <div class="box-body">
                        
                        <!-- text input -->
                        <div class="form-group has-feedback">
                            <label class="col-sm-2 control-label">Name</label>
                            <div class="col-sm-10">
                                <input name="name" value="<%=name%>" type="text" class="form-control" placeholder="Enter ..." required>
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
                            <label class="col-sm-2 control-label">Type</label>
                            <div class="col-sm-10">
                                <select name="type" class="form-control">
                                <option value="cloudino-standalone">Cloudino Standalone</option>
                                <%
                                    ArdCompiler cmp = ArdCompiler.getInstance();
                                    Iterator<io.cloudino.compiler.ArdDevice> it = cmp.listDevices();
                                    while (it.hasNext()) {
                                        io.cloudino.compiler.ArdDevice dev = it.next();
                                        out.println("<option value=\"" + dev.key + "\">" + dev.toString() + "</option>");
                                    }
                                %>                                
                                </select>
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
                Create a new Device thats lets manage your specific hardware
            </p>
            <p>
                Use the property <b>type</b> for select you hardware configuration, example:
            </p>
            <ul>
                <li>
                    Cloudino Standalone -> For use the WiFi Cloud Connector alone (without arduino)
                </li>
                <li>    
                    Arduino Uno -> For use the Wifi Cloud Connector with Arduino uno
                </li>
            </ul>
        </div>                            
    </div>   <!-- /.row -->
</section><!-- /.content -->
