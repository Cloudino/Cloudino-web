<%-- 
    Document   : data
    Created on : 13/06/2017, 01:34:40 PM
    Author     : javier.solis
--%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="io.cloudino.utils.Utils"%>
<%@page import="io.cloudino.datastreams.DataStreamMgr"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Set"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="io.cloudino.engine.DeviceMgr"%>
<%@page import="java.io.File"%>
<%@page import="org.semanticwb.datamanager.*"%>
<%
    DataObject user = (DataObject) session.getAttribute("_USER_");
    SWBScriptEngine engine = DataMgr.getUserScriptEngine("/cloudino.js", user);
    SWBDataSource ds = engine.getDataSource("DataStream");

    String id = request.getParameter("ID");
    DataObject datastream = ds.fetchObjByNumId(id);

    //System.out.println("dataStream:" + datastream);
    HashMap<String,String> devsMap=new HashMap();

//    System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
//    System.out.println("id:" + id);
//    System.out.println("datastream" + device);
//    System.out.println("data:" + data);
    //Security
    if (datastream == null || (datastream != null && !datastream.getString("user").equals(user.getId()))) {
        response.sendError(404);
        return;
    }

    DataList fields = datastream.getDataList("fields");

    //"samples" : { "total" : 30, "devices" : { "5907c35c24ac5c135fafa4d8" : 30 } }
    DataObject gsamples = datastream.getDataObject("samples");
    long totalSamples = 0;
    if (gsamples != null) {
        totalSamples = (long) gsamples.getDouble("total");
    }

    if (fields == null || gsamples==null) {
%>        
<div class="row">        
    <div class="box-body">
        There isn't data to show
    </div>    
</div>    
<%        
        return;
    }
%>

<div class="row">
    <form data-target="#tab_4" data-submit="ajax" action="dataStreamGraphs" role="form">
        <input type="hidden" name="ID" value="<%=id%>"/>
        <div class="box-body">

            <div class="form-group has-feedback">
                <label>Device</label>
                <select name="device" class="form-control">
<%
    String devid=request.getParameter("device");
    {
        SWBDataSource dsDevs = engine.getDataSource("Device");
        DataObject devsobj=gsamples.getDataObject("devices");
        Iterator<String> it=devsobj.keySet().iterator();
        while (it.hasNext()) {
            String key = it.next();
            if(devid==null)devid=key;
            DataObject obj = dsDevs.fetchObjById(dsDevs.getBaseUri() + key);
            devsMap.put(key, obj.getString("name"));
            out.print("<option value=\""+key+"\"");
            if(key.equals(devid))out.print(" selected=\"selected\"");
            out.println(">"+obj.getString("name")+"</option>");
        }
    }    
    
%>                    
                    <option value="_ALL_">ALL</option>
                </select>
            </div>      
<%    
    Date from=null;
    Date to=null;
    SimpleDateFormat df = new SimpleDateFormat("MM/dd/yyyy");        
    String dates=request.getParameter("dates");
    if(dates==null)
    {
        Calendar cal=Calendar.getInstance();
        cal.add(Calendar.DAY_OF_MONTH, 1);
        to=cal.getTime();
        cal.add(Calendar.DAY_OF_MONTH, -7);
        from=cal.getTime();        
        dates=df.format(from)+" - "+ df.format(to);
    }else
    {
        from=df.parse(dates.substring(0, dates.indexOf(" ")));
        to=df.parse(dates.substring(dates.lastIndexOf(" ")+1));
        //System.out.println("("+dates.substring(0, dates.indexOf(" "))+")");
        //System.out.println("("+dates.substring(dates.lastIndexOf(" "))+")");
    }
    //System.out.println("dates:"+dates);
%>                    
            <div class="form-group has-feedback">
                <label>Date Range</label>
                <div class="input-group">
                  <div class="input-group-addon">
                    <i class="fa fa-calendar"></i>
                  </div>
                  <input type="text" name="dates" id="DataStreamDates" class="form-control" value="<%=dates%>"/>
                </div><!-- /.input group -->                                
            </div>                                             
                    
            <div class="form-group has-feedback">
                <label>Graph Time</label>
                <select name="type" class="form-control">          
                    <option value="<%=Calendar.SECOND%>">Seconds</option>
                    <option value="<%=Calendar.MINUTE%>">Minutes</option>
                    <option value="<%=Calendar.HOUR%>">Hours</option>
                    <option value="<%=Calendar.DAY_OF_MONTH%>">Days</option>
                    <option value="<%=Calendar.MONTH%>">Months</option>
                </select>
            </div>                
                
            <div class="form-group has-feedback">
                <label>Variable</label>
                <select name="variable" multiple class="form-control">
<%
    String[] varIDs=request.getParameterValues("variable");
    HashMap vars=new HashMap();
    if(varIDs!=null)for(int x=0;x<varIDs.length;x++)vars.put(varIDs[x], null);
    if(vars.size()==0)vars.put(fields.getDataObject(0).getString("name"), null);
    
    {
        for(int x=0;x<fields.size();x++)
        {
            DataObject obj=fields.getDataObject(x);      
            String key=obj.getString("name");
            String title=obj.getString("title");            
            out.print("<option value=\""+key+"\"");
            if(vars.containsKey(key))
            {
                out.print(" selected=\"selected\"");
                vars.put(key, title);
            }
            out.println(">"+title+"</option>");            
        }        
    }    
%>                    
                </select>
            </div>      
                                    
        </div><!-- /.box-body -->

        <div class="box-footer">
            <button type="submit" class="btn btn-primary disabled">Submit</button>
        </div>
    </form>     

</div><!-- /.tab-content -->

<canvas id="DataStreamGraph01"></canvas>
<script type="text/javascript">
    
    $('#DataStreamDates').daterangepicker();
    
    var timeFormat = 'MM/DD/YYYY HH:mm';

    window.chartColors = ['rgb(255, 99, 132)','rgb(255, 159, 64)','rgb(255, 205, 86)','rgb(75, 192, 192)','rgb(54, 162, 235)','rgb(153, 102, 255)','rgb(201, 203, 207)'];
    
    var ctx = document.getElementById('DataStreamGraph01').getContext('2d');
    var chart = new Chart(ctx, {
        // The type of chart we want to create
        type: 'line',

        // The data for our dataset
        data: {
            label: "<%=datastream.getString("name")%>",            
            datasets: [
<%
    int col=0;
    Iterator<String> it=vars.keySet().iterator();
    while (it.hasNext()) 
    {
        String var = it.next();
        DataList dlist=DataStreamMgr.getInstance().getDataStream(id).getStreamData(from, to, Calendar.MINUTE, devid, var);
        if(dlist==null)continue;
    //System.out.println("dobj:"+dlist);    
%>        
                {
                    label: "<%=vars.get(var)%>",
                    backgroundColor: Color(window.chartColors[<%=col%>]).alpha(0.5).rgbString(),
                    borderColor: window.chartColors[<%=col%>],
                    data: [
<%
        for(int x=0;x<dlist.size();x++)
        {
            out.print("{");
            out.print("x:\""+Utils.toISODate((Date)dlist.getDataObject(x).get("timestamp"))+"\""+",");
            out.print("y:"+dlist.getDataObject(x).get("data"));
            out.println("},");
        }
%>                        
                    ],
                },
<%
        col++;
    }
%>                
            ]
        },

        // Configuration options go here
        options: {
            responsive: true,
            title:{
                display:true,
                text:"<%=datastream.getString("name")%>"
            },
            scales: {
/*                
                xAxes: [{
                        type: "time",
                        display: true,
                        time: {
                                format: timeFormat,
                                // round: 'day'
                        }
                }],           
*/                
                xAxes: [{
                    type: "time",
                    display: true,       
                    scaleLabel: {
                        display: true,
                        labelString: 'Date'
                    }
                }],
                yAxes: [{
                    display: true,
                    scaleLabel: {
                        display: true,
                        labelString: 'value'
                    }
                }]                
            }
        }
    });
</script>
