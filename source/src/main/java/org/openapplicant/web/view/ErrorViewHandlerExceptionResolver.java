package org.openapplicant.web.view;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.HandlerExceptionResolver;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class ErrorViewHandlerExceptionResolver implements HandlerExceptionResolver {

	private static final Log log = LogFactory.getLog(ErrorViewHandlerExceptionResolver.class);
	
	public ModelAndView resolveException(HttpServletRequest request,
			HttpServletResponse response, Object handler, Exception ex) {
		String servletPath = request.getServletPath();
        log.error(ex);
        if (!servletPath.startsWith("quiz")) {
            return new ModelAndView("error/index");
        } else {
            return new ModelAndView("quiz/index").addObject("error", "There seems to be a problem with our servers.  Please try again later.");
        }
	}
}
