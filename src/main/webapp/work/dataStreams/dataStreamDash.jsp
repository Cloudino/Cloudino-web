<%-- 
    Document   : data
    Created on : 13/06/2017, 01:34:40 PM
    Author     : javier.solis
--%>
<%@page import="java.util.StringTokenizer"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Set"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="io.cloudino.engine.DeviceMgr"%>
<%@page import="java.io.File"%>
<%@page import="org.semanticwb.datamanager.*"%>
<%
    int maxRecs=50;
    int pag=0;
    DataObject user = (DataObject) session.getAttribute("_USER_");
    SWBScriptEngine engine = DataMgr.getUserScriptEngine("/cloudino.js", user);
    SWBDataSource ds = engine.getDataSource("DataStream");

    String uri=request.getRequestURI();
    StringTokenizer st=new StringTokenizer(uri,"/");
    String api=st.nextToken();
    String serv=st.nextToken();
    String id=null;
    String devid=null;
    if(st.hasMoreTokens())id=st.nextToken();
    if(st.hasMoreTokens())devid=st.nextToken();   

    DataObject datastream = ds.fetchObjByNumId(id);

    
//    System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
//    System.out.println("id:" + id);
//    System.out.println("datastream" + device);
//    System.out.println("data:" + data);
    //Security
    if (datastream == null || (datastream != null && !datastream.getString("user").equals(user.getId()))) {
        response.sendError(404);
        return;
    }
    
    DataList fields=datastream.getDataList("fields");
    
    //"samples" : { "total" : 30, "devices" : { "5907c35c24ac5c135fafa4d8" : 30 } }
    DataObject gsamples=datastream.getDataObject("samples");
    long totalSamples=0;
    if(gsamples!=null)totalSamples=(long)gsamples.getDouble("total");
        
    if(fields==null)
    {
        out.println("There isn't defined fields");
        return;
    }
    
    SWBDataSource dsd = engine.getDataSource("DataStreamData");
    DataObject query=new DataObject();    
    query.addSubList("sortBy").add("-timestamp");
    query.addParam("endRow", 10);
    DataObject qdata=query.addSubObject("data");
    qdata.addParam("dataStream", datastream.getNumId());
    DataList data=dsd.fetch(query).getDataObject("response").getDataList("data");
    if(data==null)data=new DataList();
    //out.println(data);        
%>

    <!-- START CUSTOM TABS -->
    <div class="row">
        <div class="col-md-12" id="main_content">
            <!-- Custom Tabs -->
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <li class="active"><a href="#tab_1" data-toggle="tab" aria-expanded="true">General</a></li>
                    <li class=""><a href="#tab_2" data-toggle="tab" aria-expanded="false">Fields</a></li>
                    <li class=""><a href="#tab_3" data-toggle="tab" aria-expanded="false" onclick="loadContent('/work/panel/dataStreamData.jsp?ID=<%=id%>','#tab_3')">Data</a></li>
                    <li class=""><a href="#tab_4" data-toggle="tab" aria-expanded="false" onclick="loadContent('/work/panel/dataStreamGraphs.jsp?ID=<%=id%>','#tab_4')">Graphs</a></li>
                </ul>
                <div class="tab-content">
                    <div class="tab-pane active" id="tab_1">

<div class="row">
    <div class="box-body">
        <table id="example2" class="table table-bordered table-hover">
            <thead>
                <tr>
                    <th>Timestamp</th>
                    <th>Device</th>
<%
    for(int x=0;x<fields.size();x++)
    {
        DataObject obj=fields.getDataObject(x);        
%>
                    <th><%=obj.getString("title")%></th>
<%        
    }
%>                    
                </tr>
            </thead>
            <tbody>
<%
    long recs=0;
    boolean endPage=false;
    Iterator<DataObject> it=data.iterator();
    while (it.hasNext() && !endPage) 
    {
        DataObject rec = it.next();
        DataObject devices=rec.getDataObject("devices");
        String devs[]=devices.keySet().toArray(new String[0]);
        String devs_names[]=new String[devs.length];
        for(int i=0;i<devs.length;i++)
        {
            SWBDataSource dsDevs=engine.getDataSource("Device");   
            DataObject obj=dsDevs.fetchObjById(dsDevs.getBaseUri()+devs[i]);
            devs_names[i]=obj.getString("name");
        }
            
        for(int m=59;m>=0 && !endPage;m--)
        {
            for(int s=59;s>=0 && !endPage;s--)
            {
                for(int d=0;d<devs.length && !endPage;d++)
                {
                    DataObject minute=devices.getDataObject(devs[d]).getDataObject(""+m);
                    if(minute!=null)
                    {
                        DataObject second=minute.getDataObject(""+s);
                        if(second!=null)
                        {
                            if(recs>=pag*maxRecs)
                            {
                                Date timestamp=(Date)rec.get("timestamp");
                                timestamp.setMinutes(m);
                                timestamp.setSeconds(s);
%>
                <tr>
                    <td><%=timestamp%></td>
                    <td><%=devs_names[d]%></td>
<%
                                for(int x=0;x<fields.size();x++)
                                {
                                    DataObject field=fields.getDataObject(x); 
                                    String val=second.getString(field.getString("name"));
                                    if(val==null)val="-";
%>
                    <th><%=val%></th>
<%        
                                }
                            }
%>                    
                </tr>
<%
                            recs++;
                            if(recs==(pag+1)*maxRecs)endPage=true;
                        }
                    }
                }
            }            
        }
    }
%>                  
            </tbody>
<!--            
            <tfoot>
                <tr>
                    <th>Rendering engine</th>
                    <th>Browser</th>
                    <th>Platform(s)</th>
                    <th>Engine version</th>
                    <th>CSS grade</th>
                </tr>
            </tfoot>
-->
        </table>
    </div><!-- /.box-body -->
</div><!-- /.box -->                        
                                
                    </div><!-- /.tab-pane -->

                    <div class="tab-pane" id="tab_2">
                        <!--jsp:include page="dataStreamFields.jsp" /-->
                    </div><!-- /.tab-pane -->
                    
                    <div class="tab-pane" id="tab_3">
                        Loading...
                        <!--jsp:include page="data.jsp" /-->
                    </div><!-- /.tab-pane -->    
                    
                    <div class="tab-pane" id="tab_4">
                        Loading...
                        <!--jsp:include page="data.jsp" /-->
                    </div><!-- /.tab-pane -->                      
                </div><!-- /.tab-content -->
            </div><!-- nav-tabs-custom -->
        </div><!-- /.col -->
    </div> <!-- /.row -->
    <!-- END CUSTOM TABS -->

