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
<div class="cdino_control" style="width: 100%; height: 350px;left: -10px;padding: 2px">
    <div id="<%=contrl.getNumId()%>" style="height: 300px"></div>
    <p style="padding-top: 6px;"><%=title%></p>
    <script type="text/javascript">
        (function(){
            WS.onMessage("<%=topic%>",function(msg){setMarker(msg)});            
            var map = new google.maps.Map(document.getElementById('<%=contrl.getNumId()%>'), {
                zoom: 5,
                center: {lat: 23.3584948, lng: -99.9321301},
                //mapTypeId: 'terrain'
            });
            
            var marker=null;
            
            function setMarker(value)
            {
                var loc=JSON.parse(value);
                console.log(loc);
                //var l={lat:loc.lat,lng:loc.lng};
                //console.log(l);
                if(marker==null)
                {
                    marker = new google.maps.Marker({
                        position: loc,
                        map: map,
                        title: 'Hello World!'
                    });        
                    map.setZoom(10);
                }else
                {
                    marker.setPosition(loc);
                }
                map.setCenter(loc);                    
            }
            
            setMarker('<%=value!=null?value.toString().replace("'","\'"):null%>');
          
        })();
        
    </script>
</div>
<%
        }
    }
%>