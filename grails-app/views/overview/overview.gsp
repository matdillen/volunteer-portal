<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="au.org.ala.volunteer.ProjectActiveFilterType; au.org.ala.volunteer.ProjectStatusFilterType; au.org.ala.volunteer.Project; au.org.ala.volunteer.Task;" %>

<html xmlns="http://www.w3.org/1999/html">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="${grailsApplication.config.ala.skin}"/>
    <g:set var="entityName" value="${message(code: 'project.label', default: 'Project')}"/>
    <title><cl:pageTitle title="${g.message(code: "default.list.label", args: ['Expedition'])}"/></title>
    <asset:stylesheet src="digivol-image-resize"/>
</head>

<body class="digivol">

<cl:headerContent title="${project?.i18nName}" selectedNavItem="expeditions">
    <p>${project?.i18nShortDescription}</p>
</cl:headerContent>

<section id="main-content">
    <div class="container">
        <div class="row">
            <div class="col-sm-12">
                <div class="row">
                    <g:each in="${tasks}" status="i" var="task">
                        <g:render template="taskCard" model="[task: task, project: project, auditService: auditService, userId: userId]"/>
                        <g:if test="${(i + 1) % 4 == 0}">
                            <div class="clearfix visible-md-block visible-lg-block"></div>
                        </g:if>
                    </g:each>
                    <div class="pagination">
                        <g:paginate total="${tasksAmount}" prev="" next=""
                                    action="showProjectOverview"
                                    id="${params.id}"
                                    params="${[q: params.q] + (extraParams ?: [:])}"/>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

</body>
</html>