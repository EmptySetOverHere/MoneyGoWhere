package com.cz2006.group3.servlet;

import com.cz2006.group3.bean.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;


@WebServlet(urlPatterns = "/report")
public class ReportServlet extends AbstractServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        ArrayList<Double> unitExp = new ArrayList<>(); unitExp.add(1.00); unitExp.add(2.00);
        HashMap<String, Double> cateExp = new HashMap<>(); cateExp.put("food", 2.00); cateExp.put("drink", 1.00);
        ReceiptData r = new ReceiptData("HSGBKJ123", "each a cup", LocalDateTime.now(), 1.00, "food", "bubble tea 50% sugar");
        ArrayList<ReceiptData> rs = new ArrayList<>(); rs.add(r);
        ReportData report = new ReportData(3.00, unitExp, cateExp, rs);
        ReportModel reportmodel = new ReportModel(-1, "first report", report);

        System.out.println(req.getParameter("year"));
        System.out.println(req.getParameter("month"));
//        String user = (String) req.getSession().getAttribute("user");
//        String lang = parseLanguageFromCookie(req);
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter pw = resp.getWriter();
        pw.write(reportmodel.toString());
        pw.flush();
    }

    @Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(req.getInputStream()));
        // String.of(new InputStreamReader(eeq))
        // String username = req.getParameter("username");
        // String password = req.getParameter("password");
        System.out.println(reader.readLine());

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter pw = resp.getWriter();
        UserData u1data  = new UserData(0, "alice.google.com", "1", "0", 88888888);
        UserModel u1 = new UserModel(-1, "bob123", u1data);

        pw.write(u1.toString());
        pw.flush();
    }

}
