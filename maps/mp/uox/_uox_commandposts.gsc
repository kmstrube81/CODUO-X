precache()
{
    game["hud_ring"] = "gfx/hud/hudadd@dom_ring.dds";
    game["hud_axis_flag"] = "gfx/hud/hud@dom_g.dds";
    game["hud_neutral_flag"] = "gfx/hud/hud@dom_n.dds";

    // set up team specific variables
    switch( game["allies"])
    {
    case "british":
        game["hud_allies_radar"] = "gfx/hud/hud@objective_british";
        game["hud_allies_flag"] = "gfx/hud/hud@dom_b.dds";
        
        game["sound_allies_area_secure"] = "uk_area_secured";
        game["sound_allies_ground_taken"] = "uk_ground_taken";
        game["sound_allies_enemy_has_taken_flag"] = "uk_lost_ground";
        game["sound_allies_enemy_is_taking_flag"] = "uk_losing_ground";
        break;
    case "russian":
        game["hud_allies_radar"] = "gfx/hud/hud@objective_russian";
        game["hud_allies_flag"] = "gfx/hud/hud@dom_r.dds";

        game["sound_allies_area_secure"] = "ru_area_secured";
        game["sound_allies_ground_taken"] = "ru_ground_taken";
        game["sound_allies_enemy_has_taken_flag"] = "ru_lost_ground";
        game["sound_allies_enemy_is_taking_flag"] = "ru_losing_ground";
        break;
    default:		// default is american
        game["hud_allies_radar"] = "gfx/hud/hud@objective_american";
        game["hud_allies_flag"] = "gfx/hud/hud@dom_us.dds";

        game["sound_allies_area_secure"] = "us_area_secured";
        game["sound_allies_ground_taken"] = "us_ground_taken";
        game["sound_allies_enemy_has_taken_flag"] = "us_lost_ground";
        game["sound_allies_enemy_is_taking_flag"] = "us_losing_ground";
        break;
    }

    game["sound_axis_area_secure"] = "ge_area_secured";
    game["sound_axis_ground_taken"] = "ge_ground_taken";
    game["sound_axis_enemy_has_taken_flag"] = "ge_lost_ground";
    game["sound_axis_enemy_is_taking_flag"] = "ge_losing_ground";

    game["hud_neutral_radar"] = "gfx/hud/hud@objective_gray";
    game["hud_capping_radar"] = "gfx/hud/objective_yellow";
    game["hud_axis_radar"] = "gfx/hud/hud@objective_german";
    
    precacheShader(game["hud_axis_flag"]);
    precacheShader(game["hud_allies_flag"]);

    precacheShader(game["hud_neutral_radar"]);
    precacheShader(game["hud_neutral_radar"]+ "_up");
    precacheShader(game["hud_neutral_radar"]+ "_down");
    precacheShader(game["hud_capping_radar"]);
    precacheShader(game["hud_capping_radar"]+ "_up");
    precacheShader(game["hud_capping_radar"]+ "_down");
    precacheShader(game["hud_allies_radar"]);
    precacheShader(game["hud_allies_radar"]+ "_up");
    precacheShader(game["hud_allies_radar"]+ "_down");
    precacheShader(game["hud_axis_radar"]);
    precacheShader(game["hud_axis_radar"]+ "_up");
    precacheShader(game["hud_axis_radar"]+ "_down");

    // GMI FLAG MATCH IMAGES:
    precacheShader(game["hud_ring"]);
    precacheShader(game["hud_axis_flag"]);
    precacheShader(game["hud_allies_flag"]);
    precacheShader(game["hud_neutral_flag"]);
}

initVars()
{
	//init gametype vars
    maps\mp\uox\_uox_vars::varDef("scr", "domination_points", "int", true, 2, 0, 10, "Domination Team Score Bonus");
    maps\mp\uox\_uox_vars::varDef("scr", "domination_endround", "bool", true, true, "", "", "End Round on Domination");
    maps\mp\uox\_uox_vars::varDef("scr", "capture_points", "int", true, 1, 0, 10, "Team Score Bonus on Capture");
    maps\mp\uox\_uox_vars::varDef("scr", "hold_points", "int", true, 0, 0, 10, "Team Score Bonus on Hold");
    maps\mp\uox\_uox_vars::varDef("scr", "hold_timer", "int", true, 0, 0, 99, "Flag Hold Time (seconds)");
    maps\mp\uox\_uox_vars::varDef("scr", "defensebonus", "int", true, 0, 0, 10, "Flag Defended Bonus");
    maps\mp\uox\_uox_vars::varDef("scr", "capturebonus", "int", true, 0, 0, 10, "Flag Capture Bonus");
    maps\mp\uox\_uox_vars::varDef("scr", "capturepenalty", "int", true, 0, 0, 10, "Flag Loss Penalty");
    maps\mp\uox\_uox_vars::varDef("scr", "showicons", "bool", true, true, "", "", "Show Flag Icons");
    level.flag_timer = maps\mp\uox\_uox_vars::varDef("scr", "flagcapturetime", "int", true, 10, 3, 99, "Flag Capture Time (seconds");
    level.custom_flags = maps\mp\uox\_uox_vars::varDef("scr", "customflags", "string", false, "", "", "Custom Flags");
    // set some values for the icon positions
	game["flag_icons_w"] = 32;
	game["flag_icons_h"] = 32;
	game["flag_icons_x"] = 320 - ( game["flag_icons_w"] * 2.5 );  // defaults to five flags changed later for actual flag count
	game["flag_icons_y"] = 480 - game["flag_icons_h"];

    if(!isDefined(game["dom_allies_obj_text"]))		
		game["dom_allies_obj_text"] = (&"GMI_DOM_OBJ_ALLIES");
	if(!isDefined(game["dom_axis_obj_text"]))		
		game["dom_axis_obj_text"] = (&"GMI_DOM_OBJ_AXIS");
	if(!isDefined(game["dom_spectator_obj_text"]))		
		game["dom_spectator_obj_text"] = (&"GMI_DOM_OBJ_SPECTATOR");
    level.flagcount = 1; // Used to count how many flags are in the level.
	level.max_flag_count = 15;  // this is the limit of the amount of flags in one level

    //get the minefields
	level.minefield = getentarray("minefield", "targetname");
	if (!isdefined (level.minefield))
		level.minefield = [];
	hurtTrigs = getentarray("trigger_hurt","classname");
	for (i=0;i<hurtTrigs.size;i++)
		level.minefield[level.minefield.size] = hurtTrigs[i];
}

flag_setup()
{
    Flag_InitTriggers();
	Flag_StartThinking(); // Start the Flag_StartThinking thread. This sets up the flags for primetime.

	level thread maps\mp\uox\_uox_loops::addToLoop(level, "medium", ::Flag_AllCapturedThink, "Flag_AllCapturedThink");
	level thread maps\mp\uox\_uox_loops::addToLoop(level, "medium", ::drawFlagsOnCompass, "drawFlagsOnCompass");
}

onPlayerKill(victim, attacker)
{
    if(isPlayer(attacker))
	{
		// check to see if they were killed in the process of capping the flag
		capping = Capture_CheckCappingFlag(self);

        if(capping)
        {
            bonus = [[level.getVars]]("scr_defensebonus");
            attacker.score += bonus;
            attacker.pers["score"] = attacker.score;
        }
    }
}

// ----------------------------------------------------------------------------------
//	Capture_CheckCappingFlag
//
// 	Checks to see if the player is currently capping the flag and returns true.
// ----------------------------------------------------------------------------------
Capture_CheckCappingFlag(player)
{
	opposing_team = "allies"; 
	if ( player.pers["team"] == "allies") 
		opposing_team = "axis" ; 
	
	// loop through all the flags and see if the player is in one
	for(q=0;q<level.flags.size;q++)
    {
        flag = level.flags[q];

		// we only need to check the ones held by the other team
		if(flag.team == opposing_team && player istouching(flag))
		{
			return true;
		}
	}
	
	return false;
}

// ----------------------------------------------------------------------------------
//	Flag_InitTriggers
//
// 		Sets up all of the flag triggers with an id and a description
// ----------------------------------------------------------------------------------
Flag_InitTriggers()
{
    // Setting up the flag TRIGGERS
    flags = [];
    if(level.custom_flags != "")
    {
        customflags = maps\mp\uox\_uox_utils::stringSplit(level.custom_flags, ";");
        for(q = 0; q < customflags.size && q < level.max_flag_count - 1; q++)
        {
            i = customflags[q];

            current_flag = getent("flag" + i,"targetname");
            if(!isDefined(current_flag)) // If the flag exists, then proceed. Which then tells all of the allies and axis flag to be hidden.
            {
                continue;
            }
            current_flag.flagno = i;
            flags[flags.size] = current_flag;
            level.flagcount++;

            getent("flag" + i + "_allies","targetname") hide();
    		getent("flag" + i + "_axis","targetname") hide();

    		if(!isDefined(current_flag.script_idnumber) || current_flag.script_idnumber == 0)
    		{
    			current_flag.script_idnumber = i;
    		}

    		if(!isDefined(current_flag.description)) // If a flag has no description set, randomly pick something silly.
    		{
    			n = randomint(5);
    			switch(n)
    			{
    				case 0:
    					current_flag.description = (&"GMI_DOM_UNNAMED_FLAG0");
    					break;
    				case 1:
    					current_flag.description = (&"GMI_DOM_UNNAMED_FLAG1");
    					break;
    				case 2:
    					current_flag.description = (&"GMI_DOM_UNNAMED_FLAG2");
    					break;
    				case 3:
    					current_flag.description = (&"GMI_DOM_UNNAMED_FLAG3");
    					break;
    				case 4:
    					current_flag.description = (&"GMI_DOM_UNNAMED_FLAG4");
    					break;
    			}
    								
    		}
        }

        if (level.flagcount == 1) // If no flags are found, then do regular flag search.
    	{
            for(q=1;q<level.max_flag_count;q++)
            {
                current_flag = getent("flag" + q,"targetname");
                if(!isDefined(current_flag)) // If the flag exists, then proceed. Which then tells all of the allies and axis flag to be hidden.
                {
                    continue;
                }
                flags[flags.size] = current_flag;
                level.flagcount++;
            }

            current_flag = getent("flag" + q,"targetname");
            if(!isDefined(current_flag)) // If the flag exists, then proceed. Which then tells all of the allies and axis flag to be hidden.
            {
                continue;
            }
            flags[flags.size] = current_flag;
            level.flagcount++;

            getent("flag" + q + "_allies","targetname") hide();
    		getent("flag" + q + "_axis","targetname") hide();

    		if(!isDefined(current_flag.script_idnumber) || current_flag.script_idnumber == 0)
    		{
    			current_flag.script_idnumber = q;
    		}

    		if(!isDefined(current_flag.description)) // If a flag has no description set, randomly pick something silly.
    		{
    			n = randomint(5);
    			switch(n)
    			{
    				case 0:
    					current_flag.description = (&"GMI_DOM_UNNAMED_FLAG0");
    					break;
    				case 1:
    					current_flag.description = (&"GMI_DOM_UNNAMED_FLAG1");
    					break;
    				case 2:
    					current_flag.description = (&"GMI_DOM_UNNAMED_FLAG2");
    					break;
    				case 3:
    					current_flag.description = (&"GMI_DOM_UNNAMED_FLAG3");
    					break;
    				case 4:
    					current_flag.description = (&"GMI_DOM_UNNAMED_FLAG4");
    					break;
    			}
    								
    		}
    	}
    }
    else
    {
        for(q=1;q<level.max_flag_count;q++)
        {
            current_flag = getent("flag" + q,"targetname");
            if(!isDefined(current_flag)) // If the flag exists, then proceed. Which then tells all of the allies and axis flag to be hidden.
            {
                continue;
            }
            flags[flags.size] = current_flag;
            level.flagcount++;
        }
    }
	
    if (level.flagcount == 1) // If no flags are found, then do regular flag search.
        maps\mp\_utility::error("THERE ARE NO FLAGS IN MAP");

	// set the x position of the first flag icon
	game["flag_icons_x"] = 320 - ( game["flag_icons_w"] * (level.flagcount - 1 ) * 0.5 );
      
    level.flags = flags;
}

// ----------------------------------------------------------------------------------
//	Flag_StartThinking
//
// 		Sets up the flags and then starts the think loop for each one
// ----------------------------------------------------------------------------------
Flag_StartThinking()
{
	flags = level.flags;
	// Setting up the flag TRIGGERS
	for(q=0;q<flags.size;q++) // Makes the flag limit of 15, then searches for all of the flags in the map.
	{
		flag = getent("flag"+q,"targetname");
		
		flag.id = q;
		Flag_Initialize(flag);
				
		if(flag.script_idnumber < 0 || flag.script_idnumber > level.flagcount )
		{
			maps\mp\_utility::error("Bad script_idnumber " + script_idnumber + " for flag " + q);
		}
		
		SetupFlagIcon(flag);
		flag thread Flag_ZoneThink();
        maps\mp\uox\_uox_debug::debugLog("info", "Flag_ZoneThink ARMING trigger");
        flag maps\mp\uox\_uox_loops::addToWaitTills(flag, "trigger", ::Flag_ZoneThink, true);
        flag thread maps\mp\uox\_uox_loops::removeFromWaitTills(flag, "trigger", level, "round_ended");
	}
}

// ----------------------------------------------------------------------------------
//	Flag_Initialize
//
// 		Sets up a flag
// ----------------------------------------------------------------------------------
Flag_Initialize(flag)
{
	flag.team = "neutral";
	flag.allies = 0;
	flag.axis = 0;
	flag.progresstime = 0;
	flag.axis_capping = 0;
	flag.allies_capping = 0;
	flag.capping = 0;
	flag.last_capping = 0;
	flag.scale = 0;
	flag.radarupdated = 0;
	flag.beingcapped = false;
    flag.armed = 0;
	
	// now see if we can find any props that need to be turned off 
	props = getentarray("flag" + flag.id + "stuff_allies", "targetname");
	for ( i = 0; i < props.size; i++ )
	{
		props[i] hide();
	}

	// now see if we can find any props that need to be turned on 
	props = getentarray("flag" + flag.id + "stuff_axis", "targetname");
	for ( i = 0; i < props.size; i++ )
	{
		props[i] hide();
	}

	// now see if we can find any props that need to be turned on 
	props = getentarray("flag" + flag.id + "stuff_neutral", "targetname");
	for ( i = 0; i < props.size; i++ )
	{
		props[i] show();
	}
	
	// start special flag sounds playing if there are any
	sound_maker = getent("flag"+ flag.id + "radio" ,"targetname");
	if (isDefined(sound_maker) && isDefined(game["neutralradio"]))
	{
		sound_maker playloopsound( game["neutralradio"]);
	}
    
    flag thread maps\mp\uox\_uox_loops::initEntityLoop();	
}

// ----------------------------------------------------------------------------------
//	SetupFlagIcon
//
// 		Sets up a flag icon
// ----------------------------------------------------------------------------------
SetupFlagIcon(flag)
{
    if (![[level.getVars]]("scr_showicons"))
		return;
	
    options = [];

	options["alignX"] = "left";
	options["alignY"] = "top";
	options["x"] = game["flag_icons_x"] + (flag.script_idnumber * game["flag_icons_w"]) - game["flag_icons_w"];
	options["y"] = game["flag_icons_y"];
	options["sort"] = 0.0; // To fix a stupid bug, where the first flag icon (or the one to the furthest left) will not sort through the capping icon. BAH!
    options["width"] = game["flag_icons_w"];
    options["height"] = game["flag_icons_h"];

	if(flag.team == "allies")
        flagshader = game["hud_allies_flag"];
	else if(flag.team == "axis")
        flagshader = game["hud_axis_flag"];
	else
        flagshader = game["hud_neutral_flag"];

    flag.icon = maps\mp\uox\_uox_hud::updateHUDElement(flag.icon, "shader", flagshader, options);
}

// ----------------------------------------------------------------------------------
//	Flag_ZoneThink
//
// 		This is continually called for each flag.  This lets the flag determine
//		if it is being captured
// ----------------------------------------------------------------------------------
Flag_ZoneThink()
{
	level endon("round_ended");

	if(!isDefined(self.script_timer))
		self.script_timer = level.flag_timer;

    if((isDefined( self.capping ) && self.capping == 0) || level.roundended)
    {
        self Capture_Canceled();
        return;
    }

    if(game["matchstarted"] == false || level.roundstarted == false)
        return;

    // zero out the flag capping count
    self.capping = undefined;
    self.allied_capping = 0;
    self.axis_capping = 0;
    
    players = getentarray("player", "classname");
    
    // count up the people in the flag area
    for(i = 0; i < players.size; i++)
    {
        player = players[i];

        if(isAlive(player) && (player istouching(self)) && !(player isinvehicle()) )
        {
            if(player.pers["team"] == "allies")
            {
                self.allied_capping++;
            }
            else if(player.pers["team"] == "axis")					
            {
                self.axis_capping++;		
            }
        }
    }
    if(self.allied_capping > 0 || self.axis_capping > 0)
        self.capping = self.allied_capping - self.axis_capping;	

    // set this variable if only one team is currently trying to cap
    one_team = 0;
    if ( self.allied_capping == 0 || self.axis_capping == 0 )
    { 
        if ( self.allied_capping != 0 && self.team != "allies" )
        {
            one_team = 1;
        }
        else if ( self.axis_capping != 0 && self.team != "axis" )
        {
            one_team = 1;
        }
    }
    
    // is only one team trying to cap?
    if ( one_team )
    {
        // now each player need to have their flag progress bar started
        for(i = 0; i < players.size; i++)
        {
            player = players[i];

            if(isAlive(player) && player istouching(self))
            {
                if(!isDefined(player.pers["capture_process_thread"]))
                    player.pers["capture_process_thread"] = 0;

                // if this flag is set then the player is currently already displaying the flag info
                if (player.pers["capture_process_thread"] == 1)
                    continue;
                    
                player.pers["capture_process_thread"] = 1;
                player thread Capture_PlayerCappingFlag(self);
            }
        }

        // if this just started being capped then update the radar
        if ( !self.beingcapped )
        {
            self.radarupdated = false;
        }
        self.beingcapped = true;
        
        if (self.capping > 0)
        {
            self.progresstime += (0.05) * ((1 + (self.capping - 1) * 0.5 ));
            if(self.capping == 1)
            {
                name = other;
            }
        }
        else if (self.capping < 0)
        {
            self.progresstime +=  (0.05) * ((1 + (-1 * self.capping - 1) * 0.5 ));
            if(self.capping == -1)
            {
                name = other;
            }
        }

        self.scale = (self.progresstime / self.script_timer);
    }
    else
    {
        self Capture_Canceled();
        wait 0.05;
    }	

//			self.blinking_icon.x  =-64;	//	move off
//			self.blinking_icon.y = -64;
    
    // display the screen icons
    if ( [[level.getVars]]("scr_showicons") && self.scale > 0.00001)
    {
        capping_options = [];
        
        capping_options["alignX"] = "left";
        capping_options["alignY"] = "top";
        capping_options["x"] = game["flag_icons_x"] + (self.script_idnumber * game["flag_icons_w"]) - game["flag_icons_h"];
        capping_options["y"] = game["flag_icons_y"];
        capping_options["sort"] = 0.5;  // To fix a stupid bug, where the first flag icon (or the one to the furthest left) will not sort through the capping icon. BAH!
        capping_options["crop_width"] = 1.0;

        blinking_options = [];
        
        blinking_options["alignX"] ="left";
        blinking_options["alignY"] ="top";
        blinking_options["x"] =game["flag_icons_x"] + (self.script_idnumber * game["flag_icons_w"]) - game["flag_icons_h"];
        blinking_options["y"] = game["flag_icons_y"];
        blinking_options["sort"] = 0.7;  // To fix a stupid bug, where the first flag icon (or the one to the furthest left) will not sort through the capping icon. BAH!
        blinking_options["width"] = 32;
        blinking_options["height"] = 32;
        
        
        if(self.scale * game["flag_icons_w"] >= 1)
        {

            //	we need to clamp this to int values and back to float 
            //	this is because just using float values is TOOO smooth 
            capping_int	= (int)(self.scale * 32);

        
            capping_float = (float)capping_int / 32.0;
        
            switch((capping_int/2) % 2)
            {
                case	0:	blinking_options["color"] = (1,1,0);
                        break;
                case	1:	blinking_options["color"] = (0,0,0);
                        break;
            }
            capping_options["crop_height"] = capping_float;
            self.blinking_icon = maps\mp\uox\_uox_hud::updateHUDElement(self.blinking_icon,"shader", game["hud_ring"], options);

            if(self.capping > 0)
                flagshader = game["hud_allies_flag"];
            else
                flagshader = game["hud_axis_flag"];
            self.capping_icon = maps\mp\uox\_uox_hud::updateHUDElement(self.capping_icon,"shader", flagshader, options);
        }

    }

    self.last_capping = self.capping;
    if(self.scale >= 0.999999)
    {
        cappers = self.capping;
        
        if(self.capping > 0)
        {
            self thread Capture_AlliesCappedFlag(cappers,name);
        }
        else
        {
            self thread Capture_AxisCappedFlag(cappers,name);
        }
        
        other.score = other.pers["score"];
        
        self Capture_Canceled();
    }
}

// ----------------------------------------------------------------------------------
//	Capture_PlayerCappingFlag
//
// 		Gets called when a player starts capping a flag.  This displays the 
//		progress bar.
// ----------------------------------------------------------------------------------
Capture_UpdateProgressBar()
{

    flag = self.capping_flag;

	self endon("death");
	level endon("round_ended");
	flag endon("capture_canceled");
	flag endon("captured");

    if(	( ((flag.axis_capping == 0) || (flag.allied_capping == 0))
		&& self.pers["team"] != flag.team 
		&& self.pers["team"] != "spectator" )
        && flag.scale > 0)
            maps\mp\uox\_uox_hud::createClientHUDProgressBar(flag.script_timer, &"GMI_DOM_CAPTURING_FLAG", flag.script_timer * flag.scale);
}

// ----------------------------------------------------------------------------------
//	drawFlagsOnCompass
//
// 	Draws all of the compass flags and objectives
// ----------------------------------------------------------------------------------
drawFlagsOnCompass()
{
    for(q=0;q<level.flags.size;q++)
    {
        flag = level.flags[q];
        current_flag = getent("flag" + flag.flagno + "_neutral","targetname");
        flag_trigger = flag;
        
        if (!isDefined(current_flag))
            maps\mp\_utility::error("Could not find the flag entity flag" + q + "_neutral"); 
        if (!isDefined(flag_trigger))
            maps\mp\_utility::error("Could not fine the flag trigger flag" + q ); 

        if ( !isDefined(flag_trigger.team) )
            continue;
            
        if ( flag_trigger.radarupdated )
            continue;		
    
        flag_trigger.radarupdated = true;
        
        if(flag_trigger.beingcapped)
        {
            objective_add(flag_trigger.id, "current", current_flag.origin, game["hud_capping_radar"]);
            objective_onEntity(flag_trigger.id, current_flag);
            flag_trigger.yellow = 1;	//JS - this is to keep the shader from starting over every 0.5 seconds

            //play the flag lost sound based on team
            players = getentarray("player", "classname");
            for(i = 0; i < players.size; i++)
            {
                player = players[i];
                switch(player.pers["team"])
                {
                    case "allies":
                    {
                        if( flag_trigger.team == "allies")
                        {
                            player playLocalAnnouncerSound(game["sound_allies_enemy_is_taking_flag"]);
                            player iprintln(&"GMI_DOM_AXIS_FLAG_OVERRUN", flag_trigger.description);
                        }
                        break;
                    }
                    case "axis":
                    {
                        if( flag_trigger.team== "axis" )
                        {
                            player playLocalAnnouncerSound(game["sound_axis_enemy_is_taking_flag"]);
                            player iprintln(&"GMI_DOM_ALLIES_FLAG_OVERRUN", flag_trigger.description);
                        }
                    }
                }
            }
        }
        else if(flag_trigger.team == "allies")
        {
            objective_delete(flag_trigger.id, "current", current_flag.origin, game["hud_axis_radar"]);
            objective_delete(flag_trigger.id, "current", current_flag.origin, game["hud_neutral_radar"]);
            objective_delete(flag_trigger.id, "current", current_flag.origin, game["hud_capping_radar"]);
            objective_add(flag_trigger.id, "current", current_flag.origin, game["hud_allies_radar"]);
        }
        else if(flag_trigger.team == "axis")
        {
            objective_delete(flag_trigger.id, "current", current_flag.origin, game["hud_allies_radar"]);
            objective_delete(flag_trigger.id, "current", current_flag.origin, game["hud_neutral_radar"]);
            objective_delete(flag_trigger.id, "current", current_flag.origin, game["hud_capping_radar"]);
            objective_add(flag_trigger.id, "current", current_flag.origin, game["hud_axis_radar"]);
        }
        else if(flag_trigger.team == "neutral")
        {
            objective_delete(flag_trigger.id, "current", current_flag.origin, game["hud_allies_radar"]);
            objective_delete(flag_trigger.id, "current", current_flag.origin, game["hud_axis_radar"]);
            objective_delete(flag_trigger.id, "current", current_flag.origin, game["hud_capping_radar"]);
            objective_add(flag_trigger.id, "current", current_flag.origin, game["hud_neutral_radar"]);
        }
    }
}

// ----------------------------------------------------------------------------------
//	Capture_PlayerCappingFlag
//
// 		Gets called when a player starts capping a flag.  This displays the 
//		progress bar.
// ----------------------------------------------------------------------------------
Capture_PlayerCappingFlag(flag)
{
	if ( !isAlive(self) )
		return;
		
	if(flag.capping != 0)
	{
		getent((flag.targetname + "_neutral"),"targetname") playloopsound("start_flag_capture");
	}
	
    self.capping_flag = flag;
	self maps\mp\uox\_uox_loops::addToLoop(self, "fast", ::Capture_UpdateProgressBar, "Capture_UpdateProgressBar");
	
	flag waittill("capture_canceled");
	self maps\mp\uox\_uox_loops::removeFromLoop(self, "fast", "Capture_UpdateProgressBar");
    self.capping_flag = undefined;
	// we are done so destroy the progress bars
	maps\mp\uox\_uox_hud::deleteClientHUDProgressBar();
	
	getent((flag.targetname + "_neutral"),"targetname") stoploopsound("start_flag_capture");
	self.pers["capture_process_thread"] = 0;
}

// ----------------------------------------------------------------------------------
//	Capture_Canceled
//
// 		Called on a flag when the capture is ended for any reason
// ----------------------------------------------------------------------------------
Capture_Canceled()
{
	self notify("capture_canceled");
	
	self.beingcapped = false;
	self.radarupdated = 0;

	self.progresstime = 0;
	self.scale = 0;

    self.capping_icon = maps\mp\uox\_uox_hud::deleteHUDElement(self.capping_icon);

	self.blinking_icon = maps\mp\uox\_uox_hud::deleteHUDElement(self.blinking_icon);
	
	getent((self.targetname + "_neutral"),"targetname") stoploopsound("start_flag_capture");

}

// ----------------------------------------------------------------------------------
//	Capture_AlliesCappedFlag
//
// 		Gets called when the allies cap a flag.  Displays the appropriate flag.
//		Also displays the cap messages.
// ----------------------------------------------------------------------------------
Capture_AlliesCappedFlag(cappers,name)
{
	self notify("captured");

    self notify("kill_later_hold_bonus");
    self thread maps\mp\uox\_uox_utils::notifyLater("hold_bonus",[[level.getVars]]("scr_hold_timer"), self);
    self thread Hold_CappedFlag();
	
	old_team = self.team;
	self.team = "allies";
	self.radarupdated = 0;	

	game["alliedscore"]+= [[level.getVars]]("scr_capture_points");
	setTeamScore("allies", game["alliedscore"]);
	
	//play the flag taken vo on all players.  
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if(player.pers["team"] == "allies")
		{
			if ( old_team != "axis" )
				player playLocalAnnouncerSound(game["sound_allies_area_secure"]);
			else
				player playLocalAnnouncerSound(game["sound_allies_ground_taken"]);
		}
		else
			player playLocalAnnouncerSound(game["sound_axis_enemy_has_taken_flag"]);
	}
	
	getent((self.targetname + "_axis"),"targetname") hide();
	getent((self.targetname + "_neutral"),"targetname") hide();
	getent((self.targetname + "_allies"),"targetname") show();	
	
	if (game["showicons"])
		self.icon setShader(game["hud_allies_flag"], game["flag_icons_w"], game["flag_icons_h"]);
	
	// if the flag is capped from the other teamgive them all the reverse penalty
	if ( old_team == "axis" )
	{
		maps\mp\uox\_uox::GivePointsToTeam( "axis", 0 - [[level.getVars]]("scr_capturepenalty") );
	}
	
	// give the team points out
	maps\mp\uox\_uox::GivePointsToTeam( self.team, [[level.getVars]]("scr_capturebonus") );
	
	// give out points to the cappers
	self GivePointsToCappers( "allies" );

	names = self GetCappers("allies");

	// display the cap message
	if(cappers > 1)
	{
		// this will cause an unlocalized string warning if you are running in developer mode because of the names
		PrintCappedMessage(&"GMI_DOM_ALLIES_CAP_FLAG_TEAM",self.description,names);
	}
	else
	{
		// this will cause an unlocalized string warning if you are running in developer mode because of the names
		iprintln(&"GMI_DOM_ALLIES_CAP_FLAG_SOLO",names[0],self.description);
	}
	
	// now see if we can find any props that need to be turned off 
	props = getentarray("flag" + self.script_idnumber + "stuff_" + old_team, "targetname");
	for ( i = 0; i < props.size; i++ )
	{
		props[i] hide();
	}

	// now see if we can find any props that need to be turned on 
	props = getentarray("flag" + self.script_idnumber + "stuff_allies", "targetname");
	for ( i = 0; i < props.size; i++ )
	{
		props[i] show();
	}
	
	// start special flag sounds playing if there are any
	sound_maker = getent("flag" + self.script_idnumber + "radio","targetname");
	if (isDefined(sound_maker) && isDefined(game[self.team + "radio"]))
	{
		sound_maker playloopsound(game[self.team + "radio"]);
	}

    //reset hold timer
}

// ----------------------------------------------------------------------------------
//	Capture_AxisCappedFlag
//
// 		Gets called when the axis cap a flag.  Displays the appropriate flag.
//		Also displays the cap messages.
// ----------------------------------------------------------------------------------
Capture_AxisCappedFlag(cappers,name)
{
	self notify("captured");

    self notify("kill_later_hold_bonus");
    self thread maps\mp\uox\_uox_utils::notifyLater("hold_bonus",[[level.getVars]]("scr_hold_timer"), self);
    self thread Hold_CappedFlag();

	old_team = self.team;
	self.team = "axis";
	self.radarupdated = 0;	
	
	game["axisscore"]+= [[level.getVars]]("scr_capture_points");;
	setTeamScore("axis", game["axisscore"]);

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if(player.pers["team"] == "allies")
			player playLocalAnnouncerSound(game["sound_allies_enemy_has_taken_flag"]);
		else
		{
			if ( old_team != "allies" )
				player playLocalAnnouncerSound(game["sound_axis_area_secure"]);
			else
				player playLocalAnnouncerSound(game["sound_axis_ground_taken"]);
		}
	}
	
	getent((self.targetname + "_allies"),"targetname") hide();
	getent((self.targetname + "_neutral"),"targetname") hide();
	getent((self.targetname + "_axis"),"targetname") show();

	if (game["showicons"])
		self.icon setShader(game["hud_axis_flag"], game["flag_icons_w"], game["flag_icons_h"]);

	// if the flag is capped from the other teamgive them all the reverse penalty
	if ( old_team == "allies" )
	{
		maps\mp\uox\_uox::GivePointsToTeam( "allies", 0 - [[level.getVars]]("scr_capturepenalty") );
	}
	
	// give the team points out
	maps\mp\uox\_uox::GivePointsToTeam( self.team, [[level.getVars]]("scr_capturebonus") );
	
	// give out points to the cappers
	self GivePointsToCappers( "axis" );

	names = self GetCappers("axis");

	// display the cap message
	if(cappers < -1)
	{
		// this will cause an unlocalized string warning if you are running in developer mode because of the names
		PrintCappedMessage(&"GMI_DOM_AXIS_CAP_FLAG_TEAM",self.description,names);
	}
	else
	{
		// this will cause an unlocalized string warning if you are running in developer mode because of the names
		iprintln(&"GMI_DOM_AXIS_CAP_FLAG_SOLO",names[0],self.description);
	}
	
	// now see if we can find any props that need to be turned off 
	props = getentarray("flag" + self.script_idnumber + "stuff_" + old_team, "targetname");
	for ( i = 0; i < props.size; i++ )
	{
		props[i] hide();
	}

	// now see if we can find any props that need to be turned on 
	props = getentarray("flag" + self.script_idnumber + "stuff_axis", "targetname");
	for ( i = 0; i < props.size; i++ )
	{
		props[i] show();
	}
	
	// start special flag sounds playing if there are any
	sound_maker = getent("flag" + self.script_idnumber + "radio","targetname");
	if (isDefined(sound_maker )&& isDefined(game[self.team + "radio"]))
	{
		sound_maker playloopsound( game[self.team + "radio"]);
	}

    //reset hold timer
		
}

Hold_CappedFlag()
{
    if(self.armed)
        return;
    self.armed = 1;
    level endon("round_ended");
    self waittill("hold_bonus");

    if(self.team == "allies")
    {
        game["alliesscore"]+= [[level.getVars]]("scr_hold_points");;
        setTeamScore("allies", game["alliesscore"]);
    }
    else
    {
        game["axisscore"]+= [[level.getVars]]("scr_hold_points");;
        setTeamScore("axis", game["axisscore"]);
    }
    self.armed = 0;
    self thread maps\mp\uox\_uox_utils::notifyLater("hold_bonus",[[level.getVars]]("scr_hold_timer"), self);
    self thread Hold_CappedFlag();

}

// ----------------------------------------------------------------------------------
//	Flag_AllCapturedThink
//
// 	Continually checks to see if all of the flags have been captured.
// ----------------------------------------------------------------------------------
Flag_AllCapturedThink()
{

    if(![[level.getVars]]("scr_domination_endround")) 
        return;

    flag_count_allied = 0;
    flag_count_axis = 0;
    for(q=0;q<level.flags.size;q++)
    {
        flag = level.flags[q];
        
        if(flag.team == "allies" && !flag.beingcapped)
        {
            flag_count_allied++;
        }
        else if(flag.team == "axis" && !flag.beingcapped)
        {
            flag_count_axis++;
        }
    }

    if(flag_count_allied == (level.flagcount - 1))
    {
        thread endRound("allies");
        
        // give the allies points
        game["alliedscore"] += [[level.getVars]]("scr_domination_points");
        setTeamScore("allies", game["alliedscore"]);
        
        return;
    }
    if(flag_count_axis == (level.flagcount - 1))
    {
        thread endRound("axis");

        // give the axis points
        game["axisscore"] += [[level.getVars]]("scr_domination_points");
        setTeamScore("axis", game["axisscore"]);
        return;
    }
}

// ----------------------------------------------------------------------------------
//	GivePointsToCappers
//
// 		Gives points to everyone in the flag zone at the end of the cap1
// ----------------------------------------------------------------------------------
GivePointsToCappers( team )
{
	players = getentarray("player", "classname");
	
	// give points to everyone in the cap area
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		if(isAlive(player) && player.pers["team"] == team && player istouching(self))
		{
			player.pers["score"] += [[level.getVars]]("scr_capturebonus");		
			player.score = player.pers["score"];

			lpselfnum = player getEntityNumber();
			lpselfguid = player getGuid();
			logPrint("A;" + lpselfguid + ";" + lpselfnum + ";" + player.pers["team"] + ";" + player.name + ";" + "dom_captured" + "\n");
		}
	}
}

// ----------------------------------------------------------------------------------
//	GetCappers
//
// 		Makes a string of everyone who is in the cap area
// ----------------------------------------------------------------------------------
GetCappers( team )
{
	players = getentarray("player", "classname");
	
	names = [];
	
	// give points to everyone in the cap area
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		if(isAlive(player) && player.pers["team"] == team && player istouching(self))
		{
			names[names.size] = player;
		}
	}
	return names;
}

// ----------------------------------------------------------------------------------
//	PrintCappedMessage
//
// 		Prints out a capped message for a variable amount of cappers
// ----------------------------------------------------------------------------------
PrintCappedMessage( text, flag, cappers )
{
	size = cappers.size;
	if ( size >= 7 )
		iprintln(text,flag,"^7 ",cappers[0],"^7, ",cappers[1],"^7, ",cappers[2],"^7, ",cappers[3],"^7, ",cappers[4],", "^7,cappers[5],"^7, ",cappers[6]);
	else if ( size == 6 )
		iprintln(text,flag,"^7 ",cappers[0],"^7, ",cappers[1],"^7, ",cappers[2],"^7, ",cappers[3],"^7, ",cappers[4],", "^7,cappers[5]);
	else if ( size == 5 )
		iprintln(text,flag,"^7 ",cappers[0],"^7, ",cappers[1],"^7, ",cappers[2],"^7, ",cappers[3],"^7, ",cappers[4]);
	else if ( size == 4 )
		iprintln(text,flag,"^7 ",cappers[0],"^7, ",cappers[1],"^7, ",cappers[2],"^7, ",cappers[3]);
	else if ( size == 3 )
		iprintln(text,flag,"^7 ",cappers[0],"^7, ",cappers[1],"^7, ",cappers[2]);
	else if ( size == 2 )
		iprintln(text,flag,"^7 ",cappers[0],"^7, ",cappers[1]);
	else if ( size == 1 )
		iprintln(text,flag,"^7 ",cappers[0]);
}
