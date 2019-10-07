<%-- 
    Document   : initialjs
    Created on : 28-ene-2016, 18:55:16
    Author     : javiersolis
--%><%@page import="java.util.Arrays"%>
<%@page import="io.cloudino.utils.Utils"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.File"%>
<%@page import="org.semanticwb.datamanager.SWBDataSource"%>
<%@page import="io.cloudino.engine.Device"%>
<%@page import="io.cloudino.engine.DeviceMgr"%>
<%@page import="org.semanticwb.datamanager.DataMgr"%>
<%@page import="org.semanticwb.datamanager.SWBScriptEngine"%>
<%@page import="org.semanticwb.datamanager.DataObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%><%
    DataObject user = (DataObject) session.getAttribute("_USER_");
    SWBScriptEngine engine = DataMgr.getUserScriptEngine("/cloudino.js", user);

    //id del dispositivo
    String id = request.getParameter("ID");
    String code = request.getParameter("code");

    StringBuffer msg=new StringBuffer();
    
    Device device = DeviceMgr.getInstance().getDeviceIfPresent(id);
    DataObject data = null;

    if (device != null) {
        data = device.getData();
    } else {
        SWBDataSource ds = engine.getDataSource("Device");
        data = ds.fetchObjByNumId(id);
    }

    if (data == null || (data != null && !data.getString("user").equals(user.getId()))) {
        response.sendError(404);
        return;
    }

    if(code!=null)
    {
        code=code.replaceAll("\r", "");
        data.put("jscode", code);
        //System.out.println("code:"+code.length());
        SWBDataSource ds = engine.getDataSource("Device");
        ds.updateObj(data);
        msg.append("<div>Code saved...</div>");
        if (device != null)
        {
            if(device.post("$CDINOJSINIT", code))
            {
                msg.append("<div>Code uploaded...</div>");
            }else
            {
                msg.append("<div>Error uploading code...</div>");
            }
        }
    }else
    {
        code=data.getString("jscode");
    }
    
    
    String skt = request.getParameter("skt");
    String appPath = config.getServletContext().getRealPath("/");
    String dir = appPath + "/work";
    String userPathjs = dir + engine.getScriptObject().get("config").getString("usersWorkPath") + "/" + user.getNumId()+"/cloudinojs";
    String sketcherDefault = data.getString("sketcher", null);
    if(skt!=null)
    {
        data.put("sketcher", skt);
        sketcherDefault=skt;
        String path=userPathjs;
        if(skt.startsWith("sk_"))
        {
            skt=skt.substring(3);
            path+="/sketchers";
        }else
        {
            skt=skt.substring(3);
            path+="/blocks";
        }            
        path+="/" + skt + "/" + skt + ".js";

        System.out.println("path:"+path);

        if (device != null)
        {
            FileInputStream in = new FileInputStream(path);
            code = Utils.textInputStreamToString(in, "utf8");
            
            if(device.post("$CDINOJSINIT", code))
            {
                msg.append("Device programmed successfully.");                    
                if(data!=null)
                {
                    data.put("jscode", code);
                    SWBDataSource ds = engine.getDataSource("Device");
                    ds.updateObj(data);
                }     
            }else
            {
                msg.append("Device offline, could not be programmed.");
            }
        }else
        {
            msg.append("Device offline, could not be programmed.");
        }
    }    
    
    if(code==null)code="";
%>
<div>
    <form data-submit="ajax" data-target="#tab_6" action="deviceInitialjs" role="form">
        <input type="hidden" name="ID" value="<%=id%>">   
        <label>Startup Script</label>
        <textarea name="code" id="code"><%=code%></textarea>   
        <script type="text/javascript">

            var myCodeMirror = CodeMirror.fromTextArea(code, {
                mode: "text/javascript",
                smartIndent: true,
                lineNumbers: true,
                styleActiveLine: true,
                matchBrackets: true,
                autoCloseBrackets: true,
                theme: "eclipse",
                continueComments: "Enter",
                extraKeys: {"Ctrl-Space": "autocomplete","Ctrl-Q": "toggleComment","Ctrl-J": "toMatchingTag"},
                matchTags: {bothTags: true},                  

                gutters: ["CodeMirror-lint-markers"],
                lint: true,

            });
            myCodeMirror.setSize("100%", 300);

            $('a[data-toggle="tab"]').on('shown.bs.tab', function(e) {
                myCodeMirror.refresh();
                //console.log('shown.bs.tab', e);
            });

        </script>    
        <div class="cdino_buttons">
            <input type="submit" value="Upload Script" onclick="console.log(this.form.code);this.form.code.value=myCodeMirror.getValue();return true;"  class="btn btn-primary" >
        </div>
    </form> 
</div>
<hr/>    
<div>
    <form data-submit="ajax" data-target="#tab_6" action="deviceInitialjs" role="form">
        <input type="hidden" name="ID" value="<%=id%>">
        <!-- select -->
        <div class="form-group has-feedback">
            <div class_="col-md-2 pull-left">
            <label>Upload from Sketcher</label>
            </div>
            <div class_="col-md-8 pull-left">
            <select name="skt" id="skt" class="form-control">                                        
<%
    {
        File fblockjs = new File(userPathjs+"/blocks");
        if (!fblockjs.exists()) {
            fblockjs.mkdirs();
        }   

        File[] listFiles = fblockjs.listFiles();
        Arrays.sort(listFiles);
        for (File file : listFiles) {
            if (file.isDirectory() && !file.isHidden()) {
                String dirName = file.getName();
                if(dirName.indexOf("_")>-1){
                    dirName = dirName.substring(0,dirName.indexOf("_"));
                }
                //System.out.println(dirName);
                File[] list = file.listFiles();
                Arrays.sort(list);
                for(File inoFile:list){
                    String fileName = inoFile.getName();
                    //System.out.println("Revisando..."+dirName+" con: "+fileName);
                    if(fileName.startsWith(dirName)&&fileName.endsWith(".js")){
                        out.println("<option value=\"bk_" + file.getName()+"\" "+(sketcherDefault!=null&&sketcherDefault.equals("bk_"+file.getName())?"selected":"")+" >" + file.getName() + " (Block)</option>");
                    }
                }
            }
        }
    }
    {
        File fsketchjs = new File(userPathjs+"/sketchers");
        if (!fsketchjs.exists()) {
            fsketchjs.mkdirs();
        }                                            

        File[] listFiles = fsketchjs.listFiles();
        Arrays.sort(listFiles);
        for (File file : listFiles) {
            if (file.isDirectory() && !file.isHidden()) {
                String dirName = file.getName();
                if(dirName.indexOf("_")>-1){
                    dirName = dirName.substring(0,dirName.indexOf("_"));
                }
                //System.out.println(dirName);
                File[] list = file.listFiles();
                Arrays.sort(list);
                for(File inoFile:list){
                    String fileName = inoFile.getName();
                    //System.out.println("Revisando..."+dirName+" con: "+fileName);
                    if(fileName.startsWith(dirName)&&fileName.endsWith(".js")){
                        out.println("<option value=\"sk_" + file.getName()+"\" "+(sketcherDefault!=null&&sketcherDefault.equals("sk_"+file.getName())?"selected":"")+" >" + file.getName() + " (Sketch)</option>");
                    }
                }
            }
        }
    }                                            
%>    
            </select>
            </div>
            <div class="cdino_buttons">
                <input type="submit" value="Upload Sketcher" onclick="return true;"  class="btn btn-primary" >
                <a class="btn btn-primary" data-target=".content-wrapper" data-load="ajax" onclick="editSketcher(this);" >Edit Sketcher</a>
                <script type="text/javascript">
                    function editSketcher(alink){
                        var sketcher = document.getElementById('skt');
                        var valSket = sketcher[sketcher.selectedIndex].value;
                        //alert(valSket);
                        var urlEdit = 'sketcherDetailJS?act=edit&skt=' + valSket.substring(3) ;
                        if(valSket.startsWith('bk_'))
                        {
                            urlEdit = 'blockDetailJS?ID=' + valSket.substring(3) ;
                        }                        
                        alink.href=urlEdit;
                        alink.click();
                    }

                </script>
            </div>
        </div> 
    </form>     
    <hr/>
    <div class="form-group has-feedback">
        <div>
            <label>Console</label>
            <div class="callout callout-info">
                <div id="ws_cmp"><%=msg.toString()%></div>
            </div>
            
        </div>
    </div>          
        
</div>