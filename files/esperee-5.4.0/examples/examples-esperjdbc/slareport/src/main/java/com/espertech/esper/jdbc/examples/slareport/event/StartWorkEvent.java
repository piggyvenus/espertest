package com.espertech.esper.jdbc.examples.slareport.event;

/**
 * Event to indicate that a work item (search request) has started processing.
 */
public class StartWorkEvent
{
    private final long requestId;
    private final String serviceName;
    private final int instanceId;

    /**
     * Ctor.
     * @param requestId the name of the request
     * @param serviceName is the name of the search service
     * @param serviceInstanceId is the instance number of the service starting to process a request
     */
    public StartWorkEvent(long requestId, String serviceName, int serviceInstanceId)
    {
        this.requestId = requestId;
        this.serviceName = serviceName;
        this.instanceId = serviceInstanceId;
    }

    /**
     * Returns request to be processed.
     * @return request id
     */
    public long getRequestId()
    {
        return requestId;
    }

    /**
     * Returns the service name to process a request.
     * @return service name
     */
    public String getServiceName()
    {
        return serviceName;
    }

    /**
     * Returns the instance number of a service starting to process the request.
     * @return instance number
     */
    public int getInstanceId()
    {
        return instanceId;
    }
}
