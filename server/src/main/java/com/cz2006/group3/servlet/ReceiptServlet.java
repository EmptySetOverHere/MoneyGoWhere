package com.cz2006.group3.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import com.cz2006.group3.bean.DBConnector;
import com.cz2006.group3.bean.ReceiptData;
import com.cz2006.group3.bean.SearchFilter;

@WebServlet(urlPatterns = "/receipts")
public class ReceiptServlet extends AbstractServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{
        System.out.println("user requesting receipts");
        String query = req.getQueryString();
        System.out.println(query);
        // SearchFilter criteria(query);


        ArrayList<ReceiptData> receipts;

        if (query == null){
            // receipts = DBConnector.retrieveReciptsDefault(email);
        }else{
            // receipts = DBConnector.retrieveReceipts(email, criteria);
        }



        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter pw = resp.getWriter();
        // pw.write(ms.toString());
        pw.flush();
    }
}
