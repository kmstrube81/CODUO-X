/* *************************************************************************************************
**** isTeamPlayGametype(string gt)
****
**** Called from Callback_StartGametype
**** returns whether gametype is a team game or free for all game
**** 
************************************************************************************************* */
isTeamPlayGametype(gt)
{
	//switch case statement
	switch(gt)
	{
		case "tdm":
		case "bel":
		case "re":
		case "sd":
		case "hq":
		case "ctf":
		case "dom":
		case "bas": //if team based gametype
			return true; //is team play
		case "dm": //if free for all gametype
			return false; //not team play
		default: //unknown type 
			return false; //assume it isn't team play
	}
	return false; //code should never get here
}

/* *************************************************************************************************
**** checkPlayerKilled(playerEntity victim, playerEntity attacker)
****
**** Called from Callback_PlayerKilled
**** tracks kills, adjusts player/team score if needed for gametype
**** 
************************************************************************************************* */
checkPlayerKilled(victim, attacker)
{
	addKillToTeamScore = false; //init update team score flag as false
	doCheckScoreLimit = false; //init check score limit flag
	
	setPlayerScore(victim, attacker);
	
	if(level.uox_teamplay) //if team game
	{
		if(victim.pers["team"] == attacker.pers["team"]) // killed by a friendly
		{	//if teamkill penalty flag is true
			if ([[level.getVars]]("scr_teamscorepenalty"))
			{
				if(attacker.pers["team"] == "allies")
					game["alliedkills"]--; //subtract a kill from running total
				else if(attacker.pers["team"] == "axis")
					game["axiskills"]--;  //subtract a kill from running total
			}
		}
		else //normal non-team kill
		{
			if(attacker.pers["team"] == "allies")
				game["alliedkills"]++; //add kill to running total
			else if(attacker.pers["team"] == "axis")
				game["axiskills"]++; //add kill to running total
		}
	}
	else //if free for all game
	{
		attacker.pers["kills"]++; //give attacker a kill
	}
	/* Objective Based Kill checks */
	obj = level.objective; //get gametype
	
	if(!isDefined(obj))
		obj = "none";
	
	switch(obj)
	{
		case "none": //if dm, check score limit
			doCheckScoreLimit = true;
			if(level.uox_teamplay)
				addKillToTeamScore = true;
			break;
		case "bomb": //SD/DEM bonus
			maps\mp\uox\_uox_bombs::onPlayerKill(victim, attacker);
			break;
		case "retrieval": //RE bonus
			maps\mp\uox\_uox_retrievals::onPlayerKill(victim, attacker);
			break;
        case "bel":
            doCheckScoreLimit = true;
            maps\mp\uox\_uox_behindenemylines::onPlayerKill(victim, attacker);
            break;
	}
	if(addKillToTeamScore) //if add to team score flag set.
	{
		if(victim.pers["team"] == attacker.pers["team"]) // killed by a friendly
		{	
			if ([[level.getVars]]("scr_teamscorepenalty")) //if teamkill penalty flag set to true
			{
				incrementTeamScore(attacker.pers["team"], -1);
			}
		}
		else //normal kill
		{
			incrementTeamScore(attacker.pers["team"]);
		}
	}
	if(doCheckScoreLimit) //if check score limit flag is true
		checkScoreLimit(); //check score limit duh
}

/* *************************************************************************************************
**** checkScoreLimit()
****
**** Called from checkPlayerKilled, endRound
**** checks the scorelimit and does half or ends the game depending on settings
**** 
************************************************************************************************* */
checkScoreLimit()
{
	if(!game["matchstarted"]) //if match isn't started
		return; //then nothing to do
	
	if([[level.getVars]]("scr_scorelimit") <= 0) //if scorelimit is 0 or negative, assume there is no scorelimit
		return; //nothing to do in that case
		
	if([[level.getVars]]("scr_score_rounds"))
	{ //init team scores if scoring rounds
		alliedscore = level.alliedscore;
		axisscore = level.axisscore;
	}
	else
	{ //init teamscores if not scoring rounds
		alliedscore = game["alliedscore"];
		axisscore = game["axisscore"];
	}	
	doHalftime = false; //init doHalftime flag 
	
	if(game["suddendeath"]) //if suddendeath overtime
	{
		if(checkTie([[level.getVars]]("scr_score_rounds"))) //if game tied
		{
			return; //if game tied, nothing to do yet
		}
	}
	else //if kill is in regulation
	{
		if(level.uox_teamplay && level.objective != "bel") //if team game
		{	//if one team has reached the halfscore and game is in the first half
			if([[level.getVars]]("scr_halftime")
			   && (alliedscore >= level.halfscore || axisscore >= level.halfscore) 
			   && game["half"] == 1)
			{	//if game is roundbased and both teams are less than the scorelimit and not scoring rounds
				if(game["roundbased"] && alliedscore < [[level.getVars]]("scr_scorelimit")
					&& axisscore < [[level.getVars]]("scr_scorelimit") 
					&& ![[level.getVars]]("scr_score_rounds"))
						doHalftime(true);	//doHalftime
			}
			//if both teams or below the scorelimit
			if(alliedscore < [[level.getVars]]("scr_scorelimit")
				&& axisscore < [[level.getVars]]("scr_scorelimit"))
				return; //nothing to do
		}
		else //if free for all game
		{
			players = getentarray("player", "classname"); //get players
			for(i = 0; i < players.size; i++) //loop players
			{	//if current player score is greater than halfscore and game is in the first half
				if([[level.getVars]]("scr_halftime") && players[i].score >= level.halfscore 
				&& game["half"] == 1 && players[i].score < [[level.getVars]]("scr_scorelimit"))
				{	//if not scoring rounds and game is round based
					if(![[level.getVars]]("scr_score_rounds") && game["roundbased"])
						doHalftime = true; //set doHalftime flag
				}
				
				if(players[i].score >= [[level.getVars]]("scr_scorelimit")) //if current player is over the scorelimit
					break; //exit the loop
			}

			if(i >= players.size) //if loop fully completed
			{	//if doHalftime is true
				if(doHalftime)
					doHalftime(true); //do halftime
				return; //nothing left to do
			}
		}
	}
	
	//Loop exited early, because a player reached score limit
	if(level.mapended) //if map already ended
		return; //nothing to do
		
	if(game["roundbased"]) //if game is round based
	{
		if(!level.roundended) //and round hasn't ended
			iprintlnbold(&"MPSCRIPT_SCORE_LIMIT_REACHED"); //announce score limit reached
			
		if(![[level.getVars]]("scr_roundreset") && !level.uox_teamplay) //if not reseting scores and a free for all game 
		{	//free for all kills are the score so the game ends when score limit is reached
			level.mapended = true; //set map as ended
			level.roundended = true; //set round as ended
			players[i].pers["roundswon"] = players[i].score;	
			game["roundsplayed"]++;
			wait 5; //wait five seconds before ending round
			maps\mp\uox\_uox_hud::createHUDEndRoundScore([[level.getVars]]("sv_endRoundScoreboardTime"), true, false); //create game over scoreboard
	
			level thread endMap(); //end map
			return;
		}	//if resetting scores do regular end round shenanigans.
		if(level.uox_teamplay && level.objective != "bel") //if team game
		{	//if allies are over the score limit
			if(level.alliedscore >= [[level.getVars]]("scr_scorelimit"))
				endRound("allies"); //end round in allies favor
			else //if allies didn't end the round, then axis must have
				endRound("axis"); //end round in axis favor
		}
		else //if free for all game
			endRound("deathmatch");	//end round in deathmatch mode
		return; //let endRound take over
	}

	level.mapended = true; //set map as ended
	iprintln(&"MPSCRIPT_SCORE_LIMIT_REACHED"); //announce score limit reached
	level thread endMap(); //end map
	
}

/* *************************************************************************************************
**** endMap()
****
**** Called from checkTimeLimit, checkScoreLimit, checkRoundLimit
**** ends current game, sets game to intermission, determines winner and shows scoreboard and 
**** loads next map
**** 
************************************************************************************************* */
endMap()
{
	
	if(!level.didFinalKillcam)
	{
		level notify("postround");
		level waittill("end_finalkillcam");
	}
	game["state"] = "intermission"; //sets game to intermission
	level notify("intermission"); //send intermission notify
	
	if(isdefined(level.bombs)) //for objective modes, disable bomb tick
	{
		if(isdefined(level.bombs["A"]))
			level.bombs["A"] stopLoopSound();
		if(isdefined(level.bombs["B"]))
			level.bombs["B"] stopLoopSound();
	}
	
	winners = ""; //init winner string
	losers = ""; //init loser string
	logToPrintW = ""; //init log print W string
	logToPrintL = ""; //init log print L string
	winner = "draw"; //init winner value to draw

	//Determine Winner
	if(level.uox_teamplay) //if team game
	{
		if(game["alliedscore"] == game["axisscore"]) //if score is tied
		{	//set scoreboard text to tie and winner to draw
			text = &"MPSCRIPT_THE_GAME_IS_A_TIE";
			winner = "draw";
		}
		else if(game["alliedscore"] > game["axisscore"]) //if allies have more points than axis
		{ //set scoreboard text to allies win and winner to allies
			text = &"MPSCRIPT_ALLIES_WIN";
			winner = "allies";
		}
		else //else the axis must have most points
		{ //set scoreboard text to axis win and winners to axis
			text = &"MPSCRIPT_AXIS_WIN";
			winner = "axis";
		}
		
	}
	else //if free for all game
	{
		winningPlayer = getHighScore(); //get high scoring player
		
		if(!winningPlayer.tied)
			winner = winningPlayer.name;
		
		if([[level.getVars]]("scr_score_rounds") && [[level.getVars]]("scr_roundreset"))
		{	//if scoring rounds over kills
			resetPlayerScores(); //reset scores

			players = getentarray("player", "classname"); //get players
			for(i = 0; i < players.size; i++) //loop players
			{
				player = players[i]; //current player
				player.score = player.pers["roundswon"]; //set score to rounds won
			}
		}		
	}
	
	
	
	players = getentarray("player", "classname"); //get players
	for(i = 0; i < players.size; i++) //loop through players
	{
		player = players[i]; //for current player
		lpGuid = player getGuid(); //get GUID

		player closeMenu(); //close any open menus
		player setClientCvar("g_scriptMainMenu", "main"); //set current esc menu to main menu
		if(level.uox_teamplay) //if team game
			player setClientCvar("cg_objectiveText", text); //change scoreboard text
		else //if free for all game
		{
			if(winner == "draw") //if tie, change scoreboard text to tie text
				player setClientCvar("cg_objectiveText", &"MPSCRIPT_THE_GAME_IS_A_TIE");
			else //else if there is a winner, set scoreboard to announce winner
				player setClientCvar("cg_objectiveText", &"MPSCRIPT_WINS", winner);
		}
		
		player maps\mp\uox\_uox_respawns::spawnIntermission(); //spawn player as spec at intermission
		//if allies won game
		if(winner == "allies")
		{	//if player is on allies
			if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "allies"))
				winners = (winners + ";" + lpGuid + ";" + players[i].name); //append to winners
			//if player is on axis
			else if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "axis"))
				losers = (losers + ";" + lpGuid + ";" + players[i].name); //append to losers
		} //if axis won game
		else if(winner == "axis")
		{	//if player is on allies
			if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "allies"))
				losers = (losers + ";" + lpGuid + ";" + players[i].name); //append to losers
			//if player is on axis
			else if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "axis"))
				winners = (winners + ";" + lpGuid + ";" + players[i].name); //append to winners
		} //if free for all player won game
		else if(winner != "draw")
		{	//add winner to winners string
			winners = lpGuid + ";" + winner;
		}
	}

	if(winner != "draw") //if game isn't a tie
	{
		if(winner == "allies") //allies won game
		{	//print to log
			logToPrintW = "W;allies;" + winners + "\n";
			logToPrintL = "L;axis;" + losers + "\n";
		}
		else if(winner == "axis") //axis won game
		{	//print to log
			logToPrintW = "W;axis;" + winners + "\n";
			logToPrintL = "L;allies;" + losers + "\n";
		}
		else //if free for all player won game
		{
			logToPrintW = "W;;" + winners + "\n";
		}
	}
	
	wait 1; //wait a second for scoreboard for auto screen shot

	if (getCvar("g_autoscreenshot") == "1") //if autoscreenshot
	{
		players = getentarray("player", "classname"); //get players
		for(i = 0; i < players.size; i++) //loop players
		{
			player = players[i]; //current player
		
			player autoScreenshot(); //screenshot scoreboard
		}
	}
	
	if(winner != "draw") //if winner is not a draw
	{
		if(logToPrintW != "") //is something to log
			logPrint(logToPrintW); //print winners to log
		if(logToPrintL != "") // if something to log
			logPrint(logToPrintL); //print losers to log
	}
	
	wait 10; //display scoreboard for 10 seconds
	exitLevel(false); //load next level
}

/* *************************************************************************************************
**** doGracePeriod( )
****
**** Called from startGame; startRound
**** Sets gameclock to green, sets graceperiod flag and waits before changing clock color back
**** if graceperiod flag is set, users can respawn without a reinforcement penalty and can change
**** weapon from menu while alive 
**** 
************************************************************************************************* */
doGracePeriod(gracetime)
{
	if(gracetime < 1) //if graceperiod is less than a second
		return; //don't bother
	
	if(isDefined(level.mainclock)) //if clock already exists just change color
		maps\mp\uox\_uox_hud::updateHUDMainClockColor( ( 0, 1, 0) );
	else //if clock doesn't exist
	{
		maps\mp\uox\_uox_hud::updateHUDMainClock(gracetime); //set clock
		maps\mp\uox\_uox_hud::updateHUDMainClockColor( ( 0, 1, 0) ); //change color
	}
		
	level.graceperiod = true; //set graceperiod flag
	
	wait gracetime; //wait for end of grace period
	//if multiple rounds and there is a timer or a single round with a timer 
	if(([[level.getVars]]("scr_roundlimit") !=1 && [[level.getVars]]("scr_roundlength")) || ([[level.getVars]]("scr_timelimit") > 0 && [[level.getVars]]("scr_roundlimit") == 1))
		maps\mp\uox\_uox_hud::updateHUDMainClockColor( ( 1, 1, 1 ) ); //change clock color back
	else //otherwise
		maps\mp\uox\_uox_hud::deleteHUDMainClock(); //delete the clock altogether
	
	level.graceperiod = false; //turn off grace period flag
}		

/* *************************************************************************************************
**** startGame( )
****
**** Called from gametype Callback_StartGametype function
**** Initializes game timer, starts match on non-round based games, starts round and team balanced
**** for round based games
**** 
************************************************************************************************* */
startGame()
{
	//get epoch time for current time (level var so it resets each round)
	level.starttime = getTime();

	//not currently in grace period
	level.graceperiod = false;
	
	//start Final Killcam Listener
	level thread maps\mp\uox\_uox_killcam::finalKillcamListener();
	
	//if timelimit is set
	if([[level.getVars]]("scr_timelimit") > 0)
	{
		//int game timer [[level.getVars]]("scr_timelimit") is in minutes, so is game["timepassed"] convert to seconds; 
		//subtract timed pass from time limit to get correct time instead of re-initing the timer after
		gameTimer = ([[level.getVars]]("scr_timelimit") * 60) - (game["timepassed"] * 60); //each round
		if([[level.getVars]]("scr_roundlimit") == 1) //if game is a single round, set game clock in bottom center
			maps\mp\uox\_uox_hud::updateHUDMainClock(gameTimer);
		else //if game will last multiple rounds then set game clock above the compass
			maps\mp\uox\_uox_hud::updateHUDCompassClock(gameTimer);
	}
	//if game is not round based (1 round and none of the following enabled: Warm up, Halftime, Overtime)
	if(!game["roundbased"]) 
	{	//get right into the action, don't bother starting round.
		game["matchstarted"] = true;
	}
	else //if the game is round based (or has one of the following enabled: Warm up, Halftime, Overtime)
	{	//start the round
		thread startRound();
		//if its a team game and teambalance is on, check for balanced teams
		if ( (level.uox_teamplay) && (level.teambalance > 0) && (!game["BalanceTeamsNextRound"])
			&& ([[level.getVars]]("scr_roundlimit") != 1 ))
			level thread maps\mp\gametypes\_teams::TeamBalance_Check_Roundbased();
		//if its a single round game 
		if([[level.getVars]]("scr_roundlimit") == 1)
			return; //then let the round hand the timelimit check
	}
	
	//start game timer loop
	maps\mp\uox\_uox_loops::addToLoop(level, "slow", ::checkTimeLimit, "checkTimeLimit");
	/*
	for(;;)
	{	//check time limit once a second.
		checkTimeLimit();
		wait 1;
	} */
}

/* *************************************************************************************************
**** checkTimeLimit()
****
**** Called from startGame loop, endRound 
**** Checks the game timelimit, if time passed is greater than the timelimit then the game ends, if
**** overtime is enabled, then run overtime in case of a tie 
****
************************************************************************************************* */
checkTimeLimit()
{
	if([[level.getVars]]("scr_timelimit") <= 0) //if no timelimit
		return; //nothing to check
	if(game["suddendeath"]) //in sudden death overtime
		return; //ignore timelimit
	if(level.roundended) //wait til next round to call time up
		return;
	if(level.mapended) //if map is already over 
		return; //no point in checking time limit
	//determine time passed since start of round
	timepassed = game["timepassed"] + ((getTime() - level.starttime) / 1000) / 60.0;
	
	if(timepassed < [[level.getVars]]("scr_timelimit")) //if less time than the timelimit has passed
		return; //exit
		
	if(!game["roundbased"]) //if game is not round based 
	{
		if([[level.getVars]]("scr_overtime")) //if overtime
		{
			thread doOvertime(); //do overtime
			return;
		}
		//just end the game if no overtime
		iprintln(&"MPSCRIPT_TIME_LIMIT_REACHED"); //announce time is over
	
		level.mapended = true; //set map ended flag
		level thread endMap(); //end map
	}
	else //if round based game, end round.
	{
		iprintln(&"MPSCRIPT_TIME_LIMIT_REACHED"); //announce time is over
		if([[level.getVars]]("scr_overtime")) //if overtime is enabled
		{ 	//check if game is tied
			if(checkTie([[level.getVars]]("scr_score_rounds")))
			{
				game["suddendeath"] = true;
			}
		}
		if(level.uox_teamplay) //if team game
		{ 
			//if game has defense and offense
			// defenders win round if time runs out
			if(isDefined(game["defenders"]))
			{
				incrementTeamScore(game["defenders"], level.defense_points);
				endRound(game["defenders"]);
			}
			else if(level.alliedscore == level.axisscore)
			{	//round was a tie
					endRound("draw");
			} //if allies have more score than axis
			else if(level.alliedscore > level.axisscore)
			{	//allies won the round
				endRound("allies");
			} //otherwise axis scored more than allies
			else
			{	//axis won the round
				endRound("axis");
			}
		}
		else //free for all game
			endRound("deathmatch");
	}
}

/* *************************************************************************************************
**** startRoundTimer()
****
**** Called from startRound, _uox_bombs
**** starts round timer, if timer reaches the end, the round ends
****
************************************************************************************************* */
startRoundTimer(timer, doGracePeriod)
{
	//kill on bomb_plant
	level endon("timer_paused");	
	
	if(!isDefined(doGracePeriod))
		doGracePeriod = false;
	
	if([[level.getVars]]("scr_roundlength") <= 0) //if no timelimit
		return; //nothing to check
	if(game["suddendeath"]) //in sudden death overtime
		return; //ignore timelimit
	if(level.roundended) //wait til next round to call time up
		return;
	if(level.mapended) //if map is already over 
		return; //no point in checking time limit
	//update main clock
	maps\mp\uox\_uox_hud::updateHUDMainClock(timer);
	if(doGracePeriod) //run grace period
		level thread doGracePeriod([[level.getVars]]("scr_graceperiod"));
		
	//wait for round timer
	wait(timer);
	
	//start round end on timer
	if(level.roundended)//if round already ended, nothing to do
		return;

	//announce that time has expired
	announcement(&"GMI_CTF_TIMEEXPIRED");
	 
	if(level.uox_teamplay) //if team game
	{ 
		//if game has defense and offense
		// defenders win round if time runs out
		if(isDefined(game["defenders"]))
		{
			incrementTeamScore(game["defenders"], level.defense_points);
			endRound(game["defenders"]);
		}
		else if(level.alliedscore == level.axisscore)
		{	//round was a tie
				endRound("draw");
		} //if allies have more score than axis
		else if(level.alliedscore > level.axisscore)
		{	//allies won the round
			endRound("allies");
		} //otherwise axis scored more than allies
		else
		{	//axis won the round
			endRound("axis");
		}
	}
	else //if free for all game
	{	//determine who won round later
		endRound("deathmatch");
	}	
}

/* *************************************************************************************************
**** startRound()
****
**** Called from startGame 
**** Initializes round timer, does grace period and waits for timer to expire before ending round.
**** Is killed by "bomb_plant" notify so that round doesn't end during an active bomb
**** 
************************************************************************************************* */
startRound()
{	
	
	// round does not start until the match starts
	if ( !game["matchstarted"] )
		return;
		
	//set roundstarted flag
	level.roundstarted = true;
	
	//get epoch time for round start
	level.roundstarttime = getTime();
	
	//if game is a single round (but uses warm up or OT)
	if([[level.getVars]]("scr_roundlimit") == 1)
	{	//set timer to the game time limit
		timer = ([[level.getVars]]("scr_timelimit") * 60) - (game["timepassed"] * 60);
	}
	else//otherwise
	{	//set time to the round time limit
		timer = level.roundlength * 60;
	}
	
	level startRoundTimer(timer, true);
}

/* *************************************************************************************************
**** checkMatchStart()
****
**** Called from spawnPlayer 
**** Checks teams, if both teams have players (or if 2 players have joined on free for all games)
**** then it starts warmup or ready up mode if enabled. When warm up is done or players are ready
**** it restarts round with the game["matchstarted"] flag set to true
**** 
************************************************************************************************* */
checkMatchStart()
{
	if(!game["roundbased"])
		return;
	//save current team status
	oldvalue["teams"] = level.exist["teams"];
	level.exist["teams"] = false; //set team status to false

	if(level.uox_teamplay) //if team game
	{	//if exist flag for allies and axis both are set to true
		if(level.exist["allies"] && level.exist["axis"])
			level.exist["teams"] = true; //then teams exist, set flag to true
	}
	else //if free for all game
	{
		if(level.exist["2players"] > 0) //if number of players - 1 is greater than 0.
			level.exist["teams"] = true; //multiple players are playing, set flag to true
	}
	// If teams previously did not exist and now they do
	if(!oldvalue["teams"] && level.exist["teams"])
	{	
		if(!game["matchstarted"]) //if game hasn't started yet
		{
			if(!level.roundended) //and game isn't over
			{
				if([[level.getVars]]("scr_warmupmode") > 0) //and warm up or ready up is enabled
				{
					
					if([[level.getVars]]("scr_warmupmode") == 1) //if warmup mode is set to warm up
						maps\mp\uox\_uox_warmup::DoWarmUp();
					else	//if warmup mode is set to ready up
						maps\mp\uox\_uox_warmup::DoReadyUp();
				}
			}	
			//After waiting for Warm up/Ready up
			//announce that the game is going to start
			announcement(&"SD_MATCHSTARTING");

			//send a notify stop any round end in progress
			level notify("kill_endround");
			level.roundended = false; //set round ended flag to false
			level thread endRound("reset"); //run round end reset
		}
		else // game has already started
		{	//announce that match is resuming again
			announcement(&"SD_MATCHRESUMING");

			//send notify to kill any round ends in progress
			level notify("kill_endround");
			level.roundended = false; //set round ended flag to false
			level thread endRound("draw"); //score round as a draw
		}
		//exit thread
		return;
	}
}

/* *************************************************************************************************
**** endRound(string roundwinner, boolean doKillcam)
****
**** Called from updateTeamStatus, checkScoreLimit, startRound, 
**** Handles end of round logic. roundwinner can be a team that won the round, deathmatch for free
**** for all games, draw, or reset. doKillcam flag is to specify whether to wait for a final killcam
**** 
************************************************************************************************* */
endRound(roundwinner)
{
	//overtime check for single round games
	if(roundwinner == "deathmatch" && [[level.getVars]]("scr_roundlimit") == 1
		&& [[level.getVars]]("scr_overtime") && checkTie(false)) //if tied and a single round game
	{ 
		thread doOvertime();
		return;
	} 
	
	if(roundwinner == "half")
		doHalftime = true;
	else
		doHalftime = false;
	
	level.switchprevent = false; //allow player to switch teams at end of round
	level endon("kill_endround"); //abort end round if notify is sent

	if(level.roundended) //if round already ended
		return; //nothing to do
	level.roundended = true; //set roundend flag
	
	//lock players in place
	level.playerlock = true;
	level thread lockPlayersInPlace();

	// End bombzone threads and remove related hud elements and objectives
	level notify("round_ended");

	players = getentarray("player", "classname"); //get players
	for(i = 0; i < players.size; i++) //loop players
	{
		player = players[i]; //for current player

		player unlink(); //unlink from objective
		player enableWeapon(); //re-enable weapon if disabled by objective
		//clear uox hud elements
		player maps\mp\uox\_uox_hud::clearClientHUD();
	}

	objective_delete(0); //delete objective A
	objective_delete(1); //delete objective B

	if(roundwinner == "allies") //if roundwinner was allies
	{ 	//get players
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++) //loop players
			players[i] playLocalSound("MP_announcer_allies_win"); //make audio announcement
		game["alliesRoundsWon"]++;
		//increment allied score
		if([[level.getVars]]("scr_score_rounds"))
		{
			game["alliedscore"] = game["alliesRoundsWon"];
		}
		setTeamScore("axis", game["axisscore"]);
		setTeamScore("allies", game["alliedscore"]); //set team score
	}
	else if(roundwinner == "axis") //if roundwinner was axis
	{	//get players
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++) //loop players
			players[i] playLocalSound("MP_announcer_axis_win"); //make audio announcement
		//increment axis score
		game["axisRoundsWon"]++;
		if([[level.getVars]]("scr_score_rounds"))
		{
			game["axisscore"] = game["axisRoundsWon"];
		}
		setTeamScore("axis", game["axisscore"]);
		setTeamScore("allies", game["alliedscore"]); //set team score
	}
	else if(roundwinner == "draw") //if game was a tie
	{ 	//get players
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++) //loop players
			players[i] playLocalSound("MP_announcer_round_draw"); //make audio announcement
		setTeamScore("axis", game["axisscore"]);
		setTeamScore("allies", game["alliedscore"]); //set team score
	}
	
//	if(!isDefined([[level.getVars]]("scr_killcam")Failsafe))
//		level thread maps\mp\uox\_uox_killcam::killcam_failsafe();

	maps\mp\uox\_uox_hud::updateServerScoreboard();
	wait 5; //wait five seconds before ending round

	winners = ""; //init winners log string
	losers = "";  //init losers log string
	tied = false; //init tied flag
	if(roundwinner == "allies") //if allies win
	{		
		if(game["half"] % 2) //if 1st Half
		{
			if(game["team1"] == "allies") //if team 1 are the allies
				game["round1team1score"]++; //increment team 1 score for the half
			else //if team 2 are the allies
				game["round1team2score"]++; //increment team 2 score for the half
		}
		else //if 2nd Half
		{
			if(game["team1"] == "allies") //if team 1 are the allies
				game["round2team1score"]++; //increment team 1 score for the half
			else //if team 2 are the allies
				game["round2team2score"]++; //increment team 2 score for the half
		}
		//get players
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++) //loop players
		{	//get player guid 
			lpGuid = players[i] getGuid();
			//if player is on allies
			if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "allies"))
				winners = (winners + ";" + lpGuid + ";" + players[i].name); //append to winners
			//if player is on axis
			else if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "axis"))
				losers = (losers + ";" + lpGuid + ";" + players[i].name); //append to losers
		}
/*		if(level.clutchsituation["allies"])
		{
			lpattackname = level.clutchplayer["allies"].name;
			lpattackerteam = "allies";
			lpattackguid = level.clutchplayer["allies"] getGuid();
			lpattacknum = level.clutchplayer["allies"] getEntityNumber();
			logPrint("A;" + lpattackguid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + "sd_clutch" + "\n");
			iprintln("ROUND CLUTCH: " + lpattackname);
		}
		
		if(level.acesituation["allies"])
		{
			lpattackname = level.aceplayer["allies"].name;
			lpattackerteam = "allies";
			lpattackguid = level.aceplayer["allies"] getGuid();
			lpattacknum = level.aceplayer["allies"] getEntityNumber();
			logPrint("A;" + lpattackguid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + "sd_ace" + "\n");
			iprintln("ROUND ACE: " + lpattackname);
		}
*/
		logPrint("RW;allies;" + winners + "\n"); //print round win to log
		logPrint("RL;axis;" + losers + "\n");	 //print round loss to log
	}
	else if(roundwinner == "axis") //if round was won by axis
	{ 			
		if(game["half"] % 2) //if 1st Half
		{
			if(game["team1"] == "axis") //if team 1 are the axis
				game["round1team1score"]++; //increment team 1 score for the half
			else //if team 2 are the allies
				game["round1team2score"]++; //increment team 2 score for the half
		}
		else //if 2nd Half
		{
			if(game["team1"] == "axis") //if team 1 are the axis
				game["round2team1score"]++; //increment team 1 score for the half
			else //if team 2 are the allies
				game["round2team2score"]++; //increment team 2 score for the half
		}

		players = getentarray("player", "classname"); //get players
		for(i = 0; i < players.size; i++) //loop players
		{	//get player GUID
			lpGuid = players[i] getGuid();
			//if player is axis team
			if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "axis"))
				winners = (winners + ";" + lpGuid + ";" + players[i].name); //append to winners
			//if player is allied team
			else if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "allies"))
				losers = (losers + ";" + lpGuid + ";" + players[i].name); //append to losers
		}
/*		if(level.clutchsituation["axis"])
		{
			lpattackname = level.clutchplayer["axis"].name;
			lpattackerteam = "axis";
			lpattackguid = level.clutchplayer["axis"] getGuid();
			lpattacknum = level.clutchplayer["axis"] getEntityNumber();
			logPrint("A;" + lpattackguid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + "sd_clutch" + "\n");
			iprintln("ROUND CLUTCH: " + lpattackname);
		}
		
		if(level.acesituation["axis"])
		{
			lpattackname = level.aceplayer["axis"].name;
			lpattackerteam = "axis";
			lpattackguid = level.aceplayer["axis"] getGuid();
			lpattacknum = level.aceplayer["axis"] getEntityNumber();
			logPrint("A;" + lpattackguid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + "sd_ace" + "\n");
			iprintln("ROUND ACE: " + lpattackname);
		} */
		
		logPrint("RW;axis;" + winners + "\n"); //log round win
		logPrint("RL;allies;" + losers + "\n");//log round loss
	}
	else if(roundwinner == "deathmatch") //if free for all gametype
	{
		winner = getHighScore(); //get highest scoring player
		tied = winner.tied;		 //store tied flag to var
		guid = winner.guid;		 //winner guid
		name = winner.name;		 //winner name
		
		if(!tied) //if game tied flag was not set
		{
			winners = (winners + ";" + guid + ";" + name); //set winners to highest scoring player
			winner.pers["roundswon"]++; //increment rounds won
			
			if([[level.getVars]]("scr_score_rounds")) //if score rounds is set
			{
				if(game["half"] % 2) //if game is in 1st Half
					winner.pers["1HScore"]++; //increment 1st half score rounds won
				else //if game is in second half
					winner.pers["2HScore"]++; //increment 2nd half score rounds won
				//get rounds won leader
				leader = getHighScore(true);
				if(game["half"] % 2) //if game is in 1st half
					game["round1axisscore"] = leader.pers["1HScore"]; //set leader round 1 score
				else //if game is in 2nd half
					game["round2axisscore"] = leader.pers["2HScore"]; //set leader round 2 score
			}
			else //if score method is total score
			{
				if(game["half"] % 2) //if game is in 1st half
					game["round1axisscore"] = winner.score; //set half score
				else //if game is in 2nd half
					game["round2axisscore"] = winner.score; //set half score
			}
			//print round win to log
			logPrint("RW;deathmatch;" + winners + "\n");
		}
	}
	//determine time passed since start of round
	game["timepassed"] = game["timepassed"] + ((getTime() - level.starttime) / 1000) / 60.0;

	// for all living players store their weapons
	if(game["matchstarted"]){ //only do if game started
		players = getentarray("player", "classname"); //get players
		for(i = 0; i < players.size; i++) //loop players
		{	//for current player
			player = players[i];
			//if player is on a team and player is playing
			if(isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
			{	
				primary = player getWeaponSlotWeapon("primary"); //get slot 1 weapon
				primaryb = player getWeaponSlotWeapon("primaryb");//get slot 2 weapon

				// If a menu selection was made
				if(isDefined(player.oldweapon))
				{
					// If a new weapon has since been picked up (this fails when a player picks up a weapon the same as his original)
					if(player.oldweapon != primary && player.oldweapon != primaryb && primary != "none")
					{
						player.pers["weapon1"] = primary; //set next round slot 1 to current slot 1
						player.pers["weapon2"] = primaryb; //set next round slot 2 to current slot 2
						player.pers["spawnweapon"] = player getCurrentWeapon(); //set inital weapon
					} // If the player's menu chosen weapon is the same as what is in the primaryb slot, swap the slots
					else if(player.pers["weapon"] == primaryb)
					{
						player.pers["weapon1"] = primaryb; //set current slot 2 to slot 1
						player.pers["weapon2"] = primary; //set current slot 1 to slot 2
						player.pers["spawnweapon"] = player.pers["weapon1"]; //set intial weapon
					} // Give them the weapon they chose from the menu
					else
					{
						player.pers["weapon1"] = player.pers["weapon"]; //keep current menu selection
						player.pers["weapon2"] = primaryb; //give picked up slot 2 weapon
						player.pers["spawnweapon"] = player.pers["weapon1"]; //set current weapon
					}
				} // No menu choice was ever made, so keep their weapons and spawn them with what they're holding, unless it's a pistol or grenade
				else
				{
					if(primary == "none") //if no weapon was selected (because all are restricted)
						player.pers["weapon1"] = player.pers["weapon"]; //set slot 1 to current
					else //if a primary is selected
						player.pers["weapon1"] = primary; //set slot 1 to selected weapon
						
					player.pers["weapon2"] = primaryb; //set slot 2 to current slot 2 weapon

					spawnweapon = player getCurrentWeapon(); //set to spawn with current weapon
					if ( (spawnweapon == "none") && (isdefined (primary)) ) //if no selection
						spawnweapon = primary; //spawn with current slot 1
					//if you weren't currently holding a pistol or grenade
					if(!maps\mp\gametypes\_teams::isPistolOrGrenade(spawnweapon)) 
						player.pers["spawnweapon"] = spawnweapon; //set spawn weapon to current
					else
						player.pers["spawnweapon"] = player.pers["weapon1"]; //set spawn weapon to slot1
				}
			}
		}
	}

	//send notify that game is in post round
	level notify("postround");
/*	if(doKillcam) //if final killcam flag is set
	{
		game["finaldelay"] = (getTime() - game["finaldelay"]) / 1000; //get how long ago the killcam was
		level waittill("final_killcam_over"); //wait until kilcam is over
	}
*/
	level waittill("end_finalkillcam");
	if(game["matchstarted"]) //if game is in progress (not pregame)
	{
		if( ([[level.getVars]]("scr_countdraws") && (roundwinner == "draw" || tied) )
			|| (roundwinner != "draw" && roundwinner != "half"))
			//if draws count or game was not a draw
			game["roundsplayed"]++; //increment number of rounds played
				
		if(game["suddendeath"] && !checkTie([[level.getVars]]("scr_score_rounds"))) //if in sudden death and game in not tied
		{
			if(level.mapended) //if map already ended
				return;	//nothing to do
			level.mapended = true; //set map ended flag
			
			iprintln(&"MPSCRIPT_SCORE_LIMIT_REACHED"); //announce score limit has been reached
			maps\mp\uox\_uox_hud::createHUDEndRoundScore([[level.getVars]]("sv_endRoundScoreboardTime"), true, false); //update final scoreboard
			
			level thread endMap(); //end map
			return; //exit
		}
		
		checkRoundLimit(); //make sure we haven't hit round limit
		checkScoreLimit(); //make sure we haven't hit score limit
	}

	//if game has been started and a reset was requested
	if(!game["matchstarted"] && roundwinner == "reset")
	{	//set game started flag
		game["matchstarted"] = true;
		thread resetScores();	//reset the warmup scores
		game["roundsplayed"] = 0; //set rounds played to 0
	}

	checkTimeLimit(); //check that time limit wasn't reached during round end

	if(level.mapended) //if map has already ended
		return;	//nothing to do
	level.mapended = true; //set map ended flag to true

	if ( (level.teambalance > 0) && (game["BalanceTeamsNextRound"]) )
	{ //if teams are marked to balanced and teambalance is enforced
		level.lockteams = true; //don't let players switch team
		level thread maps\mp\gametypes\_teams::TeamBalance(); //start team balance routine
		level thread maps\mp\uox\_uox_utils::notifyLater("Teams Balanced", 15);
		level waittill ("Teams Balanced"); //wait until teams are balanced
		wait 4; //give us a second to reset
	}
		
	/* Next Round Timer */
	maps\mp\uox\_uox_hud::createHUDNextRound([[level.getVars]]("sv_endRoundScoreboardTime"), false, doHalftime);
	
	if([[level.getVars]]("scr_roundreset")) //if scores are set to reset each round
	{
		resetPlayerScores(); //reset the player scores
	}

	map_restart(true); //reload map for next round
}

/* *************************************************************************************************
**** updateTeamStatus ()
****
**** Called from Callback_PlayerDisconnect, Callback_PlayerKilled, spawnSpectator, spawnPlayer 
**** Checks that there are still players alive and playing. If not then it ends round/game
**** 
************************************************************************************************* */
updateTeamStatus()
{
	wait 0;	// Required for Callback_PlayerDisconnect to complete before updateTeamStatus can execute
	
	resettimeout(); //no idea what this does

    oldvalue["allies"] = level.exist["allies"]; //store alive allies
    oldvalue["axis"] = level.exist["axis"];		//store alive axis
    level.exist["allies"] = 0; //reset alive allies
    level.exist["axis"] = 0; //reset alive axis
    oldvalue["2players"] = level.exist["2players"]; //store alive players
    level.exist["2players"] = -1; //reset alive players

	//get players
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++) //loop players
	{
		player = players[i]; //for current player
		//if player is on a team and team isn't spectator and round isn't started or player lives aren't 
		//defined or player has lives left or player doesn't have lives left but it doesn't matter 
		//because reinforcements are set to unlimited
		if(isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && (!level.roundstarted || !isDefined(player.lives) || player.lives > -1 || (player.lives < 0 && [[level.getVars]]("scr_reinforcements") == -1)))
		{
            level.exist[player.pers["team"]]++; //increment number of alive players on team
            level.exist["2players"]++; //increment number of alive players in general
		}
	}

    if(level.exist["allies"]) //if allies have players allive
        level.didexist["allies"] = true; //mark allied did exist flag as true
    if(level.exist["axis"]) // if axis have players alive
        level.didexist["axis"] = true; //mark axis did exist flag as true
    if(level.exist["2players"]) //if there are 2 players alive
        level.didexist["2players"] = true; //mark 2 players alive flag as true
	
	if(level.roundended) //if round already ended
		return; //nothing else to do, return
	
    if([[level.getVars]]("scr_respawn_mode") == "bel") //move players over if spawn type is bel
    {
        alliesallowed = (level.exist["axis"] * 1.0) / [[level.getVars]]("scr_playerRatio");
        if(alliesallowed < 1)
            alliesallowed = 1;
        if (level.exist["allies"] == alliesallowed)
    	{
    		return;
    	}
    	
    	if (level.exist["allies"] < alliesallowed)
    	{
    		randomMoveTeams("axis");

    		if (alliesallowed > 1)
    			iprintln(&"BEL_ADDING_ALLIED");

    		return;
    	}
    	
    	if (level.exist["allies"] > (alliesallowed + 1))
    	{
    		randomMoveTeams("allies");
    		iprintln(&"BEL_REMOVING_ALLIED");
    		return;
    	}
    	if ( (level.exist["allies"] > alliesallowed) && (alliesallowed == 1) )
    	{
    		randomMoveTeams("allies");
    		iprintln(&"BEL_REMOVING_ALLIED");
    		return;
    	}
    }

	if(level.uox_teamplay) //if  team game
	{	
        //if allies did exist and now they don't and axis did exist and they don't either
		if(oldvalue["allies"] && !level.exist["allies"] && oldvalue["axis"] && !level.exist["axis"])
		{	//for objective modes, if the bomb is not planted
			if(!level.bombsites["A"]["planted"] && !level.bombsites["B"]["planted"])
			{	//score round as a draw
				announcement(&"SD_ROUNDDRAW"); //announce the draw
				level thread endRound("draw"); //run draw endRound
				return;	
			}
			//for objective modes, if bomb is planted favor attackers
			if(game["attackers"] == "allies") //if allies are the attackers
			{
				announcement(&"SD_ALLIEDMISSIONACCOMPLISHED"); //announce that allies won on objective
				level thread endRound("allies"); //end round for allies
				return;
			}
			//if the axis were the attackers
			announcement(&"SD_AXISMISSIONACCOMPLISHED"); //announce that axis won on objective
			level thread endRound("axis"); //end round for axis
			return;
		}
		//if allies did exist and now they don't (and the above didn't match)
		if(oldvalue["allies"] && !level.exist["allies"])
		{
			// for objective modes, no bomb planted, axis win
			if(checkObjective())
			{
				announcement(&"SD_ALLIESHAVEBEENELIMINATED"); //announce that allies are all dead
				//end round for axis, do killcam if the flag for the last allies killed is true
				level thread endRound("axis");
				return;
			}
			// in objective modes if the allies are attackers and the bomb is planted
			if(game["attackers"] == "allies")
				return; //nothing left to do
			
			// allies just died and axis have planted the bomb
			if(level.exist["axis"]) //if axis are still alive
			{
				announcement(&"SD_ALLIESHAVEBEENELIMINATED"); //announce allies are all dead
				//end round for axis, do killcam if the flag for the last allies killed is true
				level thread endRound("axis");
				return;
			}
			//if the axis are not alive
			announcement(&"SD_AXISMISSIONACCOMPLISHED"); //announce that the axis won on objective
			level thread endRound("axis");
			return;
		}
		//if axis did exist and now they don't (and the allies still exist based on nonmatches above)
		if(oldvalue["axis"] && !level.exist["axis"])
		{
			// for objective, no bomb planted, allies win
			if(checkObjective())
			{	
				announcement(&"SD_AXISHAVEBEENELIMINATED"); //announce the last axis just died
				//end round for axis, if flag for last axis killed is set to true, do final killcam
				level thread endRound("allies",level.axisLastKilled); 
				return;
			}
			//in objective if axis are the attackers and the bomb is planted
			if(game["attackers"] == "axis")
				return; //nothing left to do
			
			// axis just died and allies have planted the bomb
			if(level.exist["allies"])
			{
				announcement(&"SD_AXISHAVEBEENELIMINATED"); //announc that the last axis just died
				//end round for axis, if flag for last axis killed is set to true, do final killcam
				level thread endRound("allies");
				return;
			}
			//if allies are not alive
			announcement(&"SD_ALLIEDMISSIONACCOMPLISHED"); //announce that allies won on objective
			level thread endRound("allies"); //end round for allies
			return;
		}
	}
	else//if free for all game mode
	{
		//if players used to exist and now no players exist
		if(oldvalue["2players"] > 0 && level.exist["2players"] == -1)
		{
			announcement(&"SD_ROUNDDRAW"); //score round as draw
			level thread endRound("draw"); //run end round draw
			return;
		}
		//if multiple players used to exist and now 1 player exists
		else if(oldvalue["2players"] > 0 && !level.exist["2players"])
		{
			iprintlnbold("All players have been eliminated"); //announce players have been eliminated
			level thread endRound("deathmatch"); //run round end as deathmatch
			return;
		}
	}
}

/* *************************************************************************************************
**** checkRoundLimit ()
****
**** Called from endRound 
**** Checks that rounds played does not exist round limit. Checks if there should be a halftime break
**** between this round and the next. Also checks if we should play a few additional OT if game is 
**** still tied
**** 
************************************************************************************************* */
checkRoundLimit()
{
	//if roundlimit is set to 0 or less, interpret that as no round limit
	if([[level.getVars]]("scr_roundlimit") <= 0)
		return; //nothing to check if no round limit
	
	//if rounds played is greater than the round limit, we are in OT
	if(game["roundsplayed"] > [[level.getVars]]("scr_roundlimit"))
	{
		//if the number of rounds over regulation divided by the rounds per OT has a remainder
		if((game["roundsplayed"] - [[level.getVars]]("scr_roundlimit")) % [[level.getVars]]("scr_ot_roundlimit"))
			//then the next OT is in progress (rounds played over limit divided by round per OT plus 1)
			OT = ((game["roundsplayed"] - [[level.getVars]]("scr_roundlimit")) / [[level.getVars]]("scr_ot_roundlimit")) + 1;
		else //if the number over rounds over regulation divided by rounds per OT divides cleanly
			//then the OT that we are in is that number
			OT = (game["roundsplayed"] - [[level.getVars]]("scr_roundlimit")) / [[level.getVars]]("scr_ot_roundlimit");
		//get the round limit for the current overtime
		roundlimit = [[level.getVars]]("scr_roundlimit") + ([[level.getVars]]("scr_ot_roundlimit") * OT);
		//get the halftime round number for current overtime
		//if number of OT rounds is odd
		if([[level.getVars]]("scr_ot_roundlimit") % 2) 
			//then half round is rounded up to the nearest whole number
			halfround = (roundlimit - [[level.getVars]]("scr_ot_roundlimit")) + (([[level.getVars]]("scr_ot_roundlimit") / 2) + 1);
		else //if the number of OT rounds is even
			//then half round is half the number of rounds per OT
			halfround = (roundlimit - [[level.getVars]]("scr_ot_roundlimit")) + ([[level.getVars]]("scr_ot_roundlimit") / 2);
	}
	else // if rounds play is equal to the limit or below, game isn't in OT
	{
		roundlimit = [[level.getVars]]("scr_roundlimit"); //round limit
		halfround = level.halfround; //halftime round
	}
	round = game["roundsplayed"]; //current round
	
	if([[level.getVars]]("scr_score_rounds")) //if scoring rounds
	{
		//check if someone won game
		if(!checkGameWon( true, round, roundlimit ))
		{ //if no one has won the game, check if it is halftime
			if(checkHalfTime( true, round, halfround, roundlimit ))
			{		
				doHalftime(); //switch sides if necessary, take a half time break if necessary
			}
			return; //nobody won so don't end the game
		}
	}
	else if(round < roundlimit || (checkTie(false) && [[level.getVars]]("scr_overtime")))
	{ //just check roundlimit hasn't been reached (or that its not tied if it has) if not scoring rounds
		return;
	}
	//if map already ended
	if(level.mapended)
		return; //then nothing left to do
	level.mapended = true; //set round ended flag to true
	
	iprintln(&"MPSCRIPT_ROUND_LIMIT_REACHED"); //announce in feed that round limit reached
	maps\mp\uox\_uox_hud::createHUDEndRoundScore([[level.getVars]]("sv_endRoundScoreboardTime"), true, false); //create game over scoreboard
	
	level thread endMap(); //end map
}

/* *************************************************************************************************
**** checkHalfTime(boolean checkRounds, int roundScore, int RoundScoreHalf, int roundScoreLimit)
****
**** Called from checkRoundLimit 
**** Checks if a halftime break needs to be taken. if checkRounds is false then roundScore, 
**** roundScoreHalf, and roundScoreLimit should be the scorelimit that needs to be met to do half.
**** if checkRounds is true the these values should be the roundlimit that needs to be met to do half
**** if half should be done, return true
**** 
************************************************************************************************* */
checkHalfTime(checkRounds, roundScore, roundScoreHalf, roundScoreLimit)
{
	//if halftime is not enabled, nothing to do
	if(![[level.getVars]]("scr_halftime"))
		return false;
	
	//if round/score is less than designated half then return false
	if(roundScore < roundScoreHalf)
		return false;
	//if the current round/score is at the designated half then return true, if designated half is equal
	else if(roundScore == roundScoreHalf && roundScoreHalf != roundScoreLimit) //to limit, then skip
		return true;
	//if round/score is beyound the designated half but before the limit, return false
	else if(roundScore < roundScoreLimit)
		return false;
	//if match should be over but still tied then run halftime and start a new OT
	else if([[level.getVars]]("scr_overtime") && roundScore == roundScoreLimit && checkTie(checkRounds))
		return true;
	
	//match will end in tie
	return false;
}

/* *************************************************************************************************
**** checkTie()
****
**** Called from checkHalfTime, doOvertime, checkTimeLimit, endRound
**** Checks if game is tied and returns true if it is or false if it is not
**** 
************************************************************************************************* */
checkTie(checkRounds)
{
	//if team game
	if(level.uox_teamplay)
	{
		if(game["alliedscore"] == game["axisscore"]) //if allies and axis score is the same
			return true; //game is currently tied
		else //if allies and axis do not have same score
			return false; //game is not tied	
	}
	//if free for all game
	if(checkRounds) //if checking rounds won
	{
		firstplace = maps\mp\uox\_uox::getHighScore(true); //get first place player
		secondplace = maps\mp\uox\_uox::getSecondPlace(firstplace, true); //get second place player
		if(!isDefined(firstplace)) rw1p = 0; else rw1p = firstplace.roundsWon; //set rw1p to roundsWon
		if(!isDefined(secondplace)) rw2p = 0; else rw2p = secondplace.roundsWon; //set rw2p to roundsWon
	}
	else //if checking score
	{
		firstplace = maps\mp\uox\_uox::getHighScore(); //get first place player
		secondplace = maps\mp\uox\_uox::getSecondPlace(firstplace); //get second place player
		if(!isDefined(firstplace)) rw1p = 0; else rw1p = firstplace.score; //set rw1p to player score
		if(!isDefined(secondplace)) rw2p = 0; else rw2p = secondplace.score; //set rw2p to player score
	}

	if(rw1p == rw2p) // if roundsWon/Score between first and second place are the same
		return true; // the game is currently tied
	else //if roundsWon/Score between first and second place are not the same
		return false; //the game is not tied
		
	return false;
}

/* *************************************************************************************************
**** checkGameWon()
****
**** Called from checkRoundLimit
**** Checks if one player or one team (depending whether it is a team or free for all game) 
**** returns true if one player or one team has won the game, otherwise returns false
**** 
************************************************************************************************* */
checkGameWon(checkRounds, roundScore, roundScoreLimit)
{
	if(level.uox_teamplay) //if team game
	{
		if(checkRounds) //if checking rounds won
		{
			fiftyplus1 = getWinningRoundNum(roundScore, roundScoreLimit);
			//get majority score number
			
			//if both teams have less than a majority then neither have won.
			if(game["alliedscore"] < fiftyplus1 && game["axisscore"] < fiftyplus1)
				return false; //no winner yet
		}
		else //if checking score
		{
			//if both teams have less than the score limit then neither have won
			if(game["alliedscore"] < roundScoreLimit && game["axisscore"] < roundScoreLimit)
				return false; //no winner yet
		}
		return true; //if one team breached the round/score limit then the game is over (i think)
	}
	else //if free for all game
	{
		if(checkRounds) //if checking rounds won
		{
			fiftyplus1 = getWinningRoundNum(roundScore, roundScoreLimit);
			//if highscore is less than the winning round number then no one has won the game
			leader = getHighScore(true); //number of rounds first place has over second.
			if(leader.roundsWon < fiftyplus1 && !leader.tied) //if there are enough rounds for 2nd to at least tie
				return false; //then game is not won yet
			else //the lead is greater than the number of roundsRemaining
				return true;
		}
		else //if checking score 
		{
			//get array of current players
			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
			{
				player = players[i]; //set player to current loop iteration
				if(player.score >= roundScoreLimit) //if a player has reached the score limit
					return true; //somebody has won the game
			}
			//if loop finishes, no one reached the score limit so game couldn't have been won
			return false;
		}
	}
}

getWinningRoundNum(round, roundLimit)
{
	roundsRemaining = roundLimit - round;
	
	if(level.uox_teamplay)
	{
		if(getTeam2Score() > getTeam1Score())
		{
			rwA = getTeam2Score();
			rwB = getTeam1Score();
		}
		else
		{
			rwA = getTeam1Score();
			rwB = getTeam2Score();
		}
	}
	else
	{
		firstplace = getHighScore(true); //get first place player
		secondplace = getSecondPlace(firstplace, true); //get second place player
		//set rw1p to the # of rounds won by first place player
		if(!isDefined(firstplace)) rwA = 0; else rwA = firstplace.roundsWon;
		//set rw2p to the # of rounds won by the second place player
		if(!isDefined(secondplace)) rwB = 0; else rwB = secondplace.roundsWon;
	}
	scores = rwA + rwB;
	return ((roundsRemaining + scores)/2) + 1;
}

/* *************************************************************************************************
**** doHalftime()
****
**** Called from checkRoundLimit, checkScoreLimit, checkTimeLimit 
**** does the halftime break. Does ready up or warmup if set. switches sides if necessary
**** 
************************************************************************************************* */
doHalftime(midRound)
{
	//if midRound flag isn't set
	if(!isDefined(midRound))
		midRound = false;
	
	switchSides = false;
	//always switch side at half time
	if(game["half"] % 2)
		switchSides = true;
	else //determine if need to switch sides before OT
	{
		if(level.uox_teamplay) //if team game
		{
			//if map does not define attackers/defenders then switch
			if(!isDefined(game["defenders"]))
				switchSides = true;
			else //if attackers/defenders are defined
			{ 	//determine which team are which role
				if(game["team1"] == game["defenders"])
					defenders = game["team1"];
				else if(game["team1"] == game["attackers"])
					attackers = game["team1"];
				if(game["team2"] == game["defenders"])
					defenders = game["team2"];
				else if(game["team2"] == game["attackers"])
					attackers = game["team2"];
			}
			//if roles were determined
			if(isDefined(attackers) && isDefined(defenders))
			{
				//set defender Kills
				if(defenders == game["team1"])
					defenderKills = getTeam1Kills();
				else
					defenderKills = getTeam2Kills();
				//set attacker Kills
				if(attackers == game["team2"])
					attackerKills = getTeam2Kills();
				else
					attackerKills = getTeam1Kills();
				//if defenders don't get more kills then switch sides
				if(defenderKills <= attackerKills)
					switchSides = true;
			}
			else //if roles couldn't be determined, just switch
				switchSides = true;
		}
		else //free for all game
			switchSides = true; //always switch
	}
	//increment half
	game["half"] = game["half"] + 1;
	
	if(switchSides)
	{
		//switch scores
		axistempkills = game["axiskills"];
		axistempscore = game["axisscore"];
		axistemplscore = level.axisscore;
		axistemproundswon = game["axisRoundsWon"];
		game["axisscore"] = game["alliedscore"];
		level.axisscore = level.alliedscore;
		game["axisRoundsWon"] = game["alliesRoundsWon"];
		setTeamScore("axis", game["alliedscore"]);
		game["alliedkills"] = axistempkills;
		game["alliedscore"] = axistempscore;
		level.alliedscore = axistemplscore;
		game["alliesRoundsWon"] = axistemproundswon;
		setTeamScore("allies", game["alliedscore"]);
		team1storage = game["team1"];
		game["team1"] = game["team2"];
		game["team2"] = team1storage;

		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{ 
			player = players[i];

			// Switch Teams
			if ( (isdefined (player.pers["team"])) && (player.pers["team"] == "axis") )
			{
				player.pers["team"] = "allies";
				axissavedmodel = player.pers["savedmodel"];
			}
			else if ( (isdefined (player.pers["team"])) && (player.pers["team"] == "allies") )
			{
				player.pers["team"] = "axis";
				alliedsavedmodel = player.pers["savedmodel"];
			}

			//Swap Models
			if ( (isdefined(player.pers["team"]) ) && (player.pers["team"] == "axis") )
				 player.pers["savedmodel"] = axissavedmodel;
			else if ( (isdefined(player.pers["team"])) && (player.pers["team"] == "allies") )
				player.pers["savedmodel"] = alliedsavedmodel;

			//change headicons
			battlerank = [[level.getVars]]("scr_battlerank");
			drawfriend = [[level.getVars]]("scr_drawfriend");
			
			if( battlerank > 0)
			{
				// for all living players, show the appropriate headicon
				players = getentarray("player", "classname");
				for(i = 0; i < players.size; i++)
				{
					player = players[i];
					
					if(isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
					{
						// setup the hud rank indicator
						player thread maps\mp\gametypes\_rank_gmi::RankHudInit();

						player.statusicon = maps\mp\gametypes\_rank_gmi::GetRankStatusIcon(player);
						if ( drawfriend )
						{
							player.headicon = maps\mp\gametypes\_rank_gmi::GetRankHeadIcon(player);
							player.headiconteam = player.pers["team"];
						}
						else
						{
							player.headicon = "";
						}
					}
				}
			}
			else if(drawfriend)
			{
				// for all living players, show the appropriate headicon
				players = getentarray("player", "classname");
				for(i = 0; i < players.size; i++)
				{
					player = players[i];
					
					if(isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
					{
						if(player.pers["team"] == "allies")
						{
							player.headicon = game["headicon_allies"];
							player.headiconteam = "allies";
						}
						else
						{
							player.headicon = game["headicon_axis"];
							player.headiconteam = "axis";
						}
					}
				}
			}
			else
			{
				players = getentarray("player", "classname");
				for(i = 0; i < players.size; i++)
				{
					player = players[i];
					
					if(isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
						player.headicon = "";
						player.statusicon = "";
				}
			}
		}
	}
	
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{ 
		player = players[i];
		if ( (!isdefined (player.pers["team"])) || (player.pers["team"] == "spectator") )
			continue; //skip spectators
		
		//drop weapons and make spec
		player.pers["weapon"] = undefined;
		player.pers["weapon1"] = undefined;
		player.pers["weapon2"] = undefined;
		player.pers["spawnweapon"] = undefined;
		player.pers["selectedweapon"] = undefined;
		player.sessionstate = "spectator";
		player.spectatorclient = -1;
		player.archivetime = 0;
		player.reflectdamage = undefined;

		player unlink();
		player enableWeapon();
		
		//Respawn with new weapons
		player thread maps\mp\uox\_uox_respawns::halftimeSpawn();
	}
	
	//create HUD
	//maps\mp\uox\_uox_hud::createHUDNextRound(3, false, switchSides);
	
	//reset half scores
	if(game["half"] % 2) //reset scores during start of OT
	{
		if(level.uox_teamplay)  //if team game
		{						//reset team half scores
			game["round1team1score"] = 0;
			game["round2team1score"] = 0;
			game["round1team2score"] = 0;
			game["round2team2score"] = 0;
		}
		else //if free for all game
		{	 //loop through players and reset half scores
			for(i = 0; i < players.size; i++)
			{ 
				player = players[i];
				player.pers["1HScore"] = 0;
				player.pers["2HScore"] = 0;
			}
		}
	}
	
	//do warmup - readyup
	if([[level.getVars]]("scr_warmupmode") > 0)
	{
		if([[level.getVars]]("scr_warmupmode") == 1)
			maps\mp\uox\_uox_warmup::DoWarmUp(switchSides);
		else
			maps\mp\uox\_uox_warmup::DoReadyUp(switchSides);
	}
	else
	{
		if(game["half"] % 2)
		{
			if(switchSides)
				iprintlnbold("Overtime - Switching Sides");
			else
				iprintlnbold("Overtime");
		}
		else
		{
			if(switchSides)
				iprintlnbold("Halftime - Switching Sides");
			else
				iprintlnbold("Halftime");
		}
	
		wait 7;
	}
	//if a mid round switch
	if(midRound)
	{
		announcement(&"SD_MATCHRESUMING");
		endRound("half");
	}
}

/* *************************************************************************************************
**** doOvertime()
****
**** Called from checkTimeLimit
**** starts sudden death overtime (next score wins)
**** 
************************************************************************************************* */
doOvertime()
{
	game["suddendeath"] = true;
	//announce that the game is in sudden death
	iprintlnbold("SUDDEN DEATH OVERTIME STARTING NOW");
	
	maps\mp\uox\_uox_loops::addToLoop(level, "medium", ::checkSuddenDeath, "checkSuddenDeath");
}

checkSuddenDeath()
{
	if(!checkTie([[level.getVars]]("scr_score_rounds")))
		endOvertime();
}

endOvertime()
{
	//kill loop
	maps\mp\uox\_uox_loops::removeFromLoop(level, "medium", "checkSuddenDeath");
	
	//tie has been broken. End Game
	if(game["roundbased"])
	{	//if round hasn't already ended
		if(!level.roundended)
			iprintlnbold(&"MPSCRIPT_SCORE_LIMIT_REACHED"); //announce score limit has been reached
		if(level.uox_teamplay) //if team game
		{
			if(getTeamScore("allies") > getTeamScore("axis")) //if the allies won 
				endRound("allies"); //run a final end round for the allies
			else //if the axis won
				endRound("axis"); //run a final end round for the axis
		}
		else //if free for all game
			endRound("deathmatch"); //run a final deathmatch endround
		return;
	}
	//if a non round based game
	level.mapended = true; //set map endend flag to true
	iprintln(&"MPSCRIPT_SCORE_LIMIT_REACHED"); //announce score limit has been reached
	level thread endMap(); //end the map
}

/* *************************************************************************************************
**** resetScores()
****
**** Called from endRound
**** resets team scores and player scores back to 0
**** 
************************************************************************************************* */
resetScores()
{
	resetTeamScores();
	resetPlayerScores();
}

/* *************************************************************************************************
**** resetTeamScores()
****
**** Called from endRound
**** resets team scores back to 0
**** 
************************************************************************************************* */
resetTeamScores()
{
	game["alliedscore"] = 0;
	setTeamScore("allies", game["alliedscore"]);
	game["axisscore"] = 0;
	setTeamScore("axis", game["axisscore"]);
}

/* *************************************************************************************************
**** resetPlayerScores()
****
**** Called from endRound
**** resets player scores back to 0
**** 
************************************************************************************************* */
resetPlayerScores()
{
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		player.pers["score"] = 0;
		player.pers["deaths"] = 0;
		player.score = 0;
		player.deaths = 0;
	}
	
	if ([[level.getVars]]("scr_battlerank"))
	{
		maps\mp\gametypes\_rank_gmi::ResetPlayerRank();
	}

}

/* *************************************************************************************************
**** getTeam1Score()
****
**** Called from various scripts
**** determines what team team1 is on and returns the teamScore
**** 
************************************************************************************************* */
getTeam1Score()
{
	if(game["team1"] == "allies")
		return game["alliedscore"];
	else
		return game["axisscore"];
}

/* *************************************************************************************************
**** getTeam2Score()
****
**** Called from various scripts
**** determines what team team2 is on and returns the teamScore
**** 
************************************************************************************************* */
getTeam2Score()
{
	if(game["team2"] == "allies")
		return game["alliedscore"];
	else
		return game["axisscore"];
}

/* *************************************************************************************************
**** getTeam1Kills()
****
**** Called from various scripts
**** determines what team team1 is on and returns the number of kills
**** 
************************************************************************************************* */
getTeam1Kills()
{
	if(game["team1"] == "allies")
		return game["alliedkills"];
	else
		return game["axiskills"];
}

/* *************************************************************************************************
**** getTeam2Kills()
****
**** Called from various scripts
**** determines what team team2 is on and returns the number of kills
**** 
************************************************************************************************* */
getTeam2Kills()
{
	if(game["team1"] == "allies")
		return game["alliedkills"];
	else
		return game["axiskills"];
}

setPlayerScore(victim, attacker)
{
	if(level.warmup)
		return;
	
	if(isPlayer(attacker))
	{
		if(attacker == victim) // killed himself
		{	
			if (!isdefined (victim.autobalance))
			{
				
				attacker.score--;
				attacker.pers["score"]--;
				attacker.score = attacker.pers["score"];
				if(![[level.getVars]]("scr_score_rounds")) //if not scoring rounds
				{
					//test half
					if(game["half"] % 2) //if 1st half
						attacker.pers["1HScore"]--;
					else //if 2nd half
						attacker.pers["2HScore"]--;
				}
			}
		}
		else
		{
			if(victim.pers["team"] == attacker.pers["team"] && level.uox_teamplay) // killed by a friendly
			{	
				attacker.pers["score"]--;
				attacker.score = attacker.pers["score"];
				if(![[level.getVars]]("scr_score_rounds")) //if not scoring rounds
				{
					//test half
					if(game["half"] % 2) //if 1st half
						attacker.pers["1HScore"]--;
					else //if 2nd half
						attacker.pers["2HScore"]--;
				}
			}
			else
			{
				attacker.pers["score"]++;
				attacker.score = attacker.pers["score"];
				if(![[level.getVars]]("scr_score_rounds")) //if not scoring rounds
				{
					//test half
					if(game["half"] % 2) //if 1st half
						attacker.pers["1HScore"]++;
					else //if 2nd half
						attacker.pers["2HScore"]++;
				}
			}
		}
	}
	else
	{
		victim.pers["score"]--;
		victim.score = attacker.pers["score"];
		if(![[level.getVars]]("scr_score_rounds")) //if not scoring rounds
		{
			//test half
			if(game["half"] % 2) //if 1st half
				victim.pers["1HScore"]--;
			else //if 2nd half
				victim.pers["2HScore"]--;
		}
	}
}

incrementTeamScore(team, val)
{
	if(!isDefined(val))
		val = 1;
	//give them a point
	if(team == "axis")
	{
		if([[level.getVars]]("scr_score_rounds"))
		{
			teamscore = level.axisscore;
			teamscore += val;
			level.axisscore = teamscore;
			setTeamScore("axis", level.axisscore);
		}
		else
		{
			teamscore = game["axisscore"];
			teamscore += val;
			game["axisscore"] = teamscore;
			setTeamScore("axis", game["axisscore"]);
		}
	}
	else if(team == "allies")
	{
		if([[level.getVars]]("scr_score_rounds"))
		{
			teamscore = level.alliedscore;
			teamscore += val;
			level.alliedscore = teamscore;
			setTeamScore("allies", level.alliedscore);
		}
		else
		{
			teamscore = game["alliedscore"];
			teamscore += val;
			game["alliedscore"] = teamscore;
			setTeamScore("allies", game["alliedscore"]);
		}
	}
}

// ----------------------------------------------------------------------------------
//	GivePointsToTeam
//
// 		Gives points to everyone on a certain team
// ----------------------------------------------------------------------------------
GivePointsToTeam( team, points )
{
	players = getentarray("player", "classname");
	
	// count up the people in the flag area
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		if(isAlive(player) && player.pers["team"] == team)
		{
			player.pers["score"] += points;
			player.score = player.pers["score"];
		}
	}
}

/* *************************************************************************************************
**** lockPlayersInPlace()
****
**** Called from endRound
**** loops through players and locks players in place
**** 
************************************************************************************************* */
lockPlayersInPlace()
{
	players = getentarray("player","classname"); //get players
	for(i = 0; i < players.size; i++) //loop players
	{
		players[i] lockInPlace(); //lock current player in place
	}
}

/* *************************************************************************************************
**** lockInPlace()
****
**** Called from lockPlayersInPlace, Callback_PlayerDisconnect
**** sets self.maxspeed to 0
**** 
************************************************************************************************* */
lockInPlace()
{
	self.maxspeed = 0;
}

/* *************************************************************************************************
**** unlockPlayersMovement()
****
**** Called from ???
**** loops through players and unlocks players movement
**** 
************************************************************************************************* */
unlockPlayersMovement()
{
	players = getentarray("player","classname"); //get players
	for(i = 0; i < players.size; i++) //loop players
	{
		players[i] unlockMovement(); //unlock current players movement
	}
}

/* *************************************************************************************************
**** unlockMovement()
****
**** Called from unlockPlayersMovement
**** sets self.maxspeed to the server's g_speed value
**** 
************************************************************************************************* */
unlockMovement()
{
	self.maxspeed = game["g_speed"];
}

/* *************************************************************************************************
**** printJoinedTeam(string team)
****
**** Called from menu_spawn
**** announces team join in feed
**** 
************************************************************************************************* */
printJoinedTeam(team)
{
	if(team == "allies")
		iprintln(&"MPSCRIPT_JOINED_ALLIES", self);
	else if(team == "axis")
		iprintln(&"MPSCRIPT_JOINED_AXIS", self);
}

/* *************************************************************************************************
**** getHighScore(boolean checkRounds)
****
**** Called from endMap, checkTie, checkGameWon
**** loops through players and returns highest scoring player. If checkrounds is true it prioritizes
**** rounds over score
**** 
************************************************************************************************* */
getHighScore(checkRounds)
{
	//if checkrounds was not specified
	if(!isDefined(checkRounds))
		checkRounds = false; //don't check round
	tied = false; //init tied flag
	players = getentarray("player", "classname"); //get players
	for(i = 0; i < players.size; i++) //loop players
	{
		player = players[i]; //current player
		//if player is a spectator
		if(isDefined(player.pers["team"]) && player.pers["team"] == "spectator")
			continue; //don't check

		if(!isDefined(highscore)) //if a highscore player isn't defined yet
		{
			if(checkRounds) //if checking rounds
				highscore = player.pers["roundswon"]; //highscore is rounds won
			else //if checking score
				highscore = player.score; //high score is player score
			playername = player; //store highscoring player
			name = player.name; //store player name
			guid = player getGuid(); //store player guid
			continue;	//check next player
		}
		if(checkRounds) //if checking rounds
		{
			if(player.pers["roundswon"] == highscore) //if rounds won equals the current high score
				tied = true; //mark game as tied
			else if(player.pers["roundswon"] > highscore) //if rounds won is greater than high score
			{
				tied = false; //game isn't tied
				highscore = player.pers["roundswon"]; //new high score 
				playername = player; //player is new highscoring player
				name = player.name; //store playername
				guid = player getGuid(); //store guid
			}
		}
		else //if checking score
		{
			if(player.score == highscore) //if score equals the current high score
				tied = true; //mark game as tied
			else if(player.score > highscore) //if score is higher than current high score
			{
				tied = false; //game isn't tied
				highscore = player.score; //new high score
				playername = player; //player is new highscoring player
				name = player.name; //store player name
				guid = player getGuid(); //store guid
			}
		}
	}
	
	if(!isDefined(playername)) //if a highscoring player was not defined
		return undefined;	//return undefined
	
	winner = playername; //set winner to high scoring player
	winner.guid = guid; //set winner's guid to stored guid
	winner.tied = tied; //set whether winner was tied by another player to tied flag
	winner.roundsWon = winner.pers["roundswon"]; //set winner roundsWon to roundswon
	
	return winner; //return high scoring player
}

/* *************************************************************************************************
**** getSecondPlace(playerEntity firstplace, boolean checkRounds)
****
**** Called from checkTie, checkGameWon
**** loops through players and returns the second highest scoring player. If checkrounds is true
****  it prioritizes rounds over score
**** 
************************************************************************************************* */
getSecondPlace(firstplace, checkRounds)
{
	//if no first place player
	if(!isDefined(firstplace))
		return undefined; //then how can there be a second place, return undefined
	
	if(!isDefined(checkRounds)) //if checkrounds not specified
		checkRounds = false; //do not check rounds
	
	tied = false; //reset tied flag
	players = getentarray("player", "classname"); //get players
	for(i = 0; i < players.size; i++) //loop players
	{
		player = players[i]; //current player

		if(isDefined(firstplace) && player == firstplace) //if current player is firstplace player
			continue; //skip
		//if current player is a spectator
		if(isDefined(player.pers["team"]) && player.pers["team"] == "spectator")
			continue; //skip 

		if(!isDefined(highscore)) //if (second) high scoring player not defined yet
		{
			if(checkRounds) //if checking rounds
				highscore = player.pers["roundswon"]; //set high score to rounds won
			else //if checking score
				highscore = player.score; //set high score to highest player score
			playername = player; //store high scoring player
			name = player.name; //store player name
			guid = player getGuid(); //store guid
			continue; //check next player
		}
		if(checkRounds) //if checking rounds
		{
			if(player.pers["roundswon"] == highscore) //if rounds won is equal to (second) high score 
				tied = true; //set tied flag
			else if(player.pers["roundswon"] > highscore) //if rounds won is higher than current high
			{
				tied = false; //game is not tied
				highscore = player.pers["roundswon"]; //set new highscore
				playername = player; //store high scoring player
				name = player.name; //store player name
				guid = player getGuid(); //store guid
			}
		}
		else //if checking score
		{
			if(player.score == highscore) //if score is equal to second high score
				tied = true; //set tied flag
			else if(player.score > highscore) //if score is higher than current second highest score
			{
				tied = false; //game is not tied
				highscore = player.score; //set new highscore
				playername = player; //store high scoring player
				name = player.name; //store player name
				guid = player getGuid(); //store guid
			}
		}
	}
	
	if(!isDefined(playername)) //if no second place player defined
		return undefined; //return undefined
	
	winner = playername; //set winner to current high score player
	winner.guid = guid; //set winner guid to stored guid
	winner.tied = tied; //set if winner tied to tied flag
	winner.roundsWon = winner.pers["roundswon"]; //set winner.roundsWon to rounds won
	
	return winner; //return winner
}

/* *************************************************************************************************
**** addBotClients()
****
**** Called from Callback_StartGametype
**** starts a loop and monitors the scr_numbots cvar to add bots if needed.
**** 
************************************************************************************************* */
addBotClients()
{
	wait 5;

	for(;;)
	{
		if(getCvarInt("scr_numbots") > 0)
			break;
		wait 1;
	}

	switch(game["allies"])
	{
		case "russian":
			weapon = "mosin_nagant_mp";
			break;
		default:
			weapon = "springfield_mp";
	}
	
	iNumBots = getCvarInt("scr_numbots");
	numBots = iNumBots - getNumBots();	
	
	for(i = 0; i < numBots; i++)
	{
		ent[i] = addtestclient();
		wait 0.5;
		
		if(isDefined(ent[i]))
			ent[i].pers["isBot"] = true;

		if(isPlayer(ent[i]))
		{
			
			if(i & 1)
			{
				ent[i] notify("menuresponse", game["menu_team"], "axis");
				wait 0.5;
				ent[i] giveBotWeapon();
			}
			else
			{
				ent[i] notify("menuresponse", game["menu_team"], "allies");
				wait 0.5;
				ent[i] giveBotWeapon();
			}
		}
	}
}

/* *************************************************************************************************
**** giveBotWeapon()
****
**** Called from addBotClients
**** gets an a array of weapons for whatever team the bot is on and randomly gives one.
**** 
************************************************************************************************* */
giveBotWeapon()
{
	axisWeapons[0] = "kar98k_mp";
	axisWeapons[1] = "mp40_mp";
	axisWeapons[2] = "mp44_mp";
	axisWeapons[3] = "kar98k_sniper_mp";
	axisWeapons[4] = "gewehr43_mp";
	allowedAxisWeapons = [];
	
	allowedAlliesWeapons = [];
	
	switch(game["allies"])
	{
		case "british":
			alliesWeapons[0] = "enfield_mp";
			alliesWeapons[1] = "sten_mp";
			alliesWeapons[2] = "bren_mp";
			alliesWeapons[3] = "springfield_mp";
			break;
		case "russian":
			alliesWeapons[0] = "mosin_nagant_mp";
			alliesWeapons[1] = "ppsh_mp";
			alliesWeapons[2] = "mosin_nagant_sniper_mp";
			alliesWeapons[3] = "svt40_mp";
			break;
		default:
			alliesWeapons[0] = "m1carbine_mp";
			alliesWeapons[1] = "m1garand_mp";
			alliesWeapons[2] = "thompson_mp";
			alliesWeapons[3] = "bar_mp";
			alliesWeapons[4] = "springfield_mp";
	}
	
	for(i = 0; i < axisWeapons.size; i++ )
	{
		weapon = axisWeapons[i];
		if(self maps\mp\gametypes\_teams::restrict(weapon) != "restricted")
			allowedAxisWeapons[allowedAxisWeapons.size] = weapon;
	}
	
	for(i = 0; i < alliesWeapons.size; i++)
	{
		weapon = alliesWeapons[i];
		if(self maps\mp\gametypes\_teams::restrict(weapon) != "restricted")
			allowedAlliesWeapons[allowedAlliesWeapons.size] = weapon;
	}
	
	if(self.pers["team"] == "axis")
		self notify("menuresponse", game["menu_weapon_axis"], allowedAxisWeapons[randomInt(allowedAxisWeapons.size)]);
	if(self.pers["team"] == "allies")
		self notify("menuresponse", game["menu_weapon_allies"], allowedAlliesWeapons[randomInt(allowedAlliesWeapons.size)]);
}

/* *************************************************************************************************
**** getNumBots()
****
**** Called from addBotClients
**** loops through players and returns number of bot players. (specified by whether the persistent
**** property "isBot" [set when bot is added to game in addBotClients]) is defined or not)
**** 
************************************************************************************************* */
getNumBots()
{
	numBots = 0;
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if(isDefined(player.pers["isBot"]))
			numBots++;
	}
	return numBots;
}

/* **************************************************************************************************
**** initObjectives(string AttackDefend)
****
**** sets up objectives for gametype. AttackDefend is team to set as attacker if not defined by map
****
*************************************************************************************************** */
initObjectives(objective)
{

	if(!isDefined(objective))
		objective = "none";

	switch(objective)
	{
		case "bomb":
			if(!isDefined(game["attackers"]))
				game["attackers"] = "allies";
			if(!isDefined(game["defenders"]))
				game["defenders"] = "axis";
			maps\mp\uox\_uox_bombs::initVars();
			thread maps\mp\uox\_uox_bombs::bombzones();
			return;
		case "retrieval":
			if(!isdefined(game["re_attackers"]))
				game["re_attackers"] = "allies";
			game["attackers"] = game["re_attackers"];
			if(!isdefined(game["re_defenders"]))
				game["re_defenders"] = "axis";
			game["defenders"] = game["re_defenders"];
			maps\mp\uox\_uox_retrievals::initVars();
			thread maps\mp\uox\_uox_retrievals::retrieval();
			return;
        case "bel":
            maps\mp\uox\_uox_behindenemylines::initVars();
            return;
		default:
			game["attackers"] = undefined;
			game["defenders"] = undefined;
			return;
	}
}

/* **************************************************************************************************
**** precacheObjectives(string objective)
****
**** sets up objectives for gametype.
****
*************************************************************************************************** */
precacheObjectives(objective)
{

	if(!isDefined(objective))
		objective = "none";

	switch(objective)
	{
		case "bomb":
			maps\mp\uox\_uox_bombs::precache();
			return;
		case "retrieval":
			maps\mp\uox\_uox_retrievals::precache();
			return;
        case "bel":
            maps\mp\uox\_uox_behindenemylines::precache();
            return;
		default:
			return;
	}
}

/* **************************************************************************************************
**** disconnectObjectives(string objective)
****
**** handles player disconnect for objectives
****
*************************************************************************************************** */
disconnectObjectives(objective)
{

	if(!isDefined(objective))
		objective = "none";

	switch(objective)
	{
		case "bomb":
			return;
		case "retrieval":
			self maps\mp\uox\_uox_retrievals::drop_all();
			return;
        case "bel":
            self maps\mp\uox\_uox_behindenemylines::check_delete_objective();
            return;
        default:
			return;
	}
}

/* **************************************************************************************************
**** spectateObjectives(string objective)
****
**** handles player spectate for objectives
****
*************************************************************************************************** */
spectateObjectives(objective)
{

	if(!isDefined(objective))
		objective = "none";

    self setClientCvar("cg_objectiveText", maps\mp\uox\_uox::getObjectiveText(objective));

	switch(objective)
	{
		case "bomb":
			return;
		case "retrieval":
			self maps\mp\uox\_uox_retrievals::drop_all();
			return;
        case "bel":
            self maps\mp\uox\_uox_behindenemylines::check_delete_objective();
            return;
        default:
			return;
	}
}

/* **************************************************************************************************
**** playerSpawnObjectives(string objective)
****
**** handles player spectate for objectives
****
*************************************************************************************************** */
playerSpawnObjectives(objective)
{

	if(!isDefined(objective))
		objective = "none";

    self setClientCvar("cg_objectiveText", maps\mp\uox\_uox::getObjectiveText(objective));

	switch(objective)
	{
		case "bomb":
			return;
		case "retrieval":
			return;
        case "bel":
            if(self.pers["team"] == "allies")
                self thread maps\mp\uox\_uox_behindenemylines::make_obj_marker();
            return;
        default:
			return;
	}
}
	

/* **************************************************************************************************
**** getObjectiveText()
****
**** returns objective text for scoreboard
****
*************************************************************************************************** */
getObjectiveText(objective)
{
	if(!isDefined(objective))
		objective = "none";
	
	switch(objective)
	{
		case "bomb":
			if(game["attackers"] == "allies")
				return &"SD_OBJ_SPECTATOR_ALLIESATTACKING";
			else if(game["attackers"] == "axis")
				return &"SD_OBJ_SPECTATOR_AXISATTACKING";
        case "bel":
            if(self.pers["team"] == "allies")
                return &"BEL_OBJ_ALLIED";
            else if(self.pers["team"] == "axis")
                return &"BEL_OBJ_AXIS";
		default:
			if(level.uox_teamplay)
			{
				if(self.pers["team"] == "allies")
					return &"TDM_KILL_AXIS_PLAYERS";
				else if(self.pers["team"] == "axis")
					return &"TDM_KILL_ALLIED_PLAYERS";
				else
					return &"TDM_ALLIES_KILL_AXIS_PLAYERS";
			}
			else
				return &"DM_KILL_OTHER_PLAYERS";
	}
	return &"DM_KILL_OTHER_PLAYERS";
}

checkObjective()
{
	objective = level.objective;
	
	switch(objective)
	{
		case "bomb":
			if(!level.bombsites["A"]["planted"] && !level.bombsites["B"]["planted"])
				return true;
			else
				return false;
		default:
			return true;
	}
	return true;
}

spawnPlayerObjective(objective)
{
    self setClientCvar("cg_objectiveText", maps\mp\uox\_uox::getObjectiveText(objective));

    switch(objective)
	{
        case "bel":
            self maps\mp\uox\_uox_behindenemylines::check_delete_objective();
            if(self.pers["team"] == "allies")
            {
                self maps\mp\uox\_uox_behindenemylines::make_obj_marker();
            }
    }
}
numOnTeam()
{
    numonteam["allies"] = 0;
    numonteam["axis"] = 0;

    players = getentarray("player", "classname");
    for(i = 0; i < players.size; i++)
    {
        player = players[i];
    
        if(!isDefined(player.pers["team"]) || player.pers["team"] == "spectator" || player == self)
            continue;

        numonteam[player.pers["team"]]++;
    }

    return numonteam;
}

moveTeams(auto)
{

    if(isDefined(auto))
    {
        if(randomInt(2))
            return;
    }

    if (self.pers["team"] == "spectator")
		return;

    myteam = self.pers["team"];

    if(myteam == "allies")
        newteam = "axis";
    else
        newteam = "allies";

    self.pers["weapon"] = undefined;
    self.pers["weapon1"] = undefined;
    self.pers["weapon2"] = undefined;
    self.pers["spawnweapon"] = undefined;
    self.pers["selectedweapon"] = undefined;
    self.pers["team"] = newteam;
    self.sessionteam = newteam;
    self.sessionstate = "spectator";
    self.spectatorclient = -1;
    self.archivetime = 0;
    self.reflectdamage = undefined;
    
    /*
	if(!isDefined(self.pers[newteam + "_weapon"]))
	{

		if(self.pers["team"] == "allies")
		{
			self setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);
			self openMenu(game["menu_weapon_allies"]);
		}
		else
		{
			self setClientCvar("g_scriptMainMenu", game["menu_weapon_axis"]);
			self openMenu(game["menu_weapon_axis"]);
		}
	} */
	
	if(isDefined(self.pers["isBot"]))
	{
		maps\mp\uox\_uox::giveBotWeapon();
	}

    if([[level.getVars]]("scr_respawn_mode") == "bel")
    {
		self notify("remove_respawntext");
        self maps\mp\uox\_uox_hud::blackoutClientHUD(&"BEL_BLACKSCREEN_WILLSPAWN", 2);
    }

    if(isDefined(self.pers[newteam + "_weapon"])) 
    {
        self.pers["weapon"] = self.pers[newteam + "_weapon"];
        self maps\mp\uox\_uox_respawns::respawn();
        return;
    }

    timepassed = 0;
	while ( !isDefined(self.pers[newteam + "_weapon"]) )
	{
		if(self.pers["team"] != "spectator" && timepassed > 1)
		{
            self closeMenu();
			self.pers["team"] = newteam;
			if(self.pers["team"] == "allies")
				self openMenu(game["menu_weapon_allies"]);
			else
				self openMenu(game["menu_weapon_axis"]);
		}

		if (self.pers["team"] == "spectator")
			return;

		wait .1;
        timepassed += .1;

        if(timepassed >= 6)
        {
            self.pers["team"] = "spectator";
            self.sessionteam = "spectator";
            self maps\mp\uox\_uox_respawns::spawnSpectator();
            break;
        }
	}
}

randomMoveTeams(team)
{
    numonteam["both"] = [];
    numonteam["allies"] = [];
    numonteam["axis"] = [];
    players = getentarray("player", "classname");
    for(i = 0; i < players.size; i++)
    {
        player = players[i];
    
        if(player.dontmove)
        {
            player.dontmove = false;
            continue;
        }

        if(!isDefined(player.pers["team"]) || player.pers["team"] == "spectator" || player == self)
            continue;

        numonteam[player.pers["team"]][numonteam[player.pers["team"]].size] = player;
        numonteam["both"][numonteam["both"].size] = player;
    }
    if(!isDefined(team))
    {
        numPlayers = numonteam["both"].size;
        if(numPlayers > 0)
            player = numonteam["both"][randomInt()];
    }
    else if(team == "axis")
    {
        numPlayers = numonteam["axis"].size;
        if(numPlayers > 0)
            player = numonteam["axis"][randomInt(numonteam["axis"].size)];
    }
    else if(team == "allies")
    {
        numPlayers = numonteam["allies"].size;
        if(numPlayers > 0)
            player = numonteam["allies"][randomInt(numonteam["allies"].size)];
    }
    if(numPlayers > 0)
        player moveTeams();
}

/* **************************************************************************************************
**** updateTimeLimit(float timer)
****
**** var callback
**** updates the game timer
****
*************************************************************************************************** */
updateTimeLimit(timer)
{
	gt = level.gametype;
	setCvar("ui_" + gt + "_timelimit", timer);
	game["timepassed"] = 0;
	if(timer > 0)
	{
		//int game timer [[level.getVars]]("scr_timelimit") is in minutes, so is game["timepassed"] convert to seconds; 
		//subtract timed pass from time limit to get correct time instead of re-initing the timer after
		gameTimer = (timer * 60) - (game["timepassed"] * 60); //each round
		if([[level.getVars]]("scr_roundlimit") == 1) //if game is a single round, set game clock in bottom center
			maps\mp\uox\_uox_hud::updateHUDMainClock(gameTimer);
		else //if game will last multiple rounds then set game clock above the compass
			maps\mp\uox\_uox_hud::updateHUDCompassClock(gameTimer);
	}
	else
	{
		if([[level.getVars]]("scr_roundlimit") == 1) //if game is a single round, set game clock in bottom center
			maps\mp\uox\_uox_hud::deleteHUDMainClock();
		else //if game will last multiple rounds then set game clock above the compass
			maps\mp\uox\_uox_hud::deleteHUDCompassClock();
	}
	level.starttime = getTime();

	checkTimeLimit();
}

/* **************************************************************************************************
**** updateScoreLimit(int scorelimit)
****
**** var callback
**** updates the game scorelimit
****
*************************************************************************************************** */
updateScoreLimit(scorelimit)
{
	gt = level.gametype;
	setCvar("ui_" + gt +"_scorelimit", scorelimit);

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
		players[i] maps\mp\uox\_uox::checkScoreLimit();
}

/* **************************************************************************************************
**** updateKillCam(bool enableKillcam)
****
**** var callback
**** updates the killcam mode
****
*************************************************************************************************** */
updateKillcam(enableKillcam)
{
	if(enableKillcam)
		setarchive(true);
	else if([[level.getVars]]("scr_final_killcam"))
		setarchive(true);
	else
		setarchive(false);
}

/* **************************************************************************************************
**** updateFinalKillCam(bool enableKillcam)
****
**** var callback
**** updates the killcam mode
****
*************************************************************************************************** */
updateFinalKillcam(enableKillcam)
{
	level.finalKillcamTime = undefined;
	level.finalKillcamSpectatorClient = undefined;
	level.finalKillcamAttacker = undefined;
	level.finalKillcamAttackerGUID = undefined;
	level.finalKillcamAttackerTeam = undefined;
	level.finalKillcamDelay = undefined;
	
	if(enableKillcam)
		setarchive(true);
	else if([[level.getVars]]("scr_killcam"))
		setarchive(true);
	else
		setarchive(false);
}

/* **************************************************************************************************
**** updateBattleRank(int battlerank)
****
**** var callback
**** updates the battlerank mode (0 off, 1 per game, 2 persistent)
****
*************************************************************************************************** */
updateBattleRank(battlerank)
{
	//needed for compatibility with built in UO battlerank
	level.battlerank = battlerank;
	
	if(level.uox_teamplay)
		drawfriend = [[level.getVars]]("scr_drawfriend");
	else
		drawfriend = false;
	
	// battle rank has precidence over draw friend
	if(battlerank > 0)
	{	//if rank change check is not in loop, add it
		maps\mp\uox\_uox_loops::addToLoop(level, "slow",
				maps\mp\gametypes\_rank_gmi::CheckPlayersForRankChanges, "CheckPlayersForRankChanges");
				
		// for all living players, show the appropriate headicon
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			
			if(isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
			{
				// setup the hud rank indicator
				player thread maps\mp\gametypes\_rank_gmi::RankHudInit();

				player.statusicon = maps\mp\gametypes\_rank_gmi::GetRankStatusIcon(player);
				if ( drawfriend )
				{
					player.headicon = maps\mp\gametypes\_rank_gmi::GetRankHeadIcon(player);
					player.headiconteam = player.pers["team"];
				}
				else
				{
					player.headicon = "";
				}
			}
		}
	}
	else if(drawfriend)
	{
		// for all living players, show the appropriate headicon
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			
			if(isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
			{
				if(player.pers["team"] == "allies")
				{
					player.headicon = game["headicon_allies"];
					player.headiconteam = "allies";
				}
				else
				{
					player.headicon = game["headicon_axis"];
					player.headiconteam = "axis";
				}
			}
		}
	}
	else
	{
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			
			if(isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
				player.headicon = "";
				player.statusicon = "";
		}
	}
	if(battlerank == 0)
	{
		maps\mp\uox\_uox_loops::removeFromLoop(level, "slow", "CheckPlayersForRankChanges");
	}
}

/* **************************************************************************************************
**** updateDrawFriend(bool drawfriend)
****
**** var callback
**** updates the whether team headicons should be drawn
****
*************************************************************************************************** */
updateDrawFriend(drawfriend)
{
	if(!level.uox_teamplay)
		return;
	else
		battlerank = [[level.getVars]]("scr_battlerank");
	
	level.drawfriend = drawfriend;
	
	// battle rank has precidence over draw friend
	if(battlerank > 0)
	{
		// for all living players, show the appropriate headicon
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			
			if(isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
			{
				// setup the hud rank indicator
				player thread maps\mp\gametypes\_rank_gmi::RankHudInit();

				player.statusicon = maps\mp\gametypes\_rank_gmi::GetRankStatusIcon(player);
				if ( drawfriend )
				{
					player.headicon = maps\mp\gametypes\_rank_gmi::GetRankHeadIcon(player);
					player.headiconteam = player.pers["team"];
				}
				else
				{
					player.headicon = "";
				}
			}
		}
	}
	else if(drawfriend)
	{
		// for all living players, show the appropriate headicon
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			
			if(isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
			{
				if(player.pers["team"] == "allies")
				{
					player.headicon = game["headicon_allies"];
					player.headiconteam = "allies";
				}
				else
				{
					player.headicon = game["headicon_axis"];
					player.headiconteam = "axis";
				}
			}
		}
	}
	else
	{
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			
			if(isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
				player.headicon = "";
				player.statusicon = "";
		}
	}
}

/* **************************************************************************************************
**** updateCeaseFire(bool ceasefire)
****
**** var callback
**** updates whether game is in ceasefire mode
****
*************************************************************************************************** */
updateCeaseFire(ceasefire)
{
	if ( ceasefire )
	{
		level thread maps\mp\_util_mp_gmi::make_permanent_announcement(&"GMI_MP_CEASEFIRE", "end ceasefire", 220, (1.0,0.0,0.0));			
	}
	else
	{
		level notify("end ceasefire");
	}
}

/* **************************************************************************************************
**** updateTeamBalance(bool teamBalance)
****
**** var callback
**** updates whether game teams should be balanced
****
*************************************************************************************************** */
updateTeamBalance(teamBalance)
{
	if(!level.uox_teamplay)
		return;
	
	level.teambalance = teamBalance;
			
	if(teamBalance)
	{
		if(game["roundbased"])
		{
			maps\mp\uox\_uox_loops::removeFromLoop(level, "slow", "TeamBalance_Check");
			level thread maps\mp\gametypes\_teams::TeamBalance_Check_Roundbased();
		}
		else
		{
			maps\mp\uox\_uox_loops::addToLoop( level, "slow", 
					maps\mp\uox\_uox::TeamBalance_Check, "TeamBalance_Check");
			level thread maps\mp\gametypes\_teams::TeamBalance_Check();
			level.teambalancetimer = 0;
		}
	}
	maps\mp\uox\_uox_loops::removeFromLoop(level, "slow", "TeamBalance_Check");
}

TeamBalance_Check()
{
	level.teambalancetimer++;
	if (level.teambalancetimer >= 60)
	{
		level thread maps\mp\gametypes\_teams::TeamBalance_Check();
		level.teambalancetimer = 0;
	}
}

/* **************************************************************************************************
**** updateFriendlyFire(int friendlyfire)
****
**** var callback
**** updates the whether team headicons should be drawn
****
*************************************************************************************************** */
updateFriendlyFire(friendlyfire)
{
	level.friendlyfire = friendlyfire;
}