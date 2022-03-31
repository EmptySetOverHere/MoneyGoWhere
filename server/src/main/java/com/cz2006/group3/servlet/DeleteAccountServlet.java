package com.cz2006.group3.servlet;

import com.cz2006.group3.bean.DBConnector;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

/**
 * This class handles DELETE request from the client side who is requesting for deletion of an account.
 */
@WebServlet(urlPatterns = "/deleteaccount")
public class DeleteAccountServlet extends AbstractServlet {
    private final Logger logger = LogManager.getLogger(this.getClass());
    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int uid = req.getIntHeader("uid");
        logger.info("User " + uid + "requests for deleting account");
        try {
            DBConnector.DeleteUser(uid);
        }catch (SQLException e){
            e.printStackTrace();
        }
        PrintWriter pw = resp.getWriter();
        pw.write("Delete account successfull");
        pw.flush();
    }

}
