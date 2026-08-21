precache()
{
	game["radio_prespawn"] = "gfx/hud/hud@objective_bel.tga";
	game["radio_none"] = "gfx/hud/objective.tga";
	game["radio_axis"] = "gfx/hud/hud@objective_german.tga";
	if (game["allies"] == "russian")
		game["radio_allies"] = "gfx/hud/hud@objective_russian.tga";
	else if (game["allies"] == "british")
		game["radio_allies"] = "gfx/hud/hud@objective_british.tga";
	else
		game["radio_allies"] = "gfx/hud/hud@objective_american.tga";

    precacheShader("gfx/hud/hud@field_radio.tga");

	precacheString(&"HQ_REINFORCEMENTS");
    precacheString(&"HQ_REINFORCEMENTS_HUD");
	precacheString(&"HQ_CAPTURNING_RADIO");
	precacheString(&"HQ_DESTROYING_RADIO");
	precacheString(&"HQ_LOSING_RADIO");
	precacheString(&"HQ_PRESS_ACTIVATE_TO_SKIP");
	precacheString(&"HQ_MAXHOLDTIME_ALLIES");
	precacheString(&"HQ_MAXHOLDTIME_AXIS");
    precacheString(&"Radio Timer:");
	precacheShader("gfx/hud/hud@objective_bel.tga");
	precacheShader("gfx/hud/hud@objective_bel_up.tga");
	precacheShader("gfx/hud/hud@objective_bel_down.tga");
	precacheShader("gfx/hud/objective.tga");
	precacheShader("gfx/hud/objective_up.tga");
	precacheShader("gfx/hud/objective_down.tga");
	
	precacheModel("xmodel/objective_german_field_radio_notsolid");
	precacheModel("xmodel/german_field_radio_notsolid");
	precacheHeadIcon(game["radio_allies"]);
	precacheHeadIcon(game["radio_axis"]);
	precacheShader(game["radio_allies"]);
	precacheShader(game["radio_axis"]);
	precacheShader("gfx/hud/hud@objective_german_up.tga");
	precacheShader("gfx/hud/hud@objective_german_down.tga");
	if (game["allies"] == "russian")
	{
		precacheShader("gfx/hud/hud@objective_russian_up.tga");
		precacheShader("gfx/hud/hud@objective_russian_down.tga");
	}
	else if (game["allies"] == "british")
	{
		precacheShader("gfx/hud/hud@objective_british_up.tga");
		precacheShader("gfx/hud/hud@objective_british_down.tga");
	}
	else
	{
		precacheShader("gfx/hud/hud@objective_american_up.tga");
		precacheShader("gfx/hud/hud@objective_american_down.tga");
	}	

}

initVars()
{
	//init gametype vars
    level.zradioradius = 50; // Z Distance players must be from a radio to capture/neutralize it
	level.captured_radios["allies"] = 0;
	level.captured_radios["axis"] = 0;
	

	level.RadioSpawnDelay = 30;
	level.radioradius = 120;
	level.respawngracetime = 5;
	level.RadioMaxHold = 6;
	level.timesCaptured = 0;
	level.nextradio = 0;
	
	level.spawnframe = 0;


	maps\mp\uox\_uox_vars::varDef("scr", "radiocapturetime", "int", true,
		10, 3, 20, "Radio Capture Time");
	maps\mp\uox\_uox_vars::varDef("scr", "radiodestroytime", "int", true,
		10, 3, 20, "Radio Destroy Time");
    maps\mp\uox\_uox_vars::varDef("scr", "radiomaxhold", "int", true,
		6, 1, 10, "Max Radio Holds");

    if(!isDefined(level.wavetime))
        level.wavetime = maps\mp\uox\_uox_vars::varDef("scr", "wavetimer", "int", true,
                                    60, 3, 120, "Wave Timer", maps\mp\uox\_uox_respawns::updateWaveTimer);
		
	/* Radio Capture Bonus Points:
		extra points given to players who capture the radio */
	maps\mp\uox\_uox_vars::varDef("scr", "radiocapturebonuspoints", "int", true,
		0, 0, 10, "Radio Capture Bonus Points");
	/* Radio Destroy Bonus Points:
		extra points given to players who destroy the radio */
	maps\mp\uox\_uox_vars::varDef("scr", "radiodestroybonuspoints", "int", true,
		0, 0, 10, "Radio Destroyed Bonus Points");
    /* Radio Hold Bonus Points:
		extra points given to players who hold the radio */
	maps\mp\uox\_uox_vars::varDef("scr", "radioholdbonuspoints", "int", true,
		0, 0, 10, "Radio Hold Bonus Points");
	
    level.reinforcement_time = level.wavetime;
    
}

/* **************************************************************************************************
**** hq_setup()
****
**** Loads in the headquarters entities, and starts the think thread for them
****
*************************************************************************************************** */
hq_setup()
{
	wait 0.05; // wait a server fram
	
	level.radio = getentarray ("hqradio","targetname"); //load radios to level.radio array

	if ( (!level.radio.size) || (level.radio.size < 3) ) //if map has less than 3 radio spawns then map does not support HQ
	{
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		return;
	}
    
	for (i=0;i<level.radio.size;i++) //walk through array and set up radios
	{
		level.radio[i] setmodel ("xmodel/objective_german_field_radio_notsolid"); //set model
		level.radio[i].team = "none"; //clear team owning it
		level.radio[i].holdtime_allies = 0; //clear hold timer allies
		level.radio[i].holdtime_axis = 0; //clear hold timer axis
		level.radio[i].hidden = true; //mark hidden flag
		level.radio[i] hide(); //hide radio
		
		if ( (!isdefined (level.radio[i].script_radius)) || (level.radio[i].script_radius <= 0) ) //if radio doesn't have a valid preset capture radius
			level.radio[i].radius = level.radioradius; //use default radio radius (120)
		else
			level.radio[i].radius = level.radio[i].script_radius; //else use preset radius

        level.radio[i] thread maps\mp\uox\_uox_loops::initEntityLoop(); //spawn a loop for radio
		
		maps\mp\uox\_uox_loops::addToLoop(level.radio[i], "fast", ::hq_radio_think, "hq_radio_think"); // add think thread to fast (every frame) loop.
	}
	
	level.radio = maps\mp\uox\_uox_arrays::randomizeArray(level.radio); // randomize the radio rotation
	
	level thread hq_obj_think(); //start game logic

    level maps\mp\uox\_uox_respawns::updateWaveTimer(level.wavetime);
    maps\mp\uox\_uox_hud::createWaveTimerHUD(); //create HQ hud
	thread hq_wave_timer(); //start HQ wave timer
}

/* **************************************************************************************************
**** hq_obj_think(ent radio)
****
**** governs game logic for hq gametype
****
*************************************************************************************************** */

hq_obj_think(radio)
{
	NeutralRadios = 0; //set the number of neutral radios to 0
	for ( i=0 ; i<level.radio.size ; i++ ) //walk through radios
	{
		if (level.radio[i].hidden == true) //skip hidden radios
			continue;
		NeutralRadios++; //add number of active radios to neutral radio count
	}
	if (NeutralRadios <= 0) //if there was an active radio
	{
		if (level.nextradio > level.radio.size - 1) //if the next radio is already set and is last radio in the set
		{
			level.radio = maps\mp\uox\_uox_arrays::randomizeArray(level.radio); //re-randomize the radio array
			level.nextradio = 0; //set the next radio to the first in the array
			
			if (isdefined (radio)) //if called from the hq_radio_capture function, this is defined as the radio that was just captured
			{
				// same radio twice in a row so go to the next radio
				if (radio == level.radio[level.nextradio])
					level.nextradio++;
			}
		}
		
		objective_add(0, "current", level.radio[level.nextradio].origin, game["radio_prespawn"]); //add radio location to everyones compass
		
		level maps\mp\uox\_uox::updateTeamStatus(); //check that teams exist before spawning next radio
        level.exist["allies"] = 0; //reset alive allies
        level.exist["axis"] = 0; //reset alive axis
		while ( (!level.exist["allies"]) || (!level.exist["axis"]) )
		{
			wait 2;
			level maps\mp\uox\_uox::updateTeamStatus();
		}
		
		if ( (isdefined (level.wavecounter)) && (level.wavecounter >= 0) ) //if a current objective counter still has time remaining
			wait level.wavecounter; //wait for counter to expire
		else //else if no current objective counter
			wait level.RadioSpawnDelay; //wait the full spawn delay time
		
		level.radio[level.nextradio] show(); //unhide the next objective
		level.radio[level.nextradio].hidden = false;
		
		level hq_playsound_onplayers("explo_plant_no_tick"); //play radio spawn sound
		objective_icon(0, game["radio_none"]); //set the radio icon to none
		
		if ( (level.captured_radios["allies"] <= 0) && (level.captured_radios["axis"] > 0) ) // AXIS HAVE A RADIO AND ALLIES DONT
			objective_team(0, "allies");
		else if ( (level.captured_radios["allies"] > 0) && (level.captured_radios["axis"] <= 0) ) // ALLIES HAVE A RADIO AND AXIS DONT
			objective_team(0, "axis");
		else // NO TEAMS HAVE A RADIO
			objective_team(0, "none");
		
		level.nextradio++; //increment active radio
	}
}

/* **************************************************************************************************
**** hq_radio_think()
****
**** governs individal radio logic for hq gametype
****
*************************************************************************************************** */
hq_radio_think()
{	
	level endon ("intermission"); //kill current thread during game end
	if (level.mapended || level.roundended) //exit subsequent threads during game end
    {
            self maps\mp\uox\_uox_loops::removeFromLoop(self, "fast", "hq_radio_think"); //remove function from loop
            return true;
    }
	
    if (!self.hidden) //if radio is active
    {
        players = getentarray("player", "classname"); //get players
        self.allies = 0; //reset count allies in radius
        self.axis = 0; //reset count axis in radius
        for(i = 0; i < players.size; i++)
        {
            player = players[i];
            if(isdefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing") //if player is playing
            {   //and player is in the capture radius
                if ( !(player isInVehicle()) && ((distance(player.origin,self.origin)) <= self.radius) && (distance((0,0,player.origin[2]),(0,0,self.origin[2])) <= level.zradioradius) )
                {
                    if(player.pers["team"] == self.team) //if radio is already captured by this team
                        continue; //do nothing
                    
                    if ( (level.captured_radios[player.pers["team"]] > 0) && (self.team == "none") ) //if another radio was already captured
                        continue; //do nothing

                    //create radio icon for capturing players
                    iconOptions = [];
                	iconOptions["alignX"] = "center";
                	iconOptions["alignY"] = "middle";
                	iconOptions["x"] = 600;
                	iconOptions["y"] = 390;
                	iconOptions["width"] = 40;
                	iconOptions["height"] = 32;
                    //test if element already exists, don't spam hud updates
        			if(!isDefined(player maps\mp\uox\_uox_hud::getClientHUDElement("radio_icon")))
        				player maps\mp\uox\_uox_hud::updateClientHUDElement("radio_icon", "shader",
        					"gfx/hud/hud@field_radio.tga", iconOptions);
                    
                    if ( (level.captured_radios[player.pers["team"]] <= 0) && (self.team == "none") ) //if no radios are currently captured
                    {
                       if (player.pers["team"] == "allies") //if player in the radius is allies
                            player maps\mp\uox\_uox_hud::createClientHUDProgressBar([[level.getVars]]("scr_radiocapturetime"), &"HQ_CAPTURNING_RADIO", self.holdtime_allies); //create progress bar for allies
                        else //else if he's axis
                            player maps\mp\uox\_uox_hud::createClientHUDProgressBar([[level.getVars]]("scr_radiocapturetime"), &"HQ_CAPTURNING_RADIO", self.holdtime_axis); //create progress bar for axis
                    }
                    else if (self.team != "none") //else if someone has captured the radio
                    {	
                       
                        if (player.pers["team"] == "allies") //if player in the radius is allies
                            player maps\mp\uox\_uox_hud::createClientHUDProgressBar([[level.getVars]]("scr_radiocapturetime"), &"HQ_DESTROYING_RADIO", self.holdtime_allies); //create progress bar for allies
                        else //else if player is axis
                            player maps\mp\uox\_uox_hud::createClientHUDProgressBar([[level.getVars]]("scr_radiocapturetime"), &"HQ_DESTROYING_RADIO", self.holdtime_axis); //create progress bar for axis
                        
                        
                        if (self.team == "allies") //if radio is owned by allies
                        {
                            if (players[i].pers["team"] == "allies") //if player in radius is allies
                                level.progressbar_axis_neutralize = maps\mp\uox\_uox_hud::createTeamHUDProgressBar(
                                    level.progressbar_axis_netralize, "allies", [[level.getVars]]("scr_radiocapturetime"), &"HQ_LOSING_RADIO", self.holdtime_allies); //create a team progress bar for allies
                            else //else if player in radius is axis
                                 level.progressbar_axis_neutralize = maps\mp\uox\_uox_hud::createTeamHUDProgressBar(
                                    level.progressbar_axis_netralize, "axis", [[level.getVars]]("scr_radiocapturetime"), &"HQ_LOSING_RADIO", self.holdtime_axis); //create a team progress bar for axis
                        }
                        else
                        if (self.team == "axis") //if radio is owned by axis
                        {
                            if (players[i].pers["team"] == "allies") //if player in radius is allies
                                level.progressbar_allies_neutralize = maps\mp\uox\_uox_hud::createTeamHUDProgressBar(
                                    level.progressbar_allies_netralize, "allies", [[level.getVars]]("scr_radiocapturetime"), &"HQ_LOSING_RADIO", self.holdtime_allies); //create a team progress bar for allies
                            else //else if player in radius is axis
                                 level.progressbar_allies_neutralize = maps\mp\uox\_uox_hud::createTeamHUDProgressBar(
                                    level.progressbar_allies_netralize, "axis", [[level.getVars]]("scr_radiocapturetime"), &"HQ_LOSING_RADIO", self.holdtime_axis); //create a team progress bar for axis
                        }
                    }
                    
                    if(players[i].pers["team"] == "allies")
                        self.allies++;
                    else
                        self.axis++;
                }
                else 
                {
                    player maps\mp\uox\_uox_hud::deleteClientHUDElement("radio_icon");
                    player maps\mp\uox\_uox_hud::deleteClientHUDProgressBar();
                }
            }
        }
        
        if (self.team == "none") // If radio isn't captured
        {
            if ( (self.allies > 0) && (self.axis <= 0) && (self.team != "allies") ) //if there are allies in the radius and there are no axis and the radio is not captured by allies
            {
                self.holdtime_allies += 0.05; //add to the capture bar.
                if (self.holdtime_allies >= [[level.getVars]]("scr_radiocapturetime")) //if the hold time is greater than the capture time
                {
                    if ( (level.captured_radios["allies"] > 0) && (self.team != "none") ) //if a radio is already captured and this radio is not neutral, (dont see how this is ever true)
                        level hq_radio_capture(self, "none"); //set radio to neutral
                    else if (level.captured_radios["allies"] <= 0) //if no radios have been captured
                        level hq_radio_capture(self, "allies"); //set radio to allies
                }
            }
            else if ( (self.axis > 0) && (self.allies <= 0) && (self.team != "axis") ) //else if axis are on site and there are no allies and radio is not captured by axis
            {
                self.holdtime_axis += 0.05; //add to the capture bar.
                if (self.holdtime_axis >= 250)
                {
                    if ( (level.captured_radios["axis"] > 0) && (self.team != "none") )
                        level hq_radio_capture(self, "none");
                    else if (level.captured_radios["axis"] <= 0)
                        level hq_radio_capture(self, "axis");
                }
            }
            else //reset counters if point is contested 
            {
                self.holdtime_allies = 0;
                self.holdtime_axis = 0;
                
                players = getentarray("player", "classname"); //get players again
                for(i = 0; i < players.size; i++) //walk through players
                {
                    if(isdefined(players[i].pers["team"]) && players[i].pers["team"] != "spectator" && players[i].sessionstate == "playing") //only inclue players that are playing
                    {
                        if ( !(players[i] isInVehicle()) && ((distance(players[i].origin,self.origin)) <= self.radius) && (distance((0,0,players[i].origin[2]),(0,0,self.origin[2])) <= level.zradioradius) )
                        {	//only need to reset players in the capture radious
                            players[i] maps\mp\uox\_uox_hud::deleteClientHUDProgressBar();
                        }
                    }
                }
            }
        }
        else // Radio should go to neutral first
        {
            if ( (self.team == "allies") && (self.axis <= 0) ) //if no axis are in the capture radius of an allied radio
            { //destroy team bar 
                if(isdefined(level.progressbar_axis_neutralize))
                    level.progressbar_axis_neutralize = maps\mp\uox\_uox_hud::deleteTeamHUDProgressBar(level.progressbar_axis_neutralize);
            }
            else if ( (self.team == "axis") && (self.allies <= 0) ) //else if no allies are in the capture radius of an axis radio
            { //destroy team bar
                if(isdefined(level.progressbar_allies_neutralize))
                    level.progressbar_allies_neutralize = maps\mp\uox\_uox_hud::deleteTeamHUDProgressBar(level.progressbar_allies_neutralize);
            }
            
            if ( (self.allies > 0) && (self.team == "axis") ) //if allies are in an axis owned radio radius
            {
                self.holdtime_allies += 0.05; //add to hold timer
                if (self.holdtime_allies >= [[level.getVars]]("scr_radiodestroytime")) //destroy radio if held above destroy time threshold
                    level hq_radio_capture(self, "none");
            }
            else if ( (self.axis > 0) && (self.team == "allies") ) //if axis are in an allied owned radio radius
            {
                self.holdtime_axis += 0.05; //add to hold timer
                if (self.holdtime_axis >= [[level.getVars]]("scr_radiodestroytime")) //destroy radio if held above destroy time threshold
                    level hq_radio_capture(self, "none"); 
            }
            else //if radio is contested or no one home
            { //reset counters
                self.holdtime_allies = 0;
                self.holdtime_axis = 0;
            }
        }
    }
	
}

/* **************************************************************************************************
**** hq_radio_capture(ent radio, string team)
****
**** scores and runs game logic when a team captures or destroys a radio
****
*************************************************************************************************** */
hq_radio_capture(radio, team)
{
	radio.holdtime_allies = 0; //reset the hold timer for allies
	radio.holdtime_axis = 0; //reset the hold timer for axis
	
	players = getentarray("player", "classname"); //get players
	for(i = 0; i < players.size; i++) //walk all players
	{
        player = players[i]; //current players
		if(isdefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing") //if current player is playing
		{ //delete radio icon and capture progress bar
            player maps\mp\uox\_uox_hud::deleteClientHUDElement("radio_icon");
			player maps\mp\uox\_uox_hud::deleteClientHUDProgressBar();
		}
	}
	PointsScored = level.wavecounter; //set the points scored to the amount of time left of the objective timer
	level.wavecounter = level.wavetime; //set counter back to the full wave timer
	
	if (radio.team != "none") //if the radio was not neutral before then destroy it
	{	
		level.captured_radios[radio.team] = 0; //reset the number of captured radios
		level thread hq_playsound_onplayers("hq_explo_radio"); //play the destroyed sound
		playfx(level._effect["radioexplosion"], radio.origin); //blow up the radio
		level.timesCaptured = 0; //reset the capture counter
        level.defenseTeam = "none";
        level notify ("hq_reinforcements");
		// Give points to the team that neutralized it and print some text
		if (radio.team == "allies")
		{
			iprintln (&"HQ_SHUTDOWN_ALLIED_HQ"); //announce the radio was destroyed
			level thread hq_points_players("allies", "lost"); //give allied players some points?
			level thread hq_score_update("axis", PointsScored); //give axis team their points
			//destroy team bar 
            if(isdefined(level.progressbar_axis_neutralize))
                level.progressbar_axis_neutralize = maps\mp\uox\_uox_hud::deleteTeamHUDProgressBar(level.progressbar_axis_neutralize);
		}
		else if (radio.team == "axis")
		{
			iprintln (&"HQ_SHUTDOWN_AXIS_HQ"); //announce the radio was destroyed
			level thread hq_points_players("axis", "lost"); //give axis players some points?
			level thread hq_score_update("allies", PointsScored); //give allies team their points
			//destroy team bar
            if(isdefined(level.progressbar_allies_neutralize))
                level.progressbar_allies_neutralize = maps\mp\uox\_uox_hud::deleteTeamHUDProgressBar(level.progressbar_allies_neutralize);
		}
	}
	
	if (radio.team == "none") //if radio was neutral, play the radio spawn sound
		level hq_playsound_onplayers("explo_plant_no_tick");
	
	radio.team = team; //set radio team to the team that captured it
	
	if (team == "none") //don't ask me how a radio could be captured but still be neutral but apparently it can
	{
		// RADIO GOES NEUTRAL
		level thread hq_wave_timer(); //set up reinforcement timer
		
		radio setmodel ("xmodel/objective_german_field_radio_notsolid"); //make radio not have hitbox
		radio stoploopsound ("german_radio"); //stop sfx on radio
		radio stoploopsound ("german_radio_pathfinder");
		radio hide(); //make radio hidden
		radio.hidden = true;
		objective_delete(0); //delete objective off of compass
		level thread hq_removhudelem_allplayers(radio); //remove hud elements
	}
	else //if radio was captured by a team
	{
		// RADIO CAPTURED BY A TEAM
		level thread hq_wave_timer(); //set up reinforcement timer 
		
		level.captured_radios[team] = 1; //flag capturing team as having a captured radio
        level.defenseTeam = team;
        level notify ("hq_reinforcements");
		radio setmodel ("xmodel/german_field_radio_notsolid"); //set the radio to not have a hit box
		
		if (team == "allies") //if allies captured radio
		{
			iprintln (&"HQ_SETUP_HQ_ALLIED"); //announce allies have captured radio
			radio playloopsound ("german_radio_pathfinder"); //play allied sound
            level thread hq_points_players("allies", "captured"); //give points to allied players for capture
		}
		else //else if axis captured radio
		{
			iprintln (&"HQ_SETUP_HQ_AXIS"); //announce axis have captured the radio
			radio playloopsound ("german_radio"); //play axis sound
            level thread hq_points_players("axis", "captured"); //give points to axis players for capture
		}
	}
	objective_icon(0, ( game["radio_" + team ] )); //add the appropriate icon for the radio
	objective_team(0, "none"); //set the team objective to none
	
	objteam = "none"; //save none to objteam var
	if ( (level.captured_radios["allies"] <= 0) && (level.captured_radios["axis"] > 0) ) //if axis have a radio and allies don't
		objteam = "allies"; //update objteam to allies
	else if ( (level.captured_radios["allies"] > 0) && (level.captured_radios["axis"] <= 0) ) //else if allies have a radio and axis don't
		objteam = "axis"; //update obj team to axis
	
	// Make all neutral radio objectives go to the right team
	for ( i=0 ; i<level.radio.size ; i++ ) //walk radios
	{
		if (level.radio[i].hidden == true) //skip hidden radios
			continue;
		if (level.radio[i].team == "none") //update all radios to the right team
			objective_team(0, objteam);
	}
	
	level hq_obj_think(radio); //start the obj think thread, this time with the current radio
}

/* **************************************************************************************************
**** hq_playsound_onplayers(str sound)
****
**** plays the specified sound on anyone who is playing. Local sound means each player hears it on
**** themselves and isn't a world sound such as a bomb plant
****
*************************************************************************************************** */
hq_playsound_onplayers(sound)
{
	players = getentarray("player", "classname"); //get players
	for(i = 0; i < players.size; i++) //walk players
	{
		if((isDefined(players[i].pers["team"])) && (players[i].pers["team"] != "spectator")) //is player playing
			players[i] playLocalSound(sound); //play local sound
	}
}

/* **************************************************************************************************
**** hq_removeall_hudelems(ent player)
****
**** removes radio icon, progress bar, and reinforcement timer from player hud
****
*************************************************************************************************** */
hq_removeall_hudelems(player)
{
	if (isdefined (self)) //if calling ent is defined, i assume this is the radio
	{
        player maps\mp\uox\_uox_hud::deleteClientHUDElement("radio_icon"); //destroy the radio icon
        player maps\mp\uox\_uox_hud::deleteClientHUDProgressBar();		//destroy the progress bar
		player maps\mp\uox\_uox_hud::deleteClientHUDElement("respawn_timer"); //destroy the respawn timer
	}
}

/* **************************************************************************************************
**** hq_removeall_hudelems(ent player)
****
**** removes radio icon and progress bar from all players
****
*************************************************************************************************** */
hq_removhudelem_allplayers(radio)
{
	players = getentarray("player", "classname"); //get players
	for(i = 0; i < players.size; i++) //walk players
	{
        player = players[i];
		if (!isdefined (player)) //skip undefined players, could happen if a player disconnects inbetween server frames
			continue;
		player maps\mp\uox\_uox_hud::deleteClientHUDElement("radio_icon"); //destroy the radio icon
        player maps\mp\uox\_uox_hud::deleteClientHUDProgressBar(); //destroy the progress bar
	}
}

/* **************************************************************************************************
**** hq_points_players(str team, str reason)
****
**** gives points to the right team based on the specified team and reason (lost, capture, defending)
****
*************************************************************************************************** */
hq_points_players(team, reason)
{
    holdbonus = [[level.getVars]]("scr_radioholdbonuspoints");
    capturebonus = [[level.getVars]]("scr_radiocapturebonuspoints");
    destroybonus = [[level.getVars]]("scr_radiodestroybonuspoints");

    players = getentarray("player", "classname"); //get players
    for(i = 0; i < players.size; i++) //walk players
    {
        player = players[i];
        if ( !isdefined(player.pers["team"]) || player.sessionstate != "playing") //skip players not playing
            continue;
            
        // if defending then give points to the defending team
        if (reason == "defending" && player.pers["team"] == team)
        {
            player.score += holdbonus;
            player.pers["score"] = player.score;
        }
        // if capture then give points to the attacking team
        else if (reason == "captured" && player.pers["team"] == team)
        {
            player.score += capturebonus;
            player.pers["score"] = player.score;
        }
        // if lost then give points to the attacking team
        else if (reason == "lost" && player.pers["team"] != team)
        {
            player.score += destroybonus;
            player.pers["score"] = player.score;
        }
    }
	
}

/* **************************************************************************************************
**** hq_score_update(str team, int points)
****
**** removes radio icon and progress bar from all players
****
*************************************************************************************************** */
hq_score_update(team, points)
{
	//if ( (points <= 0) || (points > level.wavetime) )
	//	return;
    scorelimit = [[level.getVars]]("scr_scorelimit");
	if (team == "allies")// if team is allies, announce that they scored
		iprintln (&"HQ_SCORED_ALLIES", points);
	else //otherwise announce that axis scored
		iprintln (&"HQ_SCORED_AXIS", points);
	
	if( (getTeamScore(team) + points) >  scorelimit)
		setTeamScore(team, scorelimit);
	else
		setTeamScore(team, (getTeamScore(team) + points));
	level thread hq_playsound_onplayers("hq_score");
	
}

/* **************************************************************************************************
**** hq_wave_timer()
****
**** runs the wave timer for scoring and hq respawning
****
*************************************************************************************************** */
hq_wave_timer()
{
    level waittill("wave timer finished");
	//because the current wave needs to abort when a timer is create, can't use the loop manager
	if (!level.mapended && !level.roundended) //check as long as the match is going
	{	
		//after timer has expired
		if (level.captured_radios["axis"] > 0) //if axis has a radio
		{
			level thread hq_score_update("axis", level.wavetime); //give axis their points
			level.timesCaptured++; //increment the number of times the radio has been defended
			level thread hq_points_players("axis","defending"); //give players points for holding the radio
			if (level.timesCaptured >= [[level.getVars]]("scr_radiomaxhold")) //if radio has been defended more times than the max
			{
				level hq_radio_resetall("allies"); //reset radio
				return; //abort function
			}
		}
		if (level.captured_radios["allies"] > 0) //if allies have a radio
		{
			level thread hq_score_update("allies", level.wavetime); //give alleis their points
			level.timesCaptured++; //increment the number of times the radio has been defended
			level thread hq_points_players("allies","defending"); //give allies points for holding the radio
			if (level.timesCaptured >= [[level.getVars]]("scr_radiomaxhold")) //if radio has been defended more times than the max
			{
				level hq_radio_resetall("axis"); //reset radio
				return; //abort function
			}
		}
		level.spawnframe = 0; //set spawn frame to 0;
	}
}

/* **************************************************************************************************
**** hq_radio_resetall()
****
**** resets the radio when its been captured the maximum times
****
*************************************************************************************************** */
hq_radio_resetall(team)
{
	// Find the radio that is in play
	for (i=0;i<level.radio.size;i++) //walk radios
	{
		if (level.radio[i].hidden == false) //if the radio is not hidden
			radio = level.radio[i]; //this is our guy
	}
	
	if (!isdefined (radio)) //if we didn't find any radio
		return; //nothing to do
	
	radio.holdtime_allies = 0; //reset hold time for allies
	radio.holdtime_axis = 0;  //reset hold time for axis
	
	players = getentarray("player", "classname"); //get players
	for(i = 0; i < players.size; i++) //walk players
	{
        player = players[i];
		if(isdefined(players[i].pers["team"]) && players[i].pers["team"] != "spectator" && players[i].sessionstate == "playing")
		{
			player maps\mp\uox\_uox_hud::deleteClientHUDElement("radio_icon"); //destroy the radio icon
            player maps\mp\uox\_uox_hud::deleteClientHUDProgressBar(); //destroy the progress bar
		}
	}
	
	if (radio.team != "none") //if radio was captured
	{	
		level.captured_radios[radio.team] = 0; //reset the number of captured radios
		level hq_playsound_onplayers("hq_explo_radio"); //play radio destroy sound
		playfx(level._effect["radioexplosion"], radio.origin); //blow up the radio
		level.timesCaptured = 0; //reset the number of times radio was held
        level.defenseTeam = "none";
		
		if (radio.team == "allies") //if radio was captured by allies
		{
			iprintlnbold (&"HQ_MAXHOLDTIME_ALLIES");
			//destroy team bar 
            if(isdefined(level.progressbar_axis_neutralize))
                level.progressbar_axis_neutralize = maps\mp\uox\_uox_hud::deleteTeamHUDProgressBar(level.progressbar_axis_neutralize);
		}
		else if (radio.team == "axis")
		{
			iprintlnbold (&"HQ_MAXHOLDTIME_AXIS");
			//destroy team bar 
            if(isdefined(level.progressbar_allies_neutralize))
                level.progressbar_allies_neutralize = maps\mp\uox\_uox_hud::deleteTeamHUDProgressBar(level.progressbar_allies_neutralize);
        }
	}
	
	radio.team = "none"; //reset the team
	objective_team(0, "none"); //reset the obj marker
	
	radio setmodel ("xmodel/objective_german_field_radio_notsolid"); //reset the radio model
	radio stoploopsound ("german_radio"); //silence the radio
	radio stoploopsound ("german_radio_pathfinder");
	radio hide(); //hide the radio
	radio.hidden = true;
	objective_delete(0); //delete the obj marker
	
	level.reinforcement_time = level.wavetime;
	level.graceperiod = false; //set graceperiod to false
	level notify ("Timer Changed"); //notify that the time changed
	level thread hq_wave_timer(); //reset the wave timer
	level hq_obj_think(radio); //spawn a new radio
	level thread hq_removhudelem_allplayers(radio); //remove hud elements
}



