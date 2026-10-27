# Paquetes que dan guerra al pasar de Java 8 a Java 17 (WebCenter Sites 14.1.2)

> Versiones comprobadas en Maven Central el **26-10-2026**: que existen, y que los
> jars traen paquetes `javax` y no `jakarta`, abriéndolos uno a uno.

## La regla de oro

WebLogic 14.1.2 es **Jakarta EE 8**: paquetes **`javax`**. Lo que ya trae WebLogic
va con **`scope provided`**: se necesita para compilar, pero no se empaqueta.

⚠️ **La trampa de los nombres.** Los artefactos que empiezan por `jakarta.` siguen
trayendo paquetes **`javax`** en sus versiones antiguas, y pasan a `jakarta` en las
nuevas. **Mirad el número de versión, no el `groupId`.** Comprobado dentro del jar:

| Artefacto | Versión → paquetes |
|---|---|
| `jakarta.xml.bind:jakarta.xml.bind-api` | **2.3.3 → `javax.xml.bind`** · 3.0.0 → `jakarta.xml.bind` |
| `jakarta.annotation:jakarta.annotation-api` | **1.3.5 → `javax.annotation`** · 2.0.0 → `jakarta.annotation` |

## 1. Lo que quitó el JDK en Java 11 y trae WebLogic

**Arreglo: solo en el `pom.xml`.** El código no se toca.

### Lo propio de Java EE: una sola dependencia

```xml
<dependency>
  <groupId>jakarta.platform</groupId>
  <artifactId>jakarta.jakartaee-api</artifactId>
  <version>8.0.0</version>          <!-- 8.x = javax. NO subir a 9 o más -->
  <scope>provided</scope>
</dependency>
```

Trae, entre otros, `javax.servlet`, `javax.persistence`, `javax.ws.rs`, `javax.ejb`,
`javax.jms`, **`javax.annotation`** y **`javax.transaction`**.

### OJO: JAXB y JAX-WS NO van en esa dependencia

En Java EE 8 venían **dentro del JDK 8**, así que la plataforma no las incluye.
Con Java 17 hay que ponerlas aparte (comprobado: `jakartaee-api:8.0.0` no trae ni
`javax.xml.bind`, ni `javax.xml.ws`, ni `javax.jws`, ni `javax.xml.soap`, ni
`javax.activation`):

| Paquete que falla | Qué es | Dependencia (`provided`), última de la línea `javax` |
|---|---|---|
| `javax.xml.bind` | JAXB, XML ↔ objetos | `jakarta.xml.bind:jakarta.xml.bind-api:2.3.3` |
| `javax.xml.ws` | JAX-WS, servicios SOAP | `jakarta.xml.ws:jakarta.xml.ws-api:2.3.3` |
| `javax.jws` | Anotaciones de servicios web | `jakarta.jws:jakarta.jws-api:1.1.1` |
| `javax.xml.soap` | SAAJ | `jakarta.xml.soap:jakarta.xml.soap-api:1.4.2` |
| `javax.activation` | JAF | `jakarta.activation:jakarta.activation-api:1.2.2` |
| `javax.annotation` | `@PostConstruct`, `@Resource` | ya está en `jakartaee-api` (suelta: `jakarta.annotation-api:1.3.5`) |
| `javax.transaction` | JTA | ya está en `jakartaee-api` (suelta: `jakarta.transaction-api:1.3.3`) |

```xml
<dependency>
  <groupId>jakarta.xml.bind</groupId>
  <artifactId>jakarta.xml.bind-api</artifactId>
  <version>2.3.3</version>
  <scope>provided</scope>
</dependency>
```

### Herramientas de generación (`xjc`, `wsimport`)

Ya no vienen con el JDK. Plugins de Maven en su línea `javax`:

| Plugin | Versión | Por dentro usa |
|---|---|---|
| `org.codehaus.mojo:jaxb2-maven-plugin` | **2.5.0** (la 3.x genera `jakarta`) | JAXB 2.3.2 |
| `com.sun.xml.ws:jaxws-maven-plugin` | **2.3.7** (la 4.x genera `jakarta`) | jaxws-tools 2.3.6 |

### Código que corre FUERA de WebLogic (tests, utilidades)

Además del API, la implementación, **sin** `provided`:
- JAXB: `org.glassfish.jaxb:jaxb-runtime:2.3.9`
- JAX-WS: `com.sun.xml.ws:jaxws-rt:2.3.7`

## 2. APIs internas del JDK (`sun.*`, `com.sun.*`)

**Arreglo: cambiar el código.** Abrirlas con `--add-exports` o `--add-opens` es
el último recurso: hay que pedirlo en cada arranque y puede romper en la siguiente
versión de Java.

| Paquete que falla | Sustituto |
|---|---|
| **`sun.net.www.protocol.http.*`, `sun.net.www.http.HttpClient`** | **`java.net.http.HttpClient`** (Java 11 en adelante). Para tocar poco: `java.net.HttpURLConnection`. Para algo potente: Apache HttpClient |
| `sun.misc.BASE64Encoder` / `BASE64Decoder` | `java.util.Base64` (Java 8 en adelante) |
| `sun.security.x509.*`, `sun.security.*` (certificados) | Leer: `java.security.cert.*`. Generar: Bouncy Castle, `org.bouncycastle:bcpkix-jdk18on:1.86` |
| `sun.reflect.Reflection.getCallerClass` | `java.lang.StackWalker` (Java 9) |
| `com.sun.org.apache.xerces.internal.*`, `…xalan.internal.*` | APIs públicas: `javax.xml.parsers`, `javax.xml.transform` |
| `sun.misc.Unsafe` | Sigue funcionando (`jdk.unsupported`), pero lo correcto es `VarHandle`. Suele venir de librerías viejas |

**No es problema:** `com.sun.net.httpserver` sigue siendo API soportada.

## 3. Lo que desapareció sin más

| Qué | Desde | Qué hacer |
|---|---|---|
| Nashorn (`jdk.nashorn.*`, `ScriptEngine` "nashorn") | Java 15 | `org.openjdk.nashorn:nashorn-core:15.7`, o quitar el JavaScript del servidor |
| CORBA (`org.omg.*`, `javax.rmi.CORBA`) | Java 11 | Quitarlo. *Sin comprobar si WebLogic 14.1.2 lo trae* |
| Recolector CMS (`-XX:+UseConcMarkSweepGC`, `-XX:+CMSClassUnloadingEnabled`) | Java 14 | **La JVM no arranca**: quitarlas de los arranques |
| `-XX:MaxPermSize`, `-XX:PermSize` | Java 8 (aviso) / Java 17 (error) | **La JVM no arranca** en Java 17: en Java 8 solo avisaba, y por eso siguen en tantos `setDomainEnv` |
| `endorsed`, `-Xbootclasspath/p` | Java 9 | Quitar de los arranques |

Las cuatro opciones de JVM, comprobadas una a una con JDK 17.0.20: *«Unrecognized
VM option … Could not create the Java Virtual Machine»*.

## 3 bis. Lo que traía WEBLOGIC 12.2.1.4 y la 14.1.2 ya no

Muchas aplicaciones tienen en `provided` librerías **«porque ya las pone el
servidor»**. Algunas ya no las pone. Compila y funciona en local: **ni el
compilador ni `jdeps` lo ven**. Solo lo ve la *Migration Analysis Tool* de Oracle,
que lleva la lista dentro (más de 12.000 clases). Entre las de terceros:

| Lo que traía WebLogic 12.2.1.4 | Paquete | Qué hacer |
|---|---|---|
| commons-lang 2 | `org.apache.commons.lang` | `lang` → `lang3`. WebLogic 14.1.2 trae commons-lang3 3.14.0 y Sites la ve; en una WAR propia, empaquetad `org.apache.commons:commons-lang3:3.21.0` |
| joda-time 2.10 | `org.joda.time` | La herramienta avisa, pero Sites 14.1.2 **sí la ve**: 2.12.5, de `oracle_common/modules/thirdparty`. A medio plazo, `java.time` |
| Jersey 1 | `com.sun.jersey` | Migrar a Jersey 2 (`javax`), que sí trae WebLogic 14.1.2 |
| commons-pool 1, cglib-nodep 3.2.5 | `org.apache.commons.pool`, `net.sf.cglib` | Empaquetarlas, o sustituirlas |

En **Jersey 2** también desaparecen clases sueltas, no la librería entera: pasad la
herramienta.

Lo que de verdad ve una plantilla de Sites en vuestro servidor lo enseña la página
`CursoMig/QueHayEnElServidor` (ver `modulo2-java17/5-sites`). Comprobado en Sites
14.1.2 el 27-10-2026: commons-lang 2 **no**, Jersey 1 **no**; commons-lang3 3.14.0,
joda-time 2.12.5, JAXB 2.3.3 y Jersey 2.45 **sí**.

## 4. No subir de más: librerías que en su versión nueva ya son `jakarta`

Quedarse en la **última versión de la línea `javax`** (comprobado abriendo el jar):

| Librería | Usar (`javax`) | Todavía NO (`jakarta`) |
|---|---|---|
| Spring Framework | **5.3.39** | 6.x |
| Spring Boot | **2.7.18** | 3.x |
| Jersey | **2.48** | 3.x |
| Apache CXF | **3.6.13** | 4.x |
| Hibernate ORM | **5.6.15.Final** | 6.x |

⚠️ Spring 5.3 y Spring Boot 2.7 ya no tienen soporte gratuito de la comunidad: no
reciben arreglos de seguridad sin soporte comercial. Es el precio de quedarse en
`javax` hasta la siguiente migración.

## 5. Librerías que se rompen en Java 17 por ser viejas

No es por `javax`: hurgaban dentro del JDK y Java 17 ya no lo permite. **Subirlas:**

| Librería | Mínimo para Java 17 | Última hoy |
|---|---|---|
| Lombok | 1.18.22 | 1.18.48 |
| Mockito | 4.x | 5.24.0 |
| `maven-compiler-plugin` | 3.8, con `<release>17</release>` | 3.16.0 |

PowerMock no se lleva bien con Java 17: mejor retirarlo. Las versiones antiguas de
cglib, javassist o ASM, que suelen venir arrastradas por otras librerías, también
dan problemas.

## 6. Encontrarlos antes de que exploten

Todo esto está montado y probado en `modulo2-java17/` (ver su README).

⚠️ **Las plantillas JSP y los controladores Groovy de Sites no los ve ninguna de
estas herramientas**: no están en ninguna WAR, y WebLogic los compila al pedir la
página. Para eso, `modulo2-java17/5-sites/detectar.sh`, un grep sobre la carpeta de
elementos o sobre una exportación de CSDT.

```bash
# APIs internas del JDK, con el sustituto propuesto.
# jdeps no lee WARs: desempaquetad y pasadle WEB-INF/classes.
jdeps --jdk-internals --multi-release 17 --ignore-missing-deps -cp 'WEB-INF/lib/*' WEB-INF/classes

# APIs deprecadas o eliminadas en Java 17:
jdeprscan --release 17 --class-path 'WEB-INF/lib/*' WEB-INF/classes

# Clases que WebLogic 14.1.2 ya no trae (viene con WebLogic):
java -jar $WL_HOME/server/lib/weblogic.migration-analysis-tool.jar mi-aplicacion.war clases.jar

# La prueba de fuego:
mvn -Dmaven.compiler.release=17 clean package
```

Tres cosas que hemos comprobado y que no dice ninguna documentación:

1. **`release 17`, nunca `source/target`.** Con `source/target 1.8` sobre JDK 17,
   `sun.net.www…` y `sun.security.x509` **compilan** con un simple aviso, y
   revientan en ejecución con `IllegalAccessError`. Con `release 17` el compilador
   dice *«package … is not visible»*.
2. **La Migration Analysis Tool, sobre una WAR, solo mira los jars de
   `WEB-INF/lib`**, no `WEB-INF/classes`, que es donde está vuestro código. Hay que
   meter `WEB-INF/classes` en un jar (`clases.jar` arriba) y pasárselo también.
3. **OpenRewrite se lanza sobre el JDK viejo (8).** Sobre JDK 17 no reconoce lo que
   ya no existe (`BASE64Encoder`, `javax.xml.bind`) y solo toca el pom. Y aun así
   pone `source/target` en vez de `release`, y mete JAXB dentro de la WAR en lugar
   de `provided`: revisad su parche.
