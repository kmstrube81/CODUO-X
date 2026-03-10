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
	game["dividerText"] = &"/";
	precacheString(game["dividerText"]);
	game["waitingText"] = &"Ready-Up Mode";
	precacheString(game["waitingText"]);
	game["warmupText"] = &"Warm-Up Mode";
	precacheString(game["warmupText"]);
	game["allreadyText"] = &"All Players Ready!";
	precacheString(game["allreadyText"]);
	game["2ndHalfStartingText"] = &"Second Half Starting";
	precacheString(game["2ndHalfStartingText"]);
	game["readyText"] = &"Ready";
	precacheString(game["readyText"]);
	game["notReadyText"] = &"Not Ready";
	precacheString(game["notReadyText"]);
	game["statusText"] = &"Your Status";
	precacheString(game["statusText"]);
	game["waitingOnText"] = &"Waiting on";
	precacheString(game["waitingOnText"]);
	game["playersText"] = &"Players";
	precacheString(game["playersText"]);
	
	game["objective_default"] = "gfx/hud/headicon@re_objcarrier.dds";
	precacheShader(game["objective_default"]);
	switch(game["allies"])
	{
		case "american":
			game["headicon_allies"] = "gfx/hud/headicon@american.tga";
			break;
		case "british":
			game["headicon_allies"] = "gfx/hud/headicon@british.tga";
			break;
		case "russian":
			game["headicon_allies"] = "gfx/hud/headicon@russian.tga";
			break;
	}
	game["headicon_axis"] = "gfx/hud/headicon@german.tga";
	precacheShader(game["headicon_allies"]);
	precacheShader(game["headicon_axis"]);
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
		if(isDefined(options["width"]))
			width = options["width"];
		else
			width = 16;
		if(isDefined(options["height"]))
			height = options["height"];
		else
			height = 16;
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
		case "shader":
			element setShader(value, width, height);
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

updateServerScoreboard()
{
	level.scoreboard = true;
	//Allies Shader
	options = [];
	
	options["x"] = 10;
	options["y"] = 250;
	options["alignX"] = "left";
	options["alignY"] = "middle";
	options["width"] = 24;
	options["height"] = 24;
	options["fontScale"] = 1.6;
	
	if(level.uox_teamplay)
		shader = game["headicon_allies"];
	else 
		shader = game["objective_default"];
	level.scoreboardAlliesShader = updateHUDElement(level.scoreboardAlliesShader, "shader", shader, options);
	
	//Allies Score
	options["x"] = 58;
	options["alignX"] = "right";
	
	if(level.uox_teamplay)
		value = game["alliedscore"];
	else
	{
		if(level.scorerounds)
		{
			highscore = maps\mp\uox\_uox::getHighScore();
			if(isDefined(highscore))
				value = highscore.roundsWon;
			else
				value = 0;
		}
		else
		{
			highscore = maps\mp\uox\_uox::getHighScore();
			if(isDefined(highscore))
				value = highscore.score;
			else
				value = 0;
		}
	}
	level.scoreboardAlliesScore = updateHUDElement(level.scoreboardAlliesScore, "number", value, options);
	
	if(getCvarInt("sv_showScoreboardScoreLimit") > 0 && ((!level.scorerounds && level.scorelimit > 0) || (level.scorerounds && level.roundlimit > 0 )))
	{
		level.scoreboardScoreLimit = true;
	}
	
	if(isDefined(level.scoreboardScoreLimit) && level.scoreboardScoreLimit)
	{
		//Allies Divider
		options["x"] = 62;
		options["alignX"] = "center";
		level.scoreboardAlliesLimitDiv = updateHUDElement(level.scoreboardAlliesLimitDiv, "text", game["dividerText"], options);
		
		//Allies Limit
		options["x"] = 66;
		options["alignX"] = "left";
		if(level.scorerounds)
			value = (level.roundlimit/2) + 1;
		else
			value = level.scorelimit;
		level.scoreboardAlliesLimit = updateHUDElement(level.scoreboardAlliesLimit, "number", value, options);
	}
	
	if(level.uox_teamplay)
	{
		options["x"] = 10;
		options["y"] = 270;
		options["alignX"] = "left";
		options["alignY"] = "middle";
		
		
		shader = game["headicon_axis"];
		
		level.scoreboardAxisShader = updateHUDElement(level.scoreboardAxisShader, "shader", shader, options);
		
		//Axis Score
		options["x"] = 58;
		options["alignX"] = "right";
		
		value = game["axisscore"];
		
		level.scoreboardAxisScore = updateHUDElement(level.scoreboardAxisScore, "number", value, options);
		
		if(isDefined(level.scoreboardScoreLimit) && level.scoreboardScoreLimit)
		{
			//Axis Divider
			options["x"] = 62;
			options["alignX"] = "center";
			level.scoreboardAxisLimitDiv = updateHUDElement(level.scoreboardAxisLimitDiv, "text", game["dividerText"], options);
			
			//Axis Limit
			options["x"] = 66;
			options["alignX"] = "left";
			if(level.scorerounds)
				value = (level.roundlimit / 2) + 1;
			else
				value = level.scorelimit;
			level.scoreboardAxisLimit = updateHUDElement(level.scoreboardAxisLimit, "number", value, options);
		}
	}
	else
		updatePlayerScoreboard();
}

deleteServerScoreboard()
{
	level.scoreboardAlliesShader = deleteHUDElement(level.scoreboardAlliesShader);
	level.scoreboardAlliesScore = deleteHUDElement(level.scoreboardAlliesScore);
	if(level.uox_teamplay)
	{
		level.scoreboardAxisShader = deleteHUDElement(level.scoreboardAxisShader);
		level.scoreboardAxisScore = deleteHUDElement(level.scoreboardAxisScore);
	}
	else
	{
		deletePlayerScoreboard();
	}
	
	deleteServerScoreboardScoreLimit();
	
	level.scoreboard = undefined;
}

deleteServerScoreboardScoreLimit()
{
	level.scoreboardAlliesLimitDiv = deleteHUDElement(level.scoreboardAlliesLimitDiv);
	level.scoreboardAlliesLimit = deleteHUDElement(level.scoreboardAlliesLimit);
	
	if(level.uox_teamplay)
	{
		level.scoreboardAxisLimitDiv = deleteHUDElement(level.scoreboardAxisLimitDiv);
		level.scoreboardAxisLimit = deleteHUDElement(level.scoreboardAxisLimit);
	}
	else
	{
		deletePlayerScoreboardScoreLimit();
	}
	
	level.scoreboardScoreLimit = undefined;
}

updatePlayerScoreboard()
{
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		
		if(!isDefined(player.pers["team"]) || (isDefined(player.pers["team"]) && player.pers["team"] == "spectator"))
			continue;
		
		//Shader
		options["x"] = 10;
		options["y"] = 270;
		options["alignX"] = "left";
		options["alignY"] = "middle";
		options["width"] = 24;
		options["height"] = 24;
		options["fontScale"] = 1.6;
		
		if(player.pers["team"] == "allies")
			shader = game["headicon_allies"];
		else
			shader = game["headicon_axis"];
		
		if(!isDefined(player.scoreboardShader))
			player.scoreboardShader = newClientHudElem(player);
		player.scoreboardShader.x = options["x"];
		player.scoreboardShader.y = options["y"];
		player.scoreboardShader.alignX = options["alignX"];
		player.scoreboardShader.alignY = options["alignY"];
		player.scoreboardShader.fontScale = options["fontScale"];
		player.scoreboardShader setShader(shader, options["width"], options["height"]);
		
		//Axis Score
		options["x"] = 58;
		options["alignX"] = "right";
		
		if(level.scorerounds)
			value = player.pers["roundswon"];
		else
			value = player.score;
		
		if(!isDefined(player.scoreboardScore))
			player.scoreboardScore = newClientHudElem(player);
		player.scoreboardScore.x = options["x"];
		player.scoreboardScore.y = options["y"];
		player.scoreboardScore.alignX = options["alignX"];
		player.scoreboardScore.alignY = options["alignY"];
		player.scoreboardScore.fontScale = options["fontScale"];
		player.scoreboardScore setValue(value);
		
		if(isDefined(level.scoreboardScoreLimit) && level.scoreboardScoreLimit)
		{
			//Divider
			options["x"] = 62;
			options["alignX"] = "center";
			if(!isDefined(player.scoreboardDiv))
				player.scoreboardDiv = newClientHudElem(player);
			player.scoreboardDiv.x = options["x"];
			player.scoreboardDiv.y = options["y"];
			player.scoreboardDiv.alignX = options["alignX"];
			player.scoreboardDiv.alignY = options["alignY"];
			player.scoreboardDiv.fontScale = options["fontScale"];
			player.scoreboardDiv setText(game["dividerText"]);
			
			//Axis Limit
			options["x"] = 66;
			options["alignX"] = "left";
			if(level.scorerounds)
				value = (level.roundlimit / 2) + 1;
			else
				value = level.scorelimit;
			
			if(!isDefined(player.scoreboardLimit))
				player.scoreboardLimit = newClientHudElem(player);
			player.scoreboardLimit.x = options["x"];
			player.scoreboardLimit.y = options["y"];
			player.scoreboardLimit.alignX = options["alignX"];
			player.scoreboardLimit.alignY = options["alignY"];
			player.scoreboardLimit.fontScale = options["fontScale"];
			player.scoreboardLimit setValue(value);
		}
				
	}
}

deletePlayerScoreboard()
{
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		
		player.scoreboardShader = deleteHUDElement(player.scoreboardShader);
		player.scoreboardScore = deleteHUDElement(player.scoreboardScore);
	}
}

deletePlayerScoreboardScoreLimit()
{
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		
		player.scoreboardLimit = deleteHUDElement(player.scoreboardLimit);
		player.scoreboardDiv = deleteHUDElement(player.scoreboardDiv);
	}
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
		if(isDefined(options["width"]))
			width = options["width"];
		else
			width = 16;
		if(isDefined(options["height"]))
			height = options["height"];
		else
			height = 16;
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
		case "shader":
			element setShader(value, width, height);
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

createReadyUpHUD()
{
	if(!isDefined(level.waitingHUD))
		level.waitingHUD = newHudElem();
	level.waitingHUD.alignX = "center";
	level.waitingHUD.alignY = "middle";
	level.waitingHUD.color = (1, 0, 0);
	level.waitingHUD.x = 575;
	level.waitingHUD.y = 45;
	level.waitingHUD.fontScale = 1.4;

	level.waitingHUD setText(game["waitingText"]);
	
	if(!isDefined(level.waitingOnHUD))
		level.waitingOnHUD = newHudElem();
	level.waitingOnHUD.x = 575;
	level.waitingOnHUD.y = 70;
	level.waitingOnHUD.alignX = "center";
	level.waitingOnHUD.alignY = "middle";
	level.waitingOnHUD.fontScale = 1.1;
	level.waitingOnHUD.color = (.8, 1, 1);
	level.waitingOnHUD setText(game["waitingOnText"]);

	if(!isDefined(level.playersTextHUD))
		level.playersTextHUD = newHudElem();
	level.playersTextHUD.x = 575;
	level.playersTextHUD.y = 110;
	level.playersTextHUD.alignX = "center";
	level.playersTextHUD.alignY = "middle";
	level.playersTextHUD.fontScale = 1.1;
	level.playersTextHUD.color = (.8, 1, 1);
	level.playersTextHUD setText(game["playersText"]);

	if(!isDefined(level.notReadyHUD))
		level.notReadyHUD = newHudElem();
	level.notReadyHUD.x = 575;
	level.notReadyHUD.y = 90;
	level.notReadyHUD.alignX = "center";
	level.notReadyHUD.alignY = "middle";
	level.notReadyHUD.fontScale = 1.2;
	level.notReadyHUD.color = (.98, .98, .60);
	
	level.notReadyHUD setValue(0);
}

createPlayerReadyUpHUD()
{
	self iprintlnbold("^7Hit the ^3-Use- ^7key to Ready-Up");
	
	if(!isDefined(self.waitingHUD))
		self.waitingHUD = newClientHudElem(self);
	self.waitingHUD.alignX = "center";
	self.waitingHUD.alignY = "middle";
	self.waitingHUD.color = (1, 0, 0);
	self.waitingHUD.x = 320;
	self.waitingHUD.y = 265;
	self.waitingHUD.fontScale = 2;

	self.waitingHUD setText(game["waitingText"]);
	
	if(!isDefined(self.readyStatusHUD))
		self.readyStatusHUD = newClientHudElem(self);
	self.readyStatusHUD.x = 575;
	self.readyStatusHUD.y = 170;
	self.readyStatusHUD.alignX = "center";
	self.readyStatusHUD.alignY = "middle";
	self.readyStatusHUD.fontScale = 1.1;
	self.readyStatusHUD.color = (.8, 1, 1);
	self.readyStatusHUD setText(game["statusText"]);

	if(!isDefined(self.readyHUD))
		self.readyHUD = newClientHudElem(self);
	self.readyHUD.x = 575;
	self.readyHUD.y = 190;
	self.readyHUD.alignX = "center";
	self.readyHUD.alignY = "middle";
	self.readyHUD.fontScale = 1.2;
	self.readyHUD.color = (1, .66, .66);
	self.readyHUD setText(game["notReadyText"]);
	
	wait 8;
	
	self.waitingHUD = deleteHUDElement(self.waitingHUD);
}

deleteReadyUpHUD()
{
	
	level.waitingHUD = deleteHUDElement(level.waitingHUD);
	level.waitingOnHUD = deleteHUDElement(level.waitingOnHUD);
	level.playersTextHUD = deleteHUDElement(level.playersTextHUD);
	level.notReadyHUD = deleteHUDElement(level.notReadyHUD);
	
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		
		player deletePlayerReadyUpHUD();
		
	}
	
}

deletePlayerReadyUpHUD()
{
	self.readyStatusHUD = deleteHUDElement(self.readyStatusHUD);
	self.readyHUD = deleteHUDElement(self.readyHUD);
}

createWarmUpHUD(playercount, timer)
{
	
	if(!isDefined(level.waitingHUD))
		level.waitingHUD = newHudElem();
	level.waitingHUD.alignX = "center";
	level.waitingHUD.alignY = "middle";
	level.waitingHUD.color = (1, 0, 0);
	level.waitingHUD.x = 575;
	level.waitingHUD.y = 45;
	level.waitingHUD.fontScale = 1.4;

	level.waitingHUD setText(game["warmupText"]);
	
	if(playercount > 0)
	{
		if(!isDefined(level.waitingOnHUD))
			level.waitingOnHUD = newHudElem();
		level.waitingOnHUD.x = 575;
		level.waitingOnHUD.y = 70;
		level.waitingOnHUD.alignX = "center";
		level.waitingOnHUD.alignY = "middle";
		level.waitingOnHUD.fontScale = 1.1;
		level.waitingOnHUD.color = (.8, 1, 1);
		level.waitingOnHUD setText(game["waitingOnText"]);

		if(!isDefined(level.playersTextHUD))
			level.playersTextHUD = newHudElem();
		level.playersTextHUD.x = 575;
		level.playersTextHUD.y = 110;
		level.playersTextHUD.alignX = "center";
		level.playersTextHUD.alignY = "middle";
		level.playersTextHUD.fontScale = 1.1;
		level.playersTextHUD.color = (.8, 1, 1);
		level.playersTextHUD setText(game["playersText"]);

		if(!isDefined(level.notReadyHUD))
			level.notReadyHUD = newHudElem();
		level.notReadyHUD.x = 573;
		level.notReadyHUD.y = 90;
		level.notReadyHUD.alignX = "right";
		level.notReadyHUD.alignY = "middle";
		level.notReadyHUD.fontScale = 1.2;
		level.notReadyHUD.color = (.98, .98, .60);
		
		level.notReadyHUD setValue(0);
		
		if(!isDefined(level.notReadyDivHUD))
			level.notReadyDivHUD = newHudElem();
		level.notReadyDivHUD.x = 575;
		level.notReadyDivHUD.y = 90;
		level.notReadyDivHUD.alignX = "center";
		level.notReadyDivHUD.alignY = "middle";
		level.notReadyDivHUD.fontScale = 1.2;
		level.notReadyDivHUD.color = (.98, .98, .60);
		
		level.notReadyDivHUD setText(game["dividerText"]);
		
		if(!isDefined(level.allReadyHUD))
			level.allReadyHUD = newHudElem();
		level.allReadyHUD.x = 577;
		level.allReadyHUD.y = 90;
		level.allReadyHUD.alignX = "left";
		level.allReadyHUD.alignY = "middle";
		level.allReadyHUD.fontScale = 1.2;
		level.allReadyHUD.color = (.98, .98, .60);
		
		level.allReadyHUD setValue(playercount);
	}
}

createPlayerWarmUpHUD()
{
	
	if(!isDefined(self.waitingHUD))
		self.waitingHUD = newClientHudElem(self);
	self.waitingHUD.alignX = "center";
	self.waitingHUD.alignY = "middle";
	self.waitingHUD.color = (1, 0, 0);
	self.waitingHUD.x = 320;
	self.waitingHUD.y = 265;
	self.waitingHUD.fontScale = 2;

	self.waitingHUD setText(game["warmupText"]);
	
	wait 8;
	
	self.waitingHUD = deleteHUDElement(self.waitingHUD);
}

deleteWarmupHUD()
{
	level.waitingHUD = deleteHUDElement(level.waitingHUD);
	level.waitingOnHUD = deleteHUDElement(level.waitingOnHUD);
	level.playersTextHUD = deleteHUDElement(level.playersTextHUD);
	level.notReadyHUD = deleteHUDElement(level.notReadyHUD);
	level.notReadyDivHUD = deleteHUDElement(level.notReadyDivHUD);
	level.allReadyHUD = deleteHUDElement(level.allReadyHUD);
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
//------------------------------------------------------------------------------------

updateScoreboard()
{
	level endon("intermission");
	for(;;)
	{
		
		if(getCvarInt("sv_showScoreboard") > 0)
			updateServerScoreboard();
		else if(isDefined(level.scoreboard))
			deleteServerScoreboard();
		
		if(isDefined(level.scoreboardScoreLimit) && (getCvarInt("sv_showScoreboardScoreLimit") == 0 || ((!level.scorerounds && level.scorelimit <= 0) || (level.scorerounds && level.roundlimit <= 0 ))))
			deleteServerScoreboardScoreLimit();
		
		wait 0.25;
	}
}