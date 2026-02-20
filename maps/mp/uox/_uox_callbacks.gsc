Callback_StartGameType()
{
	level.uox_teamplay = maps\mp\uox\_uox::isTeamPlayGametype(getCvar("g_gametype"));
	// defaults if not defined in level script
	if(!isDefined(game["allies"]))
		game["allies"] = "american";
	if(!isDefined(game["axis"]))
		game["axis"] = "german";

	if(!isDefined(game["layoutimage"]))
		game["layoutimage"] = "default";
	layoutname = "levelshots/layouts/hud@layout_" + game["layoutimage"];
	precacheShader(layoutname);
	setCvar("scr_layoutimage", layoutname);
	makeCvarServerInfo("scr_layoutimage", "");

	// server cvar overrides
	if(getCvar("scr_allies") != "")
		game["allies"] = getCvar("scr_allies");
	if(getCvar("scr_axis") != "")
		game["axis"] = getCvar("scr_axis");

	game["menu_serverinfo"] = "serverinfo_" + getCvar("g_gametype");
	game["menu_team"] = "team_" + game["allies"] + game["axis"];
	game["menu_weapon_allies"] = "weapon_" + game["allies"];
	game["menu_weapon_axis"] = "weapon_" + game["axis"];
	game["menu_viewmap"] = "viewmap";
	game["menu_callvote"] = "callvote";
	game["menu_quickcommands"] = "quickcommands";
	game["menu_quickstatements"] = "quickstatements";
	game["menu_quickresponses"] = "quickresponses";
	game["menu_quickvehicles"] = "quickvehicles";
	game["menu_quickrequests"] = "quickrequests";

	precacheString(&"MPSCRIPT_PRESS_ACTIVATE_TO_RESPAWN");
	precacheString(&"MPSCRIPT_KILLCAM");
	precacheString(&"MPSCRIPT_ALLIES_WIN");
	precacheString(&"MPSCRIPT_AXIS_WIN");
	precacheString(&"GMI_MP_CEASEFIRE");

	precacheMenu(game["menu_serverinfo"]);
	precacheMenu(game["menu_team"]);
	precacheMenu(game["menu_weapon_allies"]);
	precacheMenu(game["menu_weapon_axis"]);
	precacheMenu(game["menu_viewmap"]);
	precacheMenu(game["menu_callvote"]);
	precacheMenu(game["menu_quickcommands"]);
	precacheMenu(game["menu_quickstatements"]);
	precacheMenu(game["menu_quickresponses"]);
	precacheMenu(game["menu_quickvehicles"]);
	precacheMenu(game["menu_quickrequests"]);

	precacheShader("black");
	precacheShader("hudScoreboard_mp");
	precacheShader("gfx/hud/hud@mpflag_none.tga");
	precacheShader("gfx/hud/hud@mpflag_spectator.tga");
	precacheShader("hudStopwatch");
	precacheShader("hudStopwatchNeedle");
	precacheStatusIcon("gfx/hud/hud@status_dead.tga");
	precacheStatusIcon("gfx/hud/hud@status_connecting.tga");
	precacheItem("item_health");

	
	maps\mp\gametypes\_rank_gmi::InitializeBattleRank();
	maps\mp\gametypes\_teams::modeltype();
	maps\mp\gametypes\_teams::precache();
	maps\mp\gametypes\_teams::initGlobalCvars();
	maps\mp\gametypes\_teams::initWeaponCvars();
	maps\mp\gametypes\_teams::restrictPlacedWeapons();
	thread maps\mp\gametypes\_teams::updateGlobalCvars();
	thread maps\mp\gametypes\_teams::updateWeaponCvars();

	setClientNameMode("auto_change");

	thread maps\mp\uox\_uox::addBotClients(); // For development testing
}

Callback_PlayerConnect()
{
	self.statusicon = "gfx/hud/hud@status_connecting.tga";
	self waittill("begin");
	self.statusicon = "";

	iprintln(&"MPSCRIPT_CONNECTED", self);

	lpselfnum = self getEntityNumber();
	lpselfguid = self getGuid();
	logPrint("J;" + lpselfguid + ";" + lpselfnum + ";" + self.name + "\n");
	
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

	for(;;)
	{
		self waittill("menuresponse", menu, response);

		if(menu == game["menu_serverinfo"] && response == "close")
		{
			self.pers["skipserverinfo"] = true;
			self openMenu(game["menu_team"]);
		}

		if(response == "open" || response == "close")
			continue;

		if(menu == game["menu_team"])
		{
			switch(response)
			{
			case "allies":
			case "axis":
			case "autoassign":
				if(response == "autoassign")
				{
					teams[0] = "allies";
					teams[1] = "axis";
					response = teams[randomInt(2)];
				}

				if(response == self.pers["team"] && self.sessionstate == "playing")
					break;

				if(response != self.pers["team"] && self.sessionstate == "playing")
					self suicide();

				self notify("end_respawn");

				self.pers["team"] = response;
				self.pers["weapon"] = undefined;
				self.pers["savedmodel"] = undefined;

				// if there are weapons the user can select then open the weapon menu
				if ( maps\mp\gametypes\_teams::isweaponavailable(self.pers["team"]) )
				{
					if(self.pers["team"] == "allies")
					{
						menu = game["menu_weapon_allies"];
					}
					else
					{
						menu = game["menu_weapon_axis"];
					}
				
					self setClientCvar("ui_weapontab", "1");
					self openMenu(menu);
				}
				else
				{
					self setClientCvar("ui_weapontab", "0");
					self maps\mp\uox\_uox_respawns::menu_spawn("none");
				}
		
				self setClientCvar("g_scriptMainMenu", menu);
				break;

			case "spectator":
				if(self.pers["team"] != "spectator")
				{
					self.pers["team"] = "spectator";
					self.pers["weapon"] = undefined;
					self.pers["savedmodel"] = undefined;
					
					self.sessionteam = "spectator";
					self setClientCvar("g_scriptMainMenu", game["menu_team"]);
					self setClientCvar("ui_weapontab", "0");
					maps\mp\uox\_uox_respawns::spawnSpectator();
				}
				break;

			case "weapon":
				if(self.pers["team"] == "allies")
					self openMenu(game["menu_weapon_allies"]);
				else if(self.pers["team"] == "axis")
					self openMenu(game["menu_weapon_axis"]);
				break;

			case "viewmap":
				self openMenu(game["menu_viewmap"]);
				break;

			case "callvote":
				self openMenu(game["menu_callvote"]);
				break;
			}
		}
		else if(menu == game["menu_weapon_allies"] || menu == game["menu_weapon_axis"])
		{
			if(response == "team")
			{
				self openMenu(game["menu_team"]);
				continue;
			}
			else if(response == "viewmap")
			{
				self openMenu(game["menu_viewmap"]);
				continue;
			}
			else if(response == "callvote")
			{
				self openMenu(game["menu_callvote"]);
				continue;
			}

			if(!isDefined(self.pers["team"]) || (self.pers["team"] != "allies" && self.pers["team"] != "axis"))
				continue;
				
			weapon = self maps\mp\gametypes\_teams::restrict(response);

			if(weapon == "restricted")
			{
				self openMenu(menu);
				continue;
			}

			if(isDefined(self.pers["weapon"]) && self.pers["weapon"] == weapon)
				continue;

			maps\mp\uox\_uox_respawns::menu_spawn(weapon);
		}
		else if(menu == game["menu_viewmap"])
		{
			switch(response)
			{
			case "team":
				self openMenu(game["menu_team"]);
				break;

			case "weapon":
				if(self.pers["team"] == "allies")
					self openMenu(game["menu_weapon_allies"]);
				else if(self.pers["team"] == "axis")
					self openMenu(game["menu_weapon_axis"]);
				break;

			case "callvote":
				self openMenu(game["menu_callvote"]);
				break;
			}
		}
		else if(menu == game["menu_callvote"])
		{
			switch(response)
			{
			case "team":
				self openMenu(game["menu_team"]);
				break;

			case "weapon":
				if(self.pers["team"] == "allies")
					self openMenu(game["menu_weapon_allies"]);
				else if(self.pers["team"] == "axis")
					self openMenu(game["menu_weapon_axis"]);
				break;

			case "viewmap":
				self openMenu(game["menu_viewmap"]);
				break;
			}
		}
		else if(menu == game["menu_quickcommands"])
			maps\mp\gametypes\_teams::quickcommands(response);
		else if(menu == game["menu_quickstatements"])
			maps\mp\gametypes\_teams::quickstatements(response);
		else if(menu == game["menu_quickresponses"])
			maps\mp\gametypes\_teams::quickresponses(response);
		else if(menu == game["menu_quickvehicles"])
			maps\mp\gametypes\_teams::quickvehicles(response);
		else if(menu == game["menu_quickrequests"])
			maps\mp\gametypes\_teams::quickrequests(response);
	}
}

Callback_PlayerDisconnect()
{
	iprintln(&"MPSCRIPT_DISCONNECTED", self);

	lpselfnum = self getEntityNumber();
	lpselfguid = self getGuid();
	logPrint("Q;" + lpselfguid + ";" + lpselfnum + ";" + self.name + "\n");
}

Callback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc)
{
	if(self.sessionteam == "spectator")
		return;

	// dont take damage during ceasefire mode
	// but still take damage from ambient damage (water, minefields, fire)
	if(level.ceasefire && sMeansOfDeath != "MOD_EXPLOSIVE" && sMeansOfDeath != "MOD_WATER" && sMeansOfDeath != "MOD_TRIGGER_HURT")
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
			if(level.friendlyfire == "1")
			{
				// Make sure at least one point of damage is done
				if(iDamage < 1)
					iDamage = 1;
				self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc);
			}
			else if(level.friendlyfire == "0" )
			{
				return;
			}
			else if(level.friendlyfire == "2")
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
			else if(level.friendlyfire == "3")
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
	self.statusicon = "gfx/hud/hud@status_dead.tga";
	self.deaths++;

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

			attacker.score--;
		}
		else
		{
			attackerNum = attacker getEntityNumber();
			doKillcam = true;

			attacker.score++;
			level maps\mp\uox\_uox::checkRoundEndPlayerKilled();
		}

		lpattacknum = attacker getEntityNumber();
		lpattackguid = attacker getGuid();
		lpattackname = attacker.name;
	}
	else // If you weren't killed by a player, you were in the wrong place at the wrong time
	{
		doKillcam = false;

		self.score--;

		lpattacknum = -1;
		lpattackguid = "";
		lpattackname = "";
	}
	
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

	delay = 2;	// Delay the player becoming a spectator till after he's done dying
	wait delay;	// ?? Also required for Callback_PlayerKilled to complete before respawn/killcam can execute
	
	if((getCvarInt("scr_killcam") <= 0) || (getCvarInt("scr_forcerespawn") > 0))
		doKillcam = false;
	
	if(doKillcam)
		self thread maps\mp\uox\_uox_killcam::killcam(attackerNum, delay);
	else
		self thread maps\mp\uox\_uox_respawns::respawn();
}

dropHealth()
{
	if ( !getcvarint("scr_drophealth") )
		return;
		
	if(isDefined(level.healthqueue[level.healthqueuecurrent]))
		level.healthqueue[level.healthqueuecurrent] delete();
	
	level.healthqueue[level.healthqueuecurrent] = spawn("item_health", self.origin + (0, 0, 1));
	level.healthqueue[level.healthqueuecurrent].angles = (0, randomint(360), 0);

	level.healthqueuecurrent++;
	
	if(level.healthqueuecurrent >= 16)
		level.healthqueuecurrent = 0;
}