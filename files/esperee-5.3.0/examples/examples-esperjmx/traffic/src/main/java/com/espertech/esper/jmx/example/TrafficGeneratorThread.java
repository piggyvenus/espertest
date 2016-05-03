package com.espertech.esper.jmx.example;

import com.espertech.esper.client.EPRuntime;

import java.util.Random;
import java.util.Date;

public class TrafficGeneratorThread extends Thread
{
    private final Random random = new Random();
    private final EPRuntime runtime;
    private boolean isShutdown;

    public TrafficGeneratorThread(String name, EPRuntime runtime)
    {
        super(name);
        this.runtime = runtime;
    }

    public void run()
    {
        while(true)
        {
            int trainId = Math.abs(random.nextInt(10));
            String[] stationNames = "1th Street,8th Street,14th Street,34th Street,42nd Street,56th Street,7th Ave".split(",");
            int stationId = Math.abs(random.nextInt(stationNames.length));

            TrainArrivesEvent event = new TrainArrivesEvent(trainId, new Date(), stationId, stationNames[stationId]);
            runtime.sendEvent(event);

            try
            {
                Thread.sleep(100);
            }
            catch (InterruptedException e)
            {
                e.printStackTrace();
            }

            if (isShutdown)
            {
                break;
            }
        }
    }

    public void setShutdown(boolean shutdown)
    {
        isShutdown = shutdown;
    }
}
