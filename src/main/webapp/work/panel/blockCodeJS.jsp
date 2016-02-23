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
    String blockPath = workPath + engine.getScriptObject().get("config").getString("usersWorkPath") + "/" + user.getNumId() + "/cloudinojs/blocks/" + id;

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
    myCodeMirror.setSize("100%", 400);
    myCodeMirror.setOption("readOnly", true);

    /*
    $('a[data-toggle="tab"]').on('shown.bs.tab', function(e) {
        myCodeMirror.refresh();
        //console.log('shown.bs.tab', e);
    });
    */

</script>   
