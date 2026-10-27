#!/usr/bin/env bash
# Arranque «de la epoca», como los setDomainEnv.sh de WebLogic 12.2.1.4.
# Las opciones de memoria son las que se copiaban de proyecto en proyecto.
# Uso: ./arrancar.sh <JAVA_HOME>
set -euo pipefail
JAVA_HOME="${1:?Uso: $0 <JAVA_HOME>}"
cd "$(dirname "$0")"

JAVA_OPTIONS="-Xms256m -Xmx512m " #-XX:MaxPermSize=256m -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled

exec "$JAVA_HOME/bin/java" $JAVA_OPTIONS -cp "target/classes:target/lib/*" es.curso.sites.Demo


Nashborn - Permitía ejecutar código JavaScript dentro de la JV en el servidor (Weblogic)