package org.openapplicant.web.dwr;

import org.openapplicant.domain.Response;
import org.openapplicant.service.QuizService;


public class DwrQuizService {
	
	private QuizService quizService;
	
	public void setQuizService(QuizService value) {
		quizService = value;
	}

	public void submitResponse(String sittingGuid, String questionGuid, Response response) {
		quizService.submitResponse(sittingGuid, questionGuid, response);
	}
}
