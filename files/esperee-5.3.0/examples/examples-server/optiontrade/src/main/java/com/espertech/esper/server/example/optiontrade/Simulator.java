/**************************************************************************************
 * Copyright (C) 2007 EsperTech Inc. All rights reserved.                             *
 * http://www.espertech.com                                                           *
 **************************************************************************************/
package com.espertech.esper.server.example.optiontrade;

import com.espertech.esper.client.EPServiceProvider;
import com.espertech.esper.client.EPServiceProviderManager;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import java.util.concurrent.*;

public class Simulator {

    private static final Log log = LogFactory.getLog(Simulator.class);

    private final static int NUM_SEND_THREADS = 1;

    private final EPServiceProvider engine;
    private BlockingQueue<Runnable> eventQueue;
    private ThreadPoolExecutor threadpool;
    private Thread generatorThread;
    private SimulatorGeneratorRunnable generatorRunnable;

    public Simulator(String engineURI)
    {
        // Initialize simulator
        engine = EPServiceProviderManager.getProvider(engineURI);

        // ensure that the EPL statements are deployed; find the EPL file in the resources folder
        if (!engine.getEPAdministrator().getDeploymentAdmin().isDeployed("com.espertech.esper.server.example.optiontrade")) {
            String eplFile = "optiontrade.epl";
            try {
                engine.getEPAdministrator().getDeploymentAdmin().readDeploy(eplFile, eplFile, null, null);
            }
            catch(Exception ex) {
                log.error("Unexpected exception deploying '" + eplFile + "': " + ex.getMessage(), ex);
                return;
            }
        }

        // generation runs in a separate thread and is dependent on queue size
        eventQueue = new LinkedBlockingQueue<Runnable>();
        ThreadFactory threadFactory = new SimulatorThreadFactory(engineURI, "OptionTradeExample");
        generatorRunnable = new SimulatorGeneratorRunnable(engine, eventQueue);
        generatorThread = threadFactory.newThread(generatorRunnable);
        generatorThread.start();

        if (log.isDebugEnabled())
        {
            log.debug("Starting simulator thread pol, " + NUM_SEND_THREADS + " threads in pool");
        }
        threadpool = new ThreadPoolExecutor(NUM_SEND_THREADS, NUM_SEND_THREADS, 60000, TimeUnit.SECONDS, eventQueue, threadFactory);
        threadpool.prestartAllCoreThreads();
    }

    public synchronized void destroy() throws InterruptedException
    {
        if (threadpool == null) {
            return;
        }

        log.debug("Shutting down threadpool");
        threadpool.shutdown();

        try
        {
            threadpool.awaitTermination(2, TimeUnit.SECONDS);
            threadpool.shutdownNow();
        }
        catch (InterruptedException e)
        {
            log.info(e);
        }
        threadpool = null;

        if (log.isDebugEnabled())
        {
            log.debug("Shutting down simulator thread pool");
        }

        generatorRunnable.setShutdown(true);
        if (generatorThread != null) {
            generatorThread.join();
        }
        generatorThread = null;
        eventQueue = null;
    }
}
