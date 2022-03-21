package com.cz2006.group3.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import org.json.JSONArray;
import org.json.JSONObject;

import com.cz2006.group3.bean.DBConnector;

/**
 * This class handles POST request from the client side
 * who is requesting for backing up his/her account data.
 */
@WebServlet(urlPatterns = "/sync")
public class SyncServlet extends AbstractServlet{
    @ Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int uid = req.getIntHeader("uid");
        JSONObject jsonQuery = new JSONObject(req.getReader().readLine());
        JSONArray dataArr = jsonQuery.getJSONArray("data");
        try {
            DBConnector.putReceipts(uid, dataArr);
        }catch (SQLException e){
            e.printStackTrace();
        }
        PrintWriter pw = resp.getWriter();
        pw.write("Saved!");
        pw.flush();
    }
}
