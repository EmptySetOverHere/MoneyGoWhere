package com.cz2006.group3.servlet;

import java.io.*;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cz2006.group3.bean.*;

/**
 * This is the default home route.
 */
@WebServlet(urlPatterns = "/home")
public class IndexServlet extends AbstractServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int uid = req.getIntHeader("uid");
//        String user = (String) req.getSession().getAttribute("user");
//        String lang = parseLanguageFromCookie(req);
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter pw = resp.getWriter();
        ArrayList<ReceiptData> receipts = null;
        int errorCode = -1;
        String errorMsg = "";
        try {
            receipts = DBConnector.getReceiptsDefault(uid);
        }catch (SQLException e){
            e.printStackTrace();
        }
        pw.write((new ReceiptsModel(errorCode, errorMsg, receipts)).toString());
        pw.flush();
    }
}
