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
    precacheShader("gfx/hud/ctf_stance_crouch.dds");
    precacheShader("gfx/hud/ctf_stance_stand.dds");
    precacheShader("gfx/hud/ctf_stance_prone.dds");
    precacheShader("gfx/hud/ctf_stance_sprint.dds");

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


    maps\mp\uox\_uox_vars::varDef("scr", "showoncompass", "bool", true, true, "", "", "Show Flag Carrier on Compass");
    level.PositionUpdateTime = maps\mp\uox\_uox_vars::varDef("scr", "positionTime", "int", true, 6, 1, 60, "Seconds Per Compass Update")
    maps\mp\uox\_uox_vars::varDef("scr", "showicons", "int", true, 1, 0, 3, "Show Flag HUD Icons");
    maps\mp\uox_uox_vars::varDef("scr", "defensebonus", "int", true, 0, 0, 10, "Flag Defended Bonus");
    maps\mp\uox_uox_vars::varDef("scr", "assistbonus", "int", true, 0, 0, 10, "Flag Assist Bonus");
    maps\mp\uox_uox_vars::varDef("scr", "capturebonus", "int", true, 5, 0, 10, "Flag Capture Bonus");
    maps\mp\uox_uox_vars::varDef("scr", "pickupbonus", "int", true, 0, 0, 10, "Flag Pickup Bonus");
    maps\mp\uox_uox_vars::varDef("scr", "returnbonus", "int", true, 0, 0, 10, "Flag Returned Bonus");


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
	level.axis_flag.mobile_model SetContents(0);

	if ( !isDefined(level.axis_flag.mobile_model) )
	{
		maps\mp\_utility::error("NO ALLIED MOBILE FLAG IN MAP");
		return;
	}

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
        case 1:
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
                    options["alpha"] = 1;
            }
            level.allies_flag.icon1 = maps\mp\uox\_uox_hud::updateHUDElement(level.allies_flag.icon1, "shader", game["hud_allies_flag"], options);
            options["x"] = 382;
            switch(reason)
            {
                default:
                    options["alpha"] = 1;
            }
            level.axis_flag.icon1 = maps\mp\uox\_uox_hud::updateHUDElement(level.axis_flag.icon1, "shader", game["hud_axis_flag"], options);
            //delete small icons
            level.allies_flag.icon2 = maps\mp\uox\_uox_hud::deleteHUDElement(level.allies_flag.icon2);
            level.axis_flag.icon2 = maps\mp\uox\_uox_hud::deleteHUDElement(level.axis_flag.icon2);
            break;
        case 2:
            //create/update small icons
            options = [];
        	options["x"] = 100;
        	options["y"] = 250;
        	options["alignX"] = "left";
        	options["alignY"] = "middle";
            switch(reason)
            {
                case "init":
                    options["alpha"] = 1;
                    options["width"] = 36;
                    options["height"] = 36;
            }
            level.allies_flag.icon2 = maps\mp\uox\_uox_hud::updateHUDElement(level.allies_flag.icon2, "shader", game["hud_flagicon_home"], options);
            options["y"] = 270;
            switch(reason)
            {
                case "init":
                    options["alpha"] = 1;
                    options["width"] = 36;
                    options["height"] = 36;
            }
            level.axis_flag.icon2 = maps\mp\uox\_uox_hud::updateHUDElement(level.axis_flag.icon2, "shader", game["hud_flagicon_home"], options);
            //delete big icons
            level.allies_flag.icon1 = maps\mp\uox\_uox_hud::deleteHUDElement(level.allies_flag.icon1);
            level.axis_flag.icon1 = maps\mp\uox\_uox_hud::deleteHUDElement(level.axis_flag.icon1);
            break;
        case 3:
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
                    options["alpha"] = 1;
            }
            level.allies_flag.icon1 = maps\mp\uox\_uox_hud::updateHUDElement(level.allies_flag.icon1, "shader", game["hud_allies_flag"], options);
            options["x"] = 382;
            switch(reason)
            {
                case "init":
                    options["alpha"] = 1;
            }
            level.axis_flag.icon1 = maps\mp\uox\_uox_hud::updateHUDElement(level.axis_flag.icon1, "shader", game["hud_axis_flag"], options);
            options = [];
        	options["x"] = 100;
        	options["y"] = 250;
        	options["alignX"] = "left";
        	options["alignY"] = "middle";
            switch(reason)
            {
                case "init":
                    options["alpha"] = 1;
                    options["width"] = 36;
                    options["height"] = 36;
            }
            level.allies_flag.icon2 = maps\mp\uox\_uox_hud::updateHUDElement(level.allies_flag.icon2, "shader", game["hud_flagicon_home"], options);
            options["y"] = 270;
            switch(reason)
            {
                case "init":
                    options["alpha"] = 1;
                    options["width"] = 36;
                    options["height"] = 36;
            }
            level.axis_flag.icon2 = maps\mp\uox\_uox_hud::updateHUDElement(level.axis_flag.icon2, "shader", game["hud_flagicon_home"], options);
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
			
			self.goal = (targeted[i]);
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
	
    self maps\mp\uox\_uox_loops::addToLoop(self, "medium", ::ctf_think, "ctf_think");
	
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

ctf_think() //each flag model runs this to find it's trigger and goal
{
    if(level.roundended || self.timeout)
    {
        self.timeout = false;
        self maps\mp\uox\_uox_loops::removeFromLoop(self, "ctf_think");
        return;
    }

	level endon("round_ended");
	self endon("timeout");

		if ( self.moved )
			self.mobile_trigger waittill ("trigger", other);
		else
			self.trigger waittill ("trigger", other);
		
		if(!game["matchstarted"]  )
			return;

		// do not allow people in vehicles to touch flag
		if (other isinvehicle())
			continue;
			
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
				level.allies_flag.icon setShader(game["hud_allies_flag_taken"], game["flag_icons_w"], game["flag_icons_h"]);
			}
			else
			{
				level.axis_flag.icon setShader(game["hud_axis_flag_taken"], game["flag_icons_w"], game["flag_icons_h"]);
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

// ----------------------------------------------------------------------------------
//	GameRoundThink
//
// 	This checks for possible end round conditions.  Also displays round messages.
// ----------------------------------------------------------------------------------
GameRoundThink()
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
			
		// check to see if we hit the score limit
		scorelimit = getCvarint("scr_ctf_scorelimit");
		if(level.scorelimit != scorelimit)
		{
			level.scorelimit = scorelimit;

			if(game["matchstarted"])
				thread checkScoreLimit();
		}

		// end the round if there are not enough people playing
		if (game["matchstarted"] == true && level.roundstarted == true)
		{
			debug = getCvarint("scr_debug_ctf");
			
			players_on_allies = 0;
			players_on_axis = 0;
			
			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
			{
				player = players[i];
				
				switch(player.pers["team"])
				{
					case "allies":
					{
						players_on_allies++;
						break;
					}
					case "axis":
					{
						players_on_axis++;
						break;
					}
				}
				
				// if we are in debug mode and we have found one person on a team then we are good
				if ( debug && (players_on_allies || players_on_axis) )
				{
					players_on_allies = 1;
					players_on_axis = 1;
					break;
				}			
		
				// if there is at least one player on each team then we are good.
				if (players_on_allies && players_on_axis )
				{
					break;
				}
			}
			
			// if one of these is zero then we only have one team
			if ( !players_on_allies || !players_on_axis )
			{
				updateTeamStatus();
			}
		}
			
		wait 0.5;
	}
}

onPlayerKill(victim, attacker)
{
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
