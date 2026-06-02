/* *************************************************************************************************
**** _uox_debug.gsc — debug logging with structured variable dumps
****
**** Setup: set level.debug = true to enable, level.debugLevel = "info" (or similar) to filter.
**** Usage: debugLog("info", "player connected", "self.guid", self.guid);
**** Usage: debugLog("warn", "hud array unexpected size", "self.uox_hud", self.uox_hud);
**** 
**** Severity levels (low to high): "debug" < "info" < "warn" < "error" < "fatal"
**** Only messages at or above level.debugLevel are written. Use level.debug = false to disable
**** all logging regardless of severity.
**** 
**** Do not pass vectors or function pointers as the var argument; the dumper cannot detect
**** those types without triggering a runtime error. Wrap them in a stringified placeholder
**** at the call site if you need to log them.
************************************************************************************************* */

debugLog(severity, msg, varName, var)
{
    debug = getCvarInt("g_debug");
    debugLevel = getCvar("g_debugLevel");
    if(!isDefined(debug) || !debug)
        return;

    if(severityToInt(severity) < severityToInt(debugLevel))
        return;

    // Build the entire output as one string, then write atomically.
    output = "\n|**** DEBUG ****|\n";
    output = output + severity + ": " + msg;

    if(isDefined(varName))
    {
        output = output + "\n  " + varName + " = ";
        if(isDefined(var))
            output = output + superDump(var, 0);
        else
            output = output + "undefined";
    }

    output = output + "\n|** END DEBUG **|\n";
    logPrint(output);
}

severityToInt(s)
{
    if(!isDefined(s))
        return 0;   // treat undefined as lowest, so everything passes filter
    switch(s)
    {
        case "debug": return 0;
        case "info":  return 1;
        case "warn":  return 2;
        case "error": return 3;
        case "fatal": return 4;
    }
    return 0;   // unknown level = lowest
}

/* *************************************************************************************************
**** superDump(var, depth)
****
**** Returns a string representation of var. Handles: undefined, super arrays (recursively),
**** plain keyed arrays (shown as "[size=N]"), strings (quoted), and scalars (numbers, bools).
**** 
**** Cannot detect: vectors, function pointers, entities-without-.origin, dead entities.
**** Passing those will produce a runtime type error.
************************************************************************************************* */
superDump(var, depth)
{
    if(!isDefined(depth))
        depth = 0;

    if(depth > 5)
        return "<max depth>";

    if(!isDefined(var))
        return "undefined";

    // Entity check — entities have .origin in CoD1/UO
   // if(isDefined(var.origin))
   //     return "<entity>";

    // Super array — known structure
    if(maps\mp\uox\_uox_arrays::isSuperArray(var))
        return dumpSuperArray(var, depth);

    // Plain array — has .size but not super-array sentinels
    // Note: strings also have .size, so we distinguish below
    if(isDefined(var.size))
    {
        // Strings will pass this; we need to differentiate.
        // Trick: indexing a string returns the character at that index in some
        // CoD engines, but in CoD1/UO indexing a string returns undefined.
        // Attempting to differentiate reliably is fragile. The cleanest
        // approach: try to detect "is this a string" by attempting a
        // concat-with-empty-string equivalence, but GSC has no try/catch.
        //
        // Pragmatic compromise: if var.size > 0 and var[0] is defined,
        // it's an array. If var.size > 0 and var[0] is undefined, it's
        // either a string OR a string-keyed plain array (which we can't
        // iterate without keys). Both render as opaque.
        if(var.size == 0)
            return "[]";

        if(isDefined(var[0]))
            return dumpPlainArray(var, depth);

        // Could be a string or a string-keyed plain array. Try to render
        // as a string by concatenating with "" — but that errors on
        // string-keyed arrays. There's no safe disambiguator.
        // Compromise: show opaque marker. Callers wanting string content
        // can pass the string directly without going through superDump.
        return "<string or string-keyed array, size=" + var.size + ">";
    }

    // Scalar — number or bool. Safe to concat with "".
    return "" + var;
}

dumpSuperArray(arr, depth)
{
    result = "{";
    for(i = 0; i < arr["length"]; i++)
    {
        if(i > 0)
            result = result + ", ";

        key = arr["keys"][i];
        val = arr["values"][key];

        result = result + "" + key + ": " + superDump(val, depth + 1);
    }
    result = result + "}";
    return result;
}

dumpPlainArray(arr, depth)
{
    result = "[";
    for(i = 0; i < arr.size; i++)
    {
        if(i > 0)
            result = result + ", ";
        result = result + superDump(arr[i], depth + 1);
    }
    result = result + "]";
    return result;
}
