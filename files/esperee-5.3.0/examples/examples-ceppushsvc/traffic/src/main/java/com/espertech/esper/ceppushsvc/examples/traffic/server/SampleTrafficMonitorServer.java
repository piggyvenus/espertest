package com.espertech.esper.ceppushsvc.examples.traffic.server;

import com.espertech.esper.ceppushsvc.endpoint.CepPushJaxRsApplication;
import com.espertech.esper.client.Configuration;
import com.espertech.esper.client.EPServiceProvider;
import com.espertech.esper.client.EPServiceProviderManager;
import com.espertech.esper.eeutil.rest.RestRoots;
import com.espertech.esper.eeutil.token.TokenValidationServiceProvider;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.restlet.Component;
import org.restlet.Server;
import org.restlet.data.Protocol;
import org.restlet.ext.jaxrs.JaxRsApplication;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

public class SampleTrafficMonitorServer {

    private static Log log = LogFactory.getLog(SampleTrafficMonitorServer.class);

    public static void main(String[] args) {

        try {
            SampleTrafficMonitorServer sample = new SampleTrafficMonitorServer();
            sample.start();
        }
        catch (Exception ex) {
            log.error("Exception encountered starting sample server process: " + ex.getMessage(), ex);
        }
    }

    private void start() throws Exception {
        log.info("Starting example traffic monitor server.");

        Configuration config = new Configuration();
        config.configure("esper-trafficsample.xml");
        final EPServiceProvider engine = EPServiceProviderManager.getDefaultProvider(config);

        // sample module
        String module =
                "create schema StreetCarCountSchema (streetid string, carcount int);" +
                        "" +
                "create schema StreetChangeEvent (streetid string, action string);" +
                        "" +
                "create window StreetCarCountWindow.std:unique(streetid) as StreetCarCountSchema;" +
                        "" +
                "on StreetChangeEvent ce merge StreetCarCountWindow w where ce.streetid = w.streetid\n" +
                "    when not matched and ce.action = 'ENTER' then insert select streetid, 1 as carcount\n" +
                "    when matched and ce.action = 'ENTER' then update set carcount = carcount + 1\n" +
                "    when matched and ce.action = 'LEAVE' then update set carcount = carcount - 1;" +
                        "" +
                "@Name('Output') select * from StreetCarCountWindow;" +
                "" +
                "@Name('HeartBeat') select 'Heartbeat' as heartbeat, current_timestamp() as now from pattern[every timer:interval(1 sec)]";

        // deploy module
        engine.getEPAdministrator().getDeploymentAdmin().parseDeploy(module, null, null, null);

        // expose REST-style web service for push services management
        log.info("Exposing REST web service...");
        initializeRestletService("localhost", 8400);

        // use a latch for shut down
        final CountDownLatch shutdownLatch = new CountDownLatch(1);
        Runtime.getRuntime().addShutdownHook(new Thread() {
            public void run() {
                shutdownLatch.countDown();
                engine.destroy();
            }
        });

        log.info("Sending sample car event every 1 second...");

        // send an event every 1 second
        while(shutdownLatch.getCount() > 0) {
            Map<String, Object> event = new HashMap<String, Object>();
            String streetid = Integer.toString((int) Math.random() * 100);
            String action = Math.random() > 0.5 ? "LEAVE" : "ENTER";
            event.put("streetid", streetid);
            event.put("action", action);
            engine.getEPRuntime().sendEvent(event, "StreetChangeEvent");

            shutdownLatch.await(1, TimeUnit.SECONDS);
        }

        log.info("Ending sample server.");
    }

    private void initializeRestletService(String host, int port) throws Exception {

        // restlet endpoint
        Component comp = new Component();
        Server server = new Server(Protocol.HTTP, host, port);   // always bind to localhost for the tests
        comp.getServers().add(server);

        // create JAX-RS runtime environment
        JaxRsApplication application = new CepPushJaxRsApplication(comp.getContext().createChildContext());
        application.getJaxRsRestlet().addSingleton(new TokenValidationServiceProvider(null));

        // Attach the application to the component and start it
        String attachPath = RestRoots.PUSH_V1.toAttachString();
        comp.getDefaultHost().attach(attachPath, application);
        comp.start();

        String root = "http://" + host + ":" + port + attachPath;
        log.info("REST Service URI is at root " + root + ", test via '" + root + "/pushinfo'");
    }
}
