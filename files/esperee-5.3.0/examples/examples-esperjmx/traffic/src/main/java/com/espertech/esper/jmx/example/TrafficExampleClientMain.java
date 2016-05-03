package com.espertech.esper.jmx.example;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import java.util.Properties;
import java.io.IOException;
import java.io.InputStream;

import com.espertech.esper.client.EPServiceProvider;
import com.espertech.esper.jmx.mbean.RuntimeMBean;

import javax.management.remote.JMXServiceURL;
import javax.management.remote.JMXConnector;
import javax.management.remote.JMXConnectorFactory;
import javax.management.MBeanServerConnection;
import javax.management.MBeanServerInvocationHandler;
import javax.management.ObjectName;
import javax.management.MalformedObjectNameException;

public class TrafficExampleClientMain
{
    private static final Log log = LogFactory.getLog(TrafficExampleServerMain.class);

    private EPServiceProvider epEngine;
    private TrafficGeneratorThread trafficSimulatorThread;

    /**
     * Main.
     * @param args - no arguments required
     */
    public static void main(String[] args)
    {
        TrafficExampleClientMain main = new TrafficExampleClientMain();

        try
        {
            main.run();
        }
        catch (Throwable t)
        {
            log.error("Unexpected exception running example: " + t.getMessage(), t);
        }
    }

    private void run() throws InterruptedException, IOException, MalformedObjectNameException
    {
        String filename = "trafficexample_config.properties";
        log.info("Loading properties from classpath file " + filename);
        Properties properties = new Properties();
        InputStream propertiesIS = TrafficExampleServerMain.class.getClassLoader().getResourceAsStream(filename);
        if (propertiesIS == null)
        {
            throw new RuntimeException("Properties file '" + filename + "' not found in classpath");
        }
        properties.load(propertiesIS);

        String serviceURL = (String) properties.get("service-url");
        log.info("Connecting to service URL " + serviceURL);

        JMXServiceURL jmxServiceURL = new JMXServiceURL(serviceURL);
        JMXConnector jmxc = JMXConnectorFactory.connect(jmxServiceURL, null);
        MBeanServerConnection mbsc = jmxc.getMBeanServerConnection();

        log.info("Looking up runtime MBean");
        RuntimeMBean runtimeMBean = (RuntimeMBean) MBeanServerInvocationHandler.newProxyInstance(
                mbsc, new ObjectName("com.espertech.esper-default-provider:type=Runtime"),
                RuntimeMBean.class, false);

        String query = "select stationName, count(*) from ArrivalsLast10 group by stationName order by count(*) desc";
        log.info("Executing query: " + query);

        Object[] result = runtimeMBean.fireAndForgetQueryType1(query, -1);
        Object[][] rows = (Object[][]) result[1];

        log.info("Results: ");
        String line = String.format("%15s %10s", "Station", "count");
        log.info(line);

        for (int i = 0; i < rows.length; i++)
        {
            line = String.format("%15s %10s", rows[i][0], rows[i][1]);
            log.info(line);
        }

        log.info("Disconnecting.");
        jmxc.close();
    }
}
