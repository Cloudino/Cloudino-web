<%--  
    Document   : objDetail
    Created on : 23/09/2015, 07:27:50 PM
    Author     : javier.solis
--%><%@page contentType="text/html" pageEncoding="UTF-8"%><%@page import="java.net.URLEncoder"%><%@page import="java.io.*"%><%@page import="io.cloudino.compiler.*"%><%@page import="java.util.*"%><%@page import="io.cloudino.engine.*"%><%@page import="org.semanticwb.datamanager.*"%><%
    DataObject user = (DataObject) session.getAttribute("_USER_");
    String id = request.getParameter("ID");
    String act = request.getParameter("act");    
    
    if(request.getParameter("_rm")!=null)
    {
        out.println("<script type=\"text/javascript\">loadContent('/panel/arduino?act=bl','#arduino');</script>");
    }   
%>

<section class="content-header">
    <h1>Block<small> <%=id%></small></h1>
    <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Panel</a></li>
        <li><a href="#">Arduino</a></li>
        <li><a href="#">Blocks</a></li>
        <li class="active"><%=id%></li>
    </ol>
</section>

<section class="content">
    <!-- START CUSTOM TABS -->
    <div class="row">
        <div class="col-md-12" id="main_content">
            <!-- Custom Tabs -->
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <li class="active"><a href="#tab_1" data-toggle="tab" aria-expanded="true">Blocks</a></li>
                    <li class=""><a href="#tab_2" data-toggle="tab" aria-expanded="false">Code</a></li>
                </ul>
                <div class="tab-content">
                    <div class="tab-pane active" id="tab_1">
                        <jsp:include page="block.jsp"/>
                    </div><!-- /.tab-pane -->
                    <div class="tab-pane" id="tab_2">
                        <jsp:include page="blockCode.jsp"/>
                    </div><!-- /.tab-pane -->
                    
                </div><!-- /.tab-content -->
            </div><!-- nav-tabs-custom -->
        </div><!-- /.col -->
    </div> <!-- /.row -->
    <!-- END CUSTOM TABS -->
</section>

