#!/usr/bin/env bash
# La demo de OpenSearch, paso a paso: ensena cada peticion antes de lanzarla y
# espera a Intro. Crea dos indices propios, curso-articulos y curso-como-sites;
# ./limpiar.sh los borra. No toca nada de Sites.
#
# Uso: ./demo.sh             con pausas (en clase)
#      SIN_PAUSA=1 ./demo.sh sin pausas (para comprobar que todo va)
# Antes: ./conectar.sh en otra terminal.
set -uo pipefail
O="${OPENSEARCH:-http://localhost:9200}"
AQUI="$(cd "$(dirname "$0")" && pwd)"
curl -s -o /dev/null "$O" || { echo "OpenSearch no contesta en $O: lanza antes ./conectar.sh"; exit 1; }

paso() {
  echo; echo "════════ $1"
  [ -n "${SIN_PAUSA:-}" ] || read -r -p "(Intro) " _
}
# Imprime la peticion tal como se escribiria a mano, y la lanza
peticion() {
  local metodo="$1" ruta="$2" fichero="${3:-}"
  if [ -n "$fichero" ]; then
    echo "\$ curl -X$metodo '$O$ruta' -H 'Content-Type: application/json' -d @${fichero#"$AQUI"/}"
    curl -s -X"$metodo" "$O$ruta" -H 'Content-Type: application/json' -d @"$fichero"
  else
    echo "\$ curl -X$metodo '$O$ruta'"
    curl -s -X"$metodo" "$O$ruta"
  fi
  echo
}
analizar() {
  local indice="$1" texto="$2"
  echo "\$ curl -XPOST '$O/$indice/_analyze' -d '{\"field\":\"titulo\",\"text\":\"$texto\"}'"
  curl -s -XPOST "$O/$indice/_analyze" -H 'Content-Type: application/json' \
    -d "{\"field\":\"titulo\",\"text\":\"$texto\"}" | grep -o '"token":"[^"]*"' | sed 's/"token"://' | tr '\n' ' '
  echo
}

paso "1. Que hay: version, salud e indices"
peticion GET "/?pretty"
peticion GET "/_cluster/health?pretty"
peticion GET "/_cat/indices?v&s=index"

# Por si la demo se repite: se empieza siempre de cero
curl -s -o /dev/null -XDELETE "$O/curso-articulos"
curl -s -o /dev/null -XDELETE "$O/curso-como-sites"

paso "2. Crear el indice con su mapping (mappings/articulos.json)"
peticion PUT "/curso-articulos?pretty" "$AQUI/mappings/articulos.json"
peticion GET "/curso-articulos/_mapping?pretty"

paso "3. Como trocea el texto el analizador en espanol"
analizar curso-articulos "<p>Los Ciclistas subieron las MONTAÑAS</p>"

paso "4. Cargar los ocho articulos de golpe (_bulk, datos/articulos.ndjson)"
echo "\$ curl -XPOST '$O/curso-articulos/_bulk?refresh=true' -H 'Content-Type: application/x-ndjson' --data-binary @datos/articulos.ndjson"
curl -s -XPOST "$O/curso-articulos/_bulk?refresh=true" -H 'Content-Type: application/x-ndjson' \
  --data-binary @"$AQUI/datos/articulos.ndjson" | grep -o '"errors":[a-z]*'
peticion GET "/_cat/count/curso-articulos?v"
peticion GET "/curso-articulos/_doc/1?pretty"

paso "5. Un documento suelto, y despues cambiarlo"
peticion PUT "/curso-articulos/_doc/9?refresh=true" "$AQUI/datos/uno-suelto.json"
peticion POST "/curso-articulos/_update/9?refresh=true" "$AQUI/datos/actualizar-visitas.json"
peticion GET "/curso-articulos/_doc/9?pretty"

paso "6. Buscar por la URL, como en el navegador"
peticion GET "/curso-articulos/_search?q=titulo:ciclista&_source=titulo&pretty"

for consulta in "$AQUI"/consultas/*.json; do
  paso "7. Consulta $(basename "$consulta" .json)"
  cat "$consulta"
  peticion GET "/curso-articulos/_search?pretty&filter_path=hits.total,hits.hits._source,hits.hits.highlight,aggregations" "$consulta"
done

paso "8. El mismo texto con el analizador que usa Sites (en ingles)"
peticion PUT "/curso-como-sites?pretty" "$AQUI/mappings/articulos-como-sites.json"
curl -s -o /dev/null -XPOST "$O/curso-como-sites/_bulk?refresh=true" -H 'Content-Type: application/x-ndjson' \
  --data-binary @"$AQUI/datos/articulos.ndjson"
analizar curso-articulos  "Los ciclistas subieron las montañas del maratón"
analizar curso-como-sites "Los ciclistas subieron las montañas del maratón"
# Lo que se nota buscando: la tilde (el usuario escribe sin ella) y las palabras
# vacias del espanol, que el analizador en ingles no quita
echo "Buscando «maraton», sin tilde. En espanol, y como lo haria Sites:"
peticion GET "/curso-articulos/_count?q=titulo:maraton"
peticion GET "/curso-como-sites/_count?q=titulo:maraton"
echo "Buscando «de». En espanol, y como lo haria Sites:"
peticion GET "/curso-articulos/_count?q=titulo:de"
peticion GET "/curso-como-sites/_count?q=titulo:de"

paso "Fin. Los indices siguen ahi para Dashboards. Para borrarlos: ./limpiar.sh"
