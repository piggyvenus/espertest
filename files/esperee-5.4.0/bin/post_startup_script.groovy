/**
 *   This is a sample Groovy script that executes post-startup.
 *   For more information on Groovy, please see http://www.groovy-lang.org/
 *   Groovy syntax is the same or very close to Java syntax.
 *   The classpath in which the script executes is the server classpath.
 *   
 *   Below sample script obtains the "default" engine instance
 *   and determines whether the "MySampleDataflow" dataflow is declared.
 *   
 *   When found, the script instantiates the dataflow and saves the
 *   instance such that the dataflow instance can be seen and cancelled via the GUI.
 */

/**
 * Sample script.
 * Change or comment-in as needed.
 */
 
/**
 *
import com.espertech.esper.client.*;
import com.espertech.esper.client.dataflow.*;

System.out.println("Executing post-startup script");

EPServiceProvider epService = EPServiceProviderManager.getDefaultProvider();
EPDataFlowRuntime dataFlowRuntime = epService.getEPRuntime().getDataFlowRuntime();
String dataflowName = "MySampleDataflow";
if (dataFlowRuntime.getDataFlow(dataflowName) == null) {
    System.out.println("Dataflow '" + dataflowName + "' not found");
}
else {
    EPDataFlowInstance df = dataFlowRuntime.instantiate(dataflowName);
    // save instance makes the instance visible and manageable in the GUI
    dataFlowRuntime.saveInstance(dataflowName + " Instance", df);
    df.start();
    System.out.println("Dataflow '" + dataflowName + "' started");
}
*
*/
