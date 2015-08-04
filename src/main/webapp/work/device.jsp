<%@page import="java.util.Iterator"%>
<%@page import="io.cloudino.engine.Device"%>
<%@page import="io.cloudino.engine.DeviceMgr"%>
<%
    String id=request.getParameter("ID");
    Device dev=null;
    if(id!=null)
    {
        DeviceMgr mgr=DeviceMgr.getInstance();
        dev=mgr.getDevice(id);
    }else
    {
        return;
    }
%>
<?xml version="1.0" encoding="UTF-8"?>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
    <title>Cloudino Device</title>
    <script type="text/javascript" src="js/websockets.js"></script>
    <script type="text/javascript">
        var url='ws://' + window.location.host+ '/websocket/cdino?ID=<%=id%>';
    </script>
</head>
<body onload="WS.connect(url)"> 
    
    <%=dev.getData()%>
    
    <div id="connect-container">
        <div>
            <button id="connect" onclick="WS.connect(url);">Connect</button>
            <button id="disconnect" disabled="disabled" onclick="WS.disconnect();">Disconnect</button>
        </div>
        <div>
            Topic:<br/>
            <input id="topic" type="text" style="width: 350px"/>
        </div>
        <div>
            Message:<br/>
            <textarea id="message" style="width: 350px">Here is a message!</textarea>
        </div>
        <div>
            <button id="send" onclick="WS.send();" disabled="disabled">Send</button>
        </div>
    </div>
    <div id="console-container">
        <div id="console"/>
    </div>
</body>
</html>