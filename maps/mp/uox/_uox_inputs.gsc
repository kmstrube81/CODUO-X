/* *************************************************************************************************
**** initPlayerInputs()
****
**** adds monitors to player fastLoop
****  
************************************************************************************************* */
initPlayerInputs()
{
	if(!isDefined(self.initCount))
	    self.initCount = 0;
	self.initCount++;
	maps\mp\uox\_uox_debug::debugLog("info", "player init #" + self.initCount + " for " + self.name + "\n");
	self initInputSequences();
	self maps\mp\uox\_uox_loops::addToLoop(self, "fast", ::monitorUseKey, "monitorUseKey");
	self maps\mp\uox\_uox_loops::addToLoop(self, "fast", ::monitorMeleeKey, "monitorMeleeKey");
	self maps\mp\uox\_uox_loops::addToWaitTills(self, "Pressed Use", ::watchUse);
}

/* *************************************************************************************************
**** initInputSequences()
****
**** sets up the inpute sequences and registered commands
****  
************************************************************************************************* */
initInputSequences()
{
	//init default input sequences (hold use, hold melee, doubletap use, double tap melee
	self.holdUse = maps\mp\uox\_uox_arrays::superArray();
	//TO DO: add cvar for setting default action

	self.holdMelee = maps\mp\uox\_uox_arrays::superArray();
	//TO DO: add cvar for setting default action
}

/* *************************************************************************************************
**** monitorUseKey()
****
**** sends a notify when the use key is pressed
****  
************************************************************************************************* */
monitorUseKey()
{
	//don't monitor in any of these cases
	if(!isPlayer(self)|| !isAlive(self) || !(self isOnGround()) || self.pers["team"] == "spectator"
		|| level.mapended || level.roundended)
		return;
	if(!isDefined(self.isUsing))
		self.isUsing = false;
	
	if(self.isUsing)
		return;
	
	if(self useButtonPressed())
	{
		self.isUsing = true;
		self notify("Pressed Use");
	}
	else
		self.isUsing = false;
}

isPressingUse(trigger)
{
	if(self useButtonPressed())
		return true;
	return false;
}

watchUse()
{
	self endon("disconnect");
	
	//array shape n["callback"] - what happens when finished
	// n["delaytime"] how long before hold starts counting
	// n["waittime"] how long it takes
	// n["progressbar"] whether to draw progress bar
	use = maps\mp\uox\_uox_arrays::getNextValue(self.holdUse);
	
	if(!isDefined(use))
	{
		skipHold = true; //no current hold use, nothing to do
		delaytime = 0;
	}
	else
	{
		skipHold = false;
		msg = maps\mp\uox\_uox_arrays::getNextKey(self.holdUse);
		delaytime = use["delaytime"];
		waittime = use["waittime"];
		conditionCallback = use["condition"];
		holdCallback = use["callback"];
		failCallback = use["failure"];
		drawProgressBar = use["progressbar"];
		lockInPlace = use["lock"];
		disableWeapon = use["disableweapon"];
		trigger = use["trigger"];
		audioCue = use["audiocue"];
	}
	
	if(!isDefined(conditionCallback))
		conditionCallback = ::isPressingUse;
	
	self.currenttime = 0;
	while(!skipHold && self useButtonPressed()
		&& (!isDefined(trigger) || (isDefined(trigger) && self [[ conditionCallback ]](trigger))) )
	{
		usetime = 0;
		while(isAlive(self) && self useButtonPressed() && (usetime < delaytime))
		{
			wait .05;
			usetime = (usetime + .05);
		}
		
		if(!(self isOnGround()))
		{
			continue;
		}

		if((isAlive(self)) && (self useButtonPressed()))
		{	
			self maps\mp\uox\_uox_hud::createClientHUDProgressBar(waittime);
			progresstime = 0;
			
			self notify("kill_check_" + msg);
			
			if(isDefined(trigger))
				trigger.doing = true;
			
			if(lockInPlace)
			{
				spawned = spawn("script_origin", self.origin);
				if(isdefined(spawned))
					self linkto(spawned);
			}
			
			if(disableWeapon)
				self disableWeapon();
			
			if(isDefined(audioCue) && isDefined(trigger))
				trigger playsound(audioCue);
			
			while(isAlive(self) && self useButtonPressed() && (progresstime < waittime))
			{
				progresstime += 0.05;
				wait 0.05;
			}

			//delete hud elems
			self maps\mp\uox\_uox_hud::deleteClientHUDProgressBar();

			//did it!
			if(progresstime >= waittime)
			{
				self thread [[holdCallback]](trigger);
				self unlink();
				self enableWeapon();
				self.isUsing = false;
				return;
			}
			else
			{
				self.isUsing = false;
				self unlink();
				self enableWeapon();
				if(isDefined(trigger))
					trigger.doing = undefined;
				if(isDefined(failCallback))
					self thread [[failCallback]](trigger);
			}
		}
	}
	//got here, record the input instead TODO input recording
	
	//after recording input, makesure it still isn't held down
	while(self useButtonPressed())
		wait 0.05;
	//mark as no using
	self.isUsing = false;
}

addHoldUse(msg, delayTime, waitTime, conditionCallback, successCallback, failCallback, drawProgressBar, lockInPlace, disableWeapon, trigger, audioCue)
{
		
	if(!isDefined(drawProgressBar))
		drawProgressBar = false;
	if(!isDefined(lockInPlace))
		lockInPlace = false;
	if(!isDefined(disableWeapon))
		disableWeapon = false;
	
	hold = [];
	hold["msg"] = msg;
	hold["delaytime"] = delayTime;
	hold["waittime"] = waitTime;
	hold["condition"] = conditionCallback;
	hold["callback"] = successCallback;
	hold["failure"] = failCallback;
	hold["progressbar"] = drawProgressBar;
	hold["lock"] = lockInPlace;
	hold["disableweapon"] = disableWeapon;
	hold["trigger"] = trigger;
	hold["audiocue"] = audioCue;
	
	self.holdUse = maps\mp\uox\_uox_arrays::arrayUnshift(self.holdUse, hold, msg);
	
	maps\mp\uox\_uox_debug::debugLog("info", "HoldUse register: msg=" + msg + " new size=" + self.holdUse["length"], "self.holdUse", self.holdUse);
}

removeHoldUse(msg)
{
	self.holdUse = maps\mp\uox\_uox_arrays::arraySlice(self.holdUse, msg);
	maps\mp\uox\_uox_debug::debugLog("info", "HoldUse deregister: msg=" + msg + " new size=" + self.holdUse["length"], "self.holdUse", self.holdUse);
}

/* *************************************************************************************************
**** monitorMeleeKey()
****
**** sends a notify when the melee key is pressed
****  
************************************************************************************************* */
monitorMeleeKey()
{
	//don't monitor in any of these cases
	if(!isPlayer(self)|| !isAlive(self) || !(self isOnGround()) || self.pers["team"] == "spectator"
		|| level.mapended || level.roundended)
	return;
	
	if(!isDefined(self.isMelee))
		self.isMelee = false;
	
	if(self.isMelee)
		return;
	
	if(self meleeButtonPressed())
	{
		self.ismelee = true;
		self notify("Pressed Melee");
	}
}