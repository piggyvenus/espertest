package com.espertech.esper.server.example.geoapp;

public class GeoLib {

    public static float distanceKM(Float lat1, Float lng1, Float lat2, Float lng2) {
        if (lat1 == null || lng1 == null || lat2 == null || lng2 == null) {
            throw new NullPointerException("Invalid null parameter");
        }
        double earthRadius = 3958.75;
        double dLat = Math.toRadians(lat2-lat1);
        double dLng = Math.toRadians(lng2-lng1);
        double a = Math.sin(dLat/2) * Math.sin(dLat/2) +
                   Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2)) *
                   Math.sin(dLng/2) * Math.sin(dLng/2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
        double dist = earthRadius * c;

        int meterConversion = 1609;
        double resultMeters = dist * meterConversion;
        return new Float(resultMeters / 1000d).floatValue();
     }    
}
