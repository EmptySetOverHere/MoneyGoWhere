package com.cz2006.group3.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.ArrayList;

import com.cz2006.group3.bean.DBConnector;
import com.cz2006.group3.bean.ReceiptData;
import com.cz2006.group3.bean.ReceiptsModel;
import com.cz2006.group3.bean.SearchFilter;
import org.json.JSONObject;

/**
 * This class handles POST request from the client side who is requesting for a list of receipts.
 */
@WebServlet(urlPatterns = "/receipts")
public class ReceiptServlet extends AbstractServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{
        int uid = req.getIntHeader("uid");
        System.out.println("user " + uid + " is requesting receipts");
        String query = req.getReader().readLine();
        System.out.println(query);
        SearchFilter criteria = new SearchFilter(new JSONObject(query));
        ArrayList<ReceiptData> receipts = null;
        int errorCode = 0;
        String errorMsg = "";
        if (query == null){
            try {
                receipts = DBConnector.getReceiptsDefault(uid);
            }catch (SQLException e) {
                e.printStackTrace();
                errorCode = -1;
                errorMsg = "request unsuccessful";
            }
        }else{
            try {
                receipts = DBConnector.getReceipts(uid, criteria);
            }catch (SQLException e) {
                e.printStackTrace();
                errorCode = -1;
                errorMsg = "request unsuccessful";
            }
        }
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter pw = resp.getWriter();
        pw.write((new ReceiptsModel(errorCode, errorMsg, receipts)).toString());
        pw.flush();

    }
}
