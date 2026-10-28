# CKEditor → TinyMCE en WebCenter Sites 14.1.2

Material para la **demostración 2**, la migración de un campo editable: de dónde
salía CKEditor, qué hay en su lugar y qué hay que tocar en un proyecto.

Las etiquetas de cada apartado dicen de dónde sale cada cosa:

- **Medido**: comprobado contra nuestro Sites 14.1.2 el 28-10-2026.
- **Leído**: sale del código de Sites (sus JSP y su JavaScript), pero no está probado en el navegador.
- **Reconstruido**: en el curso no hay 12.2.1.4, así que la parte del «antes» está escrita, no copiada.

## Qué hay

| Fichero | Qué es |
|---|---|
| `1-antes-ckeditor/` | Cómo estaba en 12.2.1.4: `config.js` de CKEditor, el editor de atributo y el `insite:edit` de la plantilla. **Reconstruido** |
| `2-despues-tinymce/` | Lo mismo, migrado a TinyMCE. Compáralo fichero a fichero con el anterior |
| `equivalencias.md` | Opción por opción y botón por botón, de CKEditor 4 a TinyMCE 6 |
| `buscar-ckeditor.sh` | Busca en un proyecto todo lo que depende de CKEditor. Sin argumentos, mira el Sites del curso |
| `buscar-ckeditor.ps1` | El mismo buscador, para Windows |
| `de-nuestro-sites/` | Copias tal cual de nuestro 14.1.2: el `config.js` de Oracle y el de Avisports, `TINYMCE.jsp` (el editor de atributo), el widget de Web Mode y `AVIArticle/Detail.jsp` |

## 0 · Montado en nuestro Sites: estilos y plantillas propios

`3-en-sites/subir.py` lo sube por REST a Avisports. `./subir.py --borrar` lo
quita y devuelve al atributo `body` su editor de antes, `TinyMCE500x300`.

| Qué | Dónde se ve |
|---|---|
| `CursoMig/Editor/config` | El `config.js`: cinco estilos (Entradilla, Cita, Aviso, Marcador, Dato), tres plantillas de maquetación (Dos columnas, Ficha del partido, Destacado con imagen) y la barra `CursoMig` |
| `CursoMig/Editor/estilos` | El CSS. Es **el mismo** para dentro del editor (`content_css`) y para la página publicada |
| Editor de atributo `CursoMigTinyMCE` | Puesto en el atributo `body`: el formulario de **cualquier** artículo en el Contributor sale con él |
| Plantilla `CursoMigEditor` | Plantilla de página para AVIArticle; Web Mode la usa con estos `params` |
| Artículo **«CursoMig · Editor»** | Con esa plantilla. Abridlo en Web Mode y pinchad en el cuerpo |

Las dos URLs sueltas, para enseñarlas:
`/sites/ContentServer?pagename=CursoMig/Editor/config` y `.../estilos`.

Cuatro cosas que salieron al montarlo:

- **El `config.js` y el CSS van como páginas de Sites, no como ficheros de la WAR.** Así no se toca el despliegue y siguen ahí aunque se reinstale la WAR. **Medido.**
- **El tipo de contenido se fija en la página, no en el JSP.** Va como argumento por defecto `cs.contenttype` (`resargs1` en SiteCatalog), igual que hace Oracle con `rest/asset`.
  - `response.setContentType`, `<%@ page contentType %>` e `ics.StreamHeader` **no lo cambian**: Sites contesta `text/html` con `nosniff`, y el navegador no ejecuta ese JS ni aplica ese CSS. **Medido.**
- **Web Mode y el formulario no leen el `config.js` igual.** **Leído** en `TinyMCEEdit.js`, `getConfig`:
  - el formulario lo usa entero;
  - Web Mode, si `insite:edit` lleva `customConfig`, **solo toma la barra** de ese fichero, y todo lo demás lo saca de los `params`.

  Por eso la plantilla repite en `params` los estilos y las plantillas de maquetación. Esos `params` tienen que ir **en una línea y sin comillas dobles**, porque acaban dentro de una cadena de JavaScript (`single.jsp`).
- **`insite:edit` escapa el HTML mientras `insite.edit.defaultMode` valga `text`**, que es lo que trae 14.1.2 de serie. Ver el apartado 2, punto 4. **Medido.**
  - En la página publicada de Avisports, el cuerpo de «Agility Drills» salía como texto: `&#60;p class="ckbody"&#62;…`. Y en Web Mode el editor enseñaba las etiquetas.
  - Fijaos además en que es HTML **de la época de CKEditor**: clases `ckbody`.
  - La plantilla del curso pinta el cuerpo tal cual cuando no está en Web Mode, así sale bien valga lo que valga la propiedad.

**Sin probar en el navegador:** el editor abierto, tanto en Web Mode como en el
formulario. Lo de arriba está comprobado con `curl` y con `node`: la página
publicada, el tipo de las dos URLs y la sintaxis del JS y de los `params`.

## 1 · Qué trae 14.1.2 (medido)

- **TinyMCE 6.5.1**, con licencia MIT, en `/sites/tinymce/`. Lo marca la propiedad `xcelerate.tinymce.basepath`.
- Los **plugins propios de Sites** están en `/sites/tinymce/plugins/`: `wcslinkasset`, `wcsincludeasset`, `wcsfocusincludedasset` y `wcseditcontextmenu`.
- **La librería de CKEditor ya no está.** `/sites/ckeditor/ckeditor.js` devuelve **404**.
  - Lo de alrededor sigue: la propiedad `xcelerate.ckeditor.basepath`, el JSP `OpenMarket/Gator/AttributeTypes/CKEDITOR.jsp` y los widgets Dojo `FormCKEditor`.
  - Por eso **no rompe al desplegar: rompe al editar**. El formulario se pinta y es el editor el que no aparece.
- **Avisports ya está migrado.** Sus 17 `insite:edit`, repartidos en 14 plantillas, usan `editor="tinymce"`. Sus editores de atributo son `TinyMCE500x300` y `TinyMCE300x300`.
- **Uno que Oracle no migró:** el editor de atributo `FWBlogsEditor` sigue con `<CKEDITOR WIDTH="580px" HEIGHT="200px">`. Es un buen ejemplo de lo que se escapa.
- **Restos en el CSS:** `avisports/tinymce/tinymce.css` sigue diciendo `/* classes defined for ckeditor only */`, con `.ckbody` y `.ckheadline`. Las clases de los contenidos guardados se quedan como estaban.

Para verlo en clase:

```bash
./buscar-ckeditor.sh          # sobre el Sites del curso: ninguna plantilla, y un
                              # editor de atributo, 9999999054393.txt = FWBlogsEditor
```

## 2 · Qué cambia en un proyecto

No hay jars que añadir: TinyMCE ya viene en la WAR de 14.1.2. Hay que tocar
tres sitios, que salen con `buscar-ckeditor`, y una propiedad, que no sale:

1. **Plantillas.** En `insite:edit` cambia `editor="ckeditor"` por `editor="tinymce"`, y `customConfig` pasa a apuntar a la carpeta de TinyMCE. El nombre de la barra (`toolbar: 'Article'`), `width` y `height` se quedan igual. Compara `1-antes-ckeditor/Detail.jsp` con `2-despues-tinymce/Detail.jsp`.
2. **Editores de atributo.** `<CKEDITOR …>` pasa a ser `<TINYMCE …>`. Están en la base de datos, en la tabla `ATTRTYPES`; con CSDT salen como ficheros.
3. **El `config.js`.** Aquí está casi todo el trabajo, porque **cambia de forma, no solo de nombres**:
   - En CKEditor era una función por instancia; ahora es **un objeto global** que se tiene que llamar `TINYMCE_CONFIG` (leído en `TINYMCE.jsp` y `TinyMCEEdit.js`).
   - Cada barra pasa de ser un array de arrays a ser una cadena.
   - Un botón cuyo plugin no está en `plugins` **no da error: no sale**.
   - La tabla completa está en `equivalencias.md`.
4. **La propiedad `insite.edit.defaultMode`, de `text` a `html`** (Admin → Gestión de propiedades), y reiniciar Sites.
   - Con `text`, que es el valor de serie en 14.1.2, `insite:edit` escapa el valor: el editor de Web Mode enseña `<p>` y `<div>` como texto, la página publicada también, y **si el redactor guarda, el HTML se queda escapado en la base de datos**.
   - Desde la plantilla no se arregla: `mode="html"` en la etiqueta no gana a la propiedad. Leído en el bytecode de `com.openmarket.xcelerate.jsp.insite.Edit` (en `sites-app.jar`): escapa si la etiqueta dice `text` **o** si la propiedad dice `text`.
   - Medido el 28-10-2026: tras cambiarla y reiniciar, «Agility Drills» se publica con sus `<p class="ckbody">` de verdad.
   - **El precio:** con `html` ningún `insite:edit` escapa, tampoco los de campos de texto plano como el titular. Un `<script>` en un titular se ejecuta. Es el motivo por el que Oracle lo dejó en `text`.

**Dónde viven esos ficheros.** `config.js` y su CSS se sirven desde la WAR de
Sites (por ejemplo `/sites/avisports/tinymce/config.js`). Al instalar la WAR
nueva de 14.1.2, la carpeta `ckeditor/` de vuestro proyecto **no viene**. Si
la poníais a mano en la WAR, en la migración hay que volver a ponerla, ahora
como `tinymce/`.

## 3 · El contenido ya guardado (leído; probadlo en clase)

El HTML que se guardó con CKEditor no cambia al migrar: está en la base de datos
y TinyMCE lo carga tal cual (`setContent(…, {format: 'raw'})`, en
`TINYMCE.jsp`). Los enlaces a assets son marcas de Sites (`_fwid`,
`_CSEMBEDTYPE_`) que también entiende el plugin nuevo.

**El riesgo está en el primer guardado.** Al guardar, TinyMCE serializa con su
esquema y **quita** lo que no reconoce: etiquetas como `<font>` o `<center>` y
atributos desconocidos. Un artículo viejo se edita para corregir una errata y
se guarda con otro HTML. Para lo que haya que conservar están
`extended_valid_elements` y `valid_elements`.

Cómo enseñarlo:

1. Crear por REST un artículo cuyo `body` tenga HTML viejo, por ejemplo `<font>`, `<center>` y un `<div class="ckbody">`.
2. Abrirlo en Web Mode, cambiar una letra y guardarlo.
3. Leerlo otra vez por REST y comparar los dos.

## 4 · Tres cosas raras del código de Oracle (leído, sin probar)

Están en `de-nuestro-sites/TINYMCE.jsp`. Comprobadlas antes de dar nada por hecho:

- **Línea 133.** Si `HEIGHT` es un número sin `px`, el JSP hace `ics.SetVar("WIDTH", _HEIGHT + "px")`: **le pone el alto al ancho**. Con `HEIGHT="300px"` no pasa, que es como lo trae Avisports.
- **El ancho, el alto y `CONFIGOBJ` del atributo** se guardan en un objeto aparte (`config_…`). Sin embargo, `tinymce.init` recibe `TINYMCE_CONFIG`, y de ese otro objeto solo le pasa la barra. Puede que el tamaño del editor salga del `<textarea>` y no de la configuración.
- **`TINYMCE_CONFIG` es uno solo para toda la página.** Si un formulario tiene dos campos con dos `config.js` distintos, se queda con el último que carga.

## 5 · Si preguntan

- **¿Se puede seguir usando CKEditor?** No sin traer vosotros la librería, y Oracle lo da por **no soportado** en 14.1.2. Las piezas de Sites que lo usaban siguen ahí, pero sin la librería no hacen nada.
- **¿TinyMCE 6 tiene fecha de caducidad?** La 6.5.1 es la que trae Oracle en este parche y su licencia es MIT. Las versiones posteriores de Tiny han cambiado de licencia. **Esto no está comprobado aquí:** miradlo antes de actualizarla por vuestra cuenta.
- **¿Y el Contributor y Web Mode usan el mismo editor?** Sí, pero entran por caminos distintos:
  - el Contributor, por el editor de atributo (`TINYMCE.jsp`);
  - Web Mode, por `insite:edit` (`UI/Insite/Widgets/tinymce/single.jsp`).

  Los dos cargan el mismo `tinymce.min.js` y un `config.js`, pero cada uno con sus parámetros. Por eso un campo puede verse distinto en cada sitio.
