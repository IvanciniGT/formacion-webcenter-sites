#!/usr/bin/env bash
# Busca en las plantillas JSP y los controladores Groovy de Sites lo que rompe en
# Java 17. Ni jdeps, ni la herramienta de Oracle, ni OpenRewrite los ven: no estan
# en ninguna WAR, viven en la carpeta de elementos de Sites y los compila WebLogic
# al pedir la pagina.
#
# Uso:  ./detectar.sh                 la carpeta de elementos del Sites del curso
#       ./detectar.sh <carpeta>       una exportacion de CSDT, o una copia local
#
# Es un grep: encuentra candidatos, no confirma fallos. Los SI de
# CursoMig/QueHayEnElServidor dicen que hay en el servidor.
set -euo pipefail

PATRONES='sun\.(misc|net|security|reflect|nio\.ch)\.|com\.sun\.(org\.apache|jersey|xml\.internal|image)|jdk\.nashorn|getEngineByName\("(nashorn|javascript|js|JavaScript|ECMAScript)"\)|org\.apache\.commons\.lang\.|setAccessible\(true\)'

if [ $# -gt 0 ]; then
  grep -rnE --include='*.jsp' --include='*.groovy' --include='*.jspf' "$PATRONES" "$1" || echo "Nada sospechoso en $1"
  exit 0
fi

ELEMENTOS=/u01/oracle/user_projects/domains/wcsitesinfra/config/fmwconfig/wcsconfig/elements
# El grep va dentro del pod: son mas de 1.400 ficheros y asi no se copian
kubectl -n webcenter exec wcsitesinfra-wcsites-server1 -c weblogic-server -- \
  bash -c "cd $ELEMENTOS && grep -rnE --include='*.jsp' --include='*.groovy' --include='*.jspf' '$PATRONES' . || echo 'Nada sospechoso'"
