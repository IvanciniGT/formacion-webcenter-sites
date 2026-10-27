package es.curso.sites.casos;

import java.nio.charset.StandardCharsets;
import java.util.Base64;

// ARREGLO: java.util.Base64, API publica desde Java 8. Se podia haber hecho asi
// desde 2014.
public class CodificadorBase64 {

    public String codificar(String texto) {
        return Base64.getEncoder().encodeToString(texto.getBytes(StandardCharsets.UTF_8));
    }
}
