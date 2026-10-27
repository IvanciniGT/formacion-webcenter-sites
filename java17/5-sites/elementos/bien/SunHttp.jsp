<%@ page import="java.net.URI, java.net.http.HttpClient, java.net.http.HttpRequest, java.net.http.HttpResponse"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%
// El cliente http publico, desde Java 11
URI uri = URI.create("http://" + request.getLocalAddr() + ":" + request.getLocalPort() + "/sites/ContentServer?pagename=CursoMig/Indice");
HttpResponse<String> respuesta = HttpClient.newHttpClient()
    .send(HttpRequest.newBuilder(uri).GET().build(), HttpResponse.BodyHandlers.ofString());
%>GET <%= uri %> &rarr; <%= respuesta.statusCode() %></cs:ftcs>
