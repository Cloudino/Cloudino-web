<%-- 
    Document   : testRules
    Created on : 04-nov-2015, 12:45:24
    Author     : javiersolis
--%>
<%@page import="jdk.nashorn.api.scripting.ScriptObjectMirror"%>
<%@page import="javax.script.ScriptEngine"%>
<%@page import="io.cloudino.rules.scriptengine.RuleEngineProvider"%>
<%@page import="java.io.IOException"%>
<%@page import="org.semanticwb.datamanager.DataList"%>
<%@page import="org.semanticwb.datamanager.SWBDataSource"%>
<%@page import="org.semanticwb.datamanager.SWBScriptEngine"%>
<%@page import="org.semanticwb.datamanager.DataMgr"%>
<%@page import="org.semanticwb.datamanager.DataObject"%>
<%@page import="java.util.Iterator"%>
<%@page import="io.cloudino.engine.DeviceMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
/*
    public DataList getOnDeviceMessageEvents(String devId, DataObject user) throws IOException
    {
        String type="cdino_ondevice_message";
        DataObject params=new DataObject().addParam("device", devId);
        return getOnEvents(type, user, params);
    }
*/
/*
    public void invokeEvent(String type, DataObject user, String context, DataObject params, Object... functParams) throws IOException
    {
        DataList<DataObject> ret=getOnEvents(type, user, context, params);
        RuleEngineProvider rep = RuleEngineProvider.getInstance();
        for(DataObject o : ret)
        {                
            ScriptEngine engine = rep.getEngine(o.getString("cloudRule"));
            ScriptObjectMirror evtents=(ScriptObjectMirror)engine.get("_cdino_events");        
            ScriptObjectMirror event=(ScriptObjectMirror)evtents.getSlot(o.getInt("arrayIndex"));
            event.callMember("funct", functParams);
            //out.println();        
        }        
    }
    
    public DataList getOnEvents(String type, DataObject user, String context, DataObject params) throws IOException
    {
        SWBScriptEngine engine = DataMgr.getUserScriptEngine("/cloudino.js", user);
        SWBDataSource ds = engine.getDataSource("CloudRuleEvent");
        DataObject obj=new DataObject();
        DataObject data=obj.addSubObject("data").addParam("type", type).addParam("user", user.getId());
        if(context!=null)data.addParam("context", context);
        data.addParam("params", params);
        DataObject ret=ds.fetch(obj);
        return ret.getDataObject("response").getDataList("data");
    }    
*/    

%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
<%
    DataObject user = (DataObject) session.getAttribute("_USER_");
    
    String dev="dev1";
    String context="contx1";
    
    RuleEngineProvider.invokeEvent("cdino_ondevice_message", user, context, new DataObject().addParam("device", dev), "topic..","msg..");        
%>        
    </body>
</html>
