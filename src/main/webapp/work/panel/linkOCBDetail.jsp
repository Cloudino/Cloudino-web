<%--  
    Document   : linkOCBDetail
    Created on : 11/07/2017, 07:27:50 PM
    Author     : javier.solis
--%><%@page import="io.cloudino.links.DeviceLinkMgr"%>
<%@page import="io.cloudino.utils.Utils"%><%@page import="io.cloudino.datastreams.DataStreamMgr"%><%@page contentType="text/html" pageEncoding="UTF-8"%><%@page import="java.net.URLEncoder"%><%@page import="java.io.*"%><%@page import="io.cloudino.compiler.*"%><%@page import="java.util.*"%><%@page import="io.cloudino.engine.*"%><%@page import="org.semanticwb.datamanager.*"%><%
    DataObject user = (DataObject) session.getAttribute("_USER_");
    SWBScriptEngine engine = DataMgr.getUserScriptEngine("/cloudino.js", user);
    SWBDataSource ds = engine.getDataSource("DeviceLinks");

    String id = request.getParameter("ID");
    String act = request.getParameter("act");    

    DataObject object = ds.fetchObjByNumId(id);
    
    System.out.println("object"+object);
    
//    System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
//    System.out.println("id:" + id);
//    System.out.println("datastream" + device);
//    System.out.println("data:" + data);
    //Security
    if (object == null || (object != null && !object.getString("user").equals(user.getId()))) {
        response.sendError(404);
        return;
    }
    
    
    //remove
    if("remove".equals(act))
    {
        ds.removeObjById(object.getId());
        
        DeviceLinkMgr.getInstance().clearCache(id);
        DeviceLinkMgr.getInstance().clearCacheByDevice(object.getString("device"));
        
        out.println("<script type=\"text/javascript\">loadContent('/panel/menu?act=ocb','.main-sidebar');</script>");
%>
            <!-- Custom Tabs -->
            <div class="nav-tabs-custom">
                <div class="tab-content">
                    <div class="tab-pane active" id="tab_1">
                        <h3>FIWARE OCB Link was deleted...</h3>
                    </div><!-- /.tab-pane -->
                </div>    
            </div>
<%
        return;
    }      
    
    //Update
    String name = request.getParameter("name");
    String description=Utils.nullValidate(request.getParameter("description"),"");
    String device = request.getParameter("device");
    String active=request.getParameter("active")!=null?"true":"false";

    String entityId=Utils.nullValidate(request.getParameter("entityId"),"");
    String entityDef=Utils.nullValidate(request.getParameter("entityDef"),"");
    String serverURL=Utils.nullValidate(request.getParameter("serverURL"),"");
    String authUrl=Utils.nullValidate(request.getParameter("authUrl"),"");
    String auth_user=Utils.nullValidate(request.getParameter("auth_usr"),"");
    String auth_passwd=Utils.nullValidate(request.getParameter("auth_pwd"),"");


    if (name != null) {

        DeviceLinkMgr.getInstance().clearCacheByDevice(object.getString("device"));

        object.put("name", name);
        object.put("description", description);
        object.put("device", device);
        object.put("active", Boolean.parseBoolean(active));

        DataObject data=object.getDataObject("data");
        data.put("entityId", entityId);
        data.put("entityDef", entityDef);
        data.put("serverURL", serverURL);
        data.put("authUrl", authUrl);
        data.put("user", auth_user);
        data.put("passwd", auth_passwd);

//        data.put("type", type);
        DataObject ret = ds.updateObj(object);

        DeviceLinkMgr.getInstance().clearCacheByDevice(object.getString("device"));

        //System.out.println(ret);
        //DataObject obj = ret.getDataObject("response").getDataObject("data");
        if (ret != null) {
            response.sendRedirect("linkOCBDetail?ID=" + object.getNumId()+"&_rm=true");
            return;
        } else {
            out.println("Error updating object...");
            return;
        }
        
    }

    name = object.getString("name", "");
    description = object.getString("description", "");
    device = object.getString("device", "");
    active = object.getString("active", "false");

    DataObject data=object.getDataObject("data");
    entityId = data.getString("entityId", "");
    entityDef = data.getString("entityDef", "");
    serverURL = data.getString("serverURL", "http://orion.lab.fi-ware.org:1026");
    authUrl = data.getString("authUrl", "https://orion.lab.fiware.org/token");
    auth_user = data.getString("user", "");
    auth_passwd = data.getString("passwd", "");

    /////////////////////////////////////////////////////////////
   
    if(request.getParameter("_rm")!=null)
    {
        out.println("<script type=\"text/javascript\">loadContent('/panel/menu?act=ocb','.main-sidebar');</script>");
    }    
%>

<section class="content-header">
    <h1>FIWARE OCB Link<small> <%=name%></small></h1>
    <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Panel</a></li>
        <li><a href="#">FIWARE OCB Link</a></li>
        <li class="active"><%=name%></li>
    </ol>
</section>

<section class="content">
    <!-- START CUSTOM TABS -->
    <div class="row">
        <div class="col-md-12" id="main_content">
            <!-- Custom Tabs -->
            <div class="nav-tabs-custom">
<!--                
                <ul class="nav nav-tabs">
                    <li class="active"><a href="#tab_1" data-toggle="tab" aria-expanded="true">General</a></li>
                    <li class=""><a href="#tab_2" data-toggle="tab" aria-expanded="false">Fields</a></li>
                    <li class=""><a href="#tab_3" data-toggle="tab" aria-expanded="false" onclick="loadContent('/work/panel/data.jsp?ID=<%=id%>','#tab_3')">Data</a></li>
                    <li class=""><a href="#tab_4" data-toggle="tab" aria-expanded="false" onclick="loadContent('/work/panel/graphs.jsp?ID=<%=id%>','#tab_4')">Graphs</a></li>
                </ul>
-->                
                <div class="tab-content">
                    <div class="tab-pane active" id="tab_1">

                        <form class="form-horizontal" data-target=".content-wrapper" autocomplete="off" data-submit="ajax" action="linkOCBDetail" role="form">
                            <div class="box-body">

                                <div class="form-group has-feedback">
                                    <label class="col-sm-2 control-label">Id</label>
                                    <div class="col-sm-2 control-label"><%=id%></div>
                                    <input type="hidden" name="ID" value="<%=id%>">
                                </div>  

                                <!-- text input -->
                                <div class="form-group has-feedback">
                                    <label class="col-sm-2 control-label">Name</label>
                                    <div class="col-sm-10">
                                        <input name="name" value="<%=name%>" type="text" class="form-control" placeholder="Enter the name of the DataStream" required="true">
                                    </div>
                                </div>
                                
                                <div class="form-group has-feedback">
                                    <label class="col-sm-2 control-label">Description</label>
                                    <div class="col-sm-10">
                                        <textarea name="description" class="form-control" rows="3" placeholder="Enter description"><%=description%></textarea>
                                    </div>
                                </div>
                                
                                <!-- select -->
                                <div class="form-group has-feedback">
                                    <label class="col-sm-2 control-label">Device</label>
                                    <div class="col-sm-10">
                                        <select name="device" class="form-control">
                                        <%
                                            {
                                                ds = engine.getDataSource("Device");
                                                DataObject query = new DataObject();
                                                query.addSubList("sortBy").add("name");
                                                query.addSubObject("data").addParam("user", user.getId());    
                                                DataObject ret = ds.fetch(query);
                                                //System.out.println(ret);
                                                DataList<DataObject> devices = ret.getDataObject("response").getDataList("data");
                                                if (devices != null) {
                                                    for (DataObject dev : devices) {
                                                        String dev_id = dev.getNumId();
                                                        out.println("<option value=\"" + dev_id + "\" " + (dev_id.equals(device) ? "selected" : "") + ">" + dev.getString("name") + "</option>");
                                                    }
                                                }
                                            }
                                        %>    
                                        </select>
                                    </div>
                                </div>                
                                    
                                <div class="form-group has-feedback">
                                    <label class="col-sm-2 control-label">Active</label><br>
                                    <div class="col-sm-10 control-switch">
                                        <input name="active" id="link_active" type="checkbox" <%=active.equals("true")?"checked":""%> class="checkbox-inline">
                                    </div>
                                </div>                                       
                                
                                <!-- text input -->
                                <div class="form-group has-feedback">
                                    <label class="col-sm-2 control-label">Entity ID</label>
                                    <div class="col-sm-10">
                                        <input name="entityId" value="<%=entityId%>" type="text" class="form-control" placeholder="Enter ..." required>
                                    </div>
                                </div>

                                <!-- textarea -->
                                <div class="form-group has-feedback">
                                    <label class="col-sm-2 control-label">Entity Definition</label>
                                    <div class="col-sm-10">
                                        <textarea name="entityDef" id="code" class="form-control" rows="3" placeholder="Enter ..."><%=entityDef%></textarea>
                                    </div>
                                    <script type="text/javascript">

                                        var myCodeMirror = CodeMirror.fromTextArea(code, {
                                            mode: "text/javascript",
                                            smartIndent: true,
                                            lineNumbers: true,
                                            styleActiveLine: true,
                                            matchBrackets: true,
                                            autoCloseBrackets: true,
                                            theme: "eclipse",
                                            continueComments: "Enter",
                                            extraKeys: {"Ctrl-Space": "autocomplete","Ctrl-Q": "toggleComment","Ctrl-J": "toMatchingTag"},
                                            matchTags: {bothTags: true},                  

                                            gutters: ["CodeMirror-lint-markers"],
                                            lint: true,

                                        });
                                        myCodeMirror.setSize("100%", 300);

                                        $('a[data-toggle="tab"]').on('shown.bs.tab', function(e) {
                                            myCodeMirror.refresh();
                                            //console.log('shown.bs.tab', e);
                                        });

                                    </script>                                        
                                </div>

                                <div class="form-group has-feedback">
                                    <label class="col-sm-2 control-label">Server URL</label>
                                    <div class="col-sm-10">
                                        <input name="serverURL" value="<%=serverURL%>" type="text" class="form-control" placeholder="Enter Server URL" required>
                                    </div>
                                </div>    

                                <div class="form-group has-feedback">
                                    <label class="col-sm-2 control-label">Auth URL</label>
                                    <div class="col-sm-10">
                                        <input name="authUrl" value="<%=authUrl%>" type="text" class="form-control" placeholder="Enter ...">
                                    </div>
                                </div>    

                                <div class="form-group has-feedback">
                                    <label class="col-sm-2 control-label">Auth User</label>
                                    <div class="col-sm-10">
                                        <input name="auth_usr" value="<%=auth_user%>" type="text" class="form-control" placeholder="Enter ..." autocomplete="off">
                                    </div>
                                </div> 

                                <div class="form-group has-feedback">
                                    <label class="col-sm-2 control-label">Auth Password</label>
                                    <div class="col-sm-10">
                                        <input name="auth_pwd" value="<%=auth_passwd%>" type="password" class="form-control" placeholder="Enter ..." autocomplete="new-password">
                                    </div>
                                </div>                                                   

                            </div><!-- /.box-body -->

                            <div class="box-footer">
                                <button type="submit" class="btn btn-primary disabled" onclick="this.form.code.value=myCodeMirror.getValue();return true;">Submit</button>
                                <button class="btn btn-danger" onclick="return removeObj(this);">Delete</button>  
                            </div>
                        </form>     
                                
                        <script type="text/javascript">
                            $("#link_active").bootstrapSwitch();  
    
                            function removeObj(alink){
                                    if(confirm('Are you sure to remove this DeviceLink?')){
                                        var urlRemove = 'linkOCBDetail?ID=<%=id%>&act=remove';
                                        loadContent(urlRemove,"#main_content");
                                    }
                                return false;
                             }
                        </script>                                  
                    </div><!-- /.tab-pane -->
<!--
                    <div class="tab-pane" id="tab_2">
                        Loading...
                    </div><!-- /.tab-pane -- >
                    
                    <div class="tab-pane" id="tab_3">
                        Loading...
                        <!--jsp:include page="data.jsp" /-- >
                    </div><!-- /.tab-pane -- >    
                    
                    <div class="tab-pane" id="tab_4">
                        Loading...
                        <!--jsp:include page="data.jsp" /-- >
                    </div><!-- /.tab-pane -- >
-->                          
                </div><!-- /.tab-content -->
            </div><!-- nav-tabs-custom -->
        </div><!-- /.col -->
    </div> <!-- /.row -->
    <!-- END CUSTOM TABS -->
</section>





