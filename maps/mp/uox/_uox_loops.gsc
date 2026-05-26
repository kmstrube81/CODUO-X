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
	
	self.fastLoop = [];
	self.mediumLoop = [];
	self.slowLoop = [];
	self.waitTills = [];
	
	//start Loop
	for(frame = 0; true; frame++)
	{
		if(frame == 20)
			frame = 0;
		if(frame == 0)
		{
			for(i = 0; i < self.slowLoop.size; i++)
			{
				self thread [[self.slowLoop[i]]]();
			}
		}
		if(frame % 5 == 0)
		{
			for(i = 0; i < self.mediumLoop.size; i++)
			{
				self thread [[self.mediumLoop[i]]]();
			}
		}
		for(i = 0; i < self.fastLoop.size; i++)
		{
			self thread [[self.fastLoop[i]]]();
		}
		for(i = 0; i < self.waitTills.size; i++)
		{
			waiter = self.waitTills[i];
			if(!waiter["waiting"])
				self thread doWait(i);
		}
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
	
	self.fastLoop = [];
	self.mediumLoop = [];
	self.slowLoop = [];
	self.waitTills = [];
	
	//start Loop
	for(frame = 0; true; frame++)
	{
		if(frame == 20)
			frame = 0;
		if(frame == 0)
		{
			for(i = 0; i < self.slowLoop.size; i++)
			{
				self thread [[self.slowLoop[i]]]();
			}
		}
		if(frame % 5 == 0)
		{
			for(i = 0; i < self.mediumLoop.size; i++)
			{
				self thread [[self.mediumLoop[i]]]();
			}
		}
		for(i = 0; i < self.fastLoop.size; i++)
		{
			self thread [[self.fastLoop[i]]]();
		}
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
addToLoop(ent, loop, callback)
{
	if(ent == level)
	{
		switch(loop)
		{
			case "slow":
				index = maps\mp\uox\_uox_arrays::arrayFind(level.slowLoop, callback);
				if(!isDefined(index))
					level.slowLoop = maps\mp\uox\_uox_arrays::arrayPush(level.slowLoop, callback);
				break;
			case "medium":
				index = maps\mp\uox\_uox_arrays::arrayFind(level.mediumLoop, callback);
				if(!isDefined(index))
					level.mediumLoop = maps\mp\uox\_uox_arrays::arrayPush(level.mediumLoop, callback);
				break;
			case "fast":
				index = maps\mp\uox\_uox_arrays::arrayFind(level.fastLoop, callback);
				if(!isDefined(index))
					level.fastLoop = maps\mp\uox\_uox_arrays::arrayPush(level.fastLoop, callback);
				break;
		}
	}
	else
	{
		switch(loop)
		{
			case "slow":
				index = maps\mp\uox\_uox_arrays::arrayFind(ent.slowLoop, callback);
				if(!isDefined(index))
					ent.slowLoop = maps\mp\uox\_uox_arrays::arrayPush(ent.slowLoop, callback);
				break;
			case "medium":
				index = maps\mp\uox\_uox_arrays::arrayFind(ent.mediumLoop, callback);
				if(!isDefined(index))
					ent.mediumLoop = maps\mp\uox\_uox_arrays::arrayPush(ent.mediumLoop, callback);
				break;
			case "fast":
				index = maps\mp\uox\_uox_arrays::arrayFind(ent.fastLoop, callback);
				if(!isDefined(index))
					ent.fastLoop = maps\mp\uox\_uox_arrays::arrayPush(ent.fastLoop, callback);
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
removeFromLoop(ent, loop, callback)
{
	if(ent == level)
	{
		switch(loop)
		{
			case "slow":
				index = maps\mp\uox\_uox_arrays::arrayFind(level.slowLoop, callback);
				if(isDefined(index))
					level.slowLoop = maps\mp\uox\_uox_arrays::arraySlice(level.slowLoop, index);
				break;
			case "medium":
				index = maps\mp\uox\_uox_arrays::arrayFind(level.mediumLoop, callback);
				if(isDefined(index))
					level.mediumLoop = maps\mp\uox\_uox_arrays::arraySlice(level.mediumLoop, index);
				break;
			case "fast":
				index = maps\mp\uox\_uox_arrays::arrayFind(level.fastLoop, callback);
				if(isDefined(index))
					level.fastLoop = maps\mp\uox\_uox_arrays::arraySlice(level.fastLoop, index);
				break;
		}
	}
	else
	{
		switch(loop)
		{
			case "slow":
				index = maps\mp\uox\_uox_arrays::arrayFind(ent.slowLoop, callback);
				if(isDefined(index))
					ent.slowLoop = maps\mp\uox\_uox_arrays::arraySlice(ent.slowLoop, index);
				break;
			case "medium":
				index = maps\mp\uox\_uox_arrays::arrayFind(ent.mediumLoop, callback);
				if(isDefined(index))
					ent.mediumLoop = maps\mp\uox\_uox_arrays::arraySlice(ent.mediumLoop, index);
				break;
			case "fast":
				index = maps\mp\uox\_uox_arrays::arrayFind(ent.fastLoop, callback);
				if(isDefined(index))
					ent.fastLoop = maps\mp\uox\_uox_arrays::arraySlice(ent.fastLoop, index);
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
		index = ent maps\mp\uox\_uox_arrays::searchObjArrayByProperty(ent.waitTills, "msg", msg);
		waiter = [];
		waiter["msg"] = msg;
		waiter["callback"] = callback;
		waiter["waiting"] = false;
		if(!isDefined(index))
		{
			ent.waitTills = ent maps\mp\uox\_uox_arrays::arrayPush(ent.waitTills, waiter);
		}
		else if(waiter["callback"] != ent.waitTills[index]["callback"])
		{
			ent.waitTills[index]["callback"] = callback;
		}
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
		index = ent maps\mp\uox\_uox_arrays::searchObjArrayByProperty(ent.waitTills, "msg", msg);
		if(isDefined(index))
		{
			ent.waitTills = ent maps\mp\uox\_uox_arrays::arraySlice(ent.waitTills, index);
			ent notify("kill_" + msg);
		}
	}
	return ent.waitTills;
}

/* *************************************************************************************************
**** doWait(obj wait)
****
**** USAGE: waits for notification and executes callback and sets it back to waiter mode
****  
************************************************************************************************* */
doWait(index)
{
	waiter = self.waitTills[index];
	self endon("kill_" + waiter["msg"]);
	self endon("disconnect");
	self endon("destroyed");
	
	if(waiter["waiting"])
		return;
	
	waiter["waiting"] = true;
	self waittill(waiter["msg"]);
	self thread [[waiter["callback"]]]();
	waiter["waiting"] = false;
	
	return waiter;
}