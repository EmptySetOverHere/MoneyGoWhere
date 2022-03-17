package com.cz2006.group3.bean;

/**
 * A wrapper class that includes error code and error message apart from a report object.
 * This class is used for convenient communication between server and client.
 */
public class ReportModel {
    /**
     * The error code.
     */
    int errorCode;
    /**
     * The error message for display.
     */
    String errorMsg;
    /**
     * A requested monthly/yearly report.
     */
    ReportData data;

    /**
     * Report model constructor.
     */
    public ReportModel(int errorCode, String errorMsg, ReportData data){
        this.errorCode = errorCode;
        this.errorMsg = errorMsg;
        this.data = data;
    }

    /**
     * Method to convert a report model object to JSON String.
     *
     * @return a report JSON String.
     */
    @Override
    public String toString(){
        return "{\"errorCode\":" + errorCode
                + ",\"errorMsg\":\"" + errorMsg
                + "\",\"data\":" + data.toString()
                + "}";
    }

}

