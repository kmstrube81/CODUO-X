precache()
{
	precacheString(&"RE_U_R_CARRYING");
	precacheString(&"RE_U_R_CARRYING_GENERIC");
	precacheString(&"RE_PICKUP_AXIS_ONLY_GENERIC");
	precacheString(&"RE_PICKUP_AXIS_ONLY");
	precacheString(&"RE_PICKUP_ALLIES_ONLY_GENERIC");
	precacheString(&"RE_PICKUP_ALLIES_ONLY");
	precacheString(&"RE_OBJ_PICKED_UP_GENERIC");
	precacheString(&"RE_OBJ_PICKED_UP_GENERIC_NOSTARS");
	precacheString(&"RE_OBJ_PICKED_UP");
	precacheString(&"RE_OBJ_PICKED_UP_NOSTARS");
	precacheString(&"RE_PRESS_TO_PICKUP");
	precacheString(&"RE_PRESS_TO_PICKUP_GENERIC");
	precacheString(&"RE_OBJ_TIMEOUT_RETURNING");
	precacheString(&"RE_OBJ_DROPPED");
	precacheString(&"RE_OBJ_DROPPED_DEFAULT");
	precacheString(&"RE_OBJ_INMINES_MULTIPLE");
	precacheString(&"RE_OBJ_INMINES_GENERIC");
	precacheString(&"RE_OBJ_INMINES");
	precacheString(&"RE_ATTACKERS_OBJ_TEXT_GENERIC");
	precacheString(&"RE_DEFENDERS_OBJ_TEXT_GENERIC");
	precacheString(&"RE_ROUND_DRAW");
	precacheString(&"RE_MATCHSTARTING");
	precacheString(&"RE_MATCHRESUMING");
	precacheString(&"RE_TIMEEXPIRED");
	precacheString(&"RE_ELIMINATED_ALLIES");
	precacheString(&"RE_ELIMINATED_AXIS");
	precacheString(&"RE_OBJ_CAPTURED_GENERIC");
	precacheString(&"RE_OBJ_CAPTURED_ALL");
	precacheString(&"RE_OBJ_CAPTURED");
	precacheString(&"RE_RETRIEVAL");
	precacheString(&"RE_ALLIES");
	precacheString(&"RE_AXIS");
	precacheString(&"RE_OBJ_ARTILLERY_MAP");
	precacheString(&"RE_OBJ_PATROL_LOGS");
	precacheString(&"RE_OBJ_CODE_BOOK");
	precacheString(&"RE_OBJ_FIELD_RADIO");
	precacheString(&"RE_OBJ_SPY_RECORDS");
	precacheString(&"RE_OBJ_ROCKET_SCHEDULE");
	precacheString(&"RE_OBJ_CAMP_RECORDS");
	game["headicon_carrier"] = "gfx/hud/headicon@re_objcarrier.dds";
	precacheHeadIcon(game["headicon_carrier"]);
	precacheStatusIcon(game["headicon_carrier"]);
}

initVars()
{
	maps\mp\uox\_uox_vars::varDef("scr", "showcarrier", "bool", true, false,
		undefined, undefined, "Show Objective Carrier");
	maps\mp\uox\_uox_vars::varDef("scr", "objpickupbonuspoints", "int", true,
		0, 0, 10, "Objective Pickup Bonus Points");
	maps\mp\uox\_uox_vars::varDef("scr", "objscorebonuspoints", "int", true,
		0, 0, 10, "Objective Score Bonus Points");
	maps\mp\uox\_uox_vars::varDef("scr", "objcarrierkillbonuspoints", "int", true,
		0, 0, 10, "Carrier Kill Bonus Points");
		
	if(!isdefined(game["re_attackers_obj_text"]))
		game["re_attackers_obj_text"] = (&"RE_ATTACKERS_OBJ_TEXT_GENERIC");
	if(!isdefined(game["re_defenders_obj_text"]))
		game["re_defenders_obj_text"] = (&"RE_DEFENDERS_OBJ_TEXT_GENERIC");
	
	//get the minefields
	level.minefield = getentarray("minefield", "targetname");
	if (!isdefined (level.minefield))
		level.minefield = [];
	hurtTrigs = getentarray("trigger_hurt","classname");
	for (i=0;i<hurtTrigs.size;i++)
		level.minefield[level.minefield.size] = hurtTrigs[i];
	
	level.numobjectives = 0;
	level.objectives_done = 0;
	level.hudcount = 0;	
}


retrieval()
{
	level.retrieval_objective = getentarray("retrieval_objective", "targetname");
	level.defense_points = level.retrieval_objective.size;
	for(i = 0; i < level.retrieval_objective.size; i++)
	{
		level.retrieval_objective[i] thread maps\mp\uox\_uox_loops::initEntityLoop();
		level.retrieval_objective[i] thread retrieval_spawn_objective();
		level.retrieval_objective[i] thread objective_think("objective");
	}
}

updateCarrier()
{
		self maps\mp\uox\_uox_loops::addToWaitTills(self, "picked up", ::updateCarrierObjectivePickup);
		self maps\mp\uox\_uox_loops::addToWaitTills(self, "dropped", ::updateCarrierObjectiveDrop);
}

updateCarrierObjectivePickup()
{
	objective_team(self.objnum, game["re_attackers"]);
}

updateCarrierObjectiveDrop()
{
	objective_team(self.objnum, "none");
}

objective_think(type)
{
	level.numobjectives = (level.numobjectives + 1);
	num = level.numobjectives;

	objective_add(num, "current", self.origin, "gfx/hud/objective.tga");
	self.objnum = (num);

	if(type == "objective")
	{
		level.hudcount++;
		self.hudnum = level.hudcount;
		objective_position(num, self.origin);
		if(![[level.getVars]]("scr_showcarrier"))
		thread updateCarrier();
	}
	else if(type == "goal")
	{
		objective_icon(num, "gfx/hud/hud@objectivegoal.tga");
	}
}

retrieval_spawn_objective()
{
	targeted = getentarray(self.target, "targetname");
	for(i=0;i<targeted.size;i++)
	{
		if(targeted[i].classname == "mp_retrieval_objective")
			spawnloc = maps\MP\_utility::add_to_array(spawnloc, targeted[i]);
		else
		if(targeted[i].classname == "trigger_use")
			self.trigger = (targeted[i]);
		else
		if(targeted[i].classname == "trigger_multiple")
		{
			self.goal = (targeted[i]);
			self.goal thread objective_think("goal");
		}
	}

	if((!isdefined(spawnloc)) || (spawnloc.size < 1))
	{
		maps\mp\_utility::error("retrieval_objective does not target any mp_retrieval_objectives");
		return;
	}
	if(!isdefined(self.trigger))
	{
		maps\mp\_utility::error("retrieval_objective does not target a trigger_use");
		return;
	}
	if(!isdefined(self.goal))
	{
		maps\mp\_utility::error("retrieval_objective trigger_use does not target a trigger_multiple");
		return;
	}

	//move objective to random spot
	rand = randomint(spawnloc.size);
	if(spawnloc.size > 2)
	{
		if(isdefined(game["last_objective_pos"]))
		while(rand == game["last_objective_pos"])
			rand = randomint(spawnloc.size);
		game["last_objective_pos"] = rand;
	}
	self.origin = (spawnloc[rand].origin);
	self.startorigin = self.origin;
	self.startangles = self.angles;
	self.trigger.origin = (spawnloc[rand].origin);
	self.trigger.startorigin = self.trigger.origin;
	
	self thread retrieval_think();
	
	//Set hintstring on the objectives trigger
	wait 0;//required for level script to run and load the level.obj array
	if((isdefined(self.script_objective_name)) && (isdefined(level.obj[self.script_objective_name])))
		self.trigger setHintString(&"RE_PRESS_TO_PICKUP", level.obj[self.script_objective_name]);
	else
		self.trigger setHintString(&"RE_PRESS_TO_PICKUP_GENERIC");
}

retrieval_think() //each objective model runs this to find it's trigger and goal
{
	if(isdefined(self.objnum))
		objective_position(self.objnum, self.origin);

	for(;;)
	{
		self.trigger waittill ("trigger", other);
		
		if(!game["matchstarted"] || level.roundended || level.mapended)
			return;

		if((isPlayer(other)) && (other.pers["team"] == game["re_attackers"]))
		{
			if((isdefined(self.script_objective_name)) && (isdefined(level.obj[self.script_objective_name])))
			{
				if(![[level.getVars]]("scr_showcarrier"))
					announcement(&"RE_OBJ_PICKED_UP_NOSTARS", level.obj[self.script_objective_name]);
				else
				announcement(&"RE_OBJ_PICKED_UP", level.obj[self.script_objective_name]);
			}
			else
			{
				if(![[level.getVars]]("scr_showcarrier"))
					announcement(&"RE_OBJ_PICKED_UP_GENERIC_NOSTARS");
				else
					announcement(&"RE_OBJ_PICKED_UP_GENERIC");
			}
			self playsound ("re_pickup_paper");
			self thread hold_objective(other);
			other.hasobj[self.objnum] = self;
			//println("SETTING HASOBJ[" + self.objnum + "] as the " + self.script_objective_name);
			other.objs_held++;
			/*
			println("PUTTING OBJECTIVE " + self.objnum + " ON THE PLAYER ENTITY");
			objective_onEntity(self.objnum, other);
			*/
			other thread display_holding_obj(self);
			return;

		}
		else if((isPlayer(other)) && (other.pers["team"] == game["re_defenders"]))
		{
			if((isdefined(self.script_objective_name)) && (isdefined(level.obj[self.script_objective_name])))
			{
				if(game["re_attackers"] == "allies")
					other thread client_print(self, &"RE_PICKUP_ALLIES_ONLY", level.obj[self.script_objective_name]);
				else if(game["re_attackers"] == "axis")
					other thread client_print(self, &"RE_PICKUP_AXIS_ONLY", level.obj[self.script_objective_name]);
			}
			else
			{
				if(game["re_attackers"] == "allies")
					other thread client_print(self, &"RE_PICKUP_ALLIES_ONLY_GENERIC");
				else if(game["re_attackers"] == "axis")
					other thread client_print(self, &"RE_PICKUP_AXIS_ONLY_GENERIC");
			}
		}
		else
			wait(.5);
	}
}

dropping(trigger)
{
	if(self useButtonPressed() && (isAlive(self)))
		return true;
	return false;
}

hold_objective(player) //the objective model runs this to be held by 'player'
{
	self endon("completed");
	self endon("dropped");
	team = player.sessionteam;
	self hide();
	
	lpselfnum = player getEntityNumber();
	lpselfguid = player getGuid();
	logPrint("A;" + lpselfguid + ";" + lpselfnum + ";" + game["re_attackers"] + ";" + player.name + ";" + "re_pickup" + "\n");
	
	if(player.pers["team"] == game["re_attackers"])

	self.trigger triggerOff();
	player playLocalSound("re_pickup_paper");
	self notify("picked up");

	//println("PUTTING OBJECTIVE " + self.objnum + " ON THE PLAYER ENTITY");
	player.statusicon = game["headicon_carrier"];
	objective_onEntity(self.objnum, player);

	self thread objective_carrier_atgoal_wait(player);
	player thread maps\mp\uox\_uox_inputs::addHoldUse("picked up", .3, 2, ::dropping, ::drop_objective, undefined, true, true, false, self );

	if ( level.battlerank )
	{
		if (!isdefined( self.pickup_count ) || self.pickup_count == 0)
		{
			player.pers["score"] += [[level.getVars]]("scr_objpickupbonuspoints");
			player.score = player.pers["score"];
		}
		if (!isdefined( self.pickup_count ))
			self.pickup_count = 0;
		self.pickup_count++;
	}
	
	player.headicon = game["headicon_carrier"];
	if(![[level.getVars]]("scr_showcarrier"))
		player.headiconteam = game["re_attackers"];
	else
		player.headiconteam = "none";
}

objective_carrier_atgoal_wait(player)
{
	self endon("dropped");
	for(;;)
	{
		self.goal waittill("trigger", other);
		if((other == player) && (isPlayer(player)) && (player.pers["team"] == game["re_attackers"]))
		{
			if ( level.battlerank )
			{
				player.pers["score"] += [[level.getVars]]("scr_objscorebonuspoints");
				player.score = player.pers["score"];
			}
			level.objectives_done++;
			level.defense_points--;

			objective_delete(self.objnum);
			self notify("completed");

			//org = (player.origin);
			player thread drop_objective_at_goal(self);
			//remove drop addhold
			player maps\mp\uox\_uox_inputs::removeHoldUse("picked up");

			objective_delete(self.objnum);

			self delete();

			if(level.objectives_done < level.retrieval_objective.size)
			{
				return;
			}
			else
			{
				announcement(&"RE_OBJ_CAPTURED_ALL");
				level thread maps\mp\uox\_uox::endRound(game["re_attackers"]);
				return;
			}
		}
		else
		{
			wait .05;
		}
	}
}

drop_objective(trigger)
{
	if(isPlayer(self))
	{
		num = (16 - (trigger.hudnum));
		//self drop_all();
		maps\mp\uox\_uox_inputs::removeHoldUse("picked up");
		self maps\mp\uox\_uox_hud::deleteClientHUDElement("re" + num);
	}

	//if(isdefined(loc))
	loc = (self.origin + (0, 0, 25));

	//CHAD
	plant = self maps\mp\_utility::getPlant();
	end_loc = plant.origin;
	
	if(distance(loc, end_loc) > 0)
	{
		trigger.origin = loc;
		trigger.angles = plant.angles;
		trigger show();
		speed = (distance(loc, end_loc) / 250);
		if(speed > 0.4)
		{
			trigger moveto(end_loc, speed, 0.1, 0.1);
			trigger waittill("movedone");
			trigger.trigger.origin = end_loc;
		}
		else
		{
			trigger.origin = end_loc;
			trigger.angles = plant.angles;
			trigger show();
			trigger.trigger.origin = end_loc;
		}
	}
	else
	{
		trigger.origin = end_loc;
		trigger.angles = plant.angles;
		trigger show();
		trigger.trigger.origin = end_loc;
	}

	//check if it's in a minefield
	In_Mines = 0;
	for(i = 0; i < level.minefield.size; i++)
	{
		if(trigger istouching(level.minefield[i]))
		{
			In_Mines = 1;
			break;
		}
	}

	if(In_Mines == 1)
	{
		if(self.objs_held > 1)
		{	//IF A PLAYER HOLDS 2 OR MORE OBJECTIVES AND DROPS ONLY ONE INTO THE MINEFIELD
			//THEN THIS WILL STILL SAY "MULTIPLE OBJECTIVES..." BUT A PLAYER SHOULD NEVER
			//BE ABOVE A MINEFIELD IN ONE OF THE SHIPPED MAPS SO I'LL LEAVE IT FOR NOW
			if((!isdefined(level.lastdropper)) || (level.lastdropper != self))
			{
				level.lastdropper = self;
				announcement(&"RE_OBJ_INMINES_MULTIPLE");
			}
		}
		else
		{
			if((!isdefined(level.lastdropper)) || (level.lastdropper != self))
			{
				level.lastdropper = self;
				if((isdefined(trigger.script_objective_name)) && (isdefined(level.obj[trigger.script_objective_name])))
					announcement(&"RE_OBJ_INMINES", level.obj[trigger.script_objective_name]);
				else
					announcement(&"RE_OBJ_INMINES_GENERIC");
			}
		}
		trigger.trigger.origin = trigger.trigger.startorigin;
		trigger.origin = trigger.startorigin;
		trigger.angles = trigger.startangles;
	}
	else
	{
		if((isdefined(trigger.script_objective_name)) && (isdefined(level.obj[trigger.script_objective_name])))

			announcement(&"RE_OBJ_DROPPED", level.obj[trigger.script_objective_name]);
		else
			announcement(&"RE_OBJ_DROPPED");
	}

	if(isPlayer(self))
	{
		if((isdefined(trigger.objnum)) && (isdefined(self.hasobj[trigger.objnum])))
			self.hasobj[trigger.objnum] = undefined;
		else
			println("#### " + trigger.objnum + "UNDEFINED");
		self.objs_held--;
	}

	if((isPlayer(self)) && (self.objs_held < 1))
	{
		if(level.drawfriend == 1)
		{
			if(isPlayer(self))
			if(self.pers["team"] == "allies")
			{
				self.headicon = game["headicon_allies"];
				self.headiconteam = "allies";
			}
			else if(self.pers["team"] == "axis")
			{
				self.headicon = game["headicon_axis"];
				self.headiconteam = "axis";
			}
			else
			{
				self.statusicon = "";
				self.headicon = "";
			}
		}
		else
		{
			if(isPlayer(self))
			{
				self.statusicon = "";
				self.headicon = "";
			}
		}
	}

	if(trigger istouching(trigger.goal))
	{
		if((isdefined(trigger.script_objective_name)) && (isdefined(level.obj[trigger.script_objective_name])))
			announcement(&"RE_OBJ_CAPTURED", level.obj[trigger.script_objective_name]);
		else
			announcement(&"RE_OBJ_CAPTURED_GENERIC");

		if(isdefined(trigger.trigger))
			trigger.trigger delete();

		if((isPlayer(self)) && (self.objs_held < 1))
		{
			if(level.drawfriend == 1)
			{
				if(isPlayer(self))
				if(self.pers["team"] == "allies")
				{
					self.headicon = game["headicon_allies"];
					self.headiconteam = "allies";
				}
				else if(self.pers["team"] == "axis")
				{
					self.headicon = game["headicon_axis"];
					self.headiconteam = "axis";
				}
				else
				{
					self.statusicon = "";
					self.headicon = "";
				}
			}
			else
			{
				if(isPlayer(self))
				{
					self.statusicon = "";
					self.headicon = "";
				}
			}
		}

		level.objectives_done++;
		level.defense_points--;

		trigger notify("completed");
		level thread clear_player_dropbar(self);
		
		objective_delete(trigger.objnum);
		trigger delete();
		
		self maps\mp\uox\_uox_inputs::removeHoldUse("picked up");

		if(level.objectives_done < level.retrieval_objective.size)
		{
			return;
		}
		else
		{
			announcement(&"RE_OBJ_CAPTURED_ALL");
			level thread maps\mp\uox\_uox::endRound(game["re_attackers"]);
			return;
		}
	}

	trigger thread objective_timeout();
	trigger notify("dropped");
	trigger thread retrieval_think();
}

drop_objective_at_goal(trigger)
{
	if(isPlayer(self))
	{
		num = (16 - (trigger.hudnum));
		//self drop_all();
		maps\mp\uox\_uox_inputs::removeHoldUse("picked up");
		self maps\mp\uox\_uox_hud::deleteClientHUDElement("re" + num);
	}

	//if(isdefined(loc))
	loc = (self.origin + (0, 0, 25));

	self.objs_held--;
	if((isdefined(trigger.objnum)) && (isdefined(self.hasobj[trigger.objnum])))
		self.hasobj[trigger.objnum] = undefined;
	else
		println("#### " + trigger.objnum + "UNDEFINED");

	objective_delete(trigger.objnum);
	
	lpselfnum = self getEntityNumber();
	lpselfguid = self getGuid();
	logPrint("A;" + lpselfguid + ";" + lpselfnum + ";" + game["re_attackers"] + ";" + self.name + ";" + "re_capture" + "\n");
	
	
	if((isdefined(trigger.script_objective_name)) && (isdefined(level.obj[trigger.script_objective_name])))
		announcement(&"RE_OBJ_CAPTURED", level.obj[trigger.script_objective_name]);
	else
		announcement(&"RE_OBJ_CAPTURED_GENERIC");

	if(isdefined(trigger.trigger))
		trigger.trigger delete();

	if((isPlayer(self)) && (self.objs_held < 1))
	{
		if(level.drawfriend == 1)
		{
			if(isPlayer(self))
			if(self.pers["team"] == "allies")
			{
				self.headicon = game["headicon_allies"];
				self.headiconteam = "allies";
			}
			else if(self.pers["team"] == "axis")
			{
				self.headicon = game["headicon_axis"];
				self.headiconteam = "axis";
			}
			else
			{
				self.statusicon = "";
				self.headicon = "";
			}
		}
		else
		{
			if(isPlayer(self))
			{
				self.statusicon = "";
				self.headicon = "";
			}
		}
	}
}


clear_player_dropbar(player)
{
	if(isdefined(player))
	{
		player maps\mp\uox\_uox_hud::deleteClientHUDProgressBar();
		player unlink();
		player.isusing = false;
	}
}

objective_timeout()
{
	self endon("picked up");
	obj_timeout = 60;
	wait obj_timeout;
	announcement(&"RE_OBJ_TIMEOUT_RETURNING", obj_timeout);
	self.trigger.origin = (self.trigger.startorigin);
	self.origin = (self.startorigin);
	self.angles = (self.startangles);
	self.pickup_count = 0;
	objective_position(self.objnum, self.origin);
}

display_holding_obj(obj_ent)
{
	num = (16 - (obj_ent.hudnum));

	if(num > 16)
		return;
	
	offset = (150 + (obj_ent.hudnum * 15));
	
	options = [];
	options["alignX"] = "right";
	options["alignY"] = "middle";
	options["x"] = 635;
	options["y"] = (550 - offset);

	if((isdefined(obj_ent.script_objective_name)) && (isdefined(level.obj[obj_ent.script_objective_name])))
	{
		options["label"] = &"RE_U_R_CARRYING";
		text = level.obj[obj_ent.script_objective_name];
	}
	else
		text = &"RE_U_R_CARRYING_GENERIC";
	self maps\mp\uox\_uox_hud::updateClientHUDElement("re" + num, "text", text, options);
}

triggerOff()
{
	self.origin = (self.origin - (0, 0, 10000));
}

client_print(obj, text, s)
{
	num = (16 - obj.hudnum);

	if(num > 16)
		return;

	self notify("stop client print");
	self endon("stop client print");

	//if((isdefined(self.hudelem)) && (isdefined(self.hudelem[num])))
	//	self.hudelem[num] destroy();
	
	for(i = 1; i < 16; i++)
	{
		self maps\mp\uox\_uox_hud::deleteClientHUDElement("re" + i);
	}
	
	options = [];
	options["alignX"] = "center";
	options["alignY"] = "middle";
	options["x"] = 320;
	options["y"] = 200;

	if(isdefined(s))
	{
		options["label"] = text;
		title = s;
	}
	else
		title = text;
	
	self maps\mp\uox\_uox_hud::updateClientHUDElement("re" + num, "text", title, options);

	wait 3;
	
	self maps\mp\uox\_uox_hud::deleteClientHUDElement("re" + num);
}

drop_all()
{
	if(isdefined(self.objs_held))
	{
		if(self.objs_held > 0)
		{
            for(i = 0; i < (level.numobjectives + 1); i++)
			{
				if(isdefined(self.hasobj[i]))
				{
					self.hasobj[i] thread drop_objective_on_disconnect_or_death(self);
				}
			}
		}
	}
}

drop_objective_on_disconnect_or_death(player)
{
	//CHAD
	/*
	if(isdefined(trace))
	{
		loc = (loc + (0, 0, 25));
		trace = bulletTrace(loc, (loc - (0, 0, 5000)), false, undefined);
		end_loc = trace["position"]; //where the ground under the player is
	}
	else
	{
		println("PLAYER IS ON GROUND - SKIPPING TRACE");
		end_loc = loc;
	}
	*/
	
	plant = player maps\mp\_utility::getPlant();
	end_loc = plant.origin;
	
	if(distance(player.origin, end_loc) > 0)
	{
		self.origin = player.origin;
		self.angles = plant.angles;
		self show();
		speed = (distance(player.origin, end_loc) / 250);
		if(speed > 0.4)
		{
			self moveto(end_loc, speed, 0.1, 0.1);
			self waittill("movedone");
			self.trigger.origin = end_loc;
		}
		else
		{
			self.origin = end_loc;
			self.angles = plant.angles;
			self show();
			self.trigger.origin = end_loc;
		}
	}
	else
	{
		self.origin = end_loc;
		self.angles = plant.angles;
		self show();
		self.trigger.origin = end_loc;
	}

	//check if it's in a minefield
	In_Mines = 0;
	for(i = 0; i < level.minefield.size; i++)
	{
		if(self istouching(level.minefield[i]))
		{
			In_Mines = 1;
			break;
		}
	}

	if(In_Mines == 1)
	{
		if((isdefined(self.script_objective_name)) && (isdefined(level.obj[self.script_objective_name])))
			announcement(&"RE_OBJ_INMINES", level.obj[self.script_objective_name]);
		else
			announcement(&"RE_OBJ_INMINES_GENERIC");

		self.trigger.origin = self.trigger.startorigin;
		self.origin = self.startorigin;
		self.angles = self.startangles;
	}
	else if(self istouching(self.goal))
	{
		if((isdefined(self.script_objective_name)) && (isdefined(level.obj[self.script_objective_name])))
			announcement(&"RE_OBJ_CAPTURED", level.obj[self.script_objective_name]);
		else
			announcement(&"RE_OBJ_CAPTURED_GENERIC");

		if(isdefined(self.trigger))
			self.trigger delete();

		if((isPlayer(player)) && (player.objs_held < 1))
		{
			if(level.drawfriend == 1)
			{
				if(isPlayer(player))
				if(player.pers["team"] == "allies")
				{
					player.headicon = game["headicon_allies"];
					player.headiconteam = "allies";
				}
				else if(player.pers["team"] == "axis")
				{
					player.headicon = game["headicon_axis"];
					player.headiconteam = "axis";
				}
				else
				{
					player.statusicon = "";
					player.headicon = "";
				}
			}
			else
			{
				if(isPlayer(player))
				{
					player.statusicon = "";
					player.headicon = "";
				}
			}
		}

		if ( level.battlerank )
		{
			player.pers["score"] += [[level.getVars]]("scr_objpickupbonuspoints");
			player.score = player.pers["score"];
		}
		level.objectives_done++;
		level.defense_points--;

		self notify("completed");
		level thread clear_player_dropbar(player);
		
		objective_delete(self.objnum);
		self delete();
		
		player maps\mp\uox\_uox_inputs::removeHoldUse("picked up");
		
		level maps\mp\uox\_uox::incrementTeamScore(game["re_attackers"]);

		if(level.objectives_done < level.retrieval_objective.size)
		{
			return;
		}
		else
		{
			wait 0.05; //required to let threads die
			announcement(&"RE_OBJ_CAPTURED_ALL");
			level thread maps\mp\uox\_uox::endRound(game["re_attackers"]);
			return;
		}
	}
	else
	{
		if((isdefined(self.script_objective_name)) && (isdefined(level.obj[self.script_objective_name])))
			announcement(&"RE_OBJ_DROPPED", level.obj[self.script_objective_name]);
		else
			announcement(&"RE_OBJ_DROPPED");
	}

	self thread objective_timeout();
	self notify("dropped");
	self thread retrieval_think();
}

onPlayerKill(victim, attacker)
{
	if(isdefined(victim.objs_held))
	{
        victim maps\mp\uox\_uox_inputs::removeHoldUse("picked up");
		if(victim.objs_held > 0)
		{
			for(i = 0; i < (level.numobjectives + 1); i++)
			{
				if(isdefined(victim.hasobj[i]))
				{
					if ( level.battlerank )
					{
						// give the killer a point per object 
						if (isplayer(attacker))
						{
							attacker.pers["score"] += [[level.getVars]]("scr_objcarrierkillbonuspoints");
							attacker.score = attacker.pers["score"];
						}
					}
					victim.hasobj[i] thread drop_objective_on_disconnect_or_death(victim);
				}
			}
		}
	}
	for(i = 1; i < 16; i++)
	{
		victim maps\mp\uox\_uox_hud::deleteClientHUDElement("re" + i);
	}
}