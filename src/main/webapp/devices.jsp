<%@page import="java.util.Iterator"%>
<%@page import="io.cloudino.engine.Device"%>
<%@page import="io.cloudino.engine.DeviceMgr"%>
<?xml version="1.0" encoding="UTF-8"?>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
    <title>Cloudino Devices</title>
</head>
<body>
<%
    DeviceMgr mgr=DeviceMgr.getInstance();
    Iterator<Device> it=mgr.listDevices();
    while(it.hasNext())
    {
        Device dev=it.next();
        out.print("<p>");
        out.print("<a href=\"device.jsp?ID="+dev.getId()+"\">");
        out.print(dev.getId());
        if(dev.isConnected())out.print(" (online)");
        out.print("</a>");
        out.println("</p>");
    }
%>
</body>
</html>