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
        data.put("url", request.getParameter("url"));
    }else if("c".equals(m))
    {
        String topic="";
        String url="";
        DataObject ctrl=(DataObject)request.getAttribute("control");  
        if(ctrl!=null)
        {
            DataObject data = ctrl.getDataObject("data");
            topic = data.getString("topic");
            url = data.getString("url");
        }
%>
<label>Topic</label>
<input name="topic" value="<%=topic%>" type="text" class="form-control" placeholder="Topic label..." required>
<label>URL</label>
<input name="url" value="<%=url%>" type="text" class="form-control" placeholder="Fixed Image URL or Blank to use Mesage of Topic...">  
<%
    }else{
        DataObject contrl=(DataObject)request.getAttribute("control");
        if(contrl!=null)
        {
            //String ctrlid = contrl.getNumId();
            //String ctrtype = contrl.getString("type");
            String title = contrl.getString("title");
            DataObject doData = contrl.getDataObject("data");
            String topic = doData.getString("topic");
            String url = doData.getString("url");
%>
<div class="cdino_control_image" style="padding-top: 22px;">
    <img class="img-responsive" src="<%=url%>" id="<%=contrl.getNumId()%>">
    <p style="padding-top: 6px;"><%=title%></p>
    <script type="text/javascript">WS.onMessage("<%=topic%>",function(msg){$("#<%=contrl.getNumId()%>")[0].src=<%=(url!=null&&url.length()>0)?"'"+url+"?time='+ new Date().getTime()":"msg"%>;});</script>
</div>
<%
        }
    }
%>