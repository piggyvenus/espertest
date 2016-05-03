package com.espertech.esper.server.example.optiontrade;

import com.espertech.esper.plugin.PluginLoader;
import com.espertech.esper.plugin.PluginLoaderInitContext;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class OptionTradingExampleSimulatorPlugin implements PluginLoader
{
    private static final Log log = LogFactory.getLog(OptionTradingExampleSimulatorPlugin.class);

    private static final String ENGINE_URI = "engineURI";

    private String engineURI;
    private Simulator simulator;

    public void init(PluginLoaderInitContext context)
    {
        if (context.getProperties().getProperty(ENGINE_URI) != null)
        {
            engineURI = context.getProperties().getProperty(ENGINE_URI);
        }
        else
        {
            engineURI = context.getEpServiceProvider().getURI();
        }
    }

    public void postInitialize()
    {
        log.info("Starting Options-Trading-example simulator for engine URI '" + engineURI + "'");

        simulator = new Simulator(engineURI);

        log.info("Options-Trading-example simulator started.");
    }

    public void destroy()
    {
        try
        {
            simulator.destroy();
        }
        catch (InterruptedException e) {
            log.warn("Simulator was interruped: " + e.getMessage(), e);
        }
        catch (RuntimeException ex) {
            log.info("Exception destroying simulator: " + ex.getMessage(), ex);
        }
        log.info("Options-Trading-example simulator stopped.");
    }
}
