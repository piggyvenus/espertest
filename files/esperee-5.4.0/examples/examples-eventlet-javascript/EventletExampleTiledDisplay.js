/**
 * Eventlet Example - Tiled Display.
 *
 * This example displays a grid of events, with the grid predefined in an HTML file
 * consisting of 3 rows of 3 columns (3x3).
 */
function EventletExampleTiledDisplay() {
    this.$rootDOM = null;               // the DOM element under which all cells can be found in the DOM tree
    this.maxCell = 9;                   // the maximum number of cells/tiles
    this.currentCell = 0;               // the cell to populate next
    this.typeMap = {};                  // retain a map of type information for display
    this.events = new Array(this.maxCell);   // retain events so that events can expire
}

EventletExampleTiledDisplay.prototype.eventletConfigure = function(activation) {
    // For all sources, process the manifest information
    for (i = 0; i < activation.sources.length; i++) {
        var source = activation.sources[i];
        this.processManifest(source.manifest);
    }
};

EventletExampleTiledDisplay.prototype.eventletInitialize = function(context) {
    // Keep a reference to the room DOM element so that DOM elements
    // can be found under the provided root DOM element (and therefore does not need to refer to body).
    this.$rootDOM = context.rootDOM;
};

EventletExampleTiledDisplay.prototype.eventletUpdate = function(update) {
    // One call to update the eventlet runtime may deliver multiple entry objects
    for (var i = 0; i < update.entries.length; i++) {
        var entry = update.entries[i];

        // Only process arriving events
        if (entry.newRows == null) {
            continue;
        }

        // Look up type information for this batch of events
        var typeInformation = this.typeMap[entry.typeId];

        // Process each arriving events
        for (var j = 0; j < entry.newRows.length; j++) {
            var theevent = entry.newRows[j];
            this.processEvent(theevent, typeInformation);
        }
    }
};

EventletExampleTiledDisplay.prototype.eventletManifest = function(manifestinfo) {
    // Process all the manifests provided at runtime.
    // This is useful if, for example, the subscription goes against a statement set
    // and statements come and go that belong to the statement set.
    for (var i = 0; i < manifestinfo.manifests.length; i++) {
        this.processManifest(manifestinfo.manifests[i].manifest);
    }
};

EventletExampleTiledDisplay.prototype.eventletExpire = function(expire) {
    // Loop through all events/cells
    for (var i = 0; i < this.maxCell; i++) {
        var event = this.events[i];

        // If the event slot is assigned, compare the row id (__rowid field)
        if (event != null) {
            if (event.__rowid <= expire.rowIdOffset) {

                // The event is expired, clear cell
                var $cell = this.$rootDOM.find("#cell" + i);
                $cell.empty();
            }
        }
    }
};

EventletExampleTiledDisplay.prototype.processEvent = function(theevent, typeInformation) {
    // Retain event, so that events can expire
    this.events[this.currentCell] = theevent;

    // Find DOM element of current cell
    var $cell = this.$rootDOM.find("#cell" + this.currentCell);

    // Increase cell number, assumes 6 cells
    this.currentCell++;
    if (this.currentCell >= this.maxCell) {
        this.currentCell = 0;
    }

    // Extract type information into a readable format
    var typeText = HQPushUtil.getTargetType(typeInformation.target) + ": " + HQPushUtil.getTargetName(typeInformation.target);

    // Compute a color from the __rowid
    var colorSaturation = 100 - (theevent.__rowid % 20);
    var color = "hsl(215, 100%, " + colorSaturation + "%)";

    // Built content of cell
    var $content = $('<div class="cell"></div>').css("background-color", color);
    var $spanTitle = $('<div class="title"></div>').text(typeText);   // the title is type information, i.e. "Statement xyz"
    $spanTitle.appendTo($content);

    // The content consists of all event properties except the builtin ones that are preceded by "__"
    for (var property in theevent) {
        if (property.indexOf("__") != 0) {
            var $spanProperty = $('<div></div>').text(property + ": " + theevent[property]);
            $spanProperty.appendTo($content);
        }
    }
    $cell.empty();
    $cell.append($content);
};

EventletExampleTiledDisplay.prototype.processManifest = function(manifest) {
    // Keep type information
    if (manifest != null) {
        this.typeMap[manifest.typeId] = manifest;
    }
};
