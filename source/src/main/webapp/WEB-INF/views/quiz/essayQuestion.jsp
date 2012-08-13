<%@ taglib prefix="c"    uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="/WEB-INF/tlds/ttTagLibrary.tld" prefix="tt" %>

<%@ page import="org.openapplicant.domain.question.EssayQuestion" %>



                <h3 class="question-title">${question.prompt}</h3>

                <textarea role="textbox" autocomplete="off" placeholder="Por favor complet&aacute; con la respuesta ac&aacute;." name="content" title="Por favor complet&aacute; con la respuesta ac&aacute;." id="response" class="textarea-large textarea-noCurrent" onFocus="this.className='textarea-large'" onBlur="this.className='textarea-large textarea-noCurrent'"></textarea>

                <ul class="input-radio input-radio-single">
                    <li>
                        <label>
                            <input type="radio" id="radio01" class="radio" name="radio01" value="">
                            <strong>No se la respuesta</strong>
                        </label>
                    </li>
                </ul>

<script type="text/javascript">
    oltk.include('openapplicant/quiz/helper/recorder.js');
    openapplicant.quiz.helper.recorder.init('#response');

    oltk.include('openapplicant/quiz/helper/tab.js');
    openapplicant.quiz.helper.tab.init('#response');
</script>