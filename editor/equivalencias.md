# De CKEditor 4 a TinyMCE 6: qué es qué

La columna de TinyMCE es la versión que trae nuestro 14.1.2, la **6.5.1**, con
licencia MIT. Las dos son de editores públicos y están en su documentación;
lo que es **propio de Sites** va aparte, al final.

## Opciones de configuración

| CKEditor 4 (`config.x`) | TinyMCE 6 (`TINYMCE_CONFIG.x`) | Ojo |
|---|---|---|
| `CKEDITOR.editorConfig = function (config) {…}` | `var TINYMCE_CONFIG = {…}` | Sites busca **ese nombre**. Una función por instancia pasa a ser un objeto global |
| `toolbar_X = [['Bold','Italic'], '/', …]` | `toolbar_X: 'bold italic \| …'` | Array de arrays → una cadena. `'-'` → `\|`. `'/'` (salto de fila) no existe: `toolbar_mode: 'wrap'` |
| `extraPlugins` / `removePlugins` | `plugins: '…'` | En TinyMCE se dice la lista entera de los que se cargan |
| `enterMode = CKEDITOR.ENTER_DIV` | `forced_root_block: 'div'` | Oracle lo deja en `div`, como estaba |
| `contentsCss` | `content_css` | |
| `stylesSet` | `style_formats` | `element` → `block` o `inline`; `attributes.class` → `classes` |
| `format_tags` | `block_formats` | |
| `allowedContent` / `extraAllowedContent` | `valid_elements` / `extended_valid_elements` | Lo que no está en el esquema, TinyMCE **lo quita al guardar** |
| `removeFormatTags` | `invalid_elements` | No es lo mismo: `invalid_elements` los quita siempre, no solo con el botón |
| `height`, `width` | `height`, `width` | |
| `resize_enabled` | `resize` | |
| `language` | `language` | Sites lo pone solo, con el idioma del usuario |

## Botones

| CKEditor 4 | TinyMCE 6 | Plugin que hace falta en TinyMCE |
|---|---|---|
| `Source` | `code` | `code` |
| `Undo` `Redo` | `undo` `redo` | — |
| `Bold` `Italic` `Underline` `Strike` | `bold` `italic` `underline` `strikethrough` | — |
| `Subscript` `Superscript` | `subscript` `superscript` | — |
| `RemoveFormat` | `removeformat` | — |
| `Format` | `blocks` | — |
| `Styles` | `styles` | — |
| `Font` `FontSize` | `fontfamily` `fontsize` | — |
| `TextColor` `BGColor` | `forecolor` `backcolor` | — |
| `JustifyLeft` … `JustifyBlock` | `alignleft` `aligncenter` `alignright` `alignjustify` (o `align`) | — |
| `NumberedList` `BulletedList` | `numlist` `bullist` | `lists` (o `advlist`) |
| `Outdent` `Indent` | `outdent` `indent` | — |
| `Link` `Unlink` | `link` `unlink` | `link` |
| `Anchor` | `anchor` | `anchor` |
| `Table` | `table` | `table` |
| `HorizontalRule` | `hr` | — |
| `SpecialChar` | `charmap` | `charmap` |
| `Find` `Replace` | `searchreplace` | `searchreplace` |
| `Maximize` | `fullscreen` | `fullscreen` |
| `ShowBlocks` | `visualblocks` | `visualblocks` |
| `Image` | `image` | `image` |
| `PasteText` `PasteFromWord` | `pastetext` | — (el pegado va en el núcleo desde la 6) |

## Lo propio de Sites

| 12.2.1.4 (CKEditor) | 14.1.2 (TinyMCE) | De dónde sale |
|---|---|---|
| Plugins para enlazar e incluir assets (en vuestro `config.js`: buscad los nombres) | `wcslinkasset` `wcsincludeasset` `wcsfocusincludedasset` `wcseditcontextmenu` | Carpetas de `/sites/tinymce/plugins/`, en nuestro servidor |
| `editor="ckeditor"` en `insite:edit` | `editor="tinymce"` | Avisports en 14.1.2: 17 `insite:edit` en 14 plantillas, todos ya con `tinymce` |
| `<CKEDITOR …>` en el editor de atributo | `<TINYMCE …>` | `TinyMCE500x300` de Avisports |
| `xcelerate.ckeditor.basepath` = `/sites/ckeditor/` | `xcelerate.tinymce.basepath` = `/sites/tinymce/` | Las dos propiedades siguen; la primera apunta a una carpeta que ya no existe |
| `customConfig: '../avisports/ckeditor/config.js'` | `customConfig: '../avisports/tinymce/config.js'` | Relativo a la carpeta base del editor |

**Los botones de pago.** El `config.js` de Oracle pone en sus barras
`spellcheckdialog`, `a11ycheck`, `typography` y `checklist`. Son plugins
**premium** de Tiny y **no vienen** en `/sites/tinymce/plugins/`: no dan error,
simplemente no salen. Si copiáis la barra de Oracle, sabed que esos cuatro no
están.
