<%-- 
    Document   : Post Binary Data to Memory Device Object
    Created on : 15-jun-2017, 22:08:23
    Author     : javiersolis
--%><%@page import="java.io.File"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="io.cloudino.utils.Utils"%><%@page import="java.io.ByteArrayOutputStream"%><%@page import="org.semanticwb.datamanager.DataObject"%><%@page import="java.util.*"%><%@page import="io.cloudino.engine.*"%><%@page contentType="text/plain" pageEncoding="UTF-8"%><%
    String uri=request.getRequestURI();
    StringTokenizer st=new StringTokenizer(uri,"/");
    String api=st.nextToken();
    String serv=st.nextToken();
    String authtoken=null;
    String topic=null;    
    if(st.hasMoreTokens())authtoken=st.nextToken();
    if(st.hasMoreTokens())topic=st.nextToken();
    if(authtoken==null)
    {
        out.println("Cloudino HTTP API:");
        out.println("POST /api/postBinaryData/[Authentication Token]/[Topic]        //http body msg content");
    }
    Device device=DeviceMgr.getInstance().getDeviceByAuthToken(authtoken);
    if(device!=null)
    {
        int i=0;
        if(request.getMethod().equals("POST"))
        {
            ByteArrayOutputStream o=new ByteArrayOutputStream();
            Utils.copyStream(request.getInputStream(), o);        
            byte data[]=o.toByteArray();
            System.out.println("postBinaryData:"+authtoken+":"+data.length);
            if(data.length>0)
            {
                //device.setDeviceData(topic, new String(data,"UTF-8"));
                device.setDeviceData(topic, data);
            }
            out.println("OK");
            return;
        }
    }   
    out.println("Error processing parameters");
%>