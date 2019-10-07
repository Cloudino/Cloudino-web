<%-- 
    Document   : postFile
    Created on : 01-jul-2017, 2:04:49
    Author     : javiersolis
--%><%@page import="io.cloudino.engine.*"%><%@page import="java.io.*"%><%@page import="java.util.*"%><%@page import="org.apache.commons.fileupload.*"%><%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%><%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%><%
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
        out.println("POST /api/postFile/[Authentication Token]/[Topic]        //http body msg content");
    }
    System.out.println("/api/postFile/"+authtoken+"/"+topic);
    Device device=DeviceMgr.getInstance().getDeviceByAuthToken(authtoken);
    if(device!=null)
    {
        int i=0;
        if(request.getMethod().equals("POST"))
        {
            boolean isMultipart = ServletFileUpload.isMultipartContent(request);

            if (isMultipart) {
                FileItemFactory factory = new DiskFileItemFactory();
                ServletFileUpload upload = new ServletFileUpload(factory);
                try {
                    List items = upload.parseRequest(request);
                    Iterator iterator = items.iterator();
                    while (iterator.hasNext()) {
                        FileItem item = (FileItem) iterator.next();

                        if (!item.isFormField()) {
                            String fileName = item.getName();
                            System.out.println(fileName);
                            device.setDeviceData(topic, item.get());
                        }
                    }
                } catch (FileUploadException e) {
                    e.printStackTrace();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }
%>