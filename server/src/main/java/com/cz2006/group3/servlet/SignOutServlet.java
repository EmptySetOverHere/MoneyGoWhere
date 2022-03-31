package com.cz2006.group3.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 * This class handles GET request from the client side who is requesting of signing out of the current session.
 */
@WebServlet(urlPatterns = "/signout")
public class SignOutServlet extends AbstractServlet {
    // private final Logger logger = LogManager.getLogger(this.getClass());
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 从HttpSession移除用户名:
        System.out.println("User " +  req.getIntHeader("uid") + " is signing out");
        req.getSession().removeAttribute("user");
        resp.sendRedirect("/home");
    }
}