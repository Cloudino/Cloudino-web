<%-- 
    Document   : post
    Created on : 15-jun-2017, 22:08:23
    Author     : javiersolis
--%><%@page import="io.cloudino.utils.Utils"%><%@page import="java.io.ByteArrayOutputStream"%><%@page import="org.semanticwb.datamanager.DataObject"%><%@page import="java.util.*"%><%@page import="io.cloudino.engine.*"%><%@page contentType="text/plain" pageEncoding="UTF-8"%><%
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
        out.println("GET /api/post2Srv/[Authentication Token][?topic1=msg1][&topic2=msg2]");
        out.println("GET /api/post2Srv/[Authentication Token]/[DataSource Topic][?topic1=msg1][&topic2=msg2]");
        out.println("POST /api/post2Srv/[Authentication Token]/[Topic]              //http body msg content");
    }
    Device device=DeviceMgr.getInstance().getDeviceByAuthToken(authtoken);
    if(device!=null)
    {
        int i=0;
        if(topic==null)
        {
            Map<String,String[]> map=request.getParameterMap();
            Iterator<String> it=map.keySet().iterator();
            while (it.hasNext()) {
                String key = it.next();
                String vals[]=map.get(key);
                for(int x=0;x<vals.length;x++)
                {
                    device.receive(key, vals[x]);
                    i++;
                }
            }                    
        }else
        {
            if(request.getMethod().equals("POST"))
            {
                ByteArrayOutputStream o=new ByteArrayOutputStream();
                Utils.copyStream(request.getInputStream(), o);        
                byte data[]=o.toByteArray();
                System.out.println("device:"+device);
                System.out.println("topic:"+topic);
                System.out.println("msg:"+new String(data,"UTF-8"));
                if(data.length>0)
                {
                    device.receive(topic, new String(data,"UTF-8"));
                }
            }else
            {            
                DataObject obj=new DataObject();
                Map<String,String[]> map=request.getParameterMap();
                Iterator<String> it=map.keySet().iterator();
                while (it.hasNext()) {
                    String key = it.next();
                    String vals[]=map.get(key);
                    for(int x=0;x<vals.length;x++)
                    {
                        obj.put(key, vals[x]);
                        i++;
                    }
                }       
                device.receive(topic, obj.toString());
            }
        }
        out.println("OK "+i);
    }else
    {
        out.println("Error processing parameters");
    }    
%>