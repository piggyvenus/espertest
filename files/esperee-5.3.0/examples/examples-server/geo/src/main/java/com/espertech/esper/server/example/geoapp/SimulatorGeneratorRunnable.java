/**************************************************************************************
 * Copyright (C) 2007 EsperTech Inc. All rights reserved.                             *
 * http://www.espertech.com                                                           *
 **************************************************************************************/
package com.espertech.esper.server.example.geoapp;

import com.espertech.esper.client.EPServiceProvider;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.BlockingQueue;

public class SimulatorGeneratorRunnable implements Runnable {

    private static final Log log = LogFactory.getLog(SimulatorGeneratorRunnable.class);

    private static final int NUM_PEOPLE = 100;
    private static final int MAX_QUEUE_SIZE = 1000;
    private static final int PER_EVENT_DELAY = 25;
    private static final double BASE_LAT = 40.708153;
    private static final double BASE_LONG = -74.010572;
    private static final double RANGE = 0.005;

    private final EPServiceProvider engine;
    private final BlockingQueue<Runnable> eventQueue;
    private boolean shutdown;

    public SimulatorGeneratorRunnable(EPServiceProvider engine, BlockingQueue<Runnable> eventQueue) {
        this.engine = engine;
        this.eventQueue = eventQueue;
    }

    public void run()
    {
        try
        {
            generate();
        }
        catch (RuntimeException ex)
        {
            log.error("Error generating events: " + ex.getMessage(), ex);
        }
    }

    private void generate()
    {
        // create a grid
        Random random = new Random();
        double root = Math.sqrt((double)NUM_PEOPLE);
        if (root < 1)
        {
            root = 1;
        }

        // generate current locations
        PersonLocation[] locs = new PersonLocation[NUM_PEOPLE];
        int count = 0;
        for (int x = 0; x < root; x++)
        {
            for (int y = 0; y < root; y++)
            {
                double lat = BASE_LAT - (RANGE / root) * x;
                double lng = BASE_LONG - (RANGE / root) * y;
                String id = "person_" + Integer.toString(count);
                locs[count] = new PersonLocation(id, lat, lng);
                setDirection(random, locs[count]);
                count++;
            }
        }
        PersonLocation[] current = new PersonLocation[count];
        System.arraycopy(locs, 0, current, 0, count);

        // generate events
        while(true)
        {
            while(eventQueue.size() > MAX_QUEUE_SIZE)
            {
                if (shutdown)
                {
                    break;
                }

                try {
                    Thread.sleep(100);
                }
                catch (InterruptedException e) {
                    shutdown = true;
                }
            }
            if (shutdown)
            {
                eventQueue.clear();
                break;
            }

            // create a batch of events
            for (int i = 0; i < NUM_PEOPLE; i++)
            {
                PersonLocation curr = current[i];
                current[i].setLatitude(curr.getLatitude() + curr.getDirectionLat());
                current[i].setLongitude(curr.getLongitude() + curr.getDirectionLng());

                Map<String, Object> map = new HashMap<String, Object>();
                map.put("lat", ((Double) curr.getLatitude()).floatValue());
                map.put("lng", ((Double) curr.getLongitude()).floatValue());
                map.put("id", curr.getId());
                
                eventQueue.add(new SimulatorSendRunnable(engine, map, PER_EVENT_DELAY));

                if ((random.nextInt() & 1000) == 0)
                {
                    setDirection(random, curr);
                }
            }
        }
    }

    private void setDirection(Random random, PersonLocation current) {
        double dirLat = random.nextDouble() / RANGE / 1000;
        double dirLng = random.nextDouble() / RANGE / 1000;
        current.setDirectionLat(dirLat);
        current.setDirectionLng(dirLng);
    }

    public boolean isShutdown() {
        return shutdown;
    }

    public void setShutdown(boolean shutdown) {
        if (shutdown) {
            eventQueue.clear();
        }
        this.shutdown = shutdown;
    }
}
