package au.org.ala.volunteer

class OverviewController {

    def userService
    def auditService

    def index() {
        if (params.id) {
            log.debug("index redirect to showProjectOverview: " + params.id)
            redirect(action: "showProjectOverview", id: params.id)
        } else {
            flash.message = message(code: 'transcribe.something_unexpected_happened')
            redirect(uri: "/")
        }
    }

    def showProjectOverview() {
        def project = Project.get(params.id)
        def userId = userService.currentUserId

        if (project == null) {
            log.error("Project not found for id: " + params.id)
            redirect(view: '/index')
        }

        log.debug("project id = " + params.id + " || msg = " + params.msg + " || prevInt = " + params.prevId)

        if (params.msg) {
            flash.message = params.msg
        }

        params.max = Math.min(params.max ? params.int('max') : 20, 200)
        params.order = params.order ?: 'asc'
        params.sort = params.sort ?: 'id'
        params.offset = params.offset ?: 0

        def tasksAmount = project?.tasks?.size()
        def tasks = Task.findAllByProject(project, params)

        render(view: 'overview', model: [
                project     : project,
                auditService: auditService,
                userId      : userId,
                tasks       : tasks,
                tasksAmount : tasksAmount
        ])
    }

}
