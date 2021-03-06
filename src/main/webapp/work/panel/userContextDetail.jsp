<%--  
    Document   : objDetail
    Created on : 23/09/2015, 07:27:50 PM
    Author     : juan.fernandez
--%><%@page contentType="text/html" pageEncoding="UTF-8"%><%@page import="java.net.URLEncoder"%><%@page import="java.io.*"%><%@page import="io.cloudino.compiler.*"%><%@page import="java.util.*"%><%@page import="io.cloudino.engine.*"%><%@page import="org.semanticwb.datamanager.*"%><%
    DataObject user = (DataObject) session.getAttribute("_USER_");
    SWBScriptEngine engine = DataMgr.getUserScriptEngine("/cloudino.js", user);
    SWBDataSource ds = engine.getDataSource("UserContext");

    String id = request.getParameter("ID");
    String act = request.getParameter("act");    

    DataObject obj = null;

    obj = ds.fetchObjByNumId(id);
    
//    System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
//    System.out.println("id:" + id);
//    System.out.println("obj" + device);
//    System.out.println("data:" + data);
    //Security
    if (obj == null || (obj != null && !obj.getString("user").equals(user.getId()))) {
        response.sendError(404);
        return;
    }
    
    
    //remove
    if("remove".equals(act))
    {
        ds.removeObjById(obj.getId());
        out.println("<script type=\"text/javascript\">loadContent('/panel/menu?act=uc','.main-sidebar');</script>");
%>
            <!-- Custom Tabs -->
            <div class="nav-tabs-custom">
                <div class="tab-content">
                    <div class="tab-pane active" id="tab_1">
                        <h3>User Context deleted...</h3>
                    </div><!-- /.tab-pane -->
                </div>    
            </div>
<%
        return;
    }      
    
    
    

    //Update
    String name = request.getParameter("name");
    String description = request.getParameter("description");
    if (name != null) {
        obj.put("name", name);
        obj.put("description", description);
        DataObject ret = ds.updateObj(obj);
        //System.out.println(ret);
        if (ret != null) {
            response.sendRedirect("userContextDetail?ID=" + obj.getNumId()+"&_rm=true");
            return;
        } else {
            out.println("Error updating object...");
            return;
        }
        
    }

    name = obj.getString("name", "");
    description = obj.getString("description", "");

    /////////////////////////////////////////////////////////////
   
    if(request.getParameter("_rm")!=null)
    {
        out.println("<script type=\"text/javascript\">loadContent('/panel/menu?act=uc','.main-sidebar');</script>");
    }    
%>

<section class="content-header">
    <h1>User Context<small> <%=name%></small></h1>
    <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Panel</a></li>
        <li><a href="#">User Context</a></li>
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
                    <!--<li class=""><a href="#tab_2" data-toggle="tab" aria-expanded="false">Fields</a></li>-->
                </ul>
                <div class="tab-content">
                    <div class="tab-pane active" id="tab_1">

                        <form class="form-horizontal" data-target=".content-wrapper" data-submit="ajax" action="userContextDetail" role="form">
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
                                        <input name="name" value="<%=name%>" type="text" class="form-control" placeholder="Enter ..." required="true">
                                    </div>
                                </div>
                                
                                <div class="form-group has-feedback">
                                    <label class="col-sm-2 control-label">Description</label>
                                    <div class="col-sm-10">
                                        <textarea name="description" class="form-control" rows="3" placeholder="Enter ..."><%=description%></textarea>
                                    </div>
                                </div>

                            </div><!-- /.box-body -->

                            <div class="box-footer">
                                <button type="submit" class="btn btn-primary disabled">Submit</button>
                                <button class="btn btn-danger" onclick="return removeObj(this);">Delete</button>  
                            </div>
                        </form>     
                                
                        <script type="text/javascript">
                            function removeObj(alink){
                                    if(confirm('Are you sure to remove this User Context?')){
                                        var urlRemove = 'userContextDetail?ID=<%=id%>&act=remove';
                                        loadContent(urlRemove,"#main_content");
                                    }
                                return false;
                             }
                        </script>                                  
                    </div><!-- /.tab-pane -->
<!--
                    <div class="tab-pane" id="tab_2">
                        <!--jsp:include page="fields.jsp" /-- >
                    </div><!-- /.tab-pane -- >
-->                    
                </div><!-- /.tab-content -->
            </div><!-- nav-tabs-custom -->
        </div><!-- /.col -->
    </div> <!-- /.row -->
    <!-- END CUSTOM TABS -->
</section>

