/**
 * Eventlet Example - Minimal.
 *
 * This example simply implements all required functions and outputs to console.
 */
function EventletExampleMinimal() {
}

EventletExampleMinimal.prototype.eventletConfigure = function(configuration) {
    console.log("eventletConfigure called");
    console.log("  sources: " + JSON.stringify(configuration.sources));
    console.log("  composition: " + JSON.stringify(configuration.composition));
    console.log("  activation name: " + configuration.activationName);
    console.log("  activation xml: " + configuration.activationXML);
};

EventletExampleMinimal.prototype.eventletInitialize = function(context) {
    console.log("eventletInitialize called");
    // context.containerEventTarget is useful for listening to menu events and triggering traces
    // context.rootDOM is useful for using DOM elements
};

EventletExampleMinimal.prototype.eventletUpdate = function(update) {
    console.log("eventletUpdate called");
    console.log("  update: " + JSON.stringify(update));
};

EventletExampleMinimal.prototype.eventletManifest = function(manifest) {
    console.log("eventletManifest called");
    console.log("  manifest: " + JSON.stringify(manifest));
};

EventletExampleMinimal.prototype.eventletExpire = function(expire) {
    console.log("eventletExpire called");
    console.log("  expire: " + JSON.stringify(expire));
};
