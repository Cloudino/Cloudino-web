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
<div class="cdino_control" style="padding-top: 3px;">
    <input id="<%=contrl.getNumId()%>" type="text" class="knob" data-readonly="false" value="0" data-min="0" data-max="255" data-angleOffset="-125" data-angleArc="250" data-displayPrevious=true data-width="70" data-height="70" data-fgColor="#39CCCC"/>
    <p style="margin-top: -10px;"><%=title%></p>
</div>
<script type="text/javascript">   
    $('#<%=contrl.getNumId()%>').knob({
        'release' : function (v) { 
            WS.post('<%=topic%>',''+Math.round(v));
        }
    });    
    WS.onMessage("<%=topic%>",function(msg)
    {
        $('#<%=contrl.getNumId()%>').val(msg).trigger('change');
    });
</script>
<%
        }
    }
%>