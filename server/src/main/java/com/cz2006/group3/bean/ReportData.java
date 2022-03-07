package com.cz2006.group3.bean;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class ReportData {
    double totalExpenditure;
    ArrayList<Double> unitExpenses;
    HashMap<String, Double> categoricalExpenses;
    ArrayList<ReceiptData> topReceipts;

    public ReportData(double totalExpenditure, ArrayList<Double> unitExpenses,
                      HashMap<String, Double> categoricalExpenses, ArrayList<ReceiptData> topReceipts){
        this.totalExpenditure = totalExpenditure;
        this.unitExpenses = unitExpenses;
        this.categoricalExpenses = categoricalExpenses;
        this.topReceipts = topReceipts;
    }

    @Override
    public String toString(){
        String ret = "{\"totalExpenditure\":" + totalExpenditure
                + ",\"unitExpenses\":[" ;
        for (double unitExpense : unitExpenses){
            ret+= unitExpense + ",";
        }
        ret = ret.substring(0, ret.length()-1) + "]";
        ret += ",\"categoricalExpenses\": {";
        for (Map.Entry<String, Double> entry: categoricalExpenses.entrySet()){
            String categoryName = entry.getKey();
            Double expense = entry.getValue();
            ret += "\"" + categoryName + "\":" + expense + ",";
        }
        ret = ret.substring(0, ret.length()-1)+"}";

        ret += ",\"topReceipts\":[";
        for (ReceiptData r : topReceipts){
            ret += r.toString() + ",";
        }

        ret = ret.substring(0, ret.length()-1)+ "]";
        ret+= "}";
        return ret;
    }

}
