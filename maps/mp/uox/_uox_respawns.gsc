// ----------------------------------------------------------------------------------
//	menu_spawn
//
// 		called from the player connect to spawn the player
// ----------------------------------------------------------------------------------
menu_spawn(weapon)
{
	if(!isDefined(self.pers["weapon"]))
	{
		self.pers["weapon"] = weapon;
		spawnPlayer();
	}
	else
	{
		self.pers["weapon"] = weapon;
		
		weaponname = maps\mp\gametypes\_teams::getWeaponName(self.pers["weapon"]);
		
		if(maps\mp\gametypes\_teams::useAn(self.pers["weapon"]))
			self iprintln(&"MPSCRIPT_YOU_WILL_RESPAWN_WITH_AN", weaponname);
		else
			self iprintln(&"MPSCRIPT_YOU_WILL_RESPAWN_WITH_A", weaponname);
	}
}

spawnIntermission()
{
	self notify("spawned");
	self notify("end_respawn");
	
	resettimeout();

	self.sessionstate = "intermission";
	self.spectatorclient = -1;
	self.archivetime = 0;

	spawnpointname = "mp_deathmatch_intermission";
	spawnpoints = getentarray(spawnpointname, "classname");
	spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

	if(isDefined(spawnpoint))
		self spawn(spawnpoint.origin, spawnpoint.angles);
	else
		maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
}

spawnPlayer()
{
	self notify("spawned");
	self notify("end_respawn");

	resettimeout();

	self.sessionteam = "none";
	self.sessionstate = "playing";
	self.spectatorclient = -1;
	self.archivetime = 0;
		
	// make sure that the client compass is at the correct zoom specified by the level
	self setClientCvar("cg_hudcompassMaxRange", game["compass_range"]);

	spawnpointname = "mp_deathmatch_spawn";
	spawnpoints = getentarray(spawnpointname, "classname");
	spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_DM(spawnpoints);

	if(isDefined(spawnpoint))
		self spawn(spawnpoint.origin, spawnpoint.angles);
	else
		maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");

	self.statusicon = "";
	self.maxhealth = 100;
	self.health = self.maxhealth;

	self.pers["rank"] = maps\mp\gametypes\_rank_gmi::DetermineBattleRank(self);
	self.rank = self.pers["rank"];
	
	if(!isDefined(self.pers["savedmodel"]))
		maps\mp\gametypes\_teams::model();
	else
		maps\mp\_utility::loadModel(self.pers["savedmodel"]);

	// setup all the weapons
	self maps\mp\gametypes\_loadout_gmi::PlayerSpawnLoadout();
	
	self setClientCvar("cg_objectiveText", &"DM_KILL_OTHER_PLAYERS");

	// set the status icon if battlerank is turned on
	if(level.battlerank)
	{
		self.statusicon = maps\mp\gametypes\_rank_gmi::GetRankStatusIcon(self);
	}	

	// setup the hud rank indicator
	self thread maps\mp\gametypes\_rank_gmi::RankHudInit();
}

spawnSpectator(origin, angles)
{
	self notify("spawned");
	self notify("end_respawn");
	
	resettimeout();

	self.sessionstate = "spectator";
	self.spectatorclient = -1;
	self.archivetime = 0;

	if(self.pers["team"] == "spectator")
		self.statusicon = "";
	
	if(isDefined(origin) && isDefined(angles))
		self spawn(origin, angles);
	else
	{
		spawnpointname = "mp_deathmatch_intermission";
		spawnpoints = getentarray(spawnpointname, "classname");
		spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

		if(isDefined(spawnpoint))
			self spawn(spawnpoint.origin, spawnpoint.angles);
		else
			maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
	}

	self setClientCvar("cg_objectiveText", &"DM_KILL_OTHER_PLAYERS");
}

respawn()
{
	self endon("end_respawn");
	
	firsttime = 0;
	while(!isDefined(self.pers["weapon"])) {
		
		wait 3;
		
		//self iprintln(&"");	// TODO: tell them they need to select a weapon in order to spawn
		
		if (isDefined(self.pers["weapon"]))
			break;
		
		if (firsttime < 3)
		{
			if(self.pers["team"] == "allies")
				self openMenu(game["menu_weapon_allies"]);
			else
				self openMenu(game["menu_weapon_axis"]);
		}
		firsttime++;
	
		self waittill("menuresponse");
		
		wait 0.2;
	}
	
	respawn_mode = getRespawnMode();

	self thread [[ respawn_mode ]]();
}

respawn_dm()
{
	self thread waitRespawnButton();
	self waittill("respawn");
	self thread spawnPlayer();
}

respawn_forced()
{
	self thread waitForceRespawnTime();
	self thread waitRespawnButton();
	self waittill("respawn");
	self thread spawnPlayer();
}

respawn_delayed()
{
	if(self.pers["team"] != "allies" && self.pers["team"] != "axis")
	{
		maps\mp\_utility::error("Team not set correctly on spawning player " + self + " " + self.pers["team"]);
	}
	
	gt = getCvar("g_gametype");
	death_wait_time_override = getCvarInt("scr_" + gt + "_spawndelay_time");
	
	if(death_wait_time_override > 0)
		death_wait_time = death_wait_time_override;
	else
	{
		if(getCvarInt("scr_spawndelay_time") > 0)
			death_wait_time = getCvarInt("scr_spawndelay_time");
		else 
			death_wait_time = 7;
	}
	
	self thread maps\mp\uox\_uox::stopwatch_start("respawn", death_wait_time);

	wait (death_wait_time);

	self thread spawnPlayer();
}

respawn_wave()
{
	wait(0.01);
	
	if(self.pers["team"] != "allies" && self.pers["team"] != "axis")
	{
		maps\mp\_utility::error("Team not set correctly on spawning player " + self + " " + self.pers["team"]);
	}
	
	gt = getCvar("g_gametype");
	wave_time_override = getCvarInt("scr_" + gt + "_respawn_wave_time");
	
	if(wave_time_override > 0)
		timer = wave_time_override;
	else
	{
		if(getCvarInt("scr_respawn_wave_time") > 0)
			timer = getCvarInt("scr_respawn_wave_time");
		else 
			timer = 7;
	}
	
	if(!isDefined(level.respawn_timer))
		level.respawn_timer = [];
	if(!isDefined(level.respawn_timer[self.pers["team"]]))
		level.respawn_timer[self.pers["team"]] = timer;	
	self maps\mp\uox\_uox::stopwatch_start("respawn", level.respawn_timer[self.pers["team"]] );
	level thread respawn_pool(self.pers["team"], timer);
	
	level waittill("respawn_" + self.pers["team"]);
	
	self thread spawnPlayer();
}

// ----------------------------------------------------------------------------------
//	respawn_pool
//
// 		Gets called for every guy that dies.  Starts the next wave timer if 
//		is not already started.  Sends out a notification when 
//		done.
// ----------------------------------------------------------------------------------
respawn_pool(team, timer)
{
	level endon("respawn_" + team);
	
	if(isDefined(level.respawn_timer) && isDefined(level.respawn_timer[team])
	  && level.respawn_timer[team] < timer)
		return;
		
	for(i=timer;i>0;i--)
	{
		level.respawn_timer[team] = i;
		wait 1;
	}
	level.respawn_timer[team] = timer;	
	level notify("respawn_" + team);
}

respawn_obj()
{
	if(self.pers["team"] != "allies" && self.pers["team"] != "axis")
	{
		maps\mp\_utility::error("Team not set correctly on spawning player " + self + " " + self.pers["team"]);
	}
	
	gt = getCvar("g_gametype");
	
	if(getCvar("scr_" + gt + "_reinforcements") != "")
		reinforcements = getCvarInt("scr_" + gt + "_reinforcements");
	else
		reinforcements = getCvarInt("scr_reinforcements");
	
	if(!isDefined(self.pers["lives"]))
		self.pers["lives"] = reinforcements;
	
	if(reinforcements == -1 || self.pers["lives"] > 0)
	{
		self.pers["lives"]--;
		self thread respawn_forced();
	}
	else
		self spawnSpectator();
}

respawn_hq()
{
	return;
}

getRespawnMode()
{
	gt = getCvar("g_gametype");
	respawn_mode_override = getCvar("scr_" + gt + "_respawn_mode");
	
	switch(respawn_mode_override)
	{
		case "dm": //immediate respawn
			return ::respawn_dm;
		case "forcerespawn": //same as dm but with force respawn set
			return ::respawn_forced;
		case "spawndelay": //wait X amount of seconds before spawning
			return ::respawn_delayed;
		case "wave": //respawn in waves
			return ::respawn_wave;
		case "obj": //objective respawn, typically none
			return ::respawn_obj;
		default: //get default gametype respawn mode
			switch(gt)
			{
				case "ctf":
					return ::respawn_delayed;
				case "dom":
				case "bas":
					return ::respawn_wave;
				case "hq":
					return ::respawn_hq;
				case "re":
				case "sd":
					return ::respawn_obj;
				case "dm":
				case "tdm":
				case "bel":
				default:
					if(getCvarInt("scr_forcerespawn") > 0)
						return ::respawn_forced;
					else
						return ::respawn_dm;
			}
	}
	//if you got here somehow (should never though) set dm respawn mode
	if(getCvarInt("scr_forcerespawn") > 0)
		return ::respawn_forced;
	else
		return ::respawn_dm;
}

waitForceRespawnTime()
{
	self endon("end_respawn");
	self endon("respawn");

	wait getCvarInt("scr_forcerespawn");
	self notify("respawn");
}

waitRespawnButton()
{
	self endon("end_respawn");
	self endon("respawn");

	wait 0; // Required or the "respawn" notify could happen before it's waittill has begun

	if ( getcvar("scr_forcerespawn") == "1" )
		return;
		
	self.respawntext = newClientHudElem(self);
	self.respawntext.alignX = "center";
	self.respawntext.alignY = "middle";
	self.respawntext.x = 320;
	self.respawntext.y = 70;
	self.respawntext.archived = false;
	self.respawntext setText(&"MPSCRIPT_PRESS_ACTIVATE_TO_RESPAWN");

	thread removeRespawnText();
	thread waitRemoveRespawnText("end_respawn");
	thread waitRemoveRespawnText("respawn");

	while(self useButtonPressed() != true)
		wait .05;

	self notify("remove_respawntext");

	self notify("respawn");
}

removeRespawnText()
{
	self waittill("remove_respawntext");

	if(isDefined(self.respawntext))
		self.respawntext destroy();
}

waitRemoveRespawnText(message)
{
	self endon("remove_respawntext");

	self waittill(message);
	self notify("remove_respawntext");
}