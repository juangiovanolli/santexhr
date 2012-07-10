package org.openapplicant.domain;

import java.util.Arrays;
import java.util.List;

/**
 * User: Gian Franco Zabarino
 * Date: 06/07/12
 * Time: 17:25
 */
public enum Seniority {
    JUNIOR,
    SEMI_SENIOR,
    SENIOR;

    public static List<Seniority> getList() {
        return Arrays.asList(values());
    }
}
