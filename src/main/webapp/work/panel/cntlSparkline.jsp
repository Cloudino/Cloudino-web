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
        if(contrl!=null)
        {
            //String ctrlid = contrl.getNumId();
            //String ctrtype = contrl.getString("type");
            DataObject doData = contrl.getDataObject("data");
            String topic = doData.getString("topic");
            String title = contrl.getString("title");
%>
<div class="cdino_control" style="padding-top: 8px;">
    <div id="<%=contrl.getNumId()%>"></div>
    <p><%=title%></p>
</div>
<script type="text/javascript">
    var v_<%=contrl.getNumId()%> = [];        
    WS.onMessage("<%=topic%>",function(msg)
    {
        v_<%=contrl.getNumId()%>.push(parseFloat(msg));
        if(v_<%=contrl.getNumId()%>.length>20)v_<%=contrl.getNumId()%>.shift();
        $('#<%=contrl.getNumId()%>').sparkline(v_<%=contrl.getNumId()%>, {
            type: 'line',
            lineColor: '#92c1dc',
            fillColor: "#ebf4f9",
            height: '60',
            width: '100'
        });
    });
</script>
<%
        }
    }
%>