package com.cz2006.group3.bean;

import com.zaxxer.hikari.*;
import org.json.JSONArray;
import org.json.JSONObject;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.UUID;


/**
 * (Singleton)DBConnector manages the connection between the server and database.
 * It provides basic methods to retrieve information from/modify information stored in the database.
 *
 */
public class DBConnector{
    /**
     * A configuration tool for database connection multiplexing .
     */
    private static HikariConfig config = new HikariConfig();
    /**
     * An connection object for database connection multiplexing.
     */
    private static HikariDataSource ds;
    /**
     * database url constant.
     */
    static final String jdbcUrl = "jdbc:mysql://119.13.107.101/cz2006group3?useSSL=false&characterEncoding=utf8";
    /**
     * database user account constant.
     */
    static final String jdbcUsername = "root";
    /**
     * database account password
     */
    static final String jdbcPassword = "cz2006group3!";



    static{
        System.out.println("connecting to Mysql server database...");
        config.setJdbcUrl(jdbcUrl);
        config.setUsername(jdbcUsername);
        config.setPassword(jdbcPassword);
        config.addDataSourceProperty("cachePrepStmts", "true");
        config.addDataSourceProperty("prepStmtCacheSize", "100");
        config.addDataSourceProperty("maximumPoolSize", "20");
        ds = new HikariDataSource(config);
    }

    /**
     * Disable DBConnector constructor (for Singleton).
     */
    private DBConnector(){}

    /**
     * Performs a selection search according to the input email.
     * This method is used for checking if an email has been registered before.
     *
     * Avoid duplicated user registration.
     * @param email a user's email.
     * @return true if the user already exist.
     * @throws SQLException
     */
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

    /**
     * Performs a search of user in the database and retrieve it.
     * This method is used for checking the correctness of user password during logging in stage.
     *
     * @param email a user's email.
     * @return a UserData object.
     * @throws SQLException
     */
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

    /**
     * Extracts a user from database.
     *
     * @param rs an object that contains the results of executing an SQL query.
     * @return a UserData object
     * @throws SQLException
     */
    static UserData extractUser(ResultSet rs) throws SQLException {
        UserData user = new UserData(rs.getInt("uid"), rs.getString("email"),
                rs.getString("password"), rs.getString("username"), rs.getInt("phoneno"));
        return user;
    }

    /**
     * Inserts a new user in the database with the provided email and password.
     *
     * @param email the user's valid email.
     * @param password the user's password.
     * @return uid the user's unique identifier stored in the database.
     * @throws SQLException
     */
    public static int CreateUser(String email, String password) throws SQLException{
        System.out.println("Creating new user in the database...");
        int uid = -1;
        String random_username = UUID.randomUUID().toString();
        try (Connection conn = ds.getConnection()){
            try (PreparedStatement ps = conn.prepareStatement(
                    " INSERT INTO users (email, password, username, phoneno) VALUES (?, ?, ?, ?);")){
                ps.setString(1, email);
                ps.setString(2, password);
                ps.setString(3, random_username);
                ps.setInt(4, 0);
                ps.executeUpdate();
            }

            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT uid FROM users WHERE email = ?;")){
                ps.setString(1, email);
                try(ResultSet rs = ps.executeQuery()){
                    if (rs.next() == true) {
                        uid = rs.getInt("uid");
                    }
                }
            }

            System.out.println("Initializing user-specific receipt table for user "+uid+" ...");
            // create receipt table for each newly create user
            String tableName = "U" + uid + "_Receipts";
            try (PreparedStatement ps = conn.prepareStatement(
                    " CREATE TABLE " + tableName + " ( rindex BIGINT NOT NULL AUTO_INCREMENT, rid VARCHAR(100), merchant VARCHAR(100), address VARCHAR(100), postalCode INT," +
                            " datetime_ TIMESTAMP, totalPrice DOUBLE, category VARCHAR(20), content VARCHAR(255), products LONGTEXT ,PRIMARY KEY (rindex));")){
                ps.executeUpdate();
            }
        }
        return uid;
    }

    /**
     * Modifies the user according to the given uid with new username
     *
     * @param uid the user's unique identifier
     * @param username the new username to be updated.
     * @throws SQLException
     */
    public static void updateUser(int uid, String username) throws SQLException {
        try (Connection conn = ds.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement("UPDATE users SET username = ? WHERE uid = ?")) {
                ps.setString(1, username);
                ps.setInt(2, uid);
                ps.executeUpdate();
            }
        }
    }

    /**
     * Modifiers the user according to the given uid with new phone number
     *
     * @param uid the user's unique identifier
     * @param phoneno the new phone number to be updated.
     * @throws SQLException
     */
    public static void updateUser(int uid, int phoneno) throws SQLException {
        try (Connection conn = ds.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement("UPDATE users SET phoneno = ? WHERE uid = ?")) {
                ps.setInt(1, phoneno);
                ps.setInt(2, uid);
                ps.executeUpdate();
            }
        }
    }

    /**
     * Remove the user entirely from the database.
     *
     * @param uid the user's unique identifier
     * @throws SQLException
     */
    public static void DeleteUser(int uid) throws SQLException{
        try (Connection conn = ds.getConnection()) {
            String tableName = "U" + uid + "_Receipts";
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM users WHERE uid = ?")) {
                ps.setInt(1, uid);
                ps.executeUpdate();
            }
            try (PreparedStatement ps = conn.prepareStatement("DROP TABLE " + tableName + ";")){
                ps.executeUpdate();
            }
        }
    }

    /**
     * Default methods that retrieves the most recent 20 receipts from the database.
     *
     * @param uid the user's unique identifier.
     * @return a list of requested receipts
     * @throws SQLException
     */
    public static ArrayList<ReceiptData> getReceiptsDefault(int uid) throws SQLException {
        ArrayList<ReceiptData> receipts = new ArrayList<>();
        try(Connection conn = ds.getConnection()){
            String tableName = "U" + uid + "_Receipts";
            try (PreparedStatement ps = conn.prepareStatement("SELECT * FROM "+tableName+" ORDER BY datetime_ DESC;")){
                try (ResultSet rs = ps.executeQuery()){
                    while (rs.next()){
                        receipts.add(extractReceipt(rs));
                    }
                }
            }
        }
        for (int i =0 ; i< receipts.size(); i++){
            System.out.println(receipts.get(i).toString());
        }
        return receipts;
    }

    /**
     * Retrieves receipts according to a given search criteria.
     *
     * @param uid the user's unique identifier.
     * @param criteria the search requirements.
     * @return a list receipts that fulfills the given requirements.
     * @throws SQLException
     */
    public static ArrayList<ReceiptData> getReceipts(int uid, SearchFilter criteria) throws SQLException {
        String condition = ""; ArrayList<String> categories = null;
        if (criteria.getContent()!=null){ condition += "products LIKE ? AND "; }
        if (criteria.getCategory() != null){ categories = criteria.getCategory(); for (int i = 0; i<categories.size(); i++) { condition += "categeory = ? AND "; } }
        if (criteria.getStartDate() != null){ condition += "DATE(datetime_) >= ? AND "; }
        if (criteria.getEndDate() != null){ condition += "DATE(datetime_) <= ? AND "; }
        if (criteria.getPriceLower() != null){ condition += "totalPrice >= ? AND "; }
        if (criteria.getPriceUpper() != null){ condition += "totalPrice <= ? AND "; }
        System.out.println(condition);
        if (condition.substring(condition.length()-5, condition.length()-1).equals("AND ")){
            condition = condition.substring(condition.length()-5);
        }
        ArrayList<ReceiptData> receipts = new ArrayList<>();
        try(Connection conn = ds.getConnection()){
            String tableName = "U" +uid +"_Receipts";
            try (PreparedStatement ps = conn.prepareStatement("SELECT * FROM " + tableName +
                    "WHERE " + condition +
                    "ORDER BY dateTime DESC;")){
                int index = 0;
                if (criteria.getContent() != null){ ps.setString(++index,"%" + criteria.getContent() + "%");}
                if (criteria.getCategory() != null){ for (String c : categories){ ps.setString(++index, c); } }
                if (criteria.getStartDate() != null){ ps.setString(++index, criteria.getStartDate().toString()); }
                if (criteria.getEndDate() != null){ ps.setString(++index, criteria.getEndDate().toString()); }
                if (criteria.getPriceLower() != null){ ps.setDouble(++index, criteria.getPriceLower()); }
                if (criteria.getPriceUpper() != null){ ps.setDouble(++index, criteria.getPriceUpper()); }

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()){ receipts.add(extractReceipt(rs)); }
                }
            }
        }
        return receipts;
    }

    /**
     * Inserts new receipts into the database.
     * This method is used for backing up user's local data to thge.
     *
     * @param uid the user's unique identifier.
     * @param receipts An array of receipts for backing up.
     * @throws SQLException
     */
    public static void putReceipts(int uid, JSONArray receipts) throws SQLException {
        // DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String tableName = "U" + uid + "_Receipts";
        try(Connection conn = ds.getConnection()) {
            for (int i = 0; i<receipts.length(); i++){
                JSONObject r = (JSONObject) receipts.get(i);
                try (PreparedStatement ps = conn.prepareStatement("INSERT INTO " + tableName +
                        " (rid, merchant,address, postalCode, datetime_, totalPrice, category, content, products)" +
                        " VALUES (?, ?, ?, ?, ?, ?, ?, ? )")){
                    ps.setString(1, r.getString("id"));
                    ps.setString(2, r.getString("merchant"));
                    ps.setString(3, r.getString("address"));
                    ps.setInt(4, r.getInt("postalCode"));
                    ps.setString(5, r.getString("datetime_"));
                    ps.setDouble(6, r.getDouble("totalPrice"));
                    ps.setString(7, r.getString("category"));
                    ps.setString(8, r.getString("content"));
                    ps.setString(9, r.getString("products"));
                    ps.executeUpdate();
                }
            }
        }
    }

    /**
     * Removes a specific receipt from the database according to a given receipt identifier.
     *
     * @param uid the user's unique identifier.
     * @param rindex a receipt's unique identifier.
     * @throws SQLException
     */
    public static void deleteReceipt(int uid, int rindex) throws SQLException {
        try (Connection conn = ds.getConnection()){
            String tableName = "U" + uid + "_Receipts";
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM " + tableName + " WHERE rindex = ?;")){
                ps.setInt(1, rindex);
                ps.executeUpdate();
            }
        }
    }

    /**
     * Extracts receipts from the database.
     *
     * @param rs an object that contains the results of executing an SQL query.
     * @return an ReceiptData object.
     * @throws SQLException
     */
    static ReceiptData extractReceipt(ResultSet rs) throws SQLException{
        ArrayList<ProductData> products = new ArrayList<>();
        JSONArray jsonProducts = new JSONArray(rs.getString("products"));
        for (int i =0; i<jsonProducts.length(); i++){
            products.add(new ProductData(new JSONObject(jsonProducts.getString(i))));
        }
        ReceiptData receipt = new ReceiptData(rs.getInt("rindex"),
                                    rs.getString("rid"),
                                    rs.getString("merchant"),
                                    rs.getString("address"),
                                    rs.getInt("postalCode"),
                                    rs.getTimestamp("datetime_").toLocalDateTime(),
                                    rs.getDouble("totalPrice"),
                                    rs.getString("category"),
                                    products,
                                    rs.getString("content"));
        return receipt;
    }


    /**
     * Retrieves top merchant from database arranged according to datetime.
     *
     * @param uid the user's unique identifier.
     * @return a list of merchants.
     * @throws SQLException
     */
    public static ArrayList<MerchantData> getMerchantsDefault(int uid) throws SQLException {
        ArrayList<MerchantData> merchants = new ArrayList<>();
        try(Connection conn = ds.getConnection()){
            String tableName = "U" + uid + "_Receipts";
            try (PreparedStatement ps = conn.prepareStatement("SELECT merchant, SUM(totalPrice) totalExpense FROM " + tableName + " WHERE datetime_ >= ? GROUP BY merchant;")){
                ps.setString(1, LocalDateTime.now().minusMonths(1).toString());
                try (ResultSet rs = ps.executeQuery()){
                    while (rs.next()){
                        merchants.add(extractMerchant(rs));
                    }
                }
            }
            for (MerchantData m: merchants) {
                try (PreparedStatement ps = conn.prepareStatement("SELECT address, postalCode, category FROM " + tableName + " WHERE merchant=?")) {
                    ps.setString(1, m.getName());
                    try(ResultSet rs = ps.executeQuery()){
                        if(rs.next()){
                            m.setAddress(rs.getString("address"));
                            m.setPostalCode(rs.getInt("postalCode"));
                            m.setCategory(rs.getString("category"));
                        }
                    }
                }
            }
        }
        return merchants;
    }

    /**
     * Retrieves requested merchant from database arranged according to datetime.
     *
     * @param uid the user's unique identifier
     * @param merchant the merchant name
     * @return A list of requested merchants
     * @throws SQLException
     */
    public static ArrayList<MerchantData> getMerchants(int uid, String merchant) throws SQLException {
        ArrayList<MerchantData> merchants = new ArrayList<>();
        try(Connection conn = ds.getConnection()){
            String tableName = 'U' + uid + "_Receipts";
            try (PreparedStatement ps = conn.prepareStatement("SELECT merchant, SUM(totalPrice) totalExpense FROM " + tableName + " WHERE merchant LIKE %?% AND datetime_ >= ? GROUP BY merchant;")){
                ps.setString(1, merchant);
                ps.setString(2, LocalDateTime.now().minusMonths(1).toString());
                try (ResultSet rs = ps.executeQuery()){
                    while (rs.next()){
                        merchants.add(extractMerchant(rs));
                    }
                }
            }
            for (MerchantData m: merchants) {
                try (PreparedStatement ps = conn.prepareStatement("SELECT address, postalCode, category FROM " + tableName + " WHERE merchant=?")) {
                    ps.setString(1, m.getName());
                    try(ResultSet rs = ps.executeQuery()){
                        if(rs.next()){
                            m.setAddress(rs.getString("address"));
                            m.setPostalCode(rs.getInt("postalCode"));
                            m.setCategory(rs.getString("category"));
                        }
                    }
                }
            }
        }
        return merchants;
    }

    /**
     * Extracts merchants from the database.
     *
     * @param rs an object that contains the results of executing an SQL query.
     * @return an MerchantData object.
     * @throws SQLException
     */
    static MerchantData extractMerchant(ResultSet rs) throws SQLException {
        MerchantData merchant = new MerchantData(rs.getString("merchant"),
                                                -1,
                                                null,
                                                null,
                                                rs.getDouble("totalExpense"));
        return merchant;
    }

    /**
     * Retrieves a report from the database for the given time period.
     *
     * @param uid The user's unique identifier.
     * @param start The starting datetime to count for the report.
     * @param end The ending datetime to count for the report.
     * @return A report object
     * @throws SQLException
     */
    public static ReportData getReport(int uid, LocalDateTime start, LocalDateTime end) throws SQLException{
        ReportData report;
        Double totalExpenditure = 0.0;
        try(Connection conn = ds.getConnection()){
            String tableName = "U" + uid + "_Receipts";
            try (PreparedStatement ps = conn.prepareStatement("SELECT SUM(totalPrice) totalExpenditure FROM " + tableName + " WHERE datetime_ >= ? AND datetime_ <= ?;")){
                ps.setString(1, start.toString());
                ps.setString(2, end.toString());
                try (ResultSet rs = ps.executeQuery()){
                    if (rs.next() == true){
                        totalExpenditure = rs.getDouble("totalExpenditure");
                    }
                }
            }
            // TODO: may be should not use arraylist
            ArrayList<Double> unitExpenses = new ArrayList<>();
            String condition = "";
            if (start.getMonthValue() == end.getMonthValue()){ condition  = "GROUP BY DATE(datetime_) ORDER BY DATE(datetime_) ASC";
            }else{ condition = "GROUP BY MONTH(datetime_) ORDER BY MONTH(datetime_) ASC"; }

            try (PreparedStatement ps = conn.prepareStatement("SELECT SUM(totalPrice) unitExpense FROM " + tableName + " WHERE datetime_ >= ? AND datetime_ <= ? " + condition + ";")){
                ps.setString(1, start.toString());
                ps.setString(2, end.toString());
                try (ResultSet rs = ps.executeQuery()){
                    while(rs.next()){
                        unitExpenses.add(rs.getDouble("unitExpense"));
                    }
                }
            }

            HashMap<String, Double> categoricalExpenses = new HashMap<>();
            try (PreparedStatement ps = conn.prepareStatement("SELECT category, SUM(totalPrice) totalExpense FROM " + tableName + " WHERE datetime_ >= ? AND datetime_ <= ? GROUP BY category")){
                ps.setString(1, start.toString());
                ps.setString(2, end.toString());
                try (ResultSet rs = ps.executeQuery()){
                    while(rs.next()){
                        categoricalExpenses.put(rs.getString("category"), rs.getDouble("totalExpense"));
                    }
                }
            }
            ArrayList<ReceiptData> topReceipts = new ArrayList<>();
            try (PreparedStatement ps = conn.prepareStatement("SELECT * FROM " + tableName + " WHERE datetime_ >= ? AND datetime_ <= ? ORDER BY totalPrice DESC;")){
                try (ResultSet rs = ps.executeQuery()){
                    while(rs.next()){
                        topReceipts.add(extractReceipt(rs));
                    }
                }
            }
            report = new ReportData(totalExpenditure, unitExpenses, categoricalExpenses, topReceipts);
        }
        return report;
    }




}
