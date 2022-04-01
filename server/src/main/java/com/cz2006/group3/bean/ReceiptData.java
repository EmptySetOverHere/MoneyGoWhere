package com.cz2006.group3.bean;

import java.time.LocalDateTime;
import java.util.ArrayList;

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

    String address;
    /**
     * The postal code of the merchant.
     */
    int postalCode;
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

    ArrayList<ProductData> products;

    /**
     * Receipt Constructor.
     */
    public ReceiptData(int index, String id, String merchant, String address, int postalCode, LocalDateTime dateTime,
                       double totalPrice, String category,ArrayList<ProductData> products, String content) {
        this.index = index;
        this.id = id;
        this.merchant = merchant;
        this.address = address;
        this.postalCode = postalCode;
        this.dateTime = dateTime;
        this.totalPrice = totalPrice;
        this.category = category;
        this.content = content;
        this.products = products;
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
                + ",\"address\":" + "\"" + address +"\""
                + ",\"postalCode\":" + postalCode
                + ",\"dateTime\":" + "\"" + dateTime.toString()
                + "\",\"totalPrice\":" + totalPrice
                + ",\"category\":" + "\"" + category + "\""
                + ",\"content\":" + "\""
                +",\"products\":" + products.toString()
                + "\"}";
    }
}