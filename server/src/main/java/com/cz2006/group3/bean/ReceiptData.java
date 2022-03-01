package com.cz2006.group3.bean;

import java.time.LocalDateTime;

public class ReceiptData{
    String id;
    String merchant;
    LocalDateTime dateTime;
    double totalPrice;
    String category;
    String content;

    public ReceiptData(String id, String merchant, LocalDateTime dateTime,
                       double totalPrice, String category, String content) {
        this.id = id;
        this.merchant = merchant;
        this.dateTime = dateTime;
        this.totalPrice = totalPrice;
        this.category = category;
        this.content = content;
    }

    @Override
    public String toString(){
        return "{\"errorCode\":" + id
                + ",\"errorMsg\":\"" + merchant
                + "\",\"dateTime\":" + dateTime.toString()
                + "\",\"totalPrice\":" + totalPrice
                + "\",\"category\":" + category
                + "\",\"content\":" + content + "}";
    }
}