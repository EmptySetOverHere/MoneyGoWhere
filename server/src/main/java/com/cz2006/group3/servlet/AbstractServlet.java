package com.cz2006.group3.servlet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * This is an abstract class for expending java servlet module to provide PATCH service.
 * All other servlet classes in this project are inherited from this class.
 */
public abstract class AbstractServlet extends HttpServlet {
    @Override
    protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{
        if (req.getMethod().equalsIgnoreCase("PATCH")){
            doPatch(req, resp);
        }else{
            super.service(req, resp);
        }
    }

    protected void doPatch(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{}

}
