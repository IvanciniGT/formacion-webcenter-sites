<%@ page import="java.util.Base64"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%
String texto = "Avisports en Java 17";
%>Base64 de "<%= texto %>": <%= Base64.getEncoder().encodeToString(texto.getBytes("UTF-8")) %></cs:ftcs>
