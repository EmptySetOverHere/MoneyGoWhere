package com.cz2006.group3.bean;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/**
 * Report object represents individual monthly/yearly report entity.
 */
public class ReportData {
    /**
     * the aggregated expenditure to be displayed in a report.
     */
    double totalExpenditure;
    /**
     * the unit monthly/daily expenditure to be displayed in a report.
     */
    ArrayList<Double> unitExpenses;
    /**
     * the calculated expenditure to be displayed in a report according to category.
     */
    HashMap<String, Double> categoricalExpenses;
    /**
     * a list of top spent receipts.
     */
    ArrayList<ReceiptData> topReceipts;


    /**
     * Report constructor.
     */
    public ReportData(double totalExpenditure, ArrayList<Double> unitExpenses,
                      HashMap<String, Double> categoricalExpenses, ArrayList<ReceiptData> topReceipts){
        this.totalExpenditure = totalExpenditure;
        this.unitExpenses = unitExpenses;
        this.categoricalExpenses = categoricalExpenses;
        this.topReceipts = topReceipts;

    }


    /**
     * Method to convert a report object to a JSON String.
     *
     * @return a report JSON String.
     */
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
