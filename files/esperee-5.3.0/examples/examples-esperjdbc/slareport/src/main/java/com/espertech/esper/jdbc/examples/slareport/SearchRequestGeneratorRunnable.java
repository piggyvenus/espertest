package com.espertech.esper.jdbc.examples.slareport;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import com.espertech.esper.client.EPRuntime;
import com.espertech.esper.jdbc.examples.slareport.event.SubmittedWorkEvent;

import java.util.concurrent.BlockingQueue;
import java.util.Random;

/**
 * Runnable responsible for generating search requests for the simulation. 
 */
public class SearchRequestGeneratorRunnable implements Runnable
{
    private static final Log log = LogFactory.getLog(SearchRequestGeneratorRunnable.class);

    private final EPRuntime runtime;
    private final BlockingQueue<SearchRequest>[] queues;
    private long requestId;
    private Random random;

    /**
     * Ctor.
     * @param runtime Esper engine instance
     * @param queues the queues to populate requests into
     */
    public SearchRequestGeneratorRunnable(EPRuntime runtime, BlockingQueue<SearchRequest>[] queues)
    {
        this.runtime = runtime;
        this.queues = queues;
        random = new Random();
    }

    public void run()
    {
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
    }

    private void doRun() throws InterruptedException
    {
        // submit work at at rate of N per second
        for (int i = 0; i < 10; i++)
        {
            requestId++;

            // Find a random queue
            int queueNum = random.nextInt(queues.length);
            String service = "service_" + queueNum;

            // throttle if queue full
            if (queues[queueNum].size() > 100)
            {
                if (log.isDebugEnabled())
                {
                    log.debug(".doRun Throttling, queue full for " + service);
                }
                Thread.sleep(1000);
            }

            SearchRequest searchRequest = new SearchRequest(requestId);

            // send event
            runtime.sendEvent(new SubmittedWorkEvent(requestId, service, searchRequest));

            // submit to queue
            if (log.isDebugEnabled())
            {
                log.debug(".doRun Submitted work unit for service " + service);
            }

            // add work unit
            queues[queueNum].put(searchRequest);
        }

        Thread.sleep(1000);
    }
}
