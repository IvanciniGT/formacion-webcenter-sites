
# Repaso conceptos Opensearch

- Openserach es un orquestador de Lucenes.
- En opensearch existe en concepto de INDICE
  Pero es un concepto distinto de lo que es en Lucene y de lo que son los índices inversos. 
  Un índice en Lucene es :
  - Un conjunto de lucenes
  - Un conjunto de documentos que se indexan juntos.

    En Opensearch, un índice es equivalente a lo que en una BBDD sería una tabla.
    - Los documentos de un índice se guardan repartidos entre varios lucenes.. puede ser 1 o más.
    - De cada partición podemosd tener replicas, para HA.

INDICE ARTICULOS DEL BLOG DE LA WEB PUBLICA.
- 2 lucenes indexando artículos del blog... en este INDICE. Estos luecenes en Opensearch se llaman SHARDS PRIMARIOS.
  - SHARD = FRAGMENTO DE UN ÍNDICE.
- Pero de cada uno de ellos podría tener 1 réplica (SHARD DE REPLICA) para que si se pierde una máquina, al menos haya una copia disponible en otra máquina.

Esos shards (LUCENES) se guardan en distintas máquinas.

Para vosotros, mi propuesta es que montáseis un único nodo de Opensearch.
En este caso, no tendría sentido tener:
- Más de 1 shard primario, ya que todos se guardarían en la misma máquina.
- Réplicas, ya que no habría otra máquina donde guardarlas.

Montamos más máquinas cuando:
- Tenemos que ingestar muchos datos , y las que tenemos no dan de si.
  - CREO QUE NO ES VUESTRO CASO
- Para Alta disponibilidad sin pérdida de servicio.
  - CREO QUE TAMPOCO ES VUESTRO CASO (Es decir, montando un activo-pasivo, puede estar el sistema caído 3 minutos... es admisible?)


Partiendo de esta configuración, la integración es muy simple.
Un cluster de opensearch puede estar en 3 estados:
- green         Esta cojonudo. Funciona sin problemas
- yellow        Está regular. Funciona sin problemas
- red           Esta jodido... FALTAN DATOS,. No todos los datos son accesibles


INDICE que tiene 2 framentos primarios y 1 réplica de cada uno.

Nodo1  Lucene Primario 1            Primario Primario 2
Nodo3  Réplica del Primario 1       Réplica del Primario 2

Este cluster estaría en VERDE!
Pasaría a estado YELLOW (los datos del Lucene priario 2 no están disponibles... pero hay una réplica)
Cuando la réplica sea generada en el segundo, el cluster pasa a estado VERDE.


Nodo1   P1      P2'    P3''
                        Nodo2   P2      P3'    P1'' --- OFFLINE
Nodo3   P3      P1'    P2''

Y se cae un nodo.
El cluster sigue tenendo acceso a todos los datos.
Pero no tiene dnde ubicar P2, P3' y P1''. Eso es estado yellow!

---

Tipos de indices asociados a campos en Opensearch:

- TEXT     <- Se usan para Búsquedas a texto completo (TOKENZADO)
- KEYWORD  <- Se usan para búsquedas exactas, no se tokeniza.
  - En muchos casos usamos ambos.
      ingredientes:
        Patata       -> Indexado :
                            Text: patat
                        Indexado
                            Keyword: Patata
      Nombre de un autor 
        Iván Osuna Ayuste  -> Indexado :
                                    Text: [ ivan, osun, ayuste]
                              Indexado
                                    Keyword: "Iván Osuna Ayuste"

Si quiero hacer búsquedas a texto completo, uso el campo TEXT.
    Dame los artículos de osuna 
    Dame los artículos de IVAN

Dame una tabla con cúantos artículos han escrito cada autor:
    Iván Osuna Ayuste           3
    Otro Autor                  2

Título:             Text, Keyword
Descripción:        Text, ~~Keyword~~

En estos mappings que se generan (DINAMICOS), o que NOSOTROS PONEMOS ESTATICAMENTE cuando creamos un índice. 
Aquñi no se pone solo el tipo de campo... ponemos también el ANALIZADOR que se va a usar para el campo TEXT.

Dentro de OpenSearch, podemos modificar los mappings de un índice existente, incluyendo los tipos de campo y los analizadores asociados a los campos TEXT.


Lo normal , en lugar de modificar el índice que crea Sites, es crear DE ANTEMANO un index_template.

Podemos definir un index_template para todos os índices que comiencen por "wcs_*"

```json
PUT _index_template/wcs_template
{
  "index_patterns": ["wcs_*"],
  "priority": 500,
  "template": {
    "settings": {
      "number_of_shards": 1,
      "number_of_replicas": 0,
      "analysis": {
        "filter": {
          "palabras_vacias": { "type": "stop", "stopwords": "_spanish_" },
          "raiz_espanol": { "type": "stemmer", "language": "light_spanish" }
        },
        "analyzer": {
          "default": {
            "type": "custom",
            "char_filter": ["html_strip"],
            "tokenizer": "standard",
            "filter": ["lowercase", "palabras_vacias", "raiz_espanol", "asciifolding"]
          },
          "espanol_html": {
            "type": "custom",
            "char_filter": ["html_strip"],
            "tokenizer": "standard",
            "filter": ["lowercase", "palabras_vacias", "raiz_espanol", "asciifolding"]
          }
        }
      }
    },
    "mappings": {
      "properties": {
        "DefaultSearchField": {
          "type": "text",
          "analyzer": "espanol_html",
          "fields": { "exacto": { "type": "keyword", "ignore_above": 200 } }
        }
      }
    }
  }
}
```


Para editar luego un índice concreto de un asset al que incluimos un campo:

```json
PUT wcs_aviarticle/_mapping
{
  "properties": {
    "nuevo-campo": { "type": "text", "analyzer": "espanol_html" }
  }
}

```


# JARS que faltan al integrar Opensearch

## El síntoma

Al pulsar **Configure** en *Manage Search Engines* (Admin):

```
NoClassDefFoundError: org/opensearch/client/transport/OpenSearchTransport
```

La imagen de 14.1.2 (la 241205) trae el conector de Sites, `sites-open-search.jar` (en `WEB-INF/lib` de la WAR)...
pero NO trae las librerías de las que depende. Su pom pide `opensearch-java`, `opensearch-rest-client` y `opensearch` 2.11.1,
y no hay ninguna en todo `/u01/oracle`.

ES DECIR: la integración con OpenSearch NO FUNCIONA "de serie". Hay que meter los JARs a mano.

## Dónde se ponen

En la carpeta `lib` del DOMINIO de WebLogic:

```
/u01/oracle/user_projects/domains/<dominio>/lib
```

- WebLogic añade lo que hay ahí AL FINAL del classpath del servidor.
  - Lo que el servidor ya trae (Lucene 9.9.1, Jackson 2.17, httpclient 4, commons-*, log4j, slf4j, joda-time) GANA.
    Por eso esas NO se repiten.
- Sites no lleva librerías de terceros en su WAR: las toma del servidor. Por eso van aquí... y no en la WAR.
- Hace falta REINICIAR el servidor de Sites después.

Antes de tocar: copia de seguridad de `config/` del dominio. Si algo sale mal, se borran los jars nuevos y se reinicia.

## Los 36 que hay que meter (todos de Maven Central)

| Grupo | Jars |
|---|---|
| Cliente y núcleo de OpenSearch (2.11.1) | `opensearch-java`, `opensearch-rest-client`, `opensearch`, `opensearch-cli`, `opensearch-common`, `opensearch-compress`, `opensearch-core`, `opensearch-geo`, `opensearch-secure-sm`, `opensearch-telemetry`, `opensearch-x-content` |
| Módulos de Lucene que el servidor NO trae (9.7.0) | `lucene-backward-codecs`, `lucene-grouping`, `lucene-highlighter`, `lucene-join`, `lucene-memory`, `lucene-misc`, `lucene-spatial-extras`, `lucene-spatial3d` |
| HTTP | `httpclient5` 5.2.3, `httpcore5` 5.2.4, `httpcore5-h2` 5.2.4, `httpasyncclient` 4.1.5, `httpcore-nio` 4.4.16 |
| JSON (Jakarta) | `jakarta.json-api` 2.1.3, `jakarta.json.bind-api` 2.0.0, `parsson` 1.1.6, `yasson` 2.0.2 |
| Otras que pide opensearch | `HdrHistogram` 2.1.12, `t-digest` 3.2, `jna` 5.13.0, `jopt-simple` 5.0.4, `jzlib` 1.1.3, `protobuf-java` 3.22.3, `snakeyaml` 2.1, `zstd-jni` 1.5.5-5 |

Los de Lucene: el servidor YA trae `core`, `analysis-common`, `queries`, `queryparser`, `sandbox` y `suggest` (9.9.1). Solo faltan los de la tabla.

## Los que NO hay que meter (y que rompen cosas)

Esto es lo interesante... porque NO DA ERROR AL ARRANCAR. Rompe otra cosa, en otro sitio.

### `jackson-dataformat-smile` y `jackson-dataformat-cbor` → TUMBAN CAS

- Las pide opensearch... y parecen inofensivas.
- CAS (que va en su propia WAR) lleva SU PROPIO `jackson-core`, y prefiere el suyo (`prefer-web-inf-classes`).
- Spring, dentro de CAS, encuentra `SmileFactory` en el servidor... que está enlazada al `JsonFactory` DEL SERVIDOR, no al de CAS.
- Resultado: `VerifyError: Bad return type`. CAS no arranca.
- Y SIN CAS NO SE ENTRA EN SITES.

REGLA: cualquier extensión de una librería que una WAR lleve dentro choca igual.

### `org.glassfish:jakarta.json` (la `-module`) → EL INDEXADO MUERE EN SILENCIO

- No la pides tú: la trae `yasson` de rebote (dependencia transitiva).
- Con ella Y `parsson` hay DOS implementaciones de `JsonProvider`.
- El `ServiceLoader` de Java da primero con la de glassfish... y cada hilo de indexado muere con:

```
ServiceConfigurationError: ... JsonProviderImpl not a subtype
```

- Lo que se ve en Sites: Configure "funciona", los índices `wcs_*` se crean... pero se quedan VACÍOS (o con 2 documentos de 385).
- La que usa `opensearch-java` es `parsson`. La de glassfish sobra.

MORALEJA: descargar "el jar y sus dependencias" con Maven a ciegas mete justo las que rompen. La lista hay que hacerla a mano y probarla.

## Cómo comprobar que ha ido bien

1. Reiniciar Sites.
2. Entrar en Sites (si no se puede entrar → mirar CAS en el log: el `VerifyError` de arriba).
3. Admin → Manage Search Engines → Configure.
4. Que todos los tipos pasen a **Completed**.
5. En Dashboards, que los documentos estén:

```
GET _cat/indices/wcs_*?v
POST wcs_*/_refresh
GET wcs_aviarticle/_count
```

OJO: `_cat/indices` puede dar números viejos hasta que se hace `_refresh`.
En el curso: `wcs_aviarticle` 136, `wcs_aviimage` 249, `wcs_global` 277.

## Si Configure se queda solo con "Refrescar"

Si se interrumpe una indexación (un reinicio a medias, o se borra la integración mientras indexa),
en la tabla `INDEXSOURCEMETADATACONFIG` del esquema de Sites se queda el tipo en estado `Running`... y Sites esconde el botón Configure.

- Se borra esa fila (o se pone en otro estado).
- Y se REINICIA Sites: lo tiene en caché.

Al borrar una integración y crear otra: NOMBRE DE INSTANCIA = prefijo de los índices. Si se cambia `wcs` por otra cosa,
los índices se llamarán distinto y el index template de `wcs_*` no les aplica.
