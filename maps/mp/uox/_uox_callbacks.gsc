Callback_StartGameType()
{   
    //init loops
	level thread maps\mp\uox\_uox_loops::initServerLoop();
	
    //init gametype teamplay and map vars
	level.gametype = getCvar("g_gametype");
	level.mapname = getCvar("mapname");
	level.uox_teamplay = maps\mp\uox\_uox::isTeamPlayGametype(level.gametype);
	
    //init objectives
	maps\mp\uox\_uox::initObjectives(level.objective);
	//init vars
	maps\mp\uox\_uox_vars::initGameTypeVars();
	maps\mp\gametypes\_teams::initGlobalCvars();
	maps\mp\gametypes\_teams::initWeaponCvars();
	
    if(level.uox_teamplay) {
        level.exist["allies"] = 0;
        level.exist["axis"] = 0;
        level.exist["teams"] = false;
        level.didexist["allies"] = false;
        level.didexist["axis"] = false;
    }
    else 
    {
        level.exist["2players"] = -1;
        level.didexist["2players"] = false;
    }
	
	level.roundstarted = false;
	level.roundended = false;
	level.mapended = false;
	level.warmup = false;
	level.doingReadyUp = false;
	level.playersready = false;
	level.playerLock = false;
	level.lockteams = false;
	level.healthqueue = [];
	level.healthqueuecurrent = 0;
	level.alliedscore = 0;
	level.axisscore = 0;
	level.defense_points = 0;
	level.didFinalKillcam = false;
	
	if (!isdefined (game["BalanceTeamsNextRound"]))
		game["BalanceTeamsNextRound"] = false;
	
	if([[level.getVars]]("scr_roundlimit") % 2)
		level.halfround = ([[level.getVars]]("scr_roundlimit") / 2) + 1;
	else
		level.halfround = [[level.getVars]]("scr_roundlimit") / 2;
	if([[level.getVars]]("scr_scorelimit") % 2)
		level.halfscore = ([[level.getVars]]("scr_scorelimit")/2) + 1;
	else
		level.halfscore = [[level.getVars]]("scr_scorelimit") / 2;
						
	maps\mp\gametypes\_rank_gmi::InitializeBattleRank();
	maps\mp\uox\_uox_hud::initServerHUD();
		
	if(!isDefined(game["gamestarted"]))
	{
	
		if(!isDefined(game["timepassed"]))
			game["timepassed"] = 0;
		if(!isDefined(game["state"]))
			game["state"] = "playing";
		if(!isDefined(game["roundsplayed"]))
			game["roundsplayed"] = 0;
		if(!isDefined(game["matchstarted"]))
			game["matchstarted"] = false;
		if(!isDefined(game["suddendeath"]))
			game["suddendeath"] = false;
		if(!isDefined(game["g_speed"]))
			game["g_speed"] = getCvar("g_speed");
		if(!isDefined(game["half"]))
			game["half"] = 1;
		if(!isDefined(game["round1team1score"]))
			game["round1team1score"] = 0;
		if(!isDefined(game["round2team1score"]))
			game["round2team1score"] = 0;
		if(!isDefined(game["round1team2score"]))
			game["round1team2score"] = 0;
		if(!isDefined(game["round2team2score"]))
			game["round2team2score"] = 0;
		if(!isDefined(game["alliedkills"]))
			game["alliedkills"] = 0;
		if(!isDefined(game["axiskills"]))
			game["axiskills"] = 0;
		if(!isDefined(game["alliedscore"]))
			game["alliedscore"] = 0;
		if(!isDefined(game["axisscore"]))
			game["axisscore"] = 0;
		if(!isDefined(game["alliesRoundsWon"]))
			game["alliesRoundsWon"] = 0;
		if(!isDefined(game["axisRoundsWon"]))
			game["axisRoundsWon"] = 0;
		// defaults if not defined in level script
		if(!isDefined(game["allies"]))
			game["allies"] = "american";
		if(!isDefined(game["axis"]))
			game["axis"] = "german";
        // server cvar overrides
		if(getCvar("scr_allies") != "")
			game["allies"] = getCvar("scr_allies");
		if(getCvar("scr_axis") != "")
			game["axis"] = getCvar("scr_axis");
		//set up team1/team2
		if(!isDefined(game["attackers"]))
			game["team1"] = "allies";
		else
			game["team1"] = game["attackers"];
		if(!isDefined(game["defenders"]))
			game["team2"] = "axis";
		else
			game["team2"] = game["defenders"];
		if(!isDefined(game["layoutimage"]))
			game["layoutimage"] = "default";
		layoutname = "levelshots/layouts/hud@layout_" + game["layoutimage"];
		precacheShader(layoutname);
		setCvar("scr_layoutimage", layoutname);
		makeCvarServerInfo("scr_layoutimage", "");

        maps\mp\uox\_uox_menus::defineMenus();
        maps\mp\uox\_uox_menus::precache();
		maps\mp\uox\_uox_hud::precache();
		maps\mp\uox\_uox::precacheObjective(level.objective);
		precacheItem("item_health");

		maps\mp\gametypes\_teams::precache();
		maps\mp\gametypes\_teams::scoreboard();
	}
	
	maps\mp\gametypes\_teams::modeltype();
	maps\mp\gametypes\_teams::restrictPlacedWeapons();
	thread maps\mp\gametypes\_teams::updateGlobalCvars();
	thread maps\mp\gametypes\_teams::updateWeaponCvars();
	thread maps\mp\uox\_uox_hud::updateScoreboard();
	
	game["gamestarted"] = true;
	
	if(game["roundbased"])
		setClientNameMode("manual_change");
	else
		setClientNameMode("auto_change");

	thread maps\mp\uox\_uox::addBotClients(); // For development testing
	
	thread maps\mp\uox\_uox::startGame();
	maps\mp\uox\_uox_loops::addToLoop(level, "slow", maps\mp\uox\_uox_vars::updateVars);
}

Callback_PlayerConnect()
{
	self thread maps\mp\uox\_uox_loops::initPlayerLoop();
	self maps\mp\uox\_uox_loops::addToLoop(self, "slow",
		maps\mp\uox\_uox_vars::enforceClientCvars); 
	self maps\mp\uox\_uox_inputs::initPlayerInputs();

	self.statusicon = "gfx/hud/hud@status_connecting.tga";
	self waittill("begin");
	self.statusicon = "";
	self.pers["teamTime"] = 1000000;

	if(!isDefined(self.pers["team"]))
		iprintln(&"MPSCRIPT_CONNECTED", self);

	lpselfnum = self getEntityNumber();
	lpselfguid = self getGuid();
	logPrint("J;" + lpselfguid + ";" + lpselfnum + ";" + self.name + "\n");
	
	maps\mp\uox\_uox_warmup::onPlayerConnect(lpselfnum);
	
	//init values
	if(!isDefined(self.pers["roundswon"]))
		self.pers["roundswon"] = 0;
	if (!isDefined(self.pers["rank"]))
		self.pers["rank"] = 0;
	if(!isDefined(self.pers["score"]))
		self.pers["score"] = 0;
	if(!isDefined(self.pers["deaths"]))
		self.pers["deaths"] = 0;
	if(!isDefined(self.pers["kills"]))
		self.pers["kills"] = 0;
	self.score = self.pers["score"];
	self.deaths = self.pers["deaths"];
	if(!isDefined(self.pers["1HScore"]))
		self.pers["1HScore"] = 0;
	if(!isDefined(self.pers["2HScore"]))
		self.pers["2HScore"] = 0;
	self.sessionspawned = false;
	self.objs_held = 0;
	
	//init HUD
	self maps\mp\uox\_uox_hud::initClientHUD();
	
	if(level.playerlock)
		self maps\mp\uox\_uox::lockInPlace();
	
	// set the cvar for the map quick bind
	self setClientCvar("g_scriptQuickMap", game["menu_viewmap"]);
	
	if(game["state"] == "intermission")
	{
		maps\mp\uox\_uox_respawns::spawnIntermission();
		return;
	}

	level endon("intermission");

	// start the vsay thread
	self thread maps\mp\gametypes\_teams::vsay_monitor();

	if(isDefined(self.pers["team"]) && self.pers["team"] != "spectator")
	{
		self setClientCvar("ui_weapontab", "1");
		self.sessionteam = "none";

		if(self.pers["team"] == "allies")
			self setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);
		else
			self setClientCvar("g_scriptMainMenu", game["menu_weapon_axis"]);

		if(isDefined(self.pers["weapon"]))
			maps\mp\uox\_uox_respawns::spawnPlayer();
		else
		{
			maps\mp\uox\_uox_respawns::spawnSpectator();

			if(self.pers["team"] == "allies")
				self openMenu(game["menu_weapon_allies"]);
			else
				self openMenu(game["menu_weapon_axis"]);
		}
	}
	else
	{
		self setClientCvar("g_scriptMainMenu", game["menu_team"]);
		self setClientCvar("ui_weapontab", "0");

		if(!isDefined(self.pers["skipserverinfo"]))
			self openMenu(game["menu_serverinfo"]);

		self.pers["team"] = "spectator";
		self.sessionteam = "spectator";

		maps\mp\uox\_uox_respawns::spawnSpectator();
	}


    self maps\mp\uox\_uox_loops::addToWaitTills(self, "menuresponse", maps\mp\uox\_uox_menus::handleMenuResponse, true, true);

}

Callback_PlayerDisconnect()
{
	self notify("disconnect");
	iprintln(&"MPSCRIPT_DISCONNECTED", self);

	lpselfnum = self getEntityNumber();
	lpselfguid = self getGuid();
	logPrint("Q;" + lpselfguid + ";" + lpselfnum + ";" + self.name + "\n");
	
	self maps\mp\uox\_uox_retrievals::drop_all();
	
	maps\mp\uox\_uox_warmup::OnPlayerDisconnect(lpselfnum);
	
	if(game["matchstarted"])
		level thread maps\mp\uox\_uox::updateTeamStatus();
}

Callback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc)
{
	if(self.sessionteam == "spectator")
		return;

	// dont take damage during ceasefire mode
	// but still take damage from ambient damage (water, minefields, fire)
	if([[level.getVars]]("scr_ceasefire") && sMeansOfDeath != "MOD_EXPLOSIVE" && sMeansOfDeath != "MOD_WATER" && sMeansOfDeath != "MOD_TRIGGER_HURT")
		return;
	
	if(level.roundended)
		return;

	// Don't do knockback if the damage direction was not specified
	if(!isDefined(vDir))
		iDFlags |= level.iDFLAGS_NO_KNOCKBACK;

	//don't do team checks for non-team games
	if(!level.uox_teamplay)
	{
		// Make sure at least one point of damage is done
		if(iDamage < 1)
			iDamage = 1;
			
		self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc);
	}
	else
	{
		if(isPlayer(eAttacker) && (self != eAttacker) && (self.pers["team"] == eAttacker.pers["team"]))
		{
			if([[level.getVars]]("scr_friendlyfire") == "1")
			{
				// Make sure at least one point of damage is done
				if(iDamage < 1)
					iDamage = 1;
				self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc);
			}
			else if([[level.getVars]]("scr_friendlyfire") == "0" )
			{
				return;
			}
			else if([[level.getVars]]("scr_friendlyfire") == "2")
			{
				eAttacker.friendlydamage = true;
		
				iDamage = iDamage * .5;

				// Make sure at least one point of damage is done
				if(iDamage < 1)
					iDamage = 1;
				
				eAttacker finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc);
				eAttacker.friendlydamage = undefined;
				
				friendly = true;
			}
			else if([[level.getVars]]("scr_friendlyfire") == "3")
			{
				eAttacker.friendlydamage = true;

				iDamage = iDamage * .5;

				// Make sure at least one point of damage is done
				if(iDamage < 1)
					iDamage = 1;
				
				self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc);
				eAttacker finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc);
				eAttacker.friendlydamage = undefined;
				
				friendly = true;
			}
		}
		else
		{
			// Make sure at least one point of damage is done
			if(iDamage < 1)
				iDamage = 1;
			self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc);
		}
	}

	self maps\mp\gametypes\_shellshock_gmi::DoShellShock(sWeapon, sMeansOfDeath, sHitLoc, iDamage);

	// Do debug print if it's enabled
	if(getCvarInt("g_debugDamage"))
	{
		println("client:" + self getEntityNumber() + " health:" + self.health +
			" damage:" + iDamage + " hitLoc:" + sHitLoc);
	}

	// Apply the damage to the player
	self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc);

	if(self.sessionstate != "dead")
	{
		lpselfnum = self getEntityNumber();
		lpselfname = self.name;
		lpselfteam = self.pers["team"];
		lpselfGuid = self getGuid();
		lpattackerteam = "";

		if(isPlayer(eAttacker))
		{
			lpattacknum = eAttacker getEntityNumber();
			lpattackGuid = eAttacker getGuid();
			lpattackname = eAttacker.name;
			lpattackerteam = eAttacker.pers["team"];
		}
		else
		{
			lpattacknum = -1;
			lpattackGuid = "";
			lpattackname = "";
			lpattackerteam = "world";
		}

		logPrint("D;" + lpselfGuid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattackGuid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");
	}
}

Callback_PlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc)
{
	self endon("spawned");

	if(self.sessionteam == "spectator")
		return;
	
	if(level.roundended)
		return;

	// If the player was killed by a head shot, let players know it was a head shot kill
	if(sHitLoc == "head" && sMeansOfDeath != "MOD_MELEE")
		sMeansOfDeath = "MOD_HEAD_SHOT";

	// if this is a melee kill from a binocular then make sure they know that they are a loser
	if(sMeansOfDeath == "MOD_MELEE" && (sWeapon == "binoculars_artillery_mp" || sWeapon == "binoculars_mp") )
	{
		sMeansOfDeath = "MOD_MELEE_BINOCULARS";
	}
	
	// if this is a kill from the artillery binocs change the icon
	if(sMeansOfDeath != "MOD_MELEE_BINOCULARS" && sWeapon == "binoculars_artillery_mp" )
		sMeansOfDeath = "MOD_ARTILLERY";

	// send out an obituary message to all clients about the kill
	obituary(self, attacker, sWeapon, sMeansOfDeath);

	self.sessionstate = "dead";
	if(!level.doingReadyUp)
		self.statusicon = "gfx/hud/hud@status_dead.tga";
	self.deaths++;
	self.pers["deaths"] = self.deaths;

	lpselfnum = self getEntityNumber();
	lpselfname = self.name;
	lpselfteam = "";
	lpselfguid = self getGuid();
	lpattackerteam = "";

	attackerNum = -1;
	if(isPlayer(attacker))
	{
		if(attacker == self) // killed himself
		{
			doKillcam = false;	
		}
		else
		{
			attackerNum = attacker getEntityNumber();
			doKillcam = true;
		}
		lpattacknum = attacker getEntityNumber();
		lpattackguid = attacker getGuid();
		lpattackname = attacker.name;
		level thread maps\mp\uox\_uox::checkPlayerKilled(self, attacker);
	}
	else // If you weren't killed by a player, you were in the wrong place at the wrong time
	{
		doKillcam = false;

		lpattacknum = -1;
		lpattackguid = "";
		lpattackname = "";
		lpattackerteam = "world";
	}
	
	if(!level.warmup)
		logPrint("K;" + lpselfguid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattackguid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");

	// Stop thread if map ended on this death
	if(level.mapended)
		return;
		
//	self updateDeathArray();

	// Make the player drop his weapon
	self dropItem(self getcurrentweapon());

	// Make the player drop health
	self dropHealth();

	body = self cloneplayer();

	//immediately deduct life when its your last one
	if(isDefined(self.lives) && self.lives == 0)
		self.lives--;
	maps\mp\uox\_uox::updateTeamStatus();

	delay = 2;	// Delay the player becoming a spectator till after he's done dying
	wait delay;	// ?? Also required for Callback_PlayerKilled to complete before respawn/killcam can execute
	
	if(([[level.getVars]]("scr_killcam") <= 0) || ([[level.getVars]]("scr_forcerespawn") > 0))
		doKillcam = false;
	
	if(doKillcam)
	{
		self thread maps\mp\uox\_uox_killcam::killcam(attackerNum, lpattackguid, lpattackerteam,
			lpattackname, delay);
	}
	else
		self thread maps\mp\uox\_uox_respawns::respawn();
}

dropHealth()
{
	if ( ![[level.getVars]]("scr_drophealth") )
		return;
		
	if(isDefined(level.healthqueue[level.healthqueuecurrent]))
		level.healthqueue[level.healthqueuecurrent] delete();
	
	level.healthqueue[level.healthqueuecurrent] = spawn("item_health", self.origin + (0, 0, 1));
	level.healthqueue[level.healthqueuecurrent].angles = (0, randomint(360), 0);

	level.healthqueuecurrent++;
	
	if(level.healthqueuecurrent >= 16)
		level.healthqueuecurrent = 0;
}