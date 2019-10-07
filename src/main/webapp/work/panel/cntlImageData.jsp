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
        data.put("updTopic", request.getParameter("updTopic"));        
    }else if("c".equals(m))
    {
        String topic="";
        String updTopic="";
        DataObject ctrl=(DataObject)request.getAttribute("control");  
        if(ctrl!=null)
        {
            DataObject data = ctrl.getDataObject("data");
            topic = data.getString("topic");
            updTopic = data.getString("updTopic");
        }
%>
<label>Topic</label>
<input name="topic" value="<%=topic%>" type="text" class="form-control" placeholder="Topic label..." required>
<label>Update Topic</label>
<input name="updTopic" value="<%=updTopic%>" type="text" class="form-control" placeholder="Topic used to update image...">  
<%
    }else{
        DataObject contrl=(DataObject)request.getAttribute("control");
        System.out.println("contrl:"+contrl);
        if(contrl!=null)
        {
            //String ctrlid = contrl.getNumId();
            //String ctrtype = contrl.getString("type");
            String title = contrl.getString("title");
            DataObject doData = contrl.getDataObject("data");
            String topic = doData.getString("topic");
            String updTopic = doData.getString("updTopic");
            String url = "/api/getPublicBinaryData/"+contrl.getString("device")+"/"+topic;
%>
<div class="cdino_control_image" style="padding-top: 22px;">
    <img class="img-responsive" src="<%=url+"?time="+(new java.util.Date().getTime())%>" id="<%=contrl.getNumId()%>">
    <p style="padding-top: 6px;"><%=title%></p>
    <script type="text/javascript">WS.onMessage("<%=updTopic%>",function(msg){$("#<%=contrl.getNumId()%>")[0].src=<%=(url!=null&&url.length()>0)?"'"+url+"?time='+ new Date().getTime()":"msg"%>;});</script>
</div>
<%
        }
    }
%>