<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%//
// UI/Insite/Widgets/tinymce/single
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="org.jsoup.Jsoup"%>
<%@ page import="org.jsoup.nodes.Document"%>
<cs:ftcs>

<c:set var="htmlFragment" value="${cs.value}" />
<ics:getproperty name="xcelerate.tinymce.basepath" file="futuretense_xcel.ini" output="basepath" />
<script type="text/javascript" src='<ics:getvar name="basepath"/>tinymce.min.js' referrerpolicy="origin"></script>
<script type="text/javascript" id="customScript" referrerpolicy="origin"></script>
<script type="text/javascript">
var text = "${cs.editorParams}".replaceAll("&#39;","'");
eval('var obj='+text);
var customConfigFile = "config.js";
if(obj.customConfig)
	customConfigFile = obj.customConfig;
document.getElementById('customScript').src = '<%= ics.GetVar("basepath")%>'+customConfigFile;
</script>
<%
//We are normalizing the html here so that incorrect html
//can be fixed before rendering on the webmode.
Document doc = Jsoup.parseBodyFragment((String)pageContext.getAttribute("htmlFragment"));
String innerHTML = doc.body().html();
%>
<c:set var="DeviceID" value='<%=ics.GetVar("deviceid")%>'/>
<c:set var="basepath" value='<%=ics.GetVar("basepath")%>'/>
<div dojoType="fw.ui.dijit.insite.InlineEditBox"
	editor="fw.ui.dijit.insite.TinyMCEEdit" editorType="ckedit" renderAsHtml="true"
	editorParams='{config: ${cs.editorParams}, required: ${cs.isRequired},enableEmbeddedLinks:${cs.allowEmbeddedLinks},deviceid:"${DeviceID}",BasePath:"${basepath}"}'
	widgetArgs='{assetName: "${cs.assetName}", assetId: {id: "${cs.assetId}", type: "${cs.assetType}"}, fieldName: "${cs.fieldName}", isEditable: ${cs.isEditable}, isMultivalued: ${cs.isMultivalued}, index: ${cs.index}}'>
	<%=innerHTML%>
</div> 
</cs:ftcs>