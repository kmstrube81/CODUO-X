UOX_Main() // Starts when map is loaded.
{
    level.getVars = maps\mp\uox\_uox_vars::getVars;

    level.respawn_mode = maps\mp\uox\_uox_vars::varDef("scr", "respawn_mode", "string", false, "spawndelay", "", "", "Respawn Mode");
	maps\mp\uox\_uox_vars::varDef("scr", "spawn_type", "string", false,
											"near_team", "", "", "Respawn Type");
	maps\mp\uox\_uox_vars::varDef("scr", "spawnpoints", "string", false, "uo", "", "", "Spawnpoints");
	maps\mp\uox\_uox_vars::varDef("scr", "reinforcements", "int", false, -1, -1, 999, "Reinforcements");

    /* init spawns */
	if(!maps\mp\uox\_uox_respawns::initSpawns("ctf"))
	{
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		return;
	}

    level.callbackStartGameType = maps\mp\uox\_uox_callbacks::Callback_StartGameType;
	level.callbackPlayerConnect = maps\mp\uox\_uox_callbacks::Callback_PlayerConnect;
	level.callbackPlayerDisconnect = maps\mp\uox\_uox_callbacks::Callback_PlayerDisconnect;
	level.callbackPlayerDamage = maps\mp\uox\_uox_callbacks::Callback_PlayerDamage;
	level.callbackPlayerKilled = maps\mp\uox\_uox_callbacks::Callback_PlayerKilled;

	maps\mp\gametypes\_callbacksetup::SetupCallbacks();

	allowed[0] = "ctf";

    maps\mp\gametypes\_gameobjects::main(allowed);
	maps\mp\gametypes\_secondary_gmi::Initialize();
    level.objective = "ctf";

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
	
	self thread flag_carrier_atgoal_wait(player);
}

flag_carrier_atgoal_wait(player)
{
	level endon("round_ended");
	self endon("dropped");
	while(1)
	{
		self.goal waittill("trigger", other);

		if ( other isinvehicle() )
			continue;
			
		if((other == player) && (isPlayer(player)))
		{
			// make sure the other flag is there
			if ( self.team == "axis" && level.allies_flag.moved )
				continue;
			if ( self.team == "allies" && level.axis_flag.moved )
				continue;
				
			self notify("completed");
			other notify("dropped");

			// get rid of the flag model off the player
			if (player.has_attached == true)
			{
				player.has_attached = false;
				player detach(self.holding_flag,level.held_tag_flag);	
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
			
			// give the team points
			GivePointsToTeam( player.pers["team"],  maps\mp\gametypes\_scoring_gmi::GetPoints( 5, 5));

			// give out points to the capper
			if(isValidPlayer(player))
			{
				player.pers["score"] += maps\mp\gametypes\_scoring_gmi::GetPoints( 8, 8 );
				player.score = player.pers["score"];
			}
			
			if ( self.team == "axis" )
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
						
				other_flag.returned_by.pers["score"] += maps\mp\gametypes\_scoring_gmi::GetPoints( 3, 3);
				other_flag.returned_by = other_flag.returned_by.pers["score"];
			}
			
			self.returned_by = undefined;
			
			num = (16 - (self.hudnum));
			
			// remove the carrying flag message from the player
			if((isdefined(player.hudelem)) && (isdefined(player.hudelem[num])))
				player.hudelem[num] destroy();
				
			//move flag to its base position
			self reset_flag();
		
			// clean up the player
			if(isPlayer(player))
			{
				player.hasflag = undefined;
				player setPlayerIcons();
			}
						
			self thread ctf_think();
		
			// check the score to see if we need to end the round
			thread checkScoreLimit();
			return;
		}
		else
		{
			wait .05;
		}
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
		level.allies_flag.icon setShader(game["hud_allies_flag"], game["flag_icons_w"], game["flag_icons_h"]);
	}
	else
	{
		objective_icon(self.hudnum,game["hud_axis_base_with_flag"] + ".dds");
		level.axis_flag.icon setShader(game["hud_axis_flag"], game["flag_icons_w"], game["flag_icons_h"]);
	}
	
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

	if(isPlayer(player))
	{
		num = (16 - (self.hudnum));
		
		if((isdefined(player.hudelem)) && (isdefined(player.hudelem[num])))
			player.hudelem[num] destroy();
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
		player setPlayerIcons();
	}

	for(i = 1; i < 16; i++)
	{
		if((isdefined(self.hudelem)) && (isdefined(self.hudelem[i])))
			self.hudelem[i] destroy();
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
			iprintln(&"GMI_CTF_ALLIES_FLAG_DROPPED");
		else
			iprintln(&"GMI_CTF_AXIS_FLAG_DROPPED");
	}

	self notify("dropped");
	self thread ctf_think();
}

flag_timeout()
{
	self endon("picked up");
	self endon("reset");
	flag_timeout = 20;
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
	self thread ctf_think();
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

update_objective()
{
	self endon("completed");
	self endon("reset");
	count1 = 1;
	
	// 0 is off, 1 is immediatly, greater then 1 is the position will be shown after that time in secs goes by
	show_time = level.showoncompass;
	
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

display_holding_flag(flag_ent)
{
	num = (16 - (flag_ent.hudnum));

	if(num > 16)
		return;
	
	offset = (150 + (flag_ent.hudnum * 15));
	
	self.hudelem[num] = newClientHudElem(self);
	self.hudelem[num].alignX = "right";
	self.hudelem[num].alignY = "middle";
	self.hudelem[num].x = 635;
	self.hudelem[num].y = (550 - offset);

	if ( self.sessionteam == "axis" )
	{
		self.hudelem[num] setText(&"GMI_CTF_U_R_CARRYING_AXIS");
	}
	else
	{
		self.hudelem[num] setText(&"GMI_CTF_U_R_CARRYING_ALLIES");		
	}

	self.stance_flag = newClientHudElem(self);
	self.stance_flag.alignX = "left";
	self.stance_flag.alignY = "top";
	self.stance_flag.x = 100;
	self.stance_flag.y = 434.375;
	self.color = (1,1,1);
	while(isDefined(self.hasflag))
	{
		x = self getstance();
		switch(x)
		{
			case	"sprint":	sName = "gfx/hud/ctf_stance_sprint.dds";
						break;
			case	"stand":	sName = "gfx/hud/ctf_stance_stand.dds";
						break;
			case	"crouch":	sName = "gfx/hud/ctf_stance_crouch.dds";
						break;
			case	"prone":	sName = "gfx/hud/ctf_stance_prone.dds";
						break;
		}

		
		if (self isinvehicle())
		{
			self.stance_flag.x = -64;
			self.stance_flag.y = -64;
		}
		else
		{
			self.stance_flag.x = 100;
			self.stance_flag.y = 434.375;
			self.stance_flag setShader(sName,40,40);
		}
		wait(0.5);
	}
	self.stance_flag destroy();

}



client_print(flag, text, s)
{
	num = (16 - flag.hudnum);

	if(num > 16)
		return;

	self notify("stop client print");
	self endon("stop client print");

	//if((isdefined(self.hudelem)) && (isdefined(self.hudelem[num])))
	//	self.hudelem[num] destroy();
	
	for(i = 1; i < 16; i++)
	{
		if((isdefined(self.hudelem)) && (isdefined(self.hudelem[i])))
			self.hudelem[i] destroy();
	}
	
	self.hudelem[num] = newClientHudElem(self);
	self.hudelem[num].alignX = "center";
	self.hudelem[num].alignY = "middle";
	self.hudelem[num].x = 320;
	self.hudelem[num].y = 200;

	if(isdefined(s))
	{
		self.hudelem[num].label = text;
		self.hudelem[num] setText(s);
	}
	else
		self.hudelem[num] setText(text);

	wait 3;
	
	if((isdefined(self.hudelem)) && (isdefined(self.hudelem[num])))
		self.hudelem[num] destroy();
}


