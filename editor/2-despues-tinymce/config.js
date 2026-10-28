// La misma configuracion que la de la carpeta 1-antes, pasada a TinyMCE 6.5.1,
// que es el que trae nuestro 14.1.2 en /sites/tinymce/.
//
// Lo que cambia de forma, leido en TINYMCE.jsp y en TinyMCEEdit.js de Sites:
//   - No es una funcion por instancia: es UN objeto global que se tiene que
//     llamar TINYMCE_CONFIG. Sites lo busca por ese nombre.
//   - La barra se sigue eligiendo por nombre: toolbar 'Article' en el atributo
//     o en insite:edit -> TINYMCE_CONFIG.toolbar_Article.
//   - Una barra es UNA cadena: botones separados por espacio, grupos por «|».
//   - Un boton solo aparece si su plugin esta en «plugins». Si no, no da
//     error: simplemente no sale.

var TINYMCE_CONFIG = {

    // Lo que antes era ENTER_DIV. Es lo que pone Oracle en su config.js:
    // si lo cambiais a 'p', lo nuevo y lo viejo se guardan distinto.
    forced_root_block: 'div',

    // El CSS de la web dentro del editor. Relativo a /sites/, como el de Avisports
    content_css: 'cursomig/tinymce/tinymce.css',

    // El desplegable de estilos
    style_formats: [
        { title: 'Titular',   block: 'div',  classes: 'ckheadline' },
        { title: 'Cuerpo',    block: 'div',  classes: 'ckbody' },
        { title: 'Destacado', inline: 'span', styles: { 'background-color': '#ffff99' } }
    ],

    // extraAllowedContent. En TinyMCE lo que no esta en el esquema se QUITA al
    // guardar: el primer guardado de un contenido viejo puede cambiarlo.
    extended_valid_elements: 'div[class|style|_fwid],span[class|style|_fwid]',
    invalid_elements: 'font,center,big,small',

    menubar: false,
    branding: false,
    toolbar_mode: 'wrap',

    // Los cuatro wcs* son los de Sites: enlazar e incluir assets. Sin ellos el
    // redactor pierde los enlaces a assets.
    plugins: 'advlist anchor charmap code fullscreen link lists searchreplace table visualblocks ' +
             'wcslinkasset wcsincludeasset wcsfocusincludedasset wcseditcontextmenu',

    toolbar_Article: 'code undo redo | blocks styles fontfamily fontsize | ' +
                     'bold italic underline strikethrough removeformat | ' +
                     'numlist bullist outdent indent | link unlink anchor table hr charmap | ' +
                     'wcslinkasset wcsincludeasset',

    toolbar_Home: 'bold italic | wcslinkasset',

    // El menu del boton derecho de Sites, copiado del config.js de Oracle
    contextmenu: 'CutCustomElement CopyCustomElement EditIncludeProperties RemoveInclude PasteCustomElement ' +
                 'CutCustomElementLink CopyCustomElementLink EditLinkProperties RemoveAssetLink ' +
                 'PasteCustomLinkedElement ViewAssetDetails'
};
