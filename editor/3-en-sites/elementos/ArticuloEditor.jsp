<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"
%><%@ page pageEncoding="UTF-8"
%><cs:ftcs><!DOCTYPE html>
<html lang="es">
<head>
	<title>${asset.headline}</title>
	<link type="text/css" rel="stylesheet" href="<%=request.getContextPath()%>/avisports/css/all.css"/>
	<%-- El MISMO CSS que ve el redactor dentro del editor (content_css) --%>
	<link type="text/css" rel="stylesheet" href="<%=request.getContextPath()%>/ContentServer?pagename=CursoMig/Editor/estilos"/>
	<style>
		.cm-pagina { max-width: 760px; margin: 30px auto; font-family: Arial, Helvetica, sans-serif; font-size: 15px; line-height: 22px; color: #333; }
		.cm-pagina h1 { font-size: 30px; line-height: 34px; color: #1d3557; }
		.cm-pagina .cm-etiqueta { color: #e63946; font-weight: bold; text-transform: uppercase; font-size: 12px; }
	</style>
</head>
<body>
<div class="cm-pagina">
	<div class="cm-etiqueta">Curso de migración · TinyMCE con estilos y plantillas propios</div>
	<h1><insite:edit field="headline" value="${asset.headline}" params="{noValueIndicator: '[ titular ]'}"/></h1>

	<%--
	  En Web Mode, si hay customConfig, Sites coge de ese fichero SOLO la barra
	  (TINYMCE_CONFIG['toolbar_' + toolbar]); el resto sale de estos params
	  (TinyMCEEdit.js, getConfig). Por eso plugins, estilos y plantillas van aqui.
	  Sin comillas dobles y EN UNA LINEA: los params acaban dentro de una cadena
	  JavaScript entre comillas dobles (UI/Insite/Widgets/tinymce/single.jsp), y
	  un salto de linea ahi es un error de sintaxis.
	--%>
	<%--
	  insite:edit ESCAPA el HTML mientras la propiedad insite.edit.defaultMode
	  valga text, que es lo que trae 14.1.2 de serie: el cuerpo de «Agility
	  Drills» se publicaba con los &#60;p&#62; a la vista, y en Web Mode el
	  editor enseñaba las etiquetas como texto. Con insite.edit.defaultMode=html
	  deja de escapar (medido el 28-10-2026). mode="html" en la etiqueta NO
	  basta: la clase de Oracle mira la propiedad de todas formas.

	  Fuera de Web Mode el cuerpo se pinta directamente, sin insite:edit: asi la
	  pagina publicada sale bien valga lo que valga la propiedad.
	--%>
	<% if (!"insite".equals(ics.GetVar("rendermode"))) { %>
	<div class="cm-cuerpo">${asset.body}</div>
	<% } else { %>
	<insite:edit field="body" value="${asset.body}" editor="tinymce"
		params="{noValueIndicator: 'Escribid el cuerpo', width: '760px', height: '520px', toolbar: 'CursoMig', customConfig: '../ContentServer?pagename=CursoMig/Editor/config', forced_root_block: 'div', menubar: false, branding: false, toolbar_mode: 'wrap', plugins: 'code lists link table template visualblocks wcslinkasset wcsincludeasset wcsfocusincludedasset wcseditcontextmenu', content_css: '/sites/ContentServer?pagename=CursoMig/Editor/estilos', extended_valid_elements: 'div[class|_fwid],span[class|_fwid]', style_formats: [ {title: 'Entradilla', block: 'div', classes: 'cm-entradilla'}, {title: 'Cita', block: 'div', classes: 'cm-cita'}, {title: 'Aviso', block: 'div', classes: 'cm-aviso'}, {title: 'Marcador', inline: 'span', classes: 'cm-marcador'}, {title: 'Dato (versalitas)', inline: 'span', classes: 'cm-dato'}], templates: [ {title: 'Dos columnas', description: 'Texto a dos columnas', content: '<div class=cm-columnas><div>Columna izquierda</div><div>Columna derecha</div></div>'}, {title: 'Ficha del partido', description: 'Resultado con los dos equipos', content: '<div class=cm-ficha><div class=cm-ficha-titulo>Ficha</div><div class=cm-ficha-fila><span>Local</span><span class=cm-dato>0</span></div><div class=cm-ficha-fila><span>Visitante</span><span class=cm-dato>0</span></div></div>'}, {title: 'Destacado con imagen', description: 'Recuadro a la derecha', content: '<div class=cm-recuadro><div class=cm-recuadro-titulo>Titulo</div><div>Texto del recuadro</div></div><div>Sigue el articulo...</div>'}] }"/>
	<% } %>
</div>
</body>
</html>
</cs:ftcs>
