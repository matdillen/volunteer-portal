<%@ page contentType="text/html; charset=UTF-8" %>
<div class="col-sm-12 col-md-6">
    <div class="thumbnail">
        <div class="zoom"
             style="background-image: url('${task?.multimedia?.first()?.filePath}');">
            <img src="${task?.multimedia?.first()?.filePathToThumbnail}" alt="task thumbnail"/>

        </div>
        <div class="caption">
                <div class="actions">
                    <g:if test="${!auditService.isTaskLockedForUser(task, userId)}">
                    <a href="${createLink(controller: 'transcribe', action: 'showTaskWithId', params: [projectId: project?.id, taskId: task?.id])}"
                       class="btn btn-primary" role="button">
                        <g:message code="overview.transcribe"/>
                    </a>
                    </g:if>
                    <a href="${createLink(controller: 'overview', action: 'showPreview', params: [projectId: project?.id, taskId: task?.id])}"
                       class="btn btn-primary" role="button">
                        <g:message code="overview.preview"/>
                    </a>
                </div>

        </div>
    </div>
</div>