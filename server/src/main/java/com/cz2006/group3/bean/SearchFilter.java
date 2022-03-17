package com.cz2006.group3.bean;

import org.json.JSONObject;

import java.time.LocalDateTime;
import java.util.ArrayList;

public class SearchFilter {
    String content;
    ArrayList<String> category;
    // price range
    Double price_lower;
    Double price_upper;
    // date range
    LocalDateTime start_date;
    LocalDateTime end_date;

    public SearchFilter(String content, String category,
                        Double price_lower, Double price_upper,
                        LocalDateTime start_date, LocalDateTime end_date){
        this.content = content;
        this.category = new ArrayList<>();
        this.category.add(category);
        this.price_lower = price_lower;
        this.price_upper = price_upper;
        this.start_date = start_date;
        this.end_date = end_date;
    }

    public SearchFilter(JSONObject json){
        this.category = new ArrayList<>();
        this.content = json.getString("content");
        json.get("category");
        this.category.add();
        this.price_lower = json.getDouble("price_lower");
        this.price_upper = json.getDouble("price_upper");
        this.start_date = json.getString("start_date");
        this.end_date = json.getString("end_date")
    }


}
