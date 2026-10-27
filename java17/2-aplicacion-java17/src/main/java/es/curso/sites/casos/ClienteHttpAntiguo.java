package es.curso.sites.casos;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;

// ARREGLO de «lo de sun http»: java.net.http.HttpClient, API publica desde
// Java 11. Patron builder, HTTP/2, y llamadas sincronas o asincronas.
// Si solo hubiera que tocar el import: java.net.HttpURLConnection tambien vale.
public class ClienteHttpAntiguo {

    private final HttpClient cliente = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(5))
            .build();

    public String descargar(String url) throws Exception {
        HttpRequest peticion = HttpRequest.newBuilder(URI.create(url)).GET().build();
        HttpResponse<String> respuesta = cliente.send(peticion, HttpResponse.BodyHandlers.ofString());
        return respuesta.statusCode() + " " + respuesta.body();
    }
}

// En lugar de cambiar el código podría pedir que se exporte el paquete sun.net.www.protocol.http en el JDK, pero eso no es recomendable.
// java --add-exports java.base/sun.net.www.protocol.http=ALL-UNNAMED           Permite el acceso al paquete interno
//      --add-opens java.base/sun.net.www.protocol.http=ALL-UNNAMED             Abre el paquete para REFLECTION

// En muchos casos el primero es suficiente.