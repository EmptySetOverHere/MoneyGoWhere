package com.cz2006.group3.bean;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import javax.sql.DataSource;
import java.util.List;

public class DBConnector{

    public void Init(){
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl(jdbcUrl);
        config.setUsername(jdbcUsername);
        config.setPassword(jdbcPassword);
        config.addDataSourceProperty("cachePrepStmts", "true");
        config.addDataSourceProperty("prepStmtCacheSize", "100");
        config.addDataSourceProperty("maximumPoolSize", "10");
        DataSource ds = new HikariDataSource(config);
        // List<UserModel> students = queryStudents(ds);
        // students.forEach(System.out::println);
    }





    static final String jdbcUrl = "jdbc:mysql://localhost/learnjdbc?useSSL=false&characterEncoding=utf8";
    static final String jdbcUsername = "learn";
    static final String jdbcPassword = "learnpassword";

}
