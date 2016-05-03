package com.espertech.esper.jmx.example;

import java.util.Date;

public class TrainArrivesEvent
{
    private int trainId;
    private Date arrivalTime;
    private int stationId;
    private String stationName;

    public TrainArrivesEvent(int trainId, Date arrivalTime, int stationId, String stationName)
    {
        this.trainId = trainId;
        this.arrivalTime = arrivalTime;
        this.stationId = stationId;
        this.stationName = stationName;
    }

    public int getTrainId()
    {
        return trainId;
    }

    public Date getArrivalTime()
    {
        return arrivalTime;
    }

    public int getStationId()
    {
        return stationId;
    }

    public String getStationName()
    {
        return stationName;
    }
}
