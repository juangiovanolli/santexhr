package org.openapplicant.monitor;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openapplicant.service.SittingTimeManager;
import org.springframework.stereotype.Component;

import java.util.Timer;
import java.util.TimerTask;

@Component
public class ExamTimeMonitor{
	private static final Log logger = LogFactory.getLog(ExamTimeMonitor.class);
	
	private static Timer timer = null;
	private long seconds = 0;
    private SittingTimeManager sittingTimeManager;
    private String sittingGuid;
    private long marginTime = 10000; // mS
	
	public ExamTimeMonitor(final long totalExamTime, final String sittingGuid, final SittingTimeManager sittingTimeManager) {
		this(totalExamTime, sittingGuid, sittingTimeManager, 10000);
	}

    public ExamTimeMonitor(final long totalExamTime, final String sittingGuid, final SittingTimeManager sittingTimeManager, final long marginTime) {
        timer = new Timer();
        timer.schedule(new CountDownTask(totalExamTime), 0, 1000);
        this.sittingTimeManager = sittingTimeManager;
        this.sittingGuid = sittingGuid;
        this.marginTime = marginTime;
    }
	
	public Timer getTimer() {
		return timer;
	}

	public void setTimer(Timer timer) {
		this.timer = timer;
	}

	public long getSeconds() {
		return seconds;
	}

	public void setSeconds(long seconds) {
		this.seconds = seconds;
	}

    public void stopCountDownTask() {
        getTimer().cancel();
    }

	class CountDownTask extends TimerTask{		
		
		public CountDownTask(final long totalExamTimeSec){
			seconds = totalExamTimeSec; 
		}		

		public void run() {
			if (seconds > 0) {
				logger.debug("********** " + seconds + " seconds remaining");
				seconds--;
			} else {
				logger.debug("********** Countdown finished. Scheduling new task and cancel this particular one.");
                timer.schedule(new TimerTask() {
                    @Override
                    public void run() {
                        logger.debug("********** Notifying SittingTimeManager");
                        sittingTimeManager.notifyFinishedExamEvent(sittingGuid);
                    }
                }, marginTime);
				this.cancel();
			}
		}
	}
}