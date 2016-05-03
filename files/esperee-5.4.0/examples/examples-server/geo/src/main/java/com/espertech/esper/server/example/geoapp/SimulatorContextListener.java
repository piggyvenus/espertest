package com.espertech.esper.server.example.geoapp;

import com.espertech.esper.client.EPServiceProvider;
import com.espertech.esper.client.EPServiceProviderManager;

import javax.servlet.ServletContextListener;
import javax.servlet.ServletContextEvent;

import com.espertech.esper.client.EPServiceStateListener;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class SimulatorContextListener implements ServletContextListener, EPServiceStateListener
{
    private static final Log log = LogFactory.getLog(SimulatorContextListener.class);

    private Simulator simulator;

    public void contextInitialized(ServletContextEvent servletContextEvent)
    {
        try {
            EPServiceProvider engine = (EPServiceProvider) servletContextEvent.getServletContext().getAttribute("com.espertech.esper.context-param.serviceprovider");
            if (engine == null) {
                String uri = servletContextEvent.getServletContext().getInitParameter("com.espertech.esper.context-param.uri");
                if (uri == null) {
                    log.error("EPServiceProvider instance or URI has not been provided as part of the context");
                    return;
                }
                engine = EPServiceProviderManager.getProvider(uri);
            }
            engine.addServiceStateListener(this);   // handle destroy of the engine instance
            log.info("Starting Geoapp example simulator");
            simulator = new Simulator(engine.getURI());
        }
        catch (Throwable t) {
            log.error("Error starting simulator context: " + t.getMessage(), t);
        }
    }

    public void contextDestroyed(ServletContextEvent servletContextEvent) {
        stop();
    }

    public void onEPServiceDestroyRequested(EPServiceProvider epServiceProvider) {
        stop();
    }

    public void onEPServiceInitialized(EPServiceProvider epServiceProvider) {
    }

    private void stop() {
        if (simulator != null) {
            log.info("Stopping Geoapp example simulator");
            try
            {
                simulator.destroy();
            }
            catch (Throwable t)
            {
                log.info(t);
            }
            simulator = null;
        }
    }
}
