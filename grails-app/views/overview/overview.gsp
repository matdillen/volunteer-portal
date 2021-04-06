<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="au.org.ala.volunteer.TaskFilter; au.org.ala.volunteer.Project; au.org.ala.volunteer.Task;" %>

<html xmlns="http://www.w3.org/1999/html">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="${grailsApplication.config.ala.skin}"/>
    <g:set var="entityName" value="${message(code: 'project.label', default: 'Project')}"/>
    <title><cl:pageTitle title="${g.message(code: "default.list.label", args: ['Expedition'])}"/></title>
    <asset:stylesheet src="digivol-image-resize"/>
    <style>
    .zoom {
        position: relative;
        cursor: zoom-in;
        display: block;
        min-height: 250px;
        background-size: 400%;
    }

    .zoom:hover img {
        opacity: 0;
    }

    .zoom img {
        max-width: 100%;
        max-height: 100%;
        position: absolute;
        object-fit: fill;
        pointer-events: none;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        transition: opacity 0.5s;
    }

    .actions {
        width: fit-content;
        margin: auto;
    }
    </style>
</head>

<body class="digivol">

<cl:headerContent title="${project?.i18nName}" selectedNavItem="expeditions">
    <p>${project?.i18nShortDescription}</p>
</cl:headerContent>

<section id="main-content">
    <div class="container">
        <div class="row" style="padding-bottom: 10px;">
            <div class="col-sm-12">
                <g:set var="activeFilter" value="${params.activeFilter ?: TaskFilter.showAll}"/>
                <g:set var="urlParams"
                       value="${[sort: params.sort ?: "", order: params.order ?: "", offset: 0, q: params.q ?: "", mode: params.mode ?: "", activeFilter: activeFilter]}"/>

                <div class="btn-group pull-right" style="padding-right: 10px">
                    <g:each in="${TaskFilter.values()}" var="mode">
                        <g:set var="href" value="?${(urlParams + [activeFilter: mode]).collect { it }.join('&')}"/>
                        <a href="${href}"
                           class="btn btn-warning btn-small ${activeFilter.toString() == mode?.toString() ? "active" : ""}">${message(code: mode.i18nLabel)}</a>
                    </g:each>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-sm-12">
                <div class="row">
                    <g:each in="${tasks}" status="i" var="task">
                        <g:render template="taskCard"
                                  model="[task: task, project: project, auditService: auditService, userId: userId]"/>
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
<script>
    let thumbnails = document.getElementsByClassName('zoom');
    for (let i = 0; i < thumbnails.length; i++) {
        thumbnails[i].addEventListener('mousemove', (e) => {
            const zoomer = e.currentTarget;
            let offsetX, offsetY;
            e.offsetX ? offsetX = e.offsetX : offsetX = e.touches[0].pageX
            e.offsetY ? offsetY = e.offsetY : offsetX = e.touches[0].pageX
            x = offsetX / zoomer.offsetWidth * 100
            y = offsetY / zoomer.offsetHeight * 100
            zoomer.style.backgroundPosition = x + '% ' + y + '%';
        })
    }

</script>
</body>
</html>