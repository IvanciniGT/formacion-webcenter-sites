# Evolución de Java y contexto histórico:

## Sun Microsystems

1996 1.0
1997 1.1
1998 1.2
1999 1.3
2000 1.4
2004 1.5
2006 1.6

# Hasta aquí JAVA seguía siendo Sun Microsystems. Aquí Oracle Compra Sun Microsystems (2009) ** Esta fue la "primera muerte de java"
La gente dejo de usar tanto java... No se fiaban.
Java deja de evolucionar. A Oracle se la trae al peiro el java.
Con la compra se lleva:
- Java
- OpenOffice -> StarOffice -> Abandona  . Años más tarde lo dona a una fundación, que lo trata de rescatar. RUINA!
                Desde un spinoff crean un nuevo proyecto (comunidad) contiunación de OpenOffice, llamado LibreOffice.
- MySQL ... pasa lo mismo. Lo ponen de pago, la versión gratis la recortan al absurdo.
            Muere como proyecto.. Los creadores originales de MySQL sacan un spinoff llamado MariaDB.
- Hudson -> Jenkins

                                Ahí pasa otra cosa disruptiva: GOOGLE y lanza Android (2007-2008) como Sistema operativo
                                Y eligen Java como lenguaje principal para el desarrollo de aplicaciones en Android.

                                Google tira del carro... empieza a apretar y a sacar mejoras a JAVA como lenguaje y necesitan una JVM que soporte esas funcionaldiades nuevas:
                                    Se crean su propia JVM llamada Dalvik, que luego evolucionará a ART (Android Runtime).

2011 1.7 -- 5 años              Mucha gente empieza a irse a otros lenguajes : C#
                                Años de litigios - 2011 Gana Google
2014 1.8 -- 3 años              11 años y 3 versiones. No cualeras 11 años. Expansión gigante de las aplicaciones web y el mundo Mobile

                                Oracle demanda a Google... Quién eres tu para montar una JVM. Es mi propiedad. Yo tengo el TM (Trademark) de Java.

                                Oracle anuncia que su JVM será de pago a partir de ciertas versiones.
                                OracleJDK y OracleJRE pasan a ser de pago:
                                Usuarios particulares 25$ / año
                                Empresas 50$ / core al mes

                                Acuerdos  que salen.. no se sabe mu bien de donde (OFICIALMENTE):
                                - Se libera el API de java, y se libera la arquitectura de la JVM ->  LOCURA!
                                  Hoy en día hay decenas de implementaciones de la JVM:
                                  - OpenJDK
                                  - AdoptOpenJDK
                                  - GraalVM
                                  - IBM J9
                                  - Azul Zulu
                                  - Amazon Corretto
                                  - Eclipse Temurin
                                - Se modulariza la JVM (Projecto Jigsaw) y junto con los cambios en Java 1.8 (programación funcional) es posiublemente el update de mayor calado en toda la historia de Java.
                                - Básicamente Oracle tiene librerías de las que no quiere soltar la propiedad. Y solo se liberan parte del api.
                                - En paralelo, Google dice.. yo no necesito muchas cosas que vienen en el api de java:
                                  - No quiero depender de oracle
                                  - Y para apps mobile no las necesito
                                 
                                 En java 9, aparece una palabra/concepto nuevo:
                                 module
                                 Hasta java 8, teníamos:
                                    package
                                        clases
                                        interfaces
                                        enum
                                        annotations
                                En java 9 y posteriores, además de los paquetes, clases, interfaces, enums y anotaciones, tenemos:
                                    module
                                        package
                                            clases
                                            interfaces
                                            enum
                                            annotations
                                Y el pai de java se parte en módulos, lo que permite una mayor modularidad y control sobre las dependencias.
                                Esto permite elegir QUE MODULOS (qué partes del api de java) queremos levantar en la JVM.

                                Además, algunos de los módulos que estaban en el api de java, se sacan de la JVM y se convierten en módulos independientes que se pueden agregar según sea necesario.

                                    Pensad en Modulo ~ JAR

                                Adicionalmente esto arreglaba algunos problemas que había en JAVA.
                                    Por ejemplo una clase que crease para uno interno de mi librería o la hacía public y cualquiera podía usarla (dentro y fuera) o la hacía private (y eso me obligaba a no poder usar paquetes distintos)
                                    En otros lenguajes como csharp, exisía un modificador de privacidad llamado INTERNAL. Es público, pero dentro del ensamblado.. para nosotros en java : ensamblado = JAR

                                    ```module-info.java
                                    module mi.modulo {
                                        exports com.miempresa.mipackage;
                                        opens com.miempresa.mipackage;
                                        uses com.miempresa.mipackage;
                                        provides com.miempresa.mipackage;
                                    }
                                    ```
                                    No está tan extendido el uso de módulos en JAVA aunque están disponibles... Llegaron tarde y mal.

                                - Algunos modulos / paquetes de java que quedaron fuera del api de la JVM:
                                  - JAXB (Java Architecture for XML Binding)     (xml <-> objetos java)
                                  - JAX-WS (Java API for XML Web Services)     (web services <-> objetos java) SOAP
                                  - JTA: TRansacciones
                                  De ellas algunas están como librerías libres... otras no... las provee Oracle en su JDK.

                                - Por otro lado... Se libera/dona JEE a una fundación (la fundación Jakarta).

                                - Empiezan a salir muchos lenguajes de programación alternativos a JAVA (kotlin, scala, groovy)
                                  Esos son lenguajes que comiplan a .class (bytecode de Java) y se ejecutan en la JVM.
                                  .kt -> kotlinc -> .class (bytecode de Java) (corre en una JVM)
                                    De hecho este fué el movimiento de Google.
                                        Primero implementaron su propia JVM
                                        Y despues se aliaron con JetBrains(IntelliJ IDEA) para crear un lenguaje alternativo a JAVA y soltarse completamente de Oracle!
                                        - Ya no dependen ni por la JVM
                                        - Ni por el lenguaje

                                    Hoy en día JAVA a no es el lenguaje oficial de Android, sino Kotlin. Y el entorno de desarrollo Android (antihuamente Android studio -> Eclipse tradicional) ahora es Android Studio basado en IntelliJ IDEA.

2017 9   -- 3 años                  


2018 10
2019 11
2020 12
2021 13
2021 14
2022 15
2023 17


# Webcenter sites 12 -> 14

## Java 1.8 -> Java 17

# Webcenter sites 14 -> 15

## JEE 8 -> JEE9


---

J2EE - Java 2 Enterprise Edition
JEE  - Java Enterprise Edition
Pero cuando Oracle lo dona... dicen.. el nombre JAVA (TM) es mi.. eso no lo dono! y se rebautiza:
JEE - Jakarta Enterprise Edition... pero cambian todas las rutas de los paquetes:
    Todo lo que antes era javax. pasa a ser jakarta.

JEE es un conjunto de especificaciones, que definen como podemos usar JAVA para montar aplicaciones en la empresa. 
- Webservers (tipos de webservers: Tomcat. Enterprise webservers: WebLogic, JBoss, GlassFish, WebSphere -> Websphere Liberty)
- JPA : Persistencia de objetos Java en bases de datos relacionales (Java Persistence API)
- JTA : Gestión de transacciones en aplicaciones Java (Java Transaction API)
- JMS : Java Message Service (API para mensajería asíncrona entre componentes Java)
- JNDI : Java Naming and Directory Interface (JNDI) para acceder a servicios de directorio y recursos en la red.
- JAX-RS : Java API for RESTful Web Services (API para crear servicios web RESTful)
- JAX-WS : Java API for XML Web Services (API para crear servicios web SOAP)
- JAXB : Java Architecture for XML Binding (API para convertir entre XML y objetos Java)

En Webcenter sites 14, trabajamos con JDK17, pero JEE8.
Y ojo, muchas librerías que usamos en JDK17 se migraron ya a JEE9 (con importaciones jakarta.* en lugar de javax.*).
Hay que tener cuidado al importar librerias ahora.. No ya las javax.. que en sites las tenemos (las aporta oracle - vienen en el weblogic)
Sobre todo en entornos locales de desarrollo.


A nivel del código tenemos que cuidar 2 cosas:
- Librerías javax que antes estaban en la JVM y ahora salieron de ella entre JAVA 9 y JAVA 11 (en JAVA 11 es donde se hizo la gran poda!)
  Hay que añadirlas a pom.xml... o al classpath si trabajo sin maven. En el weblogic están. Ahí no hay problema.. es en desarrollo.
    En maven:
    ```xml
    <dependency>
        <groupId>javax.xml.bind</groupId>
        <artifactId>jaxb-api</artifactId>
        <version>2.3.1</version>
        <scope>provided</scope>   <!-- es decir, el servidor de aplicaciones ya lo provee, solo la necesito en desarrollo -->
    </dependency>
    ```
- Librerías que estuvieramos usando, que en el paso a java 17 se migraron a jakarta.*, debemos actualizar las importaciones en nuestro código.

En principio, con respecto a JAVA sería todo... 
Algunas costas adicionales:
- Hay librerías (módulos) del API de java que ni pidiendolo se activan (solo son de uso interno por la JVM)... Podemos activarlas, pero hay que SUPLICARLO, no pedirlo.
Esto sehace pasando directamente argumentos adicionales a la JVM, por ejemplo:
```shell
# sun io channels
--add-exports java.base/sun.nio.ch=ALL-UNNAMED
--add-exports java.base/sun.security.x509=ALL-UNNAMED
--add-opens java.base/java.lang=ALL-UNNAMED
```
Cada módulo que queramos usar de esta manera necesita su propio argumento.

Esos módulos se consideran INSEGUROS! Y QUEDAN DE USO INTERNO

Hay otra que viene deshabilitada y que hay implementaciones de la JVM que ni permiten abrirla de nunguna forma. No la de Oracle, que si me permite seguir uándola, si lo pido explicitamente:  java.lang.reflection.

Nos permite acceder a datos privados, métodos privados de clases. Invocar funciones por su nombre (STRING) y manipularlos dinámicamente.
Lo que hace es saltarse el código java y acceder a los datos en RAM directamente, sin pasar por los métodos de acceso habituales (y por ende las proytecciones que ponemos en código: public/private/protected)

---

Hoy en díaa por ejemplo todo lo de peticiones HTTP tenemos en el api una librería completa nueva: 
- Tenemos el HttpClient, El http request y el http response, que nos permiten realizar peticiones HTTP de manera más sencilla y moderna que con las clases antiguas como HttpURLConnection. Y todo manejado desde patrones builder.
```java
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

public class HttpExample {
    public static void main(String[] args) throws Exception {
        HttpClient client = HttpClient.newHttpClient();
        HttpRequest request = HttpRequest.newBuilder()
                .uri(new URI("https://example.com"))
                .GET()
                .header("User-Agent", "Java HttpClient")
                .build();
        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
        System.out.println(response.body());
    }
}
```

- Fechas
 - Calendar, GregorianCalendar
 - java.util.Date
 - java.sql.Date
 - Milliseconds (System.currentTimeMillis())

En java 8, se incluye un nuevo paquete en el api, el la antigua librería joda.time: 
- LocalDate
- LocalTime
- LocalDateTime
- ZonedDateTime
- Instant
- Duration

Esta se incluye como parte del api.

En java 17 tenemos por ejemplo los records:

```java
public record Person(String name, int age) {}


Person person = new Person("John", 30);
person.name();

// person.name;
// person.getName();

// person.name();

```

Es el equivalente a escribir:
```java

public final class Person {
    private final String name;
    private final int age;

    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }

    public String name() {
        return name;
    }

    public int age() {
        return age;
    }
}
```

Los record son inmutables. No llevan setter. Pero llega tarde y mal!

Llevamos años en java usando lombok.
```java
@Value
public final class Person {
    String name;
    int age;
}

Person person = new Person("John", 30);
person.getName();
person.getAge();
```
---

Palabra nueva en java 10: var

```java
var miMapa = new HashMap<String, String>();
// Cuidado que el var de Java no es el de JavaScript, lo que se hace es inferencia de tipos.
// El tipo de la variable miMapa se hereda del primer valor que se asigna. Pero es estático, no dinámico como en JavaScript. Una vez inferido, no se puede cambiar el tipo de la variable.
```
---

# Programación funcional

Junto con el paquete java.function.*
Operador ::
Operador ->

En cuanto podáis, ahora que tenéis java 17, a por él!

Es complejo el cambio de mentalidad.
Y el API entero de JAVA esta migrando a programación funcional!

# Métodos con código en interfaces

```java
public interface MyInterface {

    int MI_CONSTANTE=9;

    void miFuncion1();
    int miFuncion2();

    // Hoy en día podemos:

    // Fúnciones estáticas con código:
    static void miFuncionEstatica() {
        System.out.println("Esto es una función estática con código en la interfaz");
    }
    // Funciones estáticas PROVADAS con código:
    private static void miFuncionPrivada() {
        System.out.println("Esto es una función estática privada con código en la interfaz");
    }
    // Funciones por defecto con código:
    default void miFuncionPorDefecto() { // PERO NO ES PARA PONER LOGICA
                                         // ES PARA PODER GENERAR MINORS DE LA APIS y NO MAJORS!
                                         // Para no romper retrocompatibilidad al añadir nuevos métodos a la interfaz
        throw new UnsupportedOperationException("Método por defecto no implementado");
    }
}

```
---

En la migración, los problemas con JAVA son IMPORTACIONES y dependencias.


---


```java

public final class Person {
    private  String name;
    private final int age;

    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }

    public String getName() {
        return name;
    }
    public int getAge() {
        return age;
    }
    public void setName(String name) {
        this.name = name;
    }
}
```

```kt
data class Person( var name: String, val age: Int )
```



Cómo hacer uso de clases que ya no encuentro:
Hay 2 motivos:
- La clase sigue estando en el API de JAVA, pero dentro de un MODULO (paquete) que no se activa por defecto en la JVM.
  Por ejemplo, lo del sun.http. Necesitamos abrir el módulo correspondiente al ejecutar la JVM usando la opción --add-modules.

  java --add-modules <nombre_del_modulo> MiClase.java

  En principio, de estas hay que huir! En este caso, busco alternativa.

- La clase no está ya en el api de java (Normalmente porque el MODULO / PAQUETE SE HA SACADO)
  Busco la librería correspondiente y la añado al proyecto:
    maven: dependency
    javac: -cp <ruta_a_libreria.jar> MiClase.java

Por ejemplo, los bindeos de XML a objetos en Java se realizaban con clases que ahora están en módulos específicos, como `java.xml.bind`. 
La librería sigue estando disponible.. solo hay que añadirla.
Aquí hay que mirar si:
- El Weblogic la incorpora directamente en su distribución, por lo que no es necesario añadirla al empaquetar:
  ```maven 
    <dependency>
        <groupId>javax.xml.bind</groupId>
        <artifactId>jaxb-api</artifactId>
        <version>2.3.1</version>
        <scope>provided</scope>
    </dependency>
  ```
- Si el weblogic no la incorpora,
  hay que añadirla explícitamente al empaquetar la aplicación:
  ```maven
    <dependency>
        <groupId>javax.xml.bind</groupId>
        <artifactId>jaxb-api</artifactId>
        <version>2.3.1</version>
    </dependency>
  ```
Lo normal será el primer caso.

---

Si uso alguna librería externa, tengo que subirla de versión en el upgrade...
De java 8 a java 17.
Y casi todas las librerias que se han subido de java 1.8 a java 17 en paralelo se han actualizado de jee8 a jee9 (javax-> jakarta).
Y no compilarán en vuestro entorno.

En este caso:
- Buscar una versión que aún use javax en lugar de jakarta.
- Si no existe, meter la librería de jakarta en paralelo: jee9... PROBLEMATICO!

---

# Lucene

Es un proyetco de la fundación Apache. Es una librería JAVA para generar INDICES INVERTIDOS.

Cuando hago una búsqueda en una BBDD relacional, como Oracle, a priori, la BBDD debería leer todas las filas para encontrar las que cumplen la condición. Esta operación es lo que llamamos un FULL SCAN de una tabla (está en todas las BBDD).

SELECT * FROM usuarios WHERE nombre = 'Juan Perez';

A priori, esa consulta recorrería todas las filas de la tabla `usuarios` y fila a fila iría evaluando si el valor de la columna `nombre` coincide con `'Juan Perez'`. PROBLEMA... Esta operación se degrada mucho con el tiempo. Cuando más datos más tarda.
Es proporcional al número de datos. Algoritmo de O(n)

Las BBDD resuelven esto, mediante un concepto: INDICES.

Un índice es una COPIA COMPLETA DE LOS DATOS ordenada, junto con la ubicación en la tabla completa.

TABLA USUARIOS

id    nombre          edad           sexo             pais
1     Juan Perez      30             M               España
2     Maria Lopez     25             F               México
3     Carlos Ruiz     40             M               Argentina

INDICE POR NOMBRE

nombre          id / ubicación (Oracle guarda el ROWID)
Carlos Ruiz     3
Juan Perez      1
Maria Lopez     2


Tener los datos ordenados de antemano permite aplicar un algoritmo de búsqueda muy eficiente llamada BUSQUEDA BINARIA.
Es lo que usamos cuando buscamos en un diccionario. La forma más pura es:
- Abro a la mitad del diccionario.
- Si la palabra que busco es anterior a la que está en la mitad, descarto la segunda mitad.
- Si es posterior, descarto la primera mitad.
- Repito el proceso con la mitad restante hasta encontrar la palabra o determinar que no está.

100.000 palabras
50.000 Hago solo una comprobación
25.000 Hago otra comprobación
12.500 Hago otra comprobación
6.250 Hago otra comprobación
3.125 Hago otra comprobación
1.562 Hago otra comprobación
781 Hago otra comprobación
390 Hago otra comprobación
195 Hago otra comprobación
97 Hago otra comprobación
48 Hago otra comprobación
24 Hago otra comprobación
12 Hago otra comprobación
6 Hago otra comprobación
3 Hago otra comprobación 
1 Hago otra comprobación   PEOR ESCENARIO

17 operaciones. y encuentro mi dato entre 100.000 palabras.
Eso es el log(100000) en base 2 = 17
Es un algoritmo de orden log(n) en base 2.

Esto lo hacen las BBDD... además muy bien... como los humanos.
Las BBD, igual que los humanos afinamos mucho los primeros 2/3 cortes para reducir rápidamente el espacio de búsqueda.
En los primeros 2 cortes podemos quedarnos ya con 2000 palabras.
Para eso las BBDD aprenden la distribución de los datos: ESTADISTICAS DE UNA TABLA!

Esto está guay... pero tiene problemas! GORDOS.
- Cuanto espacio adicional necesito para crear un índice? A priori duplicar.. pero me temo que NO... Mucho más!
- La clave está en que los datos están ORDENADOS.
    Para que cuando llegue un dato nuevo haya hueco donde ponerlo en ORDEN, las BBDD crean ficheros para los INDICES MUCHO MAS GRANDES que lo que a priori necesitarían.. SOLO PARA DEJAR HUECOI: PCT_FREE. Si alrededor de cada dato le pido 2 huecos... Me triplica el volumen.
    Pero sea como fuere.. al final esos 2 huecos se llenan. Y en ese momento ya no hay donde meter palabras... Y cre un ANEXO.
    Y claro.. ahora la búsqueda ya no hay que hacerla en el INDICE... hay que hacerla en el INDICE y en el ANEXO!
    Pues sigue dando tiempo... Acabas con 500 anexos. Y las búsquedas se degradan un montón.
    Resultado: Hay que estar continuamente REGENERANDO LOS INDICES:
    Rejuntando los anexos que se han ido geenrando y dejando nuevos huecos para futuros datos.
    TODA BBDD necesita de mnto en sus índices, por como funcionan.

Otro problema adicional.

Recupero la tabla de datos:

id    nombre          edad           sexo             pais
1     Juan Perez      30             M               España
2     Maria Lopez     25             F               México
3     Carlos Ruiz     40             M               Argentina

Genero índice por Pais:
pais          id / ubicación (Oracle guarda el ROWID)
    Argentina    3
    España       1
    México       2

    Quiero buscar las personas de México. Puedo aplicar ese algoritmo de búsqueda binaria? Sin problema

Genero índice por Nombre

nombre          id / ubicación (Oracle guarda el ROWID)
    Carlos Ruiz     3
    Juan Perez      1
    Maria Lopez     2

    Quiero buscar a "Juan Perez". Puedo aplicar ese algoritmo de búsqueda binaria? Sin problema, ya que el índice está ordenado por nombre.
    Dónde está problema? Cuando quiero buscar "PEREZ"... y ojo , ni siguiera he dicho "Perez"!
    Puedo aplicar el algoritmo de búsqueda binaria? NO... los datos están ordenados por NOMBRE, no por APELLIDO.
    Que no haya además más de un apellido.
    Imagina un párrafo completo. O un documento entero. Ordenar por la primera palabra vale para algo? PARA NADA!
    Me llena la BBDD de índices inútiles que no me sirven para las búsquedas que realmente quiero hacer.

    Los índices que crean las BBDD sirven para campos en los que las búsquedas serán LITERALES, o como mucho busquedas del tipo:
    LIKE "Juan%". No sirven para búsquedas del tipo: QUE CONTENGA O QUE TERMINE EN.

    Y cuando tengo CONTENIDOS (de texto, como los que guardamos en Sites) lo que quiero hacer es precisamente buscar por palabras dentro del contenido, no por la primera palabra del mismo.

    Aquí no valen estos índices.
    Algunas BBDD intentan ofrecer soluciones a este problema mediante índices de texto completo (FULL TEXT).
    De hecho Oracle tiene un producto entero magnifico llamado ORACLE_TEXT, que forma parte de la licencia enterprise de Oracle.
    No viene instalado por defecto, hay que instalarlo y configurarlo apart, pero pagado está.

    Es bueno... pero aún así NO LLEGA... sobre todo en entornos de ALTA DISPONIBILIDAD y con un volumen de usuarios grande! Que es para lo que inicialmente se piensa un Oracle Webcenter Sites.

        RECETAS DE COCINA
id    titulo                                    tiempo        Tipo de plato        País
1     Tortilla de Patatas (estilo la abuela)      30             M               España
2     Enchiladas Verdes                           25             F               México
3     Ensalada de pimiento morrón y patata        40             M               Argentina

Voy a crear un índice de texto completo (índices invertidos) para poder buscar dentro del nombre:
ESTO ES EL TRABAJO DE LUCENE:

    Juan Perez
    Maria Lopez
    Carlos Ruiz

Sobre los datos, aplica un proceso entero de INGESTA/INDEXACION:
1. Tokenizar
   - Separar el texto en palabras individuales (tokens)
     Tortilla-de-Patatas-estilo-la-abuela
     Enchiladas-Verdes
     Ensalada-de-pimiento-morrón y patata
2. Normalización
   - Convertir todas las palabras a minúsculas
     tortilla-de-patatas-estilo-la-abuela
     enchiladas-verdes
     ensalada-de-pimiento-morrón-y-patata
3. Convertir caracteres especiales: 
   - Reemplazar caracteres acentuados y otros caracteres especiales por sus equivalentes sin acento
     tortilla-de-patatas-estilo-la-abuela
     enchiladas-verdes
     ensalada-de-pimiento-morron-y-patata
4. Quitar las palabras que no aportan significado (stop words - Que dependen del idioma)
   - Eliminar palabras comunes que no aportan valor a la búsqueda
     tortilla-*-patatas-estilo-*-abuela
     enchiladas-verdes
     ensalada-*-pimiento-morron-*-patata
5.  Pueden llegar a aplicar técnicas más avanzadas, como el stemming: Quedarme con la raiz de las palabras
    O asl menos quitar los prefijos de género y número
    tor-*-patat-estil-*-abuel
    enchil-*-verd
    ensal-*-pimient-*-morr-*-patat
6. Y ahora se genera el índice:
    tor    Documento 1(1)
    patat  Documento 1(3)
    estil  Documento 1(4)
    abuel  Documento 1(5)
    enchil  Documento 2(1)
    verd  Documento 2(2)
    ensal  Documento 3(1)
    pimient  Documento 3(3)
    morr  Documento 3(4)
    patat  Documento 3(5)
7. Consolida datos
    tor    Documento 1(1)
    patat  Documento 1(3)    Documento 3(5)
    estil  Documento 1(4)
    abuel  Documento 1(5)
    enchil  Documento 2(1)
    verd  Documento 2(2)
    ensal  Documento 3(1)
    pimient  Documento 3(3)
    morr  Documento 3(4)
8. Ordena:
    abuel  Documento 1(5)
    enchil  Documento 2(1)
    ensal  Documento 3(1)
    morr  Documento 3(4)
    patat  Documento 1(3)    Documento 3(5)
    pimient  Documento 3(3)
    tor    Documento 1(1)
    verd  Documento 2(2)

    Esto es lo que se indexa.
Este proceso, sobre un documento/texto grande, tarda!
Un insert en una BBDD es escribir un texto (unos cuanto sbytes) en el culo de un fichero = RAPIDO!
Si tengo un INDICE NORMAL, el insert implica:
- Escribir el texto (bytes) en el culo del fichero
- Buscar la ubicación del dato que se indexa en el índice \
- Actualizar el índice con la nueva información           / RAPIDO

El hacer TODO ESE TRABAJO QUE ACABAMOS DE HABLAR... son ORDENES DE MAGNITUD DE DIFERENCIA EN LOS TIEMPOS.
Lo normal es que este trabajo se haga de forma ASINCRONA!
- El dato se guarda en BBDD
- Y en algún momento (cuando haya capacidad y tiempo) se actualizará el índice invertido con la nueva información

ESTO ES SOLO LA INDEXACION.
Ahora viene la BUSQUEDA!

Quiero buscar "PATATITAS CON Pimientos". Al texto de búsqueda se le aplica el MISMO PROCESO:
- PATATITAS CON PIMIENTOS
- PATATITAS-CON-PIMIENTOS
- patatitas-con-pimientos
- patatitas-*-pimientos
- patat-*-pimient-
  patat y (cerca) pimient
  Y entro y hago la query de cada uno de esos términos en el indicer invertido:
    patat -> Documento 1(3)    Documento 3(5)
    pimient -> Documento 3(3)
    Y miro el común: Documento 3(3+5 = CERCA!) LO TENGO -> RESULTADO!

    ESTO HACE LUCENE!

Problema.
Lucene es una librería de JAVA... y esos datos los guarda en archivos.
Esa librería corre con los weblogic, con el sites... Y los archivos? donde se dejan?
Cada weblogic/sites puede tener su propio conjunto de archivos?
- Tengo solo una máquina ejecutando Weblogic y sites? Tengo un cluster en el dominio de Weblogic
- Y cada máquina tiene su proceso de indexación: LUCENE
- Y cada máquina va recibiendo documentos a indexar de unos usuarios.
  - MAQUINA 1: Usuario 17:INDEXA LO MIO
  - MAQUINA 2: Usuario 23:INDEXA LO MIO
  El problema es que cuando alguien entre en la máquina 1, y haga una búsqueda debe ver lo del usuario 17 y lo del 23. 

  Oracle Sites tomó una muy mala decisión: Dejar los arhivos en una carpeta compartida entre las máquinas.
  De vez en cuando.. como se junten demasiadas cosas (trabajos de indexación) se me joden los archivos (CORRUPTOS) si hay varios urgando en ellos.

SOLUCIÓN: OPENSEARCH!

# OpenSearch

Qué es Opensearch?

Para hablar de Opensearch hay que hablar de otro producto: ElasticSearch.

ElasticSearch es un GESTOR DE LUCENES EN CLUSTER.
Le pido a ElasticSearch que indexe un dato, y lo manda a indexar a varios nodos. y los mantiene sincronizados entre si.
Elastisearch no es un proceso que corre en weblogic... Es un programa independiente que trabaja fuera.. Y al que accedermos por http (servicio REST)

 CLUSTER DE ELASTICSEARCH
   NODO 1   
   NODO 2
   NODO 3

Y llega el dato1 y se indexa en los 3 nodos del cluster, mientras están indexando ese dato, no pueden indexar otro.
Es decir, has hecho un x3 en la infra, pero tu rendimiento es x1. De hecho ese sería el rendiiento máximo teórico.. ahora quitale comunicaciones entre ellos... Tengo al final un x0.8 en el rendimiento. Y la gente cabreada... MUCHO ENTORNO DE PRODUCCION Y VA MAS LENTO QUE EN MI MAQUINA!

Lo guardo en algunas

    NODO 1: dato1 dato2
    NODO 2: dato1 dato3
    NODO 3: dato2 dato3

Guardo cada dato en 2 nodos (en 2 lucenes diferentes)

Hago un x3 en la infra y el rendimiento máximo teórico mejora en un 50%... es triste... pero es algo. Y al menos los datos están replicados y no se corrompen ni se pierden.. a no ser que se me jodan 2 máquinas del cluster a la vez.

Es más complejo.
En Sites cada tipo de asset se guarda en lo que en ELASTICSEARCH SE LLAMA UN INDICE.
Pero es un concepto raro de INDICE... En ES un INDICE es un CONJUNTO DE LUCENES!
Que además pueden estar replicados!

            INDICE "COMUNICADOS PUBLICOS"
  Nodo1      lucene1 (A-M)
  Nodo2      lucene2 (M-Z)       lucene1' (A-M)
  Nodo3      lucene2' (M-Z)

Esos lucenes en ElasticSearch se llaman SHARDS (FRAGMENTOS de índice)
Y pueden ser primarios o réplicas!

- Yo defino cuántos shards primarios quiero para un índice y cuántas réplicas de cada shard quiero.
- Y cada índice es un asset type en Sites.

Pero.. estoy hablando de ElasticSearch... y no Opensearch.

ElastiSearch es un programa que monta una empresa llamada Elastic Inc.
Hasta hace 3 años ElasticSearch era completamente open source (con modalidades de pago y modalidades gratuitas).
Es caro a rabiar! Al mismo nivel o más que Sites.

Hace 3 años, cambiaron la política y su código (parte de él) dejó de ser completamente open source.
Y llegó AMAZON! y dijo.. tu.. que nosotros usamos esto un huevo! CUIDAO!
Y desde la última versión de ElasticSearch que había opensource sacaron un fork llamado OpenSearch.
Es la continuación OPENSOURCE del proyecto ELASTICSEARCH cuando elasticSearch dejo de ser Opensource!

Hay muchas cosas que ofrece Opensearch! MUCHAS:
- Búsquedas fonéticas
- Búsquedas SEMANTICAS (embedings) IA -> Genera un VECTOR numérico que CONTIENE / SIMBOLIZA EL SIGNIFICADO del contenido.
          - Cuadro: Mujer mirando el mar al atardecer
          - Cuadro: Persona por la noche en el oceano
- Cuadros de mando

- Realmente Webcenter Sites AUN NO SACA MUCHO PARTIDO DE OPENSEARCH... Y dudo que lo saque en el futuro.

BASICAMENTE ES MONTAR GOOGLE EN MI EMPRESA! 

En lucene se pueden definir ANALIZADORES SINTACTICOS PROPIOS en WebCenterSites Integrado.
(Tu defines, tus stop words, tus terminaciones de palabras, acentos, ... si quieres partir palabras por otros conceptos: ALEMAN)

La integración por defecto de LUCENE Es con un analyzer inglés!

Tienen tan pocos usuarios de Sites con Analizadores propios que ni siquiera han documentado ni adaptado correctamente esta funcionalidad al migrar a Opensearch. Se puede hacer.. pero va por otro lado distinto. 


---

