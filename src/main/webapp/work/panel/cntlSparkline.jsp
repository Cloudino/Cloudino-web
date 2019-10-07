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
        data.put("graph_type", request.getParameter("graph_type"));
        data.put("size", request.getParameter("size"));
        data.put("width", request.getParameter("width"));
        data.put("min", request.getParameter("min"));
        data.put("max", request.getParameter("max"));
    }else if("c".equals(m))
    {
        String topic="";
        String graph_type="line";
        String size="20";
        String width="100";
        String min="";
        String max="";
        DataObject ctrl=(DataObject)request.getAttribute("control");  
        if(ctrl!=null)
        {
            DataObject data = ctrl.getDataObject("data");
            topic = data.getString("topic");
            graph_type = data.getString("graph_type",graph_type);
            size = data.getString("size",size);
            width = data.getString("width",width);
            min = data.getString("min",min);
            max = data.getString("max",max);
        }

%>
<label>Topic</label>
<input name="topic" value="<%=topic%>" type="text" class="form-control" placeholder="Topic Name..." required>
<label>Graph Type</label>
<select name="graph_type" class="form-control">
    <option value="line" <%=graph_type.equals("line")?"selected":""%>>Line</option>
    <option value="bar" <%=graph_type.equals("bar")?"selected":""%>>Bar</option>
    <option value="tristate" <%=graph_type.equals("tristate")?"selected":""%>>Tristate</option>
    <option value="discrete" <%=graph_type.equals("discrete")?"selected":""%>>Discrete</option>
    <option value="bullet" <%=graph_type.equals("bullet")?"selected":""%>>Bullet</option>
    <option value="pie" <%=graph_type.equals("pie")?"selected":""%>>Pie</option>
    <option value="box" <%=graph_type.equals("box")?"selected":""%>>Box Plot</option>
</select>
<label>Graph Width</label>
<input name="width" value="<%=width%>" type="text" class="form-control" placeholder="Graph Width...">
<label>Data Size</label>
<input name="size" value="<%=size%>" type="text" class="form-control" placeholder="Data Size..">
<label>Min Vakue</label>
<input name="min" value="<%=min%>" type="text" class="form-control" placeholder="Min Value..">
<label>Max Value</label>
<input name="max" value="<%=max%>" type="text" class="form-control" placeholder="Max Value..">
<%
    }else{
        DataObject contrl=(DataObject)request.getAttribute("control");
        if(contrl!=null)
        {
            //String ctrlid = contrl.getNumId();
            //String ctrtype = contrl.getString("type");
            DataObject doData = contrl.getDataObject("data");
            String title = contrl.getString("title");
            String topic = doData.getString("topic");
            String graph_type = doData.getString("graph_type","line");
            String size = doData.getString("size","20");
            String width = doData.getString("width","100");
            String min = doData.getString("min","");
            String max = doData.getString("max","");
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
        if(v_<%=contrl.getNumId()%>.length><%=size%>)v_<%=contrl.getNumId()%>.shift();
        $('#<%=contrl.getNumId()%>').sparkline(v_<%=contrl.getNumId()%>, {
            type: '<%=graph_type%>',
            lineColor: '#92c1dc',
            fillColor: "#ebf4f9",
            <%if(min.length()>0){%>normalRangeMin: <%=min%>,<%}%>
            <%if(max.length()>0){%>normalRangeMax: <%=max%>,<%}%>       
            height: '60',
            width: '<%=width%>'
        });
    });
</script>
<%
        }
    }
%>