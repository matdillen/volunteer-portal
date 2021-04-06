<%@ page contentType="text/html; charset=UTF-8" %>
<div class="col-sm-12 col-md-6">
    <div class="thumbnail">
        <div class="quickPreview"
             style="background-image: url('${task?.multimedia?.first()?.filePathToThumbnail}');">
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
                <button id="${task?.id}" class="btn btn-primary btnPreview" role="button">
                    <g:message code="overview.preview"/>
                </button>
            </div>

        </div>
    </div>
</div>