package org.openapplicant.domain;

import org.hibernate.validator.NotEmpty;

import javax.persistence.Column;
import javax.persistence.Entity;

/**
 * User: Gian Franco Zabarino
 * Date: 7/5/12
 * Time: 10:06 AM
 */
@Entity
public class JobPosition extends DomainObject {
    private String name;

    @Column(nullable = false)
    @NotEmpty
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
