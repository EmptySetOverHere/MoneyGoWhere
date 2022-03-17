package com.cz2006.group3.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

import com.cz2006.group3.bean.DBConnector;
import org.json.JSONObject;


@WebServlet(urlPatterns = "/register")
public class RegisterServlet extends AbstractServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        JSONObject json = new JSONObject(req.getReader().readLine());
        String email = (String)json.get("email");
        System.out.println(email);
        String password = (String)json.get("password");
        System.out.println("new user is registering....");
        System.out.println(password);
        int uid;
        // create a new user
        try {
            uid = DBConnector.CreateUser(email, password);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        PrintWriter pw = resp.getWriter();
        pw.write("register successfully");
        pw.flush();
        // req.getSession().setAttribute("email", email);
        // resp.sendRedirect("/home");
    }

}
