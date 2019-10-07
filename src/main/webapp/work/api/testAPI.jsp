<%-- 
    Document   : testAPI
    Created on : 28-jun-2017, 18:35:33
    Author     : javiersolis
--%>
<%@page import="java.io.File"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.net.Socket"%>
<%@page import="io.cloudino.utils.Utils"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.OutputStreamWriter"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.io.OutputStream"%>
<%@page import="java.net.URLConnection"%>
<%@page import="java.net.URL"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String data="Hola Mundo";
    String act=request.getParameter("act");
    if("postData".equals(act))
    {
        URL url=new URL("http://localhost:8080/api/postData/af46i7wgkt971p4bxj3pk2vbem7hbu5q27xqz1h/name");

        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setDoOutput(true);
        con.setDoInput(true);
        //con.setRequestProperty("Content-Type", "application/json");
        //con.setRequestProperty("Accept", "application/json");
        con.setRequestMethod("POST");

        OutputStreamWriter wr = new OutputStreamWriter(con.getOutputStream());
        wr.write(data);
        wr.flush();

        //display what returns the POST request

        StringBuilder sb = new StringBuilder();  
        int HttpResult = con.getResponseCode(); 
        if (HttpResult == HttpURLConnection.HTTP_OK) {
            BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
            String line = null;  
            while ((line = br.readLine()) != null) {  
                sb.append(line + "\n");  
            }
            br.close();
            out.println("" + sb.toString());  
        } else {
            out.println(con.getResponseMessage());  
        }          
    }
    if("postBinaryData".equals(act))
    {
        //URL url=new URL("http://cloudino.io/api/postBinaryData/4c35l1oorwwdawn19ekxb7zlfd651pmx04q5hb9/file");  //001
        URL url=new URL("http://cloudino.io/api/postBinaryData/aqz3856xla9up9ay1qlvw6j5mkv7djbpedamxgl/file");  //002

        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setDoOutput(true);
        con.setDoInput(true);
        //con.setRequestProperty("Content-Type", "application/binary");
        //con.setRequestProperty("Accept", "text/plain");
        con.setRequestMethod("POST");

        OutputStream o = con.getOutputStream();
        FileInputStream in=new FileInputStream("/Users/javiersolis/Downloads/image_4.jpg");
        Utils.copyStream(in, o);
        o.flush();

        //display what returns the POST request

        StringBuilder sb = new StringBuilder();  
        int HttpResult = con.getResponseCode(); 
        if (HttpResult == HttpURLConnection.HTTP_OK) {
            BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
            String line = null;  
            while ((line = br.readLine()) != null) {  
                sb.append(line + "\n");  
            }
            br.close();
            out.println("" + sb.toString());  
        } else {
            out.println(con.getResponseMessage());  
        }          
    }    
    
    if("postBinaryDataSockets".equals(act))
    {
        String file="/Users/javiersolis/Downloads/image.jpg";
        URL url=new URL("http://localhost:8080/api/postBinaryData/4c35l1oorwwdawn19ekxb7zlfd651pmx04q5hb9/file");
        
        Socket socket=new Socket("cloudino.io", 80);
        OutputStream o=socket.getOutputStream();
        InputStream i=socket.getInputStream();
        String head="POST /api/postBinaryData/4c35l1oorwwdawn19ekxb7zlfd651pmx04q5hb9/file HTTP/1.1\r\nContent-Length: "+(new File(file)).length() + "\r\n\r\n"; 
        o.write(head.getBytes());
        
        FileInputStream in=new FileInputStream(file);
        Utils.copyStream(in, o);
        o.flush();

        //display what returns the POST request

        StringBuilder sb = new StringBuilder();  
        BufferedReader br = new BufferedReader(new InputStreamReader(i, "utf-8"));
        String line = null;  
        while ((line = br.readLine()) != null) {  
            sb.append(line + "\n");  
        }
        br.close();
        out.println("" + sb.toString());  
    }  


%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
        <a href="?act=postData">postData</a>
        <a href="?act=postBinaryData">postBinaryData</a>
        <a href="?act=postBinaryDataSockets">postBinaryData Sockets</a>
        <a href="http://localhost:8080/api/getData/af46i7wgkt971p4bxj3pk2vbem7hbu5q27xqz1h/name">getData</a>
        <a href="http://localhost:8080/api/getData/af46i7wgkt971p4bxj3pk2vbem7hbu5q27xqz1h/file/image_png">getData Binary</a>
    </body>
</html>
