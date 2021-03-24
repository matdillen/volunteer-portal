<%@ page contentType="text/html; charset=UTF-8" %>
<div class="col-sm-12 col-md-6 col-lg-3">
    <div class="thumbnail">
        <div>
            <div class="resize-and-crop"
                 style="display: block; text-align: center; min-height: 226px;">
                <img class="img-responsive cropme"
                     src="${task?.multimedia?.first()?.filePathToThumbnail}"
                     style="width: 100%; min-height: 226px; object-fit: cover;"/>
            </div>

            <div class="caption" style="background: transparent; position: absolute; z-index: 10; bottom: 20px; width: 95%">
                <!-- <h4 class="ellipsis">${task?.id}</h4> -->
                <div style="width: fit-content; margin: auto;">
                    <a href="#"
                       class="btn btn-primary" role="button">
                        <span class="glyphicon glyphicon-zoom-in"></span>
                    </a>

                <g:if test="${!auditService.isTaskLockedForUser(task, userId)}">
                    <a href="${createLink(controller: 'transcribe', action: 'showTaskWithId', params: [projectId: project?.id, taskId: task?.id])}"
                       class="btn btn-primary" role="button">
                        <span class="glyphicon glyphicon-log-in"></span>
                    </a>
                </g:if>
                </div>
            </div>
        </div>
    </div>
</div>