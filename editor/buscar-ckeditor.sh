#!/usr/bin/env bash
# Busca en un proyecto de Sites todo lo que depende de CKEditor: plantillas con
# insite:edit, editores de atributo, configuraciones y CSS. En 14.1.2 la
# libreria CKEditor ya no esta (/sites/ckeditor/ckeditor.js da 404), asi que
# cada linea que salga es algo que hay que pasar a TinyMCE.
#
# Uso:  ./buscar-ckeditor.sh <carpeta>     una exportacion de CSDT, o vuestro repo
#       ./buscar-ckeditor.sh               los elementos del Sites del curso
#
# Es un grep: encuentra candidatos, no confirma fallos. Los editores de atributo
# viven en la base de datos (tabla ATTRTYPES); en una exportacion de CSDT salen
# como ficheros, en el servidor hay que mirarlos en su carpeta de Storage.
set -euo pipefail

PATRONES='editor="(ckeditor|fckeditor)"|<(CKEDITOR|FCKEDITOR)[ >]|CKEDITOR\.|ckeditor/|toolbar_[A-Za-z]+ *= *\[|contentsCss|stylesSet|enterMode'

if [ $# -gt 0 ]; then
  grep -rnEi --include='*.jsp' --include='*.jspf' --include='*.groovy' --include='*.xml' \
       --include='*.js' --include='*.txt' --include='*.html' "$PATRONES" "$1" \
    || echo "Nada de CKEditor en $1"
  exit 0
fi

CONFIG=/u01/oracle/user_projects/domains/wcsitesinfra/config/fmwconfig/wcsconfig
kubectl -n webcenter exec wcsitesinfra-wcsites-server1 -c weblogic-server -- bash -c "
  echo '== Plantillas y elementos (sin los de Oracle: OpenMarket, UI y ckeditor)'
  cd $CONFIG/elements && grep -rnEi --include='*.jsp' --include='*.jspf' \\
      --exclude-dir=OpenMarket --exclude-dir=UI --exclude-dir=ckeditor '$PATRONES' . || echo 'Ninguno'
  echo
  echo '== Editores de atributo'
  cd $CONFIG/Storage/AttrTypes && grep -rlEi '<(CKEDITOR|FCKEDITOR)[ >]' . | while read f; do echo \"\$f: \$(grep -oEi '<(CKEDITOR|FCKEDITOR)[^>]*>' \$f)\"; done
"
