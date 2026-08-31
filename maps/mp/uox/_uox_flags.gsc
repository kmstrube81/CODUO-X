precache()
{
	
    // GMI STRINGS
    precacheString(&"GMI_CTF_OBJECTIVE");
    precacheString(&"GMI_CTF_ALLIES_CAP_FLAG");
    precacheString(&"GMI_CTF_AXIS_CAP_FLAG");

    precacheString(&"GMI_CTF_ATTACKER_OBJECTIVE");
    precacheString(&"GMI_CTF_SPECTATOR_OBJECTIVE");

    precacheString(&"GMI_CTF_AXIS_PICKED_UP_FLAG");
    precacheString(&"GMI_CTF_ALLIES_PICKED_UP_FLAG");
    precacheString(&"GMI_CTF_ALLIES_FLAG_RETURNED");
    precacheString(&"GMI_CTF_AXIS_FLAG_RETURNED");
    precacheString(&"GMI_CTF_PLAYER_RETURNED_FLAG_AXIS");
    precacheString(&"GMI_CTF_PLAYER_RETURNED_FLAG_ALLIES");
    precacheString(&"GMI_CTF_AXIS_CAPTURED_FLAG");
    precacheString(&"GMI_CTF_ALLIES_CAPTURED_FLAG");
    precacheString(&"GMI_CTF_PLAYER_CAPTURED_FLAG_AXIS");
    precacheString(&"GMI_CTF_PLAYER_CAPTURED_FLAG_ALLIES");
    precacheString(&"GMI_CTF_FLAG_INMINES");
    precacheString(&"GMI_CTF_AXIS_FLAG_DROPPED");
    precacheString(&"GMI_CTF_ALLIES_FLAG_DROPPED");
    precacheString(&"GMI_CTF_AXIS_FLAG_TIMEOUT_RETURNING");
    precacheString(&"GMI_CTF_ALLIES_FLAG_TIMEOUT_RETURNING");
    precacheString(&"GMI_CTF_U_R_CARRYING_AXIS");
    precacheString(&"GMI_CTF_U_R_CARRYING_ALLIES");
    precacheString(&"GMI_CTF_DEFENDED_AXIS_FLAG");
    precacheString(&"GMI_CTF_DEFENDED_ALLIES_FLAG");
    precacheString(&"GMI_CTF_ASSISTED_AXIS_FLAG_CARRIER");
    precacheString(&"GMI_CTF_ASSISTED_ALLIES_FLAG_CARRIER");
    precacheString(&"GMI_DOM_ALLIEDMISSIONACCOMPLISHED");
    precacheString(&"GMI_DOM_AXISMISSIONACCOMPLISHED");


    //	all silly stuff
    // precacheShader("gfx/hud/ctf_stance_crouch.dds");
    // precacheShader("gfx/hud/ctf_stance_stand.dds");
    // precacheShader("gfx/hud/ctf_stance_prone.dds");
    // precacheShader("gfx/hud/ctf_stance_sprint.dds");

    // set up team specific variables
    switch( game["allies"])
    {
        case "british":
            game["headicon_carrier_axis"] = "gfx/hud/headicon@ctf_british.dds";
            game["statusicon_carrier_axis"] = "gfx/hud/hud@ctf_british.dds";

            game["hud_allies_base_with_flag"] = "gfx/hud/hud@objective_british";
            game["hud_allies_base"] = "gfx/hud/hud@b_flag_nobase2";

            game["hud_allies_flag"] 	= "gfx/hud/ctf_flag_b_1.dds";
            game["hud_allies_flag_taken"] 	= "gfx/hud/ctf_flag_b_0.dds";
            
            
            game["sound_allies_we_have_enemy_flag"] = "uk_grabbed_enemy_flag";
            game["sound_allies_enemy_has_our_flag"] = "uk_our_flag_taken";
            game["sound_allies_enemy_has_captured"] = "uk_our_flag_captured";  
            game["sound_allies_we_captured"] = "uk_captured_flag";  
            game["sound_allies_flag_has_been_returned"] = "uk_flag_returned";  
            break;
        case "russian":
            game["headicon_carrier_axis"] = "gfx/hud/headicon@ctf_russian.dds";
            game["statusicon_carrier_axis"] = "gfx/hud/hud@ctf_russian.dds";

            game["hud_allies_base_with_flag"] = "gfx/hud/hud@objective_russian";
            game["hud_allies_base"] = "gfx/hud/hud@r_flag_nobase";

            game["hud_allies_flag"] 	= "gfx/hud/ctf_flag_r_1.dds";
            game["hud_allies_flag_taken"] 	= "gfx/hud/ctf_flag_r_0.dds";

            
            game["sound_allies_we_have_enemy_flag"] = "ru_grabbed_enemy_flag";
            game["sound_allies_enemy_has_our_flag"] = "ru_our_flag_taken";
            game["sound_allies_we_captured"] = "ru_captured_flag";  
            game["sound_allies_enemy_has_captured"] = "ru_our_flag_captured";  
            game["sound_allies_flag_has_been_returned"] = "ru_flag_returned";  
            break;
        default:		// default is american
            game["headicon_carrier_axis"] = "gfx/hud/headicon@ctf_american.dds";
            game["statusicon_carrier_axis"] = "gfx/hud/hud@ctf_american.dds";

            game["hud_allies_base_with_flag"] = "gfx/hud/hud@objective_american";
            game["hud_allies_base"] = "gfx/hud/hud@a_flag_nobase";

            game["hud_allies_flag"] 	= "gfx/hud/ctf_flag_us_1.dds";
            game["hud_allies_flag_taken"] 	= "gfx/hud/ctf_flag_us_0.dds";


            
            game["sound_allies_we_have_enemy_flag"] = "us_grabbed_enemy_flag";
            game["sound_allies_enemy_has_our_flag"] = "us_our_flag_taken";
            game["sound_allies_we_captured"] = "us_captured_flag";  
            game["sound_allies_enemy_has_captured"] = "us_our_flag_captured";  
            game["sound_allies_flag_has_been_returned"] = "us_flag_returned";  
            break;
    }

                         
    game["sound_axis_victory_vo"] = "MP_announcer_axis_win";
    game["sound_axis_victory_music"] = "ge_victory";
    game["sound_axis_we_have_enemy_flag"] = "ge_grabbed_enemy_flag";
    game["sound_axis_enemy_has_our_flag"] = "ge_our_flag_taken";
    game["sound_axis_we_captured"] = "ge_captured_flag";  
    game["sound_axis_enemy_has_captured"] = "ge_our_flag_captured";  	
    game["sound_axis_flag_has_been_returned"] = "ge_flag_returned";  

    game["sound_round_draw_vo"] = "MP_announcer_round_draw";

    game["hud_axis_base_with_flag"] = "gfx/hud/hud@objective_german";
    game["hud_axis_base"] = "gfx/hud/hud@g_flag_nobase3";
    game["hud_flagicon_home"] = "gfx/hud/objective.dds";
    game["hud_flagicon_away"] = "gfx/hud/ctf_stance_sprint.dds";
    game["hud_flagicon_dropped"] = "gfx/hud/hud@status_dead.tga";
        
    precacheShader(game["hud_allies_base_with_flag"]+ ".dds");
    precacheShader(game["hud_allies_base_with_flag"]+ "_up.dds");
    precacheShader(game["hud_allies_base_with_flag"]+ "_down.dds");
    precacheShader(game["hud_allies_base"]+ ".dds");
    precacheShader(game["hud_allies_base"]+ "_up.dds");
    precacheShader(game["hud_allies_base"]+ "_down.dds");
    precacheShader(game["hud_axis_base_with_flag"]+ ".dds");
    precacheShader(game["hud_axis_base_with_flag"]+ "_up.dds");
    precacheShader(game["hud_axis_base_with_flag"]+ "_down.dds");
    precacheShader(game["hud_axis_base"]+ ".dds");
    precacheShader(game["hud_axis_base"]+ "_up.dds");
    precacheShader(game["hud_axis_base"]+ "_down.dds");
    precacheShader(game["hud_flagicon_home"]);
    precacheShader(game["hud_flagicon_away"]);
    precacheShader(game["hud_flagicon_dropped"]);
    precacheShader("gfx/hud/hud@objective_bel.tga");
    precacheShader("gfx/hud/hud@objective_bel_up.tga");
    precacheShader("gfx/hud/hud@objective_bel_down.tga");

    // set up the hud flag icons

    game["hud_axis_flag"] 		= "gfx/hud/ctf_flag_g_1.dds";
    game["hud_axis_flag_taken"] 	= "gfx/hud/ctf_flag_g_0.dds";
    
    

    precacheShader(game["hud_axis_flag"]);
    precacheShader(game["hud_axis_flag_taken"]);
    precacheShader(game["hud_allies_flag"]);
    precacheShader(game["hud_allies_flag_taken"]);
            
    // the head icon should actually be the opposite teams flag
    game["headicon_carrier_allies"] = "gfx/hud/headicon@ctf_german.dds";
    game["statusicon_carrier_allies"] = "gfx/hud/hud@ctf_german.dds";

    precacheHeadIcon(game["headicon_carrier_allies"]);
    precacheHeadIcon(game["headicon_carrier_axis"]);
    precacheStatusIcon(game["statusicon_carrier_axis"]);
    precacheStatusIcon(game["statusicon_carrier_allies"]);

    precachemodel("xmodel/o_ctf_flag_b");
    precachemodel("xmodel/o_ctf_flag_r");
    precachemodel("xmodel/o_ctf_flag_us");
    precachemodel("xmodel/o_ctf_flag_g");

}

initVars()
{
	
    level.allies_cap_count = 0;  // how many times the allies capped in the current round
	level.axis_cap_count = 0;  // how many times the axis capped in the current round

    level.axis_held_flag = "xmodel/o_ctf_flag_g";
	level.held_tag_flag = "TAG_HELMETSIDE";

    switch( game["allies"])
	{
		case	"british":	level.allies_held_flag = "xmodel/o_ctf_flag_b";
					break;
		case	"russian":	level.allies_held_flag = "xmodel/o_ctf_flag_r";
					break;
		default:		level.allies_held_flag = "xmodel/o_ctf_flag_us";
					break;
	}


    maps\mp\uox\_uox_vars::varDef("scr", "showoncompass", "int", true, 0, 0, 999, "Show Flag Carrier on Compass");
    level.PositionUpdateTime = maps\mp\uox\_uox_vars::varDef("scr", "positionTime", "int", true, 6, 1, 60, "Seconds Per Compass Update");
    maps\mp\uox\_uox_vars::varDef("scr", "showicons", "string", true, "both", "", "", "Show Flag HUD Icons");
    maps\mp\uox\_uox_vars::varDef("scr", "defensebonus", "int", true, 0, 0, 10, "Flag Defended Bonus");
    maps\mp\uox\_uox_vars::varDef("scr", "assistbonus", "int", true, 0, 0, 10, "Flag Assist Bonus");
    maps\mp\uox\_uox_vars::varDef("scr", "capturebonus", "int", true, 5, 0, 10, "Flag Capture Bonus");
    maps\mp\uox\_uox_vars::varDef("scr", "pickupbonus", "int", true, 0, 0, 10, "Flag Pickup Bonus");
    maps\mp\uox\_uox_vars::varDef("scr", "returnbonus", "int", true, 0, 0, 10, "Flag Returned Bonus");
    maps\mp\uox\_uox_vars::varDef("scr", "flagtimeout", "int", true, 20, 0, 999, "Flag Reset Time" );


    //get the minefields
	level.minefield = getentarray("minefield", "targetname");
	if (!isdefined (level.minefield))
		level.minefield = [];
	hurtTrigs = getentarray("trigger_hurt","classname");
	for (i=0;i<hurtTrigs.size;i++)
		level.minefield[level.minefield.size] = hurtTrigs[i];
	level.deepwater = getentarray("deepwater", "targetname");
	if (!isdefined (level.deepwater))
		level.deepwater = [];
    
}

// ----------------------------------------------------------------------------------
//	ctf
//
// 		starts the flags thinking
// ----------------------------------------------------------------------------------
ctf()
{
	level.allies_flag = getent("ctf_flag_allies", "targetname");
	
	if ( !isDefined(level.allies_flag) )
	{
		maps\mp\_utility::error("NO ALLIED FLAG IN MAP");
		return;
	}
	
	// get the mobile version of the flag
	level.allies_flag.mobile_model = getent("ctf_flag_allies_mobile", "targetname");
	if ( !isDefined(level.allies_flag.mobile_model) )
	{
		maps\mp\_utility::error("NO ALLIED MOBILE FLAG IN MAP");
		return;
	}
	level.allies_flag.mobile_model SetContents(0);

	level.allies_flag.mobile_model hide();	
	level.allies_flag.team = "allies";
	level.allies_flag.hudnum = 1;
	level.allies_flag thread ctf_spawn_flag();
	level.allies_flag thread maps\mp\uox\_uox_loops::initEntityLoop();
    level.allies_flag thread flag_think();

	level.axis_flag = getent("ctf_flag_axis", "targetname");
	
	if ( !isDefined(level.axis_flag) )
	{
		maps\mp\_utility::error("NO AXIS FLAG IN MAP");
		return;
	}
	
	// get the mobile version of the flag
	level.axis_flag.mobile_model = getent("ctf_flag_axis_mobile", "targetname");

	if ( !isDefined(level.axis_flag.mobile_model) )
	{
		maps\mp\_utility::error("NO ALLIED MOBILE FLAG IN MAP");
		return;
	}
	level.axis_flag.mobile_model SetContents(0);

	level.axis_flag.mobile_model hide();	
	level.axis_flag.team = "axis";
	level.axis_flag.hudnum = 2;

    updateFlagIcons([[level.getVars]]("scr_showicons"), "init");

	level.axis_flag thread ctf_spawn_flag();
	level.axis_flag thread maps\mp\uox\_uox_loops::initEntityLoop();
    level.axis_flag thread flag_think();
}

updateFlagIcons(showicons, reason)
{
    //set up flag icons scr_showicons 0 is off, 1 is big icons, 2 is small icons, 3 is both.
    switch(showicons)
    {
        case "big":
            //create/update big icon
            options = [];
            options["alignX"] = "left";
            options["alignY"] = "top";
            options["sort"] = -50;
            options["x"] = 190;
            options["y"] = 440;
            options["width"] = 64;
            options["height"] = 32;
            switch(reason)
            {
                case "init":
                case "reset_allies":
                    options["alpha"] = 1;
                    allies_icon1 = game["hud_allies_flag"];
                    break;
                case "allies_flag_taken":
                    options["alpha"] = 1;
                    allies_icon1 = game["hud_allies_flag_taken"];
                    break;
            }
            if(isDefined(allies_icon1))
                level.allies_flag.icon1 = maps\mp\uox\_uox_hud::updateHUDElement(level.allies_flag.icon1, "shader", allies_icon1, options);
            options["x"] = 382;
            switch(reason)
            {
                case "init":
                case "reset_axis":
                    options["alpha"] = 1;
                    axis_icon1 = game["hud_axis_flag"];
                    break;
                case "axis_flag_taken":
                    options["alpha"] = 1;
                    axis_icon1 = game["hud_axis_flag_taken"];
                    break;
            }
            if(isDefined(axis_icon1))
                level.axis_flag.icon1 = maps\mp\uox\_uox_hud::updateHUDElement(level.axis_flag.icon1, "shader", allies_icon1, options);
            //delete small icons
            level.allies_flag.icon2 = maps\mp\uox\_uox_hud::deleteHUDElement(level.allies_flag.icon2);
            level.axis_flag.icon2 = maps\mp\uox\_uox_hud::deleteHUDElement(level.axis_flag.icon2);
            break;

        case "small":
            //create/update small icons
            options = [];
        	options["x"] = 100;
        	options["y"] = 250;
        	options["alignX"] = "left";
        	options["alignY"] = "middle";
            switch(reason)
            {
                case "init":
                case "reset_allies":
                    options["alpha"] = 1;
                    options["width"] = 36;
                    options["height"] = 36;
                    allies_icon2 = game["hud_flagicon_home"];
                    break;
                case "allies_flag_taken":
                    options["alpha"] = 1;
                    options["width"] = 24;
                    options["height"] = 24;
                    allies_icon2 = game["hud_flagicon_away"];
                    break;
                case "allies_flag_dropped":
                    options["alpha"] = 1;
                    options["width"] = 24;
                    options["height"] = 24;
                    allies_icon2 = game["hud_flagicon_dropped"];
                    break;
            }
            if(isDefined(allies_icon2))
                level.allies_flag.icon2 = maps\mp\uox\_uox_hud::updateHUDElement(level.allies_flag.icon2, "shader", allies_icon2, options);
            options["y"] = 270;
            switch(reason)
            {
                case "init":
                case "reset_axis":
                    options["alpha"] = 1;
                    options["width"] = 36;
                    options["height"] = 36;
                    axis_icon2 = game["hud_flagicon_home"];
                    break;
                case "axis_flag_taken":
                    options["alpha"] = 1;
                    options["width"] = 24;
                    options["height"] = 24;
                    allies_icon2 = game["hud_flagicon_away"];
                    break;
                case "axis_flag_dropped":
                    options["alpha"] = 1;
                    options["width"] = 24;
                    options["height"] = 24;
                    axis_icon2 = game["hud_flagicon_dropped"];
                    break;
            }
            if(isDefined(axis_icon2))
                level.axis_flag.icon2 = maps\mp\uox\_uox_hud::updateHUDElement(level.axis_flag.icon2, "shader", axis_icon2, options);
            //delete big icons
            level.allies_flag.icon1 = maps\mp\uox\_uox_hud::deleteHUDElement(level.allies_flag.icon1);
            level.axis_flag.icon1 = maps\mp\uox\_uox_hud::deleteHUDElement(level.axis_flag.icon1);
            break;

        case "both":
            //create/update both icons
            options = [];
            options["alignX"] = "left";
            options["alignY"] = "top";
            options["sort"] = -50;
            options["x"] = 190;
            options["y"] = 440;
            options["width"] = 64;
            options["height"] = 32;
            switch(reason)
            {
                case "init":
                case "reset_allies":
                    options["alpha"] = 1;
                    allies_icon1 = game["hud_allies_flag"];
                    break;
                case "allies_flag_taken":
                    options["alpha"] = 1;
                    allies_icon1 = game["hud_allies_flag_taken"];
                    break;
            }
            if(isDefined(allies_icon1))
                level.allies_flag.icon1 = maps\mp\uox\_uox_hud::updateHUDElement(level.allies_flag.icon1, "shader", allies_icon1, options);
            options["x"] = 382;
            switch(reason)
            {
                case "init":
                case "reset_axis":
                    options["alpha"] = 1;
                    axis_icon1 = game["hud_allies_flag"];
                    break;
                case "axis_flag_taken":
                    options["alpha"] = 1;
                    axis_icon1 = game["hud_axis_flag_taken"];
                    break;
            }
            if(isDefined(axis_icon1))
                level.axis_flag.icon1 = maps\mp\uox\_uox_hud::updateHUDElement(level.axis_flag.icon1, "shader", axis_icon1, options);
            options = [];
        	options["x"] = 100;
        	options["y"] = 250;
        	options["alignX"] = "left";
        	options["alignY"] = "middle";
            switch(reason)
            {
                case "init":
                case "reset_allies":
                    options["alpha"] = 1;
                    options["width"] = 36;
                    options["height"] = 36;
                    allies_icon2 = game["hud_flagicon_home"];
                    break;
                case "allies_flag_taken":
                    options["alpha"] = 1;
                    options["width"] = 24;
                    options["height"] = 24;
                    allies_icon2 = game["hud_flagicon_away"];
                    break;
                case "allies_flag_dropped":
                    options["alpha"] = 1;
                    options["width"] = 24;
                    options["height"] = 24;
                    allies_icon2 = game["hud_flagicon_dropped"];
                    break;
            }
            if(isDefined(allies_icon2))
                level.allies_flag.icon2 = maps\mp\uox\_uox_hud::updateHUDElement(level.allies_flag.icon2, "shader", allies_icon2, options);
            options["y"] = 270;
            switch(reason)
            {
                case "init":
                case "reset_axis":
                    options["alpha"] = 1;
                    options["width"] = 36;
                    options["height"] = 36;
                    axis_icon2 = game["hud_flagicon_home"];
                    break;
                case "axis_flag_taken":
                    options["alpha"] = 1;
                    options["width"] = 24;
                    options["height"] = 24;
                    allies_icon2 = game["hud_flagicon_away"];
                    break;
                case "axis_flag_dropped":
                    options["alpha"] = 1;
                    options["width"] = 24;
                    options["height"] = 24;
                    axis_icon2 = game["hud_flagicon_dropped"];
                    break;
            }
            if(isDefined(axis_icon2))
                level.axis_flag.icon2 = maps\mp\uox\_uox_hud::updateHUDElement(level.axis_flag.icon2, "shader", axis_icon2, options);
            break;

        default:
            //delete icons
            level.allies_flag.icon1 = maps\mp\uox\_uox_hud::deleteHUDElement(level.allies_flag.icon1);
            level.allies_flag.icon2 = maps\mp\uox\_uox_hud::deleteHUDElement(level.allies_flag.icon2);
            level.axis_flag.icon1 = maps\mp\uox\_uox_hud::deleteHUDElement(level.axis_flag.icon1);
            level.axis_flag.icon2 = maps\mp\uox\_uox_hud::deleteHUDElement(level.axis_flag.icon2);
    }
}

ctf_spawn_flag()
{
	targeted = getentarray(self.target, "targetname");
	for(i=0;i<targeted.size;i++)
	{
		if(targeted[i].classname == "mp_gmi_ctf_flag")
		{
			if ( isDefined(self.spawnloc) )
			{
				maps\mp\_utility::error("multiple mp_gmi_ctf_flag for the " + self.team + " team");
				return;
			}
			
			spawnloc = targeted[i];
		}
		else
		if(targeted[i].classname == "trigger_multiple")
		{
			if ( isDefined(self.trigger) )
			{
				maps\mp\_utility::error("to many flag triggers for the " + self.team + " team. There should be one.");
				return;
			}
			
			self.trigger = (targeted[i]);
		}
	}

	if((!isdefined(spawnloc)))
	{
		maps\mp\_utility::error( self.team + " flag does not target a mp_gmi_ctf_flag entity");
		return;
	}
	if(!isdefined(self.trigger))
	{
		maps\mp\_utility::error(self.team + " flag does not target a trigger_multiple");
		return;
	}

	targeted = getentarray(spawnloc.target, "targetname");
	for(i=0;i<targeted.size;i++)
	{
		if(targeted[i].classname == "trigger_multiple")
		{
			if ( isDefined(self.goal) )
			{
				maps\mp\_utility::error("to many goal triggers for the " + self.team + " team.  There should only be one");
				return;
			}
			else
            {
                goal = (targeted[i]);
                self.goal = goal;
                goal.flag = self;
            }
		}
	}
	
	if(!isdefined(self.goal))
	{
		maps\mp\_utility::error(self.team + " mp_gmi_ctf_flag does not target a trigger_multiple");
		return;
	}
	
	// get the mobile version of the flag trigger
	targeted = getentarray(self.mobile_model.target, "targetname");
	for(i=0;i<targeted.size;i++)
	{
		if(targeted[i].classname == "trigger_multiple")
		{
			if ( isDefined(self.mobile_trigger) )
			{
				maps\mp\_utility::error("to many flag triggers for the " + self.team + " team. There should be one.");
				return;
			}
			
			self.mobile_trigger = (targeted[i]);
		}
	}
	
	if(!isdefined(self.mobile_trigger))
	{
		maps\mp\_utility::error(self.team + " mobile flag does not target a trigger_multiple");
		return;
	}
	
	
	//move flag to its base position
	self.origin = spawnloc.origin;
	self.startorigin = self.origin;
	self.startangles = self.angles;
	self.trigger.origin = self.origin;
	self.trigger.startorigin = self.trigger.origin;
	self.mobile_model.origin = self.origin;
	self.mobile_trigger.origin = self.origin;
	self.mobile_trigger.startorigin = self.trigger.origin;
	self.carried_by = undefined;

	// turn off the mobile parts
	self.mobile_trigger triggerOff();
	self.mobile_model hide();

	self.moved = false;
    self.timeout = false;
	
    self.mobile_trigger thread maps\mp\uox\_uox_loops::initEntityLoop();
    self.trigger thread maps\mp\uox\_uox_loops::initEntityLoop();
    self.goal thread maps\mp\uox\_uox_loops::initEntityLoop();
    self thread ctf_think_wait();
	
	//Set hintstring on the objectives trigger
	wait 0;//required for level script to run and load the level.obj array
}

flag_think()
{
	enemy_team = "allies";
	// add the flag base to the radar
	if ( self.team == "allies" )
	{
		objective_add(self.hudnum, "current", self.startorigin, game["hud_allies_base_with_flag"] + ".dds");
	}
	else
	{
		objective_add(self.hudnum, "current", self.startorigin, game["hud_axis_base_with_flag"] + ".dds");
		enemy_team = "axis";
	}
}

ctf_think_wait()
{
    if ( self.moved )
        self.mobile_trigger maps\mp\uox\_uox_loops::addToWaitTills(self.mobile_trigger, "trigger", ::ctf_think, true);
	else
		self.trigger maps\mp\uox\_uox_loops::addToWaitTills(self.trigger, "trigger", ::ctf_think, true);

    self.mobile_trigger thread maps\mp\uox\_uox_loops::removeFromWaitTills(self.mobile_trigger, "trigger", level, "round_ended");
    self.mobile_trigger thread maps\mp\uox\_uox_loops::removeFromWaitTills(self.mobile_trigger, "trigger", self.mobile_trigger, "timeout");
    self.trigger thread maps\mp\uox\_uox_loops::removeFromWaitTills(self.trigger, "trigger", level, "round_ended");
    self.trigger thread maps\mp\uox\_uox_loops::removeFromWaitTills(self.trigger, "trigger", self.trigger, "timeout");

}

ctf_think(other) //each flag model runs this to find it's trigger and goal
{

	level endon("round_ended");
	self endon("timeout");

    if(!game["matchstarted"]  )
        return;

    // do not allow people in vehicles to touch flag
    if (other isinvehicle())
        return;
        
    if((isPlayer(other)) && isAlive(other) && (other.pers["team"] != self.team))
    {

        // let the player know they picked up the flag
        if ( other.pers["team"] == "axis" )
        {
            announcement(&"GMI_CTF_ALLIES_FLAG_TAKEN", other);
        }
        else
        {
            announcement(&"GMI_CTF_AXIS_FLAG_TAKEN", other);
        }

        // play the flag has been grabbed sound
        players = getentarray("player", "classname");
        for(i = 0; i < players.size; i++)
        {
            player = players[i];
            
            if ( self.team == "allies" )
            {
                if(player.pers["team"] == "allies")
                    player playLocalSound(game["sound_allies_enemy_has_our_flag"]);
                else
                    player playLocalSound(game["sound_axis_we_have_enemy_flag"]);
            }
            else
            {
                if(player.pers["team"] == "allies")
                    player playLocalSound(game["sound_allies_we_have_enemy_flag"]);
                else
                    player playLocalSound(game["sound_axis_enemy_has_our_flag"]);
            }
        }
        
        // update the objective icon to the base but no flag there icon
        if ( self.team == "allies" )
        {
            updateFlagIcons([[level.getVars]]("scr_showicons"), "allies_flag_taken");
        }
        else
        {
            updateFlagIcons([[level.getVars]]("scr_showicons"), "axis_flag_taken");
        }
        
        lpselfnum = other getEntityNumber();
        lpselfguid = other getGuid();
        logPrint("A;" + lpselfguid + ";" + lpselfnum + ";" + other.pers["team"] + ";" + other.name + ";" + "ctf_take" + "\n");

        self.returned_by = undefined;
        
        self thread hold_flag(other);
        self thread update_objective();
        return;

    }
    // the team that owns the flag can only touch it if it has been moved
    else if((isPlayer(other)) && (other.pers["team"] == self.team) && self.moved)
    {
        if(other.sessionteam == "allies")
        {
            //announcement(&"GMI_CTF_ALLIES_FLAG_RETURNED");
            iprintln(&"GMI_CTF_PLAYER_RETURNED_FLAG_ALLIES",other);
        }
        else if(other.sessionteam == "axis")
        {
            //announcement(&"GMI_CTF_AXIS_FLAG_RETURNED");
            iprintln(&"GMI_CTF_PLAYER_RETURNED_FLAG_AXIS",other);
        }
        
        self.returned_by = other;
            
        lpselfnum = other getEntityNumber();
        lpselfguid = other getGuid();
        logPrint("A;" + lpselfguid + ";" + lpselfnum + ";" + other.pers["team"] + ";" + other.name + ";" + "ctf_returned" + "\n");

        // play the flag has been returned sound
        players = getentarray("player", "classname");
        for(i = 0; i < players.size; i++)
        {
            temp_player = players[i];
            if(temp_player.pers["team"] == "allies" && self.team == "allies")
                temp_player playLocalSound(game["sound_allies_flag_has_been_returned"]);
            else if(temp_player.pers["team"] == "axis" && self.team == "axis")
                temp_player playLocalSound(game["sound_axis_flag_has_been_returned"]);
        }
        
        self reset_flag();
    }

}

hold_flag(player) //the objective model runs this to be held by 'player'
{
	self endon("completed");
	self endon("dropped");


	team = player.sessionteam;
	player.hasflag = self;
	self.carried_by = player;
	self.moved = true;
	self hide();
	self.origin = (self.origin[0], self.origin[1], self.origin[2] - 3000 );
	self.mobile_model hide();
	self.mobile_trigger triggerOff();
	self.trigger triggerOff();

	self thread handle_vehicle_flag();

	lpselfnum = player getEntityNumber();
	lpselfguid = player getGuid();
	logPrint("A;" + lpselfguid + ";" + lpselfnum + ";" + self.team + ";" + player.name + ";" + "ctf_pickup" + "\n");
	
	self notify("picked up");

	if ( team == "axis")
	{
		player.statusicon = game["statusicon_carrier_axis"];
		self.holding_flag = level.allies_held_flag;
	}
	else
	{
		player.statusicon = game["statusicon_carrier_allies"];
		self.holding_flag = level.axis_held_flag;
	}

	player.has_attached = true;
	player attach(self.holding_flag,level.held_tag_flag,true);
	
	self.goal flag_carrier_atgoal_wait(); 

        
}

handle_change_flag()
{
	while(isdefined(self.carried_by))
	{
		wait(0.05);
	}

	self notify("dropped");
	if (isdefined(self.vehiclemodel))
		self.vehiclemodel delete();
}

flag_carrier_atgoal_wait()
{
    self maps\mp\uox\_uox_loops::addToWaitTills(self, "trigger", ::flag_carrier_atgoal_wait, true);
    self thread maps\mp\uox\_uox_loops::removeFromWaitTills(self, "trigger", level, "round_ended");
    self thread maps\mp\uox\_uox_loops::removeFromWaitTills(self, "trigger", self.flag, "dropped");
}

flag_carrier_atgoal(other)
{
    flag = self.flag;
    player = self.flag.carried_by;

    if ( other isinvehicle() )
        return;
        
    if((other == player) && (isPlayer(player)))
    {
        // make sure the other flag is there
        if ( flag.team == "axis" && level.allies_flag.moved )
            return;
        if ( flag.team == "allies" && level.axis_flag.moved )
            return;
            
        flag notify("completed");
        other notify("dropped");

        // get rid of the flag model off the player
        if (player.has_attached == true)
        {
            player.has_attached = false;
            player detach(flag.holding_flag,level.held_tag_flag);	
        }
    
        // announce the flag has been grabbed
        if ( other.pers["team"] == "axis" )
        {
            game["axisscore"]++;
            setTeamScore("axis", game["axisscore"]);
            
            announcement(&"GMI_CTF_AXIS_CAPTURED_FLAG");
            iprintln(&"GMI_CTF_PLAYER_CAPTURED_FLAG_AXIS",player);
        }
        else
        {
            game["alliedscore"]++;
            setTeamScore("allies", game["alliedscore"]);

            announcement(&"GMI_CTF_ALLIES_CAPTURED_FLAG");
            iprintln(&"GMI_CTF_PLAYER_CAPTURED_FLAG_ALLIES",player);
        }

        // play the flag has been captured sound
        players = getentarray("player", "classname");
        for(i = 0; i < players.size; i++)
        {
            temp_player = players[i];
            if(player.pers["team"] == "allies")
            {
                if ( temp_player.pers["team"] == "allies")
                {
                    temp_player playLocalSound(game["sound_allies_we_captured"]);
                }
                else
                    temp_player playLocalSound(game["sound_axis_enemy_has_captured"]);
            }
            else
            {
                if ( temp_player.pers["team"] == "allies")
                    temp_player playLocalSound(game["sound_allies_enemy_has_captured"]);
                else
                    temp_player playLocalSound(game["sound_axis_we_captured"]);
            }
        }
        
        // set the team cap count up one
        if ( other.pers["team"] == "axis" )
        {
            level.axis_cap_count++;
        }
        else
        {
            level.allies_cap_count++;
        }
        
        capbonus = [[level.getVars]]("scr_capturebonus");
        assistbonus = [[level.getVars]]("scr_assistbonus");

        // give the team points
        maps\mp\uox\_uox::GivePointsToTeam( player.pers["team"],  capbonus);

        // give out points to the capper
        if(isValidPlayer(player))
        {
            player.pers["score"] += capbonus;
            player.score = player.pers["score"];
        }
        
        if ( flag.team == "axis" )
            other_flag = level.allies_flag;
        else
            other_flag = level.axis_flag;

        lpselfnum = player getEntityNumber();
        lpselfguid = player getGuid();
        logPrint("A;" + lpselfguid + ";" + lpselfnum + ";" + player.pers["team"] + ";" + player.name + ";" + "ctf_captured" + "\n");

        // give assist points
        if (isDefined(other_flag.returned_by) && isValidPlayer(other_flag.returned_by) && other_flag.returned_by != player)
        {
            // let everyone know
            if ( other_flag.returned_by.pers["team"] == "axis" )
                iprintln(&"GMI_CTF_ASSISTED_AXIS_FLAG_CARRIER", other_flag.returned_by);
            else
                iprintln(&"GMI_CTF_ASSISTED_ALLIES_FLAG_CARRIER", other_flag.returned_by);
                    
            other_flag.returned_by.pers["score"] += assistbonus;
            other_flag.returned_by = other_flag.returned_by.pers["score"];
        }
        
        flag.returned_by = undefined;
            
        //move flag to its base position
        flag reset_flag();
    
        // clean up the player
        if(isPlayer(player))
        {
            player.hasflag = undefined;
            player maps\mp\uox\_uox::setPlayerIcons();
        }
                    
        //flag thread ctf_think();
    
        // check the score to see if we need to end the round
        thread maps\mp\uox\_uox::checkScoreLimit();
        return;
    }		
}

reset_flag()
{
	self notify("reset");
	
	//move flag to its base position
	self.trigger.origin = self.trigger.startorigin;
	self.origin = self.startorigin;
	self.angles = self.startangles;
	self.moved = false;
	self show();
	
	self.mobile_trigger.origin = self.trigger.startorigin;
	self.mobile_trigger triggerOff();
	self.mobile_model hide();

	self.carried_by = undefined;

	if ( level.showoncompass != 0 && isdefined(self.objnum) )
	{
		objective_delete( self.objnum );
		self.objnum = undefined;
	}
	// update the objective icon
	if ( self.team == "allies" )
	{
		objective_icon(self.hudnum,game["hud_allies_base_with_flag"] + ".dds");
		updateFlagIcons([[level.getVars]]("scr_showicons"), "reset_allies");
	}
	else
	{
		objective_icon(self.hudnum,game["hud_axis_base_with_flag"] + ".dds");
		updateFlagIcons([[level.getVars]]("scr_showicons"), "reset_axis");
	}
	
}

handle_vehicle_flag()
{
	self thread handle_change_flag();
	self endon("dropped");
	self endon("completed");
	while(1)
	{
		if (isdefined( self.carried_by) && !(self.carried_by isinvehicle()))		
			self.carried_by waittill("vehicle_activated",pos,vehicle);

		vehicle GetVehicleFlagPos(self.holding_flag,self);
		
		if ( isdefined(self.carried_by) && isvalidplayer(self.carried_by) )
		{
			if ( self.carried_by.has_attached )
			{
				self.carried_by.has_attached = false;
				self.carried_by detach(self.holding_flag,level.held_tag_flag);
			}
	
			self thread handle_vehicle_flag_exited();

			// wait until the the guy gets out of the vehicle before continuing
			wait(0.001);
			self.carried_by waittill("vehicle_deactivated",vehicle);
		}
		else
		{
			if (isdefined(self.vehiclemodel))
				self.vehiclemodel delete();
		}
		
		wait(0.001);
	}

}

GetVehicleFlagPos(flagname,flag)
{
	
	switch(self.vehicletype)
	{
		case	"t34_mp":
		case	"sherman_mp":
		case	"su152_mp":
		case	"panzeriv_mp":
		case	"elefant_mp":
			break;

		case	"horch_mp":
			break;
	}


	flag.vehiclemodel = spawn("script_model", self.origin + (0,0,160));
	flag.vehiclemodel.angles = self.angles + (0,0,0);
	flag.vehiclemodel setmodel(flagname);
	flag.vehiclemodel linkto(self,"tag_turret");
	flag.vehiclemodel setcontents(0);
	flag.vehiclemodel notsolid();
}

handle_vehicle_flag_exited()
{
	self.carried_by waittill("vehicle_deactivated",vehicle);
	
	// check for valid player
	if ( isvalidplayer(self.carried_by) )
	{
		self.carried_by.has_attached = true;
		self.carried_by attach(self.holding_flag,level.held_tag_flag, true);
	}
	
	if (isdefined(self.vehiclemodel))
		self.vehiclemodel delete();
}

onPlayerKill(victim, attacker)
{
    // make sure the flag gets dropped
	if(isdefined(victim.hasflag))
	{
		victim.hasflag drop_flag(victim);
	}

    if ( victim is_near_flag() )
    {
        // let everyone know
        if ( attacker.pers["team"] == "axis" )
            iprintln(&"GMI_CTF_DEFENDED_AXIS_FLAG", attacker);
        else
            iprintln(&"GMI_CTF_DEFENDED_ALLIES_FLAG", attacker);
        
        attacker.pers["score"] += [[level.getVars]]("scr_defensebonus");
        lpattacknum = attacker getEntityNumber();
        lpattackguid = attacker getGuid();
        logPrint("A;" + lpattackguid + ";" + lpattacknum + ";" + attacker.pers["team"] + ";" + attacker.name + ";" + "ctf_defended" + "\n");
    }
    if ( victim is_near_carrier(attacker) )
    {
        // let everyone know
        if ( attacker.pers["team"] == "axis" )
            iprintln(&"GMI_CTF_ASSISTED_AXIS_FLAG_CARRIER", attacker);
        else
            iprintln(&"GMI_CTF_ASSISTED_ALLIES_FLAG_CARRIER", attacker);
        
        attacker.pers["score"] += [[level.getVars]]("scr_assistbonus");
        lpattacknum = attacker getEntityNumber();
        lpattackguid = attacker getGuid();
        logPrint("A;" + lpattackguid + ";" + lpattacknum + ";" + attacker.pers["team"] + ";" + attacker.name + ";" + "ctf_assist" + "\n");
    }
}

// ----------------------------------------------------------------------------------
//	is_near_flag
//
// 	 	checks if the player is near the enemy flag
// ----------------------------------------------------------------------------------
is_near_flag()
{
	// determine the opposite teams flag
	if ( self.pers["team"] == "allies" )
		flag = level.axis_flag;
	else
		flag = level.allies_flag;	
		
	// if the flag is not at the base then return false
	if ( flag.moved )
		return false;
		
	dist = distance(flag.origin, self.origin);
	
	// if they were close to the flag then return true
	if ( dist < 750 )
		return true;
		
	return false;
}

// ----------------------------------------------------------------------------------
//	is_near_carrier
//
// 	 	checks if the player is near the enemy flag carrier
// ----------------------------------------------------------------------------------
is_near_carrier(attacker)
{
	// determine the teams flag
	if ( self.pers["team"] == "axis" )
		flag = level.axis_flag;
	else
		flag = level.allies_flag;	
		
	// if the flag is at the base then return false
	if ( !flag.moved )
		return false;
	
	// if the attacker is the carrier then return false
	if ( attacker == flag.carried_by )
		return false;
		
	// if the attacker is the carrier then return false
	if ( !isdefined(flag.carried_by) || !isAlive(flag.carried_by) || !isValidPlayer(flag.carried_by) )
		return false;
		
	dist = distance(self.origin, flag.carried_by.origin);
	
	// if they were close to the flag carrier then return true
	if ( dist < 750 )
		return true;
		
	return false;
}

triggerOff()
{
	self.origin = (self.origin - (0, 0, 10000));
}

update_objective()
{
	self endon("completed");
	self endon("reset");
	count1 = 1;
	
	// 0 is off, 1 is immediatly, greater then 1 is the position will be shown after that time in secs goes by
	show_time = [[level.getVars]]("scr_showoncompass");
	
	if(show_time == 0)
	{
		// make sure it was not on already
		if ( isDefined(self.objnum) && self.objnum )
		{
			objective_delete( self.objnum );
			self.objnum = undefined;
		}
		return;
	}
	
	// if show_time is greater then 0 then wait that number of seconds before displaying on radar for the first time	
	if ( show_time > 0 )
	{ 
		wait(show_time * 60);
	}		
	
	origin = get_flag_position();
	
	objnum = self.hudnum + 2;
	if ( !isDefined(self.objnum) )
	{
		self.objnum = objnum;
		objective_add(objnum, "current", origin, "gfx/hud/hud@objective_bel.tga");
		objective_icon(objnum,"gfx/hud/hud@objective_bel.tga");
		objective_team(objnum,"none");
	}
	objective_position(objnum, origin);
	lastobjpos = origin;
	newobjpos = origin;
	
	while(1)
	{
		wait(1);
		if(count1 != level.PositionUpdateTime)
			count1++;
		else
		{
			count1 = 1;
			origin = get_flag_position();
			lastobjpos = newobjpos;
			newobjpos = (((lastobjpos[0] + origin[0]) * 0.5), ((lastobjpos[1] + origin[1]) * 0.5), ((lastobjpos[2] + origin[2]) * 0.5));
			objective_position(objnum, newobjpos);
		}
	}
}

get_flag_position()
{
	origin = self.mobile_trigger.origin;
	
	// set the origin to be the carriers position if being carried
	if ( isdefined(self.carried_by) && isalive(self.carried_by))
	{
		origin = self.carried_by.origin;
	}
	return origin;
}

drop_flag(player)
{
	if (isdefined(player))
	{
		if (player.has_attached == true)
		{
			player.has_attached = false;
			player detach(self.holding_flag,level.held_tag_flag);	
		}
	}

	loc = (player.origin + (0, 0, 25));

	// get the drop position
	plant = player maps\mp\_utility::getPlant();
	end_loc = plant.origin;

	if(distance(loc, end_loc) > 0)
	{
		self.mobile_model.origin = loc;
		self.mobile_model.angles = plant.angles;
		self.mobile_model show();
		speed = (distance(loc, end_loc) / 250);
		if(speed > 0.4)
		{
			self.mobile_model moveto(end_loc, speed, 0.1, 0.1);
			self.mobile_model waittill("movedone");
			self.mobile_trigger.origin = end_loc;
		}
		else
		{
			self.mobile_model.origin = end_loc;
			self.mobile_model show();
			self.mobile_trigger.origin = end_loc;
		}
	}
	else
	{
		self.mobile_model.origin = end_loc;
		self.mobile_model show();
		self.mobile_trigger.origin = end_loc;
	}

	// check if its inside a vehicle
	vehicles = getentarray("script_vehicle","classname");

	for(i=0;i<vehicles.size;i++)
	{
		if ( self.mobile_model istouching(vehicles[i]) )
		{
			valid_origin =  vehicles[i] getdismountspot();
			
			self.mobile_model.origin = valid_origin;
			self.mobile_model.angles = plant.angles;  // just use the angles from the plant
			self.mobile_trigger.origin = valid_origin;
			break;
		}
	}
	
	self.mobile_model show();

	if(isPlayer(player))
	{
		player.hasflag = undefined;
		player maps\mp\uox\_uox::setPlayerIcons();
	}

	//check if it's in a minefield
	In_Mines = 0;
	for(i = 0; i < level.minefield.size; i++)
	{
		if(self.mobile_model istouching(level.minefield[i]))
		{
			In_Mines = 1;
			break;
		}
	}

	In_Water = 0;
	for(i = 0; i < level.deepwater.size; i++)
	{
		if(self.mobile_model istouching(level.deepwater[i]))
		{
			In_Water = 1;
			break;
		}
	}
	if(In_Mines == 1)
	{
		if((!isdefined(level.lastdropper)) || (level.lastdropper != player))
		{
			level.lastdropper = player;
			iprintln(&"GMI_CTF_FLAG_INMINES", player);
		}
		
		self reset_flag();
	}
	else if(In_Mines == 1)
	{
		if((!isdefined(level.lastdropper)) || (level.lastdropper != player))
		{
			level.lastdropper = player;
			iprintln(&"GMI_CTF_FLAG_INWATER", player);
		}
		
		self reset_flag();
	}
	else
	{
		self thread flag_timeout();

		if ( self.team == "allies" )
        {
                iprintln(&"GMI_CTF_ALLIES_FLAG_DROPPED");
                updateFlagIcons([[level.getVars]]("scr_showicons"), "allies_dropped");

        }
		else
        {
                iprintln(&"GMI_CTF_AXIS_FLAG_DROPPED");
                updateFlagIcons([[level.getVars]]("scr_showicons"), "axis_dropped");
        }
	}

	self notify("dropped");
	//self thread ctf_think();
}

flag_timeout()
{
	self endon("picked up");
	self endon("reset");
	flag_timeout = [[level.getVars]]("scr_flagtimeout");
    if (flag_timeout == 0)
        return;
    if(flag_timeout < 10)
        flag_timeout = 10;
	wait flag_timeout;
	
	if ( self.team == "axis")
	{
		announcement(&"GMI_CTF_AXIS_FLAG_TIMEOUT_RETURNING");
	}
	else
	{
		announcement(&"GMI_CTF_ALLIES_FLAG_TIMEOUT_RETURNING");
	}
	
	// play the flag has been returned sound
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		temp_player = players[i];
		if(temp_player.pers["team"] == "allies" && self.team == "allies")
			temp_player playLocalSound(game["sound_allies_flag_has_been_returned"]);
		else if(temp_player.pers["team"] == "axis" && self.team == "axis")
			temp_player playLocalSound(game["sound_axis_flag_has_been_returned"]);
	}
	
	self.returned_by = undefined;

	self reset_flag();
	self notify("timeout");
	self thread ctf_think_wait();
}
