<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><html><body>
<h2>Migracion a Java 17: los casos en Sites</h2>
<p>Codigo de plantillas y controladores: lo compila WebLogic al pedir la pagina, no Maven.</p>
<table border="1" cellpadding="6">
<tr><th>Caso</th><th>Antes (Java 8)</th><th>Migrado</th></tr>
<%
String[][] casos = {
  {"Base64",      "sun.misc.BASE64Encoder"},
  {"SunHttp",     "sun.net.www.protocol.http.HttpURLConnection"},
  {"Nashorn",     "JavaScript con Nashorn"},
  {"CommonsLang", "commons-lang 2"},
  {"Jaxb",        "JAXB (javax.xml.bind)"},
  {"Groovy",      "controlador Groovy con sun http"},
};
for (String[] c : casos) {
%><tr><td><%= c[1] %></td>
<td><a href="ContentServer?pagename=CursoMig/Roto/<%= c[0] %>">Roto</a></td>
<td><a href="ContentServer?pagename=CursoMig/Bien/<%= c[0] %>">Bien</a></td></tr>
<% } %>
</table>
<p><a href="ContentServer?pagename=CursoMig/QueHayEnElServidor">Que ve una plantilla en este servidor</a></p>
</body></html></cs:ftcs>
