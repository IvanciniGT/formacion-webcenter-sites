#!/usr/bin/env bash
# Borra los indices que crea demo.sh. Solo esos, por su nombre: nunca los de
# Sites (wcs_*) ni los internos de OpenSearch.
set -uo pipefail
O="${OPENSEARCH:-http://localhost:9200}"
for indice in curso-articulos curso-como-sites; do
  echo "$indice: $(curl -s -XDELETE "$O/$indice")"
done
echo "Si creaste el index pattern en Dashboards, borralo en Dashboards Management > Index patterns."
