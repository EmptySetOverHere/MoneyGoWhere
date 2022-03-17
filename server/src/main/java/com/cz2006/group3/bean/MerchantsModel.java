package com.cz2006.group3.bean;

import java.util.ArrayList;

/**
 * A wrapper class that includes error code and error message apart from a list of merchant.
 * This class is used for convenient communication between server and client.
 */
public class MerchantsModel {
    /**
     * The error code.
     */
    int errorCode;
    /**
     * The error message for display.
     */
    String errorMsg;
    /**
     * A list of requested merchants.
     */
    ArrayList<MerchantData> data;

    /**
     * Merchant model constructor.
     */
    public MerchantsModel(int errorCode, String errorMsg, ArrayList<MerchantData> merchants) {
        this.errorCode = errorCode;
        this.errorMsg = errorMsg;
        this.data = merchants;
    }

    /**
     * Method to convert a merchant model object to JSON String.
     *
     * @return a merchant JSON String.
     */
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

