package com.cz2006.group3.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;
import org.json.JSONObject;

import com.cz2006.group3.bean.UserData;
import com.cz2006.group3.bean.DBConnector;




/**
 * This class handles POST request from the client side who is checking for account email duplicates.
 */
@WebServlet(urlPatterns = "/checkemail")
public class CheckEmailServlet extends AbstractServlet{
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println("user is checking....");
        // BufferedReader reader = req.getReader();
        // System.out.println(reader.readLine());
        JSONObject json = new JSONObject(req.getReader().readLine());
        String email = (String)json.get("email");
        System.out.println(email);
        boolean exist = false;
        try {
            exist = DBConnector.queryEmail(email.toLowerCase());
        } catch (SQLException e) {
            e.printStackTrace();
        }
        resp.setCharacterEncoding("UTF-8");
        PrintWriter pw = resp.getWriter();
        if (exist == true) {
            pw.write("This email is already used!");
            pw.flush();
        }else{
            pw.write("OK.");
            pw.flush();
        }
    }
}