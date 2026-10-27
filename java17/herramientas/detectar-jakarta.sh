#!/usr/bin/env bash
# ¿Alguna libreria de esta WAR tira de jakarta.*? WebLogic 14.1.2 es javax: una
# libreria que use jakarta.servlet, jakarta.ws.rs... se ha subido de mas.
# Uso: herramientas/detectar-jakarta.sh <fichero.war | carpeta con jars>
#
# Mira las REFERENCIAS de cada jar, no solo sus clases: spring-web 6 no contiene
# ninguna clase jakarta.*, pero las usa todas.
set -uo pipefail
ORIGEN="${1:?Uso: $0 <fichero.war | carpeta con jars>}"
AQUI="$(cd "$(dirname "$0")" && pwd)"
JDEPS="$AQUI/../.jdks/jdk17/Contents/Home/bin/jdeps"
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT

if [ -d "$ORIGEN" ]; then LIBS="$ORIGEN"; else unzip -q "$ORIGEN" -d "$TMP"; LIBS="$TMP/WEB-INF/lib"; fi

ENCONTRADAS=0
for JAR in "$LIBS"/*.jar; do
  [ -e "$JAR" ] || continue
  PAQUETES="$("$JDEPS" -verbose:package --ignore-missing-deps --multi-release 17 "$JAR" 2>/dev/null \
              | grep -o -E -- '-> jakarta\.[a-z.]+' | sed 's/-> //' | sort -u | tr '\n' ' ')"
  if [ -n "$PAQUETES" ]; then
    echo "JAKARTA  $(basename "$JAR"): $PAQUETES"
    ENCONTRADAS=$((ENCONTRADAS + 1))
  fi
done
if [ "$ENCONTRADAS" -eq 0 ]; then
  echo "Ninguna libreria usa jakarta.*: compatible con WebLogic 14.1.2 (javax)."
else
  echo
  echo "$ENCONTRADAS libreria(s) con jakarta.*. En WebLogic 14.1.2 hay que bajarlas a su ultima version javax."
  exit 1
fi
