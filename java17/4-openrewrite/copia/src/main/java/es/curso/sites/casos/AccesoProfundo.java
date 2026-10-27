package es.curso.sites.casos;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

// CASO: reflexion DENTRO del JDK. No suele estar en vuestro codigo sino en
// librerias viejas (serializadores, caches, mocks). Compila siempre; en Java 17
// falla en EJECUCION con InaccessibleObjectException.
public class AccesoProfundo {

    public int capacidad(List<?> lista) throws Exception {
        Field interno = ArrayList.class.getDeclaredField("elementData");
        interno.setAccessible(true);
        return ((Object[]) interno.get(lista)).length;
    }
}
