package com.espertech.esper.server.example.onlineshop;

import java.io.Serializable;

public abstract class BaseOrderEvent implements Serializable {
    private String orderId;

    protected BaseOrderEvent() {
    }

    public BaseOrderEvent(String orderId) {
        this.orderId = orderId;
    }

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }
}
