package com.espertech.esper.server.example.geoapp;

import com.espertech.esper.client.EventBean;
import com.espertech.esper.client.UpdateListener;

public class SupportUpdateListener implements UpdateListener
{
    private EventBean lastEvent;

    public void update(EventBean[] eventBeans, EventBean[] eventBeans1) {
        lastEvent = eventBeans[0];
    }

    public EventBean getLastEvent() {
        return lastEvent;
    }
}
