<%@ taglib prefix="c"    uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib uri="/WEB-INF/tlds/ttTagLibrary.tld" prefix="tt" %>
<c:forEach items="${sitting.questionsAndResponses}" var="questionAndResponse">
    <c:if test="${!(question.timeAllowed eq null) && (question.timeAllowed > 0) && (questionAndResponse.question eq question) && !(questionAndResponse.response eq null) && (questionAndResponse.response.loadTimestamp != 0)}">
        <c:set var="disableInputOnTimedQuestions" value="${true}" scope="request"/>
    </c:if>
</c:forEach>
<script type="text/javascript" src="<c:url value='/dwr/engine.js'/>"></script>
<script type="text/javascript" src="<c:url value='/dwr/interface/QuizService.js'/>"></script>
<link type="text/css" rel="stylesheet" href="<c:url value="/css/vendor/jquery.hoverscroll.css"/>"/>
<script type="text/javascript">
    oltk.include('openapplicant/quiz/controller/LoadingController.js');
    oltk.include('jquery/hoverscroll/jquery.hoverscroll.js');
	dwr.engine.setPreHook( function() { openapplicant.quiz.controller.LoadingController.show(); } );
	dwr.engine.setPostHook( function() { openapplicant.quiz.controller.LoadingController.hide(); } );
</script>

<!-- section -->
<section id="section">

    <!-- article -->
    <article>

        <!-- wide -->
        <div class="wide-top align-center">

            <!-- nav control -->
            <div id="nav-control">

                <!-- title -->
                <h3>${examLink.exams[0].name}</h3>
                <!-- title -->

                <!-- nav -->
                <ul id="nav-arrows">
                    <c:if test="${fn:length(sitting.questionsAndResponses) > 8}">
                    <li id="arrow-left"><a href="#"><span>Left</span></a></li>
                    </c:if>
                    <li>
                    <ul id="nav-numbers">
                        <c:forEach items="${sitting.questionsAndResponses}" var="questionAndResponseIndex" varStatus="index">
                            <li<c:if test="${questionAndResponseIndex.question eq question}"> class='current-nav'</c:if>>
                                <a href="#" id="goToQuestion_${questionAndResponseIndex.question.guid}"
                                        <c:if test="${!(questionAndResponseIndex.response eq null) && (((not empty questionAndResponseIndex.response.content) || (questionAndResponseIndex.response.dontKnowTheAnswer == true)) || (questionAndResponseIndex.question.timeAllowed != null && questionAndResponseIndex.question.timeAllowed > 0 && questionAndResponseIndex.response.loadTimestamp != 0))}"> class="i-was-there"</c:if>><c:out value="${index.index + 1}"/></a></li>
                        </c:forEach>
                    </ul>
                    </li>
                    <c:if test="${fn:length(sitting.questionsAndResponses) > 8}">
                    <li id="of-total">of</li>
                    <li id="total"><a href="#"><c:out value="${fn:length(sitting.questionsAndResponses)}"/></a></li>
                    <li id="arrow-right"><a href="#"><span>Right</span></a></li>
                    </c:if>
                </ul>
                <!-- /nav -->

            </div>
            <!-- /nav control -->
            <c:if test="${!(question.timeAllowed eq null) && question.timeAllowed > 0}">
            <!-- lights -->
            <div id="lights-wrap">

                <p>Five yellow lights to finish this question</p>

                <ul id="lights-section">
                    <div id="semaphore_container">
                        <div id="semaphore"></div>
                        <div id="semaphore_off"></div>
                    </div>
                </ul>

            </div>
            <!-- /lights -->
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

        <c:if test="${!(question.timeAllowed eq null) && question.timeAllowed > 0}">
        var questionTime = ${question.timeAllowed * 1000};
        var numberOfLights = 5;
        var timePerLight = questionTime / numberOfLights;
        var section = $('#semaphore');
        for (i = 0; i < numberOfLights; i++) {
            section.html(section.html() + '<div id="light' + i + '"><img src="<c:url value="/img/quiz/light-yellow.png"/>"/></div>');
        }
        <c:if test="${!disableInputOnTimedQuestions}">
        var section = $('#semaphore_off');
        for (i = 0; i < numberOfLights; i++) {
            section.html(section.html() + '<div id="light_off' + i + '"><img src="<c:url value="/img/quiz/light-off.png"/>"/></div>');
        }
        var off = function(i) {
            $('#light_off' + i).fadeTo(timePerLight, 0, function() {
                if (i < (numberOfLights - 1)) {
                    off(i + 1);
                } else {
                    submitResponse();
                    goToQuestion('${question.guid}');
                }
            });
        }
        off(0);
        </c:if>
        </c:if>
        <c:if test="${fn:length(sitting.questionsAndResponses) > 8}">
        $('#nav-numbers').hoverscroll({
                    vertical: false,	// Display the list vertically or horizontally

                    width:    400,		// Width of the list container
                    height:   55,		// Height of the list container

                    arrows:   false,		// Display direction indicator arrows or not
                    arrowsOpacity: 0.7,	// Max possible opacity of the arrows
                    fixedArrows: false,  // Fixed arrows on the sides of the list (disables arrowsOpacity)

                    rtl:      false,     // Print images from right to left

                    debug:    false     // Debug output in the firebug console
                }
        );
        // Set the initial position
        var totalWidth = $('.listcontainer').width();
        var maxScrollLeft = $('#nav-numbers').width() - $('.listcontainer').width();
        <c:forEach items="${sitting.questionsAndResponses}" var="questionAndResponse" varStatus="status">
            <c:if test="${questionAndResponse.question eq question}">
                <c:set var="index" value="${status.index}"/>
            </c:if>
        </c:forEach>
        var linkInsideItemElement = $('.item a')[0];
        var elementLength = linkInsideItemElement.offsetWidth + 2 * linkInsideItemElement.offsetLeft;
        var firstElement = 5;
        var lastElement = ${fn:length(sitting.questionsAndResponses)} - firstElement;
        if (${index} > lastElement) {
            $('.listcontainer').scrollLeft(maxScrollLeft);
        } else if (${index} < firstElement) {
            $('.listcontainer').scrollLeft(0);
        } else {
            $('.listcontainer').scrollLeft(elementLength * ${index} - $('.listcontainer').width() / 2 + elementLength / 2);
        }
        </c:if>
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

    function goToQuestion(qg) {
        if(!submittedResponse) { setTimeout(function(){goToQuestion(qg);}, 10); }
        else { $(location).attr('href',"<c:url value='/quiz/goToQuestion'/>?s=${sitting.guid}&qg=" + qg); }
    }
	
	$('#nextQuestion').each(function() {
        $(this).click( function() {
            openapplicant.quiz.helper.timer.destroy();
            submitResponse();
            nextQuestion();
        });
    });
    <c:if test="${fn:length(sitting.questionsAndResponses) > 8}">
    $('#arrow-right').each(function() {
        $(this).hover( function() {
            $('#nav-numbers')[0].startMoving( 1, 15 );
        }, function () {
            $('#nav-numbers')[0].stopMoving();
        });
    });

    $('#arrow-left').each(function() {
        $(this).hover( function() {
            $('#nav-numbers')[0].startMoving( -1, 15 );
        }, function () {
            $('#nav-numbers')[0].stopMoving();
        });
    });
	</c:if>
	$('a[id^=goToQuestion]').click( function() {
		openapplicant.quiz.helper.timer.destroy();		
		submitResponse();
		var qg = $(this).attr("id").split("_")[1];
		goToQuestion(qg)
	});


</script>