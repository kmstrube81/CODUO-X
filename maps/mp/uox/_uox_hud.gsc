precache()
{
	game["roundText"] = &"Round";
	precacheString(game["roundText"]);
	game["startingText"] = &"Starting";
	precacheString(game["startingText"]);
	game["respawnText"] = &"MPSCRIPT_PRESS_ACTIVATE_TO_RESPAWN";
	precacheString(game["respawnText"]);
	game["killcamText"] = &"MPSCRIPT_KILLCAM";
	precacheString(game["killcamText"]);
	game["alliesWinText"] = &"MPSCRIPT_ALLIES_WIN";
	precacheString(game["alliesWinText"]);
	game["axisWinText"] = &"MPSCRIPT_AXIS_WIN";
	precacheString(game["axisWinText"]);
	game["ceasefireText"] = &"GMI_MP_CEASEFIRE";
	precacheString(game["ceasefireText"]);
	game["timeExpiredText"] = &"GMI_CTF_TIMEEXPIRED";
	precacheString(game["timeExpiredText"]);
	game["matchStartingText"] = &"SD_MATCHSTARTING";
	precacheString(game["matchStartingText"]);
	game["matchResumingText"] = &"SD_MATCHRESUMING";
	precacheString(game["matchResumingText"]);
	game["roundDrawText"] = &"SD_ROUNDDRAW";
	precacheString(game["roundDrawText"]);
	game["alliesEliminatedText"] = &"SD_ALLIESHAVEBEENELIMINATED";
	precacheString(game["alliesEliminatedText"]);
	game["axisEliminatedText"] = &"SD_AXISHAVEBEENELIMINATED";
	precacheString(game["axisEliminatedText"]);
	game["alliesSuccessText"] = &"SD_ALLIEDMISSIONACCOMPLISHED";
	precacheString(game["alliesSuccessText"]);
	game["axisSuccessText"] = &"SD_AXISMISSIONACCOMPLISHED";
	precacheString(game["axisSuccessText"]);
	game["livesText"] = &"Lives Left";
	precacheString(game["livesText"]);
}

initHUD()
{
	self.hud = [];
}

getClientHUDElement(name)
{
	for(i = 0; i < self.hud.size; i++)
	{
		hudElement = self.hud[i];
		if(name == hudElement["name"])
			return hudElement["element"];
	}
	return undefined;
}

updateClientHUDElement(name, type, value, options)
{
	element = getClientHUDElement(name);
	
	if(!isDefined(element))
		element = createClientHUDElement(name)["element"];
	
	//process options
	if(isDefined(options))
	{
		if(isDefined(options["x"]))
			element.x = options["x"];
		if(isDefined(options["y"]))
			element.y = options["y"];
		if(isDefined(options["alignX"]))
			element.alignX = options["alignX"];
		if(isDefined(options["alignY"]))
			element.alignY = options["alignY"];
		if(isDefined(options["font"]))
			element.font = options["font"];
		if(isDefined(options["color"]))
			element.color = options["color"];
		if(isDefined(options["fontscale"]))
			element.fontscale = options["fontscale"];
		if(isDefined(options["alpha"]))
			element.alpha = options["alpha"];
	}
	
	//set value
	switch(type)
	{
		case "timer":
			element setTimer(value);
			break;
		case "number":
			element setValue(value);
			break;
		default:
			element setText(value);
	}
	
	return element;
}

createClientHUDElement(name)
{
	element = [];
	element["name"] = name;
	element["element"] = newClientHudElem(self);
	
	self.hud[self.hud.size] = element;
	
	return self.hud[self.hud.size - 1];
}

deleteClientHUDElement(name)
{
	temparr = [];
	
	for(i = 0; i < self.hud.size; i++)
	{
		hudElement = self.hud[i];
		if(name != hudElement["name"])
			temparr[temparr.size] = hudElement;
		else
		{
			hudElement["element"] destroy();
			hudElement = undefined;
		}
	}
	self.hud = temparr;
}

clearClientHUD()
{
	for(i = 0; i < self.hud.size; i++)
	{
		hudElement = self.hud[i];
		hudElement["element"] destroy();
		hudElement = undefined;
	}
	initHUD();
}

updateHUDMainClock(timer)
{
	options = [];
	/* 	X
		Y
		AlignX
		AlignY
		Font
		Color
		Size
		Alpha
	*/
	options["x"] = 320;
	options["y"] = 460;
	options["alignX"] = "center";
	options["alignY"] = "middle";
	options["font"] = "bigfixed";
	options["color"] = (1, 1, 1 );
	level.mainclock = updateHUDElement(level.mainclock, "timer", timer, options);
}

updateHUDCompassClock(timer)
{
	options = [];
	/* 	X
		Y
		AlignX
		AlignY
		Font
		Color
		Size
		Alpha
	*/
	options["x"] = 56;
	options["y"] = 365;
	options["alignX"] = "center";
	options["alignY"] = "middle";
	options["font"] = "bigfixed";
	options["alpha"] = 0.6;
	options["color"] = (1, 1, 1 );
	level.compassclock = updateHUDElement(level.compassclock, "timer", timer, options);
}

updateHUDMainClockColor(color)
{
	level.mainclock = updateHUDElementProperty(level.mainclock, "color", color);
}

deleteHUDMainClock()
{
	level.mainclock = deleteHUDElement(level.mainclock);
}

updateHUDLivesLeft(lives)
{
	options = [];
	/* 	X
		Y
		AlignX
		AlignY
		Font
		Color
		Size
		Alpha
	*/
	options["x"] = 620;
	options["y"] = 420;
	options["alignX"] = "right";
	options["alignY"] = "middle";
	options["fontscale"] = 0.8;
	
	updateClientHUDElement("livesText", "text", game["livesText"], options);
	options["x"] = 622;
	options["alignX"] = "left";
	updateClientHUDElement("livesCounter", "number", lives, options);
	
}

deleteHUDLivesLeft()
{
	deleteClientHUDElement("livesText");
	deleteClientHUDElement("livesCounter");
}

updateHUDElementProperty(element, property, value)
{
	if(!isDefined(element))
	{
		return;
	}
	
	switch(property)
	{
		case "x":
			element.x = value;
			break;
		case "y":
			element.y = value;
			break;
		case "alignX":
			element.alignX = value;
			break;
		case "alignY":
			element.alignY = value;
			break;
		case "font":
			element.font = value;
			break;
		case "fontscale":
			element.fontscale = value;
			break;
		case "alpha":
			element.alpha = value;
			break;
		case "color":
			element.color = value;
			break;
	}
	return element;
}

updateHUDElement(element, type, value, options)
{
	//create element if it doesn't exist
	if(!isDefined(element))
	{
		element = newHudElem();
	}
	
	//process options
	if(isDefined(options))
	{
		if(isDefined(options["x"]))
			element.x = options["x"];
		if(isDefined(options["y"]))
			element.y = options["y"];
		if(isDefined(options["alignX"]))
			element.alignX = options["alignX"];
		if(isDefined(options["alignY"]))
			element.alignY = options["alignY"];
		if(isDefined(options["font"]))
			element.font = options["font"];
		if(isDefined(options["color"]))
			element.color = options["color"];
		if(isDefined(options["fontscale"]))
			element.fontscale = options["fontscale"];
		if(isDefined(options["alpha"]))
			element.alpha = options["alpha"];
	}
	
	//set value
	switch(type)
	{
		case "timer":
			element setTimer(value);
			break;
		case "number":
			element setValue(value);
			break;
		default:
			element setText(value);
	}
	
	return element;
}

deleteHUDElement(element)
{
	if(isDefined(element))
		element destroy();
		
	element = undefined;
	
	return element;
}

createHUDNextRound(time)
{
	if ( time < 3 )
		time = 3;

	level.round = newHudElem();
	level.round.x = 540;
	level.round.y = 360;
	level.round.alignX = "center";
	level.round.alignY = "middle";
	level.round.fontScale = 1;
	level.round.color = (1, 1, 0);
	level.round setText(game["roundText"]);		
		
	level.roundnum = newHudElem();
	level.roundnum.x = 540;
	level.roundnum.y = 380;
	level.roundnum.alignX = "center";
	level.roundnum.alignY = "middle";
	level.roundnum.fontScale = 1;
	level.roundnum.color = (1, 1, 0);
	round = game["roundsplayed"] +1;
	level.roundnum setValue(round);

	level.starting = newHudElem();
	level.starting.x = 540;
	level.starting.y = 400;
	level.starting.alignX = "center";
	level.starting.alignY = "middle";
	level.starting.fontScale = 1;
	level.starting.color = (1, 1, 0);
	level.starting setText(game["startingText"]);

	// Give all players a count-down stopwatch
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		
		if ( isDefined(player.pers["team"]) && player.pers["team"] == "spectator")
			continue;
			
		player thread stopwatch_start("match_start", time);
	}
	
	wait (time);

	if(isdefined(level.round))
		level.round destroy();
	if(isdefined(level.roundnum))
		level.roundnum destroy();
	if(isdefined(level.starting))
		level.starting destroy();
}

// ----------------------------------------------------------------------------------
//	clock_start
//
// 	 	starts the hud clock for the player if the reason is good enough
// ----------------------------------------------------------------------------------
stopwatch_start(reason, time)
{
	make_clock = false;

	// if we are not waiting for a match start or another match start comes in go ahead and make a new one
	if ( !isDefined( self.stopwatch_reason ) || reason == "match_start" )
	{
		make_clock = true;
	}
	
	if ( make_clock )
	{
		if(isDefined(self.stopwatch))
		{
			thread stopwatch_delete("do_it");
		}
		
		self.stopwatch = newClientHudElem(self);
		maps\mp\_util_mp_gmi::InitClock(self.stopwatch, time);
		self.stopwatch.archived = false;
		
		self.stopwatch_reason = reason;
		
		self thread stopwatch_cleanup(reason, time);
		
		// if this is a match start
		if ( reason == "match_start" )
		{
			self thread stopwatch_waittill_killrestart(reason);
		}
	}
}

// ----------------------------------------------------------------------------------
//	stopwatch_delete
//
// 	 	destroys the hud stopwatch for the player if the reason is good enough
// ----------------------------------------------------------------------------------
stopwatch_delete(reason)
{
	self endon("stop stopwatch cleanup");

	if(!isDefined(self.stopwatch))
		return;
	
	delete_it = false;
	
	if (reason == "spectator" || reason == "do_it" || reason == self.stopwatch_reason)
	{
		self.stopwatch_reason = undefined;
		self.stopwatch destroy();
		self notify("stop stopwatch cleanup");
	}
}

// ----------------------------------------------------------------------------------
//	stopwatch_cleanup_respawn
//
// 	 	should only be called by stopwatch_start
// ----------------------------------------------------------------------------------
stopwatch_cleanup(reason, time)
{
	self endon("stop stopwatch cleanup");
	wait (time);

	stopwatch_delete(reason);
}

// ----------------------------------------------------------------------------------
//	stopwatch_cleanup_respawn
//
// 	 	should only be called by stopwatch_start
// ----------------------------------------------------------------------------------
stopwatch_waittill_killrestart(reason)
{
	self endon("stop stopwatch cleanup");
	level waittill("kill_startround");

	stopwatch_delete(reason);
}