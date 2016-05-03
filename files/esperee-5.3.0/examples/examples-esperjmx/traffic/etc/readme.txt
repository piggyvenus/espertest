Running the Trafficsim example:

1) Make sure JAVA_HOME is set

2) Make sure the esper jar file and its dependent libraries are copied to ../../esperjmx/lib (they are provided by the distribution)

3) Enter "compile" to compile the example.

4) Run the server via "run_trafficsim_server"

5) Run the client via "run_trafficsim_client"

6) The default port is 1099. If the port is already in use, please assign a new port via the properties file.

7) Attach to the server using a JMX console at URL  service:jmx:rmi:///jndi/rmi://localhost:1099/com.espertech.esper
