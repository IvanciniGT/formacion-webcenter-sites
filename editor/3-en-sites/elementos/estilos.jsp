<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%--
  El CSS del curso, servido como pagina de Sites (pagename=CursoMig/Editor/estilos).
  El tipo text/css va en la SiteEntry (cs.contenttype), igual que config.jsp.

  Es EL MISMO para dos sitios, y esa es la idea:
    - dentro del editor (content_css en config.jsp y en los params de la plantilla),
      para que el redactor vea lo que va a salir;
    - en la pagina publicada (el <link> de ArticuloEditor.jsp).

  Cada clase cm-* tiene que estar en tres sitios a la vez: aqui (el aspecto),
  en style_formats o templates (el boton que la pone) y permitida en
  extended_valid_elements (para que TinyMCE no la quite al guardar).
--%><cs:ftcs>
.cm-entradilla { font-size: 1.25em; font-weight: bold; color: #1d3557; border-left: 5px solid #e63946; padding-left: 12px; margin: 12px 0; }
.cm-cita       { font-style: italic; font-size: 1.15em; color: #555; border-left: 4px solid #bbb; padding: 6px 14px; margin: 12px 0; background: #f6f6f6; }
.cm-aviso      { background: #fff3cd; border: 1px solid #e0b400; border-radius: 6px; padding: 10px 14px; margin: 12px 0; }
.cm-marcador   { background: #ffef5a; padding: 0 3px; }
.cm-dato       { font-variant: small-caps; font-weight: bold; color: #e63946; }
.cm-columnas   { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin: 12px 0; }
.cm-columnas > div { border-top: 3px solid #1d3557; padding-top: 6px; }
.cm-ficha      { width: 260px; border: 2px solid #1d3557; border-radius: 6px; margin: 12px 0; font-family: Arial, sans-serif; }
.cm-ficha-titulo { background: #1d3557; color: #fff; padding: 6px 10px; font-weight: bold; }
.cm-ficha-fila { display: flex; justify-content: space-between; padding: 6px 10px; border-top: 1px solid #ddd; }
.cm-recuadro   { float: right; width: 40%; margin: 0 0 12px 16px; background: #eef4fb; border: 1px solid #9ab; padding: 10px; }
.cm-recuadro-titulo { font-weight: bold; color: #1d3557; margin-bottom: 6px; }
</cs:ftcs>
