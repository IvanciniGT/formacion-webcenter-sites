# OpenSearch para WebCenter Sites 14.1.2

Material para enseñar OpenSearch: primero solo, con `curl` y Dashboards, y después
como motor de búsqueda de Sites.

Lo de las partes 1 y 2 está **ejecutado y comprobado** el 27-10-2026 contra el
OpenSearch del curso: 2.19.5, un nodo, seguridad desactivada. La parte 3 **no está
probada de principio a fin**: se apoya en la documentación oficial y en lo que trae
nuestro Sites.

## Qué hay

| Fichero | Qué es |
|---|---|
| `conectar.sh` | Abre los túneles: OpenSearch en `localhost:9200` y Dashboards en `localhost:5601` |
| `demo.sh` | La demo entera, paso a paso: enseña cada `curl` antes de lanzarlo y espera a Intro |
| `limpiar.sh` | Borra los índices de la demo (`curso-articulos`, `curso-como-sites`) y nada más |
| `mappings/articulos.json` | Índice en español: analizador propio que quita el HTML, minúsculas, palabras vacías, raíces y tildes |
| `mappings/articulos-como-sites.json` | Los mismos campos con **el analizador que usa Sites**, en inglés, para comparar |
| `datos/articulos.ndjson` | Ocho artículos estilo Avisports, con HTML en el cuerpo, en formato `_bulk` |
| `datos/uno-suelto.json`, `datos/actualizar-visitas.json` | Alta de un documento y actualización parcial |
| `consultas/01…09-*.json` | Una consulta por fichero: todo, palabras con peso, frase exacta, filtros y fechas, errata, resaltado, agregaciones, orden y paginación, y búsqueda mientras se escribe |
| `sites/comprobar-indices.sh` | Después de integrar con Sites: qué índices creó, su salud, sus documentos y su mapping |
| `sites/plantilla-de-sites-*.json` | Las plantillas de índice que trae Sites dentro de `sites-open-search.jar`, copiadas tal cual de nuestro servidor |

## 1 · Arrancar

```bash
cd ~/Documents/cursos/formacionSites/opensearch
./conectar.sh                 # en una terminal; se queda abierto hasta Ctrl-C
```

En otra terminal:

```bash
./demo.sh                     # en clase, con pausas
SIN_PAUSA=1 ./demo.sh         # para comprobar antes que todo va
./limpiar.sh                  # al acabar
```

Si el 9200 o el 5601 están ocupados: `./conectar.sh 19200 15601`, y en la otra terminal
`export OPENSEARCH=http://localhost:19200`.

Para lanzar una consulta suelta:

```bash
curl -s "localhost:9200/curso-articulos/_search?pretty" -H 'Content-Type: application/json' -d @consultas/05-con-errata.json
```

## 2 · Lo que enseña `demo.sh`

1. Versión, salud e índices. Fijaos en `lucene_version`: OpenSearch es Lucene por
   dentro.
2. Crear el índice con su mapping. `"dynamic": "strict"`: un campo que no esté en el
   mapping se rechaza.
3. `_analyze`: «`<p>Los Ciclistas subieron las MONTAÑAS</p>`» se queda en
   `ciclist subieron montan`. Fuera el HTML, las mayúsculas, «los» y «las», las
   terminaciones y la ñ.
4. `_bulk` con los ocho artículos.
5. Alta de un documento suelto y actualización parcial (`_update`).
6. Búsqueda por la URL: `?q=titulo:ciclista` encuentra «Los ciclistas…».
7. Las nueve consultas de `consultas/`. Resultados comprobados:

| Consulta | Resultado |
|---|---|
| `02` «ciclista montañas», con el título pesando ×3 | 4 artículos |
| `03` frase exacta «último kilómetro» | 1 |
| `04` «carrera» + atletismo + del 10 al 31 de octubre | 1: «Cómo preparar tu primera carrera de montaña» |
| `05` «baloncestto», con errata | Los 2 de baloncesto |
| `06` resaltado | `…dio la <em>copa</em> al equipo…` |
| `07` agregaciones | Visitas medias por deporte, artículos por semana, etiquetas más usadas |
| `09` «etapa rei» | «La etapa reina…» |

8. **El analizador de Sites contra el español** (ver abajo).

Al final los índices se quedan, para verlos en Dashboards.

## 3 · Dashboards (http://localhost:5601)

Sin usuario: la seguridad está desactivada. Probado que contesta; los menús son los de
la 2.19, **sin recorrer con clics**.

- **Dev Tools**: http://localhost:5601/app/dev_tools#/console, o **☰ → Management →
  Dev Tools**. Las mismas peticiones, sin `curl`: `GET curso-articulos/_search`.
- **Discover**:
  1. **☰ → Management → Dashboards Management → Index patterns → Create index
     pattern**.
  2. Patrón `curso-articulos*`, campo de tiempo `fecha`.
  3. **☰ → Discover**. Ampliad el rango de fechas arriba a la derecha: con «Last 15
     minutes» no sale nada.
- **Un gráfico**: **☰ → Visualize → Create visualization → Pie** →
  `curso-articulos*` → **Split slices → Terms → `deporte`**.

## 4 · Integrar con Sites

**Documentación oficial**, la única página que hay:
https://docs.oracle.com/en/middleware/webcenter/sites/14.1.2/admin/configure-opensearch-webcenter-sites.html

1. **Admin UI → External Integrations → nueva configuración de tipo OpenSearch.**

| Campo | Valor en este entorno |
|---|---|
| Instance Name | `wcs`: es el prefijo de los índices |
| Host Name | `opensearch.webcenter.svc.cluster.local`. Probado que el pod de Sites llega |
| Port | `9200` |
| Dashboard Port | `5601` |
| Protocol | `http` |
| Username y Password | Vacíos (la seguridad está desactivada) |

2. **Admin → Search → Manage Search Engines → opensearch → Configure.** Esperar a que
   todos estén en *Completed* (botón **Refresh**) y pulsar **Activate**.
3. Comprobar:
   ```bash
   sites/comprobar-indices.sh
   ```

Lo que **no documenta Oracle**: las versiones de OpenSearch certificadas, los plugins,
SSL, si hay que reiniciar y cómo reindexar.

### Lo que hemos visto en nuestro Sites (leído, sin cambiar nada)

- **La propiedad del motor** es `wcsites.search.engine`. Valor `lucene`, valores
  posibles `lucene, opensearch`, categoría `search`, y **`restart_required: true`**.
  Si tras activar no busca, puede hacer falta reiniciar Sites.
- **Sites crea los índices con una réplica** (`sites/plantilla-de-sites-*.json`). Con
  un solo nodo saldrán **amarillos**: los datos están, pero falta la copia. Para
  dejarlos en verde, `sites/comprobar-indices.sh wcs --verde`, que escribe en
  OpenSearch.
- **El analizador de Sites está en inglés.** Con contenido en español:

| Buscar | Analizador en español | Analizador de Sites |
|---|---|---|
| «maraton», sin tilde | encuentra «maratón» (1) | **no lo encuentra (0)** |
| «de» | 0: es palabra vacía | **5 de 8**: no la quita |
| «ciclista» | encuentra «ciclistas» | también: el inglés quita la «s» |

  Lo enseña el paso 8 de `demo.sh`, con la plantilla de Sites copiada en un índice
  nuestro. No está documentado si se puede cambiar el analizador de Sites.
- Los mappings de Sites: `name` y `description` son `text`, y además `keyword` en
  `name.keyword`; las fechas, en formato `yyyy-MM-dd HH:mm:ss.SSS`; `"dynamic": true`.
- El registrador de Sites para esto es `oracle.wcsites.search.opensearch`.
