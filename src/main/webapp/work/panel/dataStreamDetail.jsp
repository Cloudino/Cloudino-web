<%--  
    Document   : dataStreamDetail
    Created on : 23/09/2015, 07:27:50 PM
    Author     : juan.fernandez
--%><%@page import="io.cloudino.datastreams.DataStreamMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%><%@page import="java.net.URLEncoder"%><%@page import="java.io.*"%><%@page import="io.cloudino.compiler.*"%><%@page import="java.util.*"%><%@page import="io.cloudino.engine.*"%><%@page import="org.semanticwb.datamanager.*"%><%
    DataObject user = (DataObject) session.getAttribute("_USER_");
    SWBScriptEngine engine = DataMgr.getUserScriptEngine("/cloudino.js", user);
    SWBDataSource ds = engine.getDataSource("DataStream");

    String id = request.getParameter("ID");
    String act = request.getParameter("act");    

    DataObject datastream = null;

    datastream = ds.fetchObjByNumId(id);
    
//    System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
//    System.out.println("id:" + id);
//    System.out.println("datastream" + device);
//    System.out.println("data:" + data);
    //Security
    if (datastream == null || (datastream != null && !datastream.getString("user").equals(user.getId()))) {
        response.sendError(404);
        return;
    }
    
    
    //remove
    if("remove".equals(act))
    {
        ds.removeObjById(datastream.getId());
        
        DataStreamMgr.getInstance().clearCache(id);
        DataStreamMgr.getInstance().clearCache(datastream.getString("user"), datastream.getString("topic"));
        
        out.println("<script type=\"text/javascript\">loadContent('/panel/menu?act=ds','.main-sidebar');</script>");
%>
            <!-- Custom Tabs -->
            <div class="nav-tabs-custom">
                <div class="tab-content">
                    <div class="tab-pane active" id="tab_1">
                        <h3>DataStream was deleted...</h3>
                    </div><!-- /.tab-pane -->
                </div>    
            </div>
<%
        return;
    }      
    
    //Update
    String name = request.getParameter("name");
    String topic = request.getParameter("topic");
    String description = request.getParameter("description");
    String active=request.getParameter("active")!=null?"true":"false";

    if (name != null) {

        datastream.put("name", name);
        datastream.put("topic", topic);
        datastream.put("description", description);
        datastream.put("active", Boolean.parseBoolean(active));

//        data.put("type", type);
        DataObject ret = ds.updateObj(datastream);

        DataStreamMgr.getInstance().clearCache(id);
        DataStreamMgr.getInstance().clearCache(datastream.getString("user"), datastream.getString("topic"));

        //System.out.println(ret);
        //DataObject obj = ret.getDataObject("response").getDataObject("data");
        if (ret != null) {
            response.sendRedirect("dataStreamDetail?ID=" + datastream.getNumId()+"&_rm=true");
            return;
        } else {
            out.println("Error updating object...");
            return;
        }
        
    }

    name = datastream.getString("name", "");
    topic = datastream.getString("topic", "");
    description = datastream.getString("description", "");
    active = datastream.getString("active", "false");

    /////////////////////////////////////////////////////////////
   
    if(request.getParameter("_rm")!=null)
    {
        out.println("<script type=\"text/javascript\">loadContent('/panel/menu?act=ds','.main-sidebar');</script>");
    }    
%>

<section class="content-header">
    <h1>DataStream<small> <%=name%></small></h1>
    <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Panel</a></li>
        <li><a href="#">DataStreams</a></li>
        <li class="active"><%=name%></li>
    </ol>
</section>

<section class="content">
    <!-- START CUSTOM TABS -->
    <div class="row">
        <div class="col-md-12" id="main_content">
            <!-- Custom Tabs -->
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <li class="active"><a href="#tab_1" data-toggle="tab" aria-expanded="true">General</a></li>
                    <li class=""><a href="#tab_2" data-toggle="tab" aria-expanded="false">Fields</a></li>
                    <li class=""><a href="#tab_3" data-toggle="tab" aria-expanded="false" ondblclick="loadContent('/work/panel/dataStreamData.jsp?ID=<%=id%>','#tab_3')" onclick="this.onclick=undefined;this.ondblclick();">Data</a></li>
                    <li class=""><a href="#tab_4" data-toggle="tab" aria-expanded="false" ondblclick="loadContent('/work/panel/dataStreamGraphs.jsp?ID=<%=id%>','#tab_4')" onclick="this.onclick=undefined;this.ondblclick();">Graphs</a></li>
                    <li class=""><a href="#tab_5" data-toggle="tab" aria-expanded="false" ondblclick="loadContent('/work/panel/dataStreamExport.jsp?ID=<%=id%>','#tab_5')" onclick="this.onclick=undefined;this.ondblclick();">Export</a></li>
                </ul>
                <div class="tab-content">
                    <div class="tab-pane active" id="tab_1">

                        <form class="form-horizontal" data-target=".content-wrapper" data-submit="ajax" action="dataStreamDetail" role="form">
                            <div class="box-body">

                                <div class="form-group has-feedback">
                                    <label class="col-sm-2 control-label">Id</label>
                                    <div class="col-sm-10 control-text"><%=id%></div>
                                    <input type="hidden" name="ID" value="<%=id%>">
                                </div>  

                                <!-- text input -->
                                <div class="form-group has-feedback">
                                    <label class="col-sm-2 control-label">Name</label>
                                    <div class="col-sm-10">
                                        <input name="name" value="<%=name%>" type="text" class="form-control" placeholder="Enter the name of the DataStream" required="true">
                                    </div>
                                </div>
                                
                                <!-- text input -->
                                <div class="form-group has-feedback">
                                    <label class="col-sm-2 control-label">Topic</label>
                                    <div class="col-sm-10">
                                        <input name="topic" value="<%=topic%>" type="text" class="form-control" placeholder="Enter the Topic of the DataStream" required="true">
                                    </div>
                                </div>
                                
                                <div class="form-group has-feedback">
                                    <label class="col-sm-2 control-label">Description</label>
                                    <div class="col-sm-10">
                                        <textarea name="description" class="form-control" rows="3" placeholder="Enter description"><%=description%></textarea>
                                    </div>
                                </div>
                                
                                <div class="form-group has-feedback">
                                    <label class="col-sm-2 control-label">Active</label><br>
                                    <div class="col-sm-10 control-switch">
                                        <input name="active" id="link_active" type="checkbox" <%=active.equals("true")?"checked":""%> class="checkbox-inline">
                                    </div>
                                </div>                                      

                            </div><!-- /.box-body -->

                            <div class="box-footer">
                                <button type="submit" class="btn btn-primary disabled">Submit</button>
                                <button class="btn btn-danger" onclick="return removeObj(this);">Delete</button>  
                            </div>
                        </form>     
                                
                        <script type="text/javascript">
                            $("#link_active").bootstrapSwitch();  
                            function removeObj(alink){
                                    if(confirm('Are you sure to remove this DataStream?')){
                                        var urlRemove = 'dataStreamDetail?ID=<%=id%>&act=remove';
                                        loadContent(urlRemove,"#main_content");
                                    }
                                return false;
                             }
                        </script>                                  
                    </div><!-- /.tab-pane -->

                    <div class="tab-pane" id="tab_2">
                        <jsp:include page="dataStreamFields.jsp" />
                    </div><!-- /.tab-pane -->
                    
                    <div class="tab-pane" id="tab_3">
                        Loading...
                        <!--jsp:include page="data.jsp" /-->
                    </div><!-- /.tab-pane -->    
                    
                    <div class="tab-pane" id="tab_4">
                        Loading...
                        <!--jsp:include page="data.jsp" /-->
                    </div><!-- /.tab-pane -->    
                    <div class="tab-pane" id="tab_5">
                        Loading...
                        <!--jsp:include page="data.jsp" /-->
                    </div><!-- /.tab-pane -->                      
                </div><!-- /.tab-content -->
            </div><!-- nav-tabs-custom -->
        </div><!-- /.col -->
    </div> <!-- /.row -->
    <!-- END CUSTOM TABS -->
</section>

