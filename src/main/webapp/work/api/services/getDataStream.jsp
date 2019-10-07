<%-- 
    Document   : post
    Created on : 15-jun-2017, 22:08:23
    Author     : javiersolis
--%><%@page import="io.cloudino.datastreams.DataStreamMgr"%>
<%@page import="org.semanticwb.datamanager.DataObject"%><%@page import="io.cloudino.engine.*"%><%@page import="java.util.*"%><%
    String uri=request.getRequestURI();
    StringTokenizer st=new StringTokenizer(uri,"/");
    String api=st.nextToken();
    String serv=st.nextToken();
    String authtoken=null;
    String streamid=null;    
    String contentType=null;    
    if(st.hasMoreTokens())authtoken=st.nextToken();
    if(st.hasMoreTokens())streamid=st.nextToken();
    if(st.hasMoreTokens())contentType=st.nextToken();
    if(authtoken==null)
    {
        out.println("Cloudino HTTP API:");
        out.println("GET /api/getDataStream/[Authentication Token]/[Stream ID]/[Content_Type][?from=date][&to=date]");
    }
    Device device=DeviceMgr.getInstance().getDeviceByAuthToken(authtoken);
    if(device!=null)
    {
        if(contentType!=null)
        {
            response.setContentType(contentType.replace("_", "/"));
        }
        else
        {
            response.setContentType("text/json");
            response.setCharacterEncoding("UTF-8");
        }
        DataStreamMgr.
        
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