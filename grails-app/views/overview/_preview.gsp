<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="au.org.ala.volunteer.Field" %>

<g:set var="fields" value="${Field.findAllByTask(taskInstance).findAll { !it.value.isEmpty() }}"/>
<g:set var="hasFields" value="${fields.size() > 0}"/>

<div class="row">
    <div class="col-sm-12">
        <div class="well well-small">
            <g:imageViewer multimedia="${taskInstance.multimedia.first()}"
                           hidePinImage="true"
                           hideShowInOtherWindow="true"/>
        </div>
    </div>
</div>

<g:if test="${hasFields}">
    <g:render template="fieldTable" model="${[taskInstance: taskInstance, fields: fields]}"/>
</g:if>