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
    // private final Logger logger = LogManager.getLogger(this.getClass());
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        JSONObject json = new JSONObject(req.getReader().readLine());
        System.out.println(json);
        String email = json.getString("email");
        String password = json.getString("password");
        System.out.println("User "+ email + " is loggining in");

        UserData matchedUser = null;
        int errorCode = -1;
        String errorMsg = "";
        try {
            matchedUser = DBConnector.queryUser(email);
        } catch (SQLException e) {
            errorMsg = "database connection error";
            e.printStackTrace();
        }

        String expectedPassword = matchedUser.getPassword();
        resp.setContentType("application/json");
        PrintWriter pw = resp.getWriter();

        if (expectedPassword != null && expectedPassword.equals(password)) {
            // req.getSession().setAttribute("email", matchedUser.getEmail());
            // req.getSession().setAttribute("id", matchedUser.getUID());
            errorCode = 0;
            // resp.sendRedirect("/home");
        } else {
            errorMsg = "Wrong email or password";
        }
        pw.write((new UserModel(errorCode, errorMsg, matchedUser)).toString());
        pw.flush();
    }
}
