<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<!-- section -->
<section id="section">

    <!-- slide 02 -->
    <article id="slide-02">

        <!-- left -->
        <div class="left">
            <img src="<c:url value='/img/quiz/pencil-glass.png'/>" alt="Pencil &amp; Glass" name="Pencil &amp; Glass" id="pencil-glass" class="img-tutorial-left img-resize">
        </div>
        <!-- left -->

        <!-- right -->
        <div class="right">
            <p>Get a pencil, scratch paper, glass of water, and click 'start' when you are ready to begin. The whole exam should take somewhere between 20 and 60 minutes. <b>Good luck!</b></p>
            <h3>Are you ready?</h3>

            <p class="go-button align-center"><a href="info?exam=${examLink.entityInfo.businessGuid}" name="Continue">Go</a></p>
        </div>
        <!-- right -->
    </article>
    <!-- /slide 02 -->

</section>
<!-- /section -->