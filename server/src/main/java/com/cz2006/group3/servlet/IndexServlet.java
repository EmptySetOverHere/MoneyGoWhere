package com.cz2006.group3.servlet;

import java.io.*;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cz2006.group3.bean.DBConnector;
import com.cz2006.group3.bean.ReceiptData;
import com.cz2006.group3.bean.ReceiptsModel;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 * This is the default home route.
 */
@WebServlet(urlPatterns = "/home")
public class IndexServlet extends AbstractServlet {
    // private final Logger logger = LogManager.getLogger(this.getClass());
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int uid = req.getIntHeader("uid");
        System.out.println("User " + uid + "requests for default receipts");
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter pw = resp.getWriter();
        ArrayList<ReceiptData> receipts = null;
        int errorCode = -1;
        String errorMsg = "";
        try {
            receipts = DBConnector.getReceiptsDefault(uid);
        }catch (SQLException e){
            errorMsg = "Get default receipt failed";
            e.printStackTrace();
        }
        pw.write((new ReceiptsModel(errorCode, errorMsg, receipts)).toString());
        pw.flush();
    }
}
