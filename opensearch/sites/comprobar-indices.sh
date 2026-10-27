#!/usr/bin/env bash
# Que ha creado Sites en OpenSearch al pulsar Configure en Admin > Search >
# Manage Search Engines. Solo lee, salvo con --verde.
#
# Uso: sites/comprobar-indices.sh           con el prefijo wcs (Instance Name)
#      sites/comprobar-indices.sh otro      si en Sites pusisteis otro Instance Name
#      sites/comprobar-indices.sh wcs --verde   quita las replicas (ESCRIBE)
#
# Sites crea sus indices con una replica (sites/plantilla-de-sites-*.json, sacadas
# de sites-open-search.jar). Con un solo nodo de OpenSearch la replica no tiene
# donde ir: el indice sale AMARILLO. Los datos estan; falta la copia.
set -uo pipefail
O="${OPENSEARCH:-http://localhost:9200}"
PREFIJO="${1:-wcs}"
curl -s -o /dev/null "$O" || { echo "OpenSearch no contesta en $O: lanza antes ./conectar.sh"; exit 1; }

INDICES="$(curl -s "$O/_cat/indices/${PREFIJO}_*?h=index" | sort)"
if [ -z "$INDICES" ]; then
  echo "No hay indices ${PREFIJO}_*: Sites todavia no ha creado nada (o el Instance Name no es «${PREFIJO}»)."
  echo "Todos los indices que hay:"
  curl -s "$O/_cat/indices?v&s=index"
  exit 1
fi

echo "════════ Indices de Sites (${PREFIJO}_*)"
curl -s "$O/_cat/indices/${PREFIJO}_*?v&s=index&h=health,index,pri,rep,docs.count,store.size"

echo; echo "════════ Salud del cluster"
curl -s "$O/_cluster/health?filter_path=status,number_of_nodes,unassigned_shards&pretty"

echo; echo "════════ Shards sin asignar (las replicas, si hay un solo nodo)"
curl -s "$O/_cat/shards/${PREFIJO}_*?v&h=index,shard,prirep,state" | grep -E 'index|UNASSIGNED' | head -20

GLOBAL="${PREFIJO}_global"
if echo "$INDICES" | grep -qx "$GLOBAL"; then
  echo; echo "════════ $GLOBAL: tres documentos de ejemplo"
  curl -s "$O/$GLOBAL/_search?size=3&pretty&filter_path=hits.total,hits.hits._source"
  echo; echo "════════ $GLOBAL: campos del mapping"
  curl -s "$O/$GLOBAL/_mapping" | grep -o '"[A-Za-z_]*":{"type":"[a-z_]*"' | sed 's/:{"type":/ → /; s/"//g' | sort -u
fi

if [ "${2:-}" = "--verde" ]; then
  echo; echo "════════ Quitando las replicas de ${PREFIJO}_* (escribe en OpenSearch)"
  curl -s -XPUT "$O/${PREFIJO}_*/_settings" -H 'Content-Type: application/json' \
    -d '{"index":{"number_of_replicas":0}}'
  echo
  curl -s "$O/_cat/indices/${PREFIJO}_*?v&s=index&h=health,index,rep"
fi
