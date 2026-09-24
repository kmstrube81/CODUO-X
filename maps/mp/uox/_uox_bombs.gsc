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
	maps\mp\uox\_uox_vars::varDef("scr", "bombtimer", "int", true,
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

    //can plant if you are a player and are on the attacking team, and are on the ground and not
    //in a vehicle and canPlant is true
    if(isPlayer(other) && other.pers["team"] == game["attackers"])
        other thread check_bombzone(self);
	
}

canPlant(trigger)
{
	if(!isDefined(trigger) || isDefined(trigger.doing))
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
	if(self istouching(trigger) && isAlive(self) && self useButtonPressed() 
		&& (self maps\mp\_util_mp_gmi::canPlantGMI()))
		return true;
	return false;
}

plantBomb(trigger)
{
    trigger notify("bomb planted");

	self maps\mp\uox\_uox_inputs::removeHoldUse("plant_bomb");
	self maps\mp\uox\_uox_hud::deleteClientHUDElement("plant_icon");
	self.pers["score"] += [[level.getVars]]("scr_bombplantbonuspoints");
	self.score = self.pers["score"];
	
	bombexploder = trigger.script_noteworthy;
	level.bombexploders[trigger.objectiveName] = bombexploder;
	
	if(level.bombmode < 1)
	{
		bombzone_A = getent("bombzone_A", "targetname");
		bombzone_B = getent("bombzone_B", "targetname");
		bombzone_A delete();
		bombzone_B delete();
		objective_delete(0);
		objective_delete(1);
	}
    else
    {
        trigger maps\mp\_utility::triggerOff();
        objective_delete(trigger.objective);
    }

	plant = self maps\mp\_util_mp_gmi::getPlantGMI();
	
	bombmodel = spawn("script_model", plant.origin);
	bombmodel.angles = plant.angles;
	bombmodel setmodel("xmodel/mp_bomb1_defuse");
	bombmodel playSound("Explo_plant_no_tick");
	bombmodel.objectiveName = trigger.objectiveName;
	bombmodel.objective = trigger.objective;
	
	bombtrigger = getent("bombtrigger", "targetname");
	bombtrigger.origin = bombmodel.origin;

    bombtrigger.bomb = bombmodel;

	if(level.bombmode < 1)
		objective_add(0, "current", bombtrigger.origin, "gfx/hud/hud@bombplanted.tga");

	level.bombsites[trigger.objectiveName]["planted"] = true;
	
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
	
	if(!(level.bombsites["A"]["planted"] || level.bombsites["B"]["planted"]))
		level.roundTimeLeft = level.roundTimeLeft - ( (getTime() - level.roundresumetime) / 1000 );
		
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
        level.bombs[trigger.objectiveName] = bombmodel;
    }
	
	//bombtrigger thread bomb_think(bombmodel);

    bombtrigger thread maps\mp\uox\_uox_loops::initEntityLoop();

    bombtrigger maps\mp\uox\_uox_loops::addToWaitTills(bombtrigger, "trigger", ::bomb_think, true);

    bombtrigger thread maps\mp\uox\_uox_loops::removeFromWaitTills(bombtrigger, "trigger", bombtrigger, "bomb_exploded");

	bombtrigger thread bomb_countdown(bombmodel);
	
	level notify("timer_paused");

    if([[level.getVars]]("sv_showbombtimer"))
    {
        trigger endon("bomb planted");

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
		self maps\mp\uox\_uox_inputs::addHoldUse("plant_bomb", 0, [[level.getVars]]("scr_bombplanttime"),
			::planting, ::plantBomb, ::check_bombzone, true, true, true, trigger, "MP_bomb_plant");

		while(self canPlant(trigger))
			wait 0.05;
	}

    maps\mp\uox\_uox_debug::debugLog("info", self.name + " delete plant icon");
    self.checking = undefined;
	self maps\mp\uox\_uox_hud::deleteClientHUDElement("plant_icon");
	self maps\mp\uox\_uox_inputs::removeHoldUse("plant_bomb");
}

bomb_countdown(bomb)
{
	self endon("bomb_defused");
	level endon("intermission");
	
	bomb playLoopSound("bomb_tick");
	clock = bomb.clock;
	
	// set the countdown time
	countdowntime = [[level.getVars]]("scr_bombtimer");

	wait countdowntime;
		
	// bomb timer is up
	if(level.bombmode < 1)
	{
		objective_delete(0);
	}
	else
	{
		objective_delete(bomb.objective);
	}
	level.bombsites[bomb.objectiveName]["exploded"] = true;
	level.bombsites[bomb.objectiveName]["planted"] = false;
	
	self notify("bomb_exploded");

	// trigger exploder if it exists
	if(isDefined(level.bombexploders[bomb.objectiveName]))
		maps\mp\_utility::exploder(level.bombexploders[bomb.objectiveName]);

	// explode bomb
	origin = self getorigin();
	range = 500;
	maxdamage = 2000;
	mindamage = 1000;
		
	self delete(); // delete the defuse trigger
	bomb stopLoopSound();
	level.bombs[bomb.objectiveName] = undefined;
	bomb delete();
	level.hudplanted = maps\mp\uox\_uox_hud::deleteHUDElement(level.hudplanted);

	playfx(level._effect["bombexplosion"], origin);
	radiusDamage(origin, range, maxdamage, mindamage);

	//delete clock
    if(isdefined(clock))
    {
        if(clock == level.mainBombClock)
        {
            //delete clock
            level.mainBombClock = level maps\mp\uox\_uox_hud::deleteHUDMainBombClock();
            //if secondary clock exists, move it
            if(isDefined(level.secondBombClock))
                level.secondBombClock = level maps\mp\uox\_uox_hud::updateHUDElementProperty(
                    level.secondBombClock, "x", 320);
        }
        else if(clock == level.secondBombClock)
        {
            //delete clock
            level.mainBombClock = level maps\mp\uox\_uox_hud::deleteHUDSecondaryBombClock();
        }
    }
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
        return;
	}
	
	//if no bombs are planted go ahead turn round timer back on
	if( ( !(level.bombsites["A"]["planted"] || level.bombsites["B"]["planted"]) ))
	{
		level.roundresumetime = getTime();
		timer = level.roundTimeLeft + ( [[level.getVars]]("scr_bombbonustime") * 60 );
		level thread maps\mp\uox\_uox::startRoundTimer(timer);
		level.mainClock = level maps\mp\uox\_uox_hud::updateHUDMainClock(timer);
	}
}

bomb_think(other)
{
	self endon("bomb_exploded");
	
    // check for having been triggered by a valid player
    if(isPlayer(other) && (other.pers["team"] == game["defenders"]) && other isOnGround())
        other thread check_bomb(self);
	
}

canDefuse(trigger)
{
	if(!isDefined(trigger) || isDefined(trigger.doing))
		return false;
	if(!isAlive(self) || !(self isOnGround()))
		return false;
	if(distance(self.origin, trigger.origin) >= 64 || !(self islookingat(trigger)))
		return false;
	return true;
}

defusing(trigger)
{
	if(self islookingat(trigger) && distance(self.origin, trigger.origin) < 64 && isAlive(self) && self useButtonPressed())
		return true;
	return false;
}

defuseBomb(trigger)
{
	self maps\mp\uox\_uox_inputs::removeHoldUse("defuse_bomb");
	self maps\mp\uox\_uox_hud::deleteClientHUDElement("defuse_icon");

	self.pers["score"] += [[level.getVars]]("scr_bombdefusebonuspoints");
	self.score = self.pers["score"];

	if(level.bombmode == 0)
		objective_delete(0);

    bomb = trigger.bomb;
    clock = bomb.clock;

	trigger notify("bomb_defused");
	bomb setmodel("xmodel/mp_bomb1");
	bomb stopLoopSound();
	level.bombsites[bomb.objectiveName]["planted"] = false;
	bomb delete();
	trigger delete();

	announcement(game["bombDefusedText"]);
	
	lpselfnum = self getEntityNumber();
	lpselfguid = self getGuid();
	logPrint("A;" + lpselfguid + ";" + lpselfnum + ";" + game["defenders"] + ";" + self.name + ";" + "bomb_defuse" + "\n");
	
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		players[i] playLocalSound("MP_announcer_bomb_defused");
	}
	
	//delete hud elements 
	//delete clock
    if(isdefined(clock))
    {
        if(clock == level.mainBombClock)
        {
            //delete clock
            level.mainBombClock = maps\mp\uox\_uox_hud::deleteHUDMainBombClock();
            //if secondary clock exists, move it
            if(isDefined(level.secondBombClock))
            {
                    level.secondBombClock = maps\mp\uox\_uox_hud::updateHUDElementProperty(
                        level.secondBombClock, "x", 320);
            }
            else
                level.hudplanted = maps\mp\uox\_uox_hud::deleteHUDElement(level.hudplanted);
        }
        else if(clock == level.secondBombClock)
        {
            //delete clock
            level.mainBombClock = maps\mp\uox\_uox_hud::deleteHUDSecondaryBombClock();
        } 
    }
	
	if(level.bombmode == 0)
	{
		maps\mp\uox\_uox::incrementTeamScore(game["defenders"]);
		level thread maps\mp\uox\_uox::endRound(game["defenders"]);
        return;
	}
	
	//if no bombs are planted go ahead turn round timer back on
	if(!(level.bombsites["A"]["planted"] || level.bombsites["B"]["planted"]))
	{
		level.roundresumetime = getTime();
		timer = level.roundTimeLeft + ( [[level.getVars]]("scr_bombbonustime") * 60 );
		level thread maps\mp\uox\_uox::startRoundTimer(timer);
		level.mainClock = level maps\mp\uox\_uox_hud::updateHUDMainClock(timer);
	}
	
	return;	//TEMP, script should stop after the wait .05
}

check_bomb(trigger)
{
    if(isDefined(self.checking) && self.checking == trigger) //already checking this bombzone
        return;

    self.checking = trigger;

	if(self canDefuse(trigger))
	{
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
		self maps\mp\uox\_uox_inputs::addHoldUse("defuse_bomb", 0, [[level.getVars]]("scr_bombplanttime"),
			::defusing, ::defuseBomb, ::check_bomb, true, true, true, trigger, "MP_bomb_defuse");

		while(self canDefuse(trigger))
			wait 0.05;
	}

    self.checking = undefined;

    maps\mp\uox\_uox_debug::debugLog("info", self.name + " delete defuse icon");

	self maps\mp\uox\_uox_hud::deleteClientHUDElement("defuse_icon");
	self maps\mp\uox\_uox_inputs::removeHoldUse("defuse_bomb");
}

onPlayerKill(victim, attacker)
{
	return;
}