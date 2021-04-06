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

        def filter = params.activeFilter
        params.activeFilter = filter ?: TaskFilter.showAll
        def max = Math.min(params.max ? params.int('max') : 10, 20)
        params.max = max
        def order = params.order ?: 'asc'
        params.order = order
        def sort = params.sort ?: 'id'
        params.sort = sort
        def offset = (params.offset ?: 0) as int
        params.offset = offset

        def tasks = Task.findAllByProject(project)
        def filteredTasks

        switch (filter) {
            case TaskFilter.showReadyForTranscription.toString():
                filteredTasks = tasks.findAll {
                    def timeoutWindow = System.currentTimeMillis() - ((grailsApplication.config.viewedTask.timeout as long) ?: 7200000)
                    it.fullyTranscribedBy == null && (it.lastViewed == null || it.lastViewed < timeoutWindow)
                }
                break
            case TaskFilter.showTranscriptionLocked.toString():
                filteredTasks = tasks.findAll {
                    def timeoutWindow = System.currentTimeMillis() - ((grailsApplication.config.viewedTask.timeout as long) ?: 7200000)
                    !(it.fullyTranscribedBy == null && (it.lastViewed == null || it.lastViewed < timeoutWindow))
                }
                break
            default:
                filteredTasks = tasks
                break
        }

        def fromIndex = Math.min(offset, filteredTasks.size())
        def toIndex = Math.min(offset + max, filteredTasks.size())

        def paginatedTasks

        if(filteredTasks.size() > 0) {
            paginatedTasks = filteredTasks.subList(fromIndex, toIndex)
        } else {
            paginatedTasks = filteredTasks
        }

        render(view: 'overview', model: [
                project     : project,
                auditService: auditService,
                userId      : userId,
                tasks       : paginatedTasks,
                tasksAmount : filteredTasks.size()
        ])
    }

    def showPreview() {}

}
