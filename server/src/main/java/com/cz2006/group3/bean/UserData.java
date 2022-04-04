package com.cz2006.group3.bean;

/**
 * User object represents individual user entity.
 */
public class UserData{
    /**
     * The unique identifier of a user.
     */
    int id;
    /**
     * The email of a user
     */
    String email;
    /**
     * The password of a user.
     */
    String password;
    /**
     * The username of a user.
     */
    String username;
    /**
     * The contact number of a user.
     */
    int phoneno;

    /**
     * User Constructor.
     * @param id the unique identifier of the user
     * @param email the email of the user
     * @param password the encrpyted password of user account
     * @param username the username of the user
     * @param phoneno the user's phone number
     */
    public UserData(int id, String email, String password, String username, int phoneno){
        this.id = id;
        this.email = email;
        this.password = password;
        this.username = username;
        this.phoneno = phoneno;
    }

    /**
     * @return the username field of a user.
     */
    public String getUsername() {return  this.username; }

    /**
     * @return the phoneno field of a user.
     */
    public int getPhoneno() {return this.phoneno;}
    /**
     * @return the password field of a user.
     */
    public String getPassword() { return this.password; }

    /**
     * @return the user identifier field of a suer.
     */
    public int getUID() { return this.id;}
    /**
     * Method to convert a user object to a JSON String.
     *
     * @return a user JSON String.
     */
    @Override
    public String toString() {
        return "{\"id\":" + id
                + ",\"email\":\"" + email
                + "\",\"password\":\"" + password
                + "\",\"username\":\"" + username
                + "\",\"phoneno\":\"" +phoneno
                + "\"}";
    }

}