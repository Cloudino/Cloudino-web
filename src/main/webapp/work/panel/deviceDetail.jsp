<%-- 
    Document   : deviceDetail
    Created on : 04-ago-2015, 0:03:07
    Author     : javiersolis
--%><%@page import="io.cloudino.compiler.*"%><%@page import="java.util.*"%><%@page import="io.cloudino.engine.*"%><%@page import="org.semanticwb.datamanager.*"%><%
    DataObject user = (DataObject) session.getAttribute("_USER_");
    SWBScriptEngine engine = DataMgr.getUserScriptEngine("/cloudino.js", user);
    SWBDataSource ds = engine.getDataSource("Device");

    String id = request.getParameter("ID");

    Device device = DeviceMgr.getInstance().getDeviceIfPresent(id);
    DataObject data = null;

    if (device != null) {
        data = device.getData();
    } else {
        data = ds.fetchObjByNumId(id);
    }
    System.out.println("id:"+id);    
    System.out.println("device:"+device);
    System.out.println("data:"+data);
    //Security
    if (data == null || (data != null && !data.getString("user").equals(user.getId()))) {
        response.sendError(404);
        return;
    }

    //Update
    String name = request.getParameter("name");
    if (name != null) {
        String description = request.getParameter("description");
        String type = request.getParameter("type");
        data.put("name", name);
        data.put("description", description);
        data.put("type", type);
        DataObject ret=ds.updateObj(data);
        //System.out.println(ret);
        DataObject obj = ret.getDataObject("response").getDataObject("data");
        if (obj != null) {
            response.sendRedirect("deviceDetail?ID=" + obj.getNumId());
            return;
        }else
        {
            out.println("Error updating object...");
            return;
        }
    }

    name = data.getString("name", "");
    String description = data.getString("description", "");
    String type = data.getString("type");

    boolean isConnected = false;
    long connectedTime = 0;
    long createdTime = 0;
    if (device != null) {
        isConnected = device.isConnected();
        connectedTime = device.getConnectedTime();
        createdTime = device.getCreatedTime();
    }
%>

<section class="content-header">
    <h1>Device<small>Name</small></h1>
    <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li><a href="#">Forms</a></li>
        <li class="active">General Elements</li>
    </ol>
</section>

<section class="content">
    <!-- START CUSTOM TABS -->
    <div class="row">
        <div class="col-md-12">
            <!-- Custom Tabs -->
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <li class="active"><a href="#tab_1" data-toggle="tab" aria-expanded="true">General</a></li>
                    <li class=""><a href="#tab_2" data-toggle="tab" aria-expanded="false">Code</a></li>
                    <li class=""><a href="#tab_3" data-toggle="tab" aria-expanded="false">Messages</a></li>
                    <li class="dropdown">
                        <a class="dropdown-toggle" data-toggle="dropdown" href="#" aria-expanded="false">
                            Dropdown <span class="caret"></span>
                        </a>
                        <ul class="dropdown-menu">
                            <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Action</a></li>
                            <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Another action</a></li>
                            <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Something else here</a></li>
                            <li role="presentation" class="divider"></li>
                            <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Separated link</a></li>
                        </ul>
                    </li>
                    <li class="pull-right"><a href="#" class="text-muted"><i class="fa fa-gear"></i></a></li>
                </ul>
                <div class="tab-content">
                    <div class="tab-pane active" id="tab_1">

                        <form data-target=".content-wrapper" data-submit="ajax" action="deviceDetail" role="form">
                            <div class="box-body">

                                <div class="form-group has-feedback">
                                    <label>Id</label>
                                    <div><%=id%></div>
                                    <input type="hidden" name="ID" value="<%=id%>">
                                </div>  

                                <!-- text input -->
                                <div class="form-group has-feedback">
                                    <label>Name</label>
                                    <input name="name" value="<%=name%>" type="text" class="form-control" placeholder="Enter ..." required="true">
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
                                            ArdCompiler cmp = ArdCompiler.getInstance();
                                            Iterator<ArdDevice> it = cmp.listDevices();
                                            while (it.hasNext()) {
                                                io.cloudino.compiler.ArdDevice dev = it.next();
                                                out.println("<option value=\"" + dev.key + "\" " + (dev.key.equals(type) ? "selected" : "") + ">" + dev.toString() + "</option>");
                                            }
                                        %>    
                                    </select>
                                </div> 

                                <div class="form-group has-feedback">
                                    <label>Created Time</label>
                                    <div><%=new Date(createdTime)%></div>
                                </div>     

                                <div class="form-group has-feedback">
                                    <label>Connected Time</label>
                                    <div><%=new Date(connectedTime)%></div>
                                </div>      

                            </div><!-- /.box-body -->

                            <div class="box-footer">
                                <button type="submit" class="btn btn-primary disabled">Submit</button>
                            </div>
                        </form>                        

                    </div><!-- /.tab-pane -->
                    <div class="tab-pane" id="tab_2">
                        The European languages are members of the same family. Their separate existence is a myth.
                        For science, music, sport, etc, Europe uses the same vocabulary. The languages only differ
                        in their grammar, their pronunciation and their most common words. Everyone realizes why a
                        new common language would be desirable: one could refuse to pay expensive translators. To
                        achieve this, it would be necessary to have uniform grammar, pronunciation and more common
                        words. If several languages coalesce, the grammar of the resulting language is more simple
                        and regular than that of the individual languages.
                    </div><!-- /.tab-pane -->
                    <div class="tab-pane" id="tab_3">
                        Lorem Ipsum is simply dummy text of the printing and typesetting industry.
                        Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,
                        when an unknown printer took a galley of type and scrambled it to make a type specimen book.
                        It has survived not only five centuries, but also the leap into electronic typesetting,
                        remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset
                        sheets containing Lorem Ipsum passages, and more recently with desktop publishing software
                        like Aldus PageMaker including versions of Lorem Ipsum.
                    </div><!-- /.tab-pane -->
                </div><!-- /.tab-content -->
            </div><!-- nav-tabs-custom -->
        </div><!-- /.col -->


    </div> <!-- /.row -->
    <!-- END CUSTOM TABS -->
</section>