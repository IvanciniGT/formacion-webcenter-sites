#!/usr/bin/env bash
# Analiza una WAR antes de migrarla a Java 17 / WebLogic 14.1.2.
# Uso: herramientas/analizar.sh <fichero.war>
#
# Tres miradas distintas, y cada una ve cosas que las otras no:
#   1. jdeps --jdk-internals  usos de APIs INTERNAS del JDK (sun.*, com.sun.*),
#                             con el sustituto que propone el propio JDK
#   2. jdeprscan              APIs DEPRECADAS o ELIMINADAS en Java 17
#   3. Migration Analysis Tool de Oracle (viene con WebLogic 14.1.2): APIs de
#                             WEBLOGIC eliminadas en la 14.1.2
#
# Ninguna ve las dependencias que FALTAN (JAXB, javax.annotation...): eso solo
# sale compilando con release 17.
set -uo pipefail
WAR="$(cd "$(dirname "${1:?Uso: $0 <fichero.war>}")" && pwd)/$(basename "$1")"
AQUI="$(cd "$(dirname "$0")" && pwd)"
JAVA17="$AQUI/../.jdks/jdk17/Contents/Home/bin"
[ -x "$JAVA17/jdeps" ] || { echo "Falta el JDK 17 en .jdks: ejecuta ./preparar.sh"; exit 1; }

# jdeps y jdeprscan no saben leer una WAR: se desempaqueta en un temporal.
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
unzip -q "$WAR" -d "$TMP"
CP="$TMP/WEB-INF/classes"
[ -d "$TMP/WEB-INF/lib" ] && [ -n "$(ls -A "$TMP/WEB-INF/lib")" ] && CP="$CP:$TMP/WEB-INF/lib/*"

echo "════════ 1. jdeps --jdk-internals (APIs internas del JDK)"
"$JAVA17/jdeps" --jdk-internals --multi-release 17 --ignore-missing-deps -cp "$CP" "$TMP/WEB-INF/classes"

echo
echo "════════ 2. jdeprscan --release 17 (deprecado o eliminado en Java 17)"
"$JAVA17/jdeprscan" --release 17 --class-path "$CP" "$TMP/WEB-INF/classes"

echo
echo "════════ 3. Migration Analysis Tool de WebLogic 14.1.2"
# OJO: con una WAR, la herramienta solo mira los JARS de WEB-INF/lib, NO las
# clases de WEB-INF/classes, que es donde esta vuestro codigo. Comprobado:
# sobre la WAR no dice nada, y con las mismas clases en un jar avisa de
# org.apache.commons.lang.StringUtils. Por eso se le pasa tambien un jar con
# WEB-INF/classes.
"$JAVA17/jar" cf "$TMP/WEB-INF-classes.jar" -C "$TMP/WEB-INF/classes" .
SALIDA="$("$JAVA17/java" -jar "$AQUI/weblogic.migration-analysis-tool.jar" "$WAR" "$TMP/WEB-INF-classes.jar")"
if [ -z "$SALIDA" ]; then
  echo "(nada: no usa clases que WebLogic 14.1.2 haya dejado de traer)"
else
  printf '%s\n' "$SALIDA" | sed "s|$TMP/||"
fi
