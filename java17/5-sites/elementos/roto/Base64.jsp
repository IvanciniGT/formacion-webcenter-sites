<%@ page import="sun.misc.BASE64Encoder"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%
// Asi se hacia antes de Java 8, y asi se quedo. BASE64Encoder nunca fue API
// publica, y Java 9 lo quito.
String texto = "Avisports en Java 17";
%>Base64 de "<%= texto %>": <%= new BASE64Encoder().encode(texto.getBytes("UTF-8")) %></cs:ftcs>
