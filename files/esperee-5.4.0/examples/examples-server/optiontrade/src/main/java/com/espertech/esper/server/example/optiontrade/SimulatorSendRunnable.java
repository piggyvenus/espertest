/**************************************************************************************
 * Copyright (C) 2007 EsperTech Inc. All rights reserved.                             *
 * http://www.espertech.com                                                           *
 **************************************************************************************/
package com.espertech.esper.server.example.optiontrade;

import com.espertech.esper.client.EPServiceProvider;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class SimulatorSendRunnable implements Runnable {

    private static final Log log = LogFactory.getLog(SimulatorSendRunnable.class);

    private final EPServiceProvider engine;
    private final Object event;
    private final long delayMSec;

    public SimulatorSendRunnable(EPServiceProvider engine, Object event, long delayMSec) {
        this.engine = engine;
        this.event = event;
        this.delayMSec = delayMSec;
    }

    public void run() {
        try
        {
            if (log.isDebugEnabled())
            {
                log.debug("Sending event '" + event + "'");
            }

            engine.getEPRuntime().sendEvent(event);

            try {
                Thread.sleep(delayMSec);
            }
            catch (InterruptedException e) {
            }
        }
        catch (RuntimeException ex)
        {
            log.error("Unexpected error sending event:" + ex.getMessage(), ex);
        }
    }
}
