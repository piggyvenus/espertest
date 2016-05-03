package com.espertech.esper.server.example.onlineshop;

import java.io.Serializable;
import java.util.Date;

public class UserBrowseEvent implements Serializable {
    private String userId;
    private String productName;
    private String category;
    private String subcategory;
    private int stockQty;
    private double price;
    private Date pageEnterTime;
    private Date pageLeaveTime;

    public UserBrowseEvent() {
    }

    public UserBrowseEvent(String userId, String productName, String category, String subcategory, int stockQty, double price, Date pageEnterTime, Date pageLeaveTime) {
        this.userId = userId;
        this.category = category;
        this.subcategory = subcategory;
        this.price = price;
        this.productName = productName;
        this.stockQty = stockQty;
        this.pageEnterTime = pageEnterTime;
        this.pageLeaveTime = pageLeaveTime;
    }

    public String getCategory() {
        return category;
    }

    public Date getPageEnterTime() {
        return pageEnterTime;
    }

    public Date getPageLeaveTime() {
        return pageLeaveTime;
    }

    public String getSubcategory() {
        return subcategory;
    }

    public String getUserId() {
        return userId;
    }

    public double getPrice() {
        return price;
    }

    public String getProductName() {
        return productName;
    }

    public int getStockQty() {
        return stockQty;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public void setSubcategory(String subcategory) {
        this.subcategory = subcategory;
    }

    public void setStockQty(int stockQty) {
        this.stockQty = stockQty;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public void setPageEnterTime(Date pageEnterTime) {
        this.pageEnterTime = pageEnterTime;
    }

    public void setPageLeaveTime(Date pageLeaveTime) {
        this.pageLeaveTime = pageLeaveTime;
    }
}
