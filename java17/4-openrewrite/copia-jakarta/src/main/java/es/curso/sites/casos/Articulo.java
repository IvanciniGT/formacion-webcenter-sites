package es.curso.sites.casos;

import javax.xml.bind.annotation.XmlRootElement;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

// Un asset de ejemplo, como los que se exportan a XML para otros sistemas.
// Lombok genera getters y setters; JAXB necesita el constructor vacio.
@Data
@NoArgsConstructor
@AllArgsConstructor
@XmlRootElement
public class Articulo {
    private String titulo;
    private String cuerpo;
}
