<%-- Asi esta en nuestro 14.1.2 (copia entera en de-nuestro-sites/AVIArticle-Detail.jsp).

     Frente a 12.2.1.4 cambian dos cosas: editor= y la carpeta de customConfig.
     El nombre de la barra, el ancho y el alto se quedan igual.

     customConfig: en Web Mode, Sites solo coge de ese fichero LA BARRA
     (TINYMCE_CONFIG['toolbar_' + toolbar]). Plugins, estilos y demas salen de
     estos params (TinyMCEEdit.js, getConfig; leido, no probado opcion a opcion).
     El formulario del Contributor, en cambio, usa el config.js entero.

     params EN UNA LINEA y SIN COMILLAS DOBLES: ver 1-antes-ckeditor/Detail.jsp.

     OJO, Y NO ESTA EN LA ETIQUETA: con la propiedad insite.edit.defaultMode=text,
     que es la que trae 14.1.2 de serie, insite:edit ESCAPA el valor. El editor
     enseña <p> y <div> como texto, la pagina publicada tambien, y si el redactor
     guarda, el HTML se queda escapado en la base de datos. Se arregla con
     insite.edit.defaultMode=html (Admin, Gestion de propiedades) y reiniciando.
     Poner mode="html" en la etiqueta NO basta: la clase de Oracle
     (com.openmarket.xcelerate.jsp.insite.Edit) mira la propiedad igualmente.
     Precio: con html ningun insite:edit escapa, tampoco el titular (XSS). --%>
<insite:edit field="body" value="${asset.body}" editor="tinymce"
             params="{noValueIndicator: 'Enter body ', width: '627px', height: '500px', toolbar: 'Article', customConfig: '../avisports/tinymce/config.js'}"/>
