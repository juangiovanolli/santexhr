<%@ taglib prefix="c"    uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="utf-8">

    <title>Santex Talent Finder | HR Tool | Santex Group Company&trade;</title>

    <!-- favicon -->
    <link rel="shortcut icon" href="<c:url value='/img/quiz/favicon.ico'/>" type="image/x-icon" />

    <!-- style -->
    <link href="<c:url value='/css/layout/quiz.css'/>" rel="stylesheet" type="text/css"/>

    <!-- Google Fonts -->
    <link href='http://fonts.googleapis.com/css?family=Abel' rel='stylesheet' type='text/css'>
    <link href='http://fonts.googleapis.com/css?family=Oswald:400,300,700' rel='stylesheet' type='text/css'>

    <!-- Javascript -->
    <script type="text/javascript" src="<c:url value='/dwr/engine.js'/>"></script>
    <script type="text/javascript" src="<c:url value='/lib/js/oltk/oltk.js'/>"></script>
    <script type="text/javascript">
        oltk.include('jquery/jquery.js');
        oltk.include('openapplicant/quiz/view/functions.js');
        oltk.include('openapplicant/admin/helper/jquery.nonAjaxNavigation.js');
    </script>


    <!-- HTML 5 en IE -->
    <!--[if lt IE 9]>
    <script src="//html5shiv.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->

</head>

<body>
<!-- wrapper -->
<div id="container">

    <tiles:insertAttribute name="header"/>
    <tiles:insertAttribute name="content"/>
    <tiles:insertAttribute name="footer"/>

</div>
<!-- /wrapper -->
</body>
</html>