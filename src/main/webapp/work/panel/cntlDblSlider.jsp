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
        data.put("min", request.getParameter("min"));
        data.put("max", request.getParameter("max"));
        data.put("step", request.getParameter("step"));
    }else if("c".equals(m))
    {
        String topic="";
        String min="0";
        String max="255";
        String step="5";
        DataObject ctrl=(DataObject)request.getAttribute("control");  
        if(ctrl!=null)
        {
            DataObject data = ctrl.getDataObject("data");
            topic = data.getString("topic");
            min = data.getString("min",min);
            max = data.getString("max",max);
            step = data.getString("step",step);
        }

%>
<label>Topic</label>
<input name="topic" value="<%=topic%>" type="text" class="form-control" placeholder="Topic label..." required>
<label>Min Value</label>
<input name="min" value="<%=min%>" type="number" class="form-control" placeholder="0" required>
<label>Max Value</label>
<input name="max" value="<%=max%>" type="number" class="form-control" placeholder="255" required>
<label>Step</label>
<input name="step" value="<%=step%>" type="number" class="form-control" placeholder="255" required>
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
            String min = doData.getString("min","0");
            String max = doData.getString("max","255");
            String step = doData.getString("step","5");
            String title = contrl.getString("title");
%>
<div class="cdino_control" style="padding-top: 3px;">
    <input id="<%=contrl.getNumId()%>" type="text" value="<%=(value!=null)?value.toString():"[50,200]"%>" class="slider form-control" data-slider-min="<%=min%>" data-slider-max="<%=max%>"
                         data-slider-step="<%=step%>" data-slider-value="<%=(value!=null)?value.toString():"[50,200]"%>" data-slider-orientation="horizontal"
                         data-slider-selection="before" data-slider-tooltip="show" data-slider-id="dsid_<%=contrl.getNumId()%>">    
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