package com.cz2006.group3.bean;

public class UserModel {
    int errorCode;
    String errorMsg;
    UserData data;

    public UserModel(int errorCode, String errorMsg, int id, String email, String password, String username){
        this.errorCode = errorCode;
        this.errorMsg = errorMsg;
        this.data = new UserData(id, email, password, username);
    }

    @Override
    public String toString(){
        return "{\"errorCode\":" + errorCode
                + ",\"errorMsg\":\"" + errorMsg
                + "\",\"data\":" + data.toString() +"}";
    }
}


class UserData{
    int id;
    String email;
    String password;
    String username;

    public UserData(int id, String email, String password, String username){
        this.id = id;
        this.email = email;
        this.password = password;
        this.username = username;
    }
    @Override
    public String toString() {
        return "{\"id\":" + id + ",\"email\":\"" + email+ "\",\"password\":\"" + password + "\",\"username\":\"" + username +"\"}";
    }

}
