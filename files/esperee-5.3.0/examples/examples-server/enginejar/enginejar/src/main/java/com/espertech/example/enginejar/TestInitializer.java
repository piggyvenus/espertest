package com.espertech.example.enginejar;

import com.espertech.esper.client.*;
import com.espertech.esper.client.deploy.EngineInitializer;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class TestInitializer {
    public final static Log log = LogFactory.getLog(TestInitializer.class);

	@EngineInitializer
	public static void initEngine(String engineName) {
		log.info("Example test initializer for " + engineName);

        // EPL has been deployed at this point so we can set subscribers and listeners, etc.
        final EPServiceProvider engine = EPServiceProviderManager.getProvider(engineName);

        String statementName = "Example - SimpleFilter";
	    EPStatement statement = engine.getEPAdministrator().getStatement(statementName);
        if (statement == null) {
            log.warn("statement '" + statementName + "'' not found.");
            return;
        }

        statement.addListener(new UpdateListener() {
          @Override
          public void update(EventBean[] newEvents, EventBean[] oldEvents) {
            log.info("received an event, underlying=" + newEvents[0].getUnderlying());
          }
        });
	}
}
