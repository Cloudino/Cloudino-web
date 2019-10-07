<%-- 
    Document   : post
    Created on : 15-jun-2017, 22:08:23
    Author     : javiersolis
--%><%@page import="java.io.IOException"%><%@page import="io.cloudino.utils.Utils"%><%@page import="java.io.ByteArrayOutputStream"%><%@page import="org.semanticwb.datamanager.*"%><%@page import="java.util.*"%><%@page import="io.cloudino.engine.*"%><%@page contentType="text/plain" pageEncoding="UTF-8"%><%!

    private String getPostData(HttpServletRequest request) throws IOException
    {
        String ret=null;

        if(request.getMethod().equals("POST"))
        {
            ByteArrayOutputStream o=new ByteArrayOutputStream();
            Utils.copyStream(request.getInputStream(), o);        
            byte data[]=o.toByteArray();
            ret=new String(data,"UTF-8");
            System.out.println("getPostData:"+new String(data,"UTF-8"));
        }
        return ret;
    }

%><%
    
    String cloudinoKey="zjC5pmZ1I80RfmiQDeL4uP6iJHfvafcgObUEIWpVcqpbg9cIghmYTiLTZcwn0h7c";
    String authToken="2saspgeih680psjqsz4x2g45laaminrrzwyv8x1";         //Foco Demo
    
    String uri=request.getRequestURI();
    StringTokenizer st=new StringTokenizer(uri,"/");
    String api=st.nextToken();
    String ifttt=st.nextToken();
    String v1=null;
    String sname=null;
    if(st.hasMoreTokens())v1=st.nextToken();
    if(st.hasMoreTokens())sname=st.nextToken();
    if(v1==null)
    {
        out.println("Cloudino IFTTT API");
        return;
    }else
    {
        if(sname!=null)
        {
            String serviceKey=request.getHeader("IFTTT-Service-Key");
            String requestID=request.getHeader("X-Request-ID");
            
            response.setContentType("application/json");
            //response.setCharacterEncoding("utf8");
            response.setHeader("Accept", "application/json");
            
            //System.out.println("servicekey:"+serviceKey);
            //System.out.println("requestID:"+requestID);

            if(!cloudinoKey.equals(serviceKey))
            {
                response.setStatus(401);                
                DataObject err=new DataObject();  
                err.addSubList("errors").add(new DataObject().addParam("message", "Ivalid IFTTT Service Key"));
                out.print(err);
                return;
            }            
            
            if(sname.equals("status"))
            {                
                return;
            }else if(sname.equals("test"))
            {
                String ssname=null;
                if(st.hasMoreTokens())ssname=st.nextToken();
                if("setup".equals(ssname))
                {
/*
{
  "data": {
    "samples": {
      "triggers": {
        "onDeviceMessage": {
          "auth_token": "",
          "topic": ""
        },
        "onServerMessage": {
          "auth_token": "",
          "topic": ""
        }
      },
      "actions": {
        "postServerMessage": {
          "auth_token": "",
          "topic": "",
          "msg": ""
        },
        "postDeviceMessage": {
          "auth_token": "",
          "topic": "",
          "msg": ""
        }
      },
      "actionRecordSkipping": {
        "postServerMessage": {
          "auth_token": "",
          "topic": "",
          "msg": ""
        },
        "postDeviceMessage": {
          "auth_token": "",
          "topic": "",
          "msg": ""
        }
      }
    }
  }
}
*/                                             
                    DataObject obj=new DataObject();
                    DataObject data=obj.addSubObject("data");
                    DataObject samples=data.addSubObject("samples");
                    
                    DataObject triggers=samples.addSubObject("triggers");
                    DataObject onDeviceMessage=triggers.addSubObject("onDeviceMessage").addParam("auth_token", authToken).addParam("topic", "temperature");  
                    DataObject onServerMessage=triggers.addSubObject("onServerMessage").addParam("auth_token", authToken).addParam("topic", "temperature");  
                    
                    DataObject actions=samples.addSubObject("actions");
                    DataObject postDeviceMessage=actions.addSubObject("postDeviceMessage").addParam("auth_token", authToken).addParam("topic", "lamp").addParam("msg", "on");                    
                    DataObject postServerMessage=actions.addSubObject("postServerMessage").addParam("auth_token", authToken).addParam("topic", "lamp").addParam("msg", "on");                    
                    
                    DataObject actionRecordSkipping=samples.addSubObject("actionRecordSkipping");
                    DataObject postDeviceMessage2=actionRecordSkipping.addSubObject("postDeviceMessage").addParam("auth_token", authToken+"_err").addParam("topic", "lamp").addParam("msg", "on");                    
                    DataObject postServerMessage2=actionRecordSkipping.addSubObject("postServerMessage").addParam("auth_token", authToken+"_err").addParam("topic", "lamp").addParam("msg", "on");                    
                                   
                    out.print(obj);
                }                    
            }else if(sname.equals("triggers"))
            {
                String ssname=null;
                if(st.hasMoreTokens())ssname=st.nextToken();
                if("onDeviceMessage".equals(ssname) || "onServerMessage".equals(ssname))
                {
                    String json=getPostData(request);
                    if(json!=null)
                    {
                        DataObject obj=(DataObject)DataObject.parseJSON(json);
                        //System.out.println("obj:"+obj);
                        String trigger_identity=obj.getString("trigger_identity");
                        DataObject triggerFields=obj.getDataObject("triggerFields");
                        
                        if(triggerFields==null)
                        {
                            DataObject err=new DataObject();  
                            err.addSubList("errors").add(new DataObject().addParam("message", "No Trigger Fields Found"));
                            response.setStatus(400);
                            out.print(err);
                            return;
                        }                        
                        
                        String auth_token=triggerFields.getString("auth_token");
                        String topic=triggerFields.getString("topic");
                        int limit=obj.getInt("limit",-1);
                        
                        //System.out.println("trigger_identity:"+trigger_identity);
                        //System.out.println("auth_token:"+auth_token);
                        //System.out.println("topic:"+topic);
                        
                        if(auth_token==null)
                        {
                            DataObject err=new DataObject();  
                            err.addSubList("errors").add(new DataObject().addParam("message", "No Auth Token Found"));
                            response.setStatus(400);
                            out.print(err);
                            return;
                        }
                                                
                        //TODO: get data
                        DataObject ret=new DataObject();
                        DataList data=ret.addSubList("data");
                        for(int x=0;x<(limit>-1?limit:5);x++)
                        {
                            DataObject item=new DataObject();
                            item.addParam("topic", "temperature");
                            item.addParam("msg", ""+x);
                            item.addParam("created_at", DataUtils.TEXT.iso8601DateFormat(new Date()));                            
                            item.addSubObject("meta").addParam("id", DataUtils.createId()).addParam("timestamp", (long)(System.currentTimeMillis()/1000));
                            data.add(item);
                        }
                        
                        out.print(ret);
                    }
                }
            }else if(sname.equals("actions"))
            {
                String ssname=null;
                if(st.hasMoreTokens())ssname=st.nextToken();
                if("postDeviceMessage".equals(ssname) || "postServerMessage".equals(ssname))
                {
                    String json=getPostData(request);
                    if(json!=null)
                    {
                        DataObject obj=(DataObject)DataObject.parseJSON(json);
                        //System.out.println("obj:"+obj);
                        DataObject actionFields=obj.getDataObject("actionFields");
                        
                        if(actionFields==null)
                        {
                            DataObject err=new DataObject();  
                            err.addSubList("errors").add(new DataObject().addParam("message", "No Action Fields Found"));
                            response.setStatus(400);
                            out.print(err);
                            return;
                        }                        
                        
                        String auth_token=actionFields.getString("auth_token");
                        String topic=actionFields.getString("topic");
                        String msg=actionFields.getString("msg");
                        
                        //System.out.println("auth_token:"+auth_token);
                        //System.out.println("topic:"+topic);
                        //System.out.println("msg:"+msg);
                        
                        if(auth_token==null)
                        {
                            DataObject err=new DataObject();  
                            err.addSubList("errors").add(new DataObject().addParam("message", "No Auth Token Found"));
                            response.setStatus(400);
                            out.print(err);
                            return;
                        }
                                                
                        //TODO: post data
                        boolean sendData=false;
                        boolean error=false;
                        String id=DeviceMgr.getInstance().getDeviceIdByAuthToken(auth_token);
                        if(id!=null)
                        {
                            if("postDeviceMessage".equals(ssname))
                            {
                                Device device=DeviceMgr.getInstance().getDeviceIfPresent(id);
                                if(device!=null)
                                {
                                    if(device.isConnected())
                                    {
                                        sendData=device.post(topic, msg);
                                    }
                                }else error=true;
                            }else if("postServerMessage".equals(ssname))
                            {
                                Device device=DeviceMgr.getInstance().getDevice(id);
                                if(device!=null)
                                {
                                    device.receive(topic, msg);
                                    sendData=true;
                                }else error=true;
                            }
                        }else error=true;
                        
                        if(sendData && !error)
                        {                        
                            DataObject ret=new DataObject();
                            DataList data=ret.addSubList("data");
                            DataObject item=new DataObject();
                            item.addParam("id", DataUtils.createId());
                            data.add(item);
                            out.print(ret);
                        }else
                        {                            
                            DataObject err=new DataObject();  
                            if(error)
                            {                                
                                err.addSubList("errors").add(new DataObject().addParam("message", "Device not exist").addParam("status", "SKIP"));
                            }else
                            {
                                err.addSubList("errors").add(new DataObject().addParam("message", "Device is offline"));
                            }
                            response.setStatus(400);
                            out.print(err);                            
                        }
                    }
                }
            }else
            {
                System.out.println("sname:"+sname);
            }
        }else
        {
            response.sendError(404);
        }
    }        
%>