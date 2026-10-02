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
    self maps\mp\uox\_uox_loops::addToLoop(self, "fast", ::monitorInputs, "monitorInputs");
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
    self.inputStream = [];
	//init default input sequences (hold use, hold melee, doubletap use, double tap melee
	self.holdUse = maps\mp\uox\_uox_arrays::superArray();
	//TO DO: add cvar for setting default action

	self.holdMelee = maps\mp\uox\_uox_arrays::superArray();
	//TO DO: add cvar for setting default action

    self.inputCombos = maps\mp\uox\_uox_arrays::superArray();
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

isPressingUse()
{
	if(self useButtonPressed())
		return true;
	return false;
}

watchUse()
{
	self endon("disconnect");
    self endon("killed");
    self endon("Pressed Melee");
	
	//array shape n["callback"] - what happens when finished
	// n["delaytime"] how long before hold starts counting
	// n["waittime"] how long it takes
	// n["progressbar"] whether to draw progress bar
	use = maps\mp\uox\_uox_arrays::getNextValue(self.holdUse); //load top of stack
	
	if(!isDefined(use))
	{
		skipHold = true; //no current hold use, nothing to do
		delaytime = 0;
	}
	else
	{
		skipHold = false;
		msg = maps\mp\uox\_uox_arrays::getNextKey(self.holdUse); //get the notify msg
		delaytime = use["delaytime"]; //get how long it must be held to register as a use
		waittime = use["waittime"]; //how long to wait before doing the action
		conditionCallback = use["condition"]; //the functionPointer that returns true or false for the hold use, must be used with trigger
		holdCallback = use["callback"]; //the functionPointer of the success path
		failCallback = use["failure"]; //the functionPointer of the fail path
		drawProgressBar = use["progressbar"]; //should a progress bar be drawn
		lockInPlace = use["lock"]; //should the player be locked in place while doing it
		disableWeapon = use["disableweapon"]; //can the player shoot/reload while doing it
		trigger = use["trigger"]; //the entity associated with the hold use
		audioCue = use["audiocue"]; //sound to play while doing hold use
	}
	
	if(!isDefined(conditionCallback))
		conditionCallback = ::isPressingUse; //defined that use key must be pressed by default
	
	//self.currenttime = 0; //frames held down
	while(!skipHold && self useButtonPressed() //while the use button is pressed and the condition callback is true
		&& (( !isDefined(trigger) && [[ conditionCallback ]]() ) || (isDefined(trigger) && self [[ conditionCallback ]](trigger))) )
	{
		usetime = 0; //the number of frames held down
		while(isAlive(self) && self useButtonPressed() && (usetime < delaytime)) //button must be held down for the delay time first
		{
			wait level.frametime;
			usetime = (usetime + level.frametime);
		}
		
		if(!(self isOnGround())) //if player is no longer on ground, restart sequence
		{
			continue;
		}

		if((isAlive(self)) && (self useButtonPressed())) // made it past the delay time
		{	
			self maps\mp\uox\_uox_hud::createClientHUDProgressBar(waittime); //draw the progress bar

			self notify("kill_check_" + msg); //send a kill notify to end any endon threads
			
			if(isDefined(trigger)) //if trigger exists
				trigger.doing = true; //mark it as being done
			
			if(lockInPlace) //spawn a struct and link player to it if lockinplace is true
			{
				spawned = spawn("script_origin", self.origin);
				if(isdefined(spawned))
					self linkto(spawned);
			}
			
			if(disableWeapon) //if disable weapon is set then disable weapon
				self disableWeapon();
			
			if(isDefined(audioCue)) //play the audio cue
				self playsound(audioCue);
			
			while(isAlive(self) && self useButtonPressed() && (usetime < waittime)) //wait until wait time passed
			{
				wait level.frametime;
                usetime = (usetime + level.frametime);
			}

			//delete hud elems
			self maps\mp\uox\_uox_hud::deleteClientHUDProgressBar();

			//did it!
			if(usetime >= waittime)
			{
                if(isDefined(trigger)) //and that the trigger isn't being done anymore
                {
                    trigger.doing = undefined;
                    self thread [[holdCallback]](trigger); //do success path
                }
				else
                    self thread [[holdCallback]](); //do success path
				self unlink(); //let the player move
				self enableWeapon(); //and shoot
				self.isUsing = false; //mark that the player isn't holding use
                if(lockInPlace) //destroy struct that held player in place
                {
                    if(isdefined(spawned))
                        spawned destroy();
                }
				return; //finish hold use
			}
			else // didnt hold long enough
			{
				self.isUsing = false; //mark that player isn't holding use
				self unlink(); //let player move
				self enableWeapon(); //let player shoot
				if(isDefined(trigger)) //trigger isn't being done anymore
                {
                    trigger.doing = undefined;
                    if(isDefined(failCallback)) //do fail path
                        self thread [[failCallback]](trigger);
                }
                else
                {
                    if(isDefined(failCallback)) //do fail path
                        self thread [[failCallback]]();
                }
			}
		}
	}
	//got here, record the input instead TODO input recording
	recordtime = level.inputFrameWindow; //5 frames default held time to register a tap
      
	//before recording input, makesure it still isn't held down
	while(self useButtonPressed())
    {
        wait level.frametime;
        usetime = (usetime + level.frametime);
    }
    if(usetime <= recordtime) 
    {
        self.inputStream[self.inputStream.size] = "use";
    }
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
		self.isMelee = true;
		self notify("Pressed Melee");
	}
}

isPressingMelee(trigger)
{
	if(self meleeButtonPressed())
		return true;
	return false;
}

watchMelee()
{
	self endon("disconnect");
    self endon("Pressed Use");
    self endon("killed");
	
	//array shape n["callback"] - what happens when finished
	// n["delaytime"] how long before hold starts counting
	// n["waittime"] how long it takes
	// n["progressbar"] whether to draw progress bar
	melee = maps\mp\uox\_uox_arrays::getNextValue(self.holdMelee); //load top of stack
	
	if(!isDefined(melee))
	{
		skipHold = true; //no current hold use, nothing to do
		delaytime = 0;
	}
	else
	{
		skipHold = false;
		msg = maps\mp\uox\_uox_arrays::getNextKey(self.holdMelee); //get the notify msg
		delaytime = melee["delaytime"]; //get how long it must be held to register as a melee
		waittime = melee["waittime"]; //how long to wait before doing the action
		conditionCallback = melee["condition"]; //the functionPointer that returns true or false for the hold use, must be used with trigger
		holdCallback = melee["callback"]; //the functionPointer of the success path
		failCallback = melee["failure"]; //the functionPointer of the fail path
		drawProgressBar = melee["progressbar"]; //should a progress bar be drawn
		lockInPlace = melee["lock"]; //should the player be locked in place while doing it
		disableWeapon = melee["disableweapon"]; //can the player shoot/reload while doing it
		trigger = melee["trigger"]; //the entity associated with the hold use
		audioCue = melee["audiocue"]; //sound to play while doing hold use
	}
	
	if(!isDefined(conditionCallback))
		conditionCallback = ::isPressingMelee; //defined that use key must be pressed by default
	
	//self.currenttime = 0; //frames held down
	while(!skipHold && self useButtonPressed() //while the use button is pressed and the condition callback is true
		&& (( !isDefined(trigger) && [[ conditionCallback ]]() ) || (isDefined(trigger) && self [[ conditionCallback ]](trigger))) )
	{
		meleetime = 0; //the number of frames held down
		while(isAlive(self) && self meleeButtonPressed() && (meleetime < delaytime)) //button must be held down for the delay time first
		{
			wait level.frametime;
			meleetime = (meleetime + level.frametime);
		}
		
		if(!(self isOnGround())) //if player is no longer on ground, restart sequence
		{
			continue;
		}

		if((isAlive(self)) && (self meleeButtonPressed())) // made it past the delay time
		{	
			self maps\mp\uox\_uox_hud::createClientHUDProgressBar(waittime); //draw the progress bar

			self notify("kill_check_" + msg); //send a kill notify to end any endon threads
			
			if(isDefined(trigger)) //if trigger exists
				trigger.doing = true; //mark it as being done
			
			if(lockInPlace) //spawn a struct and link player to it if lockinplace is true
			{
				spawned = spawn("script_origin", self.origin);
				if(isdefined(spawned))
					self linkto(spawned);
			}
			
			if(disableWeapon) //if disable weapon is set then disable weapon
				self disableWeapon();
			
			if(isDefined(audioCue)) //play the audio cue
				self playsound(audioCue);
			
			while(isAlive(self) && self meleeButtonPressed() && (meleetime < waittime)) //wait until wait time passed
			{
				wait level.frametime;
                meleetime = (meleetime + level.frametime);
			}

			//delete hud elems
			self maps\mp\uox\_uox_hud::deleteClientHUDProgressBar();

			//did it!
			if(meleetime >= waittime)
			{
				if(isDefined(trigger)) //and that the trigger isn't being done anymore
                {
                    trigger.doing = undefined;
                    self thread [[holdCallback]](trigger); //do success path
                }
				else
                    self thread [[holdCallback]](); //do success path
				self unlink(); //let the player move
				self enableWeapon(); //and shoot
				self.isMelee = false; //mark that the player isn't holding use
                if(lockInPlace) //destroy struct that held player in place
                {
                    if(isdefined(spawned))
                        spawned destroy();
                }
				return; //finish hold use
			}
			else // didnt hold long enough
			{
				self.isMelee = false; //mark that player isn't holding use
				self unlink(); //let player move
				self enableWeapon(); //let player shoot
				if(isDefined(trigger)) //trigger isn't being done anymore
                {
                    trigger.doing = undefined;
                    if(isDefined(failCallback)) //do fail path
                        self thread [[failCallback]](trigger);
                }
                else
                {
                    if(isDefined(failCallback)) //do fail path
                        self thread [[failCallback]]();
                }
			}
		}
	}
	//got here, record the input instead TODO input recording
	recordtime = level.inputFrameWindow; //5 frames default held time to register a tap
      
	//before recording input, makesure it still isn't held down
	while(self meleeButtonPressed())
    {
        wait level.frametime;
        meleetime = (meleetime + level.frametime);
    }
    if(meleetime <= recordtime) 
    {
        self.inputStream[self.inputStream.size] = "melee";
    }
	//mark as no using
	self.isMelee = false;
}

addHoldMelee(msg, delayTime, waitTime, conditionCallback, successCallback, failCallback, drawProgressBar, lockInPlace, disableWeapon, trigger, audioCue)
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
	
	self.holdMelee = maps\mp\uox\_uox_arrays::arrayUnshift(self.holdMelee, hold, msg);
	
	maps\mp\uox\_uox_debug::debugLog("info", "HoldMelee register: msg=" + msg + " new size=" + self.holdMelee["length"], "self.holdMelee", self.holdMelee);
}

removeHoldMelee(msg)
{
	self.holdMelee = maps\mp\uox\_uox_arrays::arraySlice(self.holdMelee, msg);
	maps\mp\uox\_uox_debug::debugLog("info", "HoldMelee deregister: msg=" + msg + " new size=" + self.holdMelee["length"], "self.holdMelee", self.holdMelee);
}

/* *************************************************************************************************
**** monitorInputs()
****
**** monitors Input stream
****  
************************************************************************************************* */
monitorInputs()
{
    if(!isDefined(self.inputFrame))
        self.inputFrame = 0;

    if(self.inputFrame > level.inputFrameWindow)
    {
        self doInputCombination(self.inputStream); //check if something is registered to the input combo
        self.inputStream = []; //reset current inputStream
        self.inputFrame = 0; //reset frame buffer to 0
    }
    else
        self.inputFrame++;
}

/* *************************************************************************************************
**** doInputCombination()
****
**** monitors Input stream
****  
************************************************************************************************* */
doInputCombination(combo)
{
    if(combo.size < 2) //input combo must have at least 2 inputs
        return;

    combo_str = ""; //convert combo into string
    for(i = 0; i < combo.size; i++)
    {
        key = combo[i];
        if(combo_str != "")
            combo_str += " ";
        combo_str += key;
    }

    callback = maps\mp\uox\_uox_arrays::getValue(self.inputCombos, "combo_str");

    if(isDefined(callback))
        thread [[callback]]();
}

addInputCombination(combo, callback, callbackName)
{
    if(!isDefined(callbackName))
        callbackName = combo;

    //check if valid combo
    split = stringSplit(combo, " ");
    for(i = 0; i < split.size; i++)
    {
        input = split[i];
        switch(input)
        {
            case: "use":
            case: "melee":
            case: "meleeuse":
                break;
            default:
                maps\mp\uox\_uox_debug::debugLog("info", "Invalid InputCombo aborting- " + combo + " Callback- " + callbackName + " new size=" + self.inputCombos["length"], "self.inputCombos", self.inputCombos);
                return;
        }
    }

	self.inputCombos = maps\mp\uox\_uox_arrays::arrayPush(self.inputCombos, callback, combo);
	
	maps\mp\uox\_uox_debug::debugLog("info", "InputCombo registered- " + " Callback- " + callbackName + " new size=" + self.inputCombos["length"], "self.inputCombos", self.inputCombos);
}

removeInputCombination(combo)
{
	self.inputCombos = maps\mp\uox\_uox_arrays::arraySlice(self.inputCombos, combo);
	maps\mp\uox\_uox_debug::debugLog("info", "InputCombo deregister: msg=" + combo + " new size=" + self.inputCombos["length"], "self.inputCombos", self.inputCombos);
}
