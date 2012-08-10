package org.openapplicant.service;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openapplicant.domain.Exam;
import org.openapplicant.domain.question.Question;
import org.openapplicant.monitor.ExamTimeMonitor;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class SittingTimeManager {
	
	private static final Log logger = LogFactory.getLog(SittingTimeManager.class);
	
	private final Map<String,ExamTimeMonitor> sittingExamTimeMonitorMap = new ConcurrentHashMap<String,ExamTimeMonitor>();
	
	public ExamTimeMonitor getExamTimeBySittingGuid(String sittingGuid){
		return sittingExamTimeMonitorMap.get(sittingGuid);
	}
	
	public void createExamTimeMonitorForSitting(String sittingGuid, long totalExamTime){
		sittingExamTimeMonitorMap.put(sittingGuid, new ExamTimeMonitor(totalExamTime));
	}
	
	public void clearExamTimeMonitorBySitting(String sittingGuid){
		sittingExamTimeMonitorMap.remove(sittingGuid);
	}
	
	public boolean isExamMonitoring(String sittingGuid){
		return sittingExamTimeMonitorMap.get(sittingGuid) != null;
	}

	public void timerProcess(String sittingGuid, Exam exam){
		logger.debug("timerProcess()");
		
		long totalExamTime = 0;
		//Counter time on the server side.
		if(sittingExamTimeMonitorMap.get(sittingGuid) == null){			
			totalExamTime = calculateTotalExamTime(exam);			
			//Verify if the exam is timed or untimed.
			if(totalExamTime > 0){				
				//examMonitor = new ExamTimeMonitor(totalExamTime);
				createExamTimeMonitorForSitting(sittingGuid,totalExamTime);
			}
		}
	}
	
	private long calculateTotalExamTime(Exam exam){	
		logger.debug("calculateTotalExamTime()");
		List<Question> questionList= exam.getQuestions();
		long totalExamTime = 0; 
		
		for (Question question : questionList) {
			if(question.getTimeAllowed() != null){
				totalExamTime = totalExamTime + question.getTimeAllowed();
			}
		}
		
		// if the globalExamTime is more than the sum of time question, 
		// take it, in other case the sum is taken.
		if(exam.getTotalTime() > totalExamTime){
			totalExamTime = exam.getTotalTime();
		}	
		
		return totalExamTime;
	}
	
}
