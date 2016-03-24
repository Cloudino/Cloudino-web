<%-- 
    Document   : controls
    Created on : 28/08/2015, 01:51:27 PM
    Author     : juan.fernandez
--%>
<%@page import="io.cloudino.servlet.ResponseWrapper"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="java.io.CharArrayWriter"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="io.cloudino.engine.DeviceMgr"%>
<%@page import="java.io.File"%>
<%@page import="org.semanticwb.datamanager.*"%>
<%
    DataObject user = (DataObject) session.getAttribute("_USER_");
    SWBScriptEngine engine = DataMgr.getUserScriptEngine("/cloudino.js", user);
    SWBDataSource ds = engine.getDataSource("Control");

    //id del dispositivo
    String id = request.getParameter("ID");

    String title = request.getParameter("name");
    String type = request.getParameter("type");
    String act = request.getParameter("act");
    
    if (null == act) {
        act = "";
    }
    
//        fields:[
//        {name:"title",title:"Title",type:"string"},
//        {name:"device",title:"Device",type:"string"},
//        {name:"user",title:"User",type:"string"},
//        {name:"type",title:"Type",type:"string"},
//        {name:"data",title:"Data",type:"object", 
//            fields:[
//                {name:"topic",title:"Topic",type:"string"},
//                {name:"msg",title:"Message",type:"string"},
//            ]
//        },
//    ],     

//    System.out.println("ACCION: "+act+"  ==============================================================================");    
    if (act.equals("add")) {
        DataObject control = new DataObject();
        control.put("user", user.getId());
        control.put("title", title);
        control.put("device", id);
        control.put("type", type);

        DataObject data = new DataObject();
        control.put("data", data);
        request.setAttribute("data", data);
        RequestDispatcher req=request.getRequestDispatcher("cntl"+type+".jsp?m=u");
        try
        {
            HttpServletResponse responseWrapper = new ResponseWrapper(response);       
            req.include(request, responseWrapper);
        }catch(Exception e){e.printStackTrace();}

        DataObject ret = ds.addObj(control);
        DataObject obj = ret.getDataObject("response").getDataObject("data");
        if (obj != null) {
            response.sendRedirect("controls?ID=" + id);
            return;
        }
    } else if (act.equals("update")) {

        String ctrlid = request.getParameter("ctrlid");
        DataObject control = ds.fetchObjByNumId(ctrlid);

        //Lista de controles asociados al dispositivo
        if (control != null) {

            control.put("title", title);
            control.put("device", id);
            control.put("type", type);

            DataObject data = control.getDataObject("data");
            request.setAttribute("data", data);
            RequestDispatcher req=request.getRequestDispatcher("cntl"+type+".jsp?m=u");
            try
            {
                HttpServletResponse responseWrapper = new ResponseWrapper(response);
                req.include(request, responseWrapper);
            }catch(Exception e){e.printStackTrace();}

            ds.updateObj(control);
        }

        if (control != null) {
            response.sendRedirect("controls?ID=" + id);
            return;
        }
    } else if (act.equals("remove")) {

        String ctrlid = request.getParameter("ctrlid");
        DataObject doctrl = ds.fetchObjByNumId(ctrlid);
        if(doctrl.getString("user").equals(user.getId()))
        {
            doctrl=ds.removeObjById(ds.getBaseUri() + ctrlid);
        }
        
        //System.out.println("Entro a REMOVE....");
        //Lista de controles asociados al dispositivo
        if (doctrl != null) {
            //System.out.println("Encontro Control a eliminar ....");
            response.sendRedirect("controls?ID=" + id);
            return;
        }

    }else if ("".equals(act)) {
%>
<script type="text/javascript">WS.notify=[];</script>
<div> 
    <label>Controls</label>
    <div> 
        <%
            DataObject query = new DataObject();
            DataObject data = new DataObject();
            query.put("data", data);
            data.put("user", user.getId());
            data.put("device", id);
            DataObject ret = ds.fetch(query);
            //Lista de controles asociados al dispositivo
            DataList<DataObject> controls = ret.getDataObject("response").getDataList("data");
            if (controls != null) {
                for (DataObject contrl : controls) {
                    String ctrtype = contrl.getString("type");
                    request.setAttribute("control", contrl);
                    RequestDispatcher req=request.getRequestDispatcher("cntl"+ctrtype+".jsp");
                    try
                    {
                        HttpServletResponse responseWrapper = new ResponseWrapper(response);                    
                        req.include(request, responseWrapper);
                        out.println(responseWrapper);
                    }catch(Exception e){e.printStackTrace();}
                }
            }
        %>
    </div>
    <hr/>
    <a class="btn btn-primary" href="controls?ID=<%=id%>&act=new" data-target="#tab_5" data-load="ajax" title="Add new control">Add Control</a>
    <a class="btn btn-primary" href="controls?ID=<%=id%>&act=editlist" data-target="#tab_5" data-load="ajax" title="Edit controls">Edit Control</a>
</div>
<%
    } else if ("new".equals(act)) {
%>

<div>
    <div class="box box-primary">
        <div class="box-header">
            <h3 class="box-title">Add New Control</h3>
        </div><!-- /.box-header -->
        <!-- form start -->
        <form data-target="#tab_5" data-submit="ajax" action="controls" role="form" <%//=(isNewFile?"onsubmit=\"if(validateFileType())return true;\"":"")%>>
            <div class="box-body">
                <input type="hidden" name="act" value="add"/>
                <input type="hidden" name="ID" value="<%=id%>"/>
                <!-- text input -->
                <div class="form-group has-feedback">
                    <label>Title</label>
                    <input name="name" id="nombre" value="<%//=name%>" type="text" class="form-control" placeholder="Enter control title ..." required>
                    <label>Type</label>
                    <select name="type" id="skt" class="form-control" onchange="loadContent('/panel/cntl'+this.value+'?m=c','#ext_controls');"> 
                        <optgroup label="Send Messages">
                            <option value="Button">Button</option>
                            <option value="Switch">Switch</option>
                            <option value="Text">Text</option>
                            <option value="Slider">Slider</option>
                        </optgroup>
                        <optgroup label="Display Messages">
                            <option value="Display">Display</option>
                            <option value="Sparkline">Sparkline</option>    
                        </optgroup>
                    </select>
                    <hr/>
                    <div id="ext_controls">
                    </div>
                    <script type="text/javascript">loadContent('/panel/cntlButton?m=c','#ext_controls');</script>
                </div>

            </div><!-- /.box-body -->

            <div class="box-footer">
                <button type="submit" class="btn btn-primary"  <%//=(isNewFile?"onclick=\"if(validateFileType()){return true;}else{ return false;}\"":"")%> >Submit</button>
                <a class="btn btn-primary" data-target="#tab_5" data-load="ajax"  href="controls?ID=<%=id%>&act=">Cancel</a>                       
            </div>
        </form>
    </div>
</div>

<%
    } else if ("editlist".equals(act)) {
%>
<div>
    <!-- TABLE: LATEST ORDERS -->
    <div class="box box-info">
        <div class="box-header with-border">
            <h3 class="box-title">Existing Controls - select one of the list</h3>
        </div><!-- /.box-header -->
        <div class="box-body">
            <div class="table-responsive">
                <table class="table table-striped no-margin">
                    <thead>
                        <tr>
                            <!--<th>Id</th>-->
                            <th>Id</th>
                            <th>Title</th>
                            <th>Type</th>
                            <th>&nbsp;</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            DataObject query = new DataObject();
                            DataObject data = new DataObject();
                            query.put("data", data);
                            data.put("user", user.getId());
                            data.put("device", id);
                            DataObject ret = ds.fetch(query);
                            //Lista de controles asociados al dispositivo
                            DataList<DataObject> controls = ret.getDataObject("response").getDataList("data");
                            if (controls != null) {
                                for (DataObject contrl : controls) {
                                    String ctrlid = contrl.getNumId();
                                    String tituloCTRL = contrl.getString("title");
                                    String typeCTRL = contrl.getString("type", "");
                //            out.println("<li><a data-target=\"#tab_5\" data-load=\"ajax\"  href=\"controls?ID="+id+"&act=edit&ctrlid="+ctrlid+"\">"+titulo+"</a></li>");
%>
                        <tr>
                            <td><%=ctrlid%></td>
                            <td><%=tituloCTRL%></td>
                            <td><%=typeCTRL%></td>
                            <td><a data-target="#tab_5" data-load="ajax"  href="controls?ID=<%=id%>&act=edit&ctrlid=<%=ctrlid%>"><i class="fa fa-edit"></i></a></td>
                        </tr>
                        <%
                                }
                            }
                        %> 
                    </tbody>
                </table>
            </div><!-- /.table-responsive -->
        </div><!-- /.box-body -->
        <div class="box-footer clearfix">
            <!--<a href="fields?ID=<%//=id%>&act=new" data-target="#tab_5" data-load="ajax" title="Add new Field" class="btn btn-primary pull-left">Add New Field</a>-->
            <a class="btn btn-primary" data-target="#tab_5" data-load="ajax"  href="controls?ID=<%=id%>&act=">Cancel</a>                       
            <!--<a href="javascript::;" class="btn btn-sm btn-default btn-flat pull-right">View All Orders</a>-->
        </div><!-- /.box-footer -->
    </div><!-- /.box -->
</div>

<%
    } else if ("edit".equals(act)) {
        String ctrlid = request.getParameter("ctrlid");
        DataObject doctrl = ds.fetchObjByNumId(ctrlid);
            //Lista de controles asociados al dispositivo
        if (doctrl != null) {
            title = doctrl.getString("title");
            type = doctrl.getString("type");
        }
        request.setAttribute("control", doctrl);
%>

<div >
    <div class="box box-primary">
        <div class="box-header">
            <h3 class="box-title">Edit Control - <%=title%></h3>
        </div><!-- /.box-header -->
        <!-- form start -->
        <form data-target="#tab_5" data-submit="ajax" action="controls" role="form">
            <div class="box-body">
                <input type="hidden" name="act" value="update"/>
                <input type="hidden" name="ID" value="<%=id%>"/>
                <input type="hidden" name="ctrlid" value="<%=ctrlid%>"/>
                <!-- text input -->
                <div class="form-group has-feedback">
                    <label>Title</label>
                    <input name="name" id="nombre" value="<%=title%>" type="text" class="form-control" placeholder="Enter control title ..." required>
                    <label>Type</label>
                    <select name="type" id="skt" class="form-control">                                        
                        <option value="<%=type%>" selected ><%=type%></option>"); 
                    </select>
                    <hr/>
                    <%
                    RequestDispatcher req=request.getRequestDispatcher("cntl"+type+".jsp?m=c");
                    try
                    {
                        HttpServletResponse responseWrapper = new ResponseWrapper(response);                                 
                        req.include(request, responseWrapper);
                        out.println(responseWrapper);
                    }catch(Exception e){e.printStackTrace();}                    
                    %>
                </div>

            </div><!-- /.box-body -->

            <div class="box-footer">
                <button type="submit" class="btn btn-primary"  >Update</button>
                <a class="btn btn-primary" data-target="#tab_5" data-load="ajax"  href="controls?ID=<%=id%>">Cancel</a>                       
                <button class="btn btn-danger" onclick="removeControl(this)">Delete</button>                       
            </div>
        </form>
        <script type="text/javascript">
            function removeControl(alink) {
                if (confirm('Are you sure to remove this control?')) {
                    var urlRemove = 'controls?ID=<%=id%>&act=remove&ctrlid=<%=ctrlid%>';
                    loadContent(urlRemove, "#tab_5");
                }
                return false;
            }
        </script>
    </div>
</div>
<%
    }
%>