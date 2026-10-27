#!/usr/bin/env bash
# La receta javax -> jakarta, SOLO PARA VERLA. NO SE APLICA en WebLogic 14.1.2,
# que es javax. Es lo que habra que hacer al pasar a WebLogic 15.1.1.
# Propone el parche sobre una COPIA de ../2-aplicacion-java17.
set -euo pipefail
AQUI="$(cd "$(dirname "$0")" && pwd)"; RAIZ="$AQUI/.."
rm -rf "$AQUI/copia-jakarta"; cp -R "$RAIZ/2-aplicacion-java17" "$AQUI/copia-jakarta"; rm -rf "$AQUI/copia-jakarta/target"
cd "$AQUI/copia-jakarta"
JAVA_HOME="$RAIZ/.jdks/jdk17/Contents/Home" mvn -B -q -Dmaven.repo.local="$RAIZ/.m2" \
  org.openrewrite.maven:rewrite-maven-plugin:6.46.1:dryRunNoFork \
  -Drewrite.recipeArtifactCoordinates=org.openrewrite.recipe:rewrite-migrate-java:3.42.1 \
  -Drewrite.activeRecipes=org.openrewrite.java.migrate.jakarta.JavaxMigrationToJakarta
echo; echo "Parche propuesto (NO aplicar en 14.1.2): $AQUI/copia-jakarta/target/rewrite/rewrite.patch"; echo
cat target/rewrite/rewrite.patch
