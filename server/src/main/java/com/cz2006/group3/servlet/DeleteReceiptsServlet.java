package com.cz2006.group3.servlet;

import com.cz2006.group3.bean.DBConnector;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

/**
 * This class handles DELETE request from the client side who is requesting for deletion of a receipt.
 */
@WebServlet(urlPatterns = "/deletereceipt")
public class DeleteReceiptsServlet extends AbstractServlet {
    // private final Logger logger = LogManager.getLogger(this.getClass());
    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int uid = req.getIntHeader("uid");
        int rindex = Integer.parseInt(req.getParameter("index"));
        System.out.println("User "+ uid +" requests for deleting receipt " + rindex);
        // TODO:
        try {
            DBConnector.deleteReceipt(uid, rindex);
        }catch (SQLException e){
            e.printStackTrace();
        }
    }


}
