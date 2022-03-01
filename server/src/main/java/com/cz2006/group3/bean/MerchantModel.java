package com.cz2006.group3.bean;


public class MerchantModel {
    int errorCode;
    String errorMsg;
    MerchantData data;

    public MerchantModel(int errorCode, String errorMsg) {
        this.errorCode = errorCode;
        this.errorMsg = errorMsg;
        // this.data = MerchantData();
    }

    @Override
    public String toString() {
        return "{\"errorCode\":" + errorCode
                + ",\"errorMsg\":\"" + errorMsg
                + "\",\"data\":" + data.toString() +"}";
    }
}

class MerchantData {
    String name;
    int postalCode;
    double totalExpense;



}
