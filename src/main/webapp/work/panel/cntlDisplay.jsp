<%-- 
    Document   : cntlMsgButton
    Created on : 23-feb-2016, 14:28:33
    Author     : javiersolis
--%><%@page import="org.semanticwb.datamanager.DataObject"%><%@page contentType="text/html" pageEncoding="UTF-8"%><%
    String m=request.getParameter("m");
    if("u".equals(m))
    {
        DataObject data=(DataObject)request.getAttribute("data"); 
        data.put("topic", request.getParameter("topic"));
    }else if("c".equals(m))
    {
        String topic="";
        DataObject ctrl=(DataObject)request.getAttribute("control");  
        if(ctrl!=null)
        {
            DataObject data = ctrl.getDataObject("data");
            topic = data.getString("topic");
        }

%>
<label>Topic</label>
<input name="topic" value="<%=topic%>" type="text" class="form-control" placeholder="Topic label..." required>
<%
    }else{
        DataObject contrl=(DataObject)request.getAttribute("control");
        Object value=request.getAttribute("value");
        if(contrl!=null)
        {
            //String ctrlid = contrl.getNumId();
            //String ctrtype = contrl.getString("type");
            DataObject doData = contrl.getDataObject("data");
            String topic = doData.getString("topic");
            String title = contrl.getString("title");
%>
<div class="cdino_control" style="padding-top: 22px;">
    <span style="font-size: 28px; font-weight: bold;" id="<%=contrl.getNumId()%>"><%=(value!=null)?value.toString():""%></span>
    <p style="padding-top: 6px;"><%=title%></p>
    <script type="text/javascript">WS.onMessage("<%=topic%>",function(msg){$("#<%=contrl.getNumId()%>").html(msg);});</script>
</div>
<%
        }
    }
%>