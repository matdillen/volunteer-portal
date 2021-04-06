<g:if test="${task?.isAvailableForTranscription(userId)}">
    <a href="${createLink(controller: 'transcribe', action: 'showTaskWithId', params: [projectId: project?.id, taskId: task?.id])}"
       class="btn btn-primary" role="button">
        <g:message code="overview.transcribe"/>
    </a>
</g:if>
<g:else>
    <vpf:taskTopicButton task="${task}" class="btn-info"/>
</g:else>