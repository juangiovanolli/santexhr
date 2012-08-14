<%@ taglib prefix="c"    uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="/WEB-INF/tlds/ttTagLibrary.tld" prefix="tt" %>

<%@ page import="org.openapplicant.domain.question.CodeQuestion" %>


<h3 class="question-title">${question.prompt}</h3>
<c:if test="${not empty question.promptContent}">
<!-- code -->
<code id="code">
    <textarea disabled="disabled">${question.promptContent}</textarea>
</code>
<!-- code -->
</c:if>
<textarea id="response" role="textbox" autocomplete="off"
          placeholder="Por favor complet&aacute; con la respuesta ac&aacute;."
          name="content" title="Por favor complet&aacute; con la respuesta ac&aacute;."
          class="textarea-large textarea-noCurrent" onFocus="this.className='textarea-large'"
          onBlur="this.className='textarea-large textarea-noCurrent'"><c:forEach items="${sitting.questionsAndResponses}" var="questionAndResponse"><c:if test="${question eq questionAndResponse.question}">${questionAndResponse.response.content}</c:if></c:forEach></textarea>

<ul class="input-radio input-radio-single">
    <li>
        <label>
            <input id="dontKnowTheAnswer" type="radio" class="radio" name="dontKnowTheAnswer" value="true"<c:forEach items="${sitting.questionsAndResponses}" var="questionAndResponse"><c:if test="${(question eq questionAndResponse.question) && !(questionAndResponse.response eq null) && ((not empty questionAndResponse.response.content) || (questionAndResponse.response.dontKnowTheAnswer == true))}"> checked=""</c:if></c:forEach>>
            <strong>No se la respuesta</strong>
        </label>
    </li>
</ul>
<script type="text/javascript">
	oltk.include('openapplicant/quiz/helper/recorder.js');
	openapplicant.quiz.helper.recorder.init('#response', '#dontKnowTheAnswer');

	oltk.include('openapplicant/quiz/helper/tab.js');
	openapplicant.quiz.helper.tab.init('#response');
</script>