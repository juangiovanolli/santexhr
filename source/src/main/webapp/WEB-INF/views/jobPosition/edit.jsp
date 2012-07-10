<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tt" uri="/WEB-INF/tlds/ttTagLibrary.tld" %>
<%@ page import="static org.openapplicant.domain.User.Role.ROLE_HR" %>

<div id="content">

    <form action="save" method="POST" class="group" style="clear:both;">
        <input type="hidden" name="q" value="<c:out value='${question.artifactId}' />"/>
        <ul>
            <li>
                <label>Name:</label>
                <div>
                    <input type="text" name="name" id="name" value="<c:out value='${question.name}'/>"/>
                </div>
            </li>
            <security:authorize ifNotGranted="<%=ROLE_HR.name()%>">
                <li class="actions">
                    <input type="submit" class="submit" name="save" value="Save"/>
                    <input type="submit" class="submit" name="cancel" value="Cancel"/>
                </li>
            </security:authorize>
        </ul>
    </form>

    <security:authorize ifAllGranted="<%=ROLE_HR.name()%>">
        <script type="text/javascript">
            $('#content input, #content textarea, #content select').each(function() {
                this.disabled=true;
            });
        </script>
    </security:authorize>

    <script type="text/javascript">
        oltk.include('jquery/validate/jquery.validate.js');
        $('#content form').validate();
        $('#content #timeAllowed').rules("add",{
            min: 0
        });
    </script>
</div>