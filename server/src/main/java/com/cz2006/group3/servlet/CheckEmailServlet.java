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
 * This class handles POST request from the client side who is checking for account email duplicates.
 */
@WebServlet(urlPatterns = "/checkemail")
public class CheckEmailServlet extends AbstractServlet{

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println("User is checking email");
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
        String errorMsg;
        int errorCode = -1;

        if (exist == true) {
            errorMsg = "This email has already been used!";
        }else{
            errorMsg = "OK.";
            errorCode = 0;
        }
        pw.write("{\"errorCode\":" + errorCode + ",\"errorMsg\":\"" + errorMsg + "\"}");
        pw.flush();
    }
}
