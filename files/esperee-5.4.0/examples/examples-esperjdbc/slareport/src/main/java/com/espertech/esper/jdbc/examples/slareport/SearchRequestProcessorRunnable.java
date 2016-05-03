package com.espertech.esper.jdbc.examples.slareport;

import com.espertech.esper.client.EPRuntime;
import com.espertech.esper.jdbc.examples.slareport.event.StartWorkEvent;
import com.espertech.esper.jdbc.examples.slareport.event.CompletionEvent;
import com.espertech.esper.jdbc.examples.slareport.event.StatusCode;

import java.util.concurrent.BlockingQueue;
import java.util.Random;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * Runnable for active as a search processor, taking a search request from the queue and blocking if the queue is empty,
 * processing the search request and reporting a status back.
 */
public class SearchRequestProcessorRunnable implements Runnable
{
    private static final Log log = LogFactory.getLog(SearchRequestProcessorRunnable.class);

    private final EPRuntime runtime;
    private final BlockingQueue<SearchRequest> queue;
    private final String serviceName;
    private final int instanceId;
    private final Random random;

    /**
     * Ctor.
     * @param runtime Esper engine instance
     * @param queue the queue to take search requests from
     * @param serviceName the name of the service
     * @param instanceId the instance id
     */
    public SearchRequestProcessorRunnable(EPRuntime runtime, BlockingQueue<SearchRequest> queue, String serviceName, int instanceId)
    {
        this.runtime = runtime;
        this.queue = queue;
        this.serviceName = serviceName;
        this.instanceId = instanceId;
        this.random = new Random();
    }

    public void run()
    {
        log.debug("Started service " + serviceName + " instance " + instanceId);
        while(true)
        {
            try
            {
                doRun();
            }
            catch (InterruptedException t)
            {
                break;
            }
            catch (Throwable t)
            {
                log.error("Unexpected error in thread", t);
            }
        }
        log.info("Ended service " + serviceName + " instance " + instanceId);
    }

    private void doRun() throws InterruptedException
    {
        SearchRequest workUnit = queue.take();
        runtime.sendEvent(new StartWorkEvent(workUnit.getRequestId(), serviceName, instanceId));

        long startTime = System.currentTimeMillis();

        // sleep 100 msec on avg
        double sleepTime = 100 * random.nextDouble();
        Thread.sleep((long) sleepTime);

        long endTime = System.currentTimeMillis();
        long deltaTime = endTime - startTime;

        if (log.isDebugEnabled())
        {
            log.debug(".doRun Processed work unit for service " + serviceName + " instance " + instanceId);
        }
        runtime.sendEvent(new CompletionEvent(workUnit.getRequestId(), serviceName, instanceId, StatusCode.SUCCESS, deltaTime, 0));
    }
}
