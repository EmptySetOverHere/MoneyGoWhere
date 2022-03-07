package com.cz2006.group3.bean;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DBConnector{
    public static DataSource ds = null;
    public void Init() throws SQLException {
        System.out.println("Initiating MySQL...");
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl(jdbcUrl);
        config.setUsername(jdbcUsername);
        config.setPassword(jdbcPassword);
        config.addDataSourceProperty("cachePrepStmts", "true");
        config.addDataSourceProperty("prepStmtCacheSize", "100");
        config.addDataSourceProperty("maximumPoolSize", "20");
        ds = new HikariDataSource(config);
        // List<UserData> users = queryUsers(ds);
        // users.forEach(System.out::println);
    }

    public static UserData queryUser(String username) throws SQLException {
        UserData matchedUser = null;
        try (Connection conn = ds.getConnection()) {
            try (PreparedStatement ps = conn
                    .prepareStatement("SELECT * FROM users WHERE username == ?")) {
                ps.setString(1, username);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        matchedUser = extractRow(rs);
                    }
                }
            }
        }
        return matchedUser;
    }

    static UserData extractRow(ResultSet rs) throws SQLException {
        UserData user = new UserData(rs.getInt("id"), rs.getString("email"),
                rs.getString("password"), rs.getString("username"));
        return user;
    }

    public static void CreateUser(String email, String password) throws SQLException{
        try (Connection conn = ds.getConnection()){
            try (PreparedStatement ps = conn.prepareStatement(
                    " INSERT INTO users (id, email, password, username) VALUES (3, ?, ?, ?);")){
                ps.setString(1, email);
                ps.setString(2, password);
                ps.setString(3, "vaoergbof1adjsif");
                try (ResultSet rs = ps.executeQuery()){}
            }
        }
    }


    static final String jdbcUrl = "jdbc:mysql://localhost/cz2006group3?useSSL=false&characterEncoding=utf8";
    static final String jdbcUsername = "root";
    static final String jdbcPassword = "Sally271828*";

}
