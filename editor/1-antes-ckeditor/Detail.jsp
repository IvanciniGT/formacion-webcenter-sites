<%-- El trozo de AVIArticle/Detail que edita el cuerpo en Web Mode, como estaba
     en 12.2.1.4. RECONSTRUIDO: en el curso no hay 12.2.1.4.

     Al migrar, en esta etiqueta solo cambian dos cosas: editor= y la carpeta de
     customConfig. Comparadlo con 2-despues-tinymce/Detail.jsp.

     params va EN UNA LINEA y SIN COMILLAS DOBLES dentro, como en Avisports:
     Sites lo mete en una cadena JavaScript entre comillas dobles y lo evalua
     (eval('var obj='+text) en UI/Insite/Widgets/.../single.jsp). Un salto de
     linea o unas comillas dobles ahi dentro rompen el editor sin error en el
     servidor: solo se ve en la consola del navegador. --%>
<insite:edit field="body" value="${asset.body}" editor="ckeditor"
             params="{noValueIndicator: 'Enter body ', width: '627px', height: '500px', toolbar: 'Article', customConfig: '../avisports/ckeditor/config.js'}"/>
