<%@ taglib prefix="c"    uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@page import="org.openapplicant.domain.Candidate"%>
<!-- section -->
<section id="section">

    <!-- article -->
    <article>

        <!-- wide -->
        <div class="wide aling-center">

            <h2>Please complete your info:</h2>

            <div class="getInfo-wrap">
                <label class="label-large">First Name:</label>
                <input type="text" spellcheck="false" id="FirstName" name="FirstName" value="${candidate.name.first}" class="input-large input-noCurrent" onFocus="this.className='input-large'" onBlur="this.className='input-large input-noCurrent'">
            </div>

            <div class="getInfo-wrap">
                <label class="label-large">Last Name:</label>
                <input type="text" spellcheck="false" id="LastName" name="LastName" value="${candidate.name.last}" class="input-large input-noCurrent" onFocus="this.className='input-large'" onBlur="this.className='input-large input-noCurrent'">
            </div>

            <div class="getInfo-wrap">
                <label class="label-large">E-mail:</label>
                <input type="text" spellcheck="false" id="Email" name="Email" value="${candidate.email}" class="input-large input-noCurrent" onFocus="this.className='input-large'" onBlur="this.className='input-large input-noCurrent'">
            </div>

            <button type="button" name="Go" value="Go" id="go-button" class="go-button"><span>Go</span></button>

        </div>
        <!-- /wide -->

    </article>
    <!-- /article -->

</section>
<!-- /section -->

<script type="text/javascript">
    $(document).ready(function() {
        $('#go-button').click( function() {
            var firstName = $('#FirstName').val();
            var lastName = $('#LastName').val();
            var email = $('#Email').val();
            var dataToSend = {
                'examLink':'${examLink.entityInfo.businessGuid}',
                'examArtifactId':'${examLink.exams[0].artifactId}',
                'name.first':firstName,
                'name.last':lastName,
                'email':email};
            $.postGo('<c:url value="info"/>',dataToSend);
            return false;
        })
    });
</script>
