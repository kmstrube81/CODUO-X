precache()
{
    precacheString(&"BEL_TIME_ALIVE");
    precacheString(&"BEL_POINTS_EARNED");
    precacheShader("gfx/hud/hud@objective_bel.tga");
	precacheShader("gfx/hud/hud@objective_bel_up.tga");
	precacheShader("gfx/hud/hud@objective_bel_down.tga");
}

initVars()
{
    //set up gametype cvars
    maps\mp\uox\_uox_vars::varDef("scr", "alivepointtime", "int", true, 10, 1, 1440, "Seconds Per Survival Point");
	maps\mp\uox\_uox_vars::varDef("scr", "positiontime", "int", true, 10, 1, 1440, "Seconds Per Compass Update");
	maps\mp\uox\_uox_vars::varDef("scr", "showoncompass", "bool", true, true, "", "", "Show Allies on Compass");
    maps\mp\uox\_uox_vars::varDef("scr", "survivalHealthBonus", int, true, 0, 0, 100, "Survival Health Bonus");
}

onPlayerKill()
{
    victim check_delete_objective();
}

check_delete_objective()
{
    //kill loops
    self maps\mp\uox\_uox_loops::removeFromWaitTills(self, "bel update marker");
    self maps\mp\uox\_uox_loops::removeFromWaitTills(self, "bel survived");

	self maps\mp\uox\_uox_hud::deleteClientHUDElement("hudPoints");
    self maps\mp\uox\_uox_hud::deleteClientHUDElement("hudClock");
    self maps\mp\uox\_uox_hud::deleteClientHUDElement("hudBgnd");

	objnum = ((self getEntityNumber()) + 1);
	objective_delete(objnum);
}

allied_hud_element()
{
	wait .1;
	
	options = [];

    options["alpha"] = 0.2;
    options["x"] = 505;
    options["y"] = 382;
    options["sort"] = -1;
    options["width"] = 130;
    options["height"] = 35;
    self maps\mp\uox\_uox_hud::updateClientHUDElement("hudBgnd", "shader", "black", options);

	
	options = [];
	options["x"] = 505;
    options["y"] = 382;
	options["label"] = &"BEL_TIME_ALIVE";
	
	self maps\mp\uox\_uox_hud::updateClientHUDElement("hudClock", "timerUp", 0, options);
	
	options = [];
	options["x"] = 505;
    options["y"] = 401;
	options["label"] = &"BEL_POINTS_EARNED";

	self.hudpoints = 0;
    self maps\mp\uox\_uox_hud::updateClientHUDElement("hudPoints", "number", self.hudpoints, options);
	

	self thread give_allied_points();
}

make_obj_marker()
{	
	
	if([[level.getVars]]("scr_showoncompass"))
	{
		objnum = ((self getEntityNumber()) + 1);
		objective_add(objnum, "current", self.origin, "gfx/hud/hud@objective_bel.tga");
		objective_icon(objnum,"gfx/hud/hud@objective_bel.tga");
		objective_team(objnum,"axis");
		objective_position(objnum, self.origin);
		lastobjpos = self.origin;
		newobjpos = self.origin;
	}
	
	self thread allied_hud_element();

    thread maps\mp\uox\_uox_utils::notifyLater("bel update marker", [[level.getVars]]("scr_positiontime"), self );
    thread maps\mp\uox\_uox_utils::notifyLater("bel survived", [[level.getVars]]("scr_alivepointtime"), self );

    self maps\mp\uox\_uox_loops::addToWaitTills(self, "bel update marker", ::update_obj_marker);
    self maps\mp\uox\_uox_loops::addToWaitTills(self, "bel survived", ::survived);
	
}

update_obj_marker()
{
    if((isplayer (self)) && (isalive(self)))
	{
        if([[level.getVars]]("scr_showoncompass"))
        {
            lastobjpos = newobjpos;
            newobjpos = ( ((lastobjpos[0] + self.origin[0]) * 0.5), ((lastobjpos[1] + self.origin[1]) * 0.5), ((lastobjpos[2] + self.origin[2]) * 0.5) );
            objective_position(objnum, newobjpos);
        }
	}
    thread maps\mp\uox\_uox_utils::notifyLater("bel update marker", [[level.getVars]]("scr_positiontime"), self );
}

survived()
{
    if((isplayer (self)) && (isalive(self)))
    {
        give_allied_points();
        give_allied_health();
    }
    thread maps\mp\uox\_uox_utils::notifyLater("bel survived", [[level.getVars]]("scr_alivepointtime"), self );
}

give_allied_points()
{
        lpselfnum = self getEntityNumber();

		self.score++;
		self.hudpoints++;
		self.god = false; //failsafe to fix a very rare bug
		logPrint("A;" + lpselfnum + ";allies;" + self.name + ";bel_alive_tick\n");
		self maps\mp\uox\_uox_hud::updateClientHUDElement("hudPoints", "number", self.hudpoints);
		self maps\mp\uox\_uox::checkScoreLimit();
}

give_allied_health()
{
    if (self.health < 100)
        self.health = (self.health + [[level.getVars]]("scr_survivalHealthBonus"));
}

