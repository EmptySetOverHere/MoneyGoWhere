package com.cz2006.group3.bean;

import org.json.JSONObject;

public class ProductData {
    String pname;
    int quantity;
    double unitPrice;

    public ProductData(JSONObject json){
        this.pname = json.getString("name");
        this.quantity = json.getInt("quantity");
        this.unitPrice = json.getDouble("unitPrice");
    }

    public String toString(){
        return "{\"pname\":" + "\"" + pname + "\""
                + ",\"quantity\":" +quantity
                + ",\"unitPrice\":" + unitPrice +"}";
    }

}
