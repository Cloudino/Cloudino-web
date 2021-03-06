<%-- 
    Document   : rule
    Created on : 15-oct-2015, 0:04:21
    Author     : javiersolis
--%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="io.cloudino.utils.Utils"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.File"%>
<%@page import="org.semanticwb.datamanager.DataMgr"%>
<%@page import="org.semanticwb.datamanager.SWBDataSource"%>
<%@page import="org.semanticwb.datamanager.SWBScriptEngine"%>
<%@page import="org.semanticwb.datamanager.DataObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String id = request.getParameter("ID");
    DataObject user = (DataObject) session.getAttribute("_USER_");
    SWBScriptEngine engine = DataMgr.getUserScriptEngine("/cloudino.js", user);
    String code = "";

    String workPath = DataMgr.getApplicationPath() + "/work/";
    String blockPath = workPath + engine.getScriptObject().get("config").getString("usersWorkPath") + "/" + user.getNumId() + "/arduino/blocks/" + id;

    File blockDir = new File(blockPath);
    if (!blockDir.exists()) {
        response.sendError(404);
        return;
    } else {
        File fc=new File(blockDir, id + ".ino");
        if(fc.exists())
        {
            FileInputStream in = new FileInputStream(fc);
            code = Utils.textInputStreamToString(in, "utf8");
        }
    }
%>

<textarea name="code" id="block_code"><%=code%></textarea>   
<script type="text/javascript">

    var myCodeMirror = CodeMirror.fromTextArea(block_code, {
        mode: "text/x-c++src",
        smartIndent: true,
        //lineNumbers: true,
        styleActiveLine: true,
        matchBrackets: true,
        autoCloseBrackets: true,
        completeSingle: true,
        theme: "eclipse",
        continueComments: "Enter",
        extraKeys: {"Ctrl-Space": "autocomplete", "Ctrl-Q": "toggleComment", "Ctrl-J": "toMatchingTag", "F11": function(cm) {
                cm.setOption("fullScreen", !cm.getOption("fullScreen"));
            },
            "Esc": function(cm) {
                if (cm.getOption("fullScreen"))
                    cm.setOption("fullScreen", false);
            }},
        matchTags: {bothTags: true},
    });
    myCodeMirror.setSize("100%", 500);
    //# set readOnly mode
    myCodeMirror.setOption("readOnly", true);
</script>  
