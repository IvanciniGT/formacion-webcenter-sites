<%@ page import="org.apache.commons.lang3.StringUtils"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%
// lang -> lang3: mismo metodo, otro paquete.
%>Titular abreviado: <%= StringUtils.abbreviate("La AviSports Cup se decide en la ultima vuelta", 30) %></cs:ftcs>
