<%-- 
    Document   : post
    Created on : 15-jun-2017, 22:08:23
    Author     : javiersolis
--%><%@page import="org.semanticwb.datamanager.DataObject"%><%@page import="io.cloudino.engine.*"%><%@page import="java.util.*"%><%
    String uri=request.getRequestURI();
    StringTokenizer st=new StringTokenizer(uri,"/");
    String api=st.nextToken();
    String serv=st.nextToken();
    String devid=null;
    String topic=null;    
    String contentType=null;    
    if(st.hasMoreTokens())devid=st.nextToken();
    if(st.hasMoreTokens())topic=st.nextToken();
    if(st.hasMoreTokens())contentType=st.nextToken();
    if(devid==null)
    {
        out.println("Cloudino HTTP API:");
        out.println("GET /api/getPublicData/[Device ID]/[Topic]/[Content_Type]");
    }
    Device device=DeviceMgr.getInstance().getDevice(devid);
    if(device!=null && device.getData().getBoolean("public",false))
    {
        response.setHeader("Access-Control-Allow-Origin", "*");
        if(contentType!=null)
        {
            response.setContentType(contentType.replace("_", "/"));
        }
        else
        {
            response.setContentType("text/json");
            response.setCharacterEncoding("UTF-8");
        }
        if(topic==null)
        {            
            DataObject deviceData=device.getDeviceData();
            out.print(deviceData);
        }else
        {
            Object ret=device.getDeviceData(topic);
            if(ret instanceof byte[])
            {
                response.getOutputStream().write((byte[])ret);
            }else
            {
                out.print(ret);
            }
        }
    }else
    {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        out.println("Error processing parameters");
    }    
%>