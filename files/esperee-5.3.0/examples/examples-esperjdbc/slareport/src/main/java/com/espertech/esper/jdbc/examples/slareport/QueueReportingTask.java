package com.espertech.esper.jdbc.examples.slareport;

import com.espertech.esper.client.EPRuntime;
import com.espertech.esper.jdbc.examples.slareport.event.QueueReportEvent;

import java.util.TimerTask;
import java.util.Timer;
import java.util.concurrent.BlockingQueue;

/**
 * A timer task that runs periodically and simply reports queue depth of each queue it is registered for.
 */
public class QueueReportingTask extends TimerTask
{
    private final EPRuntime runtime;
    private final String[] queueNames;
    private final BlockingQueue<SearchRequest>[] queues;

    /**
     * Ctor.
     * @param runtime Esper engine instance
     * @param queueNames the queue name of each queue to monitor
     * @param queues the queue instances
     */
    public QueueReportingTask(EPRuntime runtime, String[] queueNames, BlockingQueue<SearchRequest>[] queues)
    {
        this.runtime = runtime;
        this.queueNames = queueNames;
        this.queues = queues;

        Timer timer = new Timer("QueueReporting", true);
        timer.schedule(this, 1, 1);
    }

    public void run()
    {
        for (int i = 0; i < queues.length; i++)
        {
            int depth = queues[i].size();
            runtime.sendEvent(new QueueReportEvent(queueNames[i], depth));
        }
    }
}
