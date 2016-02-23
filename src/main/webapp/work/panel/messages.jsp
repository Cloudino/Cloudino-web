<%-- 
    Document   : messages.jsp
    Created on : 29-ene-2016, 17:54:57
    Author     : javiersolis
--%><%@page contentType="text/html" pageEncoding="UTF-8"%><%
    String id = request.getParameter("ID");
%>
    <script type="text/javascript">
        var url='ws://' + window.location.host+ '/websocket/cdino?ID=<%=id%>';
        WS.disconnect();
        WS.connect(url);
    </script>                        
                        
    <div id="connect-container">
        
        <div style="display: none">
            <button class="btn btn-primary btn-flat" id="connect" onclick="WS.connect(url);">Connect</button>
            <button class="btn btn-primary btn-flat" id="disconnect" disabled="disabled" onclick="WS.disconnect();">Disconnect</button>
        </div>
        
        <div>
            Topic:<br/>
            <input id="topic" type="text" class="form-control"/>
        </div>
        <div>
            Message:<br/>
            <textarea id="message" class="form-control">Here is a message!</textarea>
        </div>
        <div class="cdino_buttons">
            <button class="btn btn-primary btn-flat" id="send" onclick="WS.send();" disabled="disabled">Send</button>
        </div>
    </div>
    <hr/>
    <label>Console</label>
    <div class="callout callout-info">
        <div id="ws_msg"></div>
    </div>
    <div class="">
        <input type="button" value="Clear" onclick="ws_msg.innerHTML='';" class="btn btn-primary" >
    </div>      
   