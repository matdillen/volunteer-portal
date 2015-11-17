<!doctype html>
<html>
<head>
    <meta name="layout" content="digivol-projectSettings"/>
    <r:require modules="bootstrap-file-input"/>
</head>

<body>

<content tag="pageTitle">Expedition background image</content>

<content tag="adminButtonBar">
</content>

<div class="alert alert-warning">
    For best results and to preserve quality, it is recommend that the background image has a <strong>resolution</strong> of at least <strong>2 megapixels</strong> (eg: 1920 x 1080). The system won't accept images bigger than 512KB.<br/>
    <strong>The darker the image the better!</strong>
</div>

<g:if test="${projectInstance?.backgroundImage}">
<div class="text-center">
    <div class="thumbnail display-inline-block">
        <img src="${projectInstance?.backgroundImage}" class="img-responsive" style="width: 600px;"/>
    </div>
</div>
</g:if>
<g:else>
    <div class="alert alert-info">
        No background image uploaded yet.
    </div>
</g:else>


<g:form action="uploadBackgroundImage" controller="project" method="post" enctype="multipart/form-data"
        class="form-horizontal">

    <g:hiddenField name="id" value="${projectInstance.id}"/>


    <div class="form-group">
        <label class="control-label col-md-3" for="backgroundImage">Background Image</label>

        <div class="col-md-9">
            <input type="file" data-filename-placement="inside" name="backgroundImage" id="backgroundImage"/>
        </div>
    </div>

    <div class="form-group">
        <div class="col-md-offset-3 col-md-9">
            <g:submitButton class="btn btn-primary" name="Update"/>
        </div>
    </div>

</g:form>
<script type='text/javascript'>
    $(function () {
        // Initialize input type file
        $('input[type=file]').bootstrapFileInput();
    });
</script>

</body>
</html>
