#!/usr/bin/env bash
# Compara dos WAR fichero a fichero: la que esta desplegada y la que sale de
# mvn package. Si solo difiere el MANIFEST (y META-INF/maven), el proyecto
# reproduce lo que hay en el servidor y se puede hacer el commit cero.
#
#   ./comparar.sh <war-desplegada> [war-construida]
#
# Se comparan descomprimidas porque dos WAR con el mismo contenido nunca son
# iguales byte a byte: llevan fechas dentro.
set -euo pipefail

desplegada=${1:?uso: $0 <war-desplegada> [war-construida]}
construida=${2:-target/extend.sites.webapp-lib.war}

trabajo=$(mktemp -d)
trap 'rm -rf "$trabajo"' EXIT

mkdir "$trabajo/desplegada" "$trabajo/construida"
unzip -q "$desplegada" -d "$trabajo/desplegada"
unzip -q "$construida" -d "$trabajo/construida"

# diff devuelve 1 cuando hay diferencias: es el resultado, no un fallo
diff -r "$trabajo/desplegada" "$trabajo/construida" \
    | sed "s|$trabajo/||g" || true
