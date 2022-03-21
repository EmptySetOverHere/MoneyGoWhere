package com.cz2006.group3.servlet;

import com.cz2006.group3.bean.DBConnector;
import org.json.JSONObject;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Iterator;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * This class handles PATCH request from the client side who is requesting for updating his/her account details.
 */
@WebServlet(urlPatterns = "/updateaccount")
public class UpdateAccountServlet extends AbstractServlet{
    @Override
    protected void doPatch(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int uid = req.getIntHeader("uid");
        System.out.println("User" + uid + " is updating his/her account");

        JSONObject jsonQuery = new JSONObject(req.getReader().readLine());
        System.out.println(jsonQuery.keys());
        Iterator<String> keys = jsonQuery.keys();

        while (keys.hasNext()){
            String key = keys.next();
            if (key.equals("phoneno")){
                System.out.println(jsonQuery.getInt(key));
                try {
                    DBConnector.updateUser(uid, jsonQuery.getInt(key));
                }catch (SQLException e){
                    e.printStackTrace();
                }

            }
            if (key.equals("username")){
                System.out.println(jsonQuery.get(key));
                try {
                    DBConnector.updateUser(uid, jsonQuery.getString(key));
                } catch (SQLException e){
                    e.printStackTrace();
                }

            }
        }
    }
}
