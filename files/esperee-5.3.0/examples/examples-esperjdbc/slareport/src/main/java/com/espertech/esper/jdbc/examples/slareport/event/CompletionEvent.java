package com.espertech.esper.jdbc.examples.slareport.event;

/**
 * Indicates that a search request has completed processing.
 */
public class CompletionEvent
{
    private final long requestId;
    private final String serviceName;
    private final int instanceId;

    private final StatusCode statusCode;
    private final long msecClockTime;
    private final int retryCount;

    /**
     * Ctor.
     * @param requestId id of request
     * @param serviceName the name of the service performing the search
     * @param serviceInstanceId the service instance id that has processed the search
     * @param statusCode the completion code
     * @param msecClockTime the time it took to process
     * @param retryCount the number of retries
     */
    public CompletionEvent(long requestId, String serviceName, int serviceInstanceId, StatusCode statusCode, long msecClockTime, int retryCount)
    {
        this.requestId = requestId;
        this.serviceName = serviceName;
        this.instanceId = serviceInstanceId;
        this.statusCode = statusCode;
        this.msecClockTime = msecClockTime;
        this.retryCount = retryCount;
    }

    /**
     * Returns the id of the request.
     * @return request id
     */
    public long getRequestId()
    {
        return requestId;
    }

    /**
     * The name of the service for searching.
     * @return service name
     */
    public String getServiceName()
    {
        return serviceName;
    }

    /**
     * Returns the service instance.
     * @return instance id
     */
    public int getInstanceId()
    {
        return instanceId;
    }

    /**
     * Status code of processing
     * @return status
     */
    public StatusCode getStatusCode()
    {
        return statusCode;
    }

    /**
     * Returns time to completion.
     * @return milliseconds
     */
    public long getMsecClockTime()
    {
        return msecClockTime;
    }

    /**
     * Number of retries.
     * @return retry count
     */
    public int getRetryCount()
    {
        return retryCount;
    }
}
