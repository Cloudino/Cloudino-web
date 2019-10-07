<%-- 
    Document   : dataStreamData
    Created on : 13/06/2017, 01:34:40 PM
    Author     : javier.solis
--%><%@page import="java.text.SimpleDateFormat"%><%@page import="java.io.IOException"%><%@page import="io.cloudino.datastreams.*"%><%@page import="java.util.*"%><%@page import="io.cloudino.engine.DeviceMgr"%><%@page import="java.io.File"%><%@page import="org.semanticwb.datamanager.*"%><%@page contentType="text/html" pageEncoding="UTF-8"%><%!

    void processDevice(JspWriter out, DataList fields, DataStream dataStream, DataObject devRec, String device, Date timestamp, int m, int s, String ini, String separator1, String separator2, String end) throws IOException
    {
        DataObject minute=devRec.getDataObject(""+m);
        if(minute!=null)
        {
            DataObject second=minute.getDataObject(""+s);                        
            if(second!=null)
            {
                timestamp.setMinutes(m);
                timestamp.setSeconds(s);
                out.print(ini);
                out.print(timestamp);
                out.print(separator1);
                out.print(device);

                for(int x=0;x<fields.size();x++)
                {
                    DataObject field=fields.getDataObject(x);                                     
                    Object val=second.get(field.getString("name"));
                    if(val==null || !dataStream.validateValue(val, field))
                    {
                        val="";
                        out.print(separator1);
                    }
                    else out.print(separator2);
                    out.print(val);
                }
                out.print(end);
            }
        }
    }

%><%
    
    DataObject user = (DataObject) session.getAttribute("_USER_");
    SWBScriptEngine engine = DataMgr.getUserScriptEngine("/cloudino.js", user);
    //SWBDataSource ds = engine.getDataSource("DataStream");

    String id = request.getParameter("ID");
    String format = request.getParameter("format");    
    String devid = request.getParameter("devid");    
    
    Date from=null;
    Date to=null;
    SimpleDateFormat df = new SimpleDateFormat("MM/dd/yyyy");        
    String dates=request.getParameter("dates");
    if(dates!=null && !dates.isEmpty())
    {
        from=df.parse(dates.substring(0, dates.indexOf(" ")));
        to=df.parse(dates.substring(dates.lastIndexOf(" ")+1));
    }
    

    DataStream dataStreamObj=DataStreamMgr.getInstance().getDataStream(id);
    DataObject datastream = dataStreamObj.getData();
    
    //Security
    if (datastream == null || (datastream != null && !datastream.getString("user").equals(user.getId()))) {
        response.sendError(404);
        return;
    }
    
    DataList fields=datastream.getDataList("fields");
    
    if(fields==null)
    {
%>        
<div class="row">        
    <div class="box-body">
        There isn't data to show
    </div>    
</div>    
<%  
        return;
    }
    
    SWBDataSource dsd = engine.getDataSource("DataStreamData");
    DataObject query=new DataObject();    
    query.addSubList("sortBy").add("-timestamp");
    DataObject qdata=query.addSubObject("data");
    qdata.addParam("dataStream", datastream.getNumId());
    if(from!=null || to!=null)
    {
        DataObject ts=qdata.addSubObject("timestamp");
        if(from!=null)qdata.addParam("$gte", from);
        if(to!=null)qdata.addParam("$lt", to);            
    }
    DataObjectIterator dataIt=dsd.find(query);
        
    String preHead="";
    String iniHead="";
    String separatorHead=",";
    String endHead="\n";
    String postHead="";
    String preContent="";
    String iniContent="";
    String separatorContent1=",";
    String separatorContent2=",";
    String endContent="\n";
    String postContent="";
    
    if(format!=null)
    {
        if(format.equals("csv"))
        {
            response.setHeader("Content-Disposition","attachment; filename=\"datastream.csv\"");
            response.setContentType("text/csv");
        }else if(format.equals("xls"))
        {
            response.setHeader("Content-Disposition","attachment; filename=\"datastream.xls\"");
            response.setContentType("application/vnd.ms-excel");

            preHead="<?xml version=\"1.0\"?>\n" +
            "<Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\"\n" +
            " xmlns:o=\"urn:schemas-microsoft-com:office:office\"\n" +
            " xmlns:x=\"urn:schemas-microsoft-com:office:excel\"\n" +
            " xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\"\n" +
            " xmlns:html=\"http://www.w3.org/TR/REC-html40\">\n" +
            " <Styles>\n"+
            "  <Style ss:ID=\"s66\">\n" +
            "   <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#FFFFFF\"\n" +
            "    ss:Bold=\"1\"/>\n" +
            "   <Interior ss:Color=\"#969696\" ss:Pattern=\"Solid\"/>\n" +
            "  </Style>" +                
            " </Styles>\n"+
            " <Worksheet ss:Name=\"datastream\">\n" +
            "  <Table>\n";

            iniHead="   <Row>\n    <Cell ss:StyleID=\"s66\"><Data ss:Type=\"String\">";
            separatorHead="</Data></Cell>\n    <Cell ss:StyleID=\"s66\"><Data ss:Type=\"String\">";
            endHead="</Data></Cell>\n   </Row>\n";    

            iniContent="   <Row>\n    <Cell><Data ss:Type=\"String\">";
            separatorContent1="</Data></Cell>\n    <Cell><Data ss:Type=\"String\">";
            separatorContent2="</Data></Cell>\n    <Cell><Data ss:Type=\"Number\">";
            endContent="</Data></Cell>\n   </Row>\n";       

            postContent="  </Table>\n </Worksheet>\n</Workbook>";

        }else if(format.equals("html"))
        {
            response.setHeader("Content-Disposition","attachment; filename=\"datastream.html\"");
            //response.setContentType("application/vnd.ms-excel");        
            preHead="<html><body><table>";
            iniHead="<tr><th>";
            separatorHead="</th><th>";
            endHead="</th></tr>\n";
            postHead="";
            preContent="";
            iniContent="<tr><td>";
            separatorContent1="</td><td>";
            separatorContent2="</td><td>";
            endContent="</td></tr>\n";
            postContent="</table></body></html>";        
        }    

        //header
        out.print(preHead);
        out.print(iniHead);
        out.print("timestamp");
        out.print(separatorHead);
        out.print("device");
        for(int x=0;x<fields.size();x++)
        {
            DataObject obj=fields.getDataObject(x);        
            out.print(separatorHead);
            out.print(obj.getString("name"));
        }    
        out.print(endHead);
        out.print(postHead);    

        //content
        out.print(preContent);
        SWBDataSource devds = engine.getDataSource("Device");
        query = new DataObject();
        DataObject data = query.addSubObject("data");
        data.put("user", user.getId());
        DataObject devsMap=devds.mapByNumId(query);

        while (dataIt.hasNext()) 
        {
            DataObject rec = dataIt.next();
            DataObject devices=rec.getDataObject("devices");

            if(devid!=null && !devid.isEmpty())
            {
                DataObject device=devices.getDataObject(devid);
                if(device!=null)
                {
                    DataObject dev=devsMap.getDataObject(devid);
                    String devstr=devid;
                    if(dev!=null)devstr=dev.getString("name");

                    for(int m=59;m>=0;m--)
                    {
                        for(int s=59;s>=0;s--)
                        {
                            processDevice(out, fields, dataStreamObj, device, devstr, (Date)rec.get("timestamp"), m, s, iniContent, separatorContent1,separatorContent2, endContent);
                        }            
                    }                
                }
            }else
            {
                String devs[]=devices.keySet().toArray(new String[0]);

                for(int m=59;m>=0;m--)
                {
                    for(int s=59;s>=0;s--)
                    {
                        for(int d=0;d<devs.length;d++)
                        {
                            DataObject dev=devsMap.getDataObject(devs[d]);
                            String devstr=devs[d];
                            if(dev!=null)devstr=dev.getString("name");
                            processDevice(out, fields, dataStreamObj, devices.getDataObject(devs[d]), devstr, (Date)rec.get("timestamp"), m, s, iniContent, separatorContent1,separatorContent2, endContent);
                        }
                    }            
                }
            } 
        }        
        out.print(postContent);
        return;
    }    
%>
<div class="row">
    <form data-target="#tab_5" data-submit_="ajax" action="dataStreamExport" role="form">
        <input type="hidden" name="ID" value="<%=id%>"/>
        <div class="box-body">
            <div class="form-group has-feedback">
                <label>Device</label>
                <select name="devid" class="form-control">
<%
    {
        DataObject gsamples = datastream.getDataObject("samples");
        if(gsamples!=null)
        {
            SWBDataSource dsDevs = engine.getDataSource("Device");
            DataObject devsobj=gsamples.getDataObject("devices");
            HashMap<String,String> devsMap=new HashMap();
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
    }        
%>                    
                    <option value="">ALL</option>
                </select>
            </div>                     
            <div class="form-group has-feedback">
                <label>Date Range</label>
                <div class="input-group">
                  <div class="input-group-addon">
                    <i class="fa fa-calendar"></i>
                  </div>
                  <input type="text" name="dates" id="DataStreamDates2" class="form-control" value=""/>
                </div><!-- /.input group -->                                
            </div>                                             
                    
            <div class="form-group has-feedback">
                <label>Format</label>
                <select name="format" class="form-control">          
                    <option value="csv">CSV</option>
                    <option value="xls">XLS</option>
                    <option value="html">HTML</option>
                </select>
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