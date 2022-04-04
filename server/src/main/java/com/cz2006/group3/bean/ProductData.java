package com.cz2006.group3.bean;

import org.json.JSONObject;

/**
 * This class represents a product in one receipt
 */
public class ProductData {
    /**
     * the name of the product
     */
    String pname;
    /**
     * the quantity of product bought in a receipt
     */
    int quantity;
    /**
     * the unit price of the product
     */
    double unitPrice;

    /**
     * Constructor of the product class from json string
     * @param json object that represents a product
     */
    public ProductData(JSONObject json){
        this.pname = json.getString("pname");
        this.quantity = json.getInt("quantity");
        this.unitPrice = json.getDouble("unitPrice");
    }

    /**
     * Method to convert a product object to a JSON String.
     *
     * @return a merchant JSON String.
     */
    public String toString(){
        return "{\"pname\":" + "\"" + pname + "\""
                + ",\"quantity\":" +quantity
                + ",\"unitPrice\":" + unitPrice +"}";
    }

}
