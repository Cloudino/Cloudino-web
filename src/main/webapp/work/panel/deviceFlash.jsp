<%-- 
    Document   : deviceUpload.jsp
    Created on : 29-ene-2018, 17:54:57
    Author     : javiersolis
--%><%@page import="java.util.concurrent.TimeUnit"%><%@page import="java.io.*"%><%@page import="java.util.*"%><%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%><%@page import="org.apache.commons.fileupload.*"%><%@page import="org.apache.commons.fileupload.servlet.*"%><%@page import="io.cloudino.engine.*"%><%@page import="org.semanticwb.datamanager.*"%><%@page contentType="text/html" pageEncoding="UTF-8"%><%
    String id = request.getParameter("ID");
    
    DataObject user = (DataObject) session.getAttribute("_USER_");
    SWBScriptEngine eng = DataMgr.getUserScriptEngine("/cloudino.js", user);

    if (request.getMethod().equals("POST")) {
        boolean isMultipart = ServletFileUpload.isMultipartContent(request);
        if (isMultipart) {
            FileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);
            try {
                List items = upload.parseRequest(request);
                Iterator iterator = items.iterator();
                while (iterator.hasNext()) {
                    FileItem item = (FileItem) iterator.next();
                    if (item.isFormField()) {
                        System.out.println("Name:" + item.getFieldName() + "->" + item.getString());
                        if ("ID".equals(item.getFieldName())) {
                            id = item.getString();
                        }
                    } else {
                        String fileName = item.getName();
                        System.out.println(fileName);

                        String appPath = config.getServletContext().getRealPath("/");
                        String path = appPath + "/work/cloudino/devices/"+id+"/firmware/";
                        File dir=new File(path);
                        dir.mkdirs();
                        File f=new File(dir,"update.bin");
                        FileOutputStream fout=new FileOutputStream(f);
                        DataUtils.copyStream(item.getInputStream(), fout);
                        
                        Device device = DeviceMgr.getInstance().getDevice(id);
                        //System.out.println(device);
                        if(device!=null)
                        {
                            //String furl=request.getRequestURL().toString();
                            String furl="http://cloudino.io/api/getFirmware";
                            furl+="?ID="+id;
                            
                            if(device.getData()!=null)
                            {
                                String stype=device.getData().getString("type");
                            
                                if("wio.gsm".equals(stype))
                                {
                                    furl+="&act=down";                            
                                    System.out.println("$CDINOUPDT3:"+f.length()+"|"+furl);
                                    device.post("$CDINOUPDT3", ""+f.length()+"|"+furl);                                
                                }else
                                {
                                    int speed=57600;
                                    io.cloudino.compiler_.ArdCompiler cmp=io.cloudino.compiler_.ArdCompiler.getInstance();
                                    io.cloudino.compiler_.ArdDevice dvc=cmp.getDevices().get(stype);
                                    if(dvc!=null)speed=dvc.speed;
                                    int port=request.getLocalPort();
                                    if(port==443)port=80;               //TODO: Download file via ssl

                                    //System.out.println("$CDINOUPDT2"+":"+speed+"|:"+port+"/api/getFirmware?act=arduino_down&fname="+fname+"&ID="+user.getNumId());
                                    device.post("$CDINOUPDT2", speed+"|:"+port+"/api/getFirmware?act=arduino_down_bin&ID="+device.getId());                                
                                }
                            }
                        }        
                        return;
                    }
                }
            } catch (FileUploadException e) {
                e.printStackTrace();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
%>OK