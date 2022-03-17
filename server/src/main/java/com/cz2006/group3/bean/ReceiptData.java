package com.cz2006.group3.bean;

import java.time.LocalDateTime;

/**
 * Receipt object represents individual receipt entity.
 */
public class ReceiptData{
    /**
     * The unique identifier of a receipt stored in the database.
     */
    int index;
    /**
     * The identifier sent from a merchant indicating one transaction.
     */
    String id;
    /**
     * The name of the merchant.
     */
    String merchant;
    /**
     * The timestamp of the receipt.
     */
    LocalDateTime dateTime;
    /**
     * The total price of the transaction.
     */
    double totalPrice;
    /**
     * The category of the merchant.
     */
    String category;
    /**
     * The content of the receipts.
     */
    String content;

    /**
     * Receipt Constructor.
     */
    public ReceiptData(int index, String id, String merchant, LocalDateTime dateTime,
                       double totalPrice, String category, String content) {
        this.index = index;
        this.id = id;
        this.merchant = merchant;
        this.dateTime = dateTime;
        this.totalPrice = totalPrice;
        this.category = category;
        this.content = content;
    }

    /**
     * Method to convert a receipt object to a JSON String.
     *
     * @return a receipt JSON String.
     */
    @Override
    public String toString(){
        return "{ \"index\":" + index
                + ",\"id\":" + "\""+ id + "\""
                + ",\"merchant\":" + "\"" + merchant +"\""
                + ",\"dateTime\":" + "\"" + dateTime.toString()
                + "\",\"totalPrice\":" + totalPrice
                + ",\"category\":" + "\"" + category + "\""
                + ",\"content\":" + "\"" + content + "\"}";
    }
}