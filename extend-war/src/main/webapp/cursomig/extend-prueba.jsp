<%@ page contentType="text/plain; charset=UTF-8" pageEncoding="UTF-8"
%><%--
  SOLO PARA LA DEMO: demuestra que lo que va en la extend WAR se sirve bajo
  /sites, como si estuviera dentro de sites.war. Borradlo en vuestro proyecto,
  junto con src/main/sellado/.

  No lee el MANIFEST: sites.war tiene el suyo y gana sobre el de la libreria.
  Lee un fichero de nombre unico que Maven sella al construir; si sale la hora
  de vuestra build, la WAR cargada es la vuestra y no la vacia de Oracle.
--%><%
    java.util.Properties sello = new java.util.Properties();
    try (java.io.InputStream entrada = application.getResourceAsStream("/WEB-INF/classes/cursomig-extend.properties")) {
        if (entrada != null) {
            sello.load(entrada);
        }
    }
%>extend WAR del curso cargada
version: <%= sello.getProperty("version", "(sin sello)") %>
construida: <%= sello.getProperty("construida", "(sin sello)") %>
