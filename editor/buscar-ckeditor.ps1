# Lo mismo que buscar-ckeditor.sh, para Windows. Sobre vuestro repo o una
# exportacion de CSDT:
#
#   powershell -ExecutionPolicy Bypass -File buscar-ckeditor.ps1 C:\ruta\al\proyecto
#
# Es un grep: encuentra candidatos, no confirma fallos.
param([Parameter(Mandatory = $true)][string]$Carpeta)

$patrones = 'editor="(ckeditor|fckeditor)"|<(CKEDITOR|FCKEDITOR)[ >]|CKEDITOR\.|ckeditor/|toolbar_[A-Za-z]+ *= *\[|contentsCss|stylesSet|enterMode'

$encontrados = Get-ChildItem -Path $Carpeta -Recurse -File -Include *.jsp, *.jspf, *.groovy, *.xml, *.js, *.txt, *.html |
    Select-String -Pattern $patrones

if ($encontrados) {
    $encontrados | ForEach-Object { "{0}:{1}: {2}" -f $_.Path, $_.LineNumber, $_.Line.Trim() }
} else {
    "Nada de CKEditor en $Carpeta"
}
