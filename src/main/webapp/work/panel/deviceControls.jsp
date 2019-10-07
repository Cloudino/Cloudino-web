<%-- 
    Document   : controls
    Created on : 28/08/2015, 01:51:27 PM
    Author     : juan.fernandez
--%>
<%@page import="io.cloudino.engine.Device"%>
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
    String sorder = request.getParameter("order");
    int order=0;
    if(sorder!=null && sorder.trim().length()>0)
    {
        try{order=Integer.parseInt(sorder);}catch(NumberFormatException e){}
    }
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
        control.put("order", order);

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
            response.sendRedirect("deviceControls?ID=" + id);
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
            control.put("order", order);

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
            response.sendRedirect("deviceControls?ID=" + id);
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
            response.sendRedirect("deviceControls?ID=" + id);
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
            DataList sort=new DataList();
            sort.add("order");
            query.addParam("sortBy", sort);
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
                    
                    Object value=null;                    
                    DataObject doData = contrl.getDataObject("data");
                    if(doData!=null)
                    {
                        String topic = doData.getString("topic");      
                        if(topic!=null)
                        {
                            Device device=DeviceMgr.getInstance().getDevice(id);
                            value=device.getDeviceData(topic);                            
                        }
                    }
                    if(value!=null)request.setAttribute("value", value);
                    else request.removeAttribute("value");                    
                    
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
    <a class="btn btn-primary" href="deviceControls?ID=<%=id%>&act=new" data-target="#tab_5" data-load="ajax" title="Add new control">Add Control</a>
    <a class="btn btn-primary" href="deviceControls?ID=<%=id%>&act=editlist" data-target="#tab_5" data-load="ajax" title="Edit controls">Edit Control</a>
    
    <div class="dropdown pull-right">
        <a href="#" class="btn btn-default" data-toggle="dropdown">
            <i class="fa fa-share-alt"></i>
            Share Controls
            <span class="dropdown-caret"></span>
        </a>
        <ul class="dropdown-menu" style="padding: 0px 0px 10px 0px; margin: 0;">
            <!-- User image -->
            <li class="share-header" style="color: white; text-align: center; width: 300px;padding: 10px; background-color: #3c8dbc;">
                <h4 class="mb-1">Share Device Controls</h4>
                <div class="input-group">
                    <input id="shareControls" type="text" style="width: 240px;" class="form-control input-monospace" value="<%=request.getRequestURL().substring(0,request.getRequestURL().indexOf("/work/"))+"/panel/dashboard?ID="+id%>" readonly="">                    
                    <i class="fa fa-clipboard fa-lg btn btn-default" title="Copy to Clipboard" onclick="copyText('shareControls');" style="padding: 9px; color: #3b8dbc;"></i>
                    <script>
                        function copyText(id) {
                          /* Get the text field */
                          var el = document.getElementById(id);
                          if (navigator.userAgent.match(/ipad|ipod|iphone/i)) {
                            var editable = el.contentEditable;
                            var readOnly = el.readOnly;
                            el.contentEditable = true;
                            el.readOnly = false;
                            var range = document.createRange();
                            range.selectNodeContents(el);
                            var sel = window.getSelection();
                            sel.removeAllRanges();
                            sel.addRange(range);
                            el.setSelectionRange(0, 999999);
                            el.contentEditable = editable;
                            el.readOnly = readOnly;
                          } else {
                            /* Select the text field */
                            el.select();
                          }  
                          /* Copy the text inside the text field */
                          document.execCommand("copy");
                        }                        
                    </script>
                </div>
            </li>
            <!-- Menu Footer-->
            <li class="share-footer" style="background-color: #f9f9f9; padding: 10px;">
                <div class="pull-left">
                    <a href="/panel/dashboard?ID=<%=id%>" target="new" class="btn btn-default btn-flat">This Device</a>
                </div>
                <div class="pull-right">
                    <a href="/panel/dashboard?view=ALL&ID=<%=id%>" target="new" class="btn btn-default btn-flat">All Devices</a>
                </div>
            </li>
        </ul>
    </div>
    
    <div class="dropdown-menu dropdown-menu-sw">

        <div class="get-repo-modal-options">
            <div class="clone-options https-clone-options">
                <!-- '"` --><!-- </textarea></xmp> --><form data-remote="true" action="/users/set_protocol?protocol_selector=ssh&amp;protocol_type=push" accept-charset="UTF-8" method="post"><input name="utf8" type="hidden" value="✓"><input type="hidden" name="authenticity_token" value="xZLSKkp0aguI1QU9AqfLrZTpoa1qURdsulf3e2BUwCdX/VpXg//AbAfB2jfiTJY6oLrVWlHQckmBjxNFBTx88g=="><button type="submit" class="btn-link btn-change-protocol js-toggler-target float-right">Use SSH</button></form>

                <h4 class="mb-1">
                    Clone with HTTPS
                    <a class="muted-link" href="https://help.github.com/articles/which-remote-url-should-i-use" target="_blank" title="Which remote URL should I use?">
                        <svg class="octicon octicon-question" viewBox="0 0 14 16" version="1.1" width="14" height="16" aria-hidden="true"><path fill-rule="evenodd" d="M6 10h2v2H6v-2zm4-3.5C10 8.64 8 9 8 9H6c0-.55.45-1 1-1h.5c.28 0 .5-.22.5-.5v-1c0-.28-.22-.5-.5-.5h-1c-.28 0-.5.22-.5.5V7H4c0-1.5 1.5-3 3-3s3 1 3 2.5zM7 2.3c3.14 0 5.7 2.56 5.7 5.7s-2.56 5.7-5.7 5.7A5.71 5.71 0 0 1 1.3 8c0-3.14 2.56-5.7 5.7-5.7zM7 1C3.14 1 0 4.14 0 8s3.14 7 7 7 7-3.14 7-7-3.14-7-7-7z"></path></svg>
                    </a>
                </h4>
                <p class="mb-2 get-repo-decription-text">
                    Use Git or checkout with SVN using the web URL.
                </p>

                <div class="input-group">
                    <input type="text" class="form-control input-monospace input-sm" data-autoselect="" value="https://github.com/Cloudino/Cloudino-Doc.git" aria-label="Clone this repository at https://github.com/Cloudino/Cloudino-Doc.git" readonly="">
                    <div class="input-group-button">
                        <clipboard-copy value="https://github.com/Cloudino/Cloudino-Doc.git" aria-label="Copy to clipboard" class="btn btn-sm" tabindex="0" role="button">
                            <svg class="octicon octicon-clippy" viewBox="0 0 14 16" version="1.1" width="14" height="16" aria-hidden="true"><path fill-rule="evenodd" d="M2 13h4v1H2v-1zm5-6H2v1h5V7zm2 3V8l-3 3 3 3v-2h5v-2H9zM4.5 9H2v1h2.5V9zM2 12h2.5v-1H2v1zm9 1h1v2c-.02.28-.11.52-.3.7-.19.18-.42.28-.7.3H1c-.55 0-1-.45-1-1V4c0-.55.45-1 1-1h3c0-1.11.89-2 2-2 1.11 0 2 .89 2 2h3c.55 0 1 .45 1 1v5h-1V6H1v9h10v-2zM2 5h8c0-.55-.45-1-1-1H8c-.55 0-1-.45-1-1s-.45-1-1-1-1 .45-1 1-.45 1-1 1H3c-.55 0-1 .45-1 1z"></path></svg>
                        </clipboard-copy>
                    </div>
                </div>

            </div>
            <div class="mt-2">
                <a href="github-mac://openRepo/https://github.com/Cloudino/Cloudino-Doc" class="btn btn-outline get-repo-btn tooltipped tooltipped-s tooltipped-multiline js-get-repo" data-open-app="mac" aria-label="Clone Cloudino/Cloudino-Doc to your computer and use it in GitHub Desktop.">
                    Open in Desktop
                </a>

                <a href="/Cloudino/Cloudino-Doc/archive/master.zip" class="btn btn-outline get-repo-btn" rel="nofollow" data-ga-click="Repository, download zip, location:repo overview">
                    Download ZIP
                </a>
            </div>
        </div>


    </div>
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
        <form data-target="#tab_5" data-submit="ajax" action="deviceControls" role="form" <%//=(isNewFile?"onsubmit=\"if(validateFileType())return true;\"":"")%>>
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
                            <option value="Time">Time</option>
                            <option value="Slider">Slider</option>
                            <option value="DblSlider">Range Slider</option>
                        </optgroup>
                        <optgroup label="Display Messages">
                            <option value="Display">Display</option>
                            <option value="Sparkline">Sparkline</option>    
                            <option value="Image">Image</option>    
                            <option value="ImageData">ImageData</option>    
                            <option value="Map">Map</option>    
                        </optgroup>
                    </select>
                    <label>Order</label>
                    <input name="order" id="order" value="" type="number" class="form-control" placeholder="Enter component order ...">
                    <hr/>
                    <div id="ext_controls">
                    </div>
                    <script type="text/javascript">loadContent('/panel/cntlButton?m=c','#ext_controls');</script>
                </div>

            </div><!-- /.box-body -->

            <div class="box-footer">
                <button type="submit" class="btn btn-primary"  <%//=(isNewFile?"onclick=\"if(validateFileType()){return true;}else{ return false;}\"":"")%> >Submit</button>
                <a class="btn btn-primary" data-target="#tab_5" data-load="ajax"  href="deviceControls?ID=<%=id%>&act=">Cancel</a>                       
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
                            <th>Topic</th>
                            <th>Order</th>
                            <th>&nbsp;</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            DataObject query = new DataObject();
                            DataList sort=new DataList();
                            sort.add("order");
                            query.addParam("sortBy", sort);
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
                                    DataObject dataCTRL=contrl.getDataObject("data");
                                    String topicCTRL = "";
                                    if(dataCTRL!=null)
                                    {
                                        topicCTRL =dataCTRL.getString("topic", "");
                                    }
                                    int orderCTRL = contrl.getInt("order",0);
                //            out.println("<li><a data-target=\"#tab_5\" data-load=\"ajax\"  href=\"controls?ID="+id+"&act=edit&ctrlid="+ctrlid+"\">"+titulo+"</a></li>");
%>
                        <tr>
                            <td><%=ctrlid%></td>
                            <td><%=tituloCTRL%></td>
                            <td><%=typeCTRL%></td>
                            <td><%=topicCTRL%></td>
                            <td><%=orderCTRL%></td>
                            <td><a data-target="#tab_5" data-load="ajax"  href="deviceControls?ID=<%=id%>&act=edit&ctrlid=<%=ctrlid%>"><i class="fa fa-edit"></i></a></td>
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
            <a class="btn btn-primary" data-target="#tab_5" data-load="ajax"  href="deviceControls?ID=<%=id%>&act=">Cancel</a>                       
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
            order = doctrl.getInt("order");
        }
        request.setAttribute("control", doctrl);
%>

<div >
    <div class="box box-primary">
        <div class="box-header">
            <h3 class="box-title">Edit Control - <%=title%></h3>
        </div><!-- /.box-header -->
        <!-- form start -->
        <form data-target="#tab_5" data-submit="ajax" action="deviceControls" role="form">
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
                    <label>Order</label>
                    <input name="order" id="order" value="<%=order%>" type="text" class="form-control" placeholder="Enter control order ..." required>
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
                <a class="btn btn-primary" data-target="#tab_5" data-load="ajax"  href="deviceControls?ID=<%=id%>">Cancel</a>                       
                <button class="btn btn-danger" onclick="removeControl(this)">Delete</button>                       
            </div>
        </form>
        <script type="text/javascript">
            function removeControl(alink) {
                if (confirm('Are you sure to remove this control?')) {
                    var urlRemove = 'deviceControls?ID=<%=id%>&act=remove&ctrlid=<%=ctrlid%>';
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