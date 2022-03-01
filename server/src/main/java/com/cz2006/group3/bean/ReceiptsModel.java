package com.cz2006.group3.bean;

import java.time.LocalDateTime;
import java.util.ArrayList;


public class ReceiptsModel {
    int errorCode;
    String errorMsg;
    ArrayList<ReceiptData> data;

    public ReceiptsModel(int errorCode, String errorMsg){
        this.errorCode = errorCode;
        this.errorMsg = errorMsg;
        this.data = new ArrayList<ReceiptData>();
    }

    public void addReceipt(String id, String merchant,
                            LocalDateTime dateTime,
                           double totalPrice, String category,
                           String content){
        data.add(new ReceiptData(id, merchant, dateTime, totalPrice, category, content));
    }

    // TODO: need to think twice
    public void removeReceipt(ReceiptData receipt){
        data.remove(receipt);
    }

    @Override
    public String toString(){
        return "{\"errorCode\":" + errorCode
                + ",\"errorMsg\":\"" + errorMsg
                + "\",\"data\":" + data.toString() + "}";
    }
}

