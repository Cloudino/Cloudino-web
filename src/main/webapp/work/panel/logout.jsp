<%-- 
    Document   : logout
    Created on : 05-nov-2018, 2:37:59
    Author     : javiersolis
--%><%@page contentType="text/html" pageEncoding="UTF-8"%><%
    Cookie cooks[]=request.getCookies();
    if(cooks!=null)
    {
        for(int i=0;i<cooks.length;i++)
        {
            if(cooks[i].getName().equals("cdino"))
            {
                cooks[i].setMaxAge(0);
                //cooks[i].setPath("/panel");
                response.addCookie(cooks[i]);
            }
        }                
    }
    request.getSession().invalidate();
    response.sendRedirect(request.getContextPath() + "/");                
%>