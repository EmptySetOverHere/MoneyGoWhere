package com.cz2006.group3.bean;

import java.util.ArrayList;

/**
 * A wrapper class that includes error code and error message apart from a list of receipts.
 * This class is used for convenient communication between server and client.
 */
public class ReceiptsModel {
    /**
     * The error code.
     */
    int errorCode;
    /**
     * The error message for display.
     */
    String errorMsg;
    /**
     * A list of requested receipts.
     */
    ArrayList<ReceiptData> data;

    /**
     * Receipt model constructor.
     */
    public ReceiptsModel(int errorCode, String errorMsg, ArrayList<ReceiptData> receipts){
        this.errorCode = errorCode;
        this.errorMsg = errorMsg;
        this.data = receipts;
    }

    /**
     * Method to convert a receipt model object to JSON String.
     *
     * @return a receipt JSON String.
     */
    @Override
    public String toString(){
        String ret = "[";
        if (data != null){
            for (ReceiptData r : data) {
                ret += data.toString() + ",";
            }
            ret = ret.substring(0, ret.length()-1);
        }
        ret += "]";

        return "{\"errorCode\":" + errorCode
                + ",\"errorMsg\":\"" + errorMsg
                + "\",\"data\":" + ret  + "}";

    }
}

