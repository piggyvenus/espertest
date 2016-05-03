package com.espertech.esper.server.example.geoapp;

import com.espertech.esper.client.EPServiceProviderManager;
import com.espertech.esper.client.EPServiceProvider;
import com.espertech.esper.client.Configuration;
import com.espertech.esper.client.EPStatement;

import java.util.Properties;

import junit.framework.TestCase;

public class TestGeoExampleSimulatorPlugin extends TestCase
{
    public void testPlugin() throws Exception
    {
        Configuration config = new Configuration();
        config.addPluginLoader("GeoExample", GeoExampleSimulatorPlugin.class.getName(), new Properties());
        EPServiceProvider engine = EPServiceProviderManager.getDefaultProvider(config);

        SupportUpdateListener listener = new SupportUpdateListener();
        EPStatement stmt = engine.getEPAdministrator().getStatement("GeoExample-LastPositionRelation");
        if (stmt == null) {
            throw new RuntimeException("Could not find Geoapp statements");
        }
        stmt.addListener(listener);
        
        Thread.sleep(5000);
        assertNotNull(listener.getLastEvent());
    }
}
