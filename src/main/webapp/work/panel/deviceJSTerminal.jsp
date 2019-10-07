<%-- 
    Document   : deviceJSterminal.jsp
    Created on : 29-ene-2016, 17:54:57
    Author     : javiersolis
--%><%@page contentType="text/html" pageEncoding="UTF-8"%><%
%>
    <div>
        <div>
            <label>Command</label>
            <textarea id="jscmd" class="form-control"></textarea>
        </div>
        <div class="cdino_buttons">
            <button class="btn btn-primary btn-flat" id="sendjs" onclick="WS.sendJS();">Send</button>
        </div>
    </div>
    <hr/>    
    <label>Response</label>
    <div class="callout callout-info">
        <div id="ws_jsrsp"></div>
    </div>
    <div class="">
        <input type="button" value="Clear" onclick="ws_jsrsp.innerHTML='';" class="btn btn-warning" >
    </div>  