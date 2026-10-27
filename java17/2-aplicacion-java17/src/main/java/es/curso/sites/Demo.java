package es.curso.sites;

import java.net.InetSocketAddress;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.concurrent.Callable;

import com.sun.net.httpserver.HttpServer;

import es.curso.sites.casos.AccesoProfundo;
import es.curso.sites.casos.Articulo;
import es.curso.sites.casos.ClienteHttpAntiguo;
import es.curso.sites.casos.CodificadorBase64;
import es.curso.sites.casos.ConversorXml;
import es.curso.sites.casos.MotorPlantillas;
import es.curso.sites.casos.NombreCertificado;
import es.curso.sites.casos.ServicioArticulos;
import es.curso.sites.casos.Textos;

// Ejecuta cada caso y dice si funciona o como falla, con la version de Java con
// la que corre. Se lanza igual en Java 8 y en Java 17: el mismo binario.
public class Demo {

    public static void main(String[] args) throws Exception {
        // Servidor HTTP local para no depender de internet en clase.
        // com.sun.net.httpserver NO es problema: es API soportada en Java 17.
        HttpServer servidor = HttpServer.create(new InetSocketAddress("127.0.0.1", 0), 0);
        servidor.createContext("/", intercambio -> {
            byte[] cuerpo = "hola desde el servidor".getBytes(StandardCharsets.UTF_8);
            intercambio.sendResponseHeaders(200, cuerpo.length);
            intercambio.getResponseBody().write(cuerpo);
            intercambio.close();
        });
        servidor.start();
        String url = "http://127.0.0.1:" + servidor.getAddress().getPort() + "/";

        System.out.println("Java " + System.getProperty("java.version") + "\n");
        probar("sun http (ClienteHttpAntiguo)", () -> new ClienteHttpAntiguo().descargar(url));
        probar("sun.misc.BASE64Encoder", () -> new CodificadorBase64().codificar("WebCenter").trim());
        probar("JAXB (javax.xml.bind)", () -> new ConversorXml().aXml(new Articulo("Hola", "Mundo")));
        probar("sun.security.x509", () -> new NombreCertificado().nombreComun("CN=webcenter, O=Curso"));
        probar("Nashorn (JavaScript)", () -> new MotorPlantillas().evaluar("6 * 7"));
        probar("Reflexion dentro del JDK", () -> new AccesoProfundo().capacidad(new ArrayList<>(Arrays.asList(1, 2, 3))));
        probar("commons-lang (lo traia WebLogic)", () -> new Textos().titular("webcenter sites catorce uno dos"));
        probar("@PostConstruct (javax.annotation)", () -> {
            Class<?> anotacion = Class.forName("javax.annotation.PostConstruct");
            return "la anotacion existe: " + anotacion.getName();
        });

        servidor.stop(0);
    }

    private static void probar(String caso, Callable<Object> accion) {
        String resultado;
        try {
            resultado = "OK     " + accion.call();
        } catch (Throwable error) {
            resultado = "FALLA  " + error.getClass().getSimpleName() + ": " + error.getMessage();
        }
        System.out.printf("%-36s %s%n", caso, resultado.length() > 150 ? resultado.substring(0, 150) + "…" : resultado);
    }
}
