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
        data.put("msg_on", request.getParameter("msg_on")); 
        data.put("msg_off", request.getParameter("msg_off")); 
    }else if("c".equals(m))
    {
        String topic="";
        String msg_on="";
        String msg_off="";
        DataObject ctrl=(DataObject)request.getAttribute("control");  
        if(ctrl!=null)
        {
            DataObject data = ctrl.getDataObject("data");
            topic = data.getString("topic");
            msg_on = data.getString("msg_on");
            msg_off = data.getString("msg_off");
        }

%>
<label>Topic</label>
<input name="topic" value="<%=topic%>" type="text" class="form-control" placeholder="Topic label..." required>
<label>On Message</label>
<input name="msg_on" value="<%=msg_on%>" type="text" class="form-control" placeholder="On message..." required>  
<label>Off Message</label>
<input name="msg_off" value="<%=msg_off%>" type="text" class="form-control" placeholder="Off message..." required>  
<%
    }else{
        DataObject contrl=(DataObject)request.getAttribute("control");
        if(contrl!=null)
        {
            //String ctrlid = contrl.getNumId();
            //String ctrtype = contrl.getString("type");
            DataObject doData = contrl.getDataObject("data");
            String topic = doData.getString("topic");
            String msg_on = doData.getString("msg_on");
            String msg_off = doData.getString("msg_off");
            String title = contrl.getString("title");
%>
<div class="cdino_control" style="padding-top: 25px;">
    <i><input id="<%=contrl.getNumId()%>" type="checkbox"></i>
    <p style="padding-top: 9px;"><%=title%></p>
</div>
<script type="text/javascript">
    $("#<%=contrl.getNumId()%>").bootstrapSwitch();  
    
    $("#<%=contrl.getNumId()%>").on('switchChange.bootstrapSwitch', function(evt, state){
        if(state)WS.post('<%=topic%>','<%=msg_on%>');else WS.post('<%=topic%>','<%=msg_off%>');
    });
    
    WS.onMessage('<%=topic%>',function(msg){
        if(msg=='<%=msg_on%>')
            $("#<%=contrl.getNumId()%>").bootstrapSwitch("state",true,true);
        else if(msg=='<%=msg_off%>')
            $("#<%=contrl.getNumId()%>").bootstrapSwitch("state",false,true);
    });
</script>
<%
        }
    }
%>