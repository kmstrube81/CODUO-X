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
	
	level.fastLoop = [];
	level.mediumLoop = [];
	level.slowLoop = [];
	
	//start Loop
	for(frame = 0; true; frame++)
	{
		if(frame == 20)
			frame = 0;
		if(frame == 0)
		{
			for(i = 0; i < level.slowLoop.size; i++)
			{
				level thread [[level.slowLoop[i]]]();
			}
		}
		if(frame % 5 == 0)
		{
			for(i = 0; i < level.mediumLoop.size; i++)
			{
				level thread [[level.mediumLoop[i]]]();
			}
		}
		for(i = 0; i < level.fastLoop.size; i++)
		{
			level thread [[level.fastLoop[i]]]();
		}
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
			maps\mp\uox\_uox_arrays::arrayForEach(self.slowLoop, ::doLoop );
		}
		if(frame % 5 == 0)
		{
			maps\mp\uox\_uox_arrays::arrayForEach(self.mediumLoop, ::doLoop );
		}
		maps\mp\uox\_uox_arrays::arrayForEach(self.fastLoop, ::doLoop );
		
		maps\mp\uox\_uox_arrays::arrayForEach(self.waitTills, ::startWait);
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
	self.waitTills = [];
	
	//start Loop
	for(frame = 0; true; frame++)
	{
		if(frame == 20)
			frame = 0;
		if(frame == 0)
		{
			maps\mp\uox\_uox_arrays::arrayForEach(self.slowLoop, ::doLoop );
		}
		if(frame % 5 == 0)
		{
			maps\mp\uox\_uox_arrays::arrayForEach(self.mediumLoop, ::doLoop );
		}
		maps\mp\uox\_uox_arrays::arrayForEach(self.fastLoop, ::doLoop );
		for(i = 0; i < self.waitTills.size; i++)
		{
			waiter = self.waitTills[i];
			if(!waiter["waiting"])
				self thread doWait(i);
		}
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
	if(ent == level)
	{
		switch(loop)
		{
			case "slow":
					level.slowLoop = maps\mp\uox\_uox_arrays::arrayPush(level.slowLoop, callback, callbackName);
				break;
			case "medium":
				level.mediumLoop = maps\mp\uox\_uox_arrays::arrayPush(level.mediumLoop, callback, callbackName);
				break;
			case "fast":
				level.fastLoop = maps\mp\uox\_uox_arrays::arrayPush(level.fastLoop, callback, callbackName);
				break;
		}
	}
	else
	{
		switch(loop)
		{
			case "slow":
				ent.slowLoop = maps\mp\uox\_uox_arrays::arrayPush(ent.slowLoop, callback, callbackName);
				break;
			case "medium":
				ent.mediumLoop = maps\mp\uox\_uox_arrays::arrayPush(ent.mediumLoop, callback, callbackName);
				break;
			case "fast":
				ent.fastLoop = maps\mp\uox\_uox_arrays::arrayPush(ent.fastLoop, callback, callbackName);
				break;
		}
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
	if(ent == level)
	{
		switch(loop)
		{
			case "slow":
				level.slowLoop = maps\mp\uox\_uox_arrays::arraySlice(level.slowLoop, callbackName);
				break;
			case "medium":
				level.mediumLoop = maps\mp\uox\_uox_arrays::arraySlice(level.mediumLoop, callbackName);
				break;
			case "fast":
				level.fastLoop = maps\mp\uox\_uox_arrays::arraySlice(level.fastLoop, callbackName);
				break;
		}
	}
	else
	{
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
}

/* *************************************************************************************************
**** addToWaitTills(entity ent, str notify, function callback)
****
**** USAGE: adds a callback to execute once the waittill notification has fired
****  
************************************************************************************************* */
addToWaitTills(ent, msg, callback)
{
	if(ent == level)
		return; //not implemented yet
	else
	{
		waiter = [];
		waiter["msg"] = msg;
		waiter["callback"] = callback;
		waiter["waiting"] = false;
		ent.waitTills = ent maps\mp\uox\_uox_arrays::arrayPush(ent.waitTills, waiter, msg);
	}
}

/* *************************************************************************************************
**** removeFromWaitTills(entity ent, str msg)
****
**** USAGE: removes waittill from loop and sends a kill notification to the pending waittill
****  
************************************************************************************************* */
removeFromWaitTills(ent, msg)
{
	if(ent == level)
		return; //not implemented yet
	else
	{
		
		ent.waitTills = ent maps\mp\uox\_uox_arrays::arraySlice(ent.waitTills, "msg");
		ent notify("kill_" + msg);
		
	}
	return ent.waitTills;
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
	self.waitTills = self maps\mp\uox\_uox_arrays::arraySetProperty(self.waitTills, waiter["msg"], "waiting", true);
	
	self notify("kill_" + waiter["msg"]);
	self endon("kill_" + waiter["msg"]);
	self endon("disconnect");
	self endon("destroyed");
	
	self waittill(waiter["msg"]);
	self thread [[waiter["callback"]]]();
	self.waitTills	= self maps\mp\uox\_uox_arrays::arraySetProperty(self.waitTills, waiter["msg"], "waiting",
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
}