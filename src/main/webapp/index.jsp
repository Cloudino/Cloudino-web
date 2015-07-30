<%@page import="java.util.HashMap"%>
<%@page import="org.semanticwb.datamanager.DataObject"%>
<%@page import="org.semanticwb.datamanager.SWBDataSource"%>
<%@page import="org.semanticwb.datamanager.SWBScriptEngine"%>
<%@page import="org.semanticwb.datamanager.DataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
<%
    DataObject user=(DataObject)session.getAttribute("_USER_");
    out.println(user);
    SWBScriptEngine engine=DataMgr.getUserScriptEngine("/cloudino.js",user);
    SWBDataSource ds=engine.getDataSource("Device");   
    DataObject obj=ds.fetch();
    out.println(obj);
    engine.close();
%>        
    </body>
</html>
