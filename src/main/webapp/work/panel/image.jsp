<%-- 
    Document   : image
    Created on : 08-sep-2015, 18:29:09
    Author     : javiersolis
--%><%@page import="io.cloudino.utils.Utils"%><%@page import="java.io.FileInputStream"%><%@page import="java.io.File"%><%@page import="io.cloudino.utils.ParamsMgr"%><%
    ParamsMgr params=new ParamsMgr(request.getSession());
    String k = request.getParameter("k");
    String path = params.getDataValue(k, "fp");
    File file=new File(path);
    String extension = "";
    int i = file.getName().lastIndexOf('.');
    if (i > 0) {
        extension = file.getName().substring(i+1);
    }
    response.setContentType("image/"+extension);
    FileInputStream in=new FileInputStream(file);
    Utils.copyStream(in, response.getOutputStream());
%>