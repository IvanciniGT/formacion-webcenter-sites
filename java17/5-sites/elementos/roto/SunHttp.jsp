<%@ page import="java.net.URL"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%
// La clase http del JDK, a pelo y no por URL.openConnection(): dentro de WebLogic
// openConnection() devuelve la conexion de WebLogic, y esta era la forma de
// saltarsela. Java 17 ya no deja usar sun.net.* desde fuera del JDK.
URL url = new URL("http://" + request.getLocalAddr() + ":" + request.getLocalPort() + "/sites/ContentServer?pagename=CursoMig/Indice");
sun.net.www.protocol.http.HttpURLConnection conexion =
    new sun.net.www.protocol.http.HttpURLConnection(url, (java.net.Proxy) null);
%>GET <%= url %> &rarr; <%= conexion.getResponseCode() %></cs:ftcs>
