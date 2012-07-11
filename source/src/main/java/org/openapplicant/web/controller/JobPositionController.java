package org.openapplicant.web.controller;

import org.openapplicant.domain.JobPosition;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Collection;
import java.util.Map;

import static org.springframework.web.bind.annotation.RequestMethod.GET;
import static org.springframework.web.bind.annotation.RequestMethod.POST;


@Controller
public class JobPositionController extends AdminController {
	
	@RequestMapping(method=GET)
	public String index(Map<String, Object> model) {
		Collection<JobPosition> jobPositions = getAdminService().findJobPositionsByCompany(currentUser().getCompany());
		model.put("jobPositions", jobPositions);
	    model.put("jobPositionsSidebar", true);
		return "jobPositions/index";
	}

    @RequestMapping(method = GET)
    public String view(@RequestParam(required = false) Long id,
                       Map<String, Object> model) {
        if (id != null && id > 0) {
            model.put("jobPosition", getAdminService().findJobPositionById(id));
        } else {
            model.put("jobPosition", new JobPosition());
        }
        return "jobPositions/view";
    }

    @RequestMapping(method = POST)
    public String update(
            @ModelAttribute JobPosition jobPosition,
            @RequestParam(required = false) String save,
            Map<String, Object> model) {
        if (save == null) {
            return "redirect:index";
        }
        if (jobPosition.getId() != null && jobPosition.getId() > 0) {
            getAdminService().updateJobPositionInfo(jobPosition.getId(), jobPosition.getName());
        } else {
            jobPosition = getAdminService().saveJobPosition(jobPosition);
        }
        model.put("jobPosition", jobPosition);
        model.put("success", true);
        return "jobPositions/view";
    }
}
