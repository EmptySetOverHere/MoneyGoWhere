package com.cz2006.group3.bean;

import com.zaxxer.hikari.*;
import org.json.JSONArray;
import org.json.JSONObject;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;


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
    static final String jdbcUrl = "jdbc:mysql://localhost/cz2006group3?useSSL=false&characterEncoding=utf8";
    /**
     * database user account contant.
     */
    static final String jdbcUsername = "root";
    /**
     * database account password
     */
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
    }

    /**
     * Disable DBConnector constructor (for Singleton).
     */
    void DBConnector(){}

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
                    "SELECT uid FROM users WHERE email = ?;")){
                ps.setString(1, email);
                try(ResultSet rs = ps.executeQuery()){
                    if (rs.next() == true) {
                        uid = rs.getInt("uid");
                    }
                }
            }

            System.out.println(uid);
            // create receipt table for each newly create user
            String tableName = 'U' + uid + "Receipts";
            try (PreparedStatement ps = conn.prepareStatement(
                    " CREATE TABLE " + tableName + " (index BIGINT NOT NULL AUTO_CREMENT, rid VARCHAR(100), merchant VARCHAR(100)," +
                            " datetime TIMESTAMP, totalPrice DOUBLE, category VARCHAR(20), content VARCHAR(10000), PRIMARY KEY (index));")){
                ps.executeUpdate();
            }
        }
        return uid;
    }

    /**
     * Modifies the user according to the given UserData object.
     *
     * @param user the object that represents the to-be-modified user
     * @throws SQLException
     */
    public static void updateUser(UserData user) throws SQLException {
        try (Connection conn = ds.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement("UPDATE users SET WHERE uid = ?")) {
                ps.setInt(1, user.getUID());
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
        try (Connection conn = ds.getConnection()){
            //TODO:
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
            String tableName = 'U' + uid + "Receipts";
            try (PreparedStatement ps = conn.prepareStatement("SELECT TOP 20 * FROM ? ORDER BY datetime DESC;")){
                ps.setString(1, tableName);
                try (ResultSet rs = ps.executeQuery()){
                    while (rs.next()){
                        receipts.add(extractReceipt(rs));
                    }
                }
            }
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
        if (criteria.getContent()!=null){ condition += "content LIKE ? AND "; }
        if (criteria.getCategory() != null){ categories = criteria.getCategory(); for (int i = 0; i<categories.size(); i++) { condition += "categeory = ? AND "; } }
        if (criteria.getStartDate() != null){ condition += "DATE(datetime) >= ? AND "; }
        if (criteria.getEndDate() != null){ condition += "DATE(datetime) <= ? AND "; }
        if (criteria.getPriceLower() != null){ condition += "totalPrice >= ? AND "; }
        if (criteria.getPriceUpper() != null){ condition += "totalPrice <= ? AND "; }
        System.out.println(condition);
        if (condition.substring(condition.length()-5, condition.length()-1).equals("AND ")){
            condition = condition.substring(condition.length()-5);
        }
        ArrayList<ReceiptData> receipts = new ArrayList<>();
        try(Connection conn = ds.getConnection()){
            String tableName = 'U' +uid +"Receipts";
            try (PreparedStatement ps = conn.prepareStatement("SELECT * FROM " + tableName +
                    "WHERE " + condition +
                    "ORDER BY datetime DESC;")){
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
        // TODO:
        // DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String tableName = 'U' + uid + "Receipts";
        try(Connection conn = ds.getConnection()) {
            for (int i = 0; i<receipts.length(); i++){
                JSONObject r = (JSONObject) receipts.get(i);
                try (PreparedStatement ps = conn.prepareStatement("INSERT INTO " + tableName +
                        " (rid, merchant, datetime, totalPrice, category, content)" +
                        " VALUES (?, ?, ?, ?, ?, ? )")){
                    ps.setString(1, r.getString("id"));
                    ps.setString(2, r.getString("merchant"));
                    ps.setString(3, r.getString("dateTime"));
                    ps.setDouble(4, r.getDouble("totalPrice"));
                    ps.setString(5, r.getString("category"));
                    ps.setString(6, r.getString("content"));
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
            String tableName = 'U' + uid + "Receipts";
            // TODO:
            try (PreparedStatement ps = conn.prepareStatement("")){
                ps.setString(1, tableName);
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
        ReceiptData receipt = new ReceiptData(rs.getInt("index"),
                                    rs.getString("rid"),
                                    rs.getString("merchant"),
                                    rs.getTimestamp("dateTime").toLocalDateTime(),
                                    rs.getDouble("totalPrice"),
                                    rs.getString("category"),
                                    rs.getString("content"));
        return receipt;
    }

    /**
     * Retrieves top 10 merchant from database arranged according to datetime.
     *
     * @param uid the user's unique identifier.
     * @return a list of merchants.
     * @throws SQLException
     */
    public static ArrayList<MerchantData> getMerchantsDefault(int uid) throws SQLException {
        ArrayList<MerchantData> merchants = new ArrayList<>();
        try(Connection conn = ds.getConnection()){
            String tableName = 'U' + uid + "Receipts";
            try (PreparedStatement ps = conn.prepareStatement("SELECT TOP 10 * FROM ?, Merchants ORDER BY datetime DESC;")){
                ps.setString(1, tableName);
                try (ResultSet rs = ps.executeQuery()){
                    while (rs.next()){
                        merchants.add(extractMerchant(rs));
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
        MerchantData merchant = new MerchantData(rs.getString("name"),
                                                rs.getInt("postalcode"),
                                        rs.getString("address"),
                                        rs.getString("category"),
                                        rs.getDouble("totalExpense"));
        return merchant;
    }

}
