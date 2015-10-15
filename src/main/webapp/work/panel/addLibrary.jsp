<%-- 
    Document   : addLibrary
    Created on : 24/09/2015, 11:59:05 AM
    Author     : javier.solis
--%>
<%@page import="io.cloudino.utils.Utils"%>
<%@page import="java.net.URL"%>
<%@page import="io.cloudino.utils.ParamsMgr"%>
<%@page import="java.util.Properties"%><%@page import="io.cloudino.compiler.ArdCompiler"%><%@page import="io.cloudino.engine.*"%><%@page import="java.util.ArrayList"%><%@page import="java.util.Iterator"%><%@page import="java.io.*"%><%@page import="java.net.URLEncoder"%><%@page contentType="text/html" pageEncoding="UTF-8"%><%@page import="org.semanticwb.datamanager.*"%>
<%!
    //Library Cache
    String libsLock="Libraries";
    DataObject libs=null;
    long libsUpdated=System.currentTimeMillis();
%>
<%
    ParamsMgr params = new ParamsMgr(request.getSession());
%>
<section class="content-header">
    <h1>
        Library Manager
        <small>Add Library</small>
    </h1>
    <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Panel</a></li>
        <li><a href="#">Libraries</a></li>
        <li class="active">Add Library</li>
    </ol>
</section>

<!-- Main content -->
<section class="content">
    <div class="row">
        <div class="col-md-12">

            <div class="box box-primary">
                <div class="box-header">
                    <h3 class="box-title">Libraries</h3>
                </div><!-- /.box-header -->

                <div class="row">
                    <div class="col-xs-12 table-responsive">
<%
    //Library Cache for 60 minutes
    if(libs==null || System.currentTimeMillis()-libsUpdated>1000*60*60)
    {
        synchronized(libsLock)
        {
            if(libs==null || System.currentTimeMillis()-libsUpdated>1000*60*60)
            {
                libs=Utils.readJsonFromUrl("http://downloads.arduino.cc/libraries/library_index.json");
                libsUpdated=System.currentTimeMillis();
            }
        }
    }
    
    //out.print(libs);
%>                        
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>name</th>
                                    <th>version</th>
                                    <th>author</th>
                                    <!--<th>maintainer</th>-->
                                    <th>sentence</th>
                                   <!-- <th>paragraph</th>-->
                                    <th>website</th>
                                    <th>category</th>
                                    <th>architectures</th>
                                </tr>
                            </thead>
                            <tbody>
<%
    DataList<DataObject> list=libs.getDataList("libraries");
    for(DataObject lib : list)
    {
        out.println("                                <tr>");
        out.println("                                   <td>"+lib.getString("name").replace('_', ' ')+"</td>");
        out.println("                                   <td>"+lib.getString("version")+"</td>");
        out.println("                                   <td>"+lib.getString("author")+"</td>");
        //out.println("                                   <td>"+lib.getString("maintainer")+"</td>");
        out.println("                                   <td>"+lib.getString("sentence")+"<br/>"+lib.getString("paragraph","")+"</td>");
        //out.println("                                   <td>"+lib.getString("paragraph")+"</td>");
        if(lib.getString("website")!=null && lib.getString("website").length()>0)
        {
            out.println("                                   <td><a href=\""+lib.getString("website")+"\">Website</a></td>");
        }else
        {
            out.println("                                   <td>-</td>");
        }
        out.println("                                   <td>"+lib.getString("category")+"</td>");
        out.println("                                   <td>"+lib.getString("architectures")+"</td>");
        out.println("                                </tr>");
    }
%>                                
                            </tbody>
                        </table>
                    </div><!-- /.col -->
                </div>

            </div>

        </div>

    </div>   <!-- /.row -->
</section><!-- /.content -->
