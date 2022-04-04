package com.cz2006.group3.bean;

import org.json.JSONArray;
import org.json.JSONObject;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;

/**
 * Search filter class represents a search filter
 * that contains the filtering criteria made by user.
 */
public class SearchFilter {
    /**
     * a boolean value to indicate if all fields of the class are null value
     */
    boolean isnull;
    /**
     *  Search keyword
     */
    String content;
    /**
     *  A list of requested categories.
     */
    ArrayList<String> category;
    /**
     * price range: lower bound.
     */
    Double priceLower;
    /**
     * price range: upper bound.
     */
    Double priceUpper;
    /**
     * date range: start date.
     */
    LocalDate startDate;
    /**
     * date range: end date.
     */
    LocalDate endDate;

    /**
     * Search filter constructor from JSON String
     * @param jsonQuery a query string represents the search criteria.
     */
    public SearchFilter(JSONObject jsonQuery){
            isnull = true;
            this.content = null;
            this.category = null;
            this.priceUpper = null;
            this.priceLower = null;
            this.startDate = null;
            this.endDate = null;
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");

            if (!jsonQuery.isNull("content")) {
                this.content = jsonQuery.getString("content");
                isnull = false;
            }

            this.category = new ArrayList<>();
            if (!jsonQuery.isNull("category")) {
                JSONArray jsonArr = jsonQuery.getJSONArray("category");
                if (jsonArr.length() > 0) {
                    for (int i = 0; i < jsonArr.length(); i++) {
                        category.add(jsonArr.getString(i));
                    }
                    isnull = false;
                }
            }

            if (!jsonQuery.isNull("priceLower")) {
                this.priceLower = jsonQuery.getDouble("priceLower");
                isnull = false;
            }

            if (!jsonQuery.isNull("priceUpper")){
                this.priceUpper = jsonQuery.getDouble("priceUpper");
                isnull = false;
            }

            if (!jsonQuery.isNull("startDate")){
                this.startDate = LocalDate.parse(jsonQuery.getString("startDate"), formatter);
                isnull = false;
            }
            if (!jsonQuery.isNull("endDate")) {

                this.endDate = LocalDate.parse(jsonQuery.getString("endDate"), formatter);
                isnull = false;
            }
            // System.out.println("isnull = "+isnull);
    }

    /**
     * @return the content field of a search filter.
     */
    public String getContent() {return content;}

    /**
     * @return the category field of a search filter.
     */
    public ArrayList<String> getCategory(){return category;}
    /**
     * @return the lower price field of a search filter.
     */
    public Double getPriceLower() {return priceLower;}
    /**
     * @return the upper price field of a search filter.
     */
    public Double getPriceUpper() {return priceUpper;}
    /**
     * @return the start date field of a search filter.
     */
    public LocalDate getStartDate() {return startDate;}
    /**
     * @return the end date field of a search filter.
     */
    public LocalDate getEndDate() {return endDate;}

    /**
     * @return true if the search filter is null else false.
     */
    public boolean isNull(){return isnull;}

}
