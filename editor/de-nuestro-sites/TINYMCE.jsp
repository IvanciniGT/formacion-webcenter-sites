<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"%>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld"%>
<%@ taglib prefix="presentation" uri="futuretense_cs/presentation.tld"%>
<%@page import="java.util.*"%>
<%@ page import="COM.FutureTense.Interfaces.FTValList"%>
<%@ page import="COM.FutureTense.Interfaces.ICS"%>
<%@ page import="COM.FutureTense.Interfaces.IList"%>
<%@ page import="COM.FutureTense.Interfaces.Utilities"%>
<%@ page import="com.openmarket.gator.interfaces.IAttributeTypeManager"%>
<%@ page import="com.openmarket.gator.interfaces.IPresentationObject"%>
<%@ page import="com.openmarket.assetframework.interfaces.IAssetTypeManager"%>
<%@ page import="com.openmarket.assetframework.interfaces.AssetTypeManagerFactory"%>
<%@ page import="com.openmarket.xcelerate.publish.EmbeddedLink"%>
<%//
// OpenMarket/Gator/AttributeTypes/TINYMCE
//
// INPUT
//
// OUTPUT
//%>
<%!
	final static String DEFAULT_HEIGHT = "#DEFAULT_HEIGHT#";
	final static String DEFAULT_WIDTH = "#DEFAULT_WIDTH#";
	final static String DEFAULT_TOOLBAR = "#DEFAULT_TOOLBAR#";
	final static String DEFAULT_HEIGHT_VALUE = "200px";
	final static String DEFAULT_WIDTH_VALUE = "";
	static String DEFAULT_TOOLBAR_VALUE = "";
	final static String DEFAULT_DEPTYPE = "false";

	//[KGF 2008-12-02] Adding lazyload.
	//I will be coding such that if it is not explicitly "false" it will be treated as "true".
	final static String DEFAULT_LAZYLOAD = "true";
%>
<cs:ftcs>
	<ics:getproperty name="xcelerate.tinymce.basepath" file="futuretense_xcel.ini" output="basepath" />
	<ics:getproperty name="ft.cgipath" file="futuretense.ini" output="cgipath" />
<%

	final String cgiPath = ics.GetVar("cgipath");
	DEFAULT_TOOLBAR_VALUE = ("ucform".equals(ics.GetVar("cs_environment"))) ? "SITES" : "CS";


%>
	<ics:if condition='<%=!Utilities.goodString(ics.GetVar("basepath"))%>'>
	<ics:then>
		<ics:setvar name="basepath" value='<%=ics.GetVar("cgipath") + "tinymce/"%>' />
	</ics:then>
	</ics:if>
	<ics:setvar name="doDefaultDisplay" value="no" />


<%
	boolean isSingleValued = "single".equals(ics.GetVar("EditingStyle"));
	IList attributeValueList = ics.GetList("AttrValueList", false);
	boolean hasValues = attributeValueList != null && attributeValueList.hasData();
	boolean isUrlField = "url".equals(ics.GetVar("AttrType"));

	boolean allowEmbeddedLinks = "true".equals(ics.GetVar("AllowEmbeddedLinks"));
	String presObj = ics.GetVar("PresInst");
	%>
	<presentation:getprimaryattributevalue name='<%=presObj%>' attribute="XSIZE" varname="XSIZE" />
	<presentation:getprimaryattributevalue name='<%=presObj%>' attribute="YSIZE" varname="YSIZE" />
	<presentation:getprimaryattributevalue name='<%=presObj%>' attribute="TOOLBAR" varname="TOOLBAR" />
	<presentation:getprimaryattributevalue name='<%=presObj%>' attribute="LAZYLOAD" varname="LAZYLOAD" />
	<presentation:getprimaryattributevalue name='<%=presObj%>' attribute="ALLOWEDASSETTYPES" varname="ALLOWEDASSETTYPES" />
	<presentation:getprimaryattributevalue name='<%=presObj%>' attribute="SCRIPT" varname="SCRIPT" />
	<presentation:getprimaryattributevalue name='<%=presObj%>' attribute="IMAGEPICKERID" varname="IMAGEPICKERID" />
	<presentation:getprimaryattributevalue name='<%=presObj%>' attribute="DEPTYPE" varname="DEPTYPE" />
	<presentation:getprimaryattributevalue name='<%=presObj%>' attribute="LAZYLOAD" varname="LAZYLOAD" />
	<presentation:getprimaryattributevalue name='<%=presObj%>' attribute="WIDTH" varname="WIDTH" />
	<presentation:getprimaryattributevalue name='<%=presObj%>' attribute="HEIGHT" varname="HEIGHT" />
	<presentation:getprimaryattributevalue name='<%=presObj%>' attribute="CONFIG" varname="CONFIG" />
	<presentation:getprimaryattributevalue name='<%=presObj%>' attribute="CONFIGOBJ" varname="CONFIGOBJ" />
	<presentation:getprimaryattributevalue name='<%=presObj%>' attribute="RESIZE" varname="RESIZE" />
	<presentation:getprimaryattributevalue name='<%=presObj%>' attribute="IMAGEASSETTYPE" varname="IMAGEASSETTYPE" />
	<presentation:getmaxvalues name='<%=presObj%>' varname="MAXVALUES" />

	<script type="text/javascript" src='<ics:getvar name="basepath"/>tinymce.min.js' referrerpolicy="origin"></script>
	<%if (Utilities.goodString(ics.GetVar("CONFIG"))) {
%>			<script type="text/javascript" src='<ics:getvar name="basepath"/><%=ics.GetVar("CONFIG")%>' referrerpolicy="origin"></script>
<%		} else {
%>			<script type="text/javascript" src='<ics:getvar name="basepath"/>config.js' referrerpolicy="origin"></script>
<%		}%>


	<%
	String maximumValues = ics.GetVar("MAXVALUES");
	maximumValues = Utilities.goodString(maximumValues) && !"0".equals(maximumValues) ? maximumValues : "-1";

	if (!Utilities.goodString(ics.GetVar("XSIZE"))) ics.SetVar("XSIZE", DEFAULT_WIDTH);
	if (!Utilities.goodString(ics.GetVar("YSIZE"))) ics.SetVar("YSIZE", DEFAULT_HEIGHT);
	if (!Utilities.goodString(ics.GetVar("LAZYLOAD"))) ics.SetVar("LAZYLOAD", DEFAULT_LAZYLOAD);
	if (!Utilities.goodString(ics.GetVar("TOOLBAR"))) ics.SetVar("TOOLBAR", DEFAULT_TOOLBAR);
	if (!Utilities.goodString(ics.GetVar("DEPTYPE"))) ics.SetVar("DEPTYPE", DEFAULT_DEPTYPE);

	if (!Utilities.goodString(ics.GetVar("WIDTH"))) {
		if (Utilities.goodString(ics.GetVar("XSIZE"))) {
			ics.SetVar("WIDTH", ics.GetVar("XSIZE"));
		} else {
			ics.SetVar("WIDTH", DEFAULT_WIDTH);
		}
	}

	if (!Utilities.goodString(ics.GetVar("HEIGHT"))) {
		if (Utilities.goodString(ics.GetVar("YSIZE"))) {
			ics.SetVar("HEIGHT", ics.GetVar("YSIZE"));
		} else {
			ics.SetVar("HEIGHT", DEFAULT_HEIGHT);
		}
	}

	//Take the width and height if they come with px else add it.
	if (ics.GetVar("WIDTH") != null) {
		String _WIDTH = ics.GetVar("WIDTH").trim();
		ics.SetVar("WIDTH",_WIDTH);
		try {
            Integer.parseInt(_WIDTH);
            ics.SetVar("WIDTH",_WIDTH + "px");
        } catch (Exception ex) {
			// if width is empty, we should not add 'px' to width.
			// No exception to catch.
        }
	}

	if (ics.GetVar("HEIGHT") != null) {
		String _HEIGHT = ics.GetVar("HEIGHT").trim();
		ics.SetVar("HEIGHT",_HEIGHT);
		try {
            Integer.parseInt(_HEIGHT);
            ics.SetVar("WIDTH",_HEIGHT + "px");
        } catch (Exception ex) {
			// if width is empty, we should not add 'px' to width.
			// No exception to catch.
        }
	}

	if (Utilities.goodString(ics.GetVar("RESIZE"))) {
		ics.SetVar("RESIZE", ics.GetVar("RESIZE"));
	} else {
		ics.SetVar("RESIZE", "");
	}

	//Generate the ids for the tinymce so that if there are muliple instances(In different fields and not as in multi value)
	//on the same form they can be handled idependently
	String _genId = String.valueOf((int) (Math.random()*10000000));
%>

<satellite:link pagename="OpenMarket/Xcelerate/Actions/FCKEditorRenderer" assembler="query" outstring="urlFCKEditorRenderer">
	<satellite:argument name="cs_environment" 	value='<%=ics.GetVar("cs_environment")%>' />
	<satellite:argument name="cs_formmode" 		value='<%=ics.GetVar("cs_formmode")%>' />
	<satellite:argument name="cs_imagedir" 		value='<%=ics.GetVar("cs_imagedir")%>' />
</satellite:link>

<tr>
	<ics:callelement element="OpenMarket/Gator/FlexibleAssets/Common/DisplayAttributeName" />
	<td></td>
	<td>
	<ics:callelement element="OpenMarket/Gator/UIFramework/Util/ShowHelpText">
		<ics:argument name="attributeName" value='<%=ics.GetVar("AttrName") %>' />
		<ics:argument name="attributeType" value='<%=ics.GetVar("attributetype") %>' />
	</ics:callelement>
	<ics:if condition='<%= "no".equals(ics.GetVar("MultiValueEntry")) %>'>
	<ics:then>
		<ics:if condition="<%= isUrlField %>">
		<ics:then>
			<ics:if condition="<%= hasValues %>">
			<ics:then>
				<ics:listget listname="AttrValueList" fieldname="urlvalue" output="filename" />
				<ics:listget listname="AttrValueList" fieldname="@urlvalue" output="MyAttrVal" />
			</ics:then>
			<ics:else>
				<ics:resolvevariables name="CS.UniqueID.txt" output="filename" />
			</ics:else>
			</ics:if>
			<string:encode variable="cs_SingleInputName" varname="cs_SingleInputName"/>
			<input 	type="hidden"
					name="<ics:getvar name="cs_SingleInputName"/>_file"
					value="<ics:getvar name="filename"/>" />
		</ics:then>
		</ics:if>
<%
		String attributeValue = ics.GetVar("MyAttrVal");
		attributeValue = (attributeValue == null ? "" : attributeValue);
%>
		<string:encode variable="cs_SingleInputName" varname="cs_SingleInputName"/>
		<ics:setvar name="currentValue" value='<%= attributeValue %>' />
		<ics:setvar name="currentInput" value='<%= ics.GetVar("cs_SingleInputName") %>' />

		<ics:if condition="<%= allowEmbeddedLinks %>">
		<ics:then>
			<ics:if condition='<%= !"true".equals(ics.GetVar("embeddedlink_inited")) %>'>
			<ics:then>
				<ics:setvar name="enableEmbeddedLinks" value='1' />
			</ics:then>
			</ics:if>
		</ics:then>
		<ics:else>
			<ics:setvar name="enableEmbeddedLinks" value='0' />
		</ics:else>
		</ics:if>

<%--
		 Updated  : This is  the Script To interface create an instance of
					TinyMCE.  Replace and Build

		 So I think that this covers all the current options related to creation of the instances.
		 Of course, you could use directly the TinyMCE constructor,
		 but unless you are absolutely sure that you know what you are doing,
		 you should avoid it.
--%>
<%
		String defaultFormStyle = "";
		String tinymceWidth = ics.GetVar("WIDTH");
		if ("".equals(tinymceWidth) || "px".equalsIgnoreCase(tinymceWidth))
			defaultFormStyle = "defaultFormStyle";

		boolean rtl = Boolean.valueOf(ics.GetSSVar("supportRTL"));
		if(rtl) {
%>
		<div class='<%= defaultFormStyle %>' style="margin-left: 22px">
<% } else { %>
		<div class='<%= defaultFormStyle %>' style="margin-right: 22px">
<% } %>
			<input 	type="hidden"
					id='hidden_<ics:getvar name="currentInput"/>'
					name='<ics:getvar name="currentInput"/>'
					value='<string:stream variable="currentValue"/>' />
<%
		//Keep textarea empty if this is new fck instance from "Add Another" button.
		String name = ics.GetVar("cs_MultipleInputName");
		String count = name.substring(name.lastIndexOf("_") + 1, name.length());
		String ret = "";
		if (Integer.parseInt(count) <= attributeValueList.numRows())
		{
			EmbeddedLink link = new EmbeddedLink(ics,ics.GetVar("currentValue"), false, false, true);
			ret = link.evaluate();
			ics.SetVar("retVal",ret);
		}
		%>
			<satellite:link pagename="OpenMarket/Xcelerate/Actions/FCKEditorRenderer" outstring='rendererURL'>
				<satellite:parameter name="fieldData" value='<%=ics.GetVar("currentValue")%>'/>
				<satellite:parameter name="mode" value='inspect'/>
			</satellite:link>

			<%-- Fix for bug 19188681 --%>
			<ics:listget listname="AttrValueList" fieldname="ordinal" output="attrOrdinal" />
			<%
			String _attrOrdinal = ics.GetVar("attrOrdinal");
			if(Utilities.goodString(_attrOrdinal)){
				_attrOrdinal = String.valueOf(((int)Double.parseDouble(_attrOrdinal)));
			}

			String result = (String) ics.GetVar("AttrName");
			result = result.replaceAll("[^\\w]","");
			String frameName = "iframe_" + result + "_" + _attrOrdinal;
			%>
			<script>
				var done_<%= frameName %> = false;
				var run_<%= frameName %> = function () {
					var rendererURL = '<%= ics.GetVar("rendererURL") %>';

					var queryString = {};
					var actionURL;
					rendererURL.replace(
						new RegExp("([^?=&]+)(=([^&]*))?", "g"), function($0, $1, $2, $3) {
							if (actionURL == null) {
								actionURL = $1;
							} else {
								queryString[$1] = $3;
							}
						}
					);
					// Return false if there is no data. No need to submit the empty data.
					if(queryString['fieldData'].trim().length == 0) {
						return false;
					}
					var frameForm = document.createElement("form");
					frameForm.target = '<%= frameName %>';
					frameForm.method = "post";
					frameForm.action = actionURL;

					var fieldDataInput = document.createElement("input");
					fieldDataInput.type = "hidden";
					fieldDataInput.name = "fieldData";

					fieldDataInput.value = decodeURIComponent(queryString['fieldData'].replace(/\+/g, " "));
					frameForm.appendChild(fieldDataInput);

					var authkey = document.getElementsByName("_authkey_")[0];
					frameForm.innerHTML += "<input type='hidden' name='_authkey_' value='" + authkey.value + "'/>";
					frameForm.innerHTML += "<input type='hidden' name='pagename' value='" + decodeURIComponent(queryString['pagename']) + "'/>";
					frameForm.innerHTML += "<input type='hidden' name='mode' value='" + queryString['mode'] + "'/>";

					document.body.appendChild(frameForm);    // Added this for FF
					frameForm.submit();
				}

			</script>
			<div id='pdiv_<ics:getvar name="currentInput"/>' style="position:relative">
				<div id='div_<ics:getvar name="currentInput"/>' style="position:absolute;width:100%;height:100%" tabindex="0" role="button" title="<%=ics.GetVar("currentAttrName") %>"></div>
				<iframe name='<%= frameName %>' title="TinyMCE content" src="about:blank" style='padding:4px 0 0 4px; width:580px; min-height:50px; border:1px solid #E6E6E6' onload='if (!this.contentDocument.body.innerHTML) run_<%= frameName %>();'></iframe>
			</div>

			 <textarea id='<ics:getvar name="currentInput"/>'
					style='display:none; padding:4px 4px 0 4px; width: <ics:getvar name="WIDTH"/>; height: <ics:getvar name="HEIGHT"/>; border:1px solid #E6E6E6'>
			<%
			if (Integer.parseInt(count) <= attributeValueList.numRows())
			{
			%>
			<%-- Encode the returned value to use it in the text area.--%>
			<string:encode variable="retVal" varname="retValEnc"/>
			<%= ics.GetVar("retValEnc") %>
			<%}%>
			</textarea>

			<script type="text/javascript">
				var TOOLBAR;
				var tinymceConfig={};
				var tinymceCnf={};
				tinymceCnf.csRootContext = '<%=ics.GetVar("cgipath")%>' ;
				tinymceCnf.assetId = '<ics:getvar name="ContentDetails:id"/>';
				tinymceCnf.assetName = '<ics:getvar name="ContentDetails:name"/>';
				tinymceCnf.assetType = '<ics:getvar name="AssetType"/>';
				tinymceCnf.urlFCKEditorRenderer = '<ics:getvar name="urlFCKEditorRenderer"/>';
				tinymceCnf.cs_environment = '<ics:getvar name="cs_environment"/>';
				tinymceCnf.CSSitePath = '<ics:getvar name="cgipath"/>';
				tinymceCnf.AutoDetectLanguage = 'false';
				tinymceCnf.contentsLangDirection = 'ltr';
				tinymceCnf.BasePath = '<ics:getvar name="basepath"/>';
				tinymceCnf.doHtml = "true"  ;
				tinymceCnf.doHtmlEncoding = true ;
				tinymceCnf.fieldName = '<ics:getvar name="currentInput"/>';
				tinymceCnf.editingstyle = '<ics:getvar name="EditingStyle"/>';

				<%
					if (null != ics.GetVar("showSiteTree")) {
				%>
					tinymceCnf.showSiteTree = '<%=ics.GetVar("showSiteTree").trim()%>';
				<%
					}
				%>

				function loadTinyMCE_<%=_genId%>()
				{
					var configobj,
					ckid = "<ics:getvar name="currentInput"/>",
					config_<%=_genId%>={},TOOLBAR;
<%
					if (Utilities.goodString(ics.GetVar("CONFIGOBJ"))) {
%>
							configobj = <%=ics.GetVar("CONFIGOBJ")%>;
<%					}

					if (Utilities.goodString(ics.GetVar("CONFIG"))) {
%>							config_<%=_genId%>.customConfig='<%=ics.GetVar("CONFIG")%>';
<%					} else {
%>						config_<%=_genId%>.customConfig='config.js';
<%					}
%>

					if('<ics:getvar name="WIDTH"/>' != '<%=DEFAULT_WIDTH%>'){
						config_<%=_genId%>.width = '<ics:getvar name="WIDTH"/>';
					}

					if('<ics:getvar name="HEIGHT"/>' != '<%=DEFAULT_HEIGHT%>'){
						config_<%=_genId%>.height = '<ics:getvar name="HEIGHT"/>';
					}

					if('<ics:getvar name="RESIZE"/>' != ''){
						config_<%=_genId%>.resize_enabled= ('<%=ics.GetVar("RESIZE")%>'.toUpperCase()=='TRUE')? true: false;
					}

					config_<%=_genId%>.assetId = '<ics:getvar name="ContentDetails:id"/>';
					config_<%=_genId%>.fieldName= '<ics:getvar name="currentInput"/>';
					config_<%=_genId%>.fieldDesc = '<string:stream variable="currentAttrName"/>';
					config_<%=_genId%>.editingstyle = '<%=ics.GetVar("EditingStyle")%>';
					// Retrieve one of the Attribute Property
					// To determine if we allow Embedded Asset Links
					config_<%=_genId%>.enableEmbeddedLinks = '<ics:getvar name="enableEmbeddedLinks"/>';
<%
					if (Utilities.goodString(ics.GetVar("ALLOWEDASSETTYPES"))) {
%>
					config_<%=_genId%>.allowedassettypes = '<ics:getvar name="ALLOWEDASSETTYPES"/>';
<%
					} if (Utilities.goodString(ics.GetVar("SCRIPT"))) {
%>
					config_<%=_genId%>.script = '<ics:getvar name="SCRIPT"/>';
<%
					} if (Utilities.goodString(ics.GetVar("IMAGEASSETTYPE"))) {
%>
					config_<%=_genId%>.imageassettype = '<ics:getvar name="IMAGEASSETTYPE"/>';
<%
					}

					if (Utilities.goodString(ics.GetVar("IMAGEPICKERID"))) {
						IAssetTypeManager atm = AssetTypeManagerFactory.getATM(ics);
						ics.SetObj("atmgr", atm.locateAssetManager("AttrTypes"));
						IAttributeTypeManager iam = (IAttributeTypeManager) ics.GetObj("atmgr");
						try {
							IPresentationObject presInst = iam.getPresentationObject(ics.GetVar("IMAGEPICKERID"));
							String ASSETTYPENAME = presInst.getPrimaryAttributeValue("ASSETTYPENAME");
							String ATTRIBUTETYPENAME = presInst.getPrimaryAttributeValue("ATTRIBUTETYPENAME");
							String ATTRIBUTENAME = presInst.getPrimaryAttributeValue("ATTRIBUTENAME");
		%>
							config_<%=_genId%>.ip_assettypename = "<%=ASSETTYPENAME%>";
							config_<%=_genId%>.ip_attributetypename = "<%=ATTRIBUTETYPENAME%>";
							config_<%=_genId%>.ip_attributename = "<%=ATTRIBUTENAME%>";
		<%
						} catch(Exception e){
		%>
							<ics:logmsg severity="warn"
										msg='<%="Cannot locate the imagepicker.Please check the id " + ics.GetVar("IMAGEPICKERID")%>'/>
		<%
						}
					}

					if (!Utilities.goodString(ics.GetVar("TOOLBAR"))) {
					%>
						config_<%=_genId%>.toolbar = '<%=ics.GetVar("DEFAULT_TOOLBAR")%>';
					<%} else {%>
						config_<%=_genId%>.toolbar = '<%=ics.GetVar("TOOLBAR")%>';
					<%}%>

					<ics:if condition='<%="exists".equalsIgnoreCase(ics.GetVar("DEPTYPE"))%>'>
					<ics:then>
							config_<%=_genId%>.DEPTYPE = "true";
					</ics:then>
					<ics:else>
							config_<%=_genId%>.DEPTYPE = "false";
					</ics:else>
					</ics:if>
					if (configobj) {
						addNewKeys(configobj, config_<%=_genId%>);
					}
					addNewKeys(tinymceCnf, config_<%=_genId%>);
					tinymceConfig = config_<%=_genId%>;

					//Load TinyMCE Editor
					if(config_<%=_genId%>.toolbar == '#DEFAULT_TOOLBAR#'){
						TINYMCE_CONFIG.toolbar = TINYMCE_CONFIG.toolbar_SITES;
					}else{
						TINYMCE_CONFIG.toolbar = TINYMCE_CONFIG['toolbar_'+'<%=ics.GetVar("TOOLBAR")%>'];
					}
					TINYMCE_CONFIG.selector = '#<ics:getvar name="currentInput"/>';
					TINYMCE_CONFIG.content_style = '.focusIncluded [_fwid*="_CSEMBEDTYPE_"] { display: block!important; outline: 3px dotted grey; }';
					TINYMCE_CONFIG.init_instance_callback = function (editor) {
						editor.setContent(`<ics:getvar name="retVal"/>`, {format : 'raw'});
					}
					// set the locale into tinymce editor
                    var userLocale = '<ics:getssvar name="locale"/>';
                    if (userLocale === 'pt_BR') userLocale = 'pt-br';
                    else if (userLocale === 'zh_CN') userLocale = 'zh-cn';
                    else userLocale = userLocale.substring(0,2);
                    TINYMCE_CONFIG.language = userLocale || navigator.language;
					tinymce.init(TINYMCE_CONFIG);
					document.getElementById( '<ics:getvar name="currentInput"/>' ).style.removeProperty("display");
				}

			<%-- [KGF] don't create yet if LAZYLOAD is false! Instead, show a textarea and add an onclick. --%>
			<ics:if condition='<%="false".equals(ics.GetVar("LAZYLOAD"))%>'>
			<ics:then>
				<%-- replace textarea immediately with the new tinymce --%>
				loadTinyMCE_<%=_genId%>()
			</ics:then>
			<ics:else>
				<%-- hook up onFocus for ContentPane to lazy loaded tinymce --%>
				dojo.addOnLoad(function(){
					require(["dijit/a11yclick", "dojo/on"], function(a11yclick, on){
						var div_<%=_genId%> = dojo.byId('div_<ics:getvar name="currentInput"/>');
						on(div_<%=_genId%>, a11yclick, function() {loadTinyMCE_<%=_genId%>(); dojo.destroy('pdiv_<ics:getvar name="currentInput"/>'); })
					});
				});
			</ics:else>
			</ics:if>
				// Function to add the new keys to the config object
				function addNewKeys(fromObj,toObj){
					if(toObj['width'] == '#DEFAULT_WIDTH#' && fromObj['width']){
						toObj['width'] = fromObj['width'];
					}

					if(toObj['height'] == '#DEFAULT_HEIGHT#'  && fromObj['height']){
						toObj['height'] = fromObj['height'];
					}

					if(toObj['toolbar'] == '#DEFAULT_TOOLBAR#'  && fromObj['toolbar']){
						toObj['toolbar'] = fromObj['toolbar'];
					}

					if(((toObj['resize_enabled'] && toObj['resize_enabled'].toString() == '') ||  typeof(toObj['resize_enabled']) == "undefined")  && fromObj['resize_enabled']){
						toObj['resize_enabled'] = fromObj['resize_enabled'];
					}
					for (var key in fromObj) {
						if(typeof toObj[key]=="undefined")
							toObj[key] = fromObj[key];
					}
				}
			</script>
		</div>
		<ics:removevar name="currentValue" />

	</ics:then>
	<ics:else>
		<ics:if condition="<%= isUrlField %>">
		<ics:then>
			<ics:if condition="<%= !hasValues %>">
			<ics:then>
				<ics:resolvevariables name="CS.UniqueID.txt" output="filename" />
				<string:encode variable="cs_MultipleInputName" varname="cs_MultipleInputName"/>
				<input 	type="hidden"
					name="<ics:getvar name="cs_MultipleInputName"/>_file"
					value="<ics:getvar name="filename"/>" />
			</ics:then>
			</ics:if>
		</ics:then>
		</ics:if>
		<ics:setvar name="currentInput" value='<%= ics.GetVar("cs_MultipleInputName") %>' />

<%
		String showSiteTree = "";
		if (null != ics.GetVar("showSiteTree")) {
			showSiteTree = ics.GetVar("showSiteTree").trim();
		}

		String allowedassettypes = "";
		if (Utilities.goodString(ics.GetVar("ALLOWEDASSETTYPES"))) {
			allowedassettypes = ics.GetVar("ALLOWEDASSETTYPES");
		}

		String script = "";
		if (Utilities.goodString(ics.GetVar("SCRIPT"))) {
			script = ics.GetVar("SCRIPT");
		}

		String imageassettype="";
		if (Utilities.goodString(ics.GetVar("IMAGEASSETTYPE"))) {
			imageassettype = ics.GetVar("IMAGEASSETTYPE");
		}

		String ASSETTYPENAME = "";
		String ATTRIBUTETYPENAME = "";
		String ATTRIBUTENAME = "";
		if (Utilities.goodString(ics.GetVar("IMAGEPICKERID"))) {
			IAssetTypeManager atm = AssetTypeManagerFactory.getATM(ics);
			ics.SetObj("atmgr", atm.locateAssetManager("AttrTypes"));
			IAttributeTypeManager iam = (IAttributeTypeManager) ics.GetObj("atmgr");
			try {
				IPresentationObject presInst = iam.getPresentationObject(ics.GetVar("IMAGEPICKERID"));
				ASSETTYPENAME = presInst.getPrimaryAttributeValue("ASSETTYPENAME");
				ATTRIBUTETYPENAME = presInst.getPrimaryAttributeValue("ATTRIBUTETYPENAME");
				ATTRIBUTENAME = presInst.getPrimaryAttributeValue("ATTRIBUTENAME");
			} catch (Exception e) {
%>
				<ics:logmsg severity="warn"
							msg='<%="Cannot locate the imagepicker.Please check the id " + ics.GetVar("IMAGEPICKERID")%>' />
<%
			}
		}
		String	_toolbar= ("#DEFAULT_TOOLBAR#".equals(ics.GetVar("TOOLBAR"))) ? DEFAULT_TOOLBAR_VALUE : ics.GetVar("TOOLBAR");
		boolean _resize = (("TRUE".equals(ics.GetVar("RESIZE").toUpperCase()))? true: false);
		String width = ics.GetVar("WIDTH");
		String height= ics.GetVar("HEIGHT");
		String inline_params="";
		System.out.println("TINYMCE _toolbar : "+_toolbar);
		if (Utilities.goodString(ics.GetVar("CONFIGOBJ"))) {
			String configobj=ics.GetVar("CONFIGOBJ");
			String[] tokens = configobj.replaceAll("[{}'\"]","").split(",");
			for (String token : tokens) {
				int delim_index = token.indexOf(':');
				String KEY = token.substring(0,delim_index);
				String VALUE = token.substring(delim_index+1);
				if(KEY.equals("toolbar")) { _toolbar = VALUE; continue; }
				if(KEY.equals("resize_enabled")) { _resize = Boolean.valueOf(VALUE); continue; }
				if(KEY.equals("width")) { width = VALUE; continue; }
				if(KEY.equals("height")) { height = VALUE; continue; }
				if(KEY.equals("script")) { script = VALUE; continue; }
				inline_params = inline_params + ",'"+ KEY + "': '"+VALUE + "'";
			}
		}

		if (Utilities.goodString(ics.GetVar("CONFIG"))) {
			inline_params = inline_params+ ",'customConfig': '"+ics.GetVar("CONFIG")+"'";
		}

		String DEPTYPE = "false";
		if ("exists".equals(ics.GetVar("DEPTYPE")))
			DEPTYPE = "true";
		String fieldNm = "_mul_"+ics.GetVar("currentInput");

		String editorParams = "{'config': {'csRootContext': '" + ics.GetVar("cgipath") + "'," +
									  "'height': '" + height + "'," +
									  "'resize_enabled': " + _resize + ","+
									  "'assetId': '" + ics.GetVar("ContentDetails:id") + "'," +
									  "'assetName': '" + ics.GetVar("ContentDetails:name") + "'," +
									  "'assetType': '" + ics.GetVar("AssetType") + "'," +
									  "'editingstyle': '" + ics.GetVar("EditingStyle") + "'," +
									  "'urlFCKEditorRenderer': '" + ics.GetVar("urlFCKEditorRenderer") + "'," +
									  "'fieldName': '" + fieldNm + "'," +
									  "'fieldDesc': '" + ics.GetVar("currentAttrName") + "'," +
									  "'showSiteTree': '" + showSiteTree + "'," +
									  "'enableEmbeddedLinks': '" + (("TRUE".equals(ics.GetVar("AllowEmbeddedLinks").toUpperCase()))? 1: 0) + "'," +
									  "'cs_environment': '" + ics.GetVar("cs_environment") + "'," +
									  "'CSSitePath': '" + ics.GetVar("cgipath") + "'," +
									  "'AutoDetectLanguage': 'false'," +
									  "'allowedassettypes': '" + allowedassettypes + "'," +
									   addScriptParam(ics) +
									  "'ip_assettypename': '" + ASSETTYPENAME + "'," +
									  "'ip_attributetypename': '" + ATTRIBUTETYPENAME + "'," +
									  "'ip_attributename': '" + ATTRIBUTENAME + "'," +
									  "'imageassettype': '" + imageassettype + "'," +
									  "'toolbar': '" + _toolbar + "'," +
									  "'BasePath': '" + ics.GetVar("basepath") + "'," +
									  "'doHtml': 'true'," +
									  "'doHtmlEncoding': 'true'," +
									  "'DEPTYPE': '" + DEPTYPE + "'" +
									  inline_params+
									 "}, " +
							 "'width': '" + width + "', " +
							 "'isComplexData': '" + true + "'" +
						  "}";
%>

<%!
   public String addScriptParam(ICS ics) {
		String scriptStr = "", _script="";

		if (Utilities.goodString(ics.GetVar("SCRIPT"))) {
			_script = ics.GetVar("SCRIPT");
		}
		if (_script != null && _script.trim().length() > 0){
			scriptStr = "'script': '" + _script + "',";
		}
		return scriptStr;
   }
%>
		<ics:callelement element="OpenMarket/Gator/AttributeTypes/RenderMultiValuedTextEditor">
			<ics:argument name="editorName" 	value="fw.ui.dijit.form.FormTinyMCE" />
			<ics:argument name="editorParams" 	value='<%= editorParams %>' />
			<ics:argument name="multiple" 		value="true" />
			<ics:argument name="isUrlField"		value="<%= String.valueOf(isUrlField) %>" />
			<ics:argument name="maximumValues" 	value="<%= maximumValues %>" />
		</ics:callelement>

		<ics:if condition='<%="multiple-ordered".equals(ics.GetVar("EditingStyle"))%>'>
		<ics:then>
			<ics:if condition='<%=ics.GetVar("__fckeditorscripts") == null%>'>
			<ics:then>
				<ics:setvar name="__fckeditorscripts" value="true" />
			</ics:then>
			</ics:if>
		</ics:then>
		</ics:if>
	</ics:else>
	</ics:if>

	</td>
</tr>

</cs:ftcs>
