<%@page import="org.semanticwb.datamanager.*"%><%@page import="java.util.Iterator"%><%@page import="io.cloudino.engine.*"%><%@page contentType="text/html" pageEncoding="UTF-8"%><%!

%><%
    DataObject user = (DataObject) session.getAttribute("_USER_");
    SWBScriptEngine engine = DataMgr.getUserScriptEngine("/cloudino.js", user); 
    DeviceMgr mgr=DeviceMgr.getInstance();

    SWBDataSource ds = engine.getDataSource("Device");
    DataObject query = new DataObject();
    query.addSubList("sortBy").add("name");
    DataObject data = new DataObject();
    query.put("data", data);
    data.put("user", user.getId());
    DataObject ret = ds.fetch(query);
    //System.out.println(ret);
    DataList<DataObject> devices = ret.getDataObject("response").getDataList("data");
    if (devices != null) {
        for (DataObject dev : devices) {
            String id = dev.getNumId();
            if (mgr.isDeviceConnected(id)) {
                out.print("<small class=\"label pull-right bg-green\" style=\"margin-top: 7px;\">online</small>");
            }
            out.print("<li dev=\""+id+"\"><a href=\"deviceDetail?ID=" + id + "\" class=\"cdino_text_menu\" data-target=\".content-wrapper\" data-load=\"ajax\"><i class=\"fa fa-circle-o\"></i><span>" + dev.getString("name") + "</span>");
            out.println("</a></li>");
        }
    }
%>
<li><a href="addDevice" data-target=".content-wrapper" data-load="ajax"><i class="fa fa-gear"></i> Add Device</a></li>