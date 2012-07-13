package org.openapplicant.domain;

import org.hibernate.validator.NotEmpty;
import org.openapplicant.validation.Unique;
import org.openapplicant.validation.UniqueWith;

import javax.persistence.*;

/**
 * User: Gian Franco Zabarino
 * Date: 7/5/12
 * Time: 10:06 AM
 */
@Entity
@Table(
        uniqueConstraints={@UniqueConstraint(columnNames={"name", "company"})}
)
public class JobPosition extends DomainObject {
    private String name;
    private Company company;

    @Column(nullable = false)
    @NotEmpty
    @UniqueWith("company.id")
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @ManyToOne(optional = false)
    public Company getCompany() {
        return company;
    }

    public void setCompany(Company company) {
        this.company = company;
    }
}
