#!/usr/bin/env bash
# Arranque para Java 17. Uso: ./arrancar.sh <JAVA_HOME>
set -euo pipefail
JAVA_HOME="${1:?Uso: $0 <JAVA_HOME>}"
cd "$(dirname "$0")"

# Fuera MaxPermSize, PermSize y todo lo de CMS: en Java 17 cualquiera de ellas
# impide que la JVM arranque. El recolector por defecto (G1) sirve.
JAVA_OPTIONS="-Xms256m -Xmx512m"

# PARCHE DE EMERGENCIA, no solucion: abre java.util a la reflexion para el caso
# AccesoProfundo. Lo correcto es actualizar la libreria que hace eso. Quitad
# esta linea y vereis la InaccessibleObjectException.
JAVA_OPTIONS="$JAVA_OPTIONS --add-opens java.base/java.util=ALL-UNNAMED"

exec "$JAVA_HOME/bin/java" $JAVA_OPTIONS -cp "target/classes:target/lib/*" es.curso.sites.Demo
