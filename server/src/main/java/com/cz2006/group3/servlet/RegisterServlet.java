package com.cz2006.group3.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import org.json.JSONObject;

import com.cz2006.group3.bean.DBConnector;

/**
 * This class handles POST request from the client side who is requesting for registration.
 */
@WebServlet(urlPatterns = "/register")
public class RegisterServlet extends AbstractServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        JSONObject json = new JSONObject(req.getReader().readLine());
        String email = json.getString("email");
        System.out.println(email);
        String password = json.getString("password");
        System.out.println("new user is registering....");
        System.out.println(password);
        int uid = -1;
        // create a new user
        try {
            uid = DBConnector.CreateUser(email, password);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        resp.setContentType("text/plain");
        PrintWriter pw = resp.getWriter();
        pw.write(""+uid);
        pw.flush();
        // req.getSession().setAttribute("email", email);
        // resp.sendRedirect("/home");
    }

}
