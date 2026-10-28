<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%--
  El config.js de TinyMCE del curso, servido como PAGINA de Sites
  (pagename=CursoMig/Editor/config) y no como fichero de la WAR: asi se sube por
  REST (subir.py) y sigue ahi aunque se reinstale la WAR.

  El tipo application/javascript NO lo pone este JSP: va en la SiteEntry, como
  argumento por defecto cs.contenttype. Ni response.setContentType ni
  <%@ page contentType %> lo cambian; Sites contestaria text/html con nosniff y
  el navegador no ejecutaria esto (medido el 28-10-2026).

  Quien lo usa:
    - el editor de atributo CursoMigTinyMCE (formulario del Contributor):
      CONFIG="../ContentServer?pagename=CursoMig/Editor/config", TOOLBAR="CursoMig".
      El formulario usa TODO este objeto.
    - la plantilla CursoMigEditor (Web Mode), por customConfig: de aqui solo
      toma la barra; el resto lo repite en sus params.

  Tiene que llamarse TINYMCE_CONFIG: Sites lo busca por ese nombre. Y es uno
  solo por pagina: si un formulario carga dos config.js, gana el ultimo.
--%><cs:ftcs>
var TINYMCE_CONFIG = {

    // Lo que guarda Sites desde siempre: parrafos como <div>
    forced_root_block: 'div',
    menubar: false,
    branding: false,
    toolbar_mode: 'wrap',

    // template = las plantillas de maquetacion. Los cuatro wcs* son de Sites
    plugins: 'code lists link table template visualblocks ' +
             'wcslinkasset wcsincludeasset wcsfocusincludedasset wcseditcontextmenu',

    // Se elige por nombre: TOOLBAR="CursoMig" en el atributo,
    // toolbar: 'CursoMig' en insite:edit
    toolbar_CursoMig: 'undo redo | styles | template | bold italic | bullist numlist | ' +
                      'link table | visualblocks code | wcslinkasset wcsincludeasset',

    // El CSS de la web DENTRO del editor, para que el redactor vea lo que saldra
    content_css: '/sites/ContentServer?pagename=CursoMig/Editor/estilos',

    // Los estilos del desplegable: solo ponen clases, el aspecto lo da el CSS
    style_formats: [
        { title: 'Entradilla',      block: 'div',  classes: 'cm-entradilla' },
        { title: 'Cita',            block: 'div',  classes: 'cm-cita' },
        { title: 'Aviso',           block: 'div',  classes: 'cm-aviso' },
        { title: 'Marcador',        inline: 'span', classes: 'cm-marcador' },
        { title: 'Dato (versalitas)', inline: 'span', classes: 'cm-dato' }
    ],

    // Las plantillas de maquetacion del boton «template»
    templates: [
        { title: 'Dos columnas',
          description: 'Texto a dos columnas',
          content: '<div class="cm-columnas"><div>Columna izquierda</div><div>Columna derecha</div></div>' },
        { title: 'Ficha del partido',
          description: 'Resultado con los dos equipos',
          content: '<div class="cm-ficha"><div class="cm-ficha-titulo">Ficha</div>' +
                   '<div class="cm-ficha-fila"><span>Local</span><span class="cm-dato">0</span></div>' +
                   '<div class="cm-ficha-fila"><span>Visitante</span><span class="cm-dato">0</span></div></div>' },
        { title: 'Destacado con imagen',
          description: 'Recuadro a la derecha; arrastrad dentro una imagen con «Include asset»',
          content: '<div class="cm-recuadro"><div class="cm-recuadro-titulo">Titulo</div><div>Texto del recuadro</div></div><div>Sigue el articulo...</div>' }
    ],

    // Las clases de arriba tienen que sobrevivir al guardado
    extended_valid_elements: 'div[class|_fwid],span[class|_fwid]',

    contextmenu: 'CutCustomElement CopyCustomElement EditIncludeProperties RemoveInclude PasteCustomElement ' +
                 'CutCustomElementLink CopyCustomElementLink EditLinkProperties RemoveAssetLink ' +
                 'PasteCustomLinkedElement ViewAssetDetails'
};
</cs:ftcs>
