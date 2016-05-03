package com.espertech.esper.server.example.optiontrade;

import java.io.Serializable;

public class ExchangeExecutionEvent implements Serializable {
    private int orderId;
    private int executionId;
    private String occSymbol;
    private long qty;
    private double price;
    private String exchange;
    private String status;
    private String book;

    public ExchangeExecutionEvent() {
    }

    public ExchangeExecutionEvent(int orderId, int executionId, String occ, long qty, double price, String exchange, String status, String book) {
        this.orderId = orderId;
        this.executionId = executionId;
        this.occSymbol = occ;
        this.qty = qty;
        this.price = price;
        this.exchange = exchange;
        this.status = status;
        this.book = book;
    }

    public int getOrderId() {
        return orderId;
    }

    public String getOccSymbol() {
        return occSymbol;
    }

    public long getQty() {
        return qty;
    }

    public double getPrice() {
        return price;
    }

    public String getExchange() {
        return exchange;
    }

    public String getStatus() {
        return status;
    }

    public String getBook() {
        return book;
    }

    public int getExecutionId() {
        return executionId;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public void setExecutionId(int executionId) {
        this.executionId = executionId;
    }

    public void setOccSymbol(String occSymbol) {
        this.occSymbol = occSymbol;
    }

    public void setQty(long qty) {
        this.qty = qty;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public void setExchange(String exchange) {
        this.exchange = exchange;
    }

    public void setBook(String book) {
        this.book = book;
    }
}
