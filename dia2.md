# Problemas típicos en la migración. PARTE JAVA.

Vienen principalmente por:
- APIs que se han eliminado u ocultado en Java 17 que usamos en nuestro código JAVA.
- Lo mismo ocurre con librerías de terceros que dependen de esas APIs eliminadas u ocultas.
- Hay librerías que venían en Weblogic 12 y que la 14 no tiene... y si las usamos no va a funcionar:
  - commons-lang. Lo peor es que en local nos compilará. En weblogic no ejecutará.
- Opciones de la JVM en el arranque.
---

## ¿Dónde encontramos esto?

Todo lo que use JAVA:
- JSP Plantillas de los contenidos
   En los JSPs metemos JAVA
   Además, los JSPs pueden llamar a clases JAVA (que cargamos vía .jar) 

- Controladores: Están groovy, pero desde groovy podemos llamar a clases JAVA (que cargamos vía .jar)

- Código de más bajo nievl integrado: Tratamiento de evento al que queremos reaccionar.

En los ejemplos que he puesto, muchas cosas están dentro de un WAR, para poder probar fuera de Sites.
No significa que lo que hagamos normalmente con sites sea subir WARs.

Si tenemos WARs en paralelo con Sites, para integración con servicios propios o cosas así, el problema es doble!
- Por un lado la migración de sites.
- Por otro lado la migración de esos servicios, al weblogic nuevo (JAVA 17)
  

# Herramientas para ayudarnos en el proceso de migración:

- Compilar a lo bruto.. es lo que hicimos lo primero.
- - jdeps --jdk-internals <ruta_al_jar_o_clase>
   Lista las dependencias internas de la JDK que usa el jar o clase especificada. (ofrece en algunoscasos alternativas)
- - jdeprscan <ruta_al_jar_o_clase> --release 17
   Escanea el jar o clase especificada en busca de APIs obsoletas y ofrece alternativas si las hay.
- - Migration Analysis Tool de WebLogic 14.1.2
   Ayuda a identificar problemas de compatibilidad y ofrece recomendaciones para la migración a la nueva versión de WebLogic .
   Básicamente Jars que antes ponía Weblogic y que ahora debemos incluir nosotros o reemplazar por alternativas compatibles con Java 17.

   A éste le pasamos un WAR (ni clase ni jar)
    - Desempaqueta el WAR para analizar su contenido 
    - Detecta dependencias contra APIs que Weblogic ya no proporciona pero solo en JARs dentro del WAR.
      - PROBLEMA. Si tenemos java compilado en WEB-INF/classes, no lo detectará, solo analiza los JARs dentro del WAR.
                                                       ^^^^^^^
                                                       Ahi es donde solemos tener el código


---
Maven es una herramienta para automatizar trabajos en el dia a dia de desarrollo.
- Compilar
- Ejecutar pruebas
- Empaquetar aplicaciones (WAR, JAR)
- Gestionar dependencias de manera automática
- Genera documentación (JAVADOC)
- Genera informes de cobertura de código
- Manda el código a un SonarQube para análisis de calidad y detección de problemas potenciales.

Maven hace mucho y nada. No abe hacer nada. Todo lo encarga a plugins.
Aunque no tenga explícitamente configurados plugins, maven de serie mete 8-10:
- maven-compiler-plugin: para compilar el código fuente.
- maven-surefire-plugin: para ejecutar pruebas unitarias.
- maven-war-plugin: para empaquetar aplicaciones web en formato WAR.
- maven-install-plugin: para instalar artefactos en el repositorio local.
- maven-deploy-plugin: para desplegar artefactos en un repositorio remoto.
- maven-dependency-plugin: para gestionar dependencias de manera más avanzada, como copiar dependencias a un directorio específico.

Esos plugins evolucionan con el tiempo.

- Plugin de compilacion siempre llama por debajo: a javac
  En versiones antiguas , que no existían los MODULOS en JAVA, había ciertos argms de javac.exe que no existían y el plugin no los pasaba.
  En versiones nuevas, creadas acordes a la evolución de Java, el plugin ya maneja correctamente los argumentos de javac relacionados con los módulos y otras características modernas del lenguaje.

Cada plugin tiene trabajos o "goals" específicos que realiza.

- El plugin de compilación tiene un goal compile, que se encarga de compilar el código fuente del proyecto.
- También tiene un goal test-compile, que compila el código fuente de las pruebas unitarias.
- El plugin sonar tiene un goal sonar, que se encarga de enviar el código a un servidor SonarQube para análisis de calidad y detección de problemas potenciales.

Cuando llamo a maven puedo pedirle que ejecute un goal. ESTO NO LO HACEMOS NORMALMENTE:

$ mvn sonar:sonar


Lo normal es usar otro concepto que tiene maven: Ciclo de vida (Lifecycle).

Maven define ETAPAS O FASES que forman parte de un ciclo de vida.

 CLEAN -> COMPILE -> TEST-COMPILE -> TEST -> PACKAGE -> VERIFY -> REPORT -> INSTALL -> DEPLOY
Y en cada fase se dispara la ejecución de goals de ciertos plugins.
Viene ya una configuracion por defecto en maven, que yo puedo alterar:
- FASE COMPILE : se ejecuta el goal compile del plugin de compilación, que compila el código fuente del proyecto. POR DEFECTO!
- FASE TEST-COMPILE : se ejecuta el goal test-compile del plugin de compilación, que compila el código fuente de las pruebas unitarias. POR DEFECTO!
- FASE TEST : se ejecuta el goal test del plugin surefire, que ejecuta las pruebas unitarias del proyecto. POR DEFECTO!
- FASE PACKAGE : se ejecuta el goal package del plugin de compilación, que empaqueta el proyecto en un formato distribuible, como JAR o WAR. POR DEFECTO!

Pero yo puedo pedir que en test además de el goal test del plugin surefire, se ejecuten otros goals de otros plugins, como por ejemplo sonar:sonar.
Estas cosas las vamos definiendo en el pom.xml del proyecto, donde podemos configurar qué goals se ejecutan en cada fase del ciclo de vida y cómo se comportan los plugins.

---

# Remote console                 /console
    Consola de weblogic... aqui no hay funcionalidades de Fussion Middleware (Sites)
    Administración pura del weblogic

    Deployments> New deployment

# Enterprise manager             /em
  Más pensada para sites. Ve el weblogic
  - Suelta logs de Sites, con filtros.
  - Seguridad de las apps.
  Cosas que tengan que ver con Sites

    En el Domain > Deployments > Deploy

