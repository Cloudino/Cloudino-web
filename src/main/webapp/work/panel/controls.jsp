<%-- 
    Document   : controls
    Created on : 28/08/2015, 01:51:27 PM
    Author     : juan.fernandez
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="io.cloudino.engine.DeviceMgr"%>
<%@page import="java.io.File"%>
<%@page import="org.semanticwb.datamanager.*"%>
<%
    DataObject user = (DataObject) session.getAttribute("_USER_");
    SWBScriptEngine engine = DataMgr.getUserScriptEngine("/cloudino.js", user);
    SWBDataSource ds=engine.getDataSource("Control");
    
    //id del dispositivo
    String id = request.getParameter("ID");

    String title=request.getParameter("name");   
    String type=request.getParameter("buttonType");
    String topic=request.getParameter("topic");
    String message=request.getParameter("message");
    String act = request.getParameter("act");
    if(null==act) act = "";
    
//    System.out.println("ACCION: "+act+"  ==============================================================================");    
    
    if(act.equals("add")){

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

        
        DataObject control=new DataObject();
        control.put("user", user.getId());
        control.put("title", title);
        control.put("device", id);
        control.put("type", type);
        
        DataObject data=new DataObject();
        data.put("topic", topic);
        data.put("msg", message);
        
        control.put("data", data);
        
        DataObject ret=ds.addObj(control);

        DataObject obj=ret.getDataObject("response").getDataObject("data");
        if(obj!=null)
        {
            response.sendRedirect("controls?ID="+id);
            return;
        }
    } else if(act.equals("update")){

        String ctrlid = request.getParameter("ctrlid");
        DataObject doctrl = ds.fetchObjByNumId(ctrlid);

        //Lista de controles asociados al dispositivo
        
        if (doctrl != null) {
   
            doctrl.put("title", title);
            doctrl.put("device", id);
            doctrl.put("type", type);

            DataObject dodata = doctrl.getDataObject("data");

            dodata.put("topic", topic);
            dodata.put("msg", message);

            ds.updateObj(doctrl);
        }

        if(doctrl!=null)
        {
            response.sendRedirect("controls?ID="+id);
            return;
        }
    } else if(act.equals("remove")){

        String ctrlid = request.getParameter("ctrlid");
        DataObject doctrl = ds.removeObjById(ds.getBaseUri()+ctrlid);

        //System.out.println("Entro a REMOVE....");
        
        //Lista de controles asociados al dispositivo
        
        if (doctrl != null) {   
            //System.out.println("Encontro Control a eliminar ....");
            response.sendRedirect("controls?ID="+id);
            return;
        }

    } else if("".equals(act)){
    %>
<div> 
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
                                String ctrlid = contrl.getNumId();
                                DataObject doData = contrl.getDataObject("data");
                                String topico = doData.getString("topic");
                                String mssg = doData.getString("msg");
                                String titulo = contrl.getString("title");
                                out.println("<button class=\"btn btn-primary btn-flat\" onclick=\"WS.post('"+topico+"','"+mssg+"')\" >"+titulo+"</button>");
                            }
                        } 
%>
    </div>
    <a href="controls?ID=<%=id%>&act=new" data-target="#tab_5" data-load="ajax" title="Add new control"><i class="fa fa-plus-square-o"></i></a>
    <a href="controls?ID=<%=id%>&act=editlist" data-target="#tab_5" data-load="ajax" title="Edit controls"><i class="fa fa-edit"></i></a>
</div>
<%
    } else if("new".equals(act)){
%>

<div >

            <div class="box box-primary">
                <div class="box-header">
                    <h3 class="box-title">Add New Control</h3>
                </div><!-- /.box-header -->
                <!-- form start -->
                <form data-target="#tab_5" data-submit="ajax" action="controls" role="form" <%//=(isNewFile?"onsubmit=\"if(validateFileType())return true;\"":"")%>>
                    <div class="box-body">
                        <%
                        String placeHolderStr = "Enter control title ...";
                            %>
                            <input type="hidden" name="act" value="add"/>
                            <input type="hidden" name="ID" value="<%=id%>"/>
                        <!-- text input -->
                        <div class="form-group has-feedback">
                            <label>Title</label>
                            <input name="name" id="nombre" value="<%//=name%>" type="text" class="form-control" placeholder="<%=placeHolderStr%>" required>
                            <label>Type</label>
                            <select name="buttonType" id="skt" class="form-control">                                        
                                <option value="message" selected >Message</option>"); 
                            </select>
                            <label>Topic</label>
                            <input name="topic" id="topic" value="<%//=name%>" type="text" class="form-control" placeholder="Topic label..." required>
                            <label>Message</label>
                            <input name="message" id="message" value="<%//=name%>" type="text" class="form-control" placeholder="Topic message..." required>
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
    }  else if("editlist".equals(act)){
%>
        
<!--<div>  
    <div class="box box-primary">
        <div class="box-header">
            <h3 class="box-title">Existing Controls - select one of the list</h3>
        </div>
        <ul>-->
<%        
//        DataObject query = new DataObject();
//        DataObject data = new DataObject();
//        query.put("data", data);
//        data.put("user", user.getId());
//        data.put("device", id);
//        DataObject ret = ds.fetch(query);
//        //Lista de controles asociados al dispositivo
//        DataList<DataObject> controls = ret.getDataObject("response").getDataList("data");
//        if (controls != null) {
//            for (DataObject contrl : controls) {
//                String ctrlid = contrl.getNumId();
//                String titulo = contrl.getString("title");
//                out.println("<li><a data-target=\"#tab_5\" data-load=\"ajax\"  href=\"controls?ID="+id+"&act=edit&ctrlid="+ctrlid+"\">"+titulo+"</a></li>");
//            }
//        }    
%>
<!--        </ul>
    </div>
    <div class="box-footer">
        <a class="btn btn-primary" data-target="#tab_5" data-load="ajax"  href="controls?ID=<%//=id%>&act=">Cancel</a>                       
    </div>
</div>-->
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
                                String typeCTRL = contrl.getString("type","");
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
    }  else if("edit".equals(act)){
        String ctrlid = request.getParameter("ctrlid");
        DataObject doctrl = ds.fetchObjByNumId(ctrlid);
        
        //Lista de controles asociados al dispositivo
        
        if (doctrl != null) {
            
            title=doctrl.getString("title");
            type=doctrl.getString("type");
            
            DataObject doData = doctrl.getDataObject("data");
            
            topic=doData.getString("topic");
            message=doData.getString("msg");
        }
        
%>
        
<div >
            <div class="box box-primary">
                <div class="box-header">
                    <h3 class="box-title">Edit Control - <%=title%></h3>
                </div><!-- /.box-header -->
                <!-- form start -->
                <form data-target="#tab_5" data-submit="ajax" action="controls" role="form" <%//=(isNewFile?"onsubmit=\"if(validateFileType())return true;\"":"")%>>
                    <div class="box-body">
                        <%
                        String placeHolderStr = "Enter control title ...";
                            %>
                            <input type="hidden" name="act" value="update"/>
                            <input type="hidden" name="ID" value="<%=id%>"/>
                            <input type="hidden" name="ctrlid" value="<%=ctrlid%>"/>
                        <!-- text input -->
                        <div class="form-group has-feedback">
                            <label>Title</label>
                            <input name="name" id="nombre" value="<%=title%>" type="text" class="form-control" placeholder="<%=placeHolderStr%>" required>
                            <label>Type</label>
                            <select name="buttonType" id="skt" class="form-control">                                        
                                <option value="message" selected >Message</option>"); 
                            </select>
                            <label>Topic</label>
                            <input name="topic" id="topic" value="<%=topic%>" type="text" class="form-control" placeholder="Topic label..." required>
                            <label>Message</label>
                            <input name="message" id="message" value="<%=message%>" type="text" class="form-control" placeholder="Topic message..." required>
                        </div>
    
                    </div><!-- /.box-body -->

                    <div class="box-footer">
                        <button type="submit" class="btn btn-primary"  >Update</button>
                        <button class="btn btn-danger" onclick="removeControl(this)">Delete</button>                       
                        <a class="btn btn-primary" data-target="#tab_5" data-load="ajax"  href="controls?ID=<%=id%>">Cancel</a>                       
                    </div>
                </form>
                    <script type="text/javascript">
                        function removeControl(alink){
                            if(confirm('Are you sure to remove this control?')){
                                var urlRemove = 'controls?ID=<%=id%>&act=remove&ctrlid=<%=ctrlid%>' ;
                                loadContent(urlRemove,"#tab_5");
                                //alink.href=urlRemove;
                                //alink.click(); 
                            }    
                            return false;
                         }
                    </script>
            </div>
        </div>
<%
    } 
%>