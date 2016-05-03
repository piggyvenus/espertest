package com.espertech.esper.server.example.optiontrade;

import com.espertech.esper.client.EPServiceProviderManager;
import com.espertech.esper.client.EPServiceProvider;
import com.espertech.esper.client.Configuration;
import com.espertech.esper.client.EPStatement;

import java.util.Properties;

import junit.framework.TestCase;

public class TestOptionTradingExampleSimulatorPlugin extends TestCase
{
    public void testPlugin() throws Exception
    {
        Configuration config = new Configuration();
        config.addPluginLoader("OptionsTradingExample", OptionTradingExampleSimulatorPlugin.class.getName(), new Properties());
        EPServiceProvider engine = EPServiceProviderManager.getDefaultProvider(config);

        SupportUpdateListener listener = new SupportUpdateListener();
        EPStatement stmt = engine.getEPAdministrator().getStatement("OptionTradingExample-AvgBigAsk");
        if (stmt == null) {
            throw new RuntimeException("Statement not found, example not deployed");
        }
        stmt.addListener(listener);

        Thread.sleep(5000);
        assertNotNull(listener.getLastEvent());
    }
}
