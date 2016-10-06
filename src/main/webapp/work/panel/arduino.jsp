<%@page import="java.io.FileFilter"%>
<%@page import="io.cloudino.utils.ParamsMgr"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="io.cloudino.engine.DeviceMgr"%>
<%@page import="java.io.File"%>
<%@page import="org.semanticwb.datamanager.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    void addFile(File file, JspWriter out, File base, String tool, ParamsMgr params) throws IOException
    {
        if (file.isDirectory() && !file.isHidden()) {
            out.print("<li><a href=\"#\"><i class=\"fa fa-file-code-o\"></i>" + file.getName());
            out.print("<i class=\"fa fa-angle-left pull-right\"></i>");
            out.println("</a>");
     
            out.println("<ul class=\"treeview-menu\">");
            File[] sketcherFiles = file.listFiles();
            for (File sktFile : sketcherFiles) {
                if(sktFile.isDirectory())
                {
                    addFile(sktFile, out,base,tool,params);
                    
                }
                else if(!sktFile.isHidden())
                {
                    if(!sktFile.getName().equals("config.properties")){
                        if(base!=null)
                        {
                            if(sktFile.getName().endsWith(".txt")||sktFile.getName().endsWith(".ino")||sktFile.getName().endsWith(".c")||sktFile.getName().endsWith(".cpp")||sktFile.getName().endsWith(".h")){
                                out.println("<li><a data-target=\".content-wrapper\" data-load=\"ajax\" href=\""+tool+"?k="+params.setDataValues("fp",sktFile.getCanonicalPath(),"skt",file.getName(),"act","")+"\"><i class=\"fa fa-code\"></i>" + sktFile.getName() + "</a></li>");
                            } else {
                                out.println("<li><a data-target=\".content-wrapper\" data-load=\"ajax\" href=\""+tool+"?k="+params.setDataValues("fp",sktFile.getCanonicalPath(),"skt",file.getName(),"act","showImage") + "\"><i class=\"fa fa-code\"></i>" + sktFile.getName() + "</a></li>");
                            }
                        }else{
                            if(sktFile.getName().endsWith(".txt")||sktFile.getName().endsWith(".ino")||sktFile.getName().endsWith(".c")||sktFile.getName().endsWith(".cpp")||sktFile.getName().endsWith(".h")){
                                out.println("<li><a data-target=\".content-wrapper\" data-load=\"ajax\" href=\""+tool+"?k="+params.setDataValues("fn",sktFile.getName(),"skt",file.getName(),"act","")+"\"><i class=\"fa fa-code\"></i>" + sktFile.getName() + "</a></li>");
                            } else {
                                out.println("<li><a data-target=\".content-wrapper\" data-load=\"ajax\" href=\""+tool+"?k="+params.setDataValues("fp",sktFile.getCanonicalPath(),"fn", sktFile.getName(),"skt",file.getName(),"act","showImage") + "\"><i class=\"fa fa-code\"></i>" + sktFile.getName() + "</a></li>");
                            }
                        }
                    }
                }
            }
            if("sketcherDetail".equals(tool)){
                out.println("<li><a href=\"addSketcher?k="+params.setDataValues("skt", file.getName(),"act","newfile")+"\" data-target=\".content-wrapper\" data-load=\"ajax\"><i class=\"fa fa-gear\"></i> Nuevo Archivo</a></li> ");
            }
            out.println("</ul>");
            out.println("</li>");
        }        
    }
    
    void addExamples(File dir, JspWriter out, ParamsMgr params) throws IOException
    {
        File[] listFiles = dir.listFiles();
        for(File file : listFiles) {
            addFile(file, out,dir,"exampleDetail",params);
        }            
    }
    
    void searchExamples(File base, JspWriter out, ParamsMgr params) throws IOException
    {
        if(!base.exists())
        {
            System.out.println(base);
            return;
        }
        if(base.getName().equals("examples"))
        {
            addExamples(base, out, params);
        }else
        {
            File[] dirs=base.listFiles(new FileFilter() {
                @Override
                public boolean accept(File pathname) {
                    return pathname.isDirectory();
                }
            });
            for(File dir : dirs) {
                if(dir.getName().equals("examples"))
                {
                    out.print("<li><a href=\"#\"><i class=\"fa fa-file-code-o\"></i>" + base.getName());
                    out.print("<i class=\"fa fa-angle-left pull-right\"></i>");
                    out.println("</a>");
                    out.println("<ul class=\"treeview-menu\">");                    
                    addExamples(dir, out, params);
                    out.println("</ul>");
                    out.println("</li>");
                }else
                {
                    searchExamples(dir, out, params);
                }
            }
        }
    }
    
%>
<%
    DataObject user = (DataObject) session.getAttribute("_USER_");
    ParamsMgr params=new ParamsMgr(request.getSession());
    SWBScriptEngine engine = DataMgr.getUserScriptEngine("/cloudino.js", user);
    String act=request.getParameter("act");
    File arduinoPath=new File(engine.getScriptObject().get("config").getString("arduinoPath"));
    File usersWorkPath=new File(engine.getScriptObject().get("config").getString("usersWorkPath"));

%>
    <section class="sidebar" style_="overflow: scroll">
        <ul class="sidebar-menu">
            <li class="header">BLOCKING</li>
            <li class="treeview<%=("bl".equals(act)?" active":"")%>">
                <a href="#">
                    <i class="fa fa-cubes"></i>
                    <span>Blocks</span>
                    <i class="fa fa-angle-left pull-right"></i>
                </a>
                <ul class="treeview-menu">
                    <%
                    String workPath = DataMgr.getApplicationPath() + "/work/";
                    {
                        // leer estructura de archivos del usuario
                        String userBasePath = workPath + engine.getScriptObject().get("config").getString("usersWorkPath") + "/" + user.getNumId() + "/arduino/blocks";
                        File f = new File(userBasePath);
                        if (!f.exists()) {
                            f.mkdirs();
                        }
                        File[] listFiles = f.listFiles();
                        for (File file : listFiles) {
                            if(file.isDirectory() && !file.isHidden())
                            {
%>                                
                                <li><a href="blockDetail?ID=<%=file.getName()%>" data-target=".content-wrapper" data-load="ajax"><i class="fa fa-cube"></i><%=file.getName()%></a></li>
<%                                
                            }                                                        
                        }
                    }
                    %>
                    <li><a href="addBlock" data-target=".content-wrapper" data-load="ajax"><i class="fa fa-gear"></i> Add Block</a></li>
                </ul>
            </li>
            <li class="header">CODING</li>
            <li class="treeview<%=("sket".equals(act)?" active":"")%>">
                <a href="#">
                    <i class="fa fa-laptop"></i>
                    <span>Sketchers</span>
                    <i class="fa fa-angle-left pull-right"></i>
                </a>
                <ul class="treeview-menu">
                    <%
                    //String workPath = DataMgr.getApplicationPath() + "/work/";
                    {
                        //+ request.getRequestURI().substring(1, request.getRequestURI().lastIndexOf("/")) + "/"                        
                        
                        // leer estructura de archivos del usuario
                        String userBasePath = workPath + engine.getScriptObject().get("config").getString("usersWorkPath") + "/" + user.getNumId() + "/arduino/sketchers";
                        File f = new File(userBasePath);
                        if (!f.exists()) {
                            f.mkdirs();
                        }
                        File[] listFiles = f.listFiles();
                        for (File file : listFiles) {
                            addFile(file, out,null,"sketcherDetail",params);
                        }
                    }
                    %>
                    <li><a href="addSketcher" data-target=".content-wrapper" data-load="ajax"><i class="fa fa-gear"></i> Add Sketcher</a></li> 
                </ul>
            </li>
            <li class="treeview<%=("exa".equals(act)?" active":"")%>">
                <a href="#">
                    <i class="fa fa-laptop"></i>
                    <span>Examples</span>
                    <i class="fa fa-angle-left pull-right"></i>
                </a>
                <ul class="treeview-menu">
                    <%
                    searchExamples(new File(workPath+"/platforms/arduino/examples"), out, params);
                    %>
                    
                    <li class="header" style="color: #D8D8D8;padding: 10px">Builtin Libraries Examples</li>
                    <%
                    searchExamples(new File(arduinoPath+"/libraries"), out, params);
                    %>
                    <li class="header" style="color: #D8D8D8;padding: 10px">User Libraries Examples</li>
                    <%
                    searchExamples(new File(workPath+usersWorkPath+ "/" + user.getNumId()+"/arduino/libraries"), out, params);
                    %>                
                </ul>
            </li>            
            
            <li class="treeview<%=("lib".equals(act)?" active":"")%>">
                <a href="#">
                    <i class="fa fa-book"></i>
                    <span>Libraries</span>
                    <i class="fa fa-angle-left pull-right"></i>
                </a>
                <ul class="treeview-menu">
                    <li>
                        <a href="#"><i class="fa fa-globe"></i> Builtin Libraries<i class="fa fa-angle-left pull-right"></i></a>
                        <ul class="treeview-menu">
<%
                        {
                            String path = arduinoPath + "/libraries";
                            File f = new File(path);
                            File[] listFiles = f.listFiles();
                            for (File file : listFiles) {
                                addFile(file, out,f,"libraryDetail",params);
                            }
                        }
%>
                        </ul>
                    </li>
                    <li><a href="#"><i class="fa fa-book"></i> User Libraries<i class="fa fa-angle-left pull-right"></i></a>
                        <ul class="treeview-menu">
<%
                        {
                            String path = workPath + usersWorkPath + "/" + user.getNumId() + "/arduino/libraries";
                            File f = new File(path);
                            if (!f.exists()) {
                                f.mkdirs();
                            }
                            File[] listFiles = f.listFiles();
                            for (File file : listFiles) {
                                addFile(file, out,f,"libraryDetail",params);
                            }
                        }
%>
                            <li><a href="addLibrary" data-target=".content-wrapper" data-load="ajax"><i class="fa fa-gear"></i> Library Manager</a></li> 
                        </ul>
                    </li>
                </ul>
            </li>
        </ul>
    </section>
