package au.org.ala.volunteer

import org.codehaus.groovy.grails.commons.ConfigurationHolder
import javax.imageio.ImageIO
import java.awt.image.BufferedImage
import com.thebuzzmedia.imgscalr.Scalr

class TaskService {

    javax.sql.DataSource dataSource
    def config = ConfigurationHolder.config

    static transactional = true

    def serviceMethod() {}

  /**
   * This could be a large result set for a system with many registered users.
   */
    Map getTasksTranscribedByCounts(){
        def userTaskCounts = Task.executeQuery(
            """select t.fullyTranscribedBy as userId, count(t.id) as taskCount from Task t
               where t.fullyTranscribedBy is not null
               group by t.fullyTranscribedBy""")
        userTaskCounts.toMap()
    }

    /**
     *
     * @return Map of project id -> count
     */
    Map getProjectTaskCounts() {
        def projectTaskCounts = Task.executeQuery(
            """select t.project.id as projectId, count(t) as taskCount from Task t
               group by t.project.id""")
        projectTaskCounts.toMap()
    }

    /**
     *
     * @return Map of project id -> count
     */
    Map getProjectTaskTranscribedCounts() {
        def projectTaskCounts = Task.executeQuery(
            """select t.project.id as projectId, count(distinct t.id) as taskCount
               from Task t inner join t.fields as fields group by t.project.id""")
        projectTaskCounts.toMap()
    }

    /**
     *
     * @return Map of project id -> count
     */
    Map getProjectTaskFullyTranscribedCounts() {
        def projectTaskCounts = Task.executeQuery(
            """select t.project.id as projectId, count(t) as taskCount
               from Task t where t.fullyTranscribedBy is not null group by t.project.id""")
        projectTaskCounts.toMap()
    }

    /**
     *
     * @return Map of project id -> count
     */
    Map getProjectTaskValidatedCounts() {
        def projectTaskCounts = Task.executeQuery(
            """select t.project.id as projectId, count(t) as taskCount
               from Task t where t.fullyValidatedBy is not null group by t.project.id""")
        projectTaskCounts.toMap()
    }

    /**
     * Get the next task for this user
     *
     * @param userId
     * @return
     */
    Task getNextTask(String userId) {

        def tasks = Task.executeQuery(
            """select t from Task t
               left outer join t.viewedTasks viewedTasks
               where t.fullyTranscribedBy is null
               and (viewedTasks.userId != :userId or viewedTasks.userId is null)
               order by viewedTasks.lastView""", [userId: userId, max: 1])
        if (tasks) {
            tasks.get(0)
        } else {
            //show
            tasks = Task.executeQuery(
            """select t from Task t
               left outer join t.viewedTasks viewedTasks
               where t.fullyTranscribedBy is null
               order by viewedTasks.lastView""", [max: 1])
            if(!tasks.isEmpty()){
              tasks.get(0)
            } else {
              null
            }
        }
    }

    /**
     * Get the next task for this user
     *
     * @param userId
     * @return
     */
    Task getNextTask(String userId, Project project) {

        def tasks = Task.executeQuery(
            """select t from Task t
               left outer join t.viewedTasks viewedTasks
               where
               t.project.id = :projectId
               and t.fullyTranscribedBy is null
               and (viewedTasks.userId != :userId or viewedTasks.userId is null)
               order by viewedTasks.lastView""", [projectId: project.id, userId: userId, max: 1])
        if (tasks) {
            tasks.get(0)
        } else {
            //show
            tasks = Task.executeQuery(
            """select t from Task t
               left outer join t.viewedTasks viewedTasks
               where
               t.project.id = :projectId
               and t.fullyTranscribedBy is null
               order by viewedTasks.lastView""", [projectId: project.id, max: 1])
            if(!tasks.isEmpty()){
              tasks.get(0)
            } else {
              null
            }
        }
    }


    /**
     * Get the next task for this user
     *
     * @param userId
     * @return
     */
    Task getNextTaskForValidation() {

        def tasks = Task.executeQuery(
            """select t from Task t
               where t.fullyTranscribedBy is not null
               and t.fullyValidatedBy is null""", [max: 1])
        if (tasks) {
            tasks.get(0)
        } else {
            null
        }
    }

    /**
     * Get the next task for this user for this project.
     *
     * @param userId
     * @return
     */
    Task getNextTaskForProject(Project project, String userId) {

        def tasks = Task.executeQuery(
            """select t from Task t
               left outer join t.viewedTasks viewedTasks
               where t.project = :project and (viewedTasks.userId=:userId or viewedTasks.userId is null)
               order by viewedTasks.lastView""", [project:project, userId: userId, max: 1])
        if (tasks) {
            tasks.get(0)
        } else {
            null
        }
    }

    /**
     * Loads a CSV of external identifiers and external URLs
     * into the tables, loading the task and multimedia tables.
     *
     * @param projectId
     * @param text
     * @return
     */
    def loadCSV(Integer projectId, String text) {

        println("ProjectID: " + projectId)
        def project = Project.get(projectId)
        text.eachCsvLine { tokens ->
            //only one line in this case
            def task = new Task()
            task.project = project

            String imageUrl = ""

            if(tokens.length == 1){
              task.externalIdentifier = tokens[0]
              imageUrl = tokens[0]
            } else if(tokens.length == 2) {
              task.externalIdentifier = tokens[0]
              imageUrl = tokens[1]
            }

            if (!task.hasErrors()) {

                task.save(flush: true)

                def multimedia = new Multimedia()
                multimedia.task = task
                multimedia.filePath = imageUrl
                multimedia.save(flush: true)
                // GET the image via its URL and save various forms to local disk
                def filePath = copyImageToStore(imageUrl, task.id, multimedia.id)
                println("Saved..." + tokens + " -> " + filePath['raw'])

                filePath = createImageThumbs(filePath)

                multimedia.filePath = filePath.dir + "/" +filePath.raw
                multimedia.filePathToThumbnail = filePath.dir + "/" +filePath.thumb
                multimedia.save(flush: true)
                println("Saved..." + tokens)
            } else {
                println("Has errors..." + task.errors)
            }
        }
    }

    /**
     * GET the image via its URL and save various forms to local disk
     *
     * @param imageUrl
     * @return fileMap
     */
    def copyImageToStore = { String imageUrl, taskId, multimediaId ->
        def url = new URL(imageUrl)
        def filename = url.path.replaceAll(/\/.*\//, "") // get the filename portion of url
        def conn = url.openConnection()
        def fileMap = [:]
        try {
            println("content type = " + conn.contentType + " | " + filename)
            def dir = new File(config.images.urlPrefix + taskId + "/" + multimediaId)
            if (!dir.exists()) {
                println("Creating dir " + dir.absolutePath)
                dir.mkdirs()
            }
            fileMap.dir = dir.absolutePath
            def file = new File(dir, filename)
            file << conn.inputStream
            fileMap.raw = file.name
            return fileMap
            //file.close()
        } catch (Exception e) {
            println("Failed to load URL: " + imageUrl + ". " + e)
        }
    }

    /**
     * Create cropped/scaled versions of the raw image
     *
     * @param fieMap
     * @return fileMap
     */
    def createImageThumbs = { Map fileMap ->
        println("dir = " + fileMap.dir)
        println("raw = " + fileMap.raw)
        fileMap.thumb = fileMap.raw.replaceFirst(/\.(.{3,4})$/,'_small.$1') // add _small to filename
        println("thumbName = " + fileMap.thumb )
        BufferedImage srcImage = ImageIO.read(new FileInputStream(fileMap.dir + "/" +fileMap.raw))
        // Scale the image using the imgscalr library
        BufferedImage scaledImage = Scalr.resize(srcImage, 450);
        ImageIO.write(scaledImage, "jpg", new File(fileMap.dir + "/" + fileMap.thumb))

        return fileMap
    }

//        ConvertCmd cmd = new ConvertCmd();
//
//        // create the operation, add images and operators/options
//        IMOperation op = new IMOperation();
//        println(fileMap.raw)
//
//        op.addImage();
//        op.resize(800,600);
////        File f = new File("//tmp//myimage_small.jpg");
////        f.createNewFile();
//
//        op.addImage();
//
//        // execute the operation
//        cmd.run(op, fileMap.raw, "/tmp/myimage_small.jpg");



//        ImageUtils iu = new ImageUtils();
//        iu.load(fileMap.raw);
//        //iu.square();
//        iu.smoothThumbnail(600)
//        FileOutputStream fOut = new FileOutputStream(fileMap.dir +"-"+thumb+".jpg");
//        ImageIO.write(iu.getModifiedImage(), "jpg", fOut);


//        burningImageService.doWith(fileMap.raw, fileMap.dir)
//                   .execute (thumb, {
//                       //it.scaleAccurate(100, 100)
//                       it.scaleApproximate(600, 600)
//                   })
//        fileMap.thumb = fileMap.dir + "/" + thumb

}
