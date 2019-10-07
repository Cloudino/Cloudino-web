<%-- 
    Document   : sms
    Created on : 29-may-2017, 22:16:01
    Author     : javiersolis
--%>
<%@page import="java.net.URLDecoder"%>
<%@page import="java.net.URLEncoder"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%><%
    String device=request.getParameter("device");
    String phone=request.getParameter("phone");
    String smscenter=request.getParameter("smscenter");
    String text=request.getParameter("text");
    System.out.println("device:"+device);
    System.out.println("phone:"+phone);
    System.out.println("smscenter:"+smscenter);
    System.out.println("text:"+text);
%>