<%@ page import="au.org.ala.volunteer.Template" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="${grailsApplication.config.ala.skin}"/>
        <g:set var="entityName" value="${message(code: 'template.label', default: 'Template')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
        <style type="text/css">

            table.bvp-expeditions thead th {
                text-align: left;
            }

        </style>
        <script type="text/javascript">

        </script>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="inner">
            <h1><g:message code="default.list.label" args="[entityName]" /></h1>
            <cl:messages />
            <div class="list">
                <table class="bvp-expeditions">
                    <thead>
                        <tr>

                            <g:sortableColumn property="name" title="${message(code: 'template.name.label', default: 'Name')}" />
                            <g:sortableColumn property="author" title="${message(code: 'template.author.label', default: 'Author')}" />
                            <g:sortableColumn property="viewName" title="${message(code: 'template.viewName.label', default: 'View Name')}" />

                            <th></th>

                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${templateInstanceList}" status="i" var="templateInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                            <td>${fieldValue(bean: templateInstance, field: "name")}</td>
                            <td>${fieldValue(bean: templateInstance, field: "author")}</td>
                            <td>${fieldValue(bean: templateInstance, field: "viewName")}</td>

                            <td>
                                <a class="button" style="margin-top: 6px" href="${createLink(controller:'template', action:'edit', id:templateInstance.id)}">Edit</a>
                                <a class="button" style="margin-top: 6px" href="${createLink(controller:'template', action:'preview', id:templateInstance.id)}">Preview</a>
                            </td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${templateInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
