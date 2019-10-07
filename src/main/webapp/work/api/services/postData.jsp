<%-- 
    Document   : Post String Data to Momory Device Object
    Created on : 15-jun-2017, 22:08:23
    Author     : javiersolis
--%><%@page import="io.cloudino.utils.Utils"%><%@page import="java.io.ByteArrayOutputStream"%><%@page import="org.semanticwb.datamanager.DataObject"%><%@page import="java.util.*"%><%@page import="io.cloudino.engine.*"%><%@page contentType="text/plain" pageEncoding="UTF-8"%><%
    System.out.println("postData");
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
        out.println("POST /api/postData/[Authentication Token]/[Topic]        //http body msg content");
    }
    Device device=DeviceMgr.getInstance().getDeviceByAuthToken(authtoken);
    if(device!=null)
    {
        int i=0;
        System.out.println("device:"+device);
        if(request.getMethod().equals("POST"))
        {
            ByteArrayOutputStream o=new ByteArrayOutputStream();
            Utils.copyStream(request.getInputStream(), o);        
            byte data[]=o.toByteArray();
            if(data.length>0)
            {
                device.setDeviceData(topic, new String(data,"UTF-8"));
                System.out.println("data:"+new String(data,"UTF-8"));
            }
            out.println("OK");
            return;
        }
    }   
    out.println("Error processing parameters");
%>