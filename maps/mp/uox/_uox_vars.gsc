/* *************************************************************************************************
**** varDef(string prefix, string varname, string type (optional), bool shouldMonitor (optional),
****			mixedtype defValue, (optional), number minVal (optional), number maxVal (optional),
****			string gt (optional), string map (optional) )
****
**** Original function based off cvardef from AWE (by bell)
**** TYPICAL USAGE: defines cvar with the specified prefix and varname. Will check map and gt specific
**** cvars if they exist. Optionally specify the type to make sure the return value is correct type
**** defValue, minVal, and maxVal are there to define the variable. ShouldMonitor adds variable to 
**** update loop during def. These variables should only ever be defined from a call from varDef
****
**** returns the value the cvar is set as
****  
************************************************************************************************* */
varDef(prefix, varname, type, shouldMonitor, defValue, minVal, maxVal, hrName, callback, gt, map)
{
	if(!isDefined(shouldMonitor)) shouldMonitor = false;
	if(shouldMonitor) monitorVar(prefix, varname, type, hrName);
	
	value = getVar(prefix, varname, type, defValue, minVal, maxVal, gt, map);
	//add to varlist
	if(!isDefined(level.vars))
		level.vars = maps\mp\uox\_uox_arrays::superArray();
	
	cvarname = prefix + "_" + varname;
	
	var = [];
	var["prefix"] = prefix;
	var["varname"] = varname;
	var["cvarname"] = cvarname;
	var["type"] = type;
	var["value"] = value;
	var["defaultvalue"] = defValue;
	var["callback"] = callback;
	
	level.vars = maps\mp\uox\_uox_arrays::arrayPush(level.vars, var, cvarname);
	return value;
}

/* *************************************************************************************************
**** getVar(string prefix, string varname, string type (optional), bool shouldMonitor (optional),
****			mixedtype defValue, (optional), number minVal (optional), number maxVal (optional),
****			string gt (optional), string map (optional) )
****
**** Original function based off cvardef from AWE (by bell)
**** TYPICAL USAGE: gets cvar with the specified prefix and varname. Will check map and gt specific
**** cvars if they exist. Optionally specify the type to make sure the return value is correct type
**** defValue, minVal, and maxVal are there to define the variable. ShouldMonitor adds variable to 
**** update loop during def. These variables should only ever be defined from a call from varDef
****
**** returns the value the cvar is set as, returns undefined if var not set
****  
************************************************************************************************* */
getVar(prefix, varname, type, defValue, minVal, maxVal, gt, map)
{
	//define type, shouldMonitor, gametype and mapname if not defined
	if(!isDefined(type)) type = "";
	if(!isDefined(gt)) gt = getCvar("g_gametype");
	if(!isDefined(map)) map = getCvar("mapname");
	
	setFlag = false; //flag if cvar needs to be set because it used the default value
	
	if(getCvar(prefix + "_" + gt + "_" + varname + "_" + map) != "") //if gt + map specific var is set
		varname = prefix + "_" + gt + "_" + varname + "_" + map; //hasValue type is 4
	else if(getCvar(prefix + "_" + varname + "_" + map) != "") //if map specific var is set
		varname = prefix + "_" + varname + "_" + map; //hasValue type is 3
	else if(getCvar(prefix + "_" + gt + "_" + varname) != "") //if gt specific var is set
		varname = prefix + "_" + gt + "_" + varname; //hasValue type is 2
	else if(getCvar(prefix + "_" + varname) != "") //if var is set
		varname = prefix + "_" + varname; //hasValue type is 1
	else //var has no value
	{
		varname = prefix + "_" + varname;
		value = defValue;
		//if no default value then return undefined
		if(!isDefined(defValue))
			return undefined;
		setFlag = true;
	}
		
	//get value
	if(!isDefined(value))
	{
		if(type == "int")
			value = getCvarInt(varname);
		else if(type == "float")
			value = getCvarFloat(varname);
		else
			value = getCvar(varname);
	}
		
	//valid types - bool, int, float, string
	switch(type)
	{
		case "bool": //for boolean vars
			if(!isDefined(value) || value == 0 || value == false
			  || value == "false" || value == "0") //valid false values
				_val = false;
			else //all other values are true
				_val = true;
			if(_val != value) //check if value was valid
				setFlag = true; //setFlag if value had to be adjusted
			break;
		case "int":
		case "float":
			if(isDefined(minVal) && value < minVal) //if value is less the minimum
				_val = minVal; //set value to minimum
			else if(isDefined(maxVal) && value > maxVal) //if value is greater than max
				_val = maxVal; //set value to max
			else 
				_val = value;
			if(_val != value) //check if value was valid
				setFlag = true; //setFlag if value had to be adjusted
			break;
		case "string":
			_val = value;
			break;
		default:
			_val = value;
	}
	if(setFlag)
		setCvar(varname,_val);
	return _val;
}

/* *************************************************************************************************
**** monitorVar(string prefix, string varname, string type, string hrName (optional) )
****
**** adds variable to monitor loop to 
****  
************************************************************************************************* */
monitorVar(prefix, varname, type, hrName)
{
	cvarname = prefix + "_" + varname;
	
	var = [];
	var["prefix"] = prefix;
	var["varname"] = varname;
	var["cvarname"] = cvarname;
	var["type"] = type;
	
	var["hrname"] = hrName;

	if(!isDefined(level.monitoredVars))
		level.monitoredVars = maps\mp\uox\_uox_arrays::superArray();
	level.monitoredVars = maps\mp\uox\_uox_arrays::arrayPush(
		level.monitoredVars, var, cvarname );
}

/* *************************************************************************************************
**** updateVars()
****
**** runs monitor loop to update vars
****  
************************************************************************************************* */
updateVars()
{
	for(i = 0; i < maps\mp\uox\_uox_arrays::getArrayLength(level.monitoredVars); i++)
	{
		keys = maps\mp\uox\_uox_arrays::getArrayKeys(level.monitoredVars);
		var = maps\mp\uox\_uox_arrays::getValue(level.monitoredVars, keys[i]);
		
		_val = getVar(var["prefix"], var["varname"], var["type"]);
			
		_var = maps\mp\uox\_uox_arrays::getValue(level.vars, var["cvarname"]);
		
		if(!isDefined(_val))
			_val = _var["defaultvalue"];
			
		if(_val != _var["value"])
		{
			oldval = _var["value"];
			//update var
			level.vars = maps\mp\uox\_uox_arrays::updateProperty(level.vars, var["cvarname"], "value", _val);
			//announce var change if hrname is defined
			if(isDefined(_var["hrname"]))
			{
				switch(_var["type"])
				{
					case "bool":
						if(_val)
							setting = "ON";
						else
							setting = "OFF";
						iprintln("SERVER: ^1" + var["hrname"] + " ^7has been turned ^1" + setting);
						break;
					case "int":
					case "float":
					case "string":
						setting = _val;
						iprintln("SERVER: ^1" + var["hrname"] + " ^7has been updated to ^1" + setting + "^7 from ^1" + oldval);
						break;
				}
			}
			//run callback, the var value is the first parameter
			if(isDefined(_var["callback"]))
			{
				[[_var["callback"]]](_var["value"]);
			}
		}
	}
}

/* *************************************************************************************************
**** getVars(string cvarname )
****
**** gets var value from var list
****  
************************************************************************************************* */
getVars(cvarname)
{
	return maps\mp\uox\_uox_arrays::getValue(level.vars, cvarname)["value"];
}

/* *************************************************************************************************
**** initGameTypeVars()
****
**** defines vars common to all gametypes
****  
************************************************************************************************* */
initGameTypeVars()
{
	gt = level.gametype;
	
	varDef("scr", "timelimit", "float", true,
								30, 0, 1440, "Time Limit", maps\mp\uox\_uox::updateTimeLimit);
	setCvar("ui_" + gt + "_timelimit", [[level.getVars]]("scr_timelimit"));
	makeCvarServerInfo("ui_" + gt + "_timelimit", "30");								

	varDef("scr", "scorelimit", "int", true,
								50, 0, undefined, "Score Limit", maps\mp\uox\_uox::updateScoreLimit);
	setCvar("ui_" + gt + "_scorelimit", [[level.getVars]]("scr_scorelimit"));
	makeCvarServerInfo("ui_" + gt + "_scorelimit", "50");
	
	varDef("scr", "roundlimit", "int", true, 1, 0, undefined, "Round Limit");
	setCvar("ui_" + gt + "_roundlimit", [[level.getVars]]("scr_roundlimit"));
	makeCvarServerInfo("ui_" + gt + "_roundlimit", 1);
	
	level.roundlength = varDef("scr", "roundlength", "float", true, 2.5, 0, 60, "Round Length");
	setCvar("ui_dm_roundlength", [[level.getVars]]("scr_roundlength"));
	makeCvarServerInfo("ui_dm_roundlength", "30");
	
	varDef("scr", "graceperiod", "int", true, 15, 0, undefined, "Grace Period");

	varDef("scr", "roundreset", "bool", true, false, undefined, undefined, "Round Reset");
	varDef("scr", "score_rounds", "bool", true, false, undefined, undefined, "Score Round Wins");
	varDef("scr", "countdraws", "bool", true, true, undefined, undefined, "Count Draws");

	varDef("scr", "warmupmode", "int", true, 0, 0, 2, "Warmup Mode");
	varDef("scr", "autoreadycount", "int", true, 0, 0, undefined, "Auto-Ready Player Count");
	varDef("scr", "autoreadytime", "int", true, 0, 0, undefined, "Auto-Ready Timer");
	varDef("scr", "halftime", "bool", true, false, undefined, undefined, "Halftime");
	varDef("scr", "overtime", "bool", true, false, undefined, undefined, "Overtime");
	varDef("scr", "ot_roundlimit", "int", true, 1, 0, undefined, "Overtime Rounds");
	
	game["roundbased"] = false;
	if([[level.getVars]]("scr_roundlimit") != 1)
		game["roundbased"] = true;
	else if([[level.getVars]]("scr_warmupmode") > 0)
		game["roundbased"] = true;
	else if([[level.getVars]]("scr_halftime") > 0)
		game["roundbased"] = true;
	
	switch([[level.getVars]]("scr_respawn_mode"))
	{
		case "spawndelay":
			varDef("scr", "spawn_delay_time", "int", true, 7, 1, 60, "Delayed Spawn Timer");
			break;
		case "forcerespawn":
		case "obj":
		case "dm":
			varDef("scr", "forcerespawn", "int", true, 0, 0, 60, "Force Respawn");
			break;
		case "wave":
			varDef("scr", "respawn_wave_time", "int", true, 7, 1, 60, "Respawn Wave Timer");
			break;
        case "bel":
            varDef("scr", "spawn_delay_time", "int", true, 7, 1, 60, "Delayed Spawn Timer");
            varDef("scr", "playerRatio", "int", true, 1, 1, 10, "Axis to Allies Ratio");
            break;
	}
	varDef("scr", "battlerank", "int", true, 1, 0, 2, "Battle Rank", maps\mp\uox\_uox::updateBattleRank);
	setCvar("ui_battlerank", [[level.getVars]]("scr_battlerank"));
	makeCvarServerInfo("ui_battlerank", "0");
	//needed for compatibility with built in UO battlerank
	level.battlerank = [[level.getVars]]("scr_battlerank");
	if(level.battlerank > 0)
		maps\mp\uox\_uox_loops::addToLoop(level, "slow",
				maps\mp\gametypes\_rank_gmi::CheckPlayersForRankChanges, "checkPlayersForRankChanges");
				
	varDef("scr", "shellshock", "bool", true, true, undefined, undefined, "Shellshock");
	setCvar("ui_shellshock", [[level.getVars]]("scr_shellshock"));
	makeCvarServerInfo("ui_shellshock", "0");
	varDef("scr", "drophealth", "bool", true, true, undefined, undefined, "Drop Health");
	setCvar("scr_ceasefire", false);
	varDef("scr", "ceasefire", "bool", true,
					false, undefined, undefined, "Cease Fire", maps\mp\uox\_uox::updateCeaseFire);
	varDef("scr", "killcam", "bool", true,
					true, undefined, undefined, "Killcam", maps\mp\uox\_uox::updateKillcam);
	varDef("scr", "final_killcam", "bool", true,
					false, undefined, undefined, "Final Killcam", maps\mp\uox\_uox::updateFinalKillcam);
	if([[level.getVars]]("scr_killcam") || [[level.getVars]]("scr_final_killcam"))
		setarchive(true);
	
	if(!isDefined(game["compass_range"]))		// set up the compass range.
		game["compass_range"] = 1024;		
	setCvar("cg_hudcompassMaxRange", game["compass_range"]);
	makeCvarServerInfo("cg_hudcompassMaxRange", "0");
	
    level.drawfriend = 0;
    level.teambalance = 0;
    level.teamkill_penalty = false;
    level.QuickMessageToAll = true;

	if(level.uox_teamplay)
	{
		level.drawfriend = varDef("scr", "drawfriend", "bool", true,
										true, undefined, undefined, "Draw Teams Icons",
										maps\mp\uox\_uox::updateDrawFriend);
		level.friendlyfire = varDef("scr", "friendlyfire", "int", true,
										0, 0, 3, "Friendly Fire Mode",
										maps\mp\uox\_uox::updateFriendlyFire);
        if(level.objective != "bel") {   
    		level.teambalance = varDef("scr", "teambalance", "bool", true,
    										true, undefined, undefined, "Team Balance", 
    										maps\mp\uox\_uox::updateTeamBalance);
    		if(level.teambalance && (!game["roundbased"] || [[level.getVars]]("scr_roundlimit") == 1))
    			maps\mp\uox\_uox_loops::addToLoop(level, "slow",
    					maps\mp\uox\_uox::TeamBalance_Check(), "TeamBalance_Check");
        }
		varDef("scr", "teamscorepenalty", "bool", true, true, undefined, undefined, "Team Kill Penalty");
		
		varDef("scr", "freelook", "bool", true, true, undefined, undefined, "Free Spectate",
					maps\mp\gametypes\_teams::UpdateSpectatePermissions);
		varDef("scr", "spectateenemy", true, true, undefined, undefined, "Spectate Enemy Team",
					maps\mp\gametypes\_teams::UpdateSpectatePermissions);
	}
	
	//define scoreboard vars
	varDef("sv", "showScoreboard", "bool", true, true);
	varDef("sv", "showScoreboardScoreLimit", "bool", true, true);
	varDef("sv", "showPlayersLeft", "bool", true, true);
	varDef("sv", "endRoundScoreboardTime", "int", true, 7, 3, 15);
	
	//define enforce client cvars
	varDef("sv", "enforcedClientCvars", "string", false, "");
	
}

enforceClientCvars()
{
	if([[level.getVars]]("sv_enforcedClientCvars") == "")
		return;
	
	cvars = maps\mp\uox\_uox_utils::stringSplit([[level.getVars]]("sv_enforcedClientCvars"), ";");
	
	for(i = 0; i < cvars.size; i++)
	{
		cvar = cvars[i];
		if(cvar == "")
			continue;
		
		serverCvar = getcvar(cvar);
		self setClientCvar(cvar, serverCvar);
	}
}