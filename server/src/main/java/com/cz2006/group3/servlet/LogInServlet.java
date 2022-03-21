package com.cz2006.group3.servlet;

import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONObject;

import com.cz2006.group3.bean.DBConnector;
import com.cz2006.group3.bean.UserData;
import com.cz2006.group3.bean.UserModel;

/**
 * This class handles POST request from the client side who is requesting for logging in.
 */
@WebServlet(urlPatterns = "/login")
public class LogInServlet extends AbstractServlet{

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        JSONObject json = new JSONObject(req.getReader().readLine());
        String email = json.getString("email");
        String password = json.getString("password");
        System.out.println("User "+ email + " is logining in");
        UserData matchedUser = null;
        try {
            matchedUser = DBConnector.queryUser(email);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        String expectedPassword = matchedUser.getPassword();

        if (expectedPassword != null && expectedPassword.equals(password)) {
            // req.getSession().setAttribute("email", matchedUser.getEmail());
            // req.getSession().setAttribute("id", matchedUser.getUID());
            resp.setContentType("application/json");
            PrintWriter pw = resp.getWriter();
            pw.write((new UserModel(0, "", matchedUser)).toString());
            pw.flush();
            // resp.sendRedirect("/home");
        } else {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
        }
    }
}
