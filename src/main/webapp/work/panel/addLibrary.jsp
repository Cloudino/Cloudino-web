<%-- 
    Document   : addLibrary
    Created on : 24/09/2015, 11:59:05 AM
    Author     : javier.solis
--%>
<%@page import="org.apache.commons.io.FileUtils"%>
<%@page import="java.util.zip.ZipEntry"%>
<%@page import="java.util.zip.ZipInputStream"%>
<%@page import="java.net.URLConnection"%>
<%@page import="io.cloudino.utils.Utils"%>
<%@page import="java.net.URL"%>
<%@page import="io.cloudino.utils.ParamsMgr"%>
<%@page import="java.util.Properties"%><%@page import="io.cloudino.compiler.ArdCompiler"%><%@page import="io.cloudino.engine.*"%><%@page import="java.util.ArrayList"%><%@page import="java.util.Iterator"%><%@page import="java.io.*"%><%@page import="java.net.URLEncoder"%><%@page contentType="text/html" pageEncoding="UTF-8"%><%@page import="org.semanticwb.datamanager.*"%>
<%!
    //Library Cache
    String libsLock="Libraries";
    DataObject libs=null;
    long libsUpdated=System.currentTimeMillis();
    DataList libsMap=null;
    
    
    public boolean installLibrary(String file,String name, String libpath) throws IOException
    {
        //System.out.println("path:"+file);
        //String file="https://github.com/arduino-libraries/Audio/archive/1.0.0.zip";
        //String name="Audio";
        //String userpath="/programming/proys/cloudino/server/Cloudino-web/target/Cloudino-web-1.0-SNAPSHOT/work/cloudino/users/55e0d655e4b0cb620e1910e5";
        
        URLConnection con=new URL(file).openConnection();
        ZipInputStream zip=new ZipInputStream((InputStream)con.getContent());
        
        //System.out.println("con:"+con+" "+zip);
        
        File rootDir=null;
        int BUFFER = 2048;
        ZipEntry entry=null;
        while((entry=zip.getNextEntry())!=null)
        {
            //System.out.println("entry:"+entry+" "+entry.isDirectory());
            if(!entry.isDirectory())
            {
                //System.out.println("file:"+entry.getName());
                File f=new File(libpath+entry.getName());
                f.getParentFile().mkdirs();
                if(rootDir==null)
                {
                    int i=entry.getName().indexOf('/');
                    if(i>-1)
                    {
                        rootDir=new File(libpath+entry.getName().substring(0,i));
                        System.out.println(rootDir);
                    }                    
                }
                FileOutputStream fout=new FileOutputStream(libpath+entry.getName());
                BufferedOutputStream dest = new BufferedOutputStream(fout, BUFFER);
                byte data[] = new byte[BUFFER];
                int count=0;                
                while ((count = zip.read(data, 0, BUFFER)) != -1) {
                    dest.write(data, 0, count);
                }
                dest.flush();
                dest.close();
            }
            
        }
        if(rootDir!=null)
        {
            rootDir.renameTo(new File(rootDir.getParent(),name));
        }else
        {
            return false;
        }
        return true;
    }
    
    
%>
<%
    //Library Cache for 60 minutes
    if(libs==null || System.currentTimeMillis()-libsUpdated>1000*60*60)
    {
        synchronized(libsLock)
        {
            if(libs==null || System.currentTimeMillis()-libsUpdated>1000*60*60)
            {
                libs=Utils.readJsonFromUrl("http://downloads.arduino.cc/libraries/library_index.json");
                libsUpdated=System.currentTimeMillis();
                                
                if(libs!=null)
                {
                    libsMap=new DataList(); 
                    DataObject lastLib=null;
                    DataList<DataObject> list=libs.getDataList("libraries");
                    for(DataObject lib : list)
                    {
                        String name=lib.getString("name");
                        if(lastLib==null || !name.equals(lastLib.getString("name")))
                        {
                            libsMap.add(lib);
                            DataList vers=new DataList();
                            vers.add(new DataObject().addParam("version", lib.getString("version")).addParam("url", lib.getString("url")));
                            lib.put("versions", vers);
                            //lib.remove("version");
                            //lib.remove("url");
                            lastLib=lib;
                        }else
                        {
                            lastLib.getDataList("versions").add(new DataObject().addParam("version", lib.getString("version")).addParam("url", lib.getString("url")));
                        }
                    }     
                }
                //System.out.println("libsMap:"+libsMap);                
            }
        }
    }
    
    //out.print(libs);
%>   
<%
    DataObject user = (DataObject) session.getAttribute("_USER_");    
    SWBScriptEngine engine = DataMgr.getUserScriptEngine("/cloudino.js", user);

    String appPath = config.getServletContext().getRealPath("/");
    String libpath = appPath + "/work"+engine.getScriptObject().get("config").getString("usersWorkPath") + "/" + user.getNumId() +"/arduino/libraries/";

    String name = request.getParameter("name");
    String version = request.getParameter("version");
    String uninst = request.getParameter("uninst");
     
    if(name!=null && name.indexOf("..")==-1 && uninst!=null)
    {
        FileUtils.deleteDirectory(new File(libpath+name.replace(' ', '_')));
%>
    <script type="text/javascript">
        cdino_alert("Success","Library was uninstalled...","success",3000);
    </script>  
<%           
        out.println("<script type=\"text/javascript\">loadContent('/panel/arduino?act=lib','#arduino');</script>");

    }else if(name!=null && version!=null)
    {
        String file=null;        
        
        //System.out.println("("+name+")("+version+")");
        
        DataList<DataObject> list=libs.getDataList("libraries");
        for(DataObject lib : list)
        {
            //System.out.println("("+lib.getString("name")+")("+lib.getString("version")+")");
            if(name.equals(lib.getString("name")) && version.equals(lib.getString("version")))
            {
                //System.out.println("(url)("+lib.getString("url")+")");
                file=lib.getString("url");
                break;
            }
        }
        
        boolean ret=false;
        try
        {
            ret=installLibrary(file, name.replace(' ', '_'), libpath);
        }catch(Exception e)
        {
            e.printStackTrace();
        }
        
        if(!ret)            
        {
%>
    <script type="text/javascript">
        cdino_alert("Error","Error at install library...","warning",3000);
    </script>        
<%          
            out.println("<script type=\"text/javascript\">loadContent('/panel/arduino?act=lib','#arduino');</script>");
            
        }else
        {
%>
    <script type="text/javascript">
        cdino_alert("Success","Library was installed...","success",3000);
    </script>       
<%        
            out.println("<script type=\"text/javascript\">loadContent('/panel/arduino?act=lib','#arduino');</script>");            
        }
    }
%>
<section class="content-header">
    <h1>
        Library Manager
        <small><%=libsMap.size()%> Libraries</small>
    </h1>
    <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Panel</a></li>
        <li><a href="#">Libraries</a></li>
        <li class="active">Library Manager</li>
    </ol>
</section>

<!-- Main content -->
<section class="content">
    <div class="row">
        <div class="col-md-12">

            <div class="box box-primary">
                <div class="box-header">
                    <h3 class="box-title">Libraries</h3>
                </div><!-- /.box-header -->

                <div class="row">
                    <div class="col-xs-12">                     
                        <table class="table table-striped">
                            <tbody>
<%
    DataList<DataObject> list=libsMap;
    for(DataObject lib : list)
    {
        out.println("<tr><td>");
        
        if(lib.getString("website")!=null && lib.getString("website").length()>0)
        {
            out.println("Name: <a href=\""+lib.getString("website")+"\">"+lib.getString("name").replace('_', ' ')+"</a><br/>");
        }else
        {
            out.println(""+lib.getString("name").replace('_', ' ')+"<br/>");
        }        
        out.println("Author: "+lib.getString("author")+"<br/>"); 
        out.println("Category: "+lib.getString("category")+"<br/>");
        out.println("Architectures: "+lib.getString("architectures")+"<br/>");        
        out.println("</td>");
        
        out.println("<td>");
        out.println(lib.getString("sentence")+"<br/>"+lib.getString("paragraph","")+"<br/>");
        
        out.print("Version: <select id='_ver_"+lib.getString("name").replace(' ', '_')+"'>");
        DataList<DataObject> vers=lib.getDataList("versions");
        for(int x=vers.size();x>0;x--)
        {
            DataObject ver=vers.get(x-1);
            out.println("<option value='"+ver.getString("version")+"'>"+ver.getString("version")+"</option>");            
        }
        out.println("</select> ");        
        
        if(!(new File(libpath+lib.getString("name").replace(' ', '_')).exists()))
        {
            out.println("<button class=\"btn btn-sm btn-primary\" onclick=\"return installLib('"+lib.getString("name")+"',_ver_"+lib.getString("name").replace(' ', '_')+".value)\">Install</button>");
        }else
        {
            out.println("<button class=\"btn btn-sm btn-primary btn-danger\" onclick=\"return removeLib('"+lib.getString("name")+"')\">Uninstall</button>");
        }                
        out.println("</td>");        
        
        out.print("</tr>");
        
        //out.println("                                   <td>"+lib.getString("maintainer")+"</td>");
        //out.println("                                   <td>"+lib.getString("paragraph")+"</td>");
    }
%>                                
                            </tbody>
                        </table>
                    </div><!-- /.col -->
                </div>

            </div>

        </div>

    </div>   <!-- /.row -->
</section><!-- /.content -->
<script type="text/javascript">
    function installLib(name,version){
        var urlRemove = 'addLibrary?name='+name+'&version='+version;
        loadContent(urlRemove,".content-wrapper");
        return false;
    }
    function removeLib(name){
            if(confirm('Are you sure to remove this library?')){
                var urlRemove = 'addLibrary?name='+name+'&uninst=true';
                loadContent(urlRemove,".content-wrapper");
            }
        return false;
     }
</script>  