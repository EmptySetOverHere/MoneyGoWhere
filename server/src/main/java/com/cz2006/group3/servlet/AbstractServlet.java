package com.cz2006.group3.servlet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public abstract class AbstractServlet extends HttpServlet {
    @Override
    protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{
        if (req.getMethod().equalsIgnoreCase("PATCH")){
            doPatch(req, resp);
        }else{
            super.service(req, resp);
        }
    }

    public void doPatch(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{}

}
