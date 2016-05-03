package com.espertech.esper.jmx.example;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import java.util.concurrent.*;
import java.util.Properties;
import java.io.IOException;
import java.io.InputStream;

import com.espertech.esper.client.EPServiceProvider;
import com.espertech.esper.client.EPServiceProviderManager;
import com.espertech.esper.client.Configuration;

public class TrafficExampleServerMain
{
    private static final Log log = LogFactory.getLog(TrafficExampleServerMain.class);

    private EPServiceProvider epEngine;
    private TrafficGeneratorThread trafficSimulatorThread;

    /**
     * Main.
     * @param args - no arguments required
     */
    public static void main(String[] args)
    {
        TrafficExampleServerMain main = new TrafficExampleServerMain();

        try
        {
            main.run();
        }
        catch (Throwable t)
        {
            log.error("Unexpected exception running example: " + t.getMessage(), t);
        }
    }

    private void run() throws InterruptedException, IOException
    {
        String filename = "trafficexample_config.properties";
        log.info("Loading properties from classpath file " + filename);
        Properties properties = new Properties();
        InputStream propertiesIS = TrafficExampleServerMain.class.getClassLoader().getResourceAsStream(filename);
        if (propertiesIS == null)
        {
            throw new RuntimeException("Properties file '" + filename + "' not found in classpath");
        }
        properties.load(propertiesIS);

        // set up EPL statements for reporting on
        log.info("Setting up EPL statements");
        setupEPL(properties);

        // start simulator to generate events
        log.info("Starting simulator");
        trafficSimulatorThread = new TrafficGeneratorThread("esperjmx-example", epEngine.getEPRuntime());
        trafficSimulatorThread.start();

        log.info("Startup completed");

        // register shutdown hook
        CountDownLatch shutdownLatch = new CountDownLatch(1);
        ShutdownHook shutdownHook = new ShutdownHook(shutdownLatch);
        Runtime.getRuntime().addShutdownHook(shutdownHook);

        // awaiting shutdown
        try {
            shutdownLatch.await();
        }
        catch (InterruptedException e) {
            log.error(e);
        }

        trafficSimulatorThread.setShutdown(true);
        trafficSimulatorThread.join();

        // shut down
        epEngine.destroy();

        log.info("Shutdown completed");
    }

    private void setupEPL(Properties properties)
    {
        Configuration config = new Configuration();
        config.addEventTypeAutoName(TrainArrivesEvent.class.getPackage().getName());
        config.addPluginLoader(
                "EsperJMX",
                "com.espertech.esper.jmx.client.EsperJMXPlugin",
                properties
        );

        epEngine = EPServiceProviderManager.getDefaultProvider(config);

        String[][] epl = new String[][] {
            {   "ArrivalsLast10Minutes",
                "create window ArrivalsLast10.win:time(10 min) as select * from TrainArrivesEvent" },
            {   "InsertIntoArrivals",
                "insert into ArrivalsLast10 select * from TrainArrivesEvent"},
        };

        for (int i = 0; i < epl.length; i++)
        {
            String stmtName = epl[i][0];
            String eplExpr = epl[i][1];
            epEngine.getEPAdministrator().createEPL(eplExpr, stmtName);
        }
    }

    /**
     * A thread invoked during shutdown to cleanly shut down.
     */
    private static class ShutdownHook extends Thread {

        private static final Log log = LogFactory.getLog(ShutdownHook.class);
        private CountDownLatch shutdownLatch;

        /**
         * Ctor.
         * @param shutdownLatch for communicating the shutdown event
         */
        public ShutdownHook(CountDownLatch shutdownLatch) {
            this.shutdownLatch = shutdownLatch;
        }

        public void run() {
            log.warn("Shutdown requested");
            shutdownLatch.countDown();
            try {
                Thread.sleep(3000);
            }
            catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}
