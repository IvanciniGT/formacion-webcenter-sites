<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"
%><%@ taglib prefix="fragment" uri="futuretense_cs/fragment.tld"
%><%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"
%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"
%><%@ page import="java.text.*" 
%><%@ page import="java.util.*" 
%><cs:ftcs>
<!--
	Setting site locale as locale for formatDate, other wise it take browsers default locale as locale for formatDate.
	We already set 'en_US' as insite locale for avisports in navbar.jsp, using the same here for date locale
-->
<fmt:setLocale value="en_US"/>
<fmt:formatDate value="${asset.postDate}" dateStyle="long" type="date" var="formattedDate" />
<% final String pattern = ((SimpleDateFormat) DateFormat.getDateInstance(DateFormat.LONG, new Locale("en", "US"))).toPattern();
String datePatternString = "Date Format: " + pattern; 
request.setAttribute("datePatternString", datePatternString);%>
<div class="top-section">
	<span class="section-title">
		<fragment:include name="articleCategoryLink"/>
	</span>
	<span class="date"><insite:edit field="postDate" value='${formattedDate}' 
									params="{constraints: {formatLength: 'long'}, locale:'en-us', title:'${datePatternString}' , noValueIndicator: '[ enter post date ]', width: '150px'}"/>
	</span>
</div>
<div class="title-section">
	<h1><insite:edit field="headline" value="${asset.headline}" params="{noValueIndicator: '[ enter headline ]'}"/></h1>
	<h2><insite:edit field="subheadline" value="${asset.subheadline}" params="{noValueIndicator: '[ enter subheadline ]'}" /></h2>
	<span class="author">BY <insite:edit field="author" value="${asset.author}" params="{noValueIndicator: '[ enter author ]'}"/></span>
</div>
<div class="article">
	<div class="article-image">
		<fragment:include name="articleRelatedImageDetail"/>
	</div>
	<insite:edit field="body" value="${asset.body}" editor="tinymce"
				 params="{noValueIndicator: 'Enter body ', width: '627px', height: '500px', toolbar: 'Article', customConfig: '../avisports/tinymce/config.js'}"/>
	<fragment:include name="checkCommunity"/>
	<c:choose>
		<c:when test="${communityExists}">
<style>
.article .wsdk-widget .wsdk-widget-header,
.article .wsdk-widget .wsdk-widget-content { margin: 0 auto; width: 100%; clear: both; position: relative; min-width: 600px; }
.article .wsdk-postform { max-width: none; line-height: 20px; text-align: left; }
.article .wsdk-postform .wsdk-form-fieldset-label { width: 15%; }
.article .wsdk-form .wsdk-form-fieldset .wsdk-form-fieldset-field-textarea { width: 80%; }
.article .wsdk-widget .wsdk-widget-session .wsdk-session-bar .wsdk-session-bar-user .wsdk-session-bar-user-picture { width: 15%; }
.article .wsdk-form .wsdk-form-fieldset .wsdk-form-fieldset-field-actions { margin-top: 5px; }
</style>
			<div id="comments_container<%=ics.GetVar("cid")%>"></div>
			<%ics.SetVar("cgurl", ics.GetProperty("cg.production.url", "futuretense_xcel.ini", true));%>
			<script type="text/javascript">
			
				cos = window.cos || {};

				cos.pageWidgets = cos.pageWidgets || [];

 

                cos.pageWidgets.push({name: "wsdk.comments",

                                version: "1.5",

                                elementID: "comments_container<%=ics.GetVar("cid")%>",

                                attributes: {"site_id":"avisports","resource_id":"<%=ics.GetVar("cid")%>","resource_type":"other","comment_post_status":"open"}});

                                setTimeout(

                                                                    function(){if ((typeof(wsdk) == 'undefined') || (typeof(wsdk.comments) == 'undefined')) {document.getElementById('comments_container<%=ics.GetVar("cid")%>').innerHTML = "<div style='font-family: Tahoma, Verdana, Geneva, sans-serif;font-size: 12px;color: #333333;border: 1px solid #dbdfe1;padding-left: 5px;padding-top: 4px;height: 22px;'>Comments is unavailable right now. Please contact the site administrator.</div>";}}

                                           ,30000);

   

				cos.pageScripts = cos.pageScripts || [];

				cos.pageScripts.push('wsdk.comments');

				cos.pageScripts.push('poll');

				(function()

				{

					var oldOnloadHandler = window.onload || function()

					{

					};

					if (!oldOnloadHandler.alreadyProcessed)

					{

						window.onload = function()

						{

							var script = document.createElement('script');

							script.src = '<%=ics.GetVar("cgurl")%>/wsdk/widget/'

									+ cos.pageScripts.join(':') + '.js?site_id=avisports';

							script.type = 'text/javascript';

							script.charset = 'utf-8';

							document.getElementsByTagName("head").item(0).appendChild(script);

							oldOnloadHandler.apply(this, arguments);

						};

						window.onload.alreadyProcessed = true;

					}

			 

				})();

			</script>
		</c:when>
	</c:choose>
 </div>
</cs:ftcs>