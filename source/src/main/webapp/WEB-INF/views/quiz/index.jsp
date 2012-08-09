<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<!-- section -->
<section id="section">

    <!-- slide 01 -->
    <article id="slide-01">

        <!-- left -->
        <div class="left">
            <img src="<c:url value='/img/quiz/clock.png'/>" alt="Clock" name="Clock" id="img-clock" class="img-tutorial-left img-resize">
        </div>
        <!-- left -->

        <!-- right -->
        <div class="right">
            <p>The following exam will present you with a series of questions designed to measure your problem solving abilities.</p>

            <p>Not all of the questions are timed, but that does not mean you can google around for the answers. Be sure to watch the YELLOW time ligths in the TOP.
                When all ligths are in yellow your time for this question is off.</p>

            <img src="<c:url value='/img/quiz/tutorial-img-01.png'/>" alt="Example" name="Example" id="img-example-01" class="img-resize">

            <p class="next-button"><a href="index2?exam=${examLink.entityInfo.businessGuid}" name="Continue">Continue</a></p>
        </div>
        <!-- right -->

    </article>
    <!-- /slide 01 -->

</section>
<!-- /section -->