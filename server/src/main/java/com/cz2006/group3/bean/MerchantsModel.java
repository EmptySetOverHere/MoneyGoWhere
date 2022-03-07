package com.cz2006.group3.bean;


import java.util.ArrayList;

public class MerchantsModel {
    int errorCode;
    String errorMsg;
    ArrayList<MerchantData> data;

    public MerchantsModel(int errorCode, String errorMsg, MerchantData data) {
        this.errorCode = errorCode;
        this.errorMsg = errorMsg;
        this.data = new ArrayList<>();
        this.data.add(data);
    }

    public void addMerchant(MerchantData merchant){
        data.add(merchant);
    }

    @Override
    public String toString() {
        String ret = "{\"errorCode\":" + errorCode + ",\"errorMsg\":\"" + errorMsg + "\",\"data\":[";
        for (MerchantData merchant : data){
            ret += merchant.toString() + ",";
        }
        ret = ret.substring(0, ret.length()-1);
        ret += "]}";
        return ret;
    }
}

