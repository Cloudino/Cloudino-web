<%-- 
    Document   : fields
    Created on : 24/09/2015, 01:34:40 PM
    Author     : juan.fernandez
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="io.cloudino.engine.DeviceMgr"%>
<%@page import="java.io.File"%>
<%@page import="org.semanticwb.datamanager.*"%>
<%
    DataObject user = (DataObject) session.getAttribute("_USER_");
    SWBScriptEngine engine = DataMgr.getUserScriptEngine("/cloudino.js", user);
    SWBDataSource ds=engine.getDataSource("DataSet");
    
    //id del dataset
    String id = request.getParameter("ID");
    // id del field
    String fID = request.getParameter("fID");

    
    DataObject dataset = ds.fetchObjByNumId(id);
    
    String title = request.getParameter("name");   // nombre DataSet

    String titleF = request.getParameter("titlef"); // title Field
    String nameF = request.getParameter("namef"); // nmae Field
    
    String act = request.getParameter("act");
    
    if(null==act) act = "";
    
    //System.out.println("ACCION: "+act+"  ==============================================================================");    
    
    if(act.equals("add")&&null!=dataset){

        DataList<DataObject> fields = dataset.getDataList("fields");
        if(fields==null){
            fields = new DataList();
            dataset.put("fields",fields);
        }
        DataObject field=new DataObject();
        field.put("name", nameF);
        field.put("title", titleF);
        
        fields.add(field);
        ds.updateObj(dataset);

        if(dataset!=null)
        {
            response.sendRedirect("fields?ID="+id);
            return;
        }
    } else if(act.equals("updateField")){
        
        if (dataset != null) {
            
            DataList<DataObject> fields = dataset.getDataList("fields");
            for(DataObject field:fields){
                String fieldName = field.getString("name");
                //System.out.println("Name: "+fieldName+","+fID+"===="+nameF+","+titleF);
                if(fID!=null&&fID.equals(fieldName)){
                    field.put("name", nameF);
                    field.put("title", titleF);
                    break;
                }
            }
            
            
            ds.updateObj(dataset);
        }

        if(dataset!=null)
        {
            response.sendRedirect("fields?ID="+id+"&_rm=true");
            return;
        }
    } else if(act.equals("update")){
        
        if (dataset != null) {
   
            dataset.put("title", title);
            ds.updateObj(dataset);
        }

        if(dataset!=null)
        {
            response.sendRedirect("fields?ID="+id+"&_rm=true");
            return;
        }
    } else if(act.equals("remove")){

         DataList<DataObject> fields = dataset.getDataList("fields");
            for(DataObject field:fields){
                String fieldName = field.getString("name");
                //System.out.println("Name: "+fieldName+","+fID+"===="+nameF+","+titleF);
                if(fID!=null&&fID.equals(fieldName)){
                    fields.remove(field);
                    break;
                }
            }
            ds.updateObj(dataset);
       
        if (dataset != null) {   
            response.sendRedirect("fields?ID="+id);
            return;
        }

    } else if("".equals(act)){
    %>
<!--<div> 
   <div> 
    
    </div>-->
    
    <!--<a href="fields?ID=<%//=id%>&act=editlist" data-target="#tab_5" data-load="ajax" title="Edit Fields"><i class="fa fa-edit"></i></a>-->
<!--</div>-->
    <!-- TABLE: LATEST ORDERS -->
              <div class="box box-info">
                <div class="box-header with-border">
                  <h3 class="box-title">Fields</h3>
                </div><!-- /.box-header -->
                <div class="box-body">
                  <div class="table-responsive">
                    <table class="table table-striped no-margin">
                      <thead>
                        <tr>
                          <!--<th>Id</th>-->
                          <th>Name</th>
                          <th>title</th>
                          <th>&nbsp;</th>
                        </tr>
                      </thead>
                      <tbody>
                            <%
                      
                        //Lista de fields asociados al dataset
                        DataList<DataObject> fields = dataset.getDataList("fields");
                        if (fields != null) {
                            for (DataObject field : fields) {
                                //String fieldID = field.getNumId();
                                String nombre = field.getString("name");
                                String titulo = field.getString("title");
                        %>
                        <tr>
                          <!--<td><a href="#"><%//=fieldID%></a></td>-->
                          <td><%=nombre%></td>
                          <td><%=titulo%></td>
                          <td><a data-target="#tab_5" data-load="ajax"  href="fields?ID=<%=id%>&act=edit&fID=<%=nombre%>"><i class="fa fa-edit"></i></a></td>
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
                    <a href="fields?ID=<%=id%>&act=new" data-target="#tab_5" data-load="ajax" title="Add new Field" class="btn btn-primary pull-left">Add New Field</a>
                  
                  <!--<a href="javascript::;" class="btn btn-sm btn-default btn-flat pull-right">View All Orders</a>-->
                </div><!-- /.box-footer -->
              </div><!-- /.box -->
<%
    } else if("new".equals(act)){
%>

<div >

            <div class="box box-primary">
                <div class="box-header">
                    <h3 class="box-title">Add New Field</h3>
                </div><!-- /.box-header -->
                <!-- form start -->
                <form data-target="#tab_5" data-submit="ajax" action="fields" role="form" <%//=(isNewFile?"onsubmit=\"if(validateFileType())return true;\"":"")%>>
                    <div class="box-body">

                            <input type="hidden" name="act" value="add"/>
                            <input type="hidden" name="ID" value="<%=id%>"/>
                        <!-- text input -->
                        <div class="form-group has-feedback">
                            <label>Name</label>
                            <input name="namef" id="namef" value="" type="text" class="form-control" placeholder="Enter field name ..." required>
                            <label>Title</label>
                            <input name="titlef" id="titlef" value="" type="text" class="form-control" placeholder="Enter field title ..." required>
                        </div>
    
                    </div><!-- /.box-body -->

                    <div class="box-footer">
                        <button type="submit" class="btn btn-primary"  <%//=(isNewFile?"onclick=\"if(validateFileType()){return true;}else{ return false;}\"":"")%> >Submit</button>
                        <a class="btn btn-primary" data-target="#tab_5" data-load="ajax"  href="fields?ID=<%=id%>&act=">Cancel</a>                       
                    </div>
                </form>
                    
            </div>

        </div>

<%
    }  else if("editlist".equals(act)){
%>
        
<div>  
    <div class="box box-primary">
        <div class="box-header">
            <h3 class="box-title">Existing Fields - select one of the list</h3>
        </div>
        <ul>
<%        
        DataList<DataObject> fields = dataset.getDataList("fields");
        if (fields != null) {
            for (DataObject field : fields) {
                String fldID = field.getNumId();
                String titulo = field.getString("title");
                out.println("<li><a data-target=\"#tab_5\" data-load=\"ajax\"  href=\"fields?ID="+id+"&act=edit&fieldID="+fldID+"\">"+titulo+"</a></li>");
            }
        }    
%>
        </ul>
    </div>
    <div class="box-footer">
        <a class="btn btn-primary" data-target="#tab_5" data-load="ajax"  href="fields?ID=<%=id%>&act=">Cancel</a>                       
    </div>
</div>

<%
    }  else if("edit".equals(act)){

        //Lista de fields asociados al dataset
        
        if (dataset != null) {

            DataList<DataObject> fields = dataset.getDataList("fields");
            for(DataObject field: fields){
                String fid = field.getString("name");
                if(null!=fID&&fid.equals(fID)){
                    titleF=field.getString("title");
                    nameF=field.getString("name");
                }
            }
            
        }
        
%>
        
<div >
            <div class="box box-primary">
                <div class="box-header">
                    <h3 class="box-title">Edit Field - <%=nameF%></h3>
                </div><!-- /.box-header -->
                <!-- form start -->
                <form data-target="#tab_5" data-submit="ajax" action="fields" role="form" <%//=(isNewFile?"onsubmit=\"if(validateFileType())return true;\"":"")%>>
                    <div class="box-body">
                            <input type="hidden" name="act" value="updateField"/>
                            <input type="hidden" name="ID" value="<%=id%>"/>
                            <input type="hidden" name="fID" value="<%=fID%>"/>
                        <!-- text input -->
                        <div class="form-group has-feedback">
                            <label>Name</label>
                            <input name="namef" id="namef" value="<%=nameF%>" type="text" class="form-control" placeholder="Filed name ..." required>
                            <label>Title</label>
                            <input name="titlef" id="titlef" value="<%=titleF%>" type="text" class="form-control" placeholder="Field title..." required>
                        </div>
    
                    </div><!-- /.box-body -->

                    <div class="box-footer">
                        <button type="submit" class="btn btn-primary"  >Update</button>
                        <a class="btn btn-primary" data-target="#tab_5" data-load="ajax"  onclick="removeField(this)">Delete</a>                       
                        <a class="btn btn-primary" data-target="#tab_5" data-load="ajax"  href="fields?ID=<%=id%>">Cancel</a>                       
                    </div>
                </form>
                    <script type="text/javascript">
                        function removeField(alink){
                                if(confirm('Are you sure to remove this field?')){
                                    var urlRemove = 'fields?ID=<%=id%>&act=remove&fID=<%=fID%>' ;
                                    alink.href=urlRemove;
                                    alink.click(); 
                                } else {
//                                    var urlRemove = 'controls?ID=<%=id%>' ;
//                                    alink.href=urlRemove;
//                                    alink.click();
                                    return false;
                                }    
                            return false;
                         }
                    </script>
            </div>
        </div>
<%
    } 
%>