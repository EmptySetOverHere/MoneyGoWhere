package com.cz2006.group3.bean;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class ReportModel {
    int errorCode;
    String errorMsg;
    ReportData data;

    public ReportModel(int errorCode, String errorMsg, ReportData data){
        this.errorCode = errorCode;
        this.errorMsg = errorMsg;
        this.data = data;
    }

    @Override
    public String toString(){
        return "{\"errorCode\":" + errorCode
                + ",\"errorMsg\":\"" + errorMsg
                + "\",\"data\":" + data.toString()
                + "}";
    }

}

