<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<!-- header -->
<header id="header" class="header-small">

    <!-- logo -->
    <a href="/" name="Santex Talent Finder"><img src="<c:url value='/img/quiz/santex-tf-small.png'/>" id="logo-top" class="logo-top-small" name="Santex Talent Finder" alt="Santex Talent Finder"></a>
    <!-- /logo -->
    <c:if test="${!(question eq null)}">
    <!-- timing -->
    <tiles:insertAttribute name="progressTime"/>
    <!-- /timing -->
    </c:if>

</header>
<!-- /header -->