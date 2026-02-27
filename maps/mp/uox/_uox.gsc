isTeamPlayGametype(gt)
{
	switch(gt)
	{
		case "tdm":
		case "bel":
		case "re":
		case "sd":
		case "hq":
		case "ctf":
		case "dom":
		case "bas":
			return true;
		case "dm":
			return false;
		default:
			return false;
	}
	return false;
}

checkRoundEndPlayerKilled()
{
	gt = level.gametype;
	_roundEnd = getRoundEndPlayerKilled(gt);
	
	if(isDefined(_roundEnd))
		[[ _roundEnd ]]();
}

checkScoreLimit()
{
	if(level.scorelimit <= 0)
		return;
		
	if(!level.uox_teamplay)
	{
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{			
			if(players[i].score >= level.scorelimit)
				break;
		}
		if(i >= players.size)
		{
			return;
		}
	}
	else
	{
		if(getTeamScore("allies") < level.scorelimit && getTeamScore("axis") < level.scorelimit)
			return;
	}
		
	//TO DO: add round based check
	if(level.mapended)
		return;
		
	if(level.scorerounds)
	{
		iprintln(&"MPSCRIPT_SCORE_LIMIT_REACHED");
		if(level.uox_teamplay)
		{
			if(getTeamScore("allies") >= level.scorelimit)
				endRound("allies");
			else
				endRound("axis");
		}
		else
			endRound("deathmatch");
		return;
	}

	level.mapended = true;
	iprintln(&"MPSCRIPT_SCORE_LIMIT_REACHED");
	level thread endMap();
	
}

endMap()
{
	game["state"] = "intermission";
	level notify("intermission");
	
	if(isdefined(level.bombmodel))
		level.bombmodel stopLoopSound();

	
	if(!level.uox_teamplay)
	{
		tied = false;
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			player = players[i];

			if(isDefined(player.pers["team"]) && player.pers["team"] == "spectator")
				continue;

			if(!isDefined(highscore))
			{
				if(level.scorerounds)
					highscore = player.pers["roundswon"];
				else
					highscore = player.score;
				playername = player;
				name = player.name;
				guid = player getGuid();
				continue;
			}
			if(level.scorerounds)
			{
				if(player.pers["roundswon"] == highscore)
					tied = true;
				else if(player.pers["roundswon"] > highscore)
				{
					tied = false;
					highscore = player.pers["roundswon"];
					playername = player;
					name = player.name;
					guid = player getGuid();
				}
			}
			else
			{
				if(player.score == highscore)
					tied = true;
				else if(player.score > highscore)
				{
					tied = false;
					highscore = player.score;
					playername = player;
					name = player.name;
					guid = player getGuid();
				}
			}
		}

		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			player = players[i];

			player closeMenu();
			player setClientCvar("g_scriptMainMenu", "main");

			if(isDefined(tied) && tied == true)
				player setClientCvar("cg_objectiveText", &"MPSCRIPT_THE_GAME_IS_A_TIE");
			else if(isDefined(playername))
				player setClientCvar("cg_objectiveText", &"MPSCRIPT_WINS", playername);
			
			player maps\mp\uox\_uox_respawns::spawnIntermission();
		}
		wait 1;

		if (getCvar("g_autoscreenshot") == "1")
		{
			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
			{
				player = players[i];
			
				player autoScreenshot();
			}
		}
		if(!tied)
			logPrint("W;;" + guid + ";" + name + "\n");
	}
	else
	{
		winners = "";
		winner = "draw";

		if(game["alliedscore"] == game["axisscore"])
		{
			text = &"MPSCRIPT_THE_GAME_IS_A_TIE";
			winner = "draw";
		}
		else if(game["alliedscore"] > game["axisscore"])
		{
			text = &"MPSCRIPT_ALLIES_WIN";
			winner = "allies";
		}
		else
		{
			text = &"MPSCRIPT_AXIS_WIN";
			winner = "axis";
		}
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			player = players[i];

			player closeMenu();
			player setClientCvar("g_scriptMainMenu", "main");
			player setClientCvar("cg_objectiveText", text);
			player maps\mp\uox\_uox_respawns::spawnIntermission();
			
			if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "allies"))
			{
				if(winner == "allies")
					winners = (winners + ";" + lpGuid + ";" + players[i].name);
				else if(winner == "axis")
					losers = (losers + ";" + lpGuid + ";" + players[i].name);
			}
			else if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "axis"))
			{
				if(winner == "axis")
					winners = (winners + ";" + lpGuid + ";" + players[i].name);
				else if(winner == "allies")
					losers = (losers + ";" + lpGuid + ";" + players[i].name);
			}
		}

		wait 1;

		if (getCvar("g_autoscreenshot") == "1")
		{
			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
			{
				player = players[i];
			
				player autoScreenshot();
			}
		}
		if(winner != "draw")
		{
			if(winner == "allies")
			{
				logPrint("W;allies;" + winners + "\n");
				logPrint("L;axis;" + losers + "\n");
			}
			else
			{
				logPrint("W;axis;" + winners + "\n");
				logPrint("L;allies;" + losers + "\n");
			}
		}
	}
	wait 10;
	exitLevel(false);
}

getRoundEndPlayerKilled(gt)
{
	switch(gt)
	{
		//gamemodes that don't end on kills
		case "hq":
		case "ctf":
		case "dom":
		case "bas":
		case "sd":
		case "re":
			return;
		//gamemodes that can end on kills
		case "dm":
		case "tdm":
			return ::checkScoreLimit;
		default:
			return ::checkScoreLimit;
	}
}

doGracePeriod(gracetime)
{
	if(gracetime < 1)
		return;
	
	if(isDefined(level.mainclock))
		maps\mp\uox\_uox_hud::updateHUDMainClockColor( ( 0, 1, 0) );
	else
	{
		maps\mp\uox\_uox_hud::updateHUDMainClock(gracetime);
		maps\mp\uox\_uox_hud::updateHUDMainClockColor( ( 0, 1, 0) );
	}
		
	level.graceperiod = true;
	
	wait gracetime;
	
	if((level.roundlimit !=1 && level.roundlength) || (level.timelimit > 0 && level.roundlimit == 1))
		maps\mp\uox\_uox_hud::updateHUDMainClockColor( ( 1, 1, 1 ) );
	else
		maps\mp\uox\_uox_hud::deleteHUDMainClock();
	
	level.graceperiod = false;
}		

startGame(gt)
{
	level.starttime = getTime();

	level.graceperiod = false;
	
	gameTimer = (level.timelimit * 60) - (game["timepassed"] * 60);

	if(level.timelimit > 0)
	{
		if(level.roundlimit == 1)
			maps\mp\uox\_uox_hud::updateHUDMainClock(gameTimer);
		else
			maps\mp\uox\_uox_hud::updateHUDCompassClock(gameTimer);
	}
	
	if(level.roundlimit != 1)
	{
		thread startRound(gt);

		if ( (level.uox_teamplay) && (level.teambalance > 0) && (!game["BalanceTeamsNextRound"]) )
			level thread maps\mp\gametypes\_teams::TeamBalance_Check_Roundbased();
	}
	else
	{
		game["matchstarted"] = true;
	}
	
	for(;;)
	{
		checkTimeLimit();
		wait 1;
	}
}

startRound(gt)
{	

	level endon("bomb_plant");
	// round does not start until the match starts
	if ( !game["matchstarted"] )
		return;
		
	level.roundstarted = true;
	
	level.roundstarttime = getTime();
	
	// if the round length is zero then no clock or timer
	if ( level.roundlength == 0 )
		return;
				
	maps\mp\uox\_uox_hud::updateHUDMainClock(level.roundlength * 60);
	level thread doGracePeriod(getCvarInt("scr_" + gt + "_graceperiod"));
	
	wait(level.roundlength * 60);
	
	if(level.roundended)
		return;

	announcement(&"GMI_CTF_TIMEEXPIRED");
	
	if(!level.uox_teamplay)
	{
		endRound("deathmatch");
	}
	else
	{
		if(level.alliedscore == level.axisscore)
		{
			endRound("draw");
		}
		else if(level.alliedscore > level.axisscore)
		{
			endRound("allies");
		}
		else
		{
			endRound("axis");
		}
	}
}

checkMatchStart()
{
	oldvalue["teams"] = level.exist["teams"];
	level.exist["teams"] = false;

	// If teams currently exist
	if(level.uox_teamplay)
	{
		if(level.exist["allies"] && level.exist["axis"])
			level.exist["teams"] = true;
	}
	else
	{
		if(level.exist["2players"] > 0)
			level.exist["teams"] = true;
	}
	// If teams previously did not exist and now they do
	if(!oldvalue["teams"] && level.exist["teams"])
	{
		if(!game["matchstarted"])
		{
			announcement(&"SD_MATCHSTARTING");

			level notify("kill_endround");
			level.roundended = false;
			level thread endRound("reset");
		}
		else
		{
			announcement(&"SD_MATCHRESUMING");

			level notify("kill_endround");
			level.roundended = false;
			level thread endRound("draw");
		}

		return;
	}
}

endRound(roundwinner, doKillcam)
{
	
	if(!isDefined(doKillcam))
		doKillcam = false;
	
	level.switchprevent = false;
	level endon("kill_endround");

	if(level.roundended)
		return;
	level.roundended = true;

	// End bombzone threads and remove related hud elements and objectives
	level notify("round_ended");

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		
		if(isDefined(player.planticon))
			player.planticon destroy();

		if(isDefined(player.defuseicon))
			player.defuseicon destroy();

		if(isDefined(player.progressbackground))
			player.progressbackground destroy();

		if(isDefined(player.progressbar))
			player.progressbar destroy();

		player unlink();
		player enableWeapon();
		
		player maps\mp\uox\_uox_hud::clearClientHUD();
	}

	objective_delete(0);
	objective_delete(1);

	if(roundwinner == "allies")
	{
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
			players[i] playLocalSound("MP_announcer_allies_win");
	}
	else if(roundwinner == "axis")
	{
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
			players[i] playLocalSound("MP_announcer_axis_win");
	}
	else if(roundwinner == "draw")
	{
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
			players[i] playLocalSound("MP_announcer_round_draw");
	}
	
//	if(!isDefined(level.killcamFailsafe))
//		level thread maps\mp\uox\_uox_killcam::killcam_failsafe();

	wait 5;

	winners = "";
	losers = "";
	if(roundwinner == "allies")
	{ /*
		if ( level.battlerank )
		{
			GivePointsToTeam( "allies", 3);
		}
		*/
		game["alliedscore"]++;
		setTeamScore("allies", game["alliedscore"]);
		
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			lpGuid = players[i] getGuid();
			if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "allies"))
				winners = (winners + ";" + lpGuid + ";" + players[i].name);
			else if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "axis"))
				losers = (losers + ";" + lpGuid + ";" + players[i].name);
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
		logPrint("RW;allies;" + winners + "\n");
		logPrint("RL;axis;" + losers + "\n");
	}
	else if(roundwinner == "axis")
	{ /*
		if ( level.battlerank )
		{
			GivePointsToTeam( "axis", 3);
		}
		*/
		game["axisscore"]++;
		setTeamScore("axis", game["axisscore"]);

		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			lpGuid = players[i] getGuid();
			if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "axis"))
				winners = (winners + ";" + lpGuid + ";" + players[i].name);
			else if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "allies"))
				losers = (losers + ";" + lpGuid + ";" + players[i].name);
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
		
		logPrint("RW;axis;" + winners + "\n");
		logPrint("RL;allies;" + losers + "\n");
	}
	else if(roundwinner == "deathmatch")
	{
		tied = false;
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			player = players[i];

			if(isDefined(player.pers["team"]) && player.pers["team"] == "spectator")
				continue;

			if(!isDefined(highscore))
			{
				highscore = player.score;
				playername = player;
				name = player.name;
				guid = player getGuid();
				continue;
			}

			if(player.score == highscore)
				tied = true;
			else if(player.score > highscore)
			{
				tied = false;
				highscore = player.score;
				playername = player;
				name = player.name;
				guid = player getGuid();
			}
		}
		if(!tied)
		{
			winners = (winners + ";" + guid + ";" + name);
			playername.pers["roundswon"]++;
			logPrint("RW;deathmatch;" + winners + "\n");
		}
	}
 
	game["timepassed"] = game["timepassed"] + ((getTime() - level.starttime) / 1000) / 60.0;

	// for all living players store their weapons
	if(game["matchstarted"]){
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			
			if(isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
			{
				primary = player getWeaponSlotWeapon("primary");
				primaryb = player getWeaponSlotWeapon("primaryb");

				// If a menu selection was made
				if(isDefined(player.oldweapon))
				{
					// If a new weapon has since been picked up (this fails when a player picks up a weapon the same as his original)
					if(player.oldweapon != primary && player.oldweapon != primaryb && primary != "none")
					{
						player.pers["weapon1"] = primary;
						player.pers["weapon2"] = primaryb;
						player.pers["spawnweapon"] = player getCurrentWeapon();
					} // If the player's menu chosen weapon is the same as what is in the primaryb slot, swap the slots
					else if(player.pers["weapon"] == primaryb)
					{
						player.pers["weapon1"] = primaryb;
						player.pers["weapon2"] = primary;
						player.pers["spawnweapon"] = player.pers["weapon1"];
					} // Give them the weapon they chose from the menu
					else
					{
						player.pers["weapon1"] = player.pers["weapon"];
						player.pers["weapon2"] = primaryb;
						player.pers["spawnweapon"] = player.pers["weapon1"];
					}
				} // No menu choice was ever made, so keep their weapons and spawn them with what they're holding, unless it's a pistol or grenade
				else
				{
					if(primary == "none")
						player.pers["weapon1"] = player.pers["weapon"];
					else
						player.pers["weapon1"] = primary;
						
					player.pers["weapon2"] = primaryb;

					spawnweapon = player getCurrentWeapon();
					if ( (spawnweapon == "none") && (isdefined (primary)) ) 
						spawnweapon = primary;
					
					if(!maps\mp\gametypes\_teams::isPistolOrGrenade(spawnweapon))
						player.pers["spawnweapon"] = spawnweapon;
					else
						player.pers["spawnweapon"] = player.pers["weapon1"];
				}
			}
		}
	}

	level notify("postround");
/*	if(doKillcam)
	{
		game["finaldelay"] = (getTime() - game["finaldelay"]) / 1000;
		level waittill("final_killcam_over");
	}
*/
	if(game["matchstarted"])
	{
	//	if (level.countdraws == 1)
	//		game["roundsplayed"]++;
		//else if(roundwinner != "draw")
		if(roundwinner != "draw")
			game["roundsplayed"]++;
		
		checkRoundLimit();
		checkScoreLimit();
		
	}

	

	if(!game["matchstarted"] && roundwinner == "reset")
	{
		game["matchstarted"] = true;
		thread resetScores();
		game["roundsplayed"] = 0;
	}

	checkTimeLimit();

	if(level.mapended)
		return;
	level.mapended = true;

	if ( (level.teambalance > 0) && (game["BalanceTeamsNextRound"]) )
	{
		level.lockteams = true;
		level thread maps\mp\gametypes\_teams::TeamBalance();
		level waittill ("Teams Balanced");
		wait 4;
	}
	
	/* Next Round Timer */
	maps\mp\uox\_uox_hud::createHUDNextRound(3);
	
	if(level.roundreset)
	{
		resetPlayerScores();
	}

	map_restart(true);
}

updateTeamStatus()
{
	wait 0;	// Required for Callback_PlayerDisconnect to complete before updateTeamStatus can execute
	
	resettimeout();
	
	if(level.uox_teamplay)
	{
		oldvalue["allies"] = level.exist["allies"];
		oldvalue["axis"] = level.exist["axis"];
	}
	else
	{
		oldvalue["2players"] = level.exist["2players"];
	}
/*	if(!isDefined(level.numexist["allies"]))
		level.numexist["allies"] = oldvalue["allies"];
	if(!isDefined(level.numexist["axis"]))
		level.numexist["axis"] = oldvalue["axis"];
	if(!isDefined(level.numexist["deathmatch"]))
		level.numexist["deathmatch"] = oldvalue["2players"]; */
	
	if(level.uox_teamplay)
	{
		level.exist["allies"] = 0;
		level.exist["axis"] = 0;
	}
	else
	{
		level.exist["2players"] = -1;
	}
	
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		
		if(isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && (!isDefined(player.lives) || player.lives > -1 || (player.lives < 0 && level.reinforcements == -1)))
		{
			if(level.uox_teamplay)
			{
				level.exist[player.pers["team"]]++;
			}
			else
			{
				level.exist["2players"]++;
			}
		}
		
	}

	if(level.uox_teamplay)
	{
		if(level.exist["allies"])
			level.didexist["allies"] = true;
		if(level.exist["axis"])
			level.didexist["axis"] = true;
	}
	else
	{
		if(level.exist["2players"])
			level.didexist["2players"] = true;
	}
	
	if(level.roundended)
		return;
	/* if(level.uox_teamplay)
	{
		if(!isDefined(level.acesituation))
		{
			level.acesituation = [];
		}
		if(!isDefined(level.clutchsituation))
		{
			level.clutchsituation["allies"] = false;
			level.clutchsituation["axis"] = false;
		}
		
		if(level.exist["allies"] == 1 && level.exist["axis"] > 2)
		{
			level.clutchsituation["allies"] = true;
			level.clutchplayer["allies"] = lastAlliesPlayer;
		}
		
		if(level.exist["axis"] == 1 && level.exist["allies"] > 2)
		{
			level.clutchsituation["axis"] = true;
			level.clutchplayer["axis"] = lastAxisPlayer;
		}
	} */
	
	if(level.uox_teamplay)
	{
		if(oldvalue["allies"] && !level.exist["allies"] && oldvalue["axis"] && !level.exist["axis"])
		{
			if(!level.bombplanted)
			{
				announcement(&"SD_ROUNDDRAW");
				level thread endRound("draw");
				return;
			}

			if(game["attackers"] == "allies")
			{
				announcement(&"SD_ALLIEDMISSIONACCOMPLISHED");
				level thread endRound("allies");
				return;
			}

			announcement(&"SD_AXISMISSIONACCOMPLISHED");
			level thread endRound("axis");
			return;
		}

		if(oldvalue["allies"] && !level.exist["allies"])
		{
			// no bomb planted, axis win
			if(!level.bombplanted)
			{
				announcement(&"SD_ALLIESHAVEBEENELIMINATED");
				level thread endRound("axis",level.alliesLastKilled);
				return;
			}

			if(game["attackers"] == "allies")
				return;
			
			// allies just died and axis have planted the bomb
			if(level.exist["axis"])
			{
				announcement(&"SD_ALLIESHAVEBEENELIMINATED");
				level thread endRound("axis", level.alliesLastKilled);
				return;
			}

			announcement(&"SD_AXISMISSIONACCOMPLISHED");
			level thread endRound("axis");
			return;
		}
		
		if(oldvalue["axis"] && !level.exist["axis"])
		{
			// no bomb planted, allies win
			if(!level.bombplanted)
			{
				announcement(&"SD_AXISHAVEBEENELIMINATED");
				level thread endRound("allies",level.axisLastKilled);
				return;
			}
			
			if(game["attackers"] == "axis")
				return;
			
			// axis just died and allies have planted the bomb
			if(level.exist["allies"])
			{
				announcement(&"SD_AXISHAVEBEENELIMINATED");
				level thread endRound("allies",level.axisLastKilled);
				return;
			}
			
			announcement(&"SD_ALLIEDMISSIONACCOMPLISHED");
			level thread endRound("allies");
			return;
		}
	}
	else
	{
		if(oldvalue["2players"] > 0 && level.exist["2players"] == -1)
		{
			announcement(&"SD_ROUNDDRAW");
			level thread endRound("draw");
			return;
		}
		else if(oldvalue["2players"] > 0 && !level.exist["2players"])
		{
			level iprintlnbold("All players have been eliminated");
			level thread endRound("deathmatch");
			return;
		}
	}
}

checkTimeLimit()
{
	if(level.timelimit <= 0)
		return;

	if(game["timepassed"] < level.timelimit)
		return;

	if(level.mapended)
		return;
	level.mapended = true;

	iprintln(&"MPSCRIPT_TIME_LIMIT_REACHED");
	level thread endMap();
}

checkRoundLimit()
{
	if(level.roundlimit <= 0)
		return;
	
	if(level.scorerounds)
	{
		if(game["roundsplayed"] < level.roundlimit)
		{
			fiftyplus1 = (level.roundlimit/2) + 1;
			if(level.uox_teamplay)
			{
				if(getTeamScore("allies") < fiftyplus1 && getTeamScore("axis") < fiftyplus1)
					return;
			}
			else
			{
				players = getentarray("player", "classname");
				for(i = 0; i < players.size; i++)
				{			
					if(players[i].pers["roundswon"] >= fiftyplus1)
						break;
				}
				if(i >= players.size)
				{
					return;
				}
			}
		}
	} else {
		if(game["roundsplayed"] < level.roundlimit)
			return;
	}
	
	if(level.mapended)
		return;
	level.mapended = true;

	iprintln(&"MPSCRIPT_ROUND_LIMIT_REACHED");
	level thread endMap();
}

resetScores()
{
	resetTeamScores();
	resetPlayerScores();
}

resetTeamScores()
{
	game["alliedscore"] = 0;
	setTeamScore("allies", game["alliedscore"]);
	game["axisscore"] = 0;
	setTeamScore("axis", game["axisscore"]);
}

resetPlayerScores()
{
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		player.pers["score"] = 0;
		player.pers["deaths"] = 0;
	}
	
	if (level.battlerank)
	{
		maps\mp\gametypes\_rank_gmi::ResetPlayerRank();
	}

}

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
	for(i = 0; i < iNumBots; i++)
	{
		ent[i] = addtestclient();
		wait 0.5;

		if(isPlayer(ent[i]))
		{
			if(i & 1)
			{
				ent[i] notify("menuresponse", game["menu_team"], "axis");
				wait 0.5;
				ent[i] notify("menuresponse", game["menu_weapon_axis"], "kar98k_mp");
			}
			else
			{
				ent[i] notify("menuresponse", game["menu_team"], "allies");
				wait 0.5;
				ent[i] notify("menuresponse", game["menu_weapon_allies"], weapon);
			}
		}
	}
}
