package com.cz2006.group3.bean;


/**
 * A wrapper class that includes error code and error message apart from a user.
 * This class is used for convenient communication between server and client.
 */
public class UserModel {
    /**
     * The error code.
     */
    int errorCode;
    /**
     * The error message for display.
     */
    String errorMsg;
    /**
     * The User object.
     */
    UserData data;

    /**
     * User model constructor.
     */
    public UserModel(int errorCode, String errorMsg, UserData data){
        this.errorCode = errorCode;
        this.errorMsg = errorMsg;
        this.data = data;
    }
    /**
     * Method to convert a user model object to JSON String.
     *
     * @return a user JSON String.
     */
    @Override
    public String toString(){
        return "{\"errorCode\":" + errorCode
                + ",\"errorMsg\":\"" + errorMsg
                + "\",\"data\":" + data.toString() +"}";
    }


}


