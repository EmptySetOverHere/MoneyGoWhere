package com.cz2006.group3.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

import com.cz2006.group3.bean.DBConnector;
import com.cz2006.group3.bean.UserData;


@WebServlet("/signup")
public class SignUpServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        UserData matchedUser = null;
        try {
            matchedUser = DBConnector.queryUser(email.toLowerCase());
        } catch (SQLException e) {
            e.printStackTrace();
        }

        if (matchedUser == null) {
            // does not exist duplicated user
            // create a new user
            try {
                DBConnector.CreateUser(email, password);
            } catch (SQLException e) {
                e.printStackTrace();
            }
            req.getSession().setAttribute("email", matchedUser.getEmail());

            resp.sendRedirect("/home");
        } else {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
        }
    }


}
