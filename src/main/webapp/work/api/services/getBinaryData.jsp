<%-- 
    Document   : post
    Created on : 15-jun-2017, 22:08:23
    Author     : javiersolis
--%><%@page import="io.cloudino.utils.Utils"%><%@page import="java.io.*"%><%@page import="io.cloudino.engine.*"%><%@page import="java.util.*"%><%
    String uri=request.getRequestURI();
    StringTokenizer st=new StringTokenizer(uri,"/");
    String api=st.nextToken();
    String serv=st.nextToken();
    String authtoken=null;
    String topic=null;    
    String contentType=null;    
    if(st.hasMoreTokens())authtoken=st.nextToken();
    if(st.hasMoreTokens())topic=st.nextToken();
    if(st.hasMoreTokens())contentType=st.nextToken();
    if(authtoken==null)
    {
        out.println("Cloudino HTTP API:");
        out.println("GET /api/getBinaryData/[Authentication Token]/[Topic]/[Content_Type]");
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
            response.setContentType("text/plain");
        }
        Object ret=device.getDeviceData(topic);
        if(ret==null)
        {
            String appPath = config.getServletContext().getRealPath("/");
            String path=appPath+"/work/cloudino/devices/"+device.getId()+"/";
            File f=new File(path,topic.replace(' ', '_'));
            if(f.exists())
            {
                FileInputStream fin=new FileInputStream(f);
                ByteArrayOutputStream fout=new ByteArrayOutputStream((int)f.length());
                Utils.copyStream(fin, fout);
                ret=fout.toByteArray();
            }
        }            
        if(ret instanceof byte[])
        {
            response.getOutputStream().write((byte[])ret);
        }else
        {
            out.print(ret);
        }
    }else
    {
        response.setContentType("text/plain");
        out.println("Error processing parameters");
    }    
%>