package com.espertech.esper.server.example.onlineshop;

public class StockOrderEvent extends BaseOrderEvent {
    private String userId;
    private String productName;
    private String category;
    private String subcategory;
    private double price;
    private int qty;

    public StockOrderEvent() {
    }

    public StockOrderEvent(String orderId, String userId, String productName, String category, String subcategory, double price, int qty) {
        super(orderId);
        this.userId = userId;
        this.category = category;
        this.subcategory = subcategory;
        this.price = price;
        this.productName = productName;
        this.qty = qty;
    }

    public String getCategory() {
        return category;
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

    public int getQty() {
        return qty;
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

    public void setPrice(double price) {
        this.price = price;
    }

    public void setQty(int qty) {
        this.qty = qty;
    }
}
