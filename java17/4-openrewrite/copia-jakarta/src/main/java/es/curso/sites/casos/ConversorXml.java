package es.curso.sites.casos;

import java.io.StringWriter;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.Marshaller;

// CASO: JAXB. En Java 8 venia en el JDK; en Java 11 se elimino (JEP 320).
public class ConversorXml {

    public String aXml(Articulo articulo) throws Exception {
        Marshaller m = JAXBContext.newInstance(Articulo.class).createMarshaller();
        m.setProperty(Marshaller.JAXB_FRAGMENT, true);
        StringWriter salida = new StringWriter();
        m.marshal(articulo, salida);
        return salida.toString();
    }
}
