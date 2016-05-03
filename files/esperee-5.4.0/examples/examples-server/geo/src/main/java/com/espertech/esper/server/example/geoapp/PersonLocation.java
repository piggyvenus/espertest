package com.espertech.esper.server.example.geoapp;

import java.io.Serializable;

public class PersonLocation implements Serializable {

    private String id;
    private double latitude;
    private double longitude;
    private double directionLat;
    private double directionLng;

    public PersonLocation() {
    }

    public PersonLocation(String id, double latitude, double longitude) {
        this.id = id;
        this.latitude = latitude;
        this.longitude = longitude;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public double getLatitude() {
        return latitude;
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    public double getLongitude() {
        return longitude;
    }

    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }

    public double getDirectionLat() {
        return directionLat;
    }

    public void setDirectionLat(double directionLat) {
        this.directionLat = directionLat;
    }

    public double getDirectionLng() {
        return directionLng;
    }

    public void setDirectionLng(double directionLng) {
        this.directionLng = directionLng;
    }
}
