<%@ page import="org.springframework.context.i18n.LocaleContextHolder" contentType="text/html; charset=UTF-8" %>

<!doctype html>
<html>
<head>
    <meta name="google" value="notranslate">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="digivol-main"/>
    <meta name="section" content="home"/>
    <content tag="disableBreadcrumbs">true</content>
    <title><cl:pageTitle title="Policy"/></title>
    <content tag="selectedNavItem">bvp</content>
</head>

<body>
<cl:headerContent title="${message(code: 'default.about.label', default: 'About DigiVol')}">
    <%
        pageScope.crumbs = [
        ]
    %>
</cl:headerContent>
<section class="main-content">
    <div class="container" >
        <div class="row">
            <div class="col-sm-12">
                  <g:if test="${LocaleContextHolder.getLocale().getLanguage().equalsIgnoreCase('DE') }">
                      <g:render template="policy-de" ></g:render>
                  </g:if>
                  <g:if test="${LocaleContextHolder.getLocale().getLanguage().equalsIgnoreCase('FR')}">
                      <g:render template="policy-fr" ></g:render>
                  </g:if>
                  <g:if test="${LocaleContextHolder.getLocale().getLanguage().equalsIgnoreCase('EN') }">
                      <g:render template="policy-en" ></g:render>
                  </g:if>
                  <g:if test="${LocaleContextHolder.getLocale().getLanguage().equalsIgnoreCase('NL') }">
                      <g:render template="policy-nl" ></g:render>
                  </g:if>
            </div>

        </div>
    </div>

</section>

</body>
</html>
