package com.espertech.esper.ceppushsvc.examples.traffic.client;

import com.espertech.esper.ceppushsvc.client.config.ConfigurationPushSvc;
import com.espertech.esper.ceppushsvc.client.config.Provider;
import com.espertech.esper.ceppushsvc.client.deserialize.PushServiceClient;
import com.espertech.esper.ceppushsvc.client.deserialize.PushServiceClientImpl;
import com.espertech.esper.eeutil.domain.message.EventMessageBase;
import com.espertech.esper.eeutil.domain.push.LogicalResourceRow;
import com.espertech.esper.eeutil.domain.push.LogicalResourceStatement;
import com.espertech.esper.eeutil.domain.push.SessionDetail;
import com.espertech.esper.eeutil.domain.push.SubscriptionDetail;
import com.espertech.esper.eeutil.jms.JMSRuntimeException;
import com.google.gson.Gson;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpEntityEnclosingRequestBase;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpPut;
import org.apache.http.entity.ByteArrayEntity;
import org.apache.http.entity.ContentType;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;

import javax.jms.*;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import java.util.Map;
import java.util.Properties;

public class SampleTrafficMonitorClient {

    private static Log log = LogFactory.getLog(SampleTrafficMonitorClient.class);

    public static void main(String[] args) {

        try {
            SampleTrafficMonitorClient sample = new SampleTrafficMonitorClient();
            sample.start();
        }
        catch (Exception ex) {
            log.error("Exception encountered starting sample server process: " + ex.getMessage(), ex);
        }
    }

    private void start() throws Exception {

        String restPath = "http://localhost:8400/ceppushapi/v1";

        // We are using the same configuration file to obtain the JMS provider settings
        ConfigurationPushSvc configPush = new ConfigurationPushSvc();
        configPush.configure("ceppushsvc-trafficsample.xml");
        Provider jmsProvider = configPush.getProviders().get("defaultProvider");

        PushServiceClient pushServiceClient = new PushServiceClientImpl();

        // subscribe using REST web services
        // subscription receives type information useful for deserialization
        String destination = subscribeStatementViaRESTServices(restPath, pushServiceClient);

        // Run a sample request for receiving CEP-engine published data
        subscribeJMSDestination(jmsProvider, destination, pushServiceClient);

        Thread.sleep(10000);
    }

    private String subscribeStatementViaRESTServices(String pushServicesRESTPath, PushServiceClient pushServiceClient) throws Exception {

        // obtain session
        SessionDetail sessionDetail = new SessionDetail("client-1");
        sessionDetail = httpRESTMethod(HttpMethod.POST, sessionDetail, pushServicesRESTPath + "/session", SessionDetail.class);
        log.info("Registered session, session id is " + sessionDetail.getSessionId());

        // add subscription to EPL statement
        LogicalResourceStatement statement = new LogicalResourceStatement("default", "Output", null, null);
        SubscriptionDetail subscriptionDetail = new SubscriptionDetail(sessionDetail.getSessionId(), LogicalResourceRow.fromLogicalResource("default", statement));
        subscriptionDetail = httpRESTMethod(HttpMethod.POST, subscriptionDetail, pushServicesRESTPath + "/subscription", SubscriptionDetail.class);
        log.info("Added subscription, subscription id is " + subscriptionDetail.getSubscriptionId() + " JMS destination " + subscriptionDetail.getDestination());
        pushServiceClient.add(subscriptionDetail);

        // start subscription, even though we are not listening yet
        subscriptionDetail.setState("STARTED");
        httpRESTMethod(HttpMethod.POST, subscriptionDetail, pushServicesRESTPath + "/subscription/" + subscriptionDetail.getSubscriptionId() + "/control", SubscriptionDetail.class);
        log.info("Started subscription");

        return subscriptionDetail.getDestination();
    }

    private static <T> T httpRESTMethod(HttpMethod method, Object requestObject, String path, Class<T> clazz)
            throws Exception
    {
        Gson gson = new Gson();
        String json = gson.toJson(requestObject);
        HttpEntityEnclosingRequestBase request;
        if (method == HttpMethod.POST) {
            request = new HttpPost(path);
        }
        else {
            request = new HttpPut(path);
        }
        request.setEntity(new ByteArrayEntity(json.getBytes(), ContentType.APPLICATION_JSON));
        HttpClient httpclient = new DefaultHttpClient();
        HttpResponse response = httpclient.execute(request);
        int statusCode = response.getStatusLine().getStatusCode();
        if (statusCode != 200 && statusCode != 204) {
            throw new RuntimeException("HTTP Status code " + statusCode);
        }
        if (statusCode == 204) {
            return null;
        }
        String body = EntityUtils.toString(response.getEntity());
        return gson.fromJson(body, clazz);
    }

    private static void subscribeJMSDestination(Provider jmsProviderConfig, String destination, final PushServiceClient pushServiceClient) throws Exception {

        // Establish JMS connection
        log.info("Connecting to JMS provider.");
        Connection connection = getJMSConnection(jmsProviderConfig.getObjectName(), jmsProviderConfig.getContext());
        connection.start();
        Session session = connection.createSession(false, Session.AUTO_ACKNOWLEDGE);

        // establish consumer on the destination received from the subscription response
        Destination subscriptionDestination = session.createTopic(destination);
        MessageConsumer subscriptionConsumer = session.createConsumer(subscriptionDestination);
        subscriptionConsumer.setMessageListener(new MessageListener() {
            public void onMessage(Message message) {
                try {
                    EventMessageBase[] messages = pushServiceClient.unmarshal(message);
                    log.info("Received " + messages.length + " messages");
                }
                catch (JMSException ex) {
                    log.error("Failed to receive message: " + ex.getMessage(), ex);
                }
            }
        });
    }

    private static Connection getJMSConnection(String connectionFactory, Map<String,String> initialContextProperties)
                throws NamingException, JMSRuntimeException
    {
        Properties properties = new Properties();
        properties.putAll(initialContextProperties);
        InitialContext jndiContext = new InitialContext(properties);

        if ((connectionFactory == null) || (connectionFactory.trim().length() == 0))
        {
            throw new IllegalArgumentException("Connection factory has not been provided");
        }
        ConnectionFactory factory = (ConnectionFactory)jndiContext.lookup(connectionFactory);

        Connection connection;
        try
        {
            connection = factory.createConnection();
        }
        catch (JMSException ex)
        {
            String message = "Error connecting to JMS provider";
            log.error(message, ex);
            throw new RuntimeException(message, ex);
        }

        return connection;
    }

    private static enum HttpMethod {
        POST,
        PUT
    }
}
