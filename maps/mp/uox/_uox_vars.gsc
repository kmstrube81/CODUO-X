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
		level.vars = [];
	
	cvarname = prefix + "_" + varname;
	
	var = [];
	var["prefix"] = prefix;
	var["varname"] = varname;
	var["cvarname"] = cvarname;
	var["type"] = type;
	var["value"] = value;
	var["callback"] = callback;
	
	level.vars = maps\mp\uox\_uox_arrays::updateObjArrayByProperty(
		level.vars, var, "cvarname", cvarname );
		
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
		level.monitoredVars = [];
	level.monitoredVars = maps\mp\uox\_uox_arrays::updateObjArrayByProperty(
		level.monitoredVars, var, "cvarname", cvarname );
}

/* *************************************************************************************************
**** updateVars()
****
**** runs monitor loop to update vars
****  
************************************************************************************************* */
updateVars()
{
	for(;;)
	{
		for(i = 0; i < level.monitoredVars.size; i++)
		{
			var = level.monitoredVars[i];
			
			_val = getVar(var["prefix"], var["varname"], var["type"]);
			
			if(!isDefined(_val))
				_val = "";
			
			_index = maps\mp\uox\_uox_arrays::searchObjArrayByProperty(
				level.vars, "cvarname", var["cvarname"]);
				
			_var = level.vars[_index];
				
			if(_val != _var["value"])
			{
				oldval = _var["value"];
				//update var
				
				level.vars[_index]["value"] = _val;
				//announce var change
				switch(_var["type"])
				{
					case "bool":
						if(_var["value"])
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
				//run callback, the var value is the first parameter
				if(isDefined(_var["callback"]))
				{
					[[_var["callback"]]](_var["value"]);
				}
			}
		}
		wait 1;
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
	return level.vars[maps\mp\uox\_uox_arrays::searchObjArrayByProperty(level.vars, "cvarname", cvarname)]["value"];
}