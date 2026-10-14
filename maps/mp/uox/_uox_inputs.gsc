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
	self maps\mp\uox\_uox_loops::addToLoop(self, "fast", ::monitorFireKey, "monitorFireKey");
    self maps\mp\uox\_uox_loops::addToLoop(self, "fast", ::monitorInputs, "monitorInputs");
	self maps\mp\uox\_uox_loops::addToWaitTills(self, "Pressed Use", ::watchUse);
	self maps\mp\uox\_uox_loops::addToWaitTills(self, "Pressed Melee", ::watchMelee);
	self maps\mp\uox\_uox_loops::addToWaitTills(self, "Pressed Fire", ::watchFire);
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
    self.holdFire = maps\mp\uox\_uox_arrays::superArray();
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
    if(!isPlayer(self) || level.roundended || level.mapended)
        return;
    pressed = self useButtonPressed();
    if(pressed && !isDefined(self.wasUsing))
        self notify("Pressed Use");
    if(pressed) self.wasUsing = true;
    else self.wasUsing = undefined;
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
	
	//array shape n["callback"] - what happens when finished
	// n["delaytime"] how long before hold starts counting
	// n["waittime"] how long it takes
	// n["progressbar"] whether to draw progress bar
	use = maps\mp\uox\_uox_arrays::getNextValue(self.holdUse); //load top of stack
	usetime = 0; //the number of frames held down
	
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
	while(!skipHold && self useButtonPressed() && !(self meleeButtonPressed()) //while the use button is pressed and the condition callback is true
		&& (( !isDefined(trigger) && [[ conditionCallback ]]() ) || (isDefined(trigger) && self [[ conditionCallback ]](trigger))) )
	{
		while((( !isDefined(trigger) && [[ conditionCallback ]]() ) || (isDefined(trigger) && self [[ conditionCallback ]](trigger))) && self useButtonPressed() && !(self meleeButtonPressed()) && (usetime < delaytime)) //button must be held down for the delay time first
		{
			wait level.frametime;
			usetime = (usetime + level.frametime);
		}

		if((( !isDefined(trigger) && [[ conditionCallback ]]() ) || (isDefined(trigger) && self [[ conditionCallback ]](trigger))) && (self useButtonPressed()) && !(self meleeButtonPressed()) ) // made it past the delay time
		{	
			if(drawProgressBar)
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
			
			while((( !isDefined(trigger) && [[ conditionCallback ]]() ) || (isDefined(trigger) && self [[ conditionCallback ]](trigger))) && self useButtonPressed() && !(self meleeButtonPressed()) && (usetime < waittime)) //wait until wait time passed
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
				self.wasUsing = false; //mark that the player isn't holding use
                if(lockInPlace) //destroy struct that held player in place
                {
                    if(isdefined(spawned))
                        spawned destroy();
                }
				return; //finish hold use
			}
			else // didnt hold long enough
			{
				self.wasUsing = false; //mark that player isn't holding use
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
	self.wasUsing = false;
}

addHoldUse(msg, dir, delayTime, waitTime, conditionCallback, successCallback, failCallback, drawProgressBar, lockInPlace, disableWeapon, trigger, audioCue)
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
	
	if(dir) //false pushes hold use to top of stack, true to the bottom
		self.holdUse = maps\mp\uox\_uox_arrays::arrayPush(self.holdUse, hold, msg);
	else
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
    if(!isPlayer(self) || level.roundended || level.mapended)
        return;
    pressed = self meleeButtonPressed();
    if(pressed && !isDefined(self.wasMelee))
        self notify("Pressed Melee");
    if(pressed) self.wasMelee = true;
    else self.wasMelee = undefined;
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
	
	//array shape n["callback"] - what happens when finished
	// n["delaytime"] how long before hold starts counting
	// n["waittime"] how long it takes
	// n["progressbar"] whether to draw progress bar
	melee = maps\mp\uox\_uox_arrays::getNextValue(self.holdMelee); //load top of stack
	meleetime = 0; //the number of frames held down
	
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
	while(!skipHold && self useButtonPressed() && !(self useButtonPressed()) //while the use button is pressed and the condition callback is true
		&& (( !isDefined(trigger) && [[ conditionCallback ]]() ) || (isDefined(trigger) && self [[ conditionCallback ]](trigger))) )
	{
		
		while((( !isDefined(trigger) && [[ conditionCallback ]]() ) || (isDefined(trigger) && self [[ conditionCallback ]](trigger))) && self meleeButtonPressed() && !(self useButtonPressed()) && (meleetime < delaytime)) //button must be held down for the delay time first
		{
			wait level.frametime;
			meleetime = (meleetime + level.frametime);
		}

		if((( !isDefined(trigger) && [[ conditionCallback ]]() ) || (isDefined(trigger) && self [[ conditionCallback ]](trigger))) && (self meleeButtonPressed()) && !(self useButtonPressed())) // made it past the delay time
		{	
			if(drawProgressBar)
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
			
			while((( !isDefined(trigger) && [[ conditionCallback ]]() ) || (isDefined(trigger) && self [[ conditionCallback ]](trigger))) && self meleeButtonPressed() && !(self useButtonPressed())  && (meleetime < waittime)) //wait until wait time passed
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
				self.wasMelee = false; //mark that the player isn't holding use
                if(lockInPlace) //destroy struct that held player in place
                {
                    if(isdefined(spawned))
                        spawned destroy();
                }
				return; //finish hold use
			}
			else // didnt hold long enough
			{
				self.wasMelee = false; //mark that player isn't holding use
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
	self.wasMelee = false;
}

addHoldMelee(msg, dir, delayTime, waitTime, conditionCallback, successCallback, failCallback, drawProgressBar, lockInPlace, disableWeapon, trigger, audioCue)
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
	
	if(dir) //false pushes hold use to top of stack, true to the bottom
		self.holdMelee = maps\mp\uox\_uox_arrays::arrayPush(self.holdMelee, hold, msg);
	else
		self.holdMelee = maps\mp\uox\_uox_arrays::arrayUnshift(self.holdMelee, hold, msg);
	maps\mp\uox\_uox_debug::debugLog("info", "HoldMelee register: msg=" + msg + " new size=" + self.holdMelee["length"], "self.holdMelee", self.holdMelee);
}

removeHoldMelee(msg)
{
	self.holdMelee = maps\mp\uox\_uox_arrays::arraySlice(self.holdMelee, msg);
	maps\mp\uox\_uox_debug::debugLog("info", "HoldMelee deregister: msg=" + msg + " new size=" + self.holdMelee["length"], "self.holdMelee", self.holdMelee);
}

/* *************************************************************************************************
**** monitorFireKey()
****
**** sends a notify when the fire key is pressed
****  
************************************************************************************************* */
monitorFireKey()
{
    if(!isPlayer(self) || level.roundended || level.mapended)
        return;
    pressed = self attackButtonPressed();
    if(pressed && !isDefined(self.wasFiring))
        self notify("Pressed Fire");
    if(pressed) self.wasFiring = true;
    else self.wasFiring = undefined;
}

isPressingFire()
{
	if(self attackButtonPressed())
		return true;
	return false;
}

watchFire()
{
	self endon("disconnect");
	
	//array shape n["callback"] - what happens when finished
	// n["delaytime"] how long before hold starts counting
	// n["waittime"] how long it takes
	// n["progressbar"] whether to draw progress bar
	fire = maps\mp\uox\_uox_arrays::getNextValue(self.holdFire); //load top of stack
	firetime = 0; //the number of frames held down
	
	if(!isDefined(fire))
	{
		skipHold = true; //no current hold fire, nothing to do
		delaytime = 0;
	}
	else
	{
		skipHold = false;
		msg = maps\mp\uox\_uox_arrays::getNextKey(self.holdFire); //get the notify msg
		delaytime = fire["delaytime"]; //get how long it must be held to register as a fire
		waittime = fire["waittime"]; //how long to wait before doing the action
		conditionCallback = fire["condition"]; //the functionPointer that returns true or false for the hold fire, must be fired with trigger
		holdCallback = fire["callback"]; //the functionPointer of the success path
		failCallback = fire["failure"]; //the functionPointer of the fail path
		drawProgressBar = fire["progressbar"]; //should a progress bar be drawn
		lockInPlace = fire["lock"]; //should the player be locked in place while doing it
		disableWeapon = fire["disableweapon"]; //can the player shoot/reload while doing it
		trigger = fire["trigger"]; //the entity associated with the hold fire
		audioCue = fire["audiocue"]; //sound to play while doing hold fire
	}
	
	if(!isDefined(conditionCallback))
		conditionCallback = ::isPressingFire; //defined that fire key must be pressed by default
	
	//self.currenttime = 0; //frames held down
	while(!skipHold && self attackButtonPressed()  //while the fire button is pressed and the condition callback is true
		&& (( !isDefined(trigger) && [[ conditionCallback ]]() ) || (isDefined(trigger) && self [[ conditionCallback ]](trigger))) )
	{
		while((( !isDefined(trigger) && [[ conditionCallback ]]() ) || (isDefined(trigger) && self [[ conditionCallback ]](trigger))) && self attackButtonPressed() && (firetime < delaytime)) //button must be held down for the delay time first
		{
			wait level.frametime;
			firetime = (firetime + level.frametime);
		}

		if((( !isDefined(trigger) && [[ conditionCallback ]]() ) || (isDefined(trigger) && self [[ conditionCallback ]](trigger))) && (self attackButtonPressed()) ) // made it past the delay time
		{	
			if(drawProgressBar)
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
			
			while((( !isDefined(trigger) && [[ conditionCallback ]]() ) || (isDefined(trigger) && self [[ conditionCallback ]](trigger))) && self attackButtonPressed() && (firetime < waittime)) //wait until wait time passed
			{
				wait level.frametime;
                firetime = (firetime + level.frametime);
			}

			//delete hud elems
			self maps\mp\uox\_uox_hud::deleteClientHUDProgressBar();

			//did it!
			if(firetime >= waittime)
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
				self.wasFiring = false; //mark that the player isn't holding fire
                if(lockInPlace) //destroy struct that held player in place
                {
                    if(isdefined(spawned))
                        spawned destroy();
                }
				return; //finish hold fire
			}
			else // didnt hold long enough
			{
				self.wasFiring = false; //mark that player isn't holding fire
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
	while(self attackButtonPressed())
    {
        wait level.frametime;
        firetime = (firetime + level.frametime);
    }
    if(firetime <= recordtime) 
    {
        self.inputStream[self.inputStream.size] = "fire";
    }
	//mark as no using
	self.wasFiring = false;
}

addHoldFire(msg, dir, delayTime, waitTime, conditionCallback, successCallback, failCallback, drawProgressBar, lockInPlace, disableWeapon, trigger, audioCue)
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
	
	if(dir) //false pushes hold fire to top of stack, true to the bottom
		self.holdFire = maps\mp\uox\_uox_arrays::arrayPush(self.holdFire, hold, msg);
	else
		self.holdFire = maps\mp\uox\_uox_arrays::arrayUnshift(self.holdFire, hold, msg);
	maps\mp\uox\_uox_debug::debugLog("info", "HoldFire register: msg=" + msg + " new size=" + self.holdFire["length"], "self.holdFire", self.holdFire);
}

removeHoldFire(msg)
{
	self.holdFire = maps\mp\uox\_uox_arrays::arraySlice(self.holdFire, msg);
	maps\mp\uox\_uox_debug::debugLog("info", "HoldFire deregister: msg=" + msg + " new size=" + self.holdFire["length"], "self.holdFire", self.holdFire);
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
    
    maps\mp\uox\_uox_debug::debugLog("info", self.name + " did input combo: " + combo_str);

    callback = maps\mp\uox\_uox_arrays::getValue(self.inputCombos, "combo_str");

    if(isDefined(callback))
        thread [[callback]]();
}

addInputCombination(combo, callback, callbackName)
{
    if(!isDefined(callbackName))
        callbackName = combo;

    //check if valid combo
    split = maps\mp\uox\_uox_utils::stringSplit(combo, " ");
    for(i = 0; i < split.size; i++)
    {
        input = split[i];
        switch(input)
        {
            case "use":
            case "melee":
            case "fire":
            case "meleeuse":
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
