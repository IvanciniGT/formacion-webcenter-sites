<%@ page import="java.util.*, COM.FutureTense.Common.ControllerProcessorImpl, COM.FutureTense.Common.ControllerStatusInfo"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><pre><%
// Lo mismo que el boton «Compile All» de Admin > System Tools > Controllers.
// Hace falta porque crear un controlador por REST no lo compila: la compilacion
// va colgada de la transaccion de la interfaz, y Sites no vuelve a mirar el
// disco con ft.filecheck=no.
// compileAll compila todos los controladores del sitio, aunque se le pase una
// lista: lo dice el bytecode de sites-cs.jar 14.1.2.
List<String> nuestros = Arrays.asList("CursoMigBienController", "CursoMigRotoController", "CursoMigNoCompilaController");
ControllerProcessorImpl procesador = new ControllerProcessorImpl();
try {
  procesador.compileAll(null);
  out.println("Compilan todos.\n");
} catch (Exception e) {
  out.println("ALGUNO NO COMPILA.\n");
}
for (Map.Entry<String, ControllerStatusInfo> e : ControllerProcessorImpl.toStatusInfo(procesador.getControllerStatuses()).entrySet()) {
  if (nuestros.contains(e.getKey()) || e.getValue().getError() != null)
    out.println(e.getKey() + ": " + (e.getValue().getError() == null ? "compilado" : "NO COMPILA\n  " + e.getValue().getError()));
}
%></pre></cs:ftcs>
