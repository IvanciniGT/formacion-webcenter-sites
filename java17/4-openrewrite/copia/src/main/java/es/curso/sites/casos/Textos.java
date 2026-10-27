package es.curso.sites.casos;

import org.apache.commons.lang.StringUtils;

// CASO: una libreria que traia WEBLOGIC 12.2.1.4 y la 14.1.2 ya no trae
// (com.bea.core.apache.commons.lang.jar). En el pom esta como provided, «porque
// ya la pone el servidor». Compila, y en local funciona: ni jdeps ni el
// compilador lo ven. Solo lo ve la Migration Analysis Tool de Oracle.
public class Textos {

    public String titular(String texto) {
        return StringUtils.abbreviate(StringUtils.capitalize(texto), 20);
    }
}
