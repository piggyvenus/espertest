package com.espertech.esper.server.example.onlineshop;

import java.util.Date;

public class MyUtilLib
{
    public static long deltaMSec(Date startDate, Date endDate)
    {
        long start = startDate.getTime();
        long end = endDate.getTime();
        return end - start;
    }
}
