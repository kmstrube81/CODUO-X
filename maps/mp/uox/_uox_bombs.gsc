precache()
{
	game["bombPlantedText"] = &"SD_EXPLOSIVESPLANTED";
	precacheString(game["bombPlantedText"]);
	game["bombDefusedText"] = &"SD_EXPLOSIVESDEFUSED";
	precacheString(game["bombDefusedText"]);
	game["alliesSuccessText"] = &"SD_ALLIEDMISSIONACCOMPLISHED";
	precacheString(game["alliesSuccessText"]);
	game["axisSuccessText"] = &"SD_AXISMISSIONACCOMPLISHED";
	precacheString(game["axisSuccessText"]);
	precacheShader("ui_mp/assets/hud@plantbomb.tga");
	precacheShader("ui_mp/assets/hud@defusebomb.tga");
	precacheShader("gfx/hud/hud@objectiveA.tga");
	precacheShader("gfx/hud/hud@objectiveA_up.tga");
	precacheShader("gfx/hud/hud@objectiveA_down.tga");
	precacheShader("gfx/hud/hud@objectiveB.tga");
	precacheShader("gfx/hud/hud@objectiveB_up.tga");
	precacheShader("gfx/hud/hud@objectiveB_down.tga");
	precacheShader("gfx/hud/hud@bombplanted.tga");
	precacheShader("gfx/hud/hud@bombplanted_up.tga");
	precacheShader("gfx/hud/hud@bombplanted_down.tga");
	precacheShader("gfx/hud/hud@bombplanted_down.tga");
	precacheModel("xmodel/mp_bomb1_defuse");
	precacheModel("xmodel/mp_bomb1");
}

initVars()
{
	//init gametype vars
	maps\mp\uox\_uox_vars::varDef("scr", "bombplanttime", "int", true,
		7, 3, 20, "Bomb Plant Time");
	maps\mp\uox\_uox_vars::varDef("scr", "bombdefusetime", "int", true,
		10, 3, 20, "Bomb Defuse Time");
	level.countdowntime = maps\mp\uox\_uox_vars::varDef("scr", "bombtimer", "int", true,
		60, 3, 120, "Bomb Explode Timer");
	/* Bomb Plant Modes:
		0 = default SD plant mode, single site, round ends after defusal
		1 = can dual plant bombsites, round ends after timer/elims or 1 bomb explodes
		2 = can dual plant bombsites, round ends after timer/elims or both bombs explode */
	level.bombmode = maps\mp\uox\_uox_vars::varDef("scr", "bombplantmode", "int", true,
		0, 0, 2, "Bomb Plant Mode");
	if(![[level.getVars]]("scr_score_rounds") && level.bombmode > 1)
		level.defense_points = 2;
	else 
		level.defense_points = 1;
		
	/* Bomb Plant Bonus Points:
		extra points given to players who plant the bomb*/
	maps\mp\uox\_uox_vars::varDef("scr", "bombplantbonuspoints", "int", true,
		0, 0, 10, "Bomb Plant Bonus Points");
	/* Bomb Defuse Bonus Points:
		extra points given to players who plant the bomb*/
	maps\mp\uox\_uox_vars::varDef("scr", "bombdefusebonuspoints", "int", true,
		0, 0, 10, "Bomb Defus Bonus Points");
	/* Bomb Bonus Time:
		extra time added to round length when one site is succesfully destroyed */
	maps\mp\uox\_uox_vars::varDef("scr", "bombbonustime", "float", true,
		2, 0, 1440, "Bomb Detonation Bonus Time");
	/* Bomb Bonus Points:
		extra points given to alive players when one site is succesfully destroyed */
	maps\mp\uox\_uox_vars::varDef("scr", "bombbonuspoints", "int", true,
		3, 0, 10, "Bomb Detonation Bonus Points");
		
	maps\mp\uox\_uox_vars::varDef("sv", "showbombtimer", "bool", true,
		true, undefined, undefined, "Show Bomb Timer");
		
}

bombzones()
{

	level._effect["bombexplosion"] = loadfx("fx/explosions/mp_bomb.efx");
	
	level.bombexploders = [];
	level.bombs = [];
	level.bombsites = [];
	level.bombsites["A"] = [];
	level.bombsites["A"]["planted"] = false;
	level.bombsites["A"]["exploded"] = false;
	level.bombsites["B"] = [];
	level.bombsites["B"]["planted"] = false;
	level.bombsites["B"]["exploded"] = false;

	bombtrigger = getent("bombtrigger", "targetname");
	bombtrigger maps\mp\_utility::triggerOff();

	bombzone_A = getent("bombzone_A", "targetname");
	bombzone_B = getent("bombzone_B", "targetname");
	bombzone_A.objectiveName = "A";
	bombzone_B.objectiveName = "B";
	bombzone_A.objective = 0;
	bombzone_B.objective = 1;
	bombzone_A.bombzone_other = bombzone_B;
	bombzone_B.bombzone_other = bombzone_A;

    bombzone_A thread maps\mp\uox\_uox_loops::initEntityLoop();
    bombzone_B thread maps\mp\uox\_uox_loops::initEntityLoop();

    bombzone_A maps\mp\uox\_uox_loops::addToWaitTills(bombzone_A, "trigger", ::bombzone_think, true);
    bombzone_B maps\mp\uox\_uox_loops::addToWaitTills(bombzone_B, "trigger", ::bombzone_think, true);

    bombzone_A thread maps\mp\uox\_uox_loops::removeFromWaitTills(bombzone_A, "trigger", level, "round_ended");
    bombzone_B thread maps\mp\uox\_uox_loops::removeFromWaitTills(bombzone_B, "trigger", level, "round_ended");

	wait 1;	// TEMP: without this one of the objective icon is the default. Carl says we're overflowing something.
	objective_add(0, "current", bombzone_A.origin, "gfx/hud/hud@objectiveA.tga");
	objective_add(1, "current", bombzone_B.origin, "gfx/hud/hud@objectiveB.tga");
}

bombzone_think(other)
{
	level endon("round_ended");

	if(!isPlayer(other) || !isDefined(other.pers["team"]))
		return;

	//attackers try to plant at this site
	if(other.pers["team"] == game["attackers"])
		other thread check_bombzone(self);
	//defenders try to defuse this site's bomb, if one is planted here
	else if(other.pers["team"] == game["defenders"] && isDefined(self.bomb))
		other thread check_bomb(self.bomb);
}

canPlant(trigger)
{
	if ( !game["matchstarted"] )
		return false;
		
	if(!isDefined(trigger) || isDefined(trigger.doing))
		return false;
	//site already has a live bomb (zone now stays active for defusing)
	if(level.bombsites[trigger.objectiveName]["planted"])
		return false;
	if(level.bombmode < 1 && isDefined(trigger.bombzone_other) && isDefined(trigger.bombzone_other.doing))
		return false;
	if(!isAlive(self) || self isinvehicle() || !(self isOnGround()))
		return false;
	if(!(self istouching(trigger)))
		return false;
	if(!(self maps\mp\_util_mp_gmi::canPlantGMI()))
		return false;
	return true;
}

planting(trigger)
{
	if(self istouching(trigger) && isAlive(self) 
		&& (self maps\mp\_util_mp_gmi::canPlantGMI()))
		return true;
	return false;
}

plantBomb(trigger)
{
	//cancel the planted-text cleanup from any earlier plant; this plant owns it now
	level notify("bomb_planted_hud");
	level endon("bomb_planted_hud");

	self maps\mp\uox\_uox_inputs::removeHoldUse("plant_bomb");
	self maps\mp\uox\_uox_hud::deleteClientHUDElement("plant_icon");
	self.pers["score"] += [[level.getVars]]("scr_bombplantbonuspoints");
	self.score = self.pers["score"];
	
	name = trigger.objectiveName;
	level.bombexploders[name] = trigger.script_noteworthy;
	
	if(level.bombmode < 1)
	{
		//single plant: retire the other site, keep this one alive for defusing
		if(isDefined(trigger.bombzone_other))
		{
			trigger.bombzone_other delete();
			trigger.bombzone_other = undefined;
		}
		objective_delete(0);
		objective_delete(1);
	}
	else
		objective_delete(trigger.objective);

	plant = self maps\mp\_util_mp_gmi::getPlantGMI();
	
	bombmodel = spawn("script_model", plant.origin);
	bombmodel.angles = plant.angles;
	bombmodel setmodel("xmodel/mp_bomb1_defuse");
	bombmodel playSound("Explo_plant_no_tick");
	bombmodel.objectiveName = name;
	bombmodel.objective = trigger.objective;

	//link site <-> bomb; all per-bomb state lives on the model from here on
	bombmodel.zone = trigger;
	trigger.bomb = bombmodel;
	level.bombs[name] = bombmodel;

	if(level.bombmode < 1)
		objective_add(0, "current", bombmodel.origin, "gfx/hud/hud@bombplanted.tga");

	//bank elapsed round time on the FIRST plant only - must run before this site is flagged
	if(!(level.bombsites["A"]["planted"] || level.bombsites["B"]["planted"]))
		level.roundTimeLeft = level.roundTimeLeft - ( (getTime() - level.roundresumetime) / 1000 );

	level.bombsites[name]["planted"] = true;
	
	lpselfnum = self getEntityNumber();
	lpselfguid = self getGuid();
	logPrint("A;" + lpselfguid + ";" + lpselfnum + ";" + game["attackers"] + ";" + self.name + ";" + "bomb_plant" + "\n");
	
	announcement(game["bombPlantedText"]);
						
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
		players[i] playLocalSound("MP_announcer_bomb_planted");
	
	options = [];
	options["x"] = 320;
	options["y"] = 440;
	options["alignX"] = "center";
	options["alignY"] = "middle";
	options["fontscale"] = 1.5;
	options["color"] = (1, 1, 0);
	level.hudplanted = maps\mp\uox\_uox_hud::updateHUDElement(level.hudplanted, "text",
		game["bombPlantedText"], options);
		
	level.mainClock = level maps\mp\uox\_uox_hud::deleteHUDMainClock();
		
	level.objectivetime = getTime();		

	if([[level.getVars]]("sv_showbombtimer"))
	{
		if(!isDefined(level.mainBombClock))
		{
			maps\mp\uox\_uox_hud::updateHUDMainBombClock([[level.getVars]]("scr_bombtimer"));
			//if secondary clock exists, move it
			if(isDefined(level.secondBombClock))
				level.secondBombClock = maps\mp\uox\_uox_hud::updateHUDElementProperty(
					level.secondBombClock, "x", 180);
			bombmodel.clock = level.mainBombClock;
		}
		else
		{
			maps\mp\uox\_uox_hud::updateHUDSecondaryBombClock(
				[[level.getVars]]("scr_bombtimer"));
			bombmodel.clock = level.secondBombClock;
		}
	}

	bombmodel thread bomb_countdown();
	
	level notify("timer_paused");

	if([[level.getVars]]("sv_showbombtimer"))
	{
		wait 8;
		level.hudplanted = maps\mp\uox\_uox_hud::deleteHUDElement(level.hudplanted);
	}
}

check_bombzone(trigger)
{
    if(isDefined(self.checking) && self.checking == trigger) //already checking this bombzone
        return;

	level endon("round_ended");
    level endon("halftime");

    self.checking = trigger;

	if(self canPlant(trigger))
	{

        maps\mp\uox\_uox_debug::debugLog("info", self.name + " create plant icon");
		iconOptions = [];
		iconOptions["alignX"] = "center";
		iconOptions["alignY"] = "middle";
		iconOptions["x"] = 320;
		iconOptions["y"] = 345;
		iconOptions["width"] = 64;
		iconOptions["height"] = 64;

		self maps\mp\uox\_uox_hud::updateClientHUDElement("plant_icon", "shader",
			"ui_mp/assets/hud@plantbomb.tga", iconOptions);
		self maps\mp\uox\_uox_inputs::addHoldUse("plant_bomb", false, 0, [[level.getVars]]("scr_bombplanttime"),
			::planting, ::plantBomb, ::check_bombzone, true, true, true, trigger, "MP_bomb_plant");

		while(self canPlant(trigger))
			wait level.frametime;
	}

    maps\mp\uox\_uox_debug::debugLog("info", self.name + " delete plant icon");
    self.checking = undefined;
	self maps\mp\uox\_uox_hud::deleteClientHUDElement("plant_icon");
	self maps\mp\uox\_uox_inputs::removeHoldUse("plant_bomb");
}

/* *************************************************************************************************
**** bomb_countdown()
****
**** self: bomb script_model spawned in plantBomb (.objectiveName, .objective, .zone, .clock)
**** USAGE: one thread per bomb; ended only by THIS bomb's "bomb_defused"
************************************************************************************************* */
bomb_countdown()
{
	self endon("bomb_defused");
	level endon("intermission");
	
	self playLoopSound("bomb_tick");

	wait level.countdowntime;

	// bomb timer is up
	name = self.objectiveName;
	zone = self.zone;
	clock = self.clock;
	origin = self.origin;

	if(level.bombmode < 1)
		objective_delete(0);
	else
		objective_delete(self.objective);

	level.bombsites[name]["exploded"] = true;
	level.bombsites[name]["planted"] = false;
	
	self notify("bomb_exploded");

	//site is finished - no more planting or defusing here
	if(isDefined(zone))
	{
		zone.bomb = undefined;
		zone maps\mp\_utility::triggerOff();
	}

	// trigger exploder if it exists
	if(isDefined(level.bombexploders[name]))
		maps\mp\_utility::exploder(level.bombexploders[name]);

	self stopLoopSound();
	level.bombs[name] = undefined;
	level.hudplanted = maps\mp\uox\_uox_hud::deleteHUDElement(level.hudplanted);
	deleteBombClock(clock);

	// explode bomb at ITS OWN origin
	playfx(level._effect["bombexplosion"], origin);
	radiusDamage(origin, 500, 2000, 1000);

	if(![[level.getVars]]("scr_score_rounds"))
	{
		level maps\mp\uox\_uox::incrementTeamScore(game["attackers"]);
		level.defense_points--;
	}
		
	if((level.bombsites["A"]["exploded"] && level.bombsites["B"]["exploded"])
		|| level.bombmode < 2)
	{
		if (game["attackers"] == "allies") {
			announcement(game["alliesSuccessText"]);
		} else {
			announcement(game["axisSuccessText"]);
		}
		level thread maps\mp\uox\_uox::endRound(game["attackers"]);
	}
	else
		resumeRoundTimerIfClear();

	//delete last: this thread runs on the model
	self delete();
}

canDefuse(bomb)
{
	if(!isDefined(bomb) || isDefined(bomb.doing))
		return false;
	if(!level.bombsites[bomb.objectiveName]["planted"])
		return false;
	if(!isAlive(self) || !(self isOnGround()))
		return false;
	if(distance(self.origin, bomb.origin) >= 64)
		return false;
	if(!(self isLookingAtBomb(bomb)))
		return false;
	return true;
}

defusing(bomb)
{
	if(!isDefined(bomb) || !isAlive(self))
		return false;
	if(distance(self.origin, bomb.origin) >= 64)
		return false;
	return self isLookingAtBomb(bomb);
}

/* *************************************************************************************************
**** isLookingAtBomb(entity bomb)
****
**** self: player
**** USAGE: facing check that used to come free from the trigger_lookat. UNVERIFIED that
**** islookingat registers on a script_model in UO 1.51 - test before relying on it
************************************************************************************************* */
isLookingAtBomb(bomb)
{
	return self islookingat(bomb);
}

defuseBomb(bomb)
{
	self maps\mp\uox\_uox_inputs::removeHoldUse("defuse_bomb");
	self maps\mp\uox\_uox_hud::deleteClientHUDElement("defuse_icon");

	//bomb went off in the same frame the hold finished
	if(!isDefined(bomb) || !level.bombsites[bomb.objectiveName]["planted"])
		return;

	self.pers["score"] += [[level.getVars]]("scr_bombdefusebonuspoints");
	self.score = self.pers["score"];

	name = bomb.objectiveName;
	zone = bomb.zone;
	clock = bomb.clock;

	bomb notify("bomb_defused"); //only this bomb's countdown listens
	bomb stopLoopSound();
	level.bombsites[name]["planted"] = false;
	level.bombs[name] = undefined;

	//defused site stays closed (same as before: no replant)
	if(isDefined(zone))
	{
		zone.bomb = undefined;
		zone maps\mp\_utility::triggerOff();
	}

	if(level.bombmode == 0)
		objective_delete(0);

	bomb delete();
	deleteBombClock(clock);

	announcement(game["bombDefusedText"]);
	
	lpselfnum = self getEntityNumber();
	lpselfguid = self getGuid();
	logPrint("A;" + lpselfguid + ";" + lpselfnum + ";" + game["defenders"] + ";" + self.name + ";" + "bomb_defuse" + "\n");
	
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
		players[i] playLocalSound("MP_announcer_bomb_defused");

	if(!(level.bombsites["A"]["planted"] || level.bombsites["B"]["planted"]))
		level.hudplanted = maps\mp\uox\_uox_hud::deleteHUDElement(level.hudplanted);
	
	if(level.bombmode == 0)
	{
		maps\mp\uox\_uox::incrementTeamScore(game["defenders"]);
		level thread maps\mp\uox\_uox::endRound(game["defenders"]);
		return;
	}
	
	resumeRoundTimerIfClear();
}

check_bomb(bomb)
{
	//bombzone fires every frame a defender is inside it, so bail quietly when not in defuse
	//position instead of churning HUD/holdUse cleanup each frame
	if(!(self canDefuse(bomb)))
		return;

	if(isDefined(self.checking) && self.checking == bomb) //already checking this bomb
		return;

	self.checking = bomb;

	iconOptions = [];
	iconOptions["alignX"] = "center";
	iconOptions["alignY"] = "middle";
	iconOptions["x"] = 320;
	iconOptions["y"] = 345;
	iconOptions["width"] = 64;
	iconOptions["height"] = 64;

	maps\mp\uox\_uox_debug::debugLog("info", self.name + " create defuse icon");

	self maps\mp\uox\_uox_hud::updateClientHUDElement("defuse_icon", "shader",
		"ui_mp/assets/hud@defusebomb.tga", iconOptions);
	self maps\mp\uox\_uox_inputs::addHoldUse("defuse_bomb", false, 0, [[level.getVars]]("scr_bombdefusetime"),
		::defusing, ::defuseBomb, ::check_bomb, true, true, true, bomb, "MP_bomb_defuse");

	while(self canDefuse(bomb))
		wait level.frametime;

	self.checking = undefined;

	maps\mp\uox\_uox_debug::debugLog("info", self.name + " delete defuse icon");

	self maps\mp\uox\_uox_hud::deleteClientHUDElement("defuse_icon");
	self maps\mp\uox\_uox_inputs::removeHoldUse("defuse_bomb");
}

/* *************************************************************************************************
**** deleteBombClock(hudelem clock)
****
**** USAGE: removes a bomb's HUD clock; if it was the main clock, slides the secondary to center
************************************************************************************************* */
deleteBombClock(clock)
{
	if(!isDefined(clock))
		return;

	if(isDefined(level.mainBombClock) && clock == level.mainBombClock)
	{
		maps\mp\uox\_uox_hud::deleteHUDMainBombClock();
		if(isDefined(level.secondBombClock))
			level.secondBombClock = maps\mp\uox\_uox_hud::updateHUDElementProperty(
				level.secondBombClock, "x", 320);
	}
	else if(isDefined(level.secondBombClock) && clock == level.secondBombClock)
		maps\mp\uox\_uox_hud::deleteHUDSecondaryBombClock();
}

/* *************************************************************************************************
**** resumeRoundTimerIfClear()
****
**** USAGE: restarts the round clock (plus bonus time) once no bomb is ticking
************************************************************************************************* */
resumeRoundTimerIfClear()
{
	if(level.bombsites["A"]["planted"] || level.bombsites["B"]["planted"])
		return;

	level.roundresumetime = getTime();
	timer = level.roundTimeLeft + ( [[level.getVars]]("scr_bombbonustime") * 60 );
	level thread maps\mp\uox\_uox::startRoundTimer(timer);
	level.mainClock = level maps\mp\uox\_uox_hud::updateHUDMainClock(timer);
}


onPlayerKill(victim, attacker)
{
	return;
}