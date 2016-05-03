/**************************************************************************************
 * Copyright (C) 2007 EsperTech Inc. All rights reserved.                             *
 * http://www.espertech.com                                                           *
 **************************************************************************************/
package com.espertech.esper.server.example.optiontrade;

import com.espertech.esper.client.EPServiceProvider;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import java.util.*;
import java.util.concurrent.BlockingQueue;

public class SimulatorGeneratorRunnable implements Runnable {

    private static final Log log = LogFactory.getLog(SimulatorGeneratorRunnable.class);

    private static final int MAX_QUEUE_SIZE = 1000;
    private static final int PER_EVENT_DELAY = 50;
    private static final double BASE_SYMBOL_PRICE = 55.0;

    private final EPServiceProvider engine;
    private final BlockingQueue<Runnable> eventQueue;
    private boolean shutdown;

    private Map<Integer, List<ExchangeExecutionEvent>> uncancelledExecutionIds = new HashMap<Integer, List<ExchangeExecutionEvent>>();
    private double[] bidPrices;
    private double[] askPrices;
    private int currentExecutionId;
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
        // generate current bid and ask prices
        String[] occSymbols = occSymbolList.split(",");
        bidPrices = new double[occSymbols.length];
        askPrices = new double[occSymbols.length];
        Random random = new Random();
        for (int i = 0; i < occSymbols.length; i++)
        {
            bidPrices[i] = BASE_SYMBOL_PRICE + 0.5 + i;
            askPrices[i] = bidPrices[i] - 0.01;
        }

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

            // create a batch of market data events
            for (int i = 0; i < occSymbols.length; i++)
            {
                long bidSize = random.nextInt(1000);
                long askSize = random.nextInt(1000);
                MarketDataEvent event = new MarketDataEvent(occSymbols[i], bidPrices[i], askPrices[i], bidSize, askSize, 100);
                eventQueue.add(new SimulatorSendRunnable(engine, event, PER_EVENT_DELAY));
            }

            // Create an order with executions
            if (random.nextInt(10) != 0)
            {
                currentOrderId++;
                int occSymbolIndex = Math.abs(random.nextInt(occSymbols.length));
                String occSymbol = occSymbols[occSymbolIndex];
                int numExecutions = 1 + Math.abs(random.nextInt(5));
                double price = askPrices[occSymbolIndex];
                String book = books[random.nextInt(books.length)];

                List<ExchangeExecutionEvent> executions = new ArrayList<ExchangeExecutionEvent>();
                for (int i = 0; i < numExecutions; i++)
                {
                    currentExecutionId++;
                    String exchange = exchanges[Math.abs(random.nextInt(exchanges.length))];
                    int qty = 10 + Math.abs(random.nextInt(500));
                    ExchangeExecutionEvent event = new ExchangeExecutionEvent(currentOrderId, currentExecutionId, occSymbol, qty, price, exchange, "NEW", book);
                    eventQueue.add(new SimulatorSendRunnable(engine, event, PER_EVENT_DELAY));
                    executions.add(event);
                }
                uncancelledExecutionIds.put(currentOrderId, executions);
            }

            // Cancel a random order and/or executions
            if ((random.nextInt(10) != 0) && (!uncancelledExecutionIds.isEmpty()))
            {
                // choose an order id
                Set<Integer> orderIdSet = uncancelledExecutionIds.keySet();
                Integer[] orderIds = orderIdSet.toArray(new Integer[orderIdSet.size()]);
                int orderId = orderIds[Math.abs(random.nextInt(orderIds.length))];
                List<ExchangeExecutionEvent> executions = uncancelledExecutionIds.remove(orderId);

                if (random.nextInt(5) == 0)
                {
                    // cancel all executions
                    for (ExchangeExecutionEvent cancel : executions)
                    {
                        cancel.setStatus("CXLD");
                        eventQueue.add(new SimulatorSendRunnable(engine, cancel, PER_EVENT_DELAY));
                    }
                }
                else
                {
                    // cancel one execution and no others (since order is removed)
                    ExchangeExecutionEvent cancel = executions.remove(0);
                    cancel.setStatus("CXLD");
                    eventQueue.add(new SimulatorSendRunnable(engine, cancel, PER_EVENT_DELAY));
                }
            }
        }
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

    private static String[] exchanges = new String[] {
        "AMEX",
        "BOX",
        "CBOE",
        "ISE",
        "MW",
        "NASDA",
        "NSDQ",
        "NYSE",
        "PCX",
        "PHLX",
        "PSE",
        "XBOX"        
    };

    private static String[] books = new String[] {
        "A-FL",
        "B-FL",
        "C-FL",
        "D-FL",
        "E-FL",
        "F-FL",
        "G-FL",
        "H-FL",
        "I-FL",
        "J-FL",
        "K-FL",
        "L-FL"
    };

    private static String occSymbolList =
            "GBJUV," +
            "GBJIW," +
            "GBJUW," +
            "GBJIX," +
            "GBJIY," +
            "GBJUX," +
            "GBJUY," +
            "GBJIZ," +
            "GBJUZ," +
            "GBJIA," +
            "GBJUA," +
            "GBJUB," +
            "GBJIB," +
            "GBJIC," +
            "GBJUC," +
            "GBJID," +
            "GBJUD," +
            "GBJIE," +
            "GBJIF," +
            "GBJUE," +
            "GBJUF," +
            "GBJIG," +
            "GBJUG," +
            "GBJIH," +
            "GBJUH," +
            "GBJUI," +
            "GBJII," +
            "GBJLO," +
            "GBJXO," +
            "GBJLP," +
            "GBJXP," +
            "GBJLQ," +
            "GBJLR," +
            "GBJXQ," +
            "GBJXR," +
            "GBJLS," +
            "GBJXS," +
            "GBJLT," +
            "GBJXT," +
            "GBJXU," +
            "GBJLU," +
            "GBJLV," +
            "GBJXV," +
            "GBJLW," +
            "GBJXW," +
            "GBJLX," +
            "GBJLY," +
            "GBJXX," +
            "GBJXY," +
            "GBJLZ";
}
