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
        data.put("msg", request.getParameter("msg")); 
        data.put("iclass", request.getParameter("iclass"));         
    }else if("c".equals(m))
    {
        String topic="";
        String msg="";
        String iclass="fa-play";
        DataObject ctrl=(DataObject)request.getAttribute("control");  
        if(ctrl!=null)
        {
            DataObject data = ctrl.getDataObject("data");
            topic = data.getString("topic");
            msg = data.getString("msg");
            iclass = data.getString("iclass");
        }

%>
<label>Topic</label>
<input name="topic" value="<%=topic%>" type="text" class="form-control" placeholder="Topic label..." required>
<label>Message</label>
<input name="msg" value="<%=msg%>" type="text" class="form-control" placeholder="Topic message..." required>  
<label>Icon class</label>
<div class="input-group">
    <input name="iclass" data-placement="bottomRight" class="form-control icp icp-auto" value="<%=iclass%>" type="text" />
    <span class="input-group-addon"></span>
</div>
<script type="text/javascript">$('.icp-auto').iconpicker();</script>
<%
    }else{
        DataObject contrl=(DataObject)request.getAttribute("control");
        if(contrl!=null)
        {
            //String ctrlid = contrl.getNumId();
            //String ctrtype = contrl.getString("type");
            DataObject doData = contrl.getDataObject("data");
            String topic = doData.getString("topic");
            String msg = doData.getString("msg");
            String title = contrl.getString("title");
            String iclass = doData.getString("iclass");
            if(iclass.length()==0)iclass=null;
%>
<a class="cdino_control" <%=(iclass==null)?"style=\"padding-top: 33px;\"":"style=\"padding-top: 20px;\""%> onclick="WS.post('<%=topic%>','<%=msg%>')">
    <i <%=(iclass!=null)?("class=\"fa fa-2x "+iclass+"\""):""%>></i>
    <p><%=title%></p>
</a>
<%
        }
    }
%>