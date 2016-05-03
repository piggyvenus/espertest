/**************************************************************************************
 * Copyright (C) 2007 EsperTech Inc. All rights reserved.                             *
 * http://www.espertech.com                                                           *
 **************************************************************************************/
package com.espertech.esper.server.example.geoapp;

import com.espertech.esper.client.EPServiceProvider;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import java.util.Map;

public class SimulatorSendRunnable implements Runnable {

    private static final Log log = LogFactory.getLog(SimulatorSendRunnable.class);

    private final EPServiceProvider engine;
    private final Map<String, Object> map;
    private final long delayMSec;

    public SimulatorSendRunnable(EPServiceProvider engine, Map<String, Object> map, long delayMSec) {
        this.engine = engine;
        this.map = map;
        this.delayMSec = delayMSec;
    }

    public void run() {
        try
        {
            if (log.isDebugEnabled())
            {
                log.debug("Sending event for id '" + map.get("id") + "' and " + map.get("lat") + ", " + map.get("lng"));
            }

            engine.getEPRuntime().sendEvent(map, "LatLng");

            try {
                Thread.sleep(delayMSec);
            }
            catch (InterruptedException e) {
            }
        }
        catch (RuntimeException ex)
        {
            if (engine.getEPAdministrator().getConfiguration().isEventTypeExists("LatLng")) {
                log.error("Unexpected error sending event :" + ex.getMessage(), ex);
            }
            else {
                return; // end simulator, type has been removed
            }
        }
    }
}
