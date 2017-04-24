<%-- 
    Document   : ocb_token
    Created on : 27-feb-2017, 18:44:48
    Author     : javiersolis
--%><%@page import="java.io.*"%><%@page import="javax.net.ssl.HttpsURLConnection"%><%@page import="java.net.URL"%><%@page import="org.semanticwb.datamanager.DataObject"%><%@page import="io.cloudino.utils.Utils"%><%@page contentType="text/html" pageEncoding="UTF-8"%><%
    
    ByteArrayOutputStream o=new ByteArrayOutputStream();
    Utils.copyStream(request.getInputStream(), o);
    String data=new String(o.toByteArray());
    System.out.println(data);
    
    String httpsURL = "https://orion.lab.fiware.org/token";

    URL url = new URL(httpsURL);
    HttpsURLConnection con = (HttpsURLConnection)url.openConnection();
    con.setRequestMethod("POST");
    con.setRequestProperty("Content-length", String.valueOf(data.length())); 
    con.setRequestProperty("Content-Type","application/json");
    con.setDoOutput(true); 
    con.setDoInput(true); 
    DataOutputStream output = new DataOutputStream(con.getOutputStream());  
    output.writeBytes(data);
    output.close();
    
    Utils.copyStream((InputStream)con.getContent(), response.getOutputStream());
%>