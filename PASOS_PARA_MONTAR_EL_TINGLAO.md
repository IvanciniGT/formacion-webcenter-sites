1. Pedir repositorio en GITLAB.
   - Seguro os crean rama desarrollo (o dev o desa ...)
   - Os crean una rama main (antiguamente master)

    OS DAN UNA URL

    OPCIONALMENTE:
        Vamos a generar un archivo de despliegue de weblogic en:
        target/extend.sites.webapp-lib

        Se genera vía: ./mvnw.cmd clean package
        o:             ./mvnw     clean package

        Necesitamos que esto se despliegue en el weblogic de desarrollo.
        Y eso cada vez que hagamos push con un tag

2. Clonar el repo: El comando lo ejecutar en una terminal, en la carpeta QUE TE INTERESE.
   
    git clone <URL_DEL_REPO>

3. Abrir carpeta con VSCODE o intellij IDEA.

4. Copiar dentro de la carpeta clonada la estructura del proyecto `extend-war`.
   
   CARPETA_CLONADA_COMO_SE_LLAME/
    .mvn
    mvnw.cmd
    pom.xml
    src
        main
            webapp
                META-INF
                WEB-INF
                    web.xml
                    weblogic.xml
                tinymce
                cdkeditor
                *.jsp

    Cambiar el nombre de:
        src/main/webapp/WEB-INF/web.xml         -> src/main/webapp/WEB-INF/web-version12.xml
        src/main/webapp/WEB-INF/weblogic.xml    -> src/main/webapp/WEB-INF/weblogic-version12.xml
            WEB-INF/

   Copiar los archivos :
    WEB-INF/web.xml
    WEB-INF/weblogic.xml
   del archivo extend.sites.webapp-lib-14.1.2-oracle.war original de la nueva version de sites (en mi carpeta originalos puse el mio)
   a la carpeta src/main/webapp/WEB-INF

5. CADA VEZ QUE QUIERA TRABAJAR EN EL PROYECTO:
      1. Ya trabajo!    
         - Cambio los archivos de tinyMCE si es necesario.
         - Cambio los jsp si es necesario.
         - Copio cosas de los archivos web-version12.xml y weblogic-version12.xml si es necesario a los nuevos web.xml y weblogic.xml.

      2. ./mvnw.cmd clean package

      Y Esto en bucle...

6. Cuando haya acabado, y esté listo para pruebas:

    git add :/ && git commit -m 'Descripcion de lo que he cambiado'
    git push

AHORA?
   - OPCION A: Deberían haber montado lo que llamamos un pipeline de CI asociado a gitlab.
     Ese programa debe copiar vuestro archivo target/extend.sites.webapp-lib-14.1.2-oracle.war en el weblogic.
     Si lo han montado:

        git tag v1.0.0 # Poniendo aqui numeros incrementales
        git push --tags

   - OPCION B (CUTRE pero efectiva):
     Copiais el archivo target/extend.sites.webapp-lib-14.1.2-oracle.war directamente en el weblogic de desarrollo.


---

Qué puede pasar?

Puede pasar que ese war tenga pequeñas variaciones para distintos entornos.
- EN ESTE CASO ES MUCHO MAS IMPORTANTE tener git y maven.

Eso lo resuelve solito maven al generar el war con las configuraciones correctas para cada entorno.

Pongamos que tenemos un xml que varía entre entornos:

```xml
<config>
    <web-service>
        <url>??? LO QUE VA AQUI DEPENDE DEL ENTORNO ??? </url>
    </web-service>
</config>
```

En maven existe la posibilidad de definir perfiles : PROFILES de compilación.

Lo que hacemos es en los xml, escribimos:

```xml
<config>
    <web-service>
        <url>${web.service1.url}</url>
    </web-service>
</config>
```

Y luego definimos los perfiles en el archivo `pom.xml` de maven, por ejemplo:

```xml
<profiles>
    <profile>
        <id>development</id>
        <properties>
            <web.service1.url>http://development.example.com</web.service.url>
            <web.service2.url>http://development.example.com</web.service.url>
            <web.service3.url>http://development.example.com</web.service.url>
        </properties>
    </profile>
    <profile>
        <id>production</id>
        <properties>
            <web.service1.url>http://production.example.com</web.service.url>
            <web.service2.url>http://production.example.com</web.service.url>
            <web.service3.url>http://production.example.com</web.service.url>
        </properties>
    </profile>
</profiles>
```

De esta manera, al compilar con maven usando un perfil específico:

```
./mvnw.cmd clean package -Pdevelopment
```

Se reemplazará `${web.service.url}` con el valor correspondiente al entorno de desarrollo.

ESTO MAS ADELANTE! Lo deben hacer ellos... en los pipelines de CI/CD

Cuando hago el commit en desarrollo, el pipeline de CI/CD debería compilar el proyecto usando el perfil de desarrollo, asegurándose de que los archivos generados tengan las configuraciones correctas para ese entorno.
```
./mvnw.cmd clean package -Pdevelopment
```

Cuando el commit se sube a rama RELEASE, el pipeline de CI/CD debería compilar el proyecto usando el perfil de producción, asegurándose de que los archivos generados tengan las configuraciones correctas para ese entorno.
```
./mvnw.cmd clean package -Ppreproduction
```

Cuando suba a main:
```
./mvnw.cmd clean package -Pproduction
```
