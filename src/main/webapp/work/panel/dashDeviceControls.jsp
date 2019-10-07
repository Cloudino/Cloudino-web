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
%>
<script type="text/javascript">WS.notify=[];</script>
<div style="background: white; padding: 5px"> 
    <label>Controls</label>
    <div> 
        <%
            DataObject query = new DataObject();
            DataList sort=new DataList();
            sort.add("order");
            query.addParam("sortBy", sort);
            DataObject data = new DataObject();
            query.put("data", data);
            //data.put("user", user.getId());
            data.put("device", id);
            DataObject ret = ds.fetch(query);
            //Lista de controles asociados al dispositivo
            //System.out.println("ret:"+ret);
            DataList<DataObject> controls = ret.getDataObject("response").getDataList("data");
            //System.out.println("controls:"+controls);
            if (controls != null) {
                for (DataObject contrl : controls) {
                    String ctrtype = contrl.getString("type");
                    
                    //if(!ctrtype.equals("Switch"))continue;
                    
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
                    
                    RequestDispatcher req=request.getRequestDispatcher("/work/panel/cntl"+ctrtype+".jsp");
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
</div>