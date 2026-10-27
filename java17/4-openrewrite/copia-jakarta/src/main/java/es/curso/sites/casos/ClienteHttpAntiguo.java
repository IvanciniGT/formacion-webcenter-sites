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
