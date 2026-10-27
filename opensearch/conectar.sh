#!/usr/bin/env bash
# Abre los dos tuneles al OpenSearch del curso y los deja abiertos hasta Ctrl-C.
# OpenSearch y Dashboards no tienen URL publica: viven dentro del cluster, en el
# espacio de nombres webcenter. Un port-forward solo lee; no cambia nada alli.
#
# Uso: ./conectar.sh              OpenSearch en 9200 y Dashboards en 5601
#      ./conectar.sh 19200 15601  si esos puertos ya estan ocupados en el Mac
set -uo pipefail
PUERTO_OS="${1:-9200}"
PUERTO_DASH="${2:-5601}"

kubectl -n webcenter port-forward svc/opensearch "$PUERTO_OS:9200" >/dev/null &
TUNEL_OS=$!
kubectl -n webcenter port-forward svc/opensearch-dashboards "$PUERTO_DASH:5601" >/dev/null &
TUNEL_DASH=$!
trap 'kill $TUNEL_OS $TUNEL_DASH 2>/dev/null' EXIT

for _ in $(seq 1 20); do
  curl -s -o /dev/null "http://localhost:$PUERTO_OS" && break
  sleep 0.5
done
if ! curl -s -o /dev/null "http://localhost:$PUERTO_OS"; then
  echo "OpenSearch no contesta en localhost:$PUERTO_OS. ¿kubectl apunta al cluster? ¿Puerto ocupado?"
  exit 1
fi

echo "OpenSearch:  http://localhost:$PUERTO_OS"
echo "Dashboards:  http://localhost:$PUERTO_DASH"
[ "$PUERTO_OS" = 9200 ] || echo "En otra terminal:  export OPENSEARCH=http://localhost:$PUERTO_OS"
echo "Ctrl-C para cerrar los tuneles."
wait
