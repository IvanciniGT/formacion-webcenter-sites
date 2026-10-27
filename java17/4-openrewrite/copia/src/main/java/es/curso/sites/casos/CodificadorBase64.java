package es.curso.sites.casos;

import java.nio.charset.StandardCharsets;

import sun.misc.BASE64Encoder;

// CASO: API interna del JDK. Nunca fue publica, pero media industria la uso
// porque hasta Java 8 no habia un Base64 oficial. Se elimino en Java 9.
public class CodificadorBase64 {

    public String codificar(String texto) {
        return new BASE64Encoder().encode(texto.getBytes(StandardCharsets.UTF_8));
    }
}
