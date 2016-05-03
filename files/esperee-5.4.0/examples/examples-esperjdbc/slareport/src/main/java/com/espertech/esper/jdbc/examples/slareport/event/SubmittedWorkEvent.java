package com.espertech.esper.jdbc.examples.slareport.event;

import com.espertech.esper.jdbc.examples.slareport.SearchRequest;

/**
 * Represents that a new search request was submitted into a logical queue for a search service instance to pick up and process. 
 */
public class SubmittedWorkEvent
{
    private final long requestId;
    private final String serviceName;
    private final SearchRequest searchRequest;

    /**
     * Ctor.
     * @param requestId request submitted
     * @param serviceName name of service associated to request
     * @param searchRequest search criteria
     */
    public SubmittedWorkEvent(long requestId, String serviceName, SearchRequest searchRequest)
    {
        this.requestId = requestId;
        this.serviceName = serviceName;
        this.searchRequest = searchRequest;
    }

    /**
     * Returns the request id of the request submitted.
     * @return request if
     */
    public long getRequestId()
    {
        return requestId;
    }

    /**
     * Returns the name of the service to process the request.
     * @return service name
     */
    public String getServiceName()
    {
        return serviceName;
    }

    /**
     * Returns the search criteria.
     * @return search request
     */
    public SearchRequest getSearchRequest()
    {
        return searchRequest;
    }
}
