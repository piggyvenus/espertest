package com.espertech.esper.jdbc.examples.slareport.event;

/**
 * Event to report queue depth for each service queue.
 */
public class QueueReportEvent
{
    private final String queueName;
    private final int depth;

    /**
     * Ctor.
     * @param queueName the name of the service queue
     * @param depth the current queue depth (number of searches in queue)
     */
    public QueueReportEvent(String queueName, int depth)
    {
        this.queueName = queueName;
        this.depth = depth;
    }

    /**
     * Returns the queue name.
     * @return queue name
     */
    public String getQueueName()
    {
        return queueName;
    }

    /**
     * Returns the number of elements in the queue.
     * @return queue depth
     */
    public int getDepth()
    {
        return depth;
    }
}
