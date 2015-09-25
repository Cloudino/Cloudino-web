<%--  
    Document   : datasetDetail
    Created on : 23/09/2015, 07:27:50 PM
    Author     : juan.fernandez
--%><%@page contentType="text/html" pageEncoding="UTF-8"%><%@page import="java.net.URLEncoder"%><%@page import="java.io.*"%><%@page import="io.cloudino.compiler.*"%><%@page import="java.util.*"%><%@page import="io.cloudino.engine.*"%><%@page import="org.semanticwb.datamanager.*"%><%
    DataObject user = (DataObject) session.getAttribute("_USER_");
    SWBScriptEngine engine = DataMgr.getUserScriptEngine("/cloudino.js", user);
    SWBDataSource ds = engine.getDataSource("DataSet");

    String id = request.getParameter("ID");
    String act = request.getParameter("act");    

    DataObject dataset = null;

    dataset = ds.fetchObjByNumId(id);
    
//    System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
//    System.out.println("id:" + id);
//    System.out.println("dataset" + device);
//    System.out.println("data:" + data);
    //Security
    if (dataset == null || (dataset != null && !dataset.getString("user").equals(user.getId()))) {
        response.sendError(404);
        return;
    }
    
    
    //remove
    if("remove".equals(act))
    {
        ds.removeObjById(dataset.getId());
        out.println("<script type=\"text/javascript\">loadContent('/panel/menu?act=ds','.main-sidebar');</script>");
%>
            <!-- Custom Tabs -->

            <h3>Dataset was deleted...</h3>
<%
        return;
    }      
    
    
    

    //Update
    String name = request.getParameter("name");
    if (name != null) {
        dataset.put("name", name);
//        data.put("description", description);
//        data.put("type", type);
        DataObject ret = ds.updateObj(dataset);
        //System.out.println(ret);
        //DataObject obj = ret.getDataObject("response").getDataObject("data");
        if (ret != null) {
            response.sendRedirect("datasetDetail?ID=" + dataset.getNumId()+"&_rm=true");
            return;
        } else {
            out.println("Error updating object...");
            return;
        }
        
    }

    name = dataset.getString("name", "");

    /////////////////////////////////////////////////////////////
   
    if(request.getParameter("_rm")!=null)
    {
        out.println("<script type=\"text/javascript\">loadContent('/panel/menu?act=ds','.main-sidebar');</script>");
    }    
%>

<section class="content-header">
    <h1>Data Set<small> <%=name%></small></h1>
    <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Panel</a></li>
        <li><a href="#">Data Sets</a></li>
        <li class="active"><%=name%></li>
    </ol>
</section>

<section class="content">
    <!-- START CUSTOM TABS -->
    <div class="row">
        <div class="col-md-12">
            <!-- Custom Tabs -->
            <div class="nav-tabs-custom">
<!--                <ul class="nav nav-tabs">
                    <li class="active"><a href="#tab_1" data-toggle="tab" aria-expanded="true">General</a></li>
                    <li class=""><a href="#tab_5" data-toggle="tab" aria-expanded="false">Fields</a></li>
                    <li class="pull-right"><a class="dropdown-toggle" data-toggle="dropdown" href="#" aria-expanded="false"><i class="fa fa-gear"></i></a>
                        <ul class="dropdown-menu">
                            <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Delete</a></li>
                        </ul>
                    </li>
                </ul>-->
                <div class="tab-content">
                    <div class="tab-pane active" id="tab_1">

                        <form data-target=".content-wrapper" data-submit="ajax" action="datasetDetail" role="form">
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

                            </div><!-- /.box-body -->

                            <div class="box-footer">
                                <button type="submit" class="btn btn-primary disabled">Submit</button>
                                <button class="btn btn-danger" onclick="return removeObj(this);">Delete</a>  
                            </div>
                        </form>     
                                
                        <script type="text/javascript">
                            function removeObj(alink){
                                    if(confirm('Are you sure to remove this Dataset?')){
                                        var urlRemove = 'datasetDetail?ID=<%=id%>&act=remove';
                                        loadContent(urlRemove,"#tab_1");
                                        //alink.href=urlRemove;
                                        //alink.click(); 
                                    }
                                return false;
                             }
                        </script>                                

                    <div _class="tab-pane" id="tab_5">
                        <jsp:include page="fields.jsp" />
                    </div>
                                
                                
                    </div><!-- /.tab-pane -->

                    <!-- /.tab-pane -->
                </div><!-- /.tab-content -->
            </div><!-- nav-tabs-custom -->
        </div><!-- /.col -->
    </div> <!-- /.row -->
    <!-- END CUSTOM TABS -->
</section>

