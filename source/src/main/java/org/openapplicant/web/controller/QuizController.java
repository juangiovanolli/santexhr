package org.openapplicant.web.controller;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openapplicant.domain.Candidate;
import org.openapplicant.domain.Sitting;
import org.openapplicant.domain.link.CandidateExamLink;
import org.openapplicant.domain.link.ExamLink;
import org.openapplicant.domain.question.*;
import org.openapplicant.service.QuizService;
import org.openapplicant.service.SittingTimeManager;
import org.openapplicant.web.view.MultipleChoiceHelper;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Map;

import static org.springframework.web.bind.annotation.RequestMethod.GET;
import static org.springframework.web.bind.annotation.RequestMethod.POST;


@Controller
public class QuizController {
	private static final Log logger = LogFactory.getLog(QuizController.class);
	
	private QuizService quizService;
	
	private SittingTimeManager sittingTimeManager;
	
	private final static String QUIZ_THANKS_VIEW = "quiz/thanks";
	
	public void setQuizService(QuizService value) {
		quizService = value;
	}

    public void setSittingTimeManager(SittingTimeManager sittingTimeManager) {
        this.sittingTimeManager = sittingTimeManager;
    }

    @RequestMapping(method=GET)
    public String index(	@RequestParam(value="exam", required=false) String guid,
                             Map<String,Object> model) {
        if (doIndex(guid, model)) {
            return "quiz/index";
        } else {
            return "quiz/sorry";
        }
    }

    @RequestMapping(method=GET)
    public String index2(	@RequestParam(value="exam", required=false) String guid,
                             Map<String,Object> model) {
        if (doIndex(guid, model)) {
            return "quiz/index2";
        } else {
            return "quiz/sorry";
        }
    }

    /**
     *
     * @return true if there were no errors, false if there were
     */
    private boolean doIndex(String guid, Map<String, Object> model) {
        if(null == guid || StringUtils.isBlank(guid)) {
            model.put("error", "You need an exam link to take an exam.");
            return false;
        }

        ExamLink examLink = quizService.getExamLinkByGuid(guid);

        if(null == examLink) {
            model.put("error", "Your exam link is old or invalid.");
            return false;
        }

        if(examLink.isUsed()) {
            model.put("error", "This exam link has already been used.");
            return false;
        }

        putCandidate(model, examLink);
        model.put("examLink", examLink);
        model.put("welcomeText", examLink.getCompany().getWelcomeText());
        return true;
    }

	@RequestMapping(method=GET)
	public String info(	@RequestParam(value="exam") String guid,
						Map<String,Object> model) {
		
		ExamLink examLink = quizService.getExamLinkByGuid(guid);
		
		putCandidate(model, examLink);
		model.put("examLink", examLink);

	    return "quiz/info";
	}
	
	@RequestMapping(method=POST)
	public String info(	@RequestParam(value="examLink") String guid,
						@ModelAttribute(value="candidate") Candidate candidate,
						@RequestParam(value="examArtifactId") String examArtifactId,
						Map<String,Object> model) {
		
		ExamLink examLink = quizService.getExamLinkByGuid(guid);
	
	    candidate = quizService.resolveCandidate(candidate, examLink.getCompany());
	    Sitting sitting = quizService.createSitting(candidate, examArtifactId);
	    
		if(sitting.isFinished()) {
			model.put("error", "This exam has already been completed.");
			return "quiz/sorry";
		}
		
	    return "redirect:question?s="+sitting.getGuid();
	}

    @RequestMapping(method = GET)
    public String question(@RequestParam(value = "s") String guid,
                           Map<String, Object> model) {
        logger.info("Question: building question");
        Sitting sitting = quizService.findSittingByGuid(guid);
        String sittingGuid = sitting.getGuid();

        model.put("sitting", sitting);
        String redirect;
        logger.debug("********** Question Client Request");
        if (!sitting.isFinished()) {
            Question question;
            if (sitting.hasNextQuestion()) {
                question = quizService.nextQuestion(sitting);
            } else {
                question = sitting.getCurrentQuestion();
            }

            sittingTimeManager.timerProcess(sittingGuid, sitting.getExam());

            model.put("question", question);
            model.put("questionViewHelper", new MultipleChoiceHelper(question));

            if (sittingTimeManager.isExamMonitoring(sittingGuid)) {
                model.put("isExamInTime", "true");
                model.put("remainingTime", sittingTimeManager.getExamTimeBySittingGuid(sittingGuid).getSeconds());
            }
            redirect = new QuizQuestionViewVisitor(question).getView();
        } else {
            model.put("completionText", sitting.getCandidate().getCompany().getCompletionText());
            redirect = QUIZ_THANKS_VIEW;
        }

        return redirect;
    }
	
	@RequestMapping(method=GET)
	public String goToQuestion(	@RequestParam(value="s") String guid,@RequestParam(value="qg") String questionGuid,
			Map<String,Object> model ) {
        String redirect;

        Sitting sitting = quizService.findSittingByGuid(guid);
        model.put("sitting", sitting);

        if (!sitting.isFinished()) {
            Question question = quizService.goToQuestion(sitting, questionGuid);

            model.put("question", question);
            model.put("questionViewHelper", new MultipleChoiceHelper(question));

            if (sittingTimeManager.isExamMonitoring(guid)) {
                model.put("isExamInTime", "true");
                model.put("remainingTime", sittingTimeManager.getExamTimeBySittingGuid(guid).getSeconds());
            }
            redirect = new QuizQuestionViewVisitor(question).getView();
        } else {
            model.put("completionText", sitting.getCandidate().getCompany().getCompletionText());
            redirect = QUIZ_THANKS_VIEW;
        }

        return redirect;
	}
	
	@RequestMapping(method=GET)
	public String prevQuestion(	@RequestParam(value="s") String guid,
							Map<String,Object> model) {
		String redirect;
		Sitting sitting = quizService.findSittingByGuid(guid);
		model.put("sitting", sitting);

        if (!sitting.isFinished()) {
            if (sitting.hasPreviousQuestion()) {
                Question question = quizService.previousQuestion(sitting);

                model.put("question", question);
                model.put("questionViewHelper", new MultipleChoiceHelper(question));
                if(sittingTimeManager.isExamMonitoring(guid)){
                    model.put("isExamInTime", "true");
                    model.put("remainingTime", sittingTimeManager.getExamTimeBySittingGuid(guid).getSeconds());
                }
                redirect =  new QuizQuestionViewVisitor(question).getView();
            } else {
                redirect = "quiz/sorry";
            }
        } else {
            redirect = QUIZ_THANKS_VIEW;
        }

		return redirect;
	}
	
	private void putCandidate(Map<String,Object> model, ExamLink examLink) {
		if(examLink instanceof CandidateExamLink) 
			model.put("candidate", ((CandidateExamLink) examLink).getCandidate());
		else
			model.put("candidate", new Candidate());
	}
	
	private static class QuizQuestionViewVisitor implements IQuestionVisitor {
		private String view;

		public QuizQuestionViewVisitor(Question question) {
			question.accept(this);
		}
		
		public String getView() {
			return view;
		}
		
		public void visit(CodeQuestion question) {
			this.view = "quiz/codeQuestion";
		}

		public void visit(EssayQuestion question) {
			this.view = "quiz/essayQuestion";
		}

		public void visit(MultipleChoiceQuestion question) {
			this.view = "quiz/multipleChoiceQuestion";
		}
	}

	@RequestMapping(method = RequestMethod.POST)
	public String finish(@RequestParam("guid") String guid) {
        logger.debug("********** Finish Exam Client Request");
		if(sittingTimeManager.isExamMonitoring(guid)){
            logger.debug("********** Removing sitting from timeManager");
            sittingTimeManager.clearExamTimeMonitorBySitting(guid);
		}
		return QUIZ_THANKS_VIEW;
	}
}
