package com.espertech.example.enginejar.embeddedlib;

import com.espertech.esper.client.deploy.EngineInitializer;
import com.espertech.esper.client.deploy.SingleRowFunction;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import java.util.Arrays;
import java.util.List;

public class EngineExtensions {
    public final static Log log = LogFactory.getLog(EngineExtensions.class);

	@EngineInitializer
	public static void initEngine(String engineName) {
		log.info("Example embedded-lib initializer in embedded jar for " + engineName);
		// EPL has been deployed at this point so we can set subscribers and listeners, etc.
	}

	// these functions get registered with the engine BEFORE the above @EngineInitializer is invoked
	// because the EPL in the modules has to refer to these and the init method has to refer to
	// the EPL statements...
	@SingleRowFunction(name = "containsAny")
	public static boolean ContainsAny(Object[] lhs, Object[] rhs) {
		List<Object> lhsList = Arrays.asList(lhs);
		for (Object next : rhs) {
			if (lhsList.contains(next))
				return true;
		}
		return false;
	}
}
