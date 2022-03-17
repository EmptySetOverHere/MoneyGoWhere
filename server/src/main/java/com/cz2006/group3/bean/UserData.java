package com.cz2006.group3.bean;

public class UserData{
    int id;
    String email;
    String password;
    String username;
    int phoneno;


    public UserData(int id, String email, String password, String username, int phoneno){
        this.id = id;
        this.email = email;
        this.password = password;
        this.username = username;
        this.phoneno = phoneno;
    }

    public String getPassword(){
        return this.password;
    }

    public String getEmail(){
        return this.email;
    }
    public String getUsername(){
        return this.username;
    }

    public int getPhoneno() { return this.phoneno;}
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