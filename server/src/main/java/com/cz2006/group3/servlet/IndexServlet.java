package com.cz2006.group3.servlet;

import java.io.*;
import java.util.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cz2006.group3.bean.UserModel;

@WebServlet(urlPatterns = "/")
public class IndexServlet extends HttpServlet {
    static private Map<String, String> mockDatabase = Map.of("Hello,", "CZ2006Group3!");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        UserModel u1 = new UserModel(-1, "bob123", 0, "alice.google.com", "alice123", "alice");

//        String user = (String) req.getSession().getAttribute("user");
//        String lang = parseLanguageFromCookie(req);
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter pw = resp.getWriter();
        pw.write(u1.toString());
//        if (lang.equals("zh")) {
//            pw.write("<h1>欢迎, " + (user != null ? user : "Guest") + "</h1>");
//            if (user == null) {
//                pw.write("<p><a href=\"/signin\">登录</a></p>");
//            } else {
//                pw.write("<p><a href=\"/signout\">退出</a></p>");
//            }
//        } else {
//            pw.write("<h1>Welcome, " + (user != null ? user : "Guest") + "</h1>");
//            if (user == null) {
//                pw.write("<p><a href=\"/signin\">Sign In</a></p>");
//            } else {
//                pw.write("<p><a href=\"/signout\">Sign Out</a></p>");
//            }
//        }
//        pw.write("<p><a href=\"/pref?lang=en\">English</a> | <a href=\"/pref?lang=zh\">中文</a>");
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
        UserModel u1 = new UserModel(-1, "bob123", 0, "alice.google.com", "1", "0");

        pw.write(u1.toString());
        pw.flush();


    }

    private String parseLanguageFromCookie(HttpServletRequest req) {
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("lang")) {
                    return cookie.getValue();
                }
            }
        }
        return "en";
    }
}