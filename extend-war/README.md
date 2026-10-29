# La extend WAR, construida con Maven

**Cómo se hace: [PASO-A-PASO.md](PASO-A-PASO.md).**

## Qué es la extend WAR

`extend.sites.webapp-lib.war` es el sitio que Oracle reserva para vuestras personalizaciones.
- Lo que va dentro se sirve bajo `/sites` como si estuviera en la WAR del producto, y gana sobre ella.
- De serie viene vacía. Así que lo que tenéis dentro es vuestro.

Oracle la construye también con Maven. Este proyecto hace lo mismo.

## Qué hay en la carpeta

```
extend-war\
├── pom.xml            la receta de Maven: solo hay que tocar dos números
├── mvnw.cmd, mvnw     el Maven Wrapper: descarga Maven solo, no hay que instalarlo
├── .mvn\              su configuración (la versión de Maven): no borrar
├── comparar.ps1       compara dos WAR (Windows)
├── comparar.sh        lo mismo, para Linux
├── original\          la extend WAR de Oracle 14.1.2, vacía
└── src\main\
    ├── webapp\        ← AQUÍ VA VUESTRA WAR DESCOMPRIMIDA
    ├── webapp\cursomig\   ejemplo del curso: se borra
    └── sellado\           ejemplo del curso: se borra
```

## El ejemplo del curso

`cursomig/extend-prueba.jsp` sirve para comprobar que Sites carga la WAR construida con Maven. Después de desplegarla y reiniciar Sites, abrid:

```
https://<servidor>/sites/cursomig/extend-prueba.jsp
```

Tiene que salir la hora de la build, en UTC.
