<%-- 
    Document   : apiDesc
    Created on : 28-jun-2017, 17:45:28
    Author     : javiersolis
--%><%@page contentType="text/html" pageEncoding="UTF-8"%><!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Cloudino HTTP API</h1>
        <pre>
    GET  /api/post2Dev/[Authentication Token][?topic1=msg1][&topic2=msg2]
    GET  /api/post2Srv/[Authentication Token][?topic1=msg1][&topic2=msg2]
    GET  /api/post2Srv/[Authentication Token]/[DataSource Topic][?topic1=msg1][&topic2=msg2]
    POST /api/post2Srv/[Authentication Token]/[Topic]               //http body msg content
    POST /api/postData/[Authentication Token]/[Topic]               //http body msg content
    POST /api/postBinaryData/[Authentication Token]/[Topic]         //http body msg content
    GET  /api/getData/[Authentication Token]/[Topic]/[Content_Type]
    GET  /api/getBinaryData/[Authentication Token]/[Topic]/[Content_Type]
    GET  /api/getPublicData/[Device ID]/[Topic]/[Content_Type]
    GET  /api/getPublicBinaryData/[Device ID]/[Topic]/[Content_Type]
        </pre>
    </body>
</html>
