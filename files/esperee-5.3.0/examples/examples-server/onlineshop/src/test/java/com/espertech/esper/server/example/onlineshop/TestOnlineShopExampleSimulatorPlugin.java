package com.espertech.esper.server.example.onlineshop;

import com.espertech.esper.client.EPServiceProviderManager;
import com.espertech.esper.client.EPServiceProvider;
import com.espertech.esper.client.Configuration;
import com.espertech.esper.client.EPStatement;

import java.util.Properties;

import junit.framework.TestCase;

public class TestOnlineShopExampleSimulatorPlugin extends TestCase
{
    public void testPlugin() throws Exception
    {
        Configuration config = new Configuration();
        config.addPluginLoader("OnlineShopExample", OnlineShopExampleSimulatorPlugin.class.getName(), new Properties());
        EPServiceProvider engine = EPServiceProviderManager.getDefaultProvider(config);

        SupportUpdateListener listener = new SupportUpdateListener();
        EPStatement stmt = engine.getEPAdministrator().getStatement("OnlineShopExample-AllBrowseEvents");
        stmt.addListener(listener);

        Thread.sleep(5000);
        assertNotNull(listener.getLastEvent());
    }
}
