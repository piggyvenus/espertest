/**************************************************************************************
 * Copyright (C) 2007 EsperTech Inc. All rights reserved.                             *
 * http://www.espertech.com                                                           *
 **************************************************************************************/
package com.espertech.esper.server.example.onlineshop;

import com.espertech.esper.client.EPServiceProvider;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import java.util.Date;
import java.util.Random;
import java.util.concurrent.BlockingQueue;

public class SimulatorGeneratorRunnable implements Runnable {

    private static final Log log = LogFactory.getLog(SimulatorGeneratorRunnable.class);

    private static final int PER_EVENT_DELAY = 25;
    private static final int MAX_QUEUE_SIZE = 1000;
    private static Random random = new Random();

    private final EPServiceProvider engine;
    private final BlockingQueue<Runnable> eventQueue;
    private boolean shutdown;
    private int currentOrderId;

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

            if (random.nextInt() % 5 == 0)
            {
                eventQueue.add(new SimulatorSendRunnable(engine, generatePageVisitEvent(), PER_EVENT_DELAY));
            }
            else
            {
                eventQueue.add(new SimulatorSendRunnable(engine, generatePageOrderEvent(), PER_EVENT_DELAY));
            }
        }
    }

    protected UserBrowseEvent generatePageVisitEvent()
    {
        String userId = getUserId();
        String products[] = getProducts();
        String category = products[0];
        String subcategory = products[1];
        String productName = products[2];
        int stockQty = random.nextInt(100);
        double price = random.nextDouble() * 1000;
        long pageStart = new Date().getTime() - 5000;
        long pageEnd = pageStart + random.nextInt(1000);
        if (stockQty < 100)
        {
            pageEnd = pageStart + random.nextInt(600);
        }
        if (stockQty < 10)
        {
            pageEnd = pageStart + random.nextInt(60);
        }

        return new UserBrowseEvent(userId, productName, category, subcategory, stockQty, price, new Date(pageStart), new Date(pageEnd));
    }

    protected StockOrderEvent generatePageOrderEvent()
    {
        String userId = getUserId();
        String products[] = getProducts();
        String category = products[0];
        String subcategory = products[1];
        String productName = products[2];
        int qty = random.nextInt(10);
        double price = Math.round(random.nextDouble() * 100000.0) / 100.0;
        String orderId = Integer.toString(++currentOrderId);
        return new StockOrderEvent(orderId, userId, productName, category, subcategory, price, qty);
    }

    private static String getUserId()
    {
        final String[] userIds = {"tim.b.", "joe.c.", "peter.l.", "ami.o.", "srini.s.", "john.c.", "sabrina.k.", "david.l.", "hans.g." };
        return userIds[random.nextInt(userIds.length)];
    }

    private static String[] getProducts()
    {
        final String[][] products = {
            { "antiques", "far eastern", "asian vintage old dragon phoenix toothpick box" },
            { "art", "digital art", "work shirt" },
            { "art", "drawings", "Signed Vintage French Village Etching - Ferme Picarde" },
            { "art", "drawings", "Francisco Zuniga Drawing" },
            { "baby", "baby swings", "fisher price" },
            { "books", "science fiction", "player of games" },
            { "books", "historical", "revoluionary war" },
            { "books", "historical", "60 years of art history" },
            { "books", "fantasy", "dragon slayers" },
            { "books", "fantasy", "eragon" },
            { "electronics", "karaoke", "1000 karaoke songs" },
            { "electronics", "karaoke", "sing along blues" },
            { "electronics", "karaoke", "eastern karaoke" },
            };
        int index = random.nextInt(products.length);
        return products[index];
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
