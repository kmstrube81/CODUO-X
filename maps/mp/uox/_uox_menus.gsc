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

registerMenu(menu, handlerCallback, dir, response, responseCallback)
{
    if(!isDefined(handlerCallback))
        handlerCallback = ::handleUnknownMenu;
    if(!isDefined(dir))
        dir = true;
    if(!isDefined(responseCallback))
       responseCallback = ::handleMenuOpen;

    handlers = maps\mp\uox\_uox_arrays::getValue(level.menuHandlers, menu);

    if(!isDefined(handlers))
    {
        handlers = [];
        handlers[0] = handlerCallback;
    }
    else
    {
        handlers = maps\mp\uox\_uox_arrays::arrayPush(handlers, handlerCallback);
    }
    if(dir) //if direction is true, add menuhandler to bottom of callback stack
        level.menuHandlers = maps\mp\uox\_uox_arrays::arrayPush(level.menuHandlers, handlers, menu);
    else //otherwise put it on top of the stack
        level.menuHandlers = maps\mp\uox\_uox_arrays::arrayUnshift(level.menuHandlers, handlers, menu);

    if(!isDefined(response))
        return;
    responseArr = [];
    responseArr[0] = responseCallback; //callback
    responseArr[1] = menu; //registering menu
    level.menuResponses = maps\mp\uox\_uox_arrays::arrayPush(level.menuResponses, responseArr, response);
}

setupMenuHandlers()
{
    //set up menu handlers
    if(!isDefined(level.menuHandlers))
        level.menuHandlers = maps\mp\uox\_uox_arrays::superArray();
    //map menu to response
    if(!isDefined(level.menuResponses))
        level.menuResponses = maps\mp\uox\_uox_arrays::superArray();
    //handle server info
    registerMenu(game["menu_serverinfo"], ::handleServerInfoMenu);
    //handle teams
    registerMenu(game["menu_team"], ::handleTeamMenu, true,  "team");
    //handle weapons - all
    registerMenu(game["menu_weapon_all"], ::handleWeaponMenu, true, "weapon", ::handleWeaponMenuOpen);
    //handle weapons - allies
    registerMenu(game["menu_weapon_allies"], ::handleWeaponMenu);
    //hande weapons - axis
    registerMenu(game["menu_weapon_axis"], ::handleWeaponMenu);
    //handle Map
    registerMenu(game["menu_viewmap"], undefined, true, "viewmap");
    //handle call vote
    registerMenu(game["menu_callvote"], undefined, true, "callvote");
    //handle quick commands
    registerMenu(game["menu_quickcommands"], ::handleQuickCommandsMenu);
    //handle quick statements
    registerMenu(game["menu_quickstatements"], ::handleQuickStatementsMenu);
    //handle quick responses
    registerMenu(game["menu_quickresponses"], ::handleQuickResponsesMenu);
    //handle quick Vehicles
    registerMenu(game["menu_quickvehicles"], ::handleQuickVehiclesMenu);
    //handle quick requests
    registerMenu(game["menu_quickrequests"], ::handleQuickRequestsMenu);
}

handleMenuOpen(close, open)
{
    if(close == open)
        return;

    self closeMenu(close);
    self openMenu(open);
}

handleWeaponMenuOpen(close, open)
{
    if(close == open)
        return;

    self closeMenu(close);
    if(level.objective == "bel")
        self openMenu(game["menu_weapon_all"]);
    else if(self.pers["team"] == "allies")
        self openMenu(game["menu_weapon_allies"]);
    else if(self.pers["team"] == "axis")
        self openMenu(game["menu_weapon_axis"]);
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

    else if(response == "open")
        return;

}

handleTeamMenu(response, optional)
{

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
    }
}

handleWeaponMenu(response, weapon) //allow to pass in a weapon for custom menu handling
{

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

handleQuickCommandsMenu(response, optional)
{
    if(maps\mp\uox\_uox_debug::debug("info"))
        maps\mp\uox\_uox_debug::vsay_debug(game["menu_quickcommands"], response);
    else
        maps\mp\gametypes\_teams::quickcommands(response);
}

handleQuickStatementsMenu(response, optional)
{

    if(maps\mp\uox\_uox_debug::debug("info"))
        maps\mp\uox\_uox_debug::vsay_debug(game["menu_quickstatements"], response);
    else
        maps\mp\gametypes\_teams::quickstatements(response);
}

handleQuickResponsesMenu(response, optional)
{

    if(maps\mp\uox\_uox_debug::debug("info"))
        maps\mp\uox\_uox_debug::vsay_debug(game["menu_quickresponses"], response);
    else
        maps\mp\gametypes\_teams::quickresponses(response);
}

handleQuickVehiclesMenu(response, optional)
{

    if(maps\mp\uox\_uox_debug::debug("info"))
        maps\mp\uox\_uox_debug::vsay_debug(game["menu_quickvehicles"], response);
    else
        maps\mp\gametypes\_teams::quickvehicles(response);
}

handleQuickRequestsMenu(response, optional)
{

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
    handlers = maps\mp\uox\_uox_arrays::getValue(level.menuHandlers, menu);

    if(!isDefined(handlers))
    {
        handleUnknownMenu();
        return;
    }
    else
    {
        if((response == "open" || response == "close") && menu != game["menu_serverinfo"])
            return;
        //check response array for menu
        newmenu = maps\mp\uox\_uox_arrays::getValue(level.menuResponses, response);
        if(!isDefined(newmenu))
        {   //if there isn't a menu to open, handle menu choice
            for(i = 0; i < handlers.size; i++)
            {
                handler = handlers[i];
                optional = [[ handler ]](response, optional);
            }
        }
        else //open new menu
        {
            [[ newmenu[0] ]](menu, newmenu[1]);
        }
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


