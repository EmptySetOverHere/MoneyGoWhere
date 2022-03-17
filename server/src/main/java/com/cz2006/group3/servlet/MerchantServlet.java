package com.cz2006.group3.servlet;

import com.cz2006.group3.bean.MerchantData;
import com.cz2006.group3.bean.MerchantsModel;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;


@WebServlet(urlPatterns = "/merchant")
public class MerchantServlet extends AbstractServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println(req.getQueryString());
        MerchantData m = new MerchantData("each a cup", 639798, "50 Nanyang Ave, NS3-01-21 NTU North Spine",
                "Beverage", 5.7);
        MerchantsModel ms = new MerchantsModel(-1, "first merchant", m);
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter pw = resp.getWriter();
        pw.write(ms.toString());
        pw.flush();
    }

}
