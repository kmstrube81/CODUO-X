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
	
	/* init spawns */
	if(!maps\mp\uox\_uox_respawns::initSpawns("dm"))
		return;
	
	level.callbackStartGameType = ::Callback_StartGameType;
	level.callbackPlayerConnect = maps\mp\uox\_uox_callbacks::Callback_PlayerConnect;
	level.callbackPlayerDisconnect = maps\mp\uox\_uox_callbacks::Callback_PlayerDisconnect;
	level.callbackPlayerDamage = maps\mp\uox\_uox_callbacks::Callback_PlayerDamage;
	level.callbackPlayerKilled = maps\mp\uox\_uox_callbacks::Callback_PlayerKilled;

	maps\mp\gametypes\_callbacksetup::SetupCallbacks();

	allowed[0] = "dm";
	maps\mp\gametypes\_gameobjects::main(allowed);
	
	maps\mp\gametypes\_secondary_gmi::Initialize();
	
	if(getCvar("scr_dm_timelimit") == "")		// Time limit per map
		setCvar("scr_dm_timelimit", "30");
	else if(getCvarFloat("scr_dm_timelimit") > 1440)
		setCvar("scr_dm_timelimit", "1440");
	level.timelimit = getCvarFloat("scr_dm_timelimit");
	setCvar("ui_dm_timelimit", level.timelimit);
	makeCvarServerInfo("ui_dm_timelimit", "30");

	if(getCvar("scr_dm_scorelimit") == "")		// Score limit per map
		setCvar("scr_dm_scorelimit", "50");
	level.scorelimit = getCvarInt("scr_dm_scorelimit");
	setCvar("ui_dm_scorelimit", level.scorelimit);
	makeCvarServerInfo("ui_dm_scorelimit", "50");

	if(getCvar("scr_forcerespawn") == "")		// Force respawning
		setCvar("scr_forcerespawn", "0");

	if(getCvar("scr_battlerank") == "")		
		setCvar("scr_battlerank", "1");	//default is ON
	level.battlerank = getCvarint("scr_battlerank");
	setCvar("ui_battlerank", level.battlerank);
	makeCvarServerInfo("ui_battlerank", "0");

	if(getCvar("scr_shellshock") == "")		// controls whether or not players get shellshocked from grenades or rockets
		setCvar("scr_shellshock", "1");
	setCvar("ui_shellshock", getCvar("scr_shellshock"));
	makeCvarServerInfo("ui_shellshock", "0");
			
	if(!isDefined(game["compass_range"]))		// set up the compass range.
		game["compass_range"] = 1024;		
	setCvar("cg_hudcompassMaxRange", game["compass_range"]);
	makeCvarServerInfo("cg_hudcompassMaxRange", "0");

	if(getCvar("scr_drophealth") == "")		// Free look spectator
		setCvar("scr_drophealth", "1");

	// turn off ceasefire
	level.ceasefire = 0;
	setCvar("scr_ceasefire", "0");

	killcam = getCvar("scr_killcam");
	if(killcam == "")				// Kill cam
		killcam = "1";
	setCvar("scr_killcam", killcam, true);
	level.killcam = getCvarInt("scr_killcam");
	
	if(!isDefined(game["state"]))
		game["state"] = "playing";

	// this is just to define this variable to other scripts that use it dont crash
	level.drawfriend = 0;
	
	level.QuickMessageToAll = true;
	level.mapended = false;
	level.healthqueue = [];
	level.healthqueuecurrent = 0;
	
	if(level.killcam >= 1)
		setarchive(true);
}

Callback_StartGameType()
{
	maps\mp\uox\_uox_callbacks::Callback_StartGameType();
	thread startGame();
	thread updateGametypeCvars();
}

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

startGame()
{
	level.starttime = getTime();

	if(level.timelimit > 0)
	{
		level.clock = newHudElem();
		level.clock.x = 320;
		level.clock.y = 460;
		level.clock.alignX = "center";
		level.clock.alignY = "middle";
		level.clock.font = "bigfixed";
		level.clock setTimer(level.timelimit * 60);
	}

	for(;;)
	{
		checkTimeLimit();
		wait 1;
	}
}

checkTimeLimit()
{
	if(level.timelimit <= 0)
		return;

	timepassed = (getTime() - level.starttime) / 1000;
	timepassed = timepassed / 60.0;

	if(timepassed < level.timelimit)
		return;

	if(level.mapended)
		return;
	level.mapended = true;

	iprintln(&"MPSCRIPT_TIME_LIMIT_REACHED");
	level thread maps\mp\uox\_uox::endMap();
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

			checkTimeLimit();
		}

		scorelimit = getCvarInt("scr_dm_scorelimit");
		if(level.scorelimit != scorelimit)
		{
			level.scorelimit = scorelimit;
			setCvar("ui_dm_scorelimit", level.scorelimit);

			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
				players[i] maps\mp\uox\_uox::checkDeathmatchScoreLimit("dm");
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

