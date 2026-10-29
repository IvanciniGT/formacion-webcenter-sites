# La extend WAR con Maven, paso a paso

**Lo que cambia es muy poco.** Hasta ahora, para hacer un cambio:

1. Descomprimíais la WAR.
2. Tocabais los ficheros.
3. Volvíais a empaquetar.

Ahora la WAR **se queda descomprimida para siempre** en una carpeta del proyecto, y el empaquetado lo hace Maven con un comando. Lo demás sigue igual.

---

## Una sola vez: preparar el proyecto

### 1. Comprobar que tenéis Java

**Maven no hace falta instalarlo.** El proyecto trae `mvnw.cmd`, que lo descarga solo la primera vez. Basta con Java.

En PowerShell:

```powershell
java -version
```

La primera vez hace falta Internet: se baja Maven y lo que necesita (unos pocos MB). Después ya no.

### 2. Copiar la carpeta del curso

Copiad `extend-war\` a vuestro puesto, por ejemplo a `C:\proyectos\sites-extend\`. **Copiadla entera**, incluida la carpeta `.mvn`: sin ella `mvnw.cmd` no funciona.

### 3. Traer vuestra WAR del servidor

La de siempre: `extend.sites.webapp-lib.war`, la que está en uso, no una copia con fecha. Dejadla en `C:\proyectos\sites-extend\`.

### 4. Copiar dos números al `pom.xml`

1. Abrid la WAR con 7-Zip y mirad el fichero `META-INF\MANIFEST.MF`.
2. Buscad estas dos líneas, por ejemplo:

   ```
   Specification-Version: 1.0
   Implementation-Version: 12.2.1.4
   ```

3. Poned esos mismos valores en el `pom.xml`:

   ```xml
   <sites.especificacion>1.0</sites.especificacion>
   <sites.implementation>12.2.1.4</sites.implementation>
   ```

**Tienen que ser exactamente los mismos.** Sites busca la librería por esos números.

### 5. Quitar lo de ejemplo del curso

1. Borrad las carpetas `src\main\webapp\cursomig` y `src\main\sellado`.
2. En el `pom.xml`, borrad el bloque `<webResources>` … `</webResources>`.

### 6. Descomprimir vuestra WAR dentro del proyecto

1. Descomprimid vuestra WAR dentro de `src\main\webapp\`, con 7-Zip o con:

   ```powershell
   tar -xf extend.sites.webapp-lib.war -C src\main\webapp
   ```

2. Borrad la carpeta `src\main\webapp\META-INF`. Maven la crea solo.

### 7. Probar que sale lo mismo

```powershell
.\mvnw.cmd package
.\comparar.ps1 extend.sites.webapp-lib.war
```

**Qué tiene que salir:**
- La WAR nueva queda en `target\extend.sites.webapp-lib.war`.
- El script solo debe mostrar diferencias en `META-INF\...`.

**Si sale algo más,** es que un fichero no se ha copiado bien.

**Si PowerShell no deja ejecutar el script**, lanzad antes:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
```

---

## A partir de ahora, cada cambio

1. Editar los ficheros en `src\main\webapp\`.
2. En PowerShell, en la carpeta del proyecto:

   ```powershell
   .\mvnw.cmd package
   ```

3. Subir `target\extend.sites.webapp-lib.war` al servidor como hasta ahora, y reiniciar Sites.

Ya está. Nada de descomprimir ni empaquetar a mano.

---

## Y para la 14.1.2

Basta con cambiar un número en el `pom.xml`:

```xml
<sites.implementation>14.1.2</sites.implementation>
```

Después, `.\mvnw.cmd package` y subir la WAR al servidor nuevo.
