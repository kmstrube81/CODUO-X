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
}

initHUD()
{
	self.hud = [];
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
	level.scoreboardAlliesScore = updateHUDElement(level.scoreboardAlliesScore, "number", value, options);
	
	if(getCvarInt("sv_showScoreboardScoreLimit") > 0 && ((![[level.getVars]]("scr_score_rounds") && [[level.getVars]]("scr_scorelimit") > 0) || ([[level.getVars]]("scr_score_rounds") && [[level.getVars]]("scr_roundlimit") > 0 )))
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
		if([[level.getVars]]("scr_score_rounds"))
		{
			if(level.uox_teamplay)
				value = ([[level.getVars]]("scr_roundlimit")/2) + 1;
			else
			{	//if in OT
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
				roundsRemaining = roundlimit - game["roundsplayed"];
				firstplace = maps\mp\uox\_uox::getHighScore(true);
				secondplace = maps\mp\uox\_uox::getSecondPlace(firstplace, true);
				if(!isDefined(firstplace)) rw1p = 0; else rw1p = firstplace.roundsWon;
				if(!isDefined(secondplace)) rw2p = 0; else rw2p = secondplace.roundsWon;
				scores = rw1p + rw2p;
				value = ((roundsRemaining + scores)/2) + 1;
			}
		}
		else
			value = [[level.getVars]]("scr_scorelimit");
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
			if([[level.getVars]]("scr_score_rounds"))
			{
				value = ([[level.getVars]]("scr_roundlimit")/2) + 1;
			}
			else
				value = [[level.getVars]]("scr_scorelimit");
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
		
		if([[level.getVars]]("scr_score_rounds"))
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
				roundsRemaining = roundlimit - game["roundsplayed"];
				firstplace = maps\mp\uox\_uox::getHighScore(true);
				secondplace = maps\mp\uox\_uox::getSecondPlace(firstplace, true);
				if(!isDefined(firstplace)) rw1p = 0; else rw1p = firstplace.roundsWon;
				if(!isDefined(secondplace)) rw2p = 0; else rw2p = secondplace.roundsWon;
				scores = rw1p + rw2p;
				value = ((roundsRemaining + scores)/2) + 1;
			}
			else
				value = [[level.getVars]]("scr_scorelimit");
			
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

createHUDNextRound(time, lastRound, doHalfTime)
{
	if ( time < 3 )
		time = 3;
	
	if(!isDefined(doHalfTime))
		doHalfTime = false;
	
	thread createHUDEndRoundScore(time, lastRound, doHalfTime);

	if(!isDefined(level.round))
		level.round = newHudElem();
	level.round.x = 540;
	level.round.y = 360;
	level.round.alignX = "center";
	level.round.alignY = "middle";
	level.round.fontScale = 1;
	level.round.color = (1, 1, 0);
	if(game["roundsplayed"] >= [[level.getVars]]("scr_roundlimit"))
	{
		level.round setText(game["OTroundText"]);
		round = game["roundsplayed"] + 1 - [[level.getVars]]("scr_roundlimit");
	}
	else
	{
		level.round setText(game["roundText"]);	
		round = game["roundsplayed"] + 1;
	}
		
	if(!isDefined(level.roundnum))
		level.roundnum = newHudElem();
	level.roundnum.x = 540;
	level.roundnum.y = 380;
	level.roundnum.alignX = "center";
	level.roundnum.alignY = "middle";
	level.roundnum.fontScale = 1;
	level.roundnum.color = (1, 1, 0);
	
	level.roundnum setValue(round);

	if(!isDefined(level.starting))
		level.starting = newHudElem();
	level.starting.x = 540;
	level.starting.y = 400;
	level.starting.alignX = "center";
	level.starting.alignY = "middle";
	level.starting.fontScale = 1;
	level.starting.color = (1, 1, 0);
	
	if(doHalfTime)
		level.starting setText(game["resumingText"]);
	else
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

	level.round = deleteHUDElement(level.round);
	level.roundnum = deleteHUDElement(level.roundnum);
	level.starting = deleteHUDElement(level.starting);
	
}

createHUDEndRoundScore(time, lastRound, doHalfTime)
{
	if(time < 3)
		time = 3;
	
	if(!isDefined(level.ersHeaderHUD))
		level.ersHeaderHUD = newHudElem();
	level.ersHeaderHUD.x = 575;
	level.ersHeaderHUD.y = 237;
	level.ersHeaderHUD.alignX = "center";
	level.ersHeaderHUD.alignY = "middle";
	level.ersHeaderHUD.fontScale = 1;
	level.ersHeaderHUD.color = (0, 1, 0);
	
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
		level.ersHeaderHUD setText(headerText); //change Header Text on UI element
	
	if(round > 0) //if we started playing
	{
		//Scoreboard Text
		if(!isDefined(level.ersBoardHUD))
			level.ersBoardHUD = newHudElem();
		level.ersBoardHUD.x = 575;
		level.ersBoardHUD.y = 262;
		level.ersBoardHUD.alignX = "center";
		level.ersBoardHUD.alignY = "middle";
		level.ersBoardHUD.fontScale = 1;
		level.ersBoardHUD.color = (.99, .99, .75);
		level.ersBoardHUD setText(game["scoreboardText"]);

		//Team1 Text
		level.ersTeam1HUD = newHudElem();
		level.ersTeam1HUD.x = 535;
		level.ersTeam1HUD.y = 277;
		level.ersTeam1HUD.alignX = "center";
		level.ersTeam1HUD.alignY = "middle";
		level.ersTeam1HUD.fontScale = .75;
		level.ersTeam1HUD.color = (.73, .99, .73);
		
		//Team2 Text
		level.ersTeam2HUD = newHudElem();
		level.ersTeam2HUD.x = 615;
		level.ersTeam2HUD.y = 277;
		level.ersTeam2HUD.alignX = "center";
		level.ersTeam2HUD.alignY = "middle";
		level.ersTeam2HUD.fontScale = .75;
		level.ersTeam2HUD.color = (.85, .99, .99);
		
		if(level.uox_teamplay) //if team game
		{ 	//set Team Texts and Team Scores
			level.ersTeam1HUD setText(game["team1Text"]);
			level.ersTeam2HUD setText(game["team2Text"]);
			matchScoreTeam1 = maps\mp\uox\_uox::getTeam1Score();
			matchScoreTeam2 = maps\mp\uox\_uox::getTeam2Score();
		}
		else //if free for all game
		{	//set Leader/You Texts and Score
			level.ersTeam1HUD setText(game["leaderText"]);
			level.ersTeam2HUD setText(game["youText"]);	
			leader = maps\mp\uox\_uox::getHighScore([[level.getVars]]("scr_score_rounds"));
			if([[level.getVars]]("scr_score_rounds"))
				matchScoreTeam1 = leader.roundsWon;
			else
				matchScoreTeam1 = leader.score;
		}
		
		if([[level.getVars]]("scr_halftime")) //if halftime is enabled
		{
			// First Half Score Display
			if(!isDefined(level.ers1HScoreHUD))
				level.ers1HScoreHUD = newHudElem();
			level.ers1HScoreHUD.x = 575;
			level.ers1HScoreHUD.y = 290;
			level.ers1HScoreHUD.alignX = "center";
			level.ers1HScoreHUD.alignY = "middle";
			level.ers1HScoreHUD.fontScale = .75;
			level.ers1HScoreHUD.color = (.99, .99, .75);
			if(round <= [[level.getVars]]("scr_roundlimit")) //if game is in regulation set 1st Half text
				level.ers1HScoreHUD setText(game["1HText"]);
			else //if game is in OT set OT 1H text
				level.ers1HScoreHUD setText(game["OT1HText"]);
			
			//First Half Team 1 Score
			if(!isDefined(level.ers1HAxisScoreHUD))
				level.ers1HAxisScoreHUD = newHudElem();
			level.ers1HAxisScoreHUD.x = 532;
			level.ers1HAxisScoreHUD.y = 290;
			level.ers1HAxisScoreHUD.alignX = "center";
			level.ers1HAxisScoreHUD.alignY = "middle";
			level.ers1HAxisScoreHUD.fontScale = .75;
			level.ers1HAxisScoreHUD.color = (.73, .99, .75);

			// Second Half Score Display
			if(!isDefined(level.ers2HScoreHUD))
				level.ers2HScoreHUD = newHudElem();
			level.ers2HScoreHUD.x = 575;
			level.ers2HScoreHUD.y = 307;
			level.ers2HScoreHUD.alignX = "center";
			level.ers2HScoreHUD.alignY = "middle";
			level.ers2HScoreHUD.fontScale = .75;
			level.ers2HScoreHUD.color = (.99, .99, .75);
			if(round <= [[level.getVars]]("scr_roundlimit")) //if game is in regulation set 2nd Half text
				level.ers2HScoreHUD setText(game["2HText"]);
			else //if game is in OT set OT 2H text
				level.ers2HScoreHUD setText(game["OT2HText"]);
			
			//Second Half Team 1 Score
			if(!isDefined(level.ers2HAxisScoreHUD))
				level.ers2HAxisScoreHUD = newHudElem();
			level.ers2HAxisScoreHUD.x = 532;
			level.ers2HAxisScoreHUD.y = 307;
			level.ers2HAxisScoreHUD.alignX = "center";
			level.ers2HAxisScoreHUD.alignY = "middle";
			level.ers2HAxisScoreHUD.fontScale = .75;
			level.ers2HAxisScoreHUD.color = (.85, .99, .99);
								
			// Match Score Display
			if(!isDefined(level.ersMatchScoreHUD))
				level.ersMatchScoreHUD = newHudElem();
			level.ersMatchScoreHUD.x = 575;
			level.ersMatchScoreHUD.y = 327;
			level.ersMatchScoreHUD.alignX = "center";
			level.ersMatchScoreHUD.alignY = "middle";
			level.ersMatchScoreHUD.fontScale = .8;
			level.ersMatchScoreHUD.color = (.99, .99, .75);
			level.ersMatchScoreHUD setText(game["matchScoreText"]);

			// Match Axis Score Display
			if(!isDefined(level.ersMatchAxisScoreHUD))
				level.ersMatchAxisScoreHUD = newHudElem();
			level.ersMatchAxisScoreHUD.x = 532;
			level.ersMatchAxisScoreHUD.color = (.85, .99, .99);
			level.ersMatchAxisScoreHUD.y = 327;
			level.ersMatchAxisScoreHUD.alignX = "center";
			level.ersMatchAxisScoreHUD.alignY = "middle";
			level.ersMatchAxisScoreHUD.fontScale = 1;
			level.ersMatchAxisScoreHUD setValue(matchScoreTeam1);

			if(level.uox_teamplay) //if team game
			{ 	//set half scores
				firstHalfTeam1Score = game["round1team1score"];
				firstHalfTeam2Score = game["round1team2score"];
				secondHalfTeam1Score = game["round2team1score"];
				secondHalfTeam2Score = game["round2team2score"];
				//1st Half Team 1 Score
				level.ers1HAxisScoreHUD setValue(firstHalfTeam1Score);
				//2nd Half Team 1 Score
				level.ers2HAxisScoreHUD setValue(secondHalfTeam1Score);
				
				//1st Half Team 2 score
				if(!isDefined(level.ers1HAlliesScoreHUD))
					level.ers1HAlliesScoreHUD = newHudElem();
				level.ers1HAlliesScoreHUD.x = 618;
				level.ers1HAlliesScoreHUD.y = 290;
				level.ers1HAlliesScoreHUD.alignX = "center";
				level.ers1HAlliesScoreHUD.alignY = "middle";
				level.ers1HAlliesScoreHUD.fontScale = .75;
				level.ers1HAlliesScoreHUD.color = (.85, .99, .99);
				level.ers1HAlliesScoreHUD setValue(firstHalfTeam2Score);
				
				//2nd Half Team 2 score
				if(!isDefined(level.ers2HAlliesScoreHUD))
					level.ers2HAlliesScoreHUD = newHudElem();
				level.ers2HAlliesScoreHUD.x = 532;
				level.ers2HAlliesScoreHUD.y = 307;
				level.ers2HAlliesScoreHUD.alignX = "center";
				level.ers2HAlliesScoreHUD.alignY = "middle";
				level.ers2HAlliesScoreHUD.fontScale = .75;
				level.ers2HAlliesScoreHUD.color = (.73, .99, .75);
				level.ers2HAlliesScoreHUD setValue(secondHalfTeam2Score);
				
				//Match Team 2 Score
				if(!isDefined(level.ersMatchAlliesScoreHUD))
					level.ersMatchAlliesScoreHUD = newHudElem();
				level.ersMatchAlliesScoreHUD.x = 618;
				level.ersMatchAlliesScoreHUD.color = (.73, .99, .75);
				level.ersMatchAlliesScoreHUD.y = 327;
				level.ersMatchAlliesScoreHUD.alignX = "center";
				level.ersMatchAlliesScoreHUD.alignY = "middle";
				level.ersMatchAlliesScoreHUD.fontScale = 1;
				level.ersMatchAlliesScoreHUD setValue(matchScoreTeam2);
			}
			else //if Free for All game mode
			{	
				//set half scores
				firstHalfTeam1Score = leader.pers["1HScore"];
				secondHalfTeam1Score = leader.pers["2HScore"];
				//1st Half Leader Score
				level.ers1HAxisScoreHUD setValue(firstHalfTeam1Score);
				//1st Half Leader Score
				level.ers2HAxisScoreHUD setValue(secondHalfTeam1Score);
				//create HUD Scores for players
				createPlayerHUDEndRoundScore();
			}
		}
		else //halftime disabled
		{
			// Match Score Display
			if(!isDefined(level.ersMatchScoreHUD))
				level.ersMatchScoreHUD = newHudElem();
			level.ersMatchScoreHUD.x = 575;
			level.ersMatchScoreHUD.y = 290;
			level.ersMatchScoreHUD.alignX = "center";
			level.ersMatchScoreHUD.alignY = "middle";
			level.ersMatchScoreHUD.fontScale = .75;
			level.ersMatchScoreHUD.color = (.99, .99, .75);
			level.ersMatchScoreHUD setText(game["matchScoreText"]);
			
			// Match Score Team 1 Score
			if(!isDefined(level.ersMatchAxisScoreHUD))
				level.ersMatchAxisScoreHUD = newHudElem();
			level.ersMatchAxisScoreHUD.x = 532;
			level.ersMatchAxisScoreHUD.y = 290;
			level.ersMatchAxisScoreHUD.alignX = "center";
			level.ersMatchAxisScoreHUD.alignY = "middle";
			level.ersMatchAxisScoreHUD.fontScale = .75;
			level.ersMatchAxisScoreHUD.color = (.73, .99, .75);

			if(level.uox_teamplay) //if team game
			{ 	// Match Score Team 1 Score
				level.ersMatchAxisScoreHUD setValue(matchScoreTeam1);
				// Match Score Team 2 Score
				if(!isDefined(level.ersMatchAlliesScoreHUD))
					level.ersMatchAlliesScoreHUD = newHudElem();
				level.ersMatchAlliesScoreHUD.x = 618;
				level.ersMatchAlliesScoreHUD.y = 290;
				level.ersMatchAlliesScoreHUD.alignX = "center";
				level.ersMatchAlliesScoreHUD.alignY = "middle";
				level.ersMatchAlliesScoreHUD.fontScale = .75;
				level.ersMatchAlliesScoreHUD.color = (.85, .99, .99);
				level.ersMatchAlliesScoreHUD setValue(matchScoreTeam2);
			}
			else //if free for all game
			{	// Match Score Leader Score
				level.ersMatchAxisScoreHUD setValue(matchScoreTeam1);
				//create player HUD Scores
				createPlayerHUDEndRoundScore();
			}
		}
	}
	/*
	if(switchingSides) //if Switching Sides
	{	//create Switching Side HUD
		if(!isDefined(level.ersSwitchingHUD))
			level.ersSwitchingHUD = newHudElem();
		level.ersSwitchingHUD.x = 320;
		level.ersSwitchingHUD.y = 45;
		level.ersSwitchingHUD.alignX = "center";
		level.ersSwitchingHUD.alignY = "middle";
		level.ersSwitchingHUD.fontScale = 1.6;
		level.ersSwitchingHUD.color = (1, 1, 0);
		level.ersSwitchingHUD setText(game["switchingText"]);
		
		//create please wait Switching Side HUD
		if(!isDefined(level.ersSwitchWaitHUD))
			level.ersSwitchWaitHUD = newHudElem();
		level.ersSwitchWaitHUD.x = 320;
		level.ersSwitchWaitHUD.y = 75;
		level.ersSwitchWaitHUD.alignX = "center";
		level.ersSwitchWaitHUD.alignY = "middle";
		level.ersSwitchWaitHUD.fontScale = 1.6;
		level.ersSwitchWaitHUD.color = (1, 1, 0);
		level.ersSwitchWaitHUD setText(game["switchWaitText"]);
	}
	*/
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
			
			player.ers1HScoreHUD = player deleteHUDElement(player.ers1HScoreHUD);
			player.ers2HScoreHUD = player deleteHUDElement(player.ers2HScoreHUD);
			player.ersMatchScoreHUD = player deleteHUDElement(player.ersMatchScoreHUD);
			
		}
	}
}

createPlayerHUDEndRoundScore()
{
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if([[level.getVars]]("scr_halftime") > 0)
		{
			if(!isDefined(player.ers1HScoreHUD))
					player.ers1HScoreHUD = newClientHudElem(player);
				player.ers1HScoreHUD.x = 618;
				player.ers1HScoreHUD.y = 290;
				player.ers1HScoreHUD.alignX = "center";
				player.ers1HScoreHUD.alignY = "middle";
				player.ers1HScoreHUD.fontScale = .75;
				player.ers1HScoreHUD.color = (.85, .99, .99);
				player.ers1HScoreHUD setValue(player.pers["1HScore"]);
				
				if(!isDefined(player.ers2HScoreHUD))
					player.ers2HScoreHUD = newClientHudElem(player);
				player.ers2HScoreHUD.x = 618;
				player.ers2HScoreHUD.y = 307;
				player.ers2HScoreHUD.alignX = "center";
				player.ers2HScoreHUD.alignY = "middle";
				player.ers2HScoreHUD.fontScale = .75;
				player.ers2HScoreHUD.color = (.73, .99, .75);
				player.ers2HScoreHUD setValue(player.pers["2HScore"]);
				
				if(!isDefined(player.ersMatchScoreHUD))
					player.ersMatchScoreHUD = newClientHudElem(player);
				
				player.ersMatchScoreHUD.x = 618;
				player.ersMatchScoreHUD.color = (.85, .99, .99);

				player.ersMatchScoreHUD.y = 327;
				player.ersMatchScoreHUD.alignX = "center";
				player.ersMatchScoreHUD.alignY = "middle";
				player.ersMatchScoreHUD.fontScale = 1;
				if([[level.getVars]]("scr_score_rounds"))
					player.ersMatchScoreHUD setValue(player.pers["roundswon"]);
				else
					player.ersMatchScoreHUD setValue(player.pers["score"]);
		}
		else
		{
			if(!isDefined(player.ersMatchScoreHUD))
				player.ersMatchScoreHUD = newClientHudElem(player);
			player.ersMatchScoreHUD.x = 618;
			player.ersMatchScoreHUD.y = 290;
			player.ersMatchScoreHUD.alignX = "center";
			player.ersMatchScoreHUD.alignY = "middle";
			player.ersMatchScoreHUD.fontScale = .75;
			player.ersMatchScoreHUD.color = (.85, .99, .99);
			if([[level.getVars]]("scr_score_rounds"))
				player.ersMatchScoreHUD setValue(player.pers["roundswon"]);
			else
				player.ersMatchScoreHUD setValue(player.pers["score"]);
		}
	}
}

createReadyUpHUD(switchingSides)
{
	if(!isDefined(switchingSides))
		switchingSides = false;
		
	if(!isDefined(level.waitingHUD))
		level.waitingHUD = newHudElem();
	level.waitingHUD.alignX = "center";
	level.waitingHUD.alignY = "middle";
	level.waitingHUD.color = (1, 0, 0);
	level.waitingHUD.x = 575;
	level.waitingHUD.y = 45;
	level.waitingHUD.fontScale = 1.4;

	if(switchingSides)
		level.waitingHUD setText(game["switchingText"]);
	else
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

createPlayerReadyUpHUD(switchingSides)
{
	self iprintlnbold("^7Hit the ^3-Use- ^7key to Ready-Up");
	
	if(!isDefined(switchingSides))
		switchingSides = false;
	
	if(switchingSides)
	{
		if(!isDefined(self.SwitchingHUD))
			self.SwitchingHUD = newClientHudElem(self);
		self.SwitchingHUD.x = 320;
		self.SwitchingHUD.y = 45;
		self.SwitchingHUD.alignX = "center";
		self.SwitchingHUD.alignY = "middle";
		self.SwitchingHUD.fontScale = 1.6;
		self.SwitchingHUD.color = (1, 1, 0);
		self.SwitchingHUD setText(game["switchingText"]);
	}
	
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
	self.SwitchingHUD = deleteHUDElement(self.SwitchingHUD);
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
	self.readyStatusHUD = deleteHUDElement(self.readyStatusHUD);
	self.readyHUD = deleteHUDElement(self.readyHUD);
}

createWarmUpHUD(playercount, timer, switchingSides)
{
	if(!isDefined(switchingSides))
		switchingSides = false;
	
	if(!isDefined(level.waitingHUD))
		level.waitingHUD = newHudElem();
	level.waitingHUD.alignX = "center";
	level.waitingHUD.alignY = "middle";
	level.waitingHUD.color = (1, 0, 0);
	level.waitingHUD.x = 575;
	level.waitingHUD.y = 45;
	level.waitingHUD.fontScale = 1.4;

	if(switchingSides)
		level.waitingHUD setText(game["switchingText"]);
	else
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

createPlayerWarmUpHUD(switchingSides)
{
	if(!isDefined(switchingSides))
		switchingSides = false;
	
	if(switchingSides)
	{
		if(!isDefined(self.SwitchingHUD))
			self.SwitchingHUD = newClientHudElem(self);
		self.SwitchingHUD.x = 320;
		self.SwitchingHUD.y = 45;
		self.SwitchingHUD.alignX = "center";
		self.SwitchingHUD.alignY = "middle";
		self.SwitchingHUD.fontScale = 1.6;
		self.SwitchingHUD.color = (1, 1, 0);
		self.SwitchingHUD setText(game["switchingText"]);
	}
		
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
	self.SwitchingHUD = deleteHUDElement(self.SwitchingHUD);
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
		
		if(getCvarInt("sv_showScoreboard") > 0)
			updateServerScoreboard();
		else if(isDefined(level.scoreboard))
			deleteServerScoreboard();
		
		if(isDefined(level.scoreboardScoreLimit) && (getCvarInt("sv_showScoreboardScoreLimit") == 0 || ((![[level.getVars]]("scr_score_rounds") && [[level.getVars]]("scr_scorelimit") <= 0) || ([[level.getVars]]("scr_score_rounds") && [[level.getVars]]("scr_roundlimit") <= 0 ))))
			deleteServerScoreboardScoreLimit();
		
		wait 0.25;
		if(level.mapended || level.roundended)
			return;
	}
}