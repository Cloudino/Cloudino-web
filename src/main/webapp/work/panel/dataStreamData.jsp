<%-- 
    Document   : dataStreamData
    Created on : 13/06/2017, 01:34:40 PM
    Author     : javier.solis
--%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.HashMap"%>
<%@page import="io.cloudino.datastreams.DataStream"%>
<%@page import="io.cloudino.datastreams.DataStreamMgr"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Set"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="io.cloudino.engine.DeviceMgr"%>
<%@page import="java.io.File"%>
<%@page import="org.semanticwb.datamanager.*"%><%!
%>
<%
    //System.out.println("Step 1");
    int maxRecs=50;
    int pag=0;
    DataObject user = (DataObject) session.getAttribute("_USER_");
    SWBScriptEngine engine = DataMgr.getUserScriptEngine("/cloudino.js", user);
    //SWBDataSource ds = engine.getDataSource("DataStream");

    String id = request.getParameter("ID");
    String devid = request.getParameter("devid");        
    String act = request.getParameter("act");    
    String spage = request.getParameter("page"); 
    if(spage!=null)pag=Integer.parseInt(spage);
    
    Date from=null;
    Date to=null;
    SimpleDateFormat df = new SimpleDateFormat("MM/dd/yyyy");        
    String dates=request.getParameter("dates");
    if(dates!=null && !dates.isEmpty())
    {
        from=df.parse(dates.substring(0, dates.indexOf(" ")));
        to=df.parse(dates.substring(dates.lastIndexOf(" ")+1));
    }    
    
    //System.out.println("from:"+from);
    //System.out.println("to"+to);

    DataStream dataStreamObj=DataStreamMgr.getInstance().getDataStream(id);
    DataObject datastream = dataStreamObj.getData();
    
    //System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    //System.out.println("id:" + id);
    //System.out.println("dataStreamObj" + dataStreamObj);
    //System.out.println("datastream" + datastream);
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
    
    int maxPag=(int)((totalSamples-1)/maxRecs)+1;
    
    //System.out.println("pag:"+pag);
    //System.out.println("maxPag:"+maxPag);
    //System.out.println("maxRecs:"+maxRecs);
    
    if(fields==null)
    {
        out.println("<span>There isn't defined fields</span>");
        return;
    }
    
    SWBDataSource dsd = engine.getDataSource("DataStreamData");
    DataObject query=new DataObject();    
    query.addSubList("sortBy").add("-timestamp");
    //query.addParam("endRow", 1000);    
    DataObject qdata=query.addSubObject("data");
    qdata.addParam("dataStream", datastream.getNumId());
    if(from!=null || to!=null)
    {
        DataObject ts=qdata.addSubObject("timestamp");
        if(from!=null)ts.addParam("$gte", from);
        if(to!=null)ts.addParam("$lt", to);            
    }    
    //System.out.println("query:"+query);
    DataObjectIterator data=dsd.find(query);
    //out.println(data);   
    //System.out.println("data:"+data);
%>

<div class="row">
    <form data-target="#tab_3" data-submit="ajax" action="dataStreamData" role="form">
        <input type="hidden" name="ID" value="<%=id%>"/>
        <div class="box-body">
            <div class="form-group has-feedback">
                <label>Device</label>
                <select name="devid" class="form-control">
                    <option value="">ALL</option>                    
<%
    {
        if(gsamples!=null)
        {
            SWBDataSource dsDevs = engine.getDataSource("Device");
            DataObject devsobj=gsamples.getDataObject("devices");
            //System.out.println("dsDevs:"+dsDevs);
            //System.out.println("devsobj:"+devsobj);
            HashMap<String,String> devsMap=new HashMap();
            Iterator<String> it=devsobj.keySet().iterator();
            while (it.hasNext()) {
                String key = it.next();
                //if(devid==null)devid=key;
                DataObject obj = dsDevs.fetchObjById(dsDevs.getBaseUri() + key);
                devsMap.put(key, obj.getString("name"));
                out.print("<option value=\""+key+"\"");
                if(key.equals(devid))out.print(" selected=\"selected\"");
                out.println(">"+obj.getString("name")+"</option>");
            }
            //System.out.println("devsMap:"+devsMap);
        }
    }        
%>                    
                </select>
            </div>                     
            <div class="form-group has-feedback">
                <label>Date Range</label>
                <div class="input-group">
                  <div class="input-group-addon">
                    <i class="fa fa-calendar"></i>
                  </div>
                  <input type="text" name="dates" id="DataStreamDates2" class="form-control" value="<%=dates==null?"":dates%>"/>
                </div><!-- /.input group -->                                
            </div>                                             
                                    
        </div><!-- /.box-body -->

        <div class="box-footer">
            <button type="submit" class="btn btn-primary disabled">Submit</button>
        </div>
    </form>     

</div><!-- /.tab-content -->
<script type="text/javascript">    
    $('#DataStreamDates2').daterangepicker();
</script>

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
    
    SWBDataSource devds = engine.getDataSource("Device");
    query = new DataObject();
    query.addSubObject("data").put("user", user.getId());
    DataObject devsMap=devds.mapByNumId(query);    
    
    while (data.hasNext() && !endPage) 
    {
        DataObject rec = data.next();
        DataObject devices=rec.getDataObject("devices");
        String devs[]=devices.keySet().toArray(new String[0]);
        String devs_names[]=new String[devs.length];
        for(int i=0;i<devs.length;i++)
        {
            DataObject obj=devsMap.getDataObject(devs[i]);
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
                                    Object val=second.get(field.getString("name"));
                                    if(val==null || !dataStreamObj.validateValue(val, field))val="-";
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
    data.close();
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

<div class="row">
    <div class="col-sm-5">
        <div class="dataTables_info" id="table_info" role="status" aria-live="polite">Showing <%=pag*maxRecs+1%> to <%=recs%> of <%=totalSamples%> entries</div>            
    </div>    
    <div class="col-sm-7">
        <div class="dataTables_paginate paging_simple_numbers" id="table_paginate">
            <ul class="pagination">
                <li class="paginate_button <%=pag==0?"disabled":""%>"><a href="#" onclick="loadContent('/work/panel/dataStreamData.jsp?ID=<%=id%>&page=0','#tab_3')">First</a></li>
                <li class="paginate_button previous <%=pag==0?"disabled":""%>" id="table_previous"><a href="#" onclick="<%=pag>0?"loadContent('/work/panel/dataStreamData.jsp?ID="+id+"&page="+(pag-1)+"','#tab_3')":""%>">Previous</a></li>
<%
    int ip=pag-5,mp=pag+5;
    if(ip<0)
    {
        ip=0;
        mp=ip+10;
    }
    if(mp>maxPag)
    {
        mp=maxPag;
        ip=maxPag-10;
        if(ip<0)ip=0;
    }
    for(int i=ip;i<mp;i++)
    {
%>
                <li class="paginate_button <%=pag==i?"active":""%>"><a href="#" onclick="<%=pag!=i?"loadContent('/work/panel/dataStreamData.jsp?ID="+id+"&page="+i+"','#tab_3')":""%>"><%=(i+1)%></a></li>
<%
    }
%>                
                <li class="paginate_button next <%=pag==(maxPag-1)?"disabled":""%>" id="table_next"><a href="#" onclick="<%=pag<(maxPag-1)?"loadContent('/work/panel/dataStreamData.jsp?ID="+id+"&page="+(pag+1)+"','#tab_3')":""%>">Next</a></li>
                <li class="paginate_button <%=pag==(maxPag-1)?"disabled":""%>"><a href="#" onclick="loadContent('/work/panel/dataStreamData.jsp?ID=<%=id%>&page=<%=maxPag-1%>','#tab_3')">Last</a></li>
            </ul>
        </div>
    </div>
</div>             

