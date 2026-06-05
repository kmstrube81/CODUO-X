/* *************************************************************************************************
**** initServerLoop()
****
**** USAGE: call threaded from callback Start Gametype, add functions to level.fastLoop to check
**** every frame, level.mediumLoop to check every 5 frames, or level.slowLoop to check once a second 
****  
************************************************************************************************* */
initServerLoop()
{
	level endon("round_ended");
	
	level.fastLoop = maps\mp\uox\_uox_arrays::superArray();
	level.mediumLoop = maps\mp\uox\_uox_arrays::superArray();
	level.slowLoop = maps\mp\uox\_uox_arrays::superArray();
	level.waitTills = maps\mp\uox\_uox_arrays::superArray();
	
	//start Loop
	for(frame = 0; true; frame++)
	{
		if(frame == 20)
			frame = 0;
		if(frame == 0)
		{
			level maps\mp\uox\_uox_arrays::arrayReadEach(level.slowLoop, ::doLoop );
		}
		if(frame % 5 == 0)
		{
			level maps\mp\uox\_uox_arrays::arrayReadEach(level.mediumLoop, ::doLoop );
		}
		level maps\mp\uox\_uox_arrays::arrayReadEach(level.fastLoop, ::doLoop );
		
		level maps\mp\uox\_uox_arrays::arrayReadEach(level.waitTills, ::startLevelWait);
		wait 0.05;
	}
}

/* *************************************************************************************************
**** initPlayerLoop()
****
**** USAGE: call threaded from callback Player Connect, add functions to self.fastLoop to check
**** every frame, self.mediumLoop to check every 5 frames, or self.slowLoop to check once a second 
****  
************************************************************************************************* */
initPlayerLoop()
{
	self endon("disconnect");
	
	self.fastLoop = maps\mp\uox\_uox_arrays::superArray();
	self.mediumLoop = maps\mp\uox\_uox_arrays::superArray();
	self.slowLoop = maps\mp\uox\_uox_arrays::superArray();
	self.waitTills = maps\mp\uox\_uox_arrays::superArray();
	
	//start Loop
	for(frame = 0; true; frame++)
	{
		if(frame == 20)
			frame = 0;
		if(frame == 0)
		{
			self maps\mp\uox\_uox_arrays::arrayReadEach(self.slowLoop, ::doLoop );
		}
		if(frame % 5 == 0)
		{
			self maps\mp\uox\_uox_arrays::arrayReadEach(self.mediumLoop, ::doLoop );
		}
		self maps\mp\uox\_uox_arrays::arrayReadEach(self.fastLoop, ::doLoop );
		
		self maps\mp\uox\_uox_arrays::arrayReadEach(self.waitTills, ::startWait);
		wait 0.05;
	}
}

/* *************************************************************************************************
**** initEntityLoop()
****
**** USAGE: call threaded from whereever, add functions to self.fastLoop to check
**** every frame, self.mediumLoop to check every 5 frames, or self.slowLoop to check once a second 
****  
************************************************************************************************* */
initEntityLoop()
{
	self endon("destroyed");
	
	self.fastLoop = maps\mp\uox\_uox_arrays::superArray();
	self.mediumLoop = maps\mp\uox\_uox_arrays::superArray();
	self.slowLoop = maps\mp\uox\_uox_arrays::superArray();
	self.waitTills = maps\mp\uox\_uox_arrays::superArray();
	
	//start Loop
	for(frame = 0; true; frame++)
	{
		if(frame == 20)
			frame = 0;
		if(frame == 0)
		{
			maps\mp\uox\_uox_arrays::arrayReadEach(self.slowLoop, ::doLoop );
		}
		if(frame % 5 == 0)
		{
			maps\mp\uox\_uox_arrays::arrayReadEach(self.mediumLoop, ::doLoop );
		}
		self maps\mp\uox\_uox_arrays::arrayReadEach(self.fastLoop, ::doLoop );
		
		self maps\mp\uox\_uox_arrays::arrayReadEach(self.waitTills, ::startWait);
		wait 0.05;
		
		if(!isDefined(self))
			return;
	}
}

/* *************************************************************************************************
**** addToLoop(entity ent, string loop, function callback)
****
**** USAGE: adds a callback to the the specified loop, slow loop for once a second, medium for 4
**** times a second, and fast for every frame (20fps)
****  
************************************************************************************************* */
addToLoop(ent, loop, callback, callbackName)
{
    if(!isDefined(ent)) ent = level;

    switch(loop)
    {
        case "slow":
            ent.slowLoop = maps\mp\uox\_uox_arrays::arrayPush(ent.slowLoop, callback, callbackName); break;
        case "medium":
            ent.mediumLoop = maps\mp\uox\_uox_arrays::arrayPush(ent.mediumLoop, callback, callbackName); break;
        case "fast":
            ent.fastLoop = maps\mp\uox\_uox_arrays::arrayPush(ent.fastLoop, callback, callbackName); break;
    }
}

/* *************************************************************************************************
**** removeFromLoop(entity ent, string loop, function callback)
****
**** USAGE: removes a callback to the the specified loop, slow loop for once a second, medium for 4
**** times a second, and fast for every frame (20fps)
****  
************************************************************************************************* */
removeFromLoop(ent, loop, callbackName)
{
	if(!isDefined(ent)) ent = level;
	switch(loop)
	{
		case "slow":
			ent.slowLoop = maps\mp\uox\_uox_arrays::arraySlice(ent.slowLoop, callbackName);
			break;
		case "medium":
			ent.mediumLoop = maps\mp\uox\_uox_arrays::arraySlice(ent.mediumLoop, callbackName);
			break;
		case "fast":
			ent.fastLoop = maps\mp\uox\_uox_arrays::arraySlice(ent.fastLoop, callbackName);
			break;
	}
	
}

/* *************************************************************************************************
**** addToWaitTills(entity ent, str notify, function callback)
****
**** USAGE: adds a callback to execute once the waittill notification has fired
****  
************************************************************************************************* */
addToWaitTills(ent, msg, callback, entFlag, responseFlag)
{
    if(!isDefined(ent)) ent = level;

    if(!isDefined(entFlag))
        entFlag = false;
    
    if(!isDefined(responseFlag))
        responseFlag = false;

	waiter = [];
	waiter["msg"] = msg;
	waiter["callback"] = callback;
	waiter["waiting"] = false;
    waiter["entFlag"] = entFlag;
    waiter["responseFlag"] = responseFlag; 
	ent.waitTills = maps\mp\uox\_uox_arrays::arrayPush(ent.waitTills, waiter, msg);
	
	name = " ";
	if(isPlayer(ent))
		name = ent.name + name;
	else
		name = "";
	maps\mp\uox\_uox_debug::debugLog("info", name + "WAITTILL register: msg=" + msg + " new size=" + ent.waitTills["length"]);
}

/* *************************************************************************************************
**** removeFromWaitTills(entity ent, str msg)
****
**** USAGE: removes waittill from loop and sends a kill notification to the pending waittill
****  
************************************************************************************************* */
removeFromWaitTills(ent, msg)
{
	if(!isDefined(ent)) ent = level;
	name = " ";
	if(isPlayer(ent))
		name = ent.name + name;
	else
		name = "";
	maps\mp\uox\_uox_debug::debugLog("info", name + "WAITTILL deregister: msg=" + msg + " current size=" + ent.waitTills["length"]);
    ent.waitTills = maps\mp\uox\_uox_arrays::removeArrayKey(ent.waitTills, msg);
    ent notify("kill_" + msg);
	maps\mp\uox\_uox_debug::debugLog("info", name + 
	"WAITTILL deregister: msg=" + msg + " new size=" + ent.waitTills["length"]);
}

/* *************************************************************************************************
**** doWait(obj wait)
****
**** USAGE: waits for notification and executes callback and sets it back to waiter mode
****  
************************************************************************************************* */
doWait(waiter)
{
	if(waiter["waiting"])
		return;
	self.waitTills = self maps\mp\uox\_uox_arrays::updateProperty(self.waitTills, waiter["msg"], "waiting", true);
	
	self endon("kill_" + waiter["msg"]);
	self endon("disconnect");
	self endon("destroyed");

	self notify("kill_" + waiter["msg"]);
	name = " ";
	if(isPlayer(self))
		name = self.name + name;
	else
		name = "";
	wait 0.05; //allow notifies to kill hanging threads

    if(waiter["entFlag"] && waiter["responseFlag"])
    {
		maps\mp\uox\_uox_debug::debugLog("info", name + "waiting til: msg=" + waiter["msg"]);
        self waittill(waiter["msg"], ent, response);   
		maps\mp\uox\_uox_debug::debugLog("info", name + "saw message with entity and response: msg=" + waiter["msg"]);
        self thread [[waiter["callback"]]](ent, response);
    }
    else if (waiter["entFlag"])
    {
		maps\mp\uox\_uox_debug::debugLog("info", name + "waiting til: msg=" + waiter["msg"]);
        self waittill(waiter["msg"], ent);   
		maps\mp\uox\_uox_debug::debugLog("info", name + "saw message with entity: msg=" + waiter["msg"]);
        self thread [[waiter["callback"]]](ent);
    }
    else
    {
		maps\mp\uox\_uox_debug::debugLog("info", name + "waiting til: msg=" + waiter["msg"]);
        self waittill(waiter["msg"]);
		maps\mp\uox\_uox_debug::debugLog("info", name + "saw message: msg=" + waiter["msg"]);
        self thread [[waiter["callback"]]]();
    }
	self.waitTills	= self maps\mp\uox\_uox_arrays::updateProperty(self.waitTills, waiter["msg"], "waiting",
		false);
}

/* *************************************************************************************************
**** doLoop(callback)
****
**** USAGE: executes callback
****  
************************************************************************************************* */
doLoop(callback)
{
	thread [[callback]]();
	return callback;
}

/* *************************************************************************************************
**** startWait(waiter)
****
**** USAGE: starts waittill
****  
************************************************************************************************* */
startWait(waiter)
{
	thread doWait(waiter);
	return waiter;
}

/* *************************************************************************************************
**** startLevelWait(waiter)
****
**** USAGE: starts waittill
****  
************************************************************************************************* */
startLevelWait(waiter)
{
	thread doLevelWait(waiter);
	return waiter;
}

/* *************************************************************************************************
**** doLevelWait(obj wait)
****
**** USAGE: waits for notification and executes callback and sets it back to waiter mode
****  
************************************************************************************************* */
doLevelWait(waiter)
{
	if(waiter["waiting"])
		return;
	level.waitTills = level maps\mp\uox\_uox_arrays::updateProperty(level.waitTills, waiter["msg"], "waiting", true);
	
	level endon("kill_" + waiter["msg"]);
	level endon("disconnect");
	level endon("destroyed");

	level notify("kill_" + waiter["msg"]);
	wait 0.05; //allow notifies to kill hanging threads

    if(waiter["entFlag"] && waiter["responseFlag"])
    {
        level waittill(waiter["msg"], ent, response);   
        level thread [[waiter["callback"]]](ent, response);
    }
    else if(waiter["entFlag"])
    {
        level waittill(waiter["msg"], ent);   
        level thread [[waiter["callback"]]](ent);
    }
    else
    {
        level waittill(waiter["msg"]); 
        level thread [[waiter["callback"]]]();
    }
	level.waitTills	= level maps\mp\uox\_uox_arrays::updateProperty(level.waitTills, waiter["msg"], "waiting",
		false);
}