<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><html><body><h2>Que ve una plantilla de Sites en este servidor</h2>
<p>Java <%= System.getProperty("java.version") %> &middot; <%= weblogic.version.getVersions() %></p>
<pre><%
// Lo que el JDK 8 traia y el 17 no, y lo que WebLogic 12.2.1.4 ponia y la 14.1.2
// quiza no. Se busca con el cargador de la aplicacion sites, que es el que usan
// las plantillas: lo que no este aqui no lo vera ningun JSP ni ningun Groovy.
String[] clases = {
  "sun.misc.BASE64Encoder",
  "sun.net.www.protocol.http.HttpURLConnection",
  "javax.xml.bind.JAXBContext",
  "javax.annotation.PostConstruct",
  "org.openjdk.nashorn.api.scripting.NashornScriptEngineFactory",
  "jdk.nashorn.api.scripting.NashornScriptEngineFactory",
  "org.apache.commons.lang.StringUtils",
  "org.apache.commons.lang3.StringUtils",
  "org.joda.time.DateTime",
  "com.sun.jersey.api.client.Client",
  "org.glassfish.jersey.client.JerseyClient",
  "groovy.lang.GroovyShell",
};
ClassLoader cargador = Thread.currentThread().getContextClassLoader();
for (String c : clases) {
  try {
    Class<?> k = Class.forName(c, false, cargador);
    java.security.CodeSource origen = k.getProtectionDomain().getCodeSource();
    out.println("SI  " + c + "\n      " + (origen == null ? "(del JDK)" : origen.getLocation()));
  } catch (Throwable t) {
    out.println("NO  " + c);
  }
}
out.println();
for (javax.script.ScriptEngineFactory f : new javax.script.ScriptEngineManager().getEngineFactories())
  out.println("Motor de scripts: " + f.getEngineName() + " " + f.getNames());
%></pre></body></html></cs:ftcs>
