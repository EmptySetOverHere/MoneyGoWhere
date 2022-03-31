package com.cz2006.group3.bean;

public class ProductData {
    String pname;
    int quantity;
    double unitPrice;

    public ProductData(String pname, int quantity, double unitPrice){
        this.pname = pname;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
    }

    public String toString(){
        return "{\"pname\":" + pname
                + ",\"quantity\":" +quantity
                + ",\"unitPrice\"" + unitPrice +"}";
    }

}
