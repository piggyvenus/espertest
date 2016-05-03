package com.espertech.esper.jdbc.examples.slareport;

import com.espertech.esper.client.Configuration;
import com.espertech.esper.client.EPServiceProvider;
import com.espertech.esper.client.EPServiceProviderManager;
import com.espertech.esper.jdbc.examples.slareport.event.CompletionEvent;
import com.espertech.esper.jdbc.server.remote.JDBCEndpoint;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import java.util.concurrent.*;
import java.util.Properties;
import java.io.IOException;
import java.io.InputStream;

/**
 * Simulator for the Esper JDBC example for reporting SLA.
 */
public class SLAReportExampleMain
{
    private static final Log log = LogFactory.getLog(SLAReportExampleMain.class);

    private EPServiceProvider epEngine;

    /**
     * Main.
     * @param args - no arguments required
     */
    public static void main(String[] args)
    {
        SLAReportExampleMain main = new SLAReportExampleMain();

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
        String filename = "slareportserver_config.properties";
        log.info("Loading properties from classpath file " + filename);
        Properties properties = new Properties();
        InputStream propertiesIS = SLAReportExampleMain.class.getClassLoader().getResourceAsStream(filename);
        if (propertiesIS == null)
        {
            throw new RuntimeException("Properties file '" + filename + "' not found in classpath");
        }
        properties.load(propertiesIS);
        int port = Integer.parseInt(properties.getProperty("jdbc_listen_port"));

        // set up EPL statements for reporting on
        log.info("Setting up EPL statements for reporting on");
        setupEPL();

        // start simulator to generate events
        log.info("Starting simulator");
        startSimulator();

        // start JDBC endpoint
        log.info("Starting JDBC endpoint on port " + port);
        JDBCEndpoint endpoint = new JDBCEndpoint(port);
        endpoint.start();

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

        // shut down
        endpoint.destroy();

        log.info("Shutdown completed");
    }

    private void startSimulator()
    {
        // Create 3 queues
        String[] queueNames = new String[3];
        BlockingQueue<SearchRequest>[] queues = new BlockingQueue[queueNames.length];
        for (int i = 0; i < queues.length; i++)
        {
            queueNames[i] = "queue_" + i;
            queues[i] = new LinkedBlockingQueue<SearchRequest>();
        }

        // Create a threadpool with N threads for each queue, each thread an instance of a service
        ExecutorService[] threadPools = new ExecutorService[queues.length];
        int numThreads = 2;
        for (int i = 0; i < queues.length; i++)
        {
            String serviceName = "service_" + i;
            threadPools[i] = Executors.newFixedThreadPool(numThreads, new MyThreadFactory(serviceName));

            for (int threadNum = 0; threadNum < numThreads; threadNum++)
            {
                Runnable runnable = new SearchRequestProcessorRunnable(epEngine.getEPRuntime(), queues[i], serviceName, threadNum);
                threadPools[i].execute(runnable);
            }            
        }

        // start generating requests
        ExecutorService generatorPool = Executors.newFixedThreadPool(1, new MyThreadFactory("request-generator"));
        generatorPool.execute(new SearchRequestGeneratorRunnable(epEngine.getEPRuntime(), queues));

        // start queue depth reporting through the timer task
        new QueueReportingTask(epEngine.getEPRuntime(), queueNames, queues);
    }

    private void setupEPL()
    {
        Configuration config = new Configuration();
        config.addEventTypeAutoName(CompletionEvent.class.getPackage().getName());
        config.addEventTypeAutoName(SearchRequest.class.getPackage().getName());

        epEngine = EPServiceProviderManager.getDefaultProvider(config);

        String[][] epl = new String[][] {
            {   "SubmittedPerService",
                "insert into SubmittedPerService " +
                " select serviceName, count(*) " +
                " from SubmittedWorkEvent.win:time(60 sec) " +
                " group by serviceName " +
                " output every 1 seconds"},

            {   "CompletedPerInstance",
                "insert into EndPerInstance " +
                " select serviceName, instanceId, avg(msecClockTime), count(*)" +
                " from CompletionEvent.win:time(60 sec) " +
                " group by serviceName, instanceId " +
                " output every 1 seconds"},

            {   "CompletedPerService",
                "insert into EndPerService " +
                " select serviceName, avg(msecClockTime), count(*)" +
                " from CompletionEvent.win:time(60 sec) " +
                " group by serviceName " +
                " output every 1 seconds"},

            {   "QueueDepthPerQueue",
                "insert into QueueDepthPerQueue " +
                " select queueName, avg(depth)" +
                " from QueueReportEvent.win:time(60 sec) " +
                " group by queueName " +
                " output every 1 seconds"},

            {   "SearchRequestsLast1Min",
                "create window SearchRequests.win:time(1 min) as select * from SearchRequest"},

            {   "SearchRequestsInsert",
                "insert into SearchRequests select searchRequest from SubmittedWorkEvent"}
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


    private static class MyThreadFactory implements ThreadFactory
    {
        private final String serviceName;
        private int count;

        public MyThreadFactory(String serviceName) {
            this.serviceName = serviceName;
        }

        public Thread newThread(Runnable r) {
            Thread t = new Thread(r, serviceName + " - " + count);
            count++;
            t.setDaemon(true);
            return t;
        }
    }


}
