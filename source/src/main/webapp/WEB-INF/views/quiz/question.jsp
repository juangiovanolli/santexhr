<%@ taglib prefix="c"    uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib uri="/WEB-INF/tlds/ttTagLibrary.tld" prefix="tt" %>

<script type="text/javascript" src="<c:url value='/dwr/engine.js'/>"></script>
<script type="text/javascript" src="<c:url value='/dwr/interface/QuizService.js'/>"></script>
<script type="text/javascript">
	oltk.include('openapplicant/quiz/controller/LoadingController.js');
	dwr.engine.setPreHook( function() { openapplicant.quiz.controller.LoadingController.show(); } );
	dwr.engine.setPostHook( function() { openapplicant.quiz.controller.LoadingController.hide(); } );
</script>

<!-- section -->
<section id="section">

    <!-- article -->
    <article>

        <!-- wide -->
        <div class="wide-top aling-center">

            <!-- nav control -->
            <div id="nav-control">

                <!-- title -->
                <h3>${examLink.exams[0].name}</h3>
                <!-- title -->

                <!-- nav -->
                <ul id="nav-arrows">
                    <c:set var="hasPreviousQuestion" value="${sitting.nextQuestionIndex -2 >= 0?'':'disabled'}"></c:set>
                    <c:if test="${sitting.nextQuestionIndex -2 >= 0}">
                    <li id="arrow-left"><a href="#"><span>Left</span></a></li>
                    </c:if>
                    <ul id="nav-numbers">
                        <c:forEach items="${sitting.questionsAndResponses}" var="questionAndResponseIndex" varStatus="index">
                            <li<c:if test="${questionAndResponseIndex.question eq question}"> class='current-nav'</c:if>>
                                <a href="#" id="goToQuestion_${questionAndResponseIndex.question.guid}"<c:if test="${!(questionAndResponseIndex.response eq null) && ((not empty questionAndResponseIndex.response.content) || (questionAndResponseIndex.response.dontKnowTheAnswer == true))}"> class="i-was-there"</c:if>><c:out value="${index.index + 1}"/></a></li>
                        </c:forEach>
                        <li id="of-total">of</li>
                        <li><a href="#"><c:out value="${fn:length(sitting.questionsAndResponses)}"/></a></li>
                    </ul>
                    <c:if test="${sitting.nextQuestionIndex != fn:length(sitting.exam.questions)}">
                    <li id="arrow-right"><a href="#"><span>Right</span></a></li>
                    </c:if>
                </ul>
                <!-- /nav -->

            </div>
            <!-- /nav control -->
            <c:if test="${!(question.timeAllowed eq null) && question.timeAllowed > 0}">
            <!-- ligths -->
            <div id="ligths-wrap">

                <p>Four yellow ligths to finish this question</p>

                <ul>
                    <li class="current-ligth"><img src="<c:url value='/img/quiz/ligth-yellow.png'/>" name="Ligth" alt="Ligth"></li>
                    <li><img src="<c:url value='/img/quiz/ligth-yellow.png'/>" name="Ligth" alt="Ligth"></li>
                    <li><img src="<c:url value='/img/quiz/ligth-yellow.png'/>" name="Ligth" alt="Ligth"></li>
                    <li><img src="<c:url value='/img/quiz/ligth-yellow.png'/>" name="Ligth" alt="Ligth"></li>
                </ul>

            </div>
            <!-- /ligths -->
            </c:if>

            <!-- questions  -->
            <div id="questions">
                <tiles:insertAttribute name="questionKind"/>
                <div id="errorMessage"></div>
                <c:if test="${sitting.nextQuestionIndex != fn:length(sitting.exam.questions)}">
                    <p class="next-button"><a href="#" id="nextQuestion" name="Continue">Continue</a></p>
                </c:if>
                <p class="next-button"><a href="#" id="finish" name="Finish Exam">Finish</a></p>
            </div>
            <!-- /questions  -->

        </div>
        <!-- /wide -->

    </article>
    <!-- /article -->

</section>
<!-- /section -->

<script type="text/javascript">	
	//Begin - check progress functionality
	oltk.include('jquery/time/jquery.timers-1.2.js');
	oltk.include('jquery/jquery.js');
	$(document).ready(function(){
		    var totalTime = ${remainingTime};
			if(totalTime != ""){
				 //Display Total Exam time - CountDown.	
				 $(document).everyTime('1s',function(i) {
					 if(totalTime > 0){
                        totalTime = totalTime - 1;
                        var minutesRight, minutesLeft, secondsRight, secondsLeft;
                        secondsRight = totalTime % 10;
                        secondsLeft = parseInt(Math.floor((totalTime % 60) / 10));
                        minutesRight = parseInt(Math.floor(totalTime / 60));
                        minutesLeft = parseInt(Math.floor(totalTime / 600));
                        $('#minute-left').html(minutesLeft);
                        $('#minute-right').html(minutesRight);
                        $('#second-left').html(secondsLeft);
                        $('#second-right').html(secondsRight);
					 }
					 else
					 {
                         $('#minute-left').html(0);
                         $('#minute-right').html(0);
                         $('#second-left').html(0);
                         $('#second-right').html(0);
						 $(document).stopTime('displayRemainingTime');
                         openapplicant.quiz.helper.timer.destroy();
                         submitResponse();
                         finishExam();
					 }
				 });

                $('#finish').click(function() {
                    openapplicant.quiz.helper.timer.destroy();
                    submitResponse();
                    finishExam();
                });
			}			 
	});
	//End - check progress functionality
	
	oltk.include('openapplicant/quiz/helper/timer.js');
	openapplicant.quiz.helper.timer.init('#time_allowed', ${null==question.timeAllowed ? 0 : question.timeAllowed},
		submitResponse,
		nextQuestion
	);

	var submittedResponse = false;
	
	var canContinue = function () {
		submittedResponse = true;
	}

    function finishExam() {
        if(!submittedResponse) { setTimeout("finishExam()", 10); }
        else {
            $.postGo('<c:url value="finish"/>',
                {
                    guid:'${sitting.guid}'
                }
            );
        }
    }

	function submitResponse() {
		var response = openapplicant.quiz.helper.recorder.getResponse();
		QuizService.submitResponse('${sitting.guid}', '${question.guid}', response, canContinue);
	}
	
	function nextQuestion() {
		if(!submittedResponse) { setTimeout("nextQuestion()", 10); }
		else { window.location = "<c:url value='/quiz/question?s=${sitting.guid}'/>"; }
	}
	
	function previousQuestion() {
		if(!submittedResponse) { setTimeout("previousQuestion()", 10); }
		else { window.location = "<c:url value='/quiz/prevQuestion?s=${sitting.guid}'/>"; }
	}

    function goToQuestion(qg) {
        if(!submittedResponse) { setTimeout(function(){goToQuestion(qg);}, 10); }
        else { $(location).attr('href',"<c:url value='/quiz/goToQuestion'/>?s=${sitting.guid}&qg=" + qg); }
    }
	
	$('#nextQuestion,#arrow-right').each(function() {
        $(this).click( function() {
            openapplicant.quiz.helper.timer.destroy();
            submitResponse();
            nextQuestion();
        });
    });
	
	$('#previousQuestion,#arrow-left').each(function() {
        $(this).click( function() {
            openapplicant.quiz.helper.timer.destroy();
            submitResponse();
            previousQuestion();
        });
    });
	
	$('a[id^=goToQuestion]').click( function() {
		openapplicant.quiz.helper.timer.destroy();		
		submitResponse();
		var qg = $(this).attr("id").split("_")[1];
		goToQuestion(qg)
	});


</script>