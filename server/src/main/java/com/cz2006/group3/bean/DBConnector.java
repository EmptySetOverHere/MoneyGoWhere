package com.cz2006.group3.bean;

import com.zaxxer.hikari.*;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;


public class DBConnector{

    private static HikariConfig config = new HikariConfig();
    private static HikariDataSource ds;

    static final String jdbcUrl = "jdbc:mysql://localhost/cz2006group3?useSSL=false&characterEncoding=utf8";
    static final String jdbcUsername = "root";
    static final String jdbcPassword = "Sally271828*";

    static{
        System.out.println("Initiating Connection to MySQL...");
        config.setJdbcUrl(jdbcUrl);
        config.setUsername(jdbcUsername);
        config.setPassword(jdbcPassword);
        config.addDataSourceProperty("cachePrepStmts", "true");
        config.addDataSourceProperty("prepStmtCacheSize", "100");
        config.addDataSourceProperty("maximumPoolSize", "20");
        ds = new HikariDataSource(config);
        // List<UserData> users = queryUsers();
        // users.forEach(System.out::println);
    }

    private DBConnector(){}
    public static Connection getConnection() throws SQLException {
        return ds.getConnection();
    }

    public static boolean queryEmail(String email) throws SQLException {
        boolean exist = false;
        try (Connection conn = ds.getConnection()) {
            try (PreparedStatement ps = conn
                    .prepareStatement("SELECT * FROM users WHERE email = ?")) {
                ps.setString(1, email);
                try (ResultSet rs = ps.executeQuery()) {
                    if(rs.next()==true){
                        exist = true;
                    }
                }
            }
        }
        return exist;
    }

    public static UserData queryUser(String email) throws SQLException {
        UserData matchedUser = null;
        try (Connection conn = ds.getConnection()) {
            try (PreparedStatement ps = conn
                    .prepareStatement("SELECT * FROM users WHERE email = ?")) {
                ps.setString(1, email);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next() == true){
                        matchedUser = extractUser(rs);
                    }
                }
            }
        }
        return  matchedUser;
    }
    public static ArrayList<UserData> queryUsers() throws SQLException {
        ArrayList<UserData> ret = new ArrayList<>();
        try (Connection conn = ds.getConnection()) {
            try (PreparedStatement ps = conn
                    .prepareStatement("SELECT * FROM users")) {
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next() == true){
                        ret.add(extractUser(rs));
                    }
                }
            }
        }
        return ret;
    }

    static UserData extractUser(ResultSet rs) throws SQLException {
        UserData user = new UserData(rs.getInt("uid"), rs.getString("email"),
                rs.getString("password"), rs.getString("username"), rs.getInt("phoneno"));
        return user;
    }

    public static int CreateUser(String email, String password) throws SQLException{
        System.out.println("Creating new user in the database...");
        int uid = -1;
        try (Connection conn = ds.getConnection()){
            try (PreparedStatement ps = conn.prepareStatement(
                    " INSERT INTO users (email, password, username, phoneno) VALUES (?, ?, ?, ?);")){
                ps.setString(1, email);
                ps.setString(2, password);
                ps.setString(3, "vaoergbof1adjsif");
                ps.setInt(4, 0);
                ps.executeUpdate();
            }

            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT uid FROM users WHERE email = ?")){
                ps.setString(1, email);
                try(ResultSet rs = ps.executeQuery()){
                    uid = rs.getInt("uid");
                }
            }
            System.out.println(uid);
            // create receipt table for each newly create user
            String tableName = "U" + uid + "Receipts";
            try (PreparedStatement ps = conn.prepareStatement(
                    " CREATE TABLE ? (rid VARCHAR(100), merchant VARCHAR(100), " +
                            "datetime TIMESTAMP, totalPrice DOUBLE, category VARCHAR(20), content VARCHAR(100000)) ")){
                ps.setString(1, tableName);
                ps.executeUpdate();
            }
        }
        return uid;
    }

    public static ArrayList<ReceiptData> getReceiptsDefault(String email) throws SQLException {
        ArrayList<ReceiptData> receipts = new ArrayList<>();
        try(Connection conn = ds.getConnection()){
            String tableName = email;
            try (PreparedStatement ps = conn.prepareStatement("SELECT * FROM receipts WHERE uid = ? AND dateTime >= ? AND dateTime <= ?")){
                ps.setString(1, email);
                try (ResultSet rs = ps.executeQuery()){
                    while (rs.next()){
                        receipts.add(extractReceipt(rs));
                    }
                }
            }
        }
        return receipts;
    }

    static ReceiptData extractReceipt(ResultSet rs) throws SQLException{
        ReceiptData receipt = new ReceiptData(rs.getString("rid"),
                                    rs.getString("merchant"),
                                    rs.getTimestamp("dateTime").toLocalDateTime(),
                                    rs.getDouble("totalPrice"),
                                    rs.getString("category"),
                                    rs.getString("content"));
        return receipt;
    }


    public static void DeleteUser(String email) throws SQLException{
        try (Connection conn = ds.getConnection()){

        }
    }





}
