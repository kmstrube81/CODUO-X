/*
	Deathmatch
	Objective: 	Score points by eliminating other players
	Map ends:	When one player reaches the score limit, or time limit is reached
	Respawning:	No wait / Away from other players

	Level requirements
	------------------
		Spawnpoints:
			classname		mp_deathmatch_spawn
			All players spawn from these. The spawnpoint chosen is dependent on the current locations of enemies at the time of spawn.
			Players generally spawn away from enemies.

		Spectator Spawnpoints:
			classname		mp_deathmatch_intermission
			Spectators spawn from these and intermission is viewed from these positions.
			Atleast one is required, any more and they are randomly chosen between.

	Level script requirements
	-------------------------
		Team Definitions:
			game["allies"] = "american";
			game["axis"] = "german";
			Because Deathmatch doesn't have teams with regard to gameplay or scoring, this effectively sets the available weapons.
	
		If using minefields or exploders:
			maps\mp\_load::main();
		
	Optional level script settings
	------------------------------
		Soldier Type and Variation:
			game["american_soldiertype"] = "airborne";
			game["american_soldiervariation"] = "normal";
			game["german_soldiertype"] = "wehrmacht";
			game["german_soldiervariation"] = "normal";
			This sets what models are used for each nationality on a particular map.
			
			Valid settings:
				american_soldiertype		airborne
				american_soldiervariation	normal, winter
				
				british_soldiertype		airborne, commando
				british_soldiervariation	normal, winter
				
				russian_soldiertype		conscript, veteran
				russian_soldiervariation	normal, winter
				
				german_soldiertype		waffen, wehrmacht, fallschirmjagercamo, fallschirmjagergrey, kriegsmarine
				german_soldiervariation		normal, winter

		Layout Image:
			game["layoutimage"] = "yourlevelname";
			This sets the image that is displayed when players use the "View Map" button in game.
			Create an overhead image of your map and name it "hud@layout_yourlevelname".
			Then move it to main\levelshots\layouts. This is generally done by taking a screenshot in the game.
			Use the outsideMapEnts console command to keep models such as trees from vanishing when noclipping outside of the map.
*/

/*QUAKED mp_deathmatch_spawn (1.0 0.5 0.0) (-16 -16 0) (16 16 72)
Players spawn away from enemies at one of these positions.
*/

/*QUAKED mp_deathmatch_intermission (1.0 0.0 1.0) (-16 -16 -16) (16 16 16)
Intermission is randomly viewed from one of these positions.
Spectators spawn randomly at one of these positions.
*/

UOX_Main()
{
	level.getVars = maps\mp\uox\_uox_vars::getVars;
	
	maps\mp\uox\_uox_vars::varDef("scr", "respawn_mode", "string", false, "dm", "", "", "Respawn Mode");
	/*
	if(getCvar("scr_dm_respawn_mode") != "")
		level.respawn_mode = getCvar("scr_dm_respawn_mode");
	else
		level.respawn_mode = getCvar("scr_respawn_mode");
	*/
	maps\mp\uox\_uox_vars::varDef("scr", "spawn_type", "string", false, "deathmatch", "", "", "Respawn Type");
	/*
	if(getCvar("scr_dm_spawn_type") != "")
		level.spawn_type = getCvar("scr_dm_spawn_type");
	else
		level.spawn_type = getCvar("scr_spawn_type");
	*/
	maps\mp\uox\_uox_vars::varDef("scr", "spawnpoints", "string", false, "dm", "", "", "Spawnpoints");
	/*
	if(getCvar("scr_dm_spawnpoints") != "")
		level.spawnpoints = getCvar("scr_dm_spawnpoints");
	else
		level.spawnpoints = getCvar("scr_spawnpoints");
	*/
	
	maps\mp\uox\_uox_vars::varDef("scr", "reinforcements", "int", false, -1, -1, 999, "Reinforcements");
	/*
	if(getCvar("scr_dm_reinforcements") != "")
		level.reinforcements = getCvarInt("scr_dm_reinforcements");
	else
		level.reinforcements = getCvarInt("scr_reinforcements");
	*/
	/* init spawns */
	if(!maps\mp\uox\_uox_respawns::initSpawns("dm"))
	{
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		return;
	}
	
	level.callbackStartGameType = maps\mp\uox\_uox_callbacks::Callback_StartGameType;
	level.callbackPlayerConnect = maps\mp\uox\_uox_callbacks::Callback_PlayerConnect;
	level.callbackPlayerDisconnect = maps\mp\uox\_uox_callbacks::Callback_PlayerDisconnect;
	level.callbackPlayerDamage = maps\mp\uox\_uox_callbacks::Callback_PlayerDamage;
	level.callbackPlayerKilled = maps\mp\uox\_uox_callbacks::Callback_PlayerKilled;

	maps\mp\gametypes\_callbacksetup::SetupCallbacks();

	allowed[0] = "dm";
	maps\mp\gametypes\_gameobjects::main(allowed);
	
	maps\mp\gametypes\_secondary_gmi::Initialize();
	
	maps\mp\uox\_uox_vars::varDef("scr", "timelimit", "float", true,
									30, 0, 1440, "Time Limit", maps\mp\uox\_uox::updateTimeLimit);
	/*
	if(getCvar("scr_dm_timelimit") == "")		// Time limit per map
		setCvar("scr_dm_timelimit", "30");
	else if(getCvarFloat("scr_dm_timelimit") > 1440)
		setCvar("scr_dm_timelimit", "1440");
	level.timelimit = getCvarFloat("scr_dm_timelimit");
	*/
	setCvar("ui_dm_timelimit", [[level.getVars]]("scr_timelimit"));
	makeCvarServerInfo("ui_dm_timelimit", "30");

	maps\mp\uox\_uox_vars::varDef("scr", "scorelimit", "int", true,
									50, 0, undefined, "Score Limit", maps\mp\uox\_uox::updateScoreLimit);
	/*
	if(getCvar("scr_dm_scorelimit") == "")		// Score limit per map
		setCvar("scr_dm_scorelimit", "50");
	level.scorelimit = getCvarInt("scr_dm_scorelimit");
	*/
	setCvar("ui_dm_scorelimit", [[level.getVars]]("scr_scorelimit"));
	makeCvarServerInfo("ui_dm_scorelimit", "50");
	
	maps\mp\uox\_uox_vars::varDef("scr", "roundlimit", "int", true, 1, 0, undefined, "Round Limit");
	/*
	if(getCvar("scr_dm_roundlimit") == "")		//Round limit
		setCvar("scr_dm_roundlimit", 1);
	level.roundlimit = getCvarInt("scr_dm_roundlimit");
	*/
	setCvar("ui_dm_roundlimit", [[level.getVars]]("scr_roundlimit"));
	makeCvarServerInfo("ui_dm_roundlimit", 1);
	
	maps\mp\uox\_uox_vars::varDef("scr", "ot_roundlimit", "int", true, 1, 0, undefined, "Overtime Rounds");
	/* 
	if(getCvar("scr_dm_ot_roundlimit") == "")		//Round limit
		setCvar("scr_dm_ot_roundlimit", 1);
	level.ot_roundlimit = getCvarInt("scr_dm_ot_roundlimit");
	*/
	maps\mp\uox\_uox_vars::varDef("scr", "roundlength", "float", true, 2.5, 0, 60, "Round Length");
	/*
	if(getCvar("scr_dm_roundlength") == "")		// Time limit per map
		setCvar("scr_dm_roundlength", "30");
	else if(getCvarFloat("scr_dm_roundlength") > 60)
		setCvar("scr_dm_roundlength", "0");
	level.roundlength = getCvarFloat("scr_dm_roundlength");
	*/
	setCvar("ui_dm_roundlength", [[level.getVars]]("scr_roundlength"));
	makeCvarServerInfo("ui_dm_roundlength", "30");
	
	maps\mp\uox\_uox_vars::varDef("scr", "roundreset", "bool",
								true, true, undefined, undefined, "Round Reset");
	/*
	if(getCvar("scr_dm_roundreset") == "")		//Round limit
		setCvar("scr_dm_roundreset", 0);
	level.roundreset = getCvarInt("scr_dm_roundreset");
	*/
	setCvar("ui_dm_roundreset", [[level.getVars]]("scr_roundreset"));
	makeCvarServerInfo("ui_dm_roundreset", 0);
	
	maps\mp\uox\_uox_vars::varDef("scr", "score_rounds", "bool",
								true, true, undefined, undefined, "Score Round Wins");
	/*
	if(getCvar("scr_dm_score_rounds") == "")		//Round limit
		setCvar("scr_dm_score_rounds", 0);
	level.scorerounds = getCvarInt("scr_dm_score_rounds");
	*/
	setCvar("ui_dm_score_rounds", [[level.getVars]]("scr_score_rounds"));
	makeCvarServerInfo("ui_dm_score_rounds", 0);

	maps\mp\uox\_uox_vars::varDef("scr", "graceperiod", "int", true, 15, 0, undefined, "Grace Period");
	/*
	if(getCvar("scr_dm_graceperiod") != "")
		level.graceperiodtime = getCvarInt("scr_dm_graceperiod");
	else
		level.graceperiodtime = getCvarInt("scr_graceperiod");
	*/
	
	maps\mp\uox\_uox_vars::varDef("scr", "warmupmode", "int", true, 0, 0, 2, "Warmup Mode");
	/*
	if(getCvar("scr_dm_warmupmode") != "")
		level.warmupmode = getCvarInt("scr_dm_warmupmode");
	else
		level.warmupmode = getCvarInt("scr_warmupmode");
	*/
	
	maps\mp\uox\_uox_vars::varDef("scr", "autoreadycount", "int", true,
								0, 0, undefined, "Auto-Ready Player Count");
	/*
	if(getCvar("scr_dm_autoreadycount") != "")
		level.autoreadycount = getCvarInt("scr_dm_autoreadycount");
	else
		level.autoreadycount = getCvarInt("scr_autoreadycount");
	*/
	
	maps\mp\uox\_uox_vars::varDef("scr", "autoreadytime", "int", true,
								0, 0, undefined, "Auto-Ready Timer");
	/*
	if(getCvar("scr_dm_autoreadytime") != "")
		level.autoreadytime = getCvarInt("scr_dm_autoreadytime");
	else
		level.autoreadytime = getCvarInt("scr_autoreadytime");
	*/
	
	maps\mp\uox\_uox_vars::varDef("scr", "halftime", "bool", true,
								false, undefined, undefined, "Halftime");
	/*
	if(getCvar("scr_dm_halftime") != "")
		level.halftime = getCvarInt("scr_dm_halftime");
	else
		level.halftime = getCvarInt("scr_halftime");
	*/
	
	maps\mp\uox\_uox_vars::varDef("scr", "overtime", "bool", true,
								false, undefined, undefined, "Overtime");
	/*
	if(getCvar("scr_dm_overtime") != "")
		level.overtime = getCvarInt("scr_dm_overtime");
	else
		level.overtime = getCvarInt("scr_overtime");
	*/
	
	maps\mp\uox\_uox_vars::varDef("scr", "forcerespawn", "int", true, 0, 0, 60, "Force Respawn");
	/*
	if(getCvar("scr_forcerespawn") == "")		// Force respawning
		setCvar("scr_forcerespawn", "0");
	*/
	
	maps\mp\uox\_uox_vars::varDef("scr", "battlerank", "int", true,
									1, 0, 2, "Battle Rank", maps\mp\uox\_uox::updateBattleRank);
	/*
	if(getCvar("scr_battlerank") == "")		
		setCvar("scr_battlerank", "1");	//default is ON
	level.battlerank = getCvarint("scr_battlerank");
	*/
	setCvar("ui_battlerank", [[level.getVars]]("scr_battlerank"));
	makeCvarServerInfo("ui_battlerank", "0");
	
	//needed for compatibility with built in UO battlerank
	level.battlerank = [[level.getVars]]("scr_battlerank");
	
	maps\mp\uox\_uox_vars::varDef("scr", "shellshock", "bool", true,
								true, undefined, undefined, "Shellshock");
	/*
	if(getCvar("scr_shellshock") == "")		// controls whether or not players get shellshocked from grenades or rockets
		setCvar("scr_shellshock", "1");
	*/
	setCvar("ui_shellshock", [[level.getVars]]("scr_shellshock"));
	makeCvarServerInfo("ui_shellshock", "0");
			
	if(!isDefined(game["compass_range"]))		// set up the compass range.
		game["compass_range"] = 1024;		
	setCvar("cg_hudcompassMaxRange", game["compass_range"]);
	makeCvarServerInfo("cg_hudcompassMaxRange", "0");

	maps\mp\uox\_uox_vars::varDef("scr", "drophealth", "bool", true,
								true, undefined, undefined, "Drop Health");
	/*
	if(getCvar("scr_drophealth") == "")		// Free look spectator
		setCvar("scr_drophealth", "1");
	*/
	
	// turn off ceasefire
	//level.ceasefire = 0;
	setCvar("scr_ceasefire", false);
	maps\mp\uox\_uox_vars::varDef("scr", "ceasefire", "bool", true,
								false, undefined, undefined, "Cease Fire", maps\mp\uox\_uox::updateCeaseFire);

	maps\mp\uox\_uox_vars::varDef("scr", "killcam", "bool", true,
								true, undefined, undefined, "Killcam", maps\mp\uox\_uox::updateKillcam);
	/*
	killcam = getCvar("scr_killcam");
	if(killcam == "")				// Kill cam
		killcam = "1";
	setCvar("scr_killcam", killcam, true);
	level.killcam = getCvarInt("scr_killcam");
	*/
	// this is just to define this variable to other scripts that use it dont crash
	level.drawfriend = 0;
	level.teambalance = 0;
	level.lockteams = false;
	level.teamkill_penalty = false;
	
	level.QuickMessageToAll = true;
	level.mapended = false;
	level.healthqueue = [];
	level.healthqueuecurrent = 0;
	
	if([[level.getVars]]("scr_killcam"))
		setarchive(true);
}
/*
Callback_StartGameType()
{
	maps\mp\uox\_uox_callbacks::Callback_StartGameType();
	thread maps\mp\uox\_uox::startGame();
	thread updateGametypeCvars();
}
*/
updateDeathArray()
{
	if(!isDefined(level.deatharray))
	{
		level.deatharray[0] = self.origin;
		level.deatharraycurrent = 1;
		return;
	}

	if(level.deatharraycurrent < 31)
		level.deatharray[level.deatharraycurrent] = self.origin;
	else
	{
		level.deatharray[0] = self.origin;
		level.deatharraycurrent = 1;
		return;
	}

	level.deatharraycurrent++;
}




updateGametypeCvars()
{
	for(;;)
	{
		ceasefire = getCvarint("scr_ceasefire");

		// if we are in cease fire mode display it on the screen
		if (ceasefire != level.ceasefire)
		{
			level.ceasefire = ceasefire;
			if ( ceasefire )
			{
				level thread maps\mp\_util_mp_gmi::make_permanent_announcement(&"GMI_MP_CEASEFIRE", "end ceasefire", 220, (1.0,0.0,0.0));			
			}
			else
			{
				level notify("end ceasefire");
			}
		}

		// check all the players for rank changes
		if ( getCvarint("scr_battlerank") )
			maps\mp\gametypes\_rank_gmi::CheckPlayersForRankChanges();
		
		timelimit = getCvarFloat("scr_dm_timelimit");
		if(level.timelimit != timelimit)
		{
			if(timelimit > 1440)
			{
				timelimit = 1440;
				setCvar("scr_dm_timelimit", "1440");
			}

			level.timelimit = timelimit;
			setCvar("ui_dm_timelimit", level.timelimit);
			level.starttime = getTime();

			if(level.timelimit > 0)
			{
				if(!isDefined(level.clock))
				{
					level.clock = newHudElem();
					level.clock.x = 320;
					level.clock.y = 440;
					level.clock.alignX = "center";
					level.clock.alignY = "middle";
					level.clock.font = "bigfixed";
				}
				level.clock setTimer(level.timelimit * 60);
			}
			else
			{
				if(isDefined(level.clock))
					level.clock destroy();
			}

			maps\mp\uox\_uox::checkTimeLimit();
		}

		scorelimit = getCvarInt("scr_dm_scorelimit");
		if(level.scorelimit != scorelimit)
		{
			level.scorelimit = scorelimit;
			setCvar("ui_dm_scorelimit", level.scorelimit);

			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
				players[i] maps\mp\uox\_uox::checkScoreLimit("dm");
		}

		killcam = getCvarInt("scr_killcam");
		if (level.killcam != killcam)
		{
			level.killcam = getCvarInt("scr_killcam");
			if(level.killcam >= 1)
				setarchive(true);
			else
				setarchive(false);
		}
		
		battlerank = getCvarint("scr_battlerank");
		if(level.battlerank != battlerank)
		{
			level.battlerank = battlerank;
			
			// battle rank has precidence over draw friend
			if(level.battlerank)
			{
				// for all living players, show the appropriate headicon
				players = getentarray("player", "classname");
				for(i = 0; i < players.size; i++)
			{
					// setup the hud rank indicator
					player thread maps\mp\gametypes\_rank_gmi::RankHudInit();

					player = players[i];
					
					if(isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
					{
						player.statusicon = maps\mp\gametypes\_rank_gmi::GetRankStatusIcon(player);
					}
				}
			}
		}
		wait 1;
	}
}

