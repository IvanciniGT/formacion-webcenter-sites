package es.curso.sites.casos;

import org.apache.commons.lang3.StringUtils;

// ARREGLO: commons-lang3, declarada y EMPAQUETADA en la WAR (no provided).
// Cambia el paquete (lang -> lang3); los metodos de uso comun se llaman igual.
public class Textos {

    public String titular(String texto) {
        return StringUtils.abbreviate(StringUtils.capitalize(texto), 20);
    }
}
