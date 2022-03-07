package com.cz2006.group3.bean;

public class MerchantData {
    String name;
    int postalCode;
    String address;
    String category;
    double totalExpense;

    public MerchantData(String name, int postalCode, String address, String category, double totalExpense){
        this.name = name;
        this.postalCode = postalCode;
        this.address = address;
        this.category = category;
        this.totalExpense = totalExpense;
    }

    @Override
    public String toString(){
        return "{\"name\":"+ "\":" + name + "\""
                + ",\"postalCode\":" + postalCode
                + ",\"address\":" + "\"" + address + "\""
                + ",\"category\":" + "\"" + category + "\""
                + ",\"totalExpense\":" + totalExpense
                + "}";
    }
}