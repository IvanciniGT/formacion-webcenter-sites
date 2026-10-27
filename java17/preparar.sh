#!/usr/bin/env bash
# Deja el modulo 2 listo para la clase: JDK 8 y 17 portables y todas las
# dependencias de Maven ya descargadas, para no depender de la red en directo.
# Se puede lanzar las veces que haga falta.
#
# Los JDK van en .jdks/ y el repositorio de Maven en .m2/, DENTRO de esta
# carpeta: no se instala nada en el sistema ni se toca ~/.m2.
set -euo pipefail
AQUI="$(cd "$(dirname "$0")" && pwd)"; cd "$AQUI"

for V in 8 17; do
  if [ ! -x ".jdks/jdk$V/Contents/Home/bin/java" ]; then
    echo "Bajando Temurin $V (macOS x64)..."
    mkdir -p ".jdks/jdk$V"
    curl -sSL "https://api.adoptium.net/v3/binary/latest/$V/ga/mac/x64/jdk/hotspot/normal/eclipse" \
      | tar -xz -C ".jdks/jdk$V" --strip-components=1
  fi
  echo "JDK $V: $(".jdks/jdk$V/Contents/Home/bin/java" -version 2>&1 | head -1)"
done

[ -f herramientas/weblogic.migration-analysis-tool.jar ] || {
  echo "FALTA herramientas/weblogic.migration-analysis-tool.jar."
  echo "Viene con WebLogic 14.1.2: \$WL_HOME/server/lib/weblogic.migration-analysis-tool.jar"
  exit 1
}

J8="$AQUI/.jdks/jdk8/Contents/Home"; J17="$AQUI/.jdks/jdk17/Contents/Home"
MVN="mvn -B -q -Dmaven.repo.local=$AQUI/.m2"

echo "Compilando y calentando la cache de Maven..."
(cd 1-aplicacion-java8  && JAVA_HOME=$J17 $MVN -Dlombok.version=1.18.48 dependency:resolve dependency:resolve-plugins >/dev/null)
(cd 1-aplicacion-java8  && JAVA_HOME=$J8  $MVN clean package)
(cd 2-aplicacion-java17 && JAVA_HOME=$J17 $MVN clean package)
(cd 3-trampa-jakarta    && JAVA_HOME=$J17 $MVN clean package)
(cd 3-trampa-jakarta    && JAVA_HOME=$J17 $MVN -Dspring.version=6.2.19 dependency:copy-dependencies -DoutputDirectory=target/libs-spring6 >/dev/null)
(cd 4-openrewrite && ./openrewrite-java17.sh >/dev/null && ./openrewrite-jakarta.sh >/dev/null)

echo "Listo. Guion de la clase: README.md"
