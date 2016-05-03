package com.espertech.esper.jdbc.examples.slareport;

import java.util.Random;

/**
 * Represents a search request containing search criteria to search for, for the simulation.
 */
public class SearchRequest
{
    private static final Random random = new Random();
    private static final String[] userIds = new String[] {"yrew", "olan", "qtrix", "ppasr", "otrev"};
    private static final String[] searches = new String[] {"cooking", "history", "science", "music", "inventions"};

    private final long requestId;
    private final String userId;
    private final String searchCriteria;
    private final boolean isFindFirst;

    /**
     * Ctor - populates random data into search criteria.
     * @param requestId the search request id
     */
    public SearchRequest(long requestId)
    {
        this.requestId = requestId;
        userId = userIds[random.nextInt(userIds.length)];
        searchCriteria = searches[random.nextInt(searches.length)];
        isFindFirst = random.nextBoolean();
    }

    /**
     * Returns the request id.
     * @return id of request
     */
    public long getRequestId()
    {
        return requestId;
    }

    /**
     * Returns the user id.
     * @return user id of user submitting search
     */
    public String getUserId()
    {
        return userId;
    }

    /**
     * Returns the criteria searched for.
     * @return search criteria
     */
    public String getSearchCriteria()
    {
        return searchCriteria;
    }

    /**
     * Returns boolean whether the user would like to get the first hit or all hits
     * @return true for first hit only
     */
    public boolean isFindFirst()
    {
        return isFindFirst;
    }
}
