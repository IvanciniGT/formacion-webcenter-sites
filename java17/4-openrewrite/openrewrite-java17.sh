#!/usr/bin/env bash
# OpenRewrite: receta UpgradeToJava17 sobre una COPIA de ../1-aplicacion-java8.
#   ./openrewrite-java17.sh           solo propone: deja el parche en copia/target/rewrite/rewrite.patch
#   ./openrewrite-java17.sh aplicar   lo aplica en la copia y compila con JDK 17 (release 17)
#                                     para ver lo que OpenRewrite NO arreglo
#
# SE EJECUTA SOBRE JDK 8, a proposito: OpenRewrite entiende el codigo con el
# JDK con el que corre. Sobre JDK 17 no encuentra sun.misc.BASE64Encoder ni
# javax.xml.bind, y solo toca el pom. Comprobado: en JDK 17 cambia 1 fichero,
# en JDK 8 cambia 2 y anade las dependencias de JAXB.
set -euo pipefail
AQUI="$(cd "$(dirname "$0")" && pwd)"; RAIZ="$AQUI/.."
PLUGIN=org.openrewrite.maven:rewrite-maven-plugin:6.46.1
RECETAS=org.openrewrite.recipe:rewrite-migrate-java:3.42.1
MVN="mvn -B -q -Dmaven.repo.local=$RAIZ/.m2"

rm -rf "$AQUI/copia"; cp -R "$RAIZ/1-aplicacion-java8" "$AQUI/copia"; rm -rf "$AQUI/copia/target"
cd "$AQUI/copia"

if [ "${1:-}" != "aplicar" ]; then
  JAVA_HOME="$RAIZ/.jdks/jdk8/Contents/Home" $MVN $PLUGIN:dryRun \
    -Drewrite.recipeArtifactCoordinates=$RECETAS -Drewrite.activeRecipes=org.openrewrite.java.migrate.UpgradeToJava17
  echo; echo "Parche propuesto: $AQUI/copia/target/rewrite/rewrite.patch"; echo
  cat target/rewrite/rewrite.patch
  exit 0
fi

JAVA_HOME="$RAIZ/.jdks/jdk8/Contents/Home" $MVN $PLUGIN:run \
  -Drewrite.recipeArtifactCoordinates=$RECETAS -Drewrite.activeRecipes=org.openrewrite.java.migrate.UpgradeToJava17
echo "Aplicado en $AQUI/copia. Ahora, compilando con JDK 17 y release 17:"; echo
JAVA_HOME="$RAIZ/.jdks/jdk17/Contents/Home" mvn -B -Dmaven.repo.local="$RAIZ/.m2" -Dmaven.compiler.release=17 clean package 2>&1 \
  | grep -E '^\[ERROR\] /|BUILD' | sed 's|.*/src/main/java/||' | sort -u
