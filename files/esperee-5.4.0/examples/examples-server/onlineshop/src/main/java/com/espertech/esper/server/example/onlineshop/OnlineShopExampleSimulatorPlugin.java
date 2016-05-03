package com.espertech.esper.server.example.onlineshop;

import com.espertech.esper.plugin.PluginLoader;
import com.espertech.esper.plugin.PluginLoaderInitContext;
import com.espertech.esper.core.service.EPServiceProviderSPI;

import java.util.Properties;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class OnlineShopExampleSimulatorPlugin implements PluginLoader
{
    private static final Log log = LogFactory.getLog(OnlineShopExampleSimulatorPlugin.class);

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
        log.info("Starting OnlineShop-example simulator for engine URI '" + engineURI + "'");

        simulator = new Simulator(engineURI);

        log.info("OnlineShop-example simulator started.");
    }

    public void destroy()
    {
        try
        {
            simulator.destroy();
        }
        catch (InterruptedException e)
        {
            log.warn("Simulator was interruped: " + e.getMessage(), e);
        }
        log.info("OnlineShop-example simulator stopped.");
    }
}
