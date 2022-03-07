package com.cz2006.group3.bean;

import java.util.ArrayList;

public class UserModel {
    int errorCode;
    String errorMsg;
    UserData data;

    public UserModel(int errorCode, String errorMsg, UserData data){
        this.errorCode = errorCode;
        this.errorMsg = errorMsg;
        this.data = data;
    }

    @Override
    public String toString(){
        return "{\"errorCode\":" + errorCode
                + ",\"errorMsg\":\"" + errorMsg
                + "\",\"data\":" + data.toString() +"}";
    }


}


