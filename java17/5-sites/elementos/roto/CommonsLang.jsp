<%@ page import="org.apache.commons.lang.StringUtils"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%
// commons-lang 2: nadie la empaquetaba porque la ponia WebLogic 12.2.1.4.
%>Titular abreviado: <%= StringUtils.abbreviate("La AviSports Cup se decide en la ultima vuelta", 30) %></cs:ftcs>
