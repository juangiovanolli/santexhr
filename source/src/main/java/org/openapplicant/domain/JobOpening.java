package org.openapplicant.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.ManyToOne;
import javax.persistence.Transient;
import java.util.Date;

/**
 * User: Gian Franco Zabarino
 * Date: 7/5/12
 * Time: 10:06 AM
 */
@Entity
public class JobOpening extends DomainObject {
    private final static long MILLIS_IN_A_DAY = 1000 * 60 * 60 * 24;
    private Date startDate = new Date();
    private Date finishDate = new Date(System.currentTimeMillis() + MILLIS_IN_A_DAY * 14);
    private Status status = Status.CREATED;
    private JobPosition jobPosition;
    private String description;

    @Transient
    public Boolean isOpen() {
        Date now = new Date();
        return now.before(finishDate) && now.after(startDate);
    }

    @Column(nullable = false)
    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    @Column(nullable = false)
    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    @Column(nullable = false)
    public Date getFinishDate() {
        return finishDate;
    }

    public void setFinishDate(Date finishDate) {
        this.finishDate = finishDate;
    }

    @ManyToOne
    public JobPosition getJobPosition() {
        return jobPosition;
    }

    public void setJobPosition(JobPosition jobPosition) {
        this.jobPosition = jobPosition;
    }

    @Column
    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    //========================================================================
    // STATUS
    //========================================================================
    public enum Status {
        CREATED,
        INTERVIEWING,
        CANDIDATE_SELECTION,
        HIRING_PROCESS,
        ABOUT_TO_REOPEN;
    }
}
