# Módulo 2 · De Java 8 a Java 17 — guion de la demo

Todo lo de esta carpeta está **ejecutado y comprobado** (26-10-2026, macOS). Las
salidas que aparecen abajo son las reales.

## Antes de la clase

```bash
cd ~/Documents/cursos/formacionSites/modulo2-java17
./preparar.sh          # ~1 minuto. Deja JDK 8 y 17 y todas las dependencias en local
```

No instala nada en el sistema: los JDK van en `.jdks/` y Maven usa `.m2/`, ambos
dentro de esta carpeta. Después, la clase funciona **sin red**.

Para escribir menos en directo:

```bash
export J8=$PWD/.jdks/jdk8/Contents/Home J17=$PWD/.jdks/jdk17/Contents/Home
alias mvn8="JAVA_HOME=\$J8 mvn -B -Dmaven.repo.local=$PWD/.m2"
alias mvn17="JAVA_HOME=\$J17 mvn -B -Dmaven.repo.local=$PWD/.m2"
```

## Qué hay

| Carpeta | Qué es |
|---|---|
| `1-aplicacion-java8/` | La aplicación «de antes»: una WAR de WebLogic 12.2.1.4, Java 8, con **ocho casos** que rompen |
| `2-aplicacion-java17/` | La misma aplicación, migrada. Comparad los `pom.xml`: casi todo el arreglo está ahí |
| `3-trampa-jakarta/` | Un filtro de Spring: con Spring 5.3 compila, y con Spring 6 (`jakarta`) no |
| `4-openrewrite/` | Migración asistida, sus aciertos y sus límites |
| `5-sites/` | **Lo mismo, en Sites de verdad**: plantillas JSP y controladores Groovy, versión rota y arreglada, subidos a Avisports |
| `herramientas/analizar.sh` | `jdeps` + `jdeprscan` + la **Migration Analysis Tool** de Oracle sobre una WAR |
| `herramientas/detectar-jakarta.sh` | ¿Alguna librería de la WAR tira de `jakarta.*`? |
| `herramientas/weblogic.migration-analysis-tool.jar` | La herramienta de Oracle, copiada de nuestro WebLogic 14.1.2 |

En un proyecto Sites, la mayor parte del código son **plantillas, CSElements y
controladores** (escena 9). La WAR de las escenas 1 a 8 representa **vuestros jars
propios**, los que llaman las plantillas: el Java que se rompe es el mismo. Las WAR
sueltas desplegadas junto a Sites existen, pero son lo menos habitual.

Los ocho casos, en `1-aplicacion-java8/src/main/java/es/curso/sites/casos/`:

| Clase | Caso | Cómo rompe en Java 17 |
|---|---|---|
| `ClienteHttpAntiguo` | **«Lo de sun http»**: `sun.net.www.protocol.http.HttpURLConnection` | No compila (con `release 17`). Si no, `IllegalAccessError` en ejecución |
| `CodificadorBase64` | `sun.misc.BASE64Encoder` | No existe |
| `ConversorXml` + `Articulo` | JAXB (`javax.xml.bind`) | No está en el JDK |
| `ServicioArticulos` | `@PostConstruct` (`javax.annotation`) | No está en el JDK |
| `NombreCertificado` | `sun.security.x509.X500Name` | No compila. En ejecución, `IllegalAccessError` |
| `MotorPlantillas` | Nashorn (JavaScript) | **Compila**, y en ejecución el motor es `null` |
| `AccesoProfundo` | Reflexión dentro del JDK | **Compila**, y en ejecución `InaccessibleObjectException` |
| `Textos` | commons-lang 2 «que ponía WebLogic» | **Compila y funciona en local**. Falla en WebLogic 14.1.2, que ya no la trae |

Y además: Lombok 1.18.12 y un `arrancar.sh` con las opciones de JVM de la época.

---

## Escena 1 · Así estaba: Java 8, todo funciona

```bash
cd 1-aplicacion-java8
mvn8 clean package
./arrancar.sh $J8
```
```
Java 1.8.0_504

sun http (ClienteHttpAntiguo)        OK     200 hola desde el servidor
sun.misc.BASE64Encoder               OK     V2ViQ2VudGVy
JAXB (javax.xml.bind)                OK     <articulo><cuerpo>Mundo</cuerpo><titulo>Hola</titulo></articulo>
sun.security.x509                    OK     webcenter
Nashorn (JavaScript)                 OK     42
Reflexion dentro del JDK             OK     3
commons-lang (lo traia WebLogic)     OK     Webcenter sites c...
@PostConstruct (javax.annotation)    OK     la anotacion existe: javax.annotation.PostConstruct
```

## Escena 2 · Cambio la JVM y no toco nada

Es lo que pasa si en el upgrade solo se cambia el JDK. Primero, el arranque de
siempre:

```bash
./arrancar.sh $J17
```
```
Unrecognized VM option 'MaxPermSize=256m'
Error: Could not create the Java Virtual Machine.
```

**Ni arranca.** En Java 17, `MaxPermSize`, `PermSize`, `UseConcMarkSweepGC` y
`CMSClassUnloadingEnabled` tumban la JVM, las cuatro (comprobado una a una).
Mirad los `setDomainEnv` y los `JAVA_OPTIONS`.

Sin esas opciones, el mismo binario:

```bash
$J17/bin/java -cp "target/classes:target/lib/*" es.curso.sites.Demo
```
```
Java 17.0.20.1

sun http (ClienteHttpAntiguo)        FALLA  IllegalAccessError: … cannot access class sun.net.www.protocol.http…
sun.misc.BASE64Encoder               FALLA  NoClassDefFoundError: sun/misc/BASE64Encoder
JAXB (javax.xml.bind)                FALLA  NoClassDefFoundError: javax/xml/bind/JAXBContext
sun.security.x509                    FALLA  IllegalAccessError: … cannot access class sun.security.x509.X500Name…
Nashorn (JavaScript)                 FALLA  NullPointerException: … because "motor" is null
Reflexion dentro del JDK             FALLA  InaccessibleObjectException: Unable to make field … ArrayList.elementData accessible…
commons-lang (lo traia WebLogic)     OK     Webcenter sites c...
@PostConstruct (javax.annotation)    FALLA  ClassNotFoundException: javax.annotation.PostConstruct
```

**Fijaos en commons-lang: OK.** En local la pone `target/lib`, pero en WebLogic
14.1.2 no estará. Ninguna de estas pruebas lo ve (escena 5).

## Escena 3 · Compilo con Java 17: el primer error no es vuestro

```bash
mvn17 clean package
```
```
Fatal error compiling: java.lang.IllegalAccessError: class lombok.javac.apt.LombokProcessor
  cannot access class com.sun.tools.javac.processing.JavacProcessingEnvironment …
```

Revienta el **compilador entero**, antes de mirar una línea de vuestro código. Es
Lombok 1.18.12. **Primero se arregla el build, luego el código.**

## Escena 4 · Lombok al día… y la trampa de `source/target`

```bash
mvn17 -Dlombok.version=1.18.48 clean package
```

Salen JAXB, `javax.annotation` y `BASE64Encoder`, pero **no** los dos `sun.*`.
Solo un aviso:

```
sun.net.www.protocol.http.HttpURLConnection is internal proprietary API and may be removed in a future release
sun.security.x509.X500Name is internal proprietary API and may be removed in a future release
```

Con `source/target 1.8`, el JDK 17 **compila** esos usos, y luego revientan en
ejecución (escena 2). Ahora con `release`:

```bash
mvn17 -Dlombok.version=1.18.48 -Dmaven.compiler.release=17 clean package
```
```
ClienteHttpAntiguo.java:[7,28] package sun.net.www.protocol.http is not visible
NombreCertificado.java:[3,20] package sun.security.x509 is not visible
ConversorXml.java:[5,22] package javax.xml.bind does not exist
ServicioArticulos.java:[3,24] package javax.annotation does not exist
CodificadorBase64.java:[5,16] cannot find symbol
…
```

> **Moraleja: `<maven.compiler.release>17</maven.compiler.release>`, nunca
> `source/target`.** Con `release` los problemas salen al compilar, no en
> producción.

Para volver a dejarla como estaba: `mvn8 clean package`.

## Escena 5 · Las herramientas de análisis

```bash
cd ..
herramientas/analizar.sh 1-aplicacion-java8/target/aplicacion-java8-1.0.war
```

**1. `jdeps --jdk-internals`** encuentra los `sun.*` **y propone el sustituto**:
```
es.curso.sites.casos.ClienteHttpAntiguo  -> sun.net.www.protocol.http.HttpURLConnection  JDK internal API (java.base)
es.curso.sites.casos.CodificadorBase64   -> sun.misc.BASE64Encoder                       JDK removed internal API
es.curso.sites.casos.NombreCertificado   -> sun.security.x509.X500Name                   JDK internal API (java.base)

sun.misc.BASE64Encoder        Use java.util.Base64 @since 1.8
sun.security.x509.X500Name    Use javax.security.auth.x500.X500Principal @since 1.4
```

**2. `jdeprscan --release 17`**: cada «cannot find class» es algo que no está ni
en Java 17 ni en la WAR. Los `javax.servlet` los pone WebLogic; los
`javax.xml.bind` hay que declararlos; `sun.misc` ya no existe.

**3. Migration Analysis Tool de Oracle** (viene con WebLogic 14.1.2, en
`$WL_HOME/server/lib/`). Busca clases que **WebLogic 12.2.1.4 traía y la 14.1.2
ya no**:
```
WEB-INF-classes.jar   org.apache.commons.lang.StringUtils(com.bea.core.apache.commons.lang.jar)
```
**Es la única que ve lo de commons-lang.** Su lista tiene más de 12.000 clases;
entre las librerías de terceros que desaparecen están commons-lang 2,
joda-time 2.10, Jersey 1 (`com.sun.jersey`) y jersey-guava. **Ojo: no todo
desaparece para Sites.** joda-time sigue, en la 2.12.5 (ver la escena 9).

> ⚠️ **Hallazgo del curso:** sobre una WAR, la herramienta **solo mira los jars de
> `WEB-INF/lib`, no `WEB-INF/classes`**, que es donde está vuestro código. Pasada
> directamente sobre esta WAR **no dice nada**. Por eso `analizar.sh` le pasa
> además un jar con `WEB-INF/classes`. Si la usáis a mano, haced lo mismo.

Sobre la WAR migrada **no todo sale limpio, y está bien** (comprobado):
- `jdeps` señala que **Nashorn** usa `sun.misc.Unsafe` por dentro. Es de las pocas
  APIs internas que Java 17 sigue permitiendo (módulo `jdk.unsupported`, JEP 260).
  Buen ejemplo de un `sun.*` que viene de una **librería**, no de vuestro código.
- `jdeprscan` sigue sin encontrar `javax.servlet` ni `javax.xml.bind`: son
  `provided`, no van en la WAR, los pone WebLogic.
- La Migration Analysis Tool, limpia.

**Leer estas herramientas es interpretar, no contar líneas.**

## Escena 6 · La aplicación migrada

```bash
cd 2-aplicacion-java17
diff ../1-aplicacion-java8/pom.xml pom.xml     # aquí está casi todo el arreglo
mvn17 clean package
./arrancar.sh $J17
```
```
Java 17.0.20.1

sun http (ClienteHttpAntiguo)        OK     200 hola desde el servidor
sun.misc.BASE64Encoder               OK     V2ViQ2VudGVy
JAXB (javax.xml.bind)                OK     <articulo><cuerpo>Mundo</cuerpo><titulo>Hola</titulo></articulo>
sun.security.x509                    OK     webcenter
Nashorn (JavaScript)                 OK     42
Reflexion dentro del JDK             OK     3
commons-lang (lo traia WebLogic)     OK     Webcenter sites c...
@PostConstruct (javax.annotation)    OK     la anotacion existe: javax.annotation.PostConstruct
```

**Mismos resultados que en Java 8.** Qué se ha tocado:

| Caso | Arreglo | ¿Código? |
|---|---|---|
| JAXB | `jakarta.xml.bind-api:2.3.3` + `jaxb-runtime:2.3.9`, `provided` | **No** |
| `@PostConstruct` | `jakarta.jakartaee-api:8.0.0`, `provided` | **No** |
| Nashorn | `nashorn-core:15.7`, empaquetado | **No** |
| Lombok | 1.18.48 + `annotationProcessorPaths` | No |
| sun http | `java.net.http.HttpClient` | Sí |
| `BASE64Encoder` | `java.util.Base64` | Sí |
| `X500Name` | `javax.naming.ldap.LdapName` | Sí |
| commons-lang 2 | `commons-lang3:3.21.0`, empaquetado (`lang` → `lang3`) | El import |
| Reflexión | `--add-opens` en `arrancar.sh`, **como parche** | No |

Quitad el `--add-opens` de `arrancar.sh` y vuelve la `InaccessibleObjectException`
(comprobado). Lo correcto es actualizar la librería que hace eso.

Y el propio WebLogic de Sites 14.1.2 arranca con `--add-opens` (leído en el proceso
del servidor el 27-10-2026): `java.base/java.lang`, `java.base/java.lang.reflect`,
`java.base/java.util`, `java.base/java.text` y `java.desktop/java.awt.font`. Este caso
concreto (`java.util`) probablemente funcione allí; **sin comprobar con una página**.
Nada de `sun.net`: por eso «lo de sun http» sí falla en Sites (escena 9).

Qué va dentro de la WAR, y qué no:
```bash
unzip -l target/aplicacion-java17-2.0.war | grep WEB-INF/lib
```
Solo Nashorn (y sus `asm`) y commons-lang3. **JAXB y Java EE no van dentro: los pone
WebLogic.**

## Escena 7 · La trampa de `jakarta`

```bash
cd ../3-trampa-jakarta
mvn17 clean package                                  # Spring 5.3.39: compila
../herramientas/detectar-jakarta.sh target/trampa-jakarta-1.0.war
```
```
Ninguna libreria usa jakarta.*: compatible con WebLogic 14.1.2 (javax).
```

«Ya que estamos en Java 17, subo Spring»:
```bash
mvn17 -Dspring.version=6.2.19 clean package
```
```
FiltroCabeceras.java:[15,8] cannot access jakarta.servlet.Filter
```

Y qué librerías han entrado con `jakarta`:
```bash
mvn17 -q -Dspring.version=6.2.19 dependency:copy-dependencies -DoutputDirectory=target/libs-spring6
../herramientas/detectar-jakarta.sh target/libs-spring6
```
```
JAKARTA  spring-beans-6.2.19.jar: jakarta.inject
JAKARTA  spring-context-6.2.19.jar: jakarta.annotation jakarta.ejb …
JAKARTA  spring-web-6.2.19.jar: … jakarta.servlet jakarta.servlet.http … jakarta.xml.bind …
JAKARTA  spring-webmvc-6.2.19.jar: … jakarta.servlet …
```

Para dejarlo como estaba: `mvn17 clean package`.

## Escena 8 · OpenRewrite: lo que hace y lo que no

```bash
cd ../4-openrewrite
./openrewrite-java17.sh             # propone un parche, sin tocar nada
./openrewrite-java17.sh aplicar     # lo aplica sobre una copia y compila con release 17
```

Trabaja siempre sobre una **copia** de `1-aplicacion-java8`: la original no se toca
y la demo se puede repetir.

> ⚠️ **Hallazgo del curso:** OpenRewrite entiende el código con el JDK con el que
> corre. **Hay que lanzarlo sobre el JDK viejo (8).** Sobre JDK 17 no reconoce
> `BASE64Encoder` ni `javax.xml.bind` (ya no existen) y solo toca el pom.

**Lo que hace bien:**
- `BASE64Encoder` → `java.util.Base64`
- añade JAXB y `javax.annotation`, y en su versión `javax` (2.3.3 y 1.3.5)
- sube Lombok, `maven-compiler-plugin` y `maven-war-plugin`

**Sus límites:**
1. Pone `source/target 17`, **no `release 17`**: la trampa de la escena 4.
2. Mete el API de JAXB con scope `compile` y `jaxb-runtime` como `runtime`: los dos
   acabarían **dentro de la WAR**, duplicando lo que trae WebLogic. Hay que pasarlos
   a `provided` a mano.
3. **No toca** sun http, `sun.security.x509`, Nashorn, la reflexión ni commons-lang.

Tras aplicarlo y compilar con `release 17`, lo que queda para hacer a mano:
```
ClienteHttpAntiguo.java:[7,28] package sun.net.www.protocol.http is not visible
NombreCertificado.java:[3,20] package sun.security.x509 is not visible
```
Y Nashorn, la reflexión y commons-lang **no salen ni ahí**: fallan en ejecución o
en el servidor. Para eso están las escenas 2 y 5.

### La receta de `jakarta`, solo para verla

```bash
./openrewrite-jakarta.sh
```
Cambiaría `javax.servlet`, `javax.annotation` y `javax.xml.bind` por `jakarta.*`, y
el pom. **No se aplica en WebLogic 14.1.2**, que es `javax`. Es el trabajo de la
siguiente migración, a WebLogic 15.1.1.

## Escena 9 · Y en Sites: el código que no pasa por Maven

Todo lo anterior es una WAR. Pero buena parte del código de un proyecto Sites son
**plantillas JSP y controladores Groovy** guardados en Sites, que compila WebLogic
**al pedir la página**. Ni Maven, ni `jdeps`, ni la herramienta de Oracle, ni
OpenRewrite los ven. El primer aviso es la página caída.

Ya están subidos a Avisports. Se entra por el navegador, con Keycloak:

**https://webcenter.ivanosuna.com/sites/ContentServer?pagename=CursoMig/Indice**

Cada caso tiene dos páginas, `CursoMig/Roto/<caso>` y `CursoMig/Bien/<caso>`:

| Caso | Roto: qué pasa en 14.1.2 con Java 17 | Bien |
|---|---|---|
| `Base64` (`sun.misc.BASE64Encoder`) | **No compila el JSP**: *The import sun.misc.BASE64Encoder cannot be resolved* | `java.util.Base64` |
| `SunHttp` (**lo de sun http**) | **Compila**, y en ejecución `IllegalAccessError`: *module java.base does not export sun.net.www.protocol.http* | `java.net.http.HttpClient` |
| `Nashorn` | Compila, y en ejecución `NullPointerException`: el motor es `null` | La cuenta en Java |
| `CommonsLang` (commons-lang 2) | **No compila**: WebLogic 14.1.2 ya no la trae | `lang3`, que sí está |
| `Jaxb` | **Funciona igual en las dos**: el JDK ya no trae JAXB, pero WebLogic sí, en `javax` | — |
| `Groovy` (sun http en un controlador) | Groovy lo compila, y en ejecución el mismo `IllegalAccessError` | `HttpClient` |

En el navegador solo sale *«Content Server error»*. El detalle está en el log del
servidor:

```bash
kubectl -n webcenter logs wcsitesinfra-wcsites-server1 -c weblogic-server --since=5m \
  | grep -v '^\s*at ' | grep -A4 CursoMig
```

**`CursoMig/QueHayEnElServidor`** enseña qué clases ve una plantilla y de qué jar
salen. Sacado de ahí (Sites 14.1.2, imagen 241205):

```
NO  sun.misc.BASE64Encoder
SI  sun.net.www.protocol.http.HttpURLConnection   (del JDK: existe, pero no se puede usar)
SI  javax.xml.bind.JAXBContext                    oracle_common/modules/jakarta.xml.bind-api-2.3.3.jar
SI  javax.annotation.PostConstruct                oracle_common/modules/endorsed/jakarta.annotation-api-1.3.4.jar
NO  Nashorn (ni jdk.nashorn ni org.openjdk.nashorn)
NO  org.apache.commons.lang.StringUtils
SI  org.apache.commons.lang3.StringUtils          oracle_common/modules/thirdparty/commons-lang3-3.14.0.jar
SI  org.joda.time.DateTime                        oracle_common/modules/thirdparty/joda-time-2.12.5.jar
NO  com.sun.jersey (Jersey 1)
SI  org.glassfish.jersey (Jersey 2)               oracle_common/modules/jersey-client-2.45.jar
Motores de scripts: Groovy, JEXL, jython. JavaScript, ninguno.
```

### Cómo se encuentran antes de que caiga la página

```bash
cd 5-sites
./detectar.sh            # grep sobre la carpeta de elementos de Sites
```

Encuentra los nuestros, y **ninguno de los más de 1.400 elementos de Oracle**. En
un proyecto real se pasa sobre la exportación de CSDT: `./detectar.sh <carpeta>`.

### Los controladores: dónde se ve que no compilan

Un controlador que no compila **no da error al guardarlo**. Sale en
**Admin › System Tools › Controllers**, y la página que lo usa cae. Para verlo:

```bash
./subir.py --no-compila  # sube además CursoMigNoCompilaController (sun.misc)
./subir.py               # lo quita
```

### Volver a subirlo

```bash
cd 5-sites
./subir.py               # borra lo del curso y lo vuelve a crear (~1 min)
./subir.py --borrar      # quita todo lo del curso de Avisports
```

Va por la API REST de Sites, y desde casa: usa el ingress interno (`192.168.2.252`)
para no pasar por Keycloak. Tres cosas que salieron montándolo, todas comprobadas:

1. Actualizar un CSElement por REST contesta 200 **y no reescribe el JSP**. Por
   eso se borra y se crea.
2. Un controlador creado por REST **no se compila**: la compilación va colgada de
   la interfaz de Sites, y con `ft.filecheck=no` Sites no vuelve a mirar el disco.
   `subir.py` lo compila al final con `CursoMig/CompilarControladores`, que hace lo
   mismo que el botón *Compile All* de esa pantalla.
3. La búsqueda REST no devuelve nada mientras OpenSearch no esté configurado. Por
   eso los ids se guardan en `5-sites/.ids.json`.

---

## Versiones usadas (todas comprobadas en Maven Central)

| | Versión |
|---|---|
| JDK | Temurin 8u504 y 17.0.20.1 |
| OpenRewrite | `rewrite-maven-plugin` 6.46.1, `rewrite-migrate-java` 3.42.1 |
| Lombok | 1.18.12 (la que rompe) → 1.18.48 |
| Spring | 5.3.39 (última `javax`) / 6.2.19 (`jakarta`, la trampa) |
| Migration Analysis Tool | 14.1.2.0, de la imagen `webcentersites:14.1.2.0-jdk17-ol8-241205` |
