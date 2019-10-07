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
    SWBDataSource ds = engine.getDataSource("DataStream");

    //id del datastream
    String id = request.getParameter("ID");
    // id del field
    String fID = request.getParameter("fID");

    DataObject datastream = ds.fetchObjByNumId(id);

    String title = request.getParameter("name");   // nombre DataStream

    String titleF = request.getParameter("titlef"); // title Field
    String nameF = request.getParameter("namef"); // name Field
    String typeF = request.getParameter("typef");
    String minValuef = request.getParameter("minValuef");
    String maxValuef = request.getParameter("maxValuef");

    String act = request.getParameter("act");

    if (null == act) {
        act = "";
    }

    //System.out.println("ACCION: "+act+"  ==============================================================================");    
    if (act.equals("add") && null != datastream) {

        DataList<DataObject> fields = datastream.getDataList("fields");
        if (fields == null) {
            fields = new DataList();
            datastream.put("fields", fields);
        }
        DataObject field = new DataObject();
        field.put("name", nameF);
        field.put("title", titleF);
        field.put("type", typeF);
        if (minValuef != null && !minValuef.isEmpty()) {
            Object val=Double.parseDouble(minValuef);
            if(typeF.equals("int"))val=(int)(double)val;
            field.put("minValue", val);
        }
        if (maxValuef != null && !maxValuef.isEmpty()) {
            Object val=Double.parseDouble(maxValuef);
            if(typeF.equals("int"))val=(int)(double)val;
            field.put("maxValue", val);
        }

        fields.add(field);
        ds.updateObj(datastream);

        if (datastream != null) {
            response.sendRedirect("dataStreamFields?ID=" + id);
            return;
        }
    } else if (act.equals("updateField")) {

        if (datastream != null) {

            DataList<DataObject> fields = datastream.getDataList("fields");
            for (DataObject field : fields) {
                String fieldName = field.getString("name");
                //System.out.println("Name: "+fieldName+","+fID+"===="+nameF+","+titleF);
                if (fID != null && fID.equals(fieldName)) {
                    field.put("name", nameF);
                    field.put("title", titleF);
                    field.put("type", typeF);
                    if (minValuef != null && !minValuef.isEmpty()) {
                        Object val=Double.parseDouble(minValuef);
                        if(typeF.equals("int"))val=(int)(double)val;
                        field.put("minValue", val);
                    }
                    if (maxValuef != null && !maxValuef.isEmpty()) {
                        Object val=Double.parseDouble(maxValuef);
                        if(typeF.equals("int"))val=(int)(double)val;
                        field.put("maxValue", val);
                    }
                    break;
                }
            }
            ds.updateObj(datastream);
        }

        if (datastream != null) {
            response.sendRedirect("dataStreamFields?ID=" + id + "&_rm=true");
            return;
        }
    } else if (act.equals("update")) {

        if (datastream != null) {

            datastream.put("title", title);
            ds.updateObj(datastream);
        }

        if (datastream != null) {
            response.sendRedirect("dataStreamFields?ID=" + id + "&_rm=true");
            return;
        }
    } else if (act.equals("remove")) {

        DataList<DataObject> fields = datastream.getDataList("fields");
        for (DataObject field : fields) {
            String fieldName = field.getString("name");
            //System.out.println("Name: "+fieldName+","+fID+"===="+nameF+","+titleF);
            if (fID != null && fID.equals(fieldName)) {
                fields.remove(field);
                break;
            }
        }
        ds.updateObj(datastream);

        if (datastream != null) {
            response.sendRedirect("dataStreamFields?ID=" + id);
            return;
        }

    } else if ("".equals(act)) {
%>

<!--<a href="fields?ID=<%//=id%>&act=editlist" data-target="#tab_2" data-load="ajax" title="Edit Fields"><i class="fa fa-edit"></i></a>-->
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
                        <th>Title</th>
                        <th>Type</th>
                        <th>Min Value</th>
                        <th>Max Value</th>
                        <th>&nbsp;</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        //Lista de fields asociados al datastream
                        DataList<DataObject> fields = datastream.getDataList("fields");
                        if (fields != null) {
                            for (DataObject field : fields) {
                                //String fieldID = field.getNumId();
                                String nombre = field.getString("name");
                                String titulo = field.getString("title");
                                String tipo = field.getString("type");
                                String minValue = field.getString("minValue", "-");
                                String maxValue = field.getString("maxValue", "-");
                    %>
                    <tr>
                      <!--<td><a href="#"><%//=fieldID%></a></td>-->
                        <td><%=nombre%></td>
                        <td><%=titulo%></td>
                        <td><%=tipo%></td>
                        <td><%=minValue%></td>
                        <td><%=maxValue%></td>
                        <td><a data-target="#tab_2" data-load="ajax"  href="dataStreamFields?ID=<%=id%>&act=edit&fID=<%=nombre%>"><i class="fa fa-edit"></i></a></td>
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
        <a href="dataStreamFields?ID=<%=id%>&act=new" data-target="#tab_2" data-load="ajax" title="Add new Field" class="btn btn-primary pull-left">Add New Field</a>

        <!--<a href="javascript::;" class="btn btn-sm btn-default btn-flat pull-right">View All Orders</a>-->
    </div><!-- /.box-footer -->
</div><!-- /.box -->
<%
} else if ("new".equals(act)) {
%>

<div >

    <div class="box box-primary">
        <div class="box-header">
            <h3 class="box-title">Add New Field</h3>
        </div><!-- /.box-header -->
        <!-- form start -->
        <form data-target="#tab_2" data-submit="ajax" action="dataStreamFields" role="form" <%//=(isNewFile?"onsubmit=\"if(validateFileType())return true;\"":"")%>>
            <div class="box-body">

                <input type="hidden" name="act" value="add"/>
                <input type="hidden" name="ID" value="<%=id%>"/>
                <!-- text input -->
                <div class="form-group has-feedback">
                    <label>Name</label>
                    <input name="namef" id="namef" value="" type="text" class="form-control" placeholder="Property Name" required>
                    <label>Title</label>
                    <input name="titlef" id="titlef" value="" type="text" class="form-control" placeholder="Property Title" required>
                    <label>Type</label>                            
                    <select name="typef" class="form-control" onchange="if (value == 'int' || value == 'double')
                                $('#MinMax').show();
                            else
                                $('#MinMax').hide()">
                        <option value="string">String</option>
                        <option value="int">Int</option>
                        <option value="double">Double</option>
                        <option value="boolean">Boolean</option>
                    </select>        
                    <div id="MinMax" style="display: none">
                        <label>Min Value</label>
                        <input name="minValuef" id="minValuef" value="" type="number" step="any" class="form-control" placeholder="Min Value">
                        <label>Max Value</label>
                        <input name="maxValuef" id="maxValuef" value="" type="number" step="any" class="form-control" placeholder="Max Value">
                    </div>
                </div>

            </div><!-- /.box-body -->

            <div class="box-footer">
                <button type="submit" class="btn btn-primary"  <%//=(isNewFile?"onclick=\"if(validateFileType()){return true;}else{ return false;}\"":"")%> >Submit</button>
                <a class="btn btn-primary" data-target="#tab_2" data-load="ajax"  href="dataStreamFields?ID=<%=id%>&act=">Cancel</a>                       
            </div>
        </form>

    </div>

</div>

<%
} else if ("editlist".equals(act)) {
%>

<div>  
    <div class="box box-primary">
        <div class="box-header">
            <h3 class="box-title">Existing Fields - select one of the list</h3>
        </div>
        <ul>
            <%
                DataList<DataObject> fields = datastream.getDataList("fields");
                if (fields != null) {
                    for (DataObject field : fields) {
                        String fldID = field.getNumId();
                        String titulo = field.getString("title");
                        out.println("<li><a data-target=\"#tab_2\" data-load=\"ajax\"  href=\"dataStreamFields?ID=" + id + "&act=edit&fieldID=" + fldID + "\">" + titulo + "</a></li>");
                    }
                }
            %>
        </ul>
    </div>
    <div class="box-footer">
        <a class="btn btn-primary" data-target="#tab_2" data-load="ajax"  href="dataStreamFields?ID=<%=id%>&act=">Cancel</a>                       
    </div>
</div>

<%
} else if ("edit".equals(act)) {

    //Lista de fields asociados al datastream
    if (datastream != null) {

        DataList<DataObject> fields = datastream.getDataList("fields");
        for (DataObject field : fields) {
            String fid = field.getString("name");
            if (null != fID && fid.equals(fID)) {
                titleF = field.getString("title");
                nameF = field.getString("name");
                typeF = field.getString("type");
                minValuef = field.getString("minValue", "");
                maxValuef = field.getString("maxValue", "");
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
        <form data-target="#tab_2" data-submit="ajax" action="dataStreamFields" role="form" <%//=(isNewFile?"onsubmit=\"if(validateFileType())return true;\"":"")%>>
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
                    <label>Type</label>                            
                    <select name="typef" class="form-control" onchange="if (value == 'int' || value == 'double')
                                $('#MinMax').show();else
                                $('#MinMax').hide()">
                        <option value="string" <%=typeF.equals("string") ? "selected" : ""%>>String</option>
                        <option value="int" <%=typeF.equals("int") ? "selected" : ""%>>Int</option>
                        <option value="double" <%=typeF.equals("double") ? "selected" : ""%>>Double</option>
                        <option value="boolean" <%=typeF.equals("boolean") ? "selected" : ""%>>Boolean</option>
                    </select>   
                    <div id="MinMax" style="display: <%=(typeF.equals("int") || typeF.equals("double")) ? "block" : "none"%>">
                        <label>Min Value</label>
                        <input name="minValuef" id="minValuef" value="<%=minValuef%>" type="number" step="any" class="form-control" placeholder="Min Value">
                        <label>Max Value</label>
                        <input name="maxValuef" id="maxValuef" value="<%=maxValuef%>" type="number" step="any" class="form-control" placeholder="Max Value">
                    </div>                            
                </div>

            </div><!-- /.box-body -->

            <div class="box-footer">
                <button type="submit" class="btn btn-primary"  >Update</button>
                <button class="btn btn-danger" onclick="removeField(this)">Delete</button>                       
                <a class="btn btn-primary" data-target="#tab_2" data-load="ajax"  href="dataStreamFields?ID=<%=id%>">Cancel</a>                       
            </div>
        </form>
        <script type="text/javascript">
            function removeField(alink) {
                if (confirm('Are you sure to remove this field?')) {
                    var urlRemove = 'dataStreamFields?ID=<%=id%>&act=remove&fID=<%=fID%>';
                    loadContent(urlRemove, "#tab_2");
                }
                return false;
            }
        </script>
    </div>
</div>
<%
    }
%>