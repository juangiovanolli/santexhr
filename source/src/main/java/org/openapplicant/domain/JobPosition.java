package org.openapplicant.domain;

import org.hibernate.validator.NotEmpty;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.ManyToOne;

/**
 * User: Gian Franco Zabarino
 * Date: 7/5/12
 * Time: 10:06 AM
 */
@Entity
public class JobPosition extends DomainObject {
    private String name;
    private Company company;

    @Column(nullable = false)
    @NotEmpty
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @ManyToOne
    public Company getCompany() {
        return company;
    }

    public void setCompany(Company company) {
        this.company = company;
    }
}
