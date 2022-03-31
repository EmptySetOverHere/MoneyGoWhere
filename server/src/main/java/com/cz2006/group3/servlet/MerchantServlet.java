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
import com.cz2006.group3.bean.MerchantData;
import com.cz2006.group3.bean.MerchantsModel;


/**
 * This class handles GET request from the client side who is requesting for a list of merchant.
 */
@WebServlet(urlPatterns = "/merchant")
public class MerchantServlet extends AbstractServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println(req.getQueryString());
        int uid = req.getIntHeader("uid");
//        // return the most recent 5 merchants
//        MerchantData m = new MerchantData("each a cup", 639798, "50 Nanyang Ave, NS3-01-21 NTU North Spine",
//                "Beverage", 5.7);
//        MerchantsModel ms = new MerchantsModel(-1, "first merchant", m);
        ArrayList<MerchantData> merchants = null;
        int errorCode = -1;
        String errorMsg = "";
        try {
            merchants = DBConnector.getMerchantsDefault(uid);
        }catch (SQLException e){
            e.printStackTrace();
        }
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter pw = resp.getWriter();
        pw.write((new MerchantsModel(errorCode, errorMsg, merchants)).toString());
        pw.flush();
    }

}
