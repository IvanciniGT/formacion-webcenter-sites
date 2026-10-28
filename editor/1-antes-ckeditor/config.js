// La configuracion de CKEditor de un proyecto en 12.2.1.4, del estilo de la que
// traia Avisports en avisports/ckeditor/config.js.
//
// RECONSTRUIDA, NO COPIADA: en el curso no hay 12.2.1.4. La forma (una funcion
// que recibe el config de cada instancia) es la de CKEditor 4. Los nombres de
// los botones propios de Sites (fwlinkasset, fwincludeasset) son de memoria:
// buscad los vuestros en el config.js de vuestro proyecto antes de fiaros.

CKEDITOR.editorConfig = function (config) {

    // Los parrafos como <div>: lo que Sites ha guardado siempre
    config.enterMode = CKEDITOR.ENTER_DIV;

    // El CSS de la web dentro del editor, para que se vea como en la pagina
    config.contentsCss = '../avisports/ckeditor/ckeditor.css';

    // Los estilos que el redactor elige en el desplegable «Estilos»
    config.stylesSet = [
        { name: 'Titular',  element: 'div',  attributes: { 'class': 'ckheadline' } },
        { name: 'Cuerpo',   element: 'div',  attributes: { 'class': 'ckbody' } },
        { name: 'Destacado', element: 'span', styles: { 'background-color': '#ffff99' } }
    ];

    // Lo que el redactor NO puede meter, aunque lo pegue de Word
    config.removeFormatTags = 'font,center,big,small';
    config.extraAllowedContent = 'div(*);span{background-color}';

    // Barras de herramientas: se eligen por nombre desde el atributo o la
    // plantilla (toolbar: 'Article' -> config.toolbar_Article)
    config.toolbar_Article = [
        ['Source', '-', 'Undo', 'Redo'],
        ['Format', 'Styles', 'Font', 'FontSize'],
        ['Bold', 'Italic', 'Underline', 'Strike', '-', 'RemoveFormat'],
        ['NumberedList', 'BulletedList', '-', 'Outdent', 'Indent'],
        ['Link', 'Unlink', 'Anchor', 'Table', 'HorizontalRule', 'SpecialChar'],
        '/',
        ['fwlinkasset', 'fwincludeasset']
    ];

    config.toolbar_Home = [
        ['Bold', 'Italic', '-', 'fwlinkasset']
    ];
};
