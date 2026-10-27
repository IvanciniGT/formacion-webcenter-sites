package es.curso.sites.casos;

import javax.annotation.PostConstruct;

// CASO: anotaciones comunes. En Java 8 @PostConstruct venia en el JDK; en
// Java 11 se elimino. Ojo al detalle: con el binario de Java 8 corriendo en
// Java 17 no da error, porque una anotacion que no existe se ignora en
// silencio. Es al compilar donde salta.
public class ServicioArticulos {

    private boolean listo;

    @PostConstruct
    public void iniciar() {
        listo = true;
    }

    public boolean estaListo() {
        return listo;
    }
}
