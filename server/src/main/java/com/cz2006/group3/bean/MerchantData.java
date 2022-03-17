package com.cz2006.group3.bean;

/**
 * Merchant object represents individual merchant entity.
 */
public class MerchantData {
    /**
     * The name of the merchant.
     */
    String name;
    /**
     * The postalCode of the merchant.
     */
    int postalCode;
    /**
     * The address of the merchant.
     */
    String address;
    /**
     * The category of the service that the merchant provides.
     */
    String category;
    /**
     * The total expenditure that a user spent on this merchant.
     */
    double totalExpense;

    /**
     * Merchant constructor.
     */
    public MerchantData(String name, int postalCode, String address, String category, double totalExpense){
        this.name = name;
        this.postalCode = postalCode;
        this.address = address;
        this.category = category;
        this.totalExpense = totalExpense;
    }

    /**
     * Method to convert a merchant object to a JSON String.
     *
     * @return a merchant JSON String.
     */
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