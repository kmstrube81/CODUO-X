defineMenus()
{
    game["menu_serverinfo"] = getServerInfoMenu();
    if(level.objective == "bel")
        game["menu_team"] = "team_germanonly";
    else
        game["menu_team"] = "team_" + game["allies"] + game["axis"];
    game["menu_weapon_all"] = "weapon_" + game["allies"] + game["axis"];
    game["menu_weapon_allies"] = "weapon_" + game["allies"];
    game["menu_weapon_axis"] = "weapon_" + game["axis"];
    game["menu_viewmap"] = "viewmap";
    game["menu_callvote"] = "callvote";
    game["menu_quickcommands"] = "quickcommands";
    game["menu_quickstatements"] = "quickstatements";
    game["menu_quickresponses"] = "quickresponses";
    game["menu_quickvehicles"] = "quickvehicles";
    game["menu_quickrequests"] = "quickrequests";

    //set up menu handlers
    if(!isDefined(game["menuHandlers"]))
        game["menuHandlers"] = maps\mp\uox\_uox_arrays::superArray();
    //handle server info
    handlers = maps\mp\uox\_uox_arrays::getValue(game["menuHandlers"], game["menu_serverinfo"]);
    if(!isDefined(handlers))
    {
        handlers = [];
        handlers[0] = ::handleServerInfoMenu;
    }
    else
    {
        handlers = maps\mp\uox\_uox_arrays::arrayPush(handlers, ::handleServerInfoMenu);
    }
    game["menuHandlers"] = maps\mp\uox\_uox_arrays::arrayPush(game["menuHandlers"], handlers, game["menu_serverinfo"]);
    //handle teams
    handlers = maps\mp\uox\_uox_arrays::getValue(game["menuHandlers"], game["menu_team"]);
    if(!isDefined(handlers))
    {
        handlers = [];
        handlers[0] = ::handleTeamMenu;
    }
    else
    {
        handlers = maps\mp\uox\_uox_arrays::arrayPush(handlers, ::handleTeamMenu);
    }
    game["menuHandlers"] = maps\mp\uox\_uox_arrays::arrayPush(game["menuHandlers"], handlers, game["menu_team"]);
    //handle weapons - all
    handlers = maps\mp\uox\_uox_arrays::getValue(game["menuHandlers"], game["menu_weapon_all"]);
    if(!isDefined(handlers))
    {
        handlers = [];
        handlers[0] = ::handleWeaponMenu;
    }
    else
    {
        handlers = maps\mp\uox\_uox_arrays::arrayPush(handlers, ::handleWeaponMenu);
    }
    game["menuHandlers"] = maps\mp\uox\_uox_arrays::arrayPush(game["menuHandlers"], handlers, game["menu_weapon_all"]);
    //handle weapons - allies
    handlers = maps\mp\uox\_uox_arrays::getValue(game["menuHandlers"], game["menu_weapon_allies"]);
    if(!isDefined(handlers))
    {
        handlers = [];
        handlers[0] = ::handleWeaponMenu;
    }
    else
    {
        handlers = maps\mp\uox\_uox_arrays::arrayPush(handlers, ::handleWeaponMenu);
    }
    game["menuHandlers"] = maps\mp\uox\_uox_arrays::arrayPush(game["menuHandlers"], handlers, game["menu_weapon_allies"]);
    //hande weapons - axis
    handlers = maps\mp\uox\_uox_arrays::getValue(game["menuHandlers"], game["menu_weapon_axis"]);
    if(!isDefined(handlers))
    {
        handlers = [];
        handlers[0] = ::handleWeaponMenu;
    }
    else
    {
        handlers = maps\mp\uox\_uox_arrays::arrayPush(handlers, ::handleWeaponMenu);
    }
    game["menuHandlers"] = maps\mp\uox\_uox_arrays::arrayPush(game["menuHandlers"], handlers, game["menu_weapon_axis"]);
    //handle Map
    handlers = maps\mp\uox\_uox_arrays::getValue(game["menuHandlers"], game["menu_viewmap"]);
    if(!isDefined(handlers))
    {
        handlers = [];
        handlers[0] = ::handleMapMenu;
    }
    else
    {
        handlers = maps\mp\uox\_uox_arrays::arrayPush(handlers, ::handleMapMenu);
    }
    game["menuHandlers"] = maps\mp\uox\_uox_arrays::arrayPush(game["menuHandlers"], handlers, game["menu_viewmap"]);
    //handle call vote
    handlers = maps\mp\uox\_uox_arrays::getValue(game["menuHandlers"], game["menu_callvote"]);
    if(!isDefined(handlers))
    {
        handlers = [];
        handlers[0] = ::handleVoteMenu;
    }
    else
    {
        handlers = maps\mp\uox\_uox_arrays::arrayPush(handlers, ::handleVoteMenu);
    }
    game["menuHandlers"] = maps\mp\uox\_uox_arrays::arrayPush(game["menuHandlers"], handlers, game["menu_callvote"]);
    //handle quick commands
    handlers = maps\mp\uox\_uox_arrays::getValue(game["menuHandlers"], game["menu_quickcommands"]);
    if(!isDefined(handlers))
    {
        handlers = [];
        handlers[0] = ::handleQuickCommandsMenu;
    }
    else
    {
        handlers = maps\mp\uox\_uox_arrays::arrayPush(handlers, ::handleQuickCommandsMenu);
    }
    game["menuHandlers"] = maps\mp\uox\_uox_arrays::arrayPush(game["menuHandlers"], handlers, game["menu_quickcommands"]);
    //handel quick statements
    handlers = maps\mp\uox\_uox_arrays::getValue(game["menuHandlers"], game["menu_quickstatements"]);
    if(!isDefined(handlers))
    {
        handlers = [];
        handlers[0] = ::handleQuickStatementsMenu;
    }
    else
    {
        handlers = maps\mp\uox\_uox_arrays::arrayPush(handlers, ::handleQuickStatementsMenu);
    }
    game["menuHandlers"] = maps\mp\uox\_uox_arrays::arrayPush(game["menuHandlers"], handlers, game["menu_quickstatements"]);
    //handle quick responses
    handlers = maps\mp\uox\_uox_arrays::getValue(game["menuHandlers"], game["menu_quickresponses"]);
    if(!isDefined(handlers))
    {
        handlers = [];
        handlers[0] = ::handleQuickResponsesMenu;
    }
    else
    {
        handlers = maps\mp\uox\_uox_arrays::arrayPush(handlers, ::handleQuickResponsesMenu);
    }
    game["menuHandlers"] = maps\mp\uox\_uox_arrays::arrayPush(game["menuHandlers"], handlers, game["menu_quickresponses"]);
    //handle quick Vehicles
    handlers = maps\mp\uox\_uox_arrays::getValue(game["menuHandlers"], game["menu_quickvehicles"]);
    if(!isDefined(handlers))
    {
        handlers = [];
        handlers[0] = ::handleQuickVehiclesMenu;
    }
    else
    {
        handlers = maps\mp\uox\_uox_arrays::arrayPush(handlers, ::handleQuickVehiclesMenu);
    }
    game["menuHandlers"] = maps\mp\uox\_uox_arrays::arrayPush(game["menuHandlers"], handlers, game["menu_quickvehicles"]);
    //handle quick requests
    handlers = maps\mp\uox\_uox_arrays::getValue(game["menuHandlers"], game["menu_quickrequests"]);
    if(!isDefined(handlers))
    {
        handlers = [];
        handlers[0] = ::handleQuickRequestsMenu;
    }
    else
    {
        handlers = maps\mp\uox\_uox_arrays::arrayPush(handlers, ::handleQuickRequestsMenu);
    }
    game["menuHandlers"] = maps\mp\uox\_uox_arrays::arrayPush(game["menuHandlers"], handlers, game["menu_quickrequests"]);
}

precache()
{
    precacheMenu(game["menu_serverinfo"]);
    precacheMenu(game["menu_team"]);
    precacheMenu(game["menu_weapon_allies"]);
    precacheMenu(game["menu_weapon_axis"]);
    precacheMenu(game["menu_weapon_all"]);
    precacheMenu(game["menu_viewmap"]);
    precacheMenu(game["menu_callvote"]);
    precacheMenu(game["menu_quickcommands"]);
    precacheMenu(game["menu_quickstatements"]);
    precacheMenu(game["menu_quickresponses"]);
    precacheMenu(game["menu_quickvehicles"]);
    precacheMenu(game["menu_quickrequests"]);
}

getServerInfoMenu()
{
    gt = level.gametype;
    switch(gt)
    {
        //known gametypes
        case "dm":
        case "tdm":
        case "bel":
        case "hq":
        case "re":
        case "sd":
        case "ctf":
        case "dom":
        case "bas":
            return "serverinfo_" + gt;
        //unknown gametypes
        default:
            if(level.uox_teamplay)
                return "serverinfo_tdm";
            else
                return "serverinfo_dm";
    }
    if(level.uox_teamplay)
        return "serverinfo_tdm";
    else
        return "serverinfo_dm";
}

handleServerInfoMenu(response, optional)
{
    if(response == "close")
    {
        self.pers["skipserverinfo"] = true;
        self openMenu(game["menu_team"]);
    }

    if(response == "open" || response == "close")
        return;
}

handleTeamMenu(response, optional)
{
    if(response == "open" || response == "close")
        return;

    switch(response)
    {
    case "allies":
    case "axis":
    case "autoassign":
        if(level.lockteams)
            break;
        if(response == "autoassign")
        {
            response = getAutoAssign();
            skipbalancecheck = true;
        }

        if(response == self.pers["team"] && self.sessionstate == "playing")
            break;

        //Check if the teams will become unbalanced when the player goes to this team...
        //------------------------------------------------------------------------------
        if ( (level.teambalance > 0) && (!isdefined (skipbalancecheck)) )
        {
            //Get a count of all players on Axis and Allies
            players = maps\mp\gametypes\_teams::CountPlayers();
            
            if (self.sessionteam != "spectator")
            {
                if (((players[response] + 1) - (players[self.pers["team"]] - 1)) > level.teambalance)
                {
                    if (response == "allies")
                    {
                        if (game["allies"] == "american")
                            self iprintlnbold(&"PATCH_1_3_CANTJOINTEAM_ALLIED",&"PATCH_1_3_AMERICAN");
                        else if (game["allies"] == "british")
                            self iprintlnbold(&"PATCH_1_3_CANTJOINTEAM_ALLIED",&"PATCH_1_3_BRITISH");
                        else if (game["allies"] == "russian")
                            self iprintlnbold(&"PATCH_1_3_CANTJOINTEAM_ALLIED",&"PATCH_1_3_RUSSIAN");
                    }
                    else
                        self iprintlnbold(&"PATCH_1_3_CANTJOINTEAM_ALLIED",&"PATCH_1_3_GERMAN");
                    break;
                }
            }
            else
            {
                if (response == "allies")
                    otherteam = "axis";
                else
                    otherteam = "allies";
                if (((players[response] + 1) - players[otherteam]) > level.teambalance)
                {
                    if (response == "allies")
                    {
                        if (game["allies"] == "american")
                            self iprintlnbold(&"PATCH_1_3_CANTJOINTEAM_ALLIED2",&"PATCH_1_3_AMERICAN");
                        else if (game["allies"] == "british")
                            self iprintlnbold(&"PATCH_1_3_CANTJOINTEAM_ALLIED2",&"PATCH_1_3_BRITISH");
                        else if (game["allies"] == "russian")
                            self iprintlnbold(&"PATCH_1_3_CANTJOINTEAM_ALLIED2",&"PATCH_1_3_RUSSIAN");
                    }
                    else
                    {
                        if (game["allies"] == "american")
                            self iprintlnbold(&"PATCH_1_3_CANTJOINTEAM_AXIS",&"PATCH_1_3_AMERICAN");
                        else if (game["allies"] == "british")
                            self iprintlnbold(&"PATCH_1_3_CANTJOINTEAM_AXIS",&"PATCH_1_3_BRITISH");
                        else if (game["allies"] == "russian")
                            self iprintlnbold(&"PATCH_1_3_CANTJOINTEAM_AXIS",&"PATCH_1_3_RUSSIAN");
                    }
                    break;
                }
            }
        }
        skipbalancecheck = undefined;
        //------

        if(response != self.pers["team"] && self.sessionstate == "playing")
            self suicide();

        self notify("end_respawn");

        self.pers["team"] = response;
        self.pers["teamTime"] = (gettime() / 1000);
        self.pers["weapon"] = undefined;
        self.pers["weapon1"] = undefined;
        self.pers["weapon2"] = undefined;
        self.pers["spawnweapon"] = undefined;
        self.pers["savedmodel"] = undefined;
        
        if(level.uox_teamplay) // update spectator permissions immediately on change of team
            maps\mp\gametypes\_teams::SetSpectatePermissions();

        // if there are weapons the user can select then open the weapon menu      
        if(level.objective == "bel" && ( maps\mp\gametypes\_teams::isweaponavailable("axis") || maps\mp\gametypes\_teams::isweaponavailable("allies") ))
        {
            menu = game["menu_weapon_all"];
            self setClientCvar("ui_weapontab", "1");
            self openMenu(menu);
        }
        if(self.pers["team"] == "allies" && maps\mp\gametypes\_teams::isweaponavailable(self.pers["team"]))
        {
            menu = game["menu_weapon_allies"];
            self setClientCvar("ui_weapontab", "1");
            self openMenu(menu);
        }
        else if(self.pers["team"] == "axis" && maps\mp\gametypes\_teams::isweaponavailable(self.pers["team"])) 
        {
            menu = game["menu_weapon_axis"];
            self setClientCvar("ui_weapontab", "1");
            self openMenu(menu);
        }
        else
        {
            self setClientCvar("ui_weapontab", "0");
            self maps\mp\uox\_uox_respawns::menu_spawn("none");
        }

        if(!isDefined(menu))
            menu = game["menu_team"];
        self setClientCvar("g_scriptMainMenu", menu);
        break;

    case "spectator":
        if (level.lockteams)
            break;
        if(self.pers["team"] != "spectator")
        {
            if(isAlive(self) && level.respawn_mode != "bel")
                self suicide();

            self.pers["team"] = "spectator";
            self.pers["teamTime"] = 1000000;
            self.pers["weapon"] = undefined;
            self.pers["weapon1"] = undefined;
            self.pers["weapon2"] = undefined;
            self.pers["spawnweapon"] = undefined;
            self.pers["savedmodel"] = undefined;
            
            self.sessionteam = "spectator";
            self setClientCvar("g_scriptMainMenu", game["menu_team"]);
            self setClientCvar("ui_weapontab", "0");
            maps\mp\uox\_uox_respawns::spawnSpectator();
        }
        break;

    case "weapon":
        if(self.pers["team"] == "allies")
            self openMenu(game["menu_weapon_allies"]);
        else if(self.pers["team"] == "axis")
            self openMenu(game["menu_weapon_axis"]);
        break;

    case "viewmap":
        self openMenu(game["menu_viewmap"]);
        break;

    case "callvote":
        self openMenu(game["menu_callvote"]);
        break;
    }
}

handleWeaponMenu(response, weapon) //allow to pass in a weapon for custom menu handling
{
    if(!isdefined(weapon)) {
        bug = "not defined";
    } else {
        bug = weapon;
    }
    maps\mp\uox\_uox_debug::debugLog("info", self.name + "desperate debug logging response " + response + " weapon " + bug);

    if(response == "open" || response == "close")
        return;

    if(response == "team")
    {
        self openMenu(game["menu_team"]);
        return;
    }
    else if(response == "viewmap")
    {
        self openMenu(game["menu_viewmap"]);
        return;
    }
    else if(response == "callvote")
    {
        self openMenu(game["menu_callvote"]);
        return;
    }

    if(!isDefined(self.pers["team"]) || (self.pers["team"] != "allies" && self.pers["team"] != "axis"))
        return;
    
    if(isDefined(weapon))
        maps\mp\uox\_uox_debug::debugLog("info", self.name + " handleWeaponMenu passed in weapon is " + weapon);

    if(!isDefined(weapon) || weapon != "restricted") 
        weapon = self maps\mp\gametypes\_teams::restrict(response);

    if(weapon == "restricted")
    {
        if(level.objective == "bel")
            menu = game["menu_weapon_all"];
        else if(self.pers["team"] == "allies")
            menu = game["menu_weapon_allies"];
        else if(self.pers["team"] == "axis")
            menu = game["menu_weapon_axis"];

        self openMenu(menu);
        return;
    }

    self.pers["selectedweapon"] = weapon;

    if(isDefined(self.pers["weapon"]) && self.pers["weapon"] == weapon)
        return;

    maps\mp\uox\_uox_respawns::menu_spawn(weapon);
}

handleMapMenu(response, optional)
{
    if(response == "open" || response == "close")
        return;

    switch(response)
    {
        case "team":
            self openMenu(game["menu_team"]);
            break;

        case "weapon":
            if(level.objective == "bel")
                self openMenu(game["menu_weapon_all"]);
            else if(self.pers["team"] == "allies")
                self openMenu(game["menu_weapon_allies"]);
            else if(self.pers["team"] == "axis")
                self openMenu(game["menu_weapon_axis"]);
            break;

        case "callvote":
            self openMenu(game["menu_callvote"]);
            break;
    }
}

handleVoteMenu(response, optional)
{
    if(response == "open" || response == "close")
        return;

    switch(response)
    {
    case "team":
        self openMenu(game["menu_team"]);
        break;

    case "weapon":
        if(level.objective == "bel")
            self openMenu(game["menu_weapon_all"]);
        else if(self.pers["team"] == "allies")
            self openMenu(game["menu_weapon_allies"]);
        else if(self.pers["team"] == "axis")
            self openMenu(game["menu_weapon_axis"]);
        break;

    case "viewmap":
        self openMenu(game["menu_viewmap"]);
        break;
    }
}

handleQuickCommandsMenu(response, optional)
{
    if(response == "open" || response == "close")
        return;

    if(maps\mp\uox\_uox_debug::debug("info"))
        maps\mp\uox\_uox_debug::vsay_debug(game["menu_quickcommands"], response);
    else
        maps\mp\gametypes\_teams::quickcommands(response);
}

handleQuickStatementsMenu(response, optional)
{
    if(response == "open" || response == "close")
        return;

    if(maps\mp\uox\_uox_debug::debug("info"))
        maps\mp\uox\_uox_debug::vsay_debug(game["menu_quickstatements"], response);
    else
        maps\mp\gametypes\_teams::quickstatements(response);
}

handleQuickResponsesMenu(response, optional)
{
    if(response == "open" || response == "close")
        return;

    if(maps\mp\uox\_uox_debug::debug("info"))
        maps\mp\uox\_uox_debug::vsay_debug(game["menu_quickresponses"], response);
    else
        maps\mp\gametypes\_teams::quickresponses(response);
}

handleQuickVehiclesMenu(response, optional)
{
    if(response == "open" || response == "close")
        return;

    if(maps\mp\uox\_uox_debug::debug("info"))
        maps\mp\uox\_uox_debug::vsay_debug(game["menu_quickvehicles"], response);
    else
        maps\mp\gametypes\_teams::quickvehicles(response);
}

handleQuickRequestsMenu(response, optional)
{
    if(response == "open" || response == "close")
        return;

    if(maps\mp\uox\_uox_debug::debug("info"))
        maps\mp\uox\_uox_debug::vsay_debug(game["menu_quickrequests"], response);
    else
        maps\mp\gametypes\_teams::quickrequests(response);
}

handleUnknownMenu(response, optional)
{
    if(response == "open" || response == "close")
        return;
}

handleMenuResponse(menu, response)
{
    handlers = maps\mp\uox\_uox_arrays::getValue(game["menuHandlers"], menu);

    if(!isDefined(handlers))
    {
        handleUnknownMenu();
    }
    for(i = 0; i < handlers.size; i++)
    {
        handler = handlers[i];
        optional = [[ handler ]](response, optional);
    }
}

getAutoAssign()
{
	
	if(level.uox_teamplay)
	{
		numonteam = level.exist; //maps\mp\uox\_uox::numOnTeam();
		
		// if teams are equal return the team with the lowest score
		if(numonteam["allies"] == numonteam["axis"])
		{
			if(game["alliedscore"] == game["axisscore"])
			{
				teams[0] = "allies";
				teams[1] = "axis";
				response = teams[randomInt(2)];
			}
			else if(game["alliedscore"] < game["axisscore"])
				response = "allies";
			else
				response = "axis";
		}
		else if(numonteam["allies"] < numonteam["axis"])
			response = "allies";
		else
			response = "axis";
	}
	else
	{
		teams[0] = "allies";
		teams[1] = "axis";
		response = teams[randomInt(2)];
	}
	return response;
}


