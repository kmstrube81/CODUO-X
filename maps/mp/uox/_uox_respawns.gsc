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

	level maps\mp\uox\_uox::updateTeamStatus();
	if(!game["matchstarted"])
		level maps\mp\uox\_uox::checkMatchStart();
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
	
	self thread maps\mp\uox\_uox_hud::stopwatch_start("respawn", death_wait_time);

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
	self maps\mp\uox\_uox_hud::stopwatch_start("respawn", level.respawn_timer[self.pers["team"]] );
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

spawnPlayer(farthest)
{
	self notify("spawned");
	self notify("end_respawn");

	resettimeout();

	if(level.uox_teamplay)
		self.sessionteam = self.pers["team"];
	else
		self.sessionteam = "none";
	self.sessionstate = "playing";
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.friendlydamage = undefined;
		
	// make sure that the client compass is at the correct zoom specified by the level
	self setClientCvar("cg_hudcompassMaxRange", game["compass_range"]);
	
	gt = getCvar("g_gametype");
	
	spawnpoint = getSpawn(gt, farthest);
	
	if(isDefined(spawnpoint))
		self spawn(spawnpoint.origin, spawnpoint.angles);
	else
		maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
	
	/*
	spawnpointname = "mp_deathmatch_spawn";
	spawnpoints = getentarray(spawnpointname, "classname");
	spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_DM(spawnpoints);
	*/
	self.statusicon = "";
	self.maxhealth = 100;
	self.health = self.maxhealth;
	
	if(!isDefined(self.pers["score"]))
		self.pers["score"] = 0;
	self.score = self.pers["score"];
	
	if(!isDefined(self.pers["roundswon"]))
		self.pers["roundswon"] = 0;
	
	level maps\mp\uox\_uox::updateTeamStatus();
	if(!game["matchstarted"])
		level maps\mp\uox\_uox::checkMatchStart();
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

getSpawn(gt, farthest)
{
	spawn_type_override = getCvar("scr_" + gt + "_spawn_type");
	
	switch(spawn_type_override)
	{
		case "deathmatch":
		case "near_team":
		case "random":
		case "middle":
		case "near_team_hq":
		case "farthest":
			spawn_type = spawn_type_override;
			break;
		default:
			spawn_type = getDefaultSpawnType(gt);
	}
	
	spawnpoints_type = getSpawnPoints(gt);
	
	switch(spawnpoints_type)
	{
		case "dm":
			spawnpointname = "mp_deathmatch_spawn";
			spawnpoints = getentarray(spawnpointname, "classname");
			break;
		case "tdm":
			spawnpointname = "mp_teamdeathmatch_spawn";
			spawnpoints = getentarray(spawnpointname, "classname");
			break;
		case "re":
			if(self.pers["team"] == "allies")
				spawnpointname = "mp_retrieval_spawn_allied";
			else
				spawnpointname = "mp_retrieval_spawn_axis";
			spawnpoints = getentarray(spawnpointname, "classname");
			break;
		case "sd":
			if(self.pers["team"] == "allies")
				spawnpointname = "mp_searchanddestroy_spawn_allied";
			else
				spawnpointname = "mp_searchanddestroy_spawn_axis";
			spawnpoints = getentarray(spawnpointname, "classname");
			break;
		case "uo":
			if(self.pers["team"] == "allies")
			{
				base_spawn_name = "mp_uo_spawn_allies";
				secondary_spawn_name = "mp_uo_spawn_allies_secondary";
			}
			else if(self.pers["team"] == "axis")
			{
				base_spawn_name = "mp_uo_spawn_axis";
				secondary_spawn_name = "mp_uo_spawn_axis_secondary";
			}	
			spawnpoints = getentarray(base_spawn_name, "classname");
			
			// now add to the array any spawnpoints that are related to held flags
			for(q=1;q<15;q++)
			{
				flag_trigger = getent("flag" + q,"targetname");
				
				if(!isDefined(flag_trigger)) // If the flag exists, then proceed. Which then tells all of the allies and axis flag to be hidden.
				{
					continue;
				}
				
				if ( !isDefined( flag_trigger.target ) )
					continue;
					
				// only get spawnpoints from flags that are held by this team	
				if ( self.pers["team"] != flag_trigger.team )
					continue;
					
				secondary_spawns =  getentarray(flag_trigger.target, "targetname");
			
				for ( i = 0; i < secondary_spawns.size; i++ )
				{
					// only get the ones for the current team
					if ( secondary_spawns[i].classname != secondary_spawn_name )
						continue;
						
					spawnpoints = maps\mp\_util_mp_gmi::add_to_array(spawnpoints, secondary_spawns[i]);
				}
			}
			
			// TODO: GRACEPERIOD secondary spawn points are used after the first few seconds of the round
			if ( true )
			{
				secondary_spawns =  getentarray(secondary_spawn_name, "classname");
			
				for ( i = 0; i < secondary_spawns.size; i++ )
				{
					
					// if this is targeted by a trigger then it must be a objective spawn so do not just grab it unless that trigger is 
					// owned by this team
					if ( isdefined(secondary_spawns[i].targetname) )
					{
						targeter =  getent(secondary_spawns[i].targetname, "target");
						
						if ( isdefined( targeter ) && isdefined(targeter.team) && targeter.team != self.pers["team"] )
						{
							continue;
						}
					}
				
					spawnpoints = maps\mp\_util_mp_gmi::add_to_array(spawnpoints, secondary_spawns[i]);
				}
			}
			spawnpoints = getentarray(spawnpointname, "classname");
			break;
		case "bas":
			// pick the appropriate spawn point
			if(self.pers["team"] == "allies")
			{
				base_spawn_name = "mp_gmi_bas_allies_spawn";
				secondary_spawn_name = "mp_gmi_bas_allied_secondary_spawn";
			}
			else 
			{
				base_spawn_name = "mp_gmi_bas_axis_spawn";
				secondary_spawn_name = "mp_gmi_bas_axis_secondary_spawn";
			}	
			// get the base spawnpoints
			spawnpoints = getentarray(base_spawn_name, "classname");
			
			// now add to the array any spawnpoints that are related to held bases
			secondary_spawns =  getentarray(secondary_spawn_name, "classname");

			for ( i = 0; i < secondary_spawns.size; i++ )
			{
				// only get the ones for the current team
				if ( secondary_spawns[i].classname != secondary_spawn_name )
					continue;
					
				spawnpoints = maps\mp\_util_mp_gmi::add_to_array(spawnpoints, secondary_spawns[i]);
			}

			// now add any secondary spawnpoints
			array = maps\mp\gametypes\_secondary_gmi::GetSecondaryTriggers(self.pers["team"]);
			for ( i = 0; i < array.size; i++ )
			{
				if ( !isDefined( array[i].target ) )
					continue;
					
				secondary_spawns =  getentarray(array[i].target, "targetname");
			
				for ( j = 0; j < secondary_spawns.size; j++ )
				{
					// only get the ones for the current team
					if ( secondary_spawns[j].classname != secondary_spawn_name )
						continue;
						
					spawnpoints = maps\mp\_util_mp_gmi::add_to_array(spawnpoints, secondary_spawns[j]);
				}
			}
			break;
		default:
			spawnpointname = "mp_teamdeathmatch_spawn";
			spawnpoints = getentarray(spawnpointname, "classname");
	}
	
	switch(spawn_type)
	{
		case "deathmatch":
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_DM(spawnpoints);
			break;
		case "near_team":
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam(spawnpoints);
			break;
		case "random":
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);
			break;
		case "middle":
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_MiddleThird(spawnpoints);
			break;
		case "near_team_hq":
			if (isdefined (farthest))
				spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Farthest(spawnpoints);
			else
				spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam_AwayfromRadios(spawnpoints);
			break;
		case "farthest":
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Farthest(spawnpoints);
			break;
		default:
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_DM(spawnpoints);
	}
	return spawnpoint;
}

getDefaultSpawnType(gt)
{
	switch(gt)
	{
		case "dm":
			return "deathmatch";
		case "tdm":
		case "ctf":
		case "dom":
		case "bas":
			return "near_team";
		case "bel":
			return "middle";
		case "hq":
			return "near_team_hq";
		case "sd":
		case "re":
			return "random";
		default:
			return "near_team";
	}
	return "near_team";
}

getDefaultSpawnPoints(gt)
{
	switch(gt)
	{
		case "dm":
			return "dm";
		case "ctf":
		case "dom":
			return "uo";
		case "bas":
			return "bas";
		case "tdm":
		case "bel":
		case "hq":
			return "tdm";
		case "sd":
			return "sd";
		case "re":
			return "re";
		default:
			return "tdm";
	}
	return "tdm";
}

getSpawnPoints(gt)
{
	spawnpoints_override = getCvar("scr_" + gt + "_spawnpoints");
	
	switch(spawnpoints_override)
	{
		case "dm":
		case "tdm":
		case "sd":
		case "re":
		case "bas":
		case "uo":
			spawnpoints_type = spawnpoints_override;
			break;
		default:
			spawnpoints_type = getDefaultSpawnPoints(gt);
	}
	
	return spawnpoints_type;
}

initSpawns(gt)
{
	spawnpoints_type = getSpawnPoints(gt);
	
	switch(spawnpoints_type)
	{
		case "uo":
			// init the spawn points first because if they do not exist then abort the game
			if ( !maps\mp\gametypes\_spawnlogic_gmi::InitSpawnPoints("mp_uo_spawn_allies", 1) )
			{
				if(gt == "dm")
					setCvar("scr_dm_spawnpoints", "dm");
				return false;
			}
			// Set up the spawnpoints of the "axis"
			if ( !maps\mp\gametypes\_spawnlogic_gmi::InitSpawnPoints("mp_uo_spawn_axis", 1) )
			{
				if(gt == "dm")
					setCvar("scr_dm_spawnpoints", "dm");
				return false;
			}
			// Set up the spawnpoints of the "axis"
			if ( !maps\mp\gametypes\_spawnlogic_gmi::InitSpawnPoints("mp_ctf_intermission", 1, 1) && !maps\mp\gametypes\_spawnlogic_gmi::InitSpawnPoints("mp_dom_intermission", 1, 1) )
			{
				if(gt == "dm")
					setCvar("scr_dm_spawnpoints", "dm");
				return false;
			}
			// set up secondary spawn points but don't abort if they are not there
			maps\mp\gametypes\_spawnlogic_gmi::InitSpawnPoints("mp_uo_spawn_allies_secondary");
			maps\mp\gametypes\_spawnlogic_gmi::InitSpawnPoints("mp_uo_spawn_axis");
			break;
		case "bas":
			if ( !maps\mp\gametypes\_spawnlogic_gmi::InitSpawnPoints("mp_gmi_bas_allies_spawn", 1) )
			{
				if(gt == "dm")
					setCvar("scr_dm_spawnpoints", "dm");
				maps\mp\_utility::error("NO allied Spawns");
				return false;
			}
			// Set up the spawnpoints of the "axis"
			if ( !maps\mp\gametypes\_spawnlogic_gmi::InitSpawnPoints("mp_gmi_bas_axis_spawn", 1) )
			{
				if(gt == "dm")
					setCvar("scr_dm_spawnpoints", "dm");
				maps\mp\_utility::error("NO axis Spawns");
				return false;
			}
			// set up secondary spawn points but don't abort if they are not there
			maps\mp\gametypes\_spawnlogic_gmi::InitSpawnPoints("mp_gmi_bas_allied_secondary_spawn");
			maps\mp\gametypes\_spawnlogic_gmi::InitSpawnPoints("mp_gmi_bas_axis_secondary_spawn");
			break;
		case "dm":
			spawnpointname = "mp_deathmatch_spawn";
			spawnpoints = getentarray(spawnpointname, "classname");
			
			if(!spawnpoints.size)
			{
				maps\mp\gametypes\_callbacksetup::AbortLevel();
				return false;
			}

			for(i = 0; i < spawnpoints.size; i++)
				spawnpoints[i] placeSpawnpoint();
			break;
		case "tdm":
			spawnpointname = "mp_teamdeathmatch_spawn";
			spawnpoints = getentarray(spawnpointname, "classname");
			
			if(!spawnpoints.size)
			{
				maps\mp\gametypes\_callbacksetup::AbortLevel();
				return false;
			}

			for(i = 0; i < spawnpoints.size; i++)
				spawnpoints[i] placeSpawnpoint();
			break;
		case "sd":
			spawnpointname = "mp_searchanddestroy_spawn_allied";
			spawnpoints = getentarray(spawnpointname, "classname");
			
			if(!spawnpoints.size)
			{
				maps\mp\gametypes\_callbacksetup::AbortLevel();
				return false;
			}

			for(i = 0; i < spawnpoints.size; i++)
				spawnpoints[i] placeSpawnpoint();

			spawnpointname = "mp_searchanddestroy_spawn_axis";
			spawnpoints = getentarray(spawnpointname, "classname");

			if(!spawnpoints.size)
			{
				maps\mp\gametypes\_callbacksetup::AbortLevel();
				return false;
			}

			for(i = 0; i < spawnpoints.size; i++)
				spawnpoints[i] PlaceSpawnpoint();
			break;
		case "re":
			spawnpointname = "mp_retrieval_spawn_allied";
			spawnpoints = getentarray(spawnpointname, "classname");
			
			if(!spawnpoints.size)
			{
				maps\mp\gametypes\_callbacksetup::AbortLevel();
				return false;
			}

			for(i = 0; i < spawnpoints.size; i++)
				spawnpoints[i] placeSpawnpoint();

			spawnpointname = "mp_retrieval_spawn_axis";
			spawnpoints = getentarray(spawnpointname, "classname");
			
			if(!spawnpoints.size)
			{
				maps\mp\gametypes\_callbacksetup::AbortLevel();
				return false;
			}

			for(i = 0; i < spawnpoints.size; i++)
				spawnpoints[i] PlaceSpawnpoint();
			break;
		default:
			spawnpointname = "mp_deathmatch_spawn";
			spawnpoints = getentarray(spawnpointname, "classname");
			
			if(!spawnpoints.size)
			{
				maps\mp\gametypes\_callbacksetup::AbortLevel();
				return false;
			}

			for(i = 0; i < spawnpoints.size; i++)
				spawnpoints[i] placeSpawnpoint();
	}
	return true;
}