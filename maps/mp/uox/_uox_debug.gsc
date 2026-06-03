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

debug(severity)
{
    debug = getCvarInt("g_debug");
    debugLevel = getCvar("g_debugLevel");
    if(!isDefined(debug) || !debug)
        return false;

    if(severityToInt(severity) < severityToInt(debugLevel))
        return false;
}

debugLog(severity, msg, varName, var)
{
    if(!debug(severity))
	return;

    // Build the entire output as one string, then write atomically.
    output = "\n|**** DEBUG ****|\n";
    output = output + severity + ": " + msg;

    if(isDefined(varName))
    {
        output = output + "\n  " + varName + " = ";
        if(isDefined(var))
            output = output + safeDump(var);
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

safeDump(var)
{
    if(!isDefined(var))
        return "undefined";

    if(isSuperArray(var))
        return dumpSuperArrayShallow(var);

    // Caller is responsible for ensuring `var` is a string or number
    // if not a super array. Anything else may throw.
    return "" + var;
}

dumpSuperArrayShallow(arr)
{
    result = "{";
    for(i = 0; i < arr["length"]; i++)
    {
        if(i > 0)
            result = result + ", ";
        result = result + "" + arr["keys"][i] + ": <val>";
    }
    result = result + "}";
    return result;
}

testRemove()
{
    arr = maps\mp\uox\_uox_arrays::superArray();
    arr = maps\mp\uox\_uox_arrays::arrayPush(arr, "valA", "keyA");
    arr = maps\mp\uox\_uox_arrays::arrayPush(arr, "valB", "keyB");
    arr = maps\mp\uox\_uox_arrays::removeArrayKey(arr, "keyA");
    arr = maps\mp\uox\_uox_arrays::arrayPush(arr, "valC", "keyA");

    // Expected: length=2, keys=[keyB, keyA], values={keyA: valC, keyB: valB}
    logPrint("length: " + arr["length"] + "\n");
    for(i = 0; i < arr["length"]; i++)
        logPrint("  [" + i + "] " + arr["keys"][i] + " = " + arr["values"][arr["keys"][i]] + "\n");
    logPrint("keys.size: " + arr["keys"].size + "\n");
}

vsay_debug(menu, response)
{
    switch(menu)
    {
	case game["menu_quickcommands"]:
	    switch(response)
	    {
	        case 1 :
		    thread testRemove();
		    self iprintlnbold("did testRemove()");
		    break;
	    }
	    break;
     }
}
