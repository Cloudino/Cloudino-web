<%-- 
    Document   : post
    Created on : 15-jun-2017, 22:08:23
    Author     : javiersolis
--%><%@page import="java.util.*"%><%@page import="io.cloudino.engine.*"%><%@page contentType="text/plain" pageEncoding="UTF-8"%><%
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
        out.println("GET /api/post2dev/[Authentication Token][?topic1=msg1][&topic2=msg2]");
        return;
    }
    String id=DeviceMgr.getInstance().getDeviceIdByAuthToken(authtoken);
    if(id!=null)
    {
        Device device=DeviceMgr.getInstance().getDeviceIfPresent(id);
        if(device!=null && device.isConnected())
        {
            int i=0;
            Map<String,String[]> map=request.getParameterMap();
            Iterator<String> it=map.keySet().iterator();
            while (it.hasNext()) {
                String key = it.next();
                String vals[]=map.get(key);
                for(int x=0;x<vals.length;x++)
                {
                    device.post(key, vals[x]);
                    i++;
                }
            }        
            out.println(i);
        }else
        {
            out.println("Error:Device offline");
        }
    }else{
        out.println("Error:Bad parameters");
    }
%>