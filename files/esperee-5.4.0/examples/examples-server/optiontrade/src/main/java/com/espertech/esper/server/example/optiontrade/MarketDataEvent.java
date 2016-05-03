package com.espertech.esper.server.example.optiontrade;

import java.io.Serializable;

public class MarketDataEvent implements Serializable {
    private String occSymbol;
    private double bid;
    private double ask;
    private long bidSize;
    private long askSize;
    private long openInterest;

    public MarketDataEvent() {
    }

    public MarketDataEvent(String occSymbol, double bid, double ask, long bidsize, long asksize, long openInterest) {
        this.occSymbol = occSymbol;
        this.bid = bid;
        this.ask = ask;
        this.bidSize = bidsize;
        this.askSize = asksize;
        this.openInterest = openInterest;
    }

    public String getOccSymbol() {
        return occSymbol;
    }

    public double getBid() {
        return bid;
    }

    public double getAsk() {
        return ask;
    }

    public long getBidSize() {
        return bidSize;
    }

    public long getAskSize() {
        return askSize;
    }

    public long getOpenInterest() {
        return openInterest;
    }

    public void setOccSymbol(String occSymbol) {
        this.occSymbol = occSymbol;
    }

    public void setBid(double bid) {
        this.bid = bid;
    }

    public void setAsk(double ask) {
        this.ask = ask;
    }

    public void setBidSize(long bidSize) {
        this.bidSize = bidSize;
    }

    public void setAskSize(long askSize) {
        this.askSize = askSize;
    }

    public void setOpenInterest(long openInterest) {
        this.openInterest = openInterest;
    }

    public String toString()
    {
        return "occ " + occSymbol + " bid " + bid + " ask " + ask;
    }
}
