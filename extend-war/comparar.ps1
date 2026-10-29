# Compara dos WAR fichero a fichero: la que esta desplegada y la que sale de
# mvn package. Si solo difiere el MANIFEST (y META-INF/maven), el proyecto
# reproduce lo que hay en el servidor y se puede hacer el commit cero.
#
#   .\comparar.ps1 <war-desplegada> [war-construida]
#
# Se comparan descomprimidas porque dos WAR con el mismo contenido nunca son
# iguales byte a byte: llevan fechas dentro. Y por huella (SHA-256), no por
# texto: asi un fichero que solo cambia de LF a CRLF tambien sale, que es justo
# lo que pasa si git convierte los finales de linea en Windows.
#
# Descomprime con tar y no con Expand-Archive: Expand-Archive no abre ficheros
# que no acaben en .zip. tar viene con Windows 10 y posteriores.
param(
    [Parameter(Mandatory = $true)][string]$Desplegada,
    [string]$Construida = "target\extend.sites.webapp-lib.war"
)
$ErrorActionPreference = "Stop"

function Get-Huellas([string]$carpeta) {
    $huellas = @{}
    Get-ChildItem -LiteralPath $carpeta -Recurse -File | ForEach-Object {
        $ruta = $_.FullName.Substring($carpeta.Length + 1).Replace('\', '/')
        $huellas[$ruta] = (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash
    }
    return $huellas
}

$trabajo = Join-Path $env:TEMP ("comparar-war-" + [guid]::NewGuid())
try {
    $dirDesplegada = Join-Path $trabajo "desplegada"
    $dirConstruida = Join-Path $trabajo "construida"
    New-Item -ItemType Directory -Path $dirDesplegada, $dirConstruida | Out-Null
    tar -xf (Resolve-Path $Desplegada) -C $dirDesplegada
    tar -xf (Resolve-Path $Construida) -C $dirConstruida

    $a = Get-Huellas $dirDesplegada
    $b = Get-Huellas $dirConstruida

    $rutas = @($a.Keys) + @($b.Keys) | Sort-Object -Unique
    $diferencias = 0
    foreach ($ruta in $rutas) {
        if (-not $b.ContainsKey($ruta))      { "solo en la DESPLEGADA   $ruta"; $diferencias++ }
        elseif (-not $a.ContainsKey($ruta))  { "solo en la CONSTRUIDA   $ruta"; $diferencias++ }
        elseif ($a[$ruta] -ne $b[$ruta])     { "DISTINTO                $ruta"; $diferencias++ }
    }
    if ($diferencias -eq 0) { "Iguales." }
}
finally {
    Remove-Item -LiteralPath $trabajo -Recurse -Force -ErrorAction SilentlyContinue
}
