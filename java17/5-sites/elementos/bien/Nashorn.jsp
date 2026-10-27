<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%
// Sin motor de JavaScript en el servidor: la cuenta, en Java. La otra salida es
// poner nashorn-core 15.x en extend.sites.webapp-lib, la libreria que Oracle
// reserva para los jars propios, y reiniciar Sites.
double precio = Math.round(100 * 1.21 * 100) / 100.0;
%>Precio con IVA, calculado en Java: <%= precio %></cs:ftcs>
