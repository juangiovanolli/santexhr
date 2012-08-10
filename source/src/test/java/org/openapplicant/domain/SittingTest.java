package org.openapplicant.domain;

import org.junit.Test;
import org.openapplicant.domain.question.CodeQuestionBuilder;
import org.openapplicant.domain.question.Question;

import static org.junit.Assert.*;


public class SittingTest {
	
	@Test
	public void advanceToNextQuestion() {
		
		Question q1 = new CodeQuestionBuilder().build();
		Question q2 = new CodeQuestionBuilder().build();
		
		Sitting sitting = new SittingBuilder()
								.withExam(
										new ExamBuilder()
												.withQuestions(q1, q2)
												.build()
								)
								.build();
		
		assertTrue(sitting.hasNextQuestion());
		assertEquals(0, sitting.getNextQuestionIndex());
		
		assertEquals(q1, sitting.advanceToNextQuestion());
		assertEquals(1, sitting.getNextQuestionIndex());
		
		assertEquals(q2, sitting.advanceToNextQuestion());
		assertEquals(2, sitting.getNextQuestionIndex());
		
		assertFalse(sitting.hasNextQuestion());
	}
	
	@Test
	public void assignResponse() {
		Sitting sitting = new SittingBuilder()
								.withExam(
										new ExamBuilder()
												.withQuestions(
														new CodeQuestionBuilder()
																.withId(10L)
																.build()
												)
												.build()
								)
								.build();
		
		Question q = sitting.getExam().getQuestions().get(0);
		Response r = new ResponseBuilder().build();
		
		sitting.assignResponse(q.getGuid(), r);
		
		assertEquals(r, sitting.getQuestionsAndResponses().get(0).getResponse());
	}
	
	@Test
	public void gradeResponse() {
		Question question1 = new CodeQuestionBuilder()
									.withId(10L)
									.build();
		Question question2 = new CodeQuestionBuilder()
									.withId(11L)
									.build();
		
		Candidate candidate = new CandidateBuilder()
									.withStatus(Candidate.Status.READY_FOR_GRADING)
									.build();
		
		Sitting sitting = new SittingBuilder()
								.withCandidate(candidate)
								.withExam(
										new ExamBuilder()
												.withQuestions(
														question1,
														question2
												)
										.build()
								)
								.build();
	
		Response response1 = new ResponseBuilder()
									.withGradeOfZero()
									.withId(10L)
									.build();
		sitting.assignResponse(question1.getGuid(), response1);
		
		Response response2 = new ResponseBuilder()
									.withGradeOfZero()
									.withId(11L)
									.build();
		sitting.assignResponse(question2.getGuid(), response2);
		
		assertEquals(new Score(0), sitting.getScore());
		
		sitting.gradeResponse(
				response1.getId(), 
				new GradeBuilder()
					.withNoScores()
					.addScore("form", new Score(10))
				.build()
		);
		
		assertEquals(new Score(5), sitting.getScore());
		assertFalse(Candidate.Status.GRADED == sitting.getCandidate().getStatus());
		assertFalse(sitting.isEachResponseGraded());
		
		sitting.gradeResponse(
				response2.getId(),
				new GradeBuilder()
						.withNoScores()
						.addScore("form", new Score(8))
						.build()			
		);
		
		assertEquals(new Score(9), sitting.getScore());
		assertTrue(sitting.isEachResponseGraded());
		assertEquals(Candidate.Status.GRADED, sitting.getCandidate().getStatus());
	}
	
	@Test
	public void gradeResponse_notAllQuestionsRespondedTo() {
		Question q1 = new CodeQuestionBuilder().withId(10L).build();
		Question q2 = new CodeQuestionBuilder().build();
		
		Sitting sitting = new SittingBuilder()
								.withExam(
										new ExamBuilder()
												.withQuestions(q1,q2)
												.build()
								)
								.build();
		
		Response response1 = new ResponseBuilder()
									.withGradeOfZero()
									.withId(10L)
									.build();
		
		sitting.assignResponse(q1.getGuid(), response1);
		
		assertTrue(sitting.hasNextQuestion());
		
		sitting.gradeResponse(
				response1.getId(),
				new GradeBuilder()
						.withNoScores()
						.addScore("form", new Score(100))
						.build()
		);
		
		assertTrue(sitting.isEachResponseGraded());
		assertEquals(new Score(50), sitting.getScore());
	}
	
	@Test
	public void gradeResponse_nonTerminatingDecimal() {
		Question q1 = new CodeQuestionBuilder().withId(10L).build();
		Question q2 = new CodeQuestionBuilder().build();
		Question q3 = new CodeQuestionBuilder().build();
		
		Sitting sitting = new SittingBuilder()
								.withExam(
										new ExamBuilder()
												.withQuestions(q1,q2,q3)
												.build()
								)
								.build();
		
		Response response1 = new ResponseBuilder()
									.withGradeOfZero()
									.withId(10L)
									.build();
		sitting.assignResponse(q1.getGuid(), response1);
		
		// 100/3 is an arithmetic exception, unless we specify a rounding mode.
		sitting.gradeResponse(
				response1.getId(), 
				new GradeBuilder()
						.withNoScores()
						.addScore("form", new Score(100))
						.addScore("function", new Score(100))
						.build()
		);
		
		assertEquals(new Score(33.3), sitting.getScore());
	}
}
