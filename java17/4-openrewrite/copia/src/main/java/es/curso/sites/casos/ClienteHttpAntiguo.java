package es.curso.sites.casos;

import java.io.InputStream;
import java.net.URL;
import java.util.Scanner;

import sun.net.www.protocol.http.HttpURLConnection;

// CASO: «lo de sun http». Alguien importo la implementacion interna del JDK en
// vez de la clase publica java.net.HttpURLConnection; el IDE lo autocompleto y
// en Java 8 funcionaba. En Java 17 el paquete no se exporta: ni compila, ni
// el binario antiguo funciona.
public class ClienteHttpAntiguo {

    public String descargar(String url) throws Exception {
        HttpURLConnection conexion = (HttpURLConnection) new URL(url).openConnection();
        conexion.setRequestMethod("GET");
        try (InputStream entrada = conexion.getInputStream();
             Scanner lector = new Scanner(entrada, "UTF-8").useDelimiter("\\A")) {
            return conexion.getResponseCode() + " " + (lector.hasNext() ? lector.next() : "");
        }
    }
}


