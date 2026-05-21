precache()
{
	game["roundText"] = &"Round";
	precacheString(game["roundText"]);
	game["OTroundText"] = &"OT Round";
	precacheString(game["OTroundText"]);
	game["startingText"] = &"Starting";
	precacheString(game["startingText"]);
	game["resumingText"] = &"Resuming";
	precacheString(game["resumingText"]);
	game["respawnText"] = &"MPSCRIPT_PRESS_ACTIVATE_TO_RESPAWN";
	precacheString(game["respawnText"]);
	game["killcamText"] = &"MPSCRIPT_KILLCAM";
	precacheString(game["killcamText"]);
	game["finalKillcamText"] = &"FINAL KILLCAM";
	precacheString(game["finalKillcamText"]);
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
	game["bombPlantedText"] = &"SD_EXPLOSIVESPLANTED";
	precacheString(game["bombPlantedText"]);
	game["bombDefusedText"] = &"SD_EXPLOSIVESDEFUSED";
	precacheString(game["bombDefusedText"]);
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
	game["1stHalfStartingText"] = &"1st Half Starting";
	precacheString(game["1stHalfStartingText"]);
	game["2ndHalfStartingText"] = &"2nd Half Starting";
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
	game["scoreboardText"] = &"Scoreboard";
	precacheString(game["scoreboardText"]);
	game["team1Text"] = &"TEAM 1";
	precacheString(game["team1Text"]);
	game["team2Text"] = &"TEAM 2";
	precacheString(game["team2Text"]);
	game["team1WinText"] = &"Team 1 Wins!";
	precacheString(game["team1WinText"]);
	game["team2WinText"] = &"Team 2 Wins!";
	precacheString(game["team2WinText"]);
	game["tieText"] = &"Its a TIE!";
	precacheString(game["tieText"]);
	game["matchoverText"] = &"Match Over";
	precacheString(game["matchoverText"]);
	game["overtimeText"] = &"Going to Overtime";
	precacheString(game["overtimeText"]);
	game["overtimemodeText"] = &"Overtime";
	precacheString(game["overtimemodeText"]);
	game["halftimeText"] = &"Halftime";
	precacheString(game["halftimeText"]);
	game["switchingText"] = &"Switching Sides";
	precacheString(game["switchingText"]);	
	game["switchWaitText"] = &"Please wait";
	precacheString(game["switchWaitText"]);
	game["axisScoreText"] = &"AXIS SCORE";
	precacheString(game["axisScoreText"]);		
	game["alliesScoreText"] = &"ALLIES SCORE";
	precacheString(game["alliesScoreText"]);
	game["leaderText"] = &"LEADER";
	precacheString(game["leaderText"]);
	game["youText"] = &"YOU";
	precacheString(game["youText"]);
	game["1HText"] = &"1st Half";
	precacheString(game["1HText"]);	
	game["2HText"] = &"2nd Half";
	precacheString(game["2HText"]);
	game["OT1HText"] = &"OT 1H";
	precacheString(game["OT1HText"]);	
	game["OT2HText"] = &"OT 2H";
	precacheString(game["OT2HText"]);
	game["matchText"] = &"Match";
	precacheString(game["matchText"]);	
	game["1HScoresText"] = &"1st Half Scores:";
	precacheString(game["1HScoresText"]);	
	game["2HScoresText"] = &"2nd Half Scores:";
	precacheString(game["2HScoresText"]);	
	game["matchScoreText"] = &"Match Scores:";
	precacheString(game["matchScoreText"]);	
	
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
	precacheShader("black");
	precacheShader("white");
}

initClientHUD()
{
	self.hud = [];
}

initServerHUD()
{
	level.scoreboardKillsRounds = false; //false = kills, true = rounds
	
	if( [[level.getVars]]("scr_score_rounds") && [[level.getVars]]("scr_roundlimit") != 1 )
		level.scoreboardKillsRounds = true;
}

/* ****************************************************************************************************
**** getClientHUDElement( string name)
****
**** gets element from clientHudArray with specified name value
****
**** returns matched HUD element if one exists or undefined if no matches are found
****
***************************************************************************************************** */
getClientHUDElement(name)
{
	//find element
	index = maps\mp\uox\_uox_arrays::searchObjArrayByProperty(self.hud, "name", name);
	//if element exists
	if(isDefined(index))
		return self.hud[index]["element"]; //return element
	
	return undefined; //otherwise return undefined
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
		if(isDefined(options["archived"]))
			element.archived = options["archived"];
		if(isDefined(options["sort"]))
			element.sort = options["sort"];
	}
	
	//set value
	switch(type)
	{
		case "timer":
			element setTimer(value);
			break;
		case "tenthsTimer":
			element setTenthsTimer(value);
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

animateClientHUDElement(name, type, options)
{
	//get hud element
	element = getClientHUDElement(name);
	
	if(!isDefined(element)) //nothing to animate if no hudelement exists
		return;
	
	//process options
	if(isDefined(options))
	{
		if(isDefined(options["x"]))
			x = options["x"];
		if(isDefined(options["y"]))
			y = options["y"];
		if(isDefined(options["time"]))
			time = options["time"];
		else time = 0;
		if(isDefined(options["color"]))
			color = options["color"];
		if(isDefined(options["fontscale"]))
			fontscale = options["fontscale"];
		if(isDefined(options["alpha"]))
			alpha = options["alpha"];
		if(isDefined(options["width"]))
			width = options["width"];
		else width = 16;
		if(isDefined(options["height"]))
			height = options["height"];
		else height = 16;
	}
	
	if(time <= 0) //if no timer, nothing to animate
		return;
		
	//do animation
	switch(type)
	{
		case "scaleShader":
			element scaleOverTime(time, width, height);
			break;
	}
}

clearClientHUD()
{
	for(i = 0; i < self.hud.size; i++)
	{
		hudElement = self.hud[i];
		hudElement["element"] destroy();
		hudElement = undefined;
	}
	initClientHUD();
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
		case "sort":
			element.sort = value;
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

animateHUDElement(element, type, options)
{
	if(!isDefined(element)) //nothing to animate if no hudelement exists
		return;
	
	//process options
	if(isDefined(options))
	{
		if(isDefined(options["x"]))
			x = options["x"];
		if(isDefined(options["y"]))
			y = options["y"];
		if(isDefined(options["time"]))
			time = options["time"];
		else time = 0;
		if(isDefined(options["color"]))
			color = options["color"];
		if(isDefined(options["fontscale"]))
			fontscale = options["fontscale"];
		if(isDefined(options["alpha"]))
			alpha = options["alpha"];
		if(isDefined(options["width"]))
			width = options["width"];
		else width = 16;
		if(isDefined(options["height"]))
			height = options["height"];
		else height = 16;
	}
	
	if(time <= 0) //if no timer, nothing to animate
		return;
		
	//do animation
	switch(type)
	{
		case "scaleShader":
			element scaleOverTime(time, width, height);
			break;
	}
}

/* ****************************************************************************************************
**** updateHUDMainClock( int timer )
****
**** creates HUD clock in bottom center of screen
****
***************************************************************************************************** */
updateHUDMainClock(timer)
{
	//UI Element Options array
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
	options["x"] = 320; //center of screen x
	options["y"] = 460; //20 px above bottom of screen y
	options["alignX"] = "center"; //align text horizontally
	options["alignY"] = "middle"; //align text vertically
	options["font"] = "bigfixed"; //font option
	options["color"] = (1, 1, 1 ); // white
	if(timer > 0) //if timer
		level.mainclock = updateHUDElement(level.mainclock, "timer", timer, options); //update hud elem
}

/* ****************************************************************************************************
**** updateHUDCompassClock( int timer )
****
**** creates HUD clock above compass
****
***************************************************************************************************** */
updateHUDCompassClock(timer)
{
	//UI Element Options array
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
	options["x"] = 56; //56 pixels from left side of screen x
	options["y"] = 365; //just above compass y
	options["alignX"] = "center"; //align text horizontally
	options["alignY"] = "middle"; //align text vertically
	options["font"] = "bigfixed"; //font option
	options["alpha"] = 0.6; //make text slightly transparent
	options["color"] = (1, 1, 1 ); //white
	if(timer > 0) //if timer
		level.compassclock = updateHUDElement(level.compassclock, "timer", timer, options); //create elem
}

/* ****************************************************************************************************
**** updateHUDMainClockColor( vector color )
****
**** changes color of the main clock
****
***************************************************************************************************** */
updateHUDMainClockColor(color)
{
	level.mainclock = updateHUDElementProperty(level.mainclock, "color", color);
}

/* ****************************************************************************************************
**** deleteHUDMainClock()
****
**** deletes the main clock
****
***************************************************************************************************** */
deleteHUDMainClock()
{
	level.mainclock = deleteHUDElement(level.mainclock);
}

/* ****************************************************************************************************
**** deleteHUDCompassClock()
****
**** deletes the compass clock
****
***************************************************************************************************** */
deleteHUDCompassClock()
{
	level.compassclock = deleteHUDElement(level.compassclock);
}

updateHUDMainBombClock(timer)
{
	//delete main clock if making a bomb clock
	level.mainclock = deleteHUDElement(level.mainclock);
	
	//UI Element Options array
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
	options["x"] = 320; //center of screen x
	options["y"] = 460; //20 px above bottom of screen y
	options["alignX"] = "center"; //align text horizontally
	options["alignY"] = "middle"; //align text vertically
	options["font"] = "bigfixed"; //font option
	options["color"] = (1, 1, 1 ); // white
	if(timer > 0) //if timer
		level.mainBombClock = updateHUDElement(level.mainBombClock, "timer", timer, options);
}

updateHUDSecondaryBombClock(timer)
{
		//UI Element Options array
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
	options["x"] = 180; //left center of screen x
	options["y"] = 460; //20 px above bottom of screen y
	options["alignX"] = "center"; //align text horizontally
	options["alignY"] = "middle"; //align text vertically
	options["font"] = "bigfixed"; //font option
	options["color"] = (1, 1, 1 ); // white
	if(timer > 0) //if timer
		level.secondBombClock = updateHUDElement(level.secondBombClock, "timer", timer, options); 
}

deleteHUDMainBombClock()
{
	level.mainBombClock = deleteHUDElement(level.mainBombClock);
}

deleteHUDSecondaryBombClock()
{
	level.secondBombClock = deleteHUDElement(level.secondBombClock);
}

createClientHUDProgressBar(timer)
{
	barsize = 288;
		
	iconOptions = [];
	iconOptions["alignX"] = "center";
	iconOptions["alignY"] = "middle";
	iconOptions["x"] = 320;
	iconOptions["y"] = 345;
	iconOptions["width"] = 64;
	iconOptions["height"] = 64;
	
	backgroundOptions = [];
	backgroundOptions["alignX"] = "center";
	backgroundOptions["alignY"] = "middle";
	backgroundOptions["x"] = 320;
	backgroundOptions["y"] = 385;
	backgroundOptions["alpha"] = 0.5;
	backgroundOptions["height"] = 12;
	backgroundOptions["width"] = (barsize + 4);
	
	barOptions = [];
	barOptions["alignX"] = "left";
	barOptions["alignY"] = "middle";
	barOptions["x"] = (320 - (barsize / 2.0));
	barOptions["y"] = 385;
	barOptions["height"] = 8;
	barOptions["width"] = 0;
	
	barAnimOptions = [];
	barAnimOptions["height"] = 8;
	barAnimOptions["width"] = barsize;
	
	//test if element already exists, don't spam hud updates
	if(!isDefined(self maps\mp\uox\_uox_hud::getClientHUDElement("progressbackground")))
		self maps\mp\uox\_uox_hud::updateClientHUDElement("progressbackground",
			"shader", "black", backgroundOptions);

	//test if element already exists, don't spam hud updates
	if(!isDefined(self maps\mp\uox\_uox_hud::getClientHUDElement("progressbar")))
		self maps\mp\uox\_uox_hud::updateClientHUDElement("progressbar",
			"shader", "white", barOptions);
			
	barAnimOptions["time"] = planttime;
	self maps\mp\uox\_uox_hud::animateClientHUDElement("progressbar", "scaleShader",
		barAnimOptions);
}

deleteClientHUDProgressBar()
{
	self deleteClientHUDElement("progressbackground");
	self deleteClientHUDElement("progressbar");
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
		shader = game["headicon_" + game["team1"]];
	else 
		shader = game["objective_default"];
	level.scoreboardTeam1Shader = updateHUDElement(level.scoreboardTeam1Shader, "shader", shader, options);
	
	//Team1 Score
	options["x"] = 58;
	options["alignX"] = "right";
	
	if(level.uox_teamplay)
		value = maps\mp\uox\_uox::getTeam1Score();
	else
	{
		if([[level.getVars]]("scr_score_rounds"))
		{
			highscore = maps\mp\uox\_uox::getHighScore(true);
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
	level.scoreboardTeam1Score = updateHUDElement(level.scoreboardTeam1Score, "number", value, options);
	
	if([[level.getVars]]("sv_showScoreboardScoreLimit") > 0 && ((![[level.getVars]]("scr_score_rounds") && [[level.getVars]]("scr_scorelimit") > 0) || ([[level.getVars]]("scr_score_rounds") && [[level.getVars]]("scr_roundlimit") > 0 )))
	{
		level.scoreboardScoreLimit = true;
	}
	
	if(isDefined(level.scoreboardScoreLimit) && level.scoreboardScoreLimit)
	{
		//Allies Divider
		options["x"] = 62;
		options["alignX"] = "center";
		level.scoreboardTeam1LimitDiv = updateHUDElement(level.scoreboardTeam1LimitDiv, "text", game["dividerText"], options);
		
		//Allies Limit
		options["x"] = 66;
		options["alignX"] = "left";
		if(level.scoreboardKillsRounds)
		{
			//if in OT
			if(game["roundsplayed"] > [[level.getVars]]("scr_roundlimit"))
			{
				if((game["roundsplayed"] - [[level.getVars]]("scr_roundlimit")) % [[level.getVars]]("scr_ot_roundlimit"))
					OT = ((game["roundsplayed"] - [[level.getVars]]("scr_roundlimit")) / [[level.getVars]]("scr_ot_roundlimit")) + 1;
				else
					OT = (game["roundsplayed"] - [[level.getVars]]("scr_roundlimit")) / [[level.getVars]]("scr_ot_roundlimit");
			
				roundlimit = [[level.getVars]]("scr_roundlimit") + ([[level.getVars]]("scr_ot_roundlimit") * OT);
			} //otherwise
			else
				roundlimit = [[level.getVars]]("scr_roundlimit");
			value = maps\mp\uox\_uox::getWinningRoundNum(game["roundsplayed"], roundlimit);	
		}
		else
			value = [[level.getVars]]("scr_scorelimit");
		level.scoreboardTeam1Limit = updateHUDElement(level.scoreboardTeam1Limit, "number", value, options);
	}
	
	if(level.uox_teamplay)
	{
		options["x"] = 10;
		options["y"] = 270;
		options["alignX"] = "left";
		options["alignY"] = "middle";
		
		
		shader = game["headicon_" + game["team2"]];
		
		level.scoreboardTeam2Shader = updateHUDElement(level.scoreboardTeam2Shader, "shader", shader, options);
		
		//Axis Score
		options["x"] = 58;
		options["alignX"] = "right";
		
		value = maps\mp\uox\_uox::getTeam2Score();
		
		level.scoreboardTeam2Score = updateHUDElement(level.scoreboardTeam2Score, "number", value, options);
		
		if(isDefined(level.scoreboardScoreLimit) && level.scoreboardScoreLimit)
		{
			//Axis Divider
			options["x"] = 62;
			options["alignX"] = "center";
			level.scoreboardTeam2LimitDiv = updateHUDElement(level.scoreboardTeam2LimitDiv, "text", game["dividerText"], options);
			
			//Axis Limit
			options["x"] = 66;
			options["alignX"] = "left";
			if(level.scoreboardKillsRounds)
			{
				value = maps\mp\uox\_uox::getWinningRoundNum(game["roundsplayed"], roundlimit);	
			}
			else
				value = [[level.getVars]]("scr_scorelimit");
			level.scoreboardTeam2Limit = updateHUDElement(level.scoreboardTeam2Limit, "number", value, options);
		}
	}
	else
		updatePlayerScoreboard();
}

deleteServerScoreboard()
{
	level.scoreboardTeam1Shader = deleteHUDElement(level.scoreboardTeam1Shader);
	level.scoreboardTeam1Score = deleteHUDElement(level.scoreboardTeam1Score);
	if(level.uox_teamplay)
	{
		level.scoreboardTeam2Shader = deleteHUDElement(level.scoreboardTeam2Shader);
		level.scoreboardTeam2Score = deleteHUDElement(level.scoreboardTeam2Score);
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
	level.scoreboardTeam1LimitDiv = deleteHUDElement(level.scoreboardTeam1LimitDiv);
	level.scoreboardTeam1Limit = deleteHUDElement(level.scoreboardTeam1Limit);
	
	if(level.uox_teamplay)
	{
		level.scoreboardTeam2LimitDiv = deleteHUDElement(level.scoreboardTeam2LimitDiv);
		level.scoreboardTeam2Limit = deleteHUDElement(level.scoreboardTeam2Limit);
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
		
		player updateClientHUDElement("scoreboardShader", "shader", shader, options);
		
		//Axis Score
		options["x"] = 58;
		options["alignX"] = "right";
		
		if([[level.getVars]]("scr_score_rounds"))
			value = player.pers["roundswon"];
		else
			value = player.score;
		
		player updateClientHUDElement("scoreboardScore", "number", value, options);
		
		if(isDefined(level.scoreboardScoreLimit) && level.scoreboardScoreLimit)
		{
			//Divider
			options["x"] = 62;
			options["alignX"] = "center";
			
			player updateClientHUDElement("scoreboardDiv", "text", game["dividerText"], options);
			
			//Axis Limit
			options["x"] = 66;
			options["alignX"] = "left";
			if([[level.getVars]]("scr_score_rounds"))
			{
				//if in OT
				if(game["roundsplayed"] > [[level.getVars]]("scr_roundlimit"))
				{
					if((game["roundsplayed"] - [[level.getVars]]("scr_roundlimit")) % [[level.getVars]]("scr_ot_roundlimit"))
						OT = ((game["roundsplayed"] - [[level.getVars]]("scr_roundlimit")) / [[level.getVars]]("scr_ot_roundlimit")) + 1;
					else
						OT = (game["roundsplayed"] - [[level.getVars]]("scr_roundlimit")) / [[level.getVars]]("scr_ot_roundlimit");
				
					roundlimit = [[level.getVars]]("scr_roundlimit") + ([[level.getVars]]("scr_ot_roundlimit") * OT);
				} //otherwise
				else
					roundlimit = [[level.getVars]]("scr_roundlimit");
				value = maps\mp\uox\_uox::getWinningRoundNum(game["roundsplayed"], roundlimit);	
			}
			else
				value = [[level.getVars]]("scr_scorelimit");
			
			player updateClientHUDElement("scoreboardLimit", "number", value, options);
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

createHUDNextRound(time, lastRound, doHalfTime)
{
	if ( time < 3 )
		time = 3;
	
	if(!isDefined(doHalfTime))
		doHalfTime = false;
	
	thread createHUDEndRoundScore(time, lastRound, doHalfTime);

	if(game["roundsplayed"] >= [[level.getVars]]("scr_roundlimit"))
	{
		text = game["OTroundText"];
		round = game["roundsplayed"] + 1 - [[level.getVars]]("scr_roundlimit");
	}
	else
	{
		text = game["roundText"];	
		round = game["roundsplayed"] + 1;
	}

	options = [];
	options["x"] = 540;
	options["y"] = 360;
	options["alignX"] = "center";
	options["alignY"] = "middle";
	options["fontscale"] = 1;
	options["color"] = (1, 1, 0);
	level.round = updateHUDElement(level.round, "text", text, options);
	
	options["y"] = 380;
	level.roundnum = updateHUDElement(level.roundnum, "number", round, options);

	if(doHalfTime)
		text = game["resumingText"];
	else
		text = game["startingText"];

	options["y"] = 400;
	level.starting = updateHUDElement(level.starting, "text", text, options);
	
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

	level.round = deleteHUDElement(level.round);
	level.roundnum = deleteHUDElement(level.roundnum);
	level.starting = deleteHUDElement(level.starting);
	
}

createHUDEndRoundScore(time, lastRound, doHalfTime)
{
	if(time < 3)
		time = 3;
	
	options = [];
	options["x"] = 575;
	options["y"] = 237;
	options["alignX"] = "center";
	options["alignY"] = "middle";
	options["fontscale"] = 1;
	options["color"] = (0, 1, 0);
	
	//if in OT
	if(game["roundsplayed"] > [[level.getVars]]("scr_roundlimit"))
	{
		//get OT number
		if((game["roundsplayed"] - [[level.getVars]]("scr_roundlimit")) % [[level.getVars]]("scr_ot_roundlimit"))
			OT = ((game["roundsplayed"] - [[level.getVars]]("scr_roundlimit")) / [[level.getVars]]("scr_ot_roundlimit")) + 1;
		else
			OT = (game["roundsplayed"] - [[level.getVars]]("scr_roundlimit")) / [[level.getVars]]("scr_ot_roundlimit");
		//get the round limit for the current overtime
		roundlimit = [[level.getVars]]("scr_roundlimit") + ([[level.getVars]]("scr_ot_roundlimit") * OT);
		//get the halftime round number for current overtime
		if([[level.getVars]]("scr_ot_roundlimit") % 2)
			halfround = (roundlimit - [[level.getVars]]("scr_ot_roundlimit")) + (([[level.getVars]]("scr_ot_roundlimit") / 2) + 1);
		else
			halfround = (roundlimit - [[level.getVars]]("scr_ot_roundlimit")) + ([[level.getVars]]("scr_ot_roundlimit") / 2);
	}
	else // if game isn't in OT
	{
		roundlimit = [[level.getVars]]("scr_roundlimit"); //round limit
		halfround = level.halfround; //halftime round
	}
	round = game["roundsplayed"]; //current round
	
	//if we haven't played a round yet
	if(round == 0)
	{
		//if halftime is disabled
		if([[level.getVars]]("scr_halftime") == 0)
			//display Match Starting Header
			headerText = game["matchStartingText"];
		//if halftime is enabled
		else
			if(game["half"] == 1)
				//display first half starting text
				headerText = game["1stHalfStartingText"];
			else if(game["half"] == 2)
				//display second half starting text;
				headerText = game["2ndHalfStartingText"];
			else
				//display overtime text
				headerText = game["overtimemodeText"];
	}
	//if this was the last round
	else if(lastRound == true)
	{	//if its a team game
		if(level.uox_teamplay)
		{
			//get Team Scores
			team1Score = maps\mp\uox\_uox::getTeam1Score();
			team2Score = maps\mp\uox\_uox::getTeam2Score();
			//team 1 is winning
			if(team1Score > team2Score)
			{
				headerText = game["team1WinText"]; //set header to Team 1 Wins	
			} //if score is tied
			else if(game["alliedscore"] == game["axisscore"])
			{
				headerText = game["tieText"]; //set header to Its a Tie!
			}
			else //team 2 is winning
				headerText = game["team2WinText"]; //set header to Team 2 Wins
		}
		else //if its a free for all game
		{
			headerText = game["matchoverText"]; //set header to Match Over
		}
	}
	else if([[level.getVars]]("scr_halftime") == 0) //if halftime is disabled.
	{
		headerText = game["matchText"]; //set header to Match
	}
	else if(round == halfround) //if its halftime
	{
		headerText = game["halftimeText"];
	}
	else if(game["half"] == 1) //if game is in the first half
	{
		headerText = game["1HText"]; //set header to First Half
	}
	else if(game["half"] == 2) //if game is in second half
	{
		if(doHalfTime)
		{
			headerText = game["2ndHalfStartingText"];
		}
		else
			headerText = game["2HText"]; //set header to Second Half
	}
	else if(game["half"] > 2) //if game is in Overtime
	{
		headerText = game["overtimemodeText"]; //set header to Overtime
	}
	if(isDefined(headerText)) //if headerText was set		
		level.ersHeaderHUD = updateHUDElement(level.ersHeaderHUD, "text", headerText, options);
		//change Header Text on UI element
	
	if(round > 0) //if we started playing
	{
		//Scoreboard Text
		options["y"] = 262;
		options["color"] = (.99, .99, .75);
		level.ersBoardHUD = updateHUDElement(level.ersBoardHUD, "text", game["scoreboardText"], options);

		if(level.uox_teamplay) //if team game
		{ 	//set Team Texts and Team Scores
			team1Text = game["team1Text"];
			team2Text = game["team2Text"];
			matchScoreTeam1 = maps\mp\uox\_uox::getTeam1Score();
			matchScoreTeam2 = maps\mp\uox\_uox::getTeam2Score();
		}
		else //if free for all game
		{	//set Leader/You Texts and Score
			team1Text = game["leaderText"];
			team2Text = game["youText"];	
			leader = maps\mp\uox\_uox::getHighScore([[level.getVars]]("scr_score_rounds"));
			if([[level.getVars]]("scr_score_rounds"))
				matchScoreTeam1 = leader.roundsWon;
			else
				matchScoreTeam1 = leader.score;
		}

		//Team1 Text
		options["x"] = 535;
		options["y"] = 277;
		options["fontscale"] = .75;
		options["color"] = (.73, .99, .73);
		level.ersTeam1HUD = updateHUDElement(level.ersTeam1HUD, "text", team1Text, options);
		
		//Team2 Text
		options["x"] = 615;
		options["color"] = (.85, .99, .99);
		level.ersTeam2HUD = updateHUDElement(level.ersTeam2HUD, "text", team2Text, options);
		
		if([[level.getVars]]("scr_halftime")) //if halftime is enabled
		{
			if(level.uox_teamplay) //if team game
			{ 	//set half scores
				firstHalfTeam1Score = game["round1team1score"];
				firstHalfTeam2Score = game["round1team2score"];
				secondHalfTeam1Score = game["round2team1score"];
				secondHalfTeam2Score = game["round2team2score"];
				
				options["x"] = 618;
				options["y"] = 290;
				options["color"] = (.85, .99, .99);
				//1st Half Team 2 score
				level.ers1HAlliesScoreHUD = updateHUDElement(level.ers1HAlliesScoreHUD, "number",
					firstHalfTeam2Score, options);
				
				options["y"] = 307;
				options["color"] = (.73, .99, .75);
				//2nd Half Team 2 score
				level.ers2HAlliesScoreHUD = updateHUDElement(level.ers2HAlliesScoreHUD, "number", 
					secondHalfTeam2Score, options);
				
				options["y"] = 327;
				options["fontscale"] = 1;
				//Match Team 2 Score
				level.ersMatchAlliesScoreHUD = updateHUDElement(level.ersMatchAlliesScoreHUD, "number", 
					matchScoreTeam2, options);
			}
			else //if Free for All game mode
			{	
				//set half scores
				firstHalfTeam1Score = leader.pers["1HScore"];
				secondHalfTeam1Score = leader.pers["2HScore"];
				//create HUD Scores for players
				createPlayerHUDEndRoundScore();
			}
			// First Half Score Display
			options["x"] = 575;
			options["y"] = 290;
			options["color"] = (.99, .99, .75);
			if(round <= [[level.getVars]]("scr_roundlimit")) //if game is in regulation set 1st Half text
				text = game["1HText"];
			else //if game is in OT set OT 1H text
				text = game["OT1HText"];
			level.ers1HScoreHUD = updateHUDElement(level.ers1HScoreHUD, "text", text, options);
			
			options["x"] = 532;
			options["color"] = (.73, .99, .75);
			
			//First Half Team 1 Score
			level.ers1HAxisScoreHUD = updateHUDElement(level.ers1HAxisScoreHUD, "number", 
				firstHalfTeam1Score, options);
			
			if(round <= [[level.getVars]]("scr_roundlimit")) //if game is in regulation set 2nd Half text
				text = game["2HText"];
			else //if game is in OT set OT 2H text
				text = game["OT2HText"];
			
			options["x"] = 575;
			options["y"] = 307;
			options["color"] = (.99, .99, .75);
			// Second Half Score Display
			level.ers2HScoreHUD = updateHUDElement(level.ers2HScoreHUD, "text", text, options);
			
			options["x"] = 532;
			options["color"] = (.85, .99, .99);
			//Second Half Team 1 Score
			level.ers2HAxisScoreHUD = updateHUDElement(level.ers2HAxisScoreHUD, "number", 
				secondHalfTeam1Score, options);

			options["x"] = 575;
			options["y"] = 327;
			options["fontscale"] = .8;
			options["color"] = (.99, .99, .75);
			// Match Score Display
			level.ersMatchScoreHUD = updateHUDElement(level.ersMatchScoreHUD, "text", 
				game["matchScoreText"], options);

			options["x"] = 532;
			options["fontscale"] = 1;
			options["color"] = (.85, .99, .99);
			// Match Axis Score Display
			level.ersMatchAxisScoreHUD = updateHUDElement(level.ersMatchAxisScoreHUD, "number", 
				matchScoreTeam1, options);
		}
		else //halftime disabled
		{
			options["x"] = 575;
			options["y"] = 290;
			options["fontscale"] = .8;
			options["color"] = (.99, .99, .75);
			// Match Score Display
			level.ersMatchScoreHUD = updateHUDElement(level.ersMatchScoreHUD, "text", 
				game["matchScoreText"], options);
			
			options["x"] = 532;
			options["fontscale"] = .75;
			options["color"] = (.73, .99, .75);
			// Match Score Team 1 Score
			level.ersMatchAxisScoreHUD = updateHUDElement(level.ersMatchAxisScoreHUD, "number", 
				matchScoreTeam1, options);

			if(level.uox_teamplay) //if team game
			{ 	
				options["x"] = 618;
				options["color"] = (.85, .99, .99);
				// Match Score Team 2 Score 
				level.ersMatchAlliesScoreHUD = updateHUDElement(level.ersMatchAlliesScoreHUD, "number", 
					matchScoreTeam2, options);
			}
			else //if free for all game
			{	//create player HUD Scores
				createPlayerHUDEndRoundScore();
			}
		}
	}
	wait (time); //wait for timer
	
	//delete HUD elements
	level.ersHeaderHUD = deleteHUDElement(level.ersHeaderHUD);
	level.ersBoardHUD = deleteHUDElement(level.ersBoardHUD);
	level.ersTeam1HUD = deleteHUDElement(level.ersTeam1HUD);
	level.ersTeam2HUD = deleteHUDElement(level.ersTeam2HUD);
	level.ers1HAlliesScoreHUD = deleteHUDElement(level.ers1HAlliesScoreHUD);
	level.ers1HAxisScoreHUD = deleteHUDElement(level.ers1HAxisScoreHUD);
	level.ers1HScoreHUD = deleteHUDElement(level.ers1HScoreHUD);
	level.ers2HAlliesScoreHUD = deleteHUDElement(level.ers2HAlliesScoreHUD);
	level.ers2HAxisScoreHUD = deleteHUDElement(level.ers2HAxisScoreHUD);
	level.ers2HScoreHUD = deleteHUDElement(level.ers2HScoreHUD);
	level.ersMatchScoreHUD = deleteHUDElement(level.ersMatchScoreHUD);
	level.ersMatchAlliesScoreHUD = deleteHUDElement(level.ersMatchAlliesScoreHUD);
	level.ersMatchAxisScoreHUD = deleteHUDElement(level.ersMatchAxisScoreHUD);
	level.ersSwitchingHUD = deleteHUDElement(level.ersSwitchingHUD);
	level.ersSwitchWaitHUD = deleteHUDElement(level.ersSwitchWaitHUD);
	
	if(!level.uox_teamplay) //if free for all game
	{	//delete player HUD elements
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			
			player deleteClientHUDElement("ers1HScoreHUD");
			player deleteClientHUDElement("ers2HScoreHUD");
			player deleteClientHUDElement("ersMatchScoreHUD");
			
		}
	}
}

createPlayerHUDEndRoundScore()
{
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		options = [];
		options["alignX"] = "center";
		options["alignY"] = "middle";
		options["x"] = 618;
		
		player = players[i];
		if([[level.getVars]]("scr_halftime"))
		{
			options["y"] = 290;
			options["fontscale"] = .75;
			options["color"] = (.85, .99, .99);
			player updateClientHUDElement("ers1HScoreHUD", "number", player.pers["1HScore"], options);
			
			options["y"] = 307;
			options["color"] = (.73, .99, .75);
			player updateClientHUDElement("ers2HScoreHUD", "number", player.pers["2HScore"], options);
				
			options["y"] = 327;
			options["fontscale"] = 1;
			options["color"] = (.85, .99, .99);
			if([[level.getVars]]("scr_score_rounds"))
				value = player.pers["roundswon"];
			else
				value = player.pers["score"];
			player updateClientHUDElement("ersMatchScoreHUD", "number", value, options);
		}
		else
		{
			options["y"] = 290;
			options["fontscale"] = .75;
			options["color"] = (.85, .99, .99);
			if([[level.getVars]]("scr_score_rounds"))
				value = player.pers["roundswon"];
			else
				value = player.pers["score"];
			player updateClientHUDElement("ersMatchScoreHUD", "number", value, options);
		}
	}
}

createReadyUpHUD(switchingSides)
{
	if(!isDefined(switchingSides))
		switchingSides = false;
	
	if(switchingSides)
		text = game["switchingText"];
	else
		text = game["waitingText"];
	
	options = [];
	options["alignX"] = "center";
	options["alignY"] = "middle";
	options["color"] = (1, 0, 0);
	options["x"] = 575;
	options["y"] = 45;
	options["fontscale"] = 1.4;
	level.waitingHUD = updateHUDElement(level.waitingHUD, "text", text, options);
	
	options["y"] = 70;
	options["fontscale"] = 1.1;
	options["color"] = (.8, 1, 1);
	level.waitingOnHUD = updateHUDElement(level.waitingOnHUD, "text", game["waitingOnText"], options);

	options["y"] = 110;
	level.playersTextHUD = updateHUDElement(level.playersTextHUD, "text", game["playersText"], options);

	options["y"] = 90;
	options["fontscale"] = 1.2;
	options["color"] = (.98, .98, .60);
	
	level.notReadyHUD = updateHUDElement(level.notReadyHUD, "number", 0, options);
}

createPlayerReadyUpHUD(switchingSides)
{
	self iprintlnbold("^7Hit the ^3-Use- ^7key to Ready-Up");
	
	if(!isDefined(switchingSides))
		switchingSides = false;
	
	options = [];
	options["x"] = 320;
	options["alignX"] = "center";
	options["alignY"] = "middle";
	if(switchingSides)
	{
		options["y"] = 45;
		options["fontscale"] = 1.6;
		options["color"] = (1, 1, 0);
		updateClientHUDElement("SwitchingHUD", "text", game["switchingText"], options);
	}
	
	options["y"] = 265;
	options["fontscale"] = 2;
	options["color"] = (1, 0, 0);
	updateClientHUDElement("waitingHUD", "text", game["waitingText"], options);

	options["x"] = 575;
	options["y"] = 170;
	options["fontscale"] = 1.1;
	options["color"] = (.8, 1, 1);
	updateClientHUDElement("readyStatusHUD", "text", game["statusText"], options);
	
	options["y"] = 190;
	options["fontscale"] = 1.2;
	options["color"] = (1, .66, .66);
	updateClientHUDElement("readyHUD", "text", game["notReadyText"], options);
	
	wait 8;
	
	deleteClientHUDElement("waitingHUD");
	deleteClientHUDElement("SwitchingHUD");
}

deleteReadyUpHUD()
{
	
	level.waitingHUD = deleteHUDElement(level.waitingHUD);
	level.waitingOnHUD = deleteHUDElement(level.waitingOnHUD);
	level.playersTextHUD = deleteHUDElement(level.playersTextHUD);
	level.notReadyHUD = deleteHUDElement(level.notReadyHUD);
	level.SwitchingHUD = deleteHUDElement(level.SwitchingHUD);
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		
		player deletePlayerReadyUpHUD();
		
	}
	
}

deletePlayerReadyUpHUD()
{
	deleteClientHUDElement("readyStatusHUD");
	deleteClientHUDElement("readyHUD");
}

createWarmUpHUD(playercount, timer, switchingSides)
{
	if(!isDefined(switchingSides))
		switchingSides = false;
	options = [];
	options["alignX"] = "center";
	options["alignY"] = "middle";
	options["color"] = (1, 0, 0);
	options["x"] = 575;
	options["y"] = 45;
	options["fontscale"] = 1.4;
	
	if(switchingSides)
		text = game["switchingText"];
	else
		text = game["warmupText"];
	level.waitingHUD = updateHUDElement(level.waitingHUD, "text", text, options);
	
	if(playercount > 0)
	{
		options["y"] = 70;
		options["fontscale"] = 1.1;
		options["color"] = (.8, 1, 1);
		level.waitingOnHUD = updateHUDElement(level.waitingOnHUD, "text", 
			game["waitingOnText"], options);

		options["y"] = 110;
		level.playersTextHUD = updateHUDElement(level.playersTextHUD, "text",
			game["playersText"], options);

		options["x"] = 573;
		options["y"] = 90;
		options["alignX"] = "right";
		options["fontscale"] = 1.2;
		options["color"] = (.98, .98, .60);
		level.notReadyHUD = updateHUDElement(level.notReadyHUD, "number", 0, options);
		
		options["x"] = 575;
		options["alignX"] = "center";
		level.notReadyDivHUD = updateHUDElement(level.notReadyDivHUD, "text",
			game["dividerText"], options);
		
		options["x"] = 577;
		options["alignX"] = "left";
		
		level.allReadyHUD = updateHUDElement(level.allReadyHUD, "number", playercount, options);
	}
}

createPlayerWarmUpHUD(switchingSides)
{
	if(!isDefined(switchingSides))
		switchingSides = false;
	
	options = [];
	options["x"] = 320;
	options["alignX"] = "center";
	options["alignY"] = "middle";
	
	if(switchingSides)
	{
		options["y"] = 45;
		options["fontscale"] = 1.6;
		options["color"] = (1, 1, 0);
		updateClientHUDElement("SwitchingHUD", "text", game["switchingText"], options);
	}
	
	options["y"] = 265;
	options["fontscale"] = 2;
	options["color"] = (1, 0, 0);
	updateClientHUDElement("waitingHUD", "text", game["warmupText"], options);
	
	wait 8;
	
	deleteClientHUDElement("waitingHUD");
	deleteClientHUDElement("SwitchingHUD");
}

deleteWarmupHUD()
{
	level.waitingHUD = deleteHUDElement(level.waitingHUD);
	level.waitingOnHUD = deleteHUDElement(level.waitingOnHUD);
	level.playersTextHUD = deleteHUDElement(level.playersTextHUD);
	level.notReadyHUD = deleteHUDElement(level.notReadyHUD);
	level.notReadyDivHUD = deleteHUDElement(level.notReadyDivHUD);
	level.allReadyHUD = deleteHUDElement(level.allReadyHUD);
	level.SwitchingHUD = deleteHUDElement(level.SwitchingHUD);
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
		
		if([[level.getVars]]("sv_showScoreboard"))
			updateServerScoreboard();
		else if(isDefined(level.scoreboard))
			deleteServerScoreboard();
		
		if(isDefined(level.scoreboardScoreLimit) && ([[level.getVars]]("sv_showScoreboardScoreLimit") == 0 || ((![[level.getVars]]("scr_score_rounds") && [[level.getVars]]("scr_scorelimit") <= 0) || ([[level.getVars]]("scr_score_rounds") && [[level.getVars]]("scr_roundlimit") <= 0 ))))
			deleteServerScoreboardScoreLimit();
		
		wait 0.25;
		if(level.mapended || level.roundended)
			return;
	}
}