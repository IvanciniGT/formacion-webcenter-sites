<%@ page import="javax.script.ScriptEngine, javax.script.ScriptEngineManager"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%
// Compila: javax.script sigue en el JDK. Lo que ya no esta es el motor, asi
// que getEngineByName devuelve null y revienta al usarlo.
ScriptEngine motor = new ScriptEngineManager().getEngineByName("nashorn");
%>Precio con IVA, calculado en JavaScript: <%= motor.eval("Math.round(100 * 1.21 * 100) / 100") %></cs:ftcs>
