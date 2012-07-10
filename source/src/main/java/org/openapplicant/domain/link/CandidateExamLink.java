package org.openapplicant.domain.link;

import org.hibernate.annotations.Cascade;
import org.openapplicant.domain.Candidate;
import org.openapplicant.domain.Company;
import org.openapplicant.domain.JobPosition;
import org.openapplicant.policy.NeverCall;
import org.springframework.util.Assert;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.ManyToOne;


/**
 * Models an exam link sent to a candidate.
 */
@Entity
public class CandidateExamLink extends ExamLink {
	
	private Candidate candidate;
    private JobPosition jobPosition;
	
	// FIXME: company param is redundant
	public CandidateExamLink(Company company, Candidate candidate, ExamsStrategy strategy) {
		super(company, strategy);
		
		Assert.notNull(candidate);
		this.candidate = candidate;
        this.jobPosition = strategy.fetchExams(null).get(0).getJobPosition();
	}
	
	@NeverCall
	CandidateExamLink(){}
	
	@ManyToOne(
			cascade={CascadeType.PERSIST,CascadeType.MERGE,CascadeType.REFRESH},
			fetch=FetchType.LAZY
	)
	@Cascade(org.hibernate.annotations.CascadeType.SAVE_UPDATE)
	public Candidate getCandidate() {
		return candidate;
	}
	
	private void setCandidate(Candidate value) {
		candidate = value;
	}

    @ManyToOne
    public JobPosition getJobPosition() {
        return jobPosition;
    }

    public void setJobPosition(JobPosition jobPosition) {
        this.jobPosition = jobPosition;
    }
}
