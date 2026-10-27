<%@ page import="java.io.StringWriter, javax.xml.bind.JAXBContext, javax.xml.bind.Marshaller, javax.xml.bind.annotation.XmlRootElement"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%!
@XmlRootElement(name = "articulo")
public static class Articulo {
  public String titulo = "Etapa reina";
  public int visitas = 1200;
}
%><cs:ftcs><%
// Igual en las dos versiones, y funciona en las dos: el JDK 17 ya no trae JAXB,
// pero WebLogic 14.1.2 si, y en javax. En el pom de un jar propio, provided.
StringWriter xml = new StringWriter();
Marshaller m = JAXBContext.newInstance(Articulo.class).createMarshaller();
m.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
m.marshal(new Articulo(), xml);
%><pre><%= xml.toString().replace("<", "&lt;") %></pre></cs:ftcs>
