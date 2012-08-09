<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<!-- header -->
<header id="header" class="header-large">

    <a href="/" name="Santex Talent Finder"><img src="<c:url value='/img/quiz/santex-tf.png'/>" id="logo-top" class="logo-top-large" name="Santex Talent Finder" alt="Santex Talent Finder"></a>

    <a href="http://www.santexgroup.com/" name="Santex"><img src="<c:url value='/img/quiz/santex-logo.png'/>" id="santex-logo" name="Santex" alt="Santex"></a>

    <h1>Hello<c:if test="${!(candidate.name eq null)}"> ${candidate.name.first} ${candidate.name.last}</c:if>, welcome to Talent Finder.</h1>

</header>
<!-- /header -->