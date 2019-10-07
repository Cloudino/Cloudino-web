<%-- 
    Document   : ardown
    Created on : 01-feb-2018, 0:47:54
    Author     : javiersolis
--%><%@page import="java.io.*"%><%@page import="io.cloudino.utils.*"%><%@page import="org.semanticwb.datamanager.*"%><%@page import="java.util.concurrent.TimeUnit"%><%@page import="java.io.OutputStream"%><%@page import="java.io.FileInputStream"%><%@page import="java.io.File"%><%
    DataObject user = (DataObject) session.getAttribute("_USER_");
    SWBScriptEngine engine = DataMgr.getUserScriptEngine("/cloudino.js", user);

    String id = request.getParameter("ID");
    String act = request.getParameter("act"); 
    
    if("down".equals(act))
    {
        String ini=request.getParameter("ini");
        String end=request.getParameter("end");
        String chunk=request.getParameter("chunk");
        String chunkDelay=request.getParameter("chunkDelay");
        
        String file = "/work/cloudino/devices/"+id+"/firmware/update.bin";

        if (file != null) {
            String appPath = config.getServletContext().getRealPath("/");
            File f = new File(appPath,file);
            if (f.exists()) {
                long len = f.length();
                if(end!=null)len=Integer.parseInt(end);
                //response.setContentLength((int) l);
                OutputStream o=response.getOutputStream();

                FileInputStream in=new FileInputStream(f);
                if(ini!=null)
                {
                    int i=Integer.parseInt(ini);
                    in.skip(i);
                    len-=i;
                }

                int bufferSize=1024;
                if(chunk!=null)
                {            
                    bufferSize=Integer.parseInt(chunk);
                }

                byte[] bfile = new byte[bufferSize];
                int x;
                while (len>0 && (x = in.read(bfile, 0, (bufferSize>len)?(int)len:bufferSize)) > -1) 
                {
                    o.write(bfile, 0, x);
                    o.flush();
                    len-=x;
                    if(chunkDelay!=null)
                    {
                        TimeUnit.MILLISECONDS.sleep(Integer.parseInt(chunkDelay));
                    }
                }            
                in.close();
                return;
            }
        }    
    }else if("arduino_down".equals(act))
    {
        //String uid = request.getParameter("uid");
        String fname = request.getParameter("fname");

        String appPath = config.getServletContext().getRealPath("/");
        String dir = appPath + "work";
        String userPath = dir + engine.getScriptObject().get("config").getString("usersWorkPath") + "/" + id +"/arduino";
        String userBuildPath = userPath + "/build";

        String compiled = userBuildPath + "/" + fname + ".cpp.hex"; 

        HexSender obj=new HexSender();
        System.out.println("compiled:"+compiled);

        HexSender.Data[] data=obj.readHex(new FileInputStream(compiled));
        ByteArrayOutputStream b=new ByteArrayOutputStream();
        obj.programData(data,b);
        System.out.println("size:"+b.size());
        response.setContentLength(b.size());
        response.getOutputStream().write(b.toByteArray());   
        return;
    }else if("arduino_down_bin".equals(act))
    {
        String appPath = config.getServletContext().getRealPath("/");
        String compiled = appPath + "/work/cloudino/devices/"+id+"/firmware/update.bin";        

        HexSender obj=new HexSender();
        //System.out.println(compiled);

        HexSender.Data[] data=obj.readHex(new FileInputStream(compiled));
        ByteArrayOutputStream b=new ByteArrayOutputStream();
        obj.programData(data,b);
        response.setContentLength(b.size());
        response.getOutputStream().write(b.toByteArray());  
        return;
    }
%>