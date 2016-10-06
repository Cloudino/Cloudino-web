<%-- 
    Document   : arduinoDownload
    Created on : 11-sep-2016, 18:50:13
    Author     : javiersolis
--%><%@page import="java.io.*"%><%@page import="io.cloudino.utils.*"%><%@page import="org.semanticwb.datamanager.*"%><%@page import="io.cloudino.engine.*"%><%@page contentType="application/octet-stream"%><%
    DataObject user = (DataObject) session.getAttribute("_USER_");
    SWBScriptEngine engine = DataMgr.getUserScriptEngine("/cloudino.js", user);
    
    String uid = request.getParameter("uid");
    String fname = request.getParameter("fname");
    //Device device = DeviceMgr.getInstance().getDeviceIfPresent(id);
    
    String appPath = config.getServletContext().getRealPath("/");
    String dir = appPath + "/work";
    String userPath = dir + engine.getScriptObject().get("config").getString("usersWorkPath") + "/" + uid+"/arduino";
    String userBuildPath = userPath + "/build";
    
    String compiled = userBuildPath + "/" + fname + ".cpp.hex"; 
    
    HexSender obj=new HexSender();
    //System.out.println(compiled);
    
    HexSender.Data[] data=obj.readHex(new FileInputStream(compiled));
    ByteArrayOutputStream b=new ByteArrayOutputStream();
    obj.programData(data,b);
    response.setContentLength(b.size());
    response.getOutputStream().write(b.toByteArray());           
%>