defineMenus()
{
    game["menu_serverinfo"] = getServerInfoMenu();
    game["menu_team"] = "team_" + game["allies"] + game["axis"];
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

handleMenuResponse(menu, response)
{
    if(menu == game["menu_serverinfo"] && response == "close")
    {
        self.pers["skipserverinfo"] = true;
        self openMenu(game["menu_team"]);
    }

    if(response == "open" || response == "close")
        return;

    if(menu == game["menu_team"])
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
            if ( maps\mp\gametypes\_teams::isweaponavailable(self.pers["team"]) )
            {
                if(self.pers["team"] == "allies")
                {
                    menu = game["menu_weapon_allies"];
                }
                else
                {
                    menu = game["menu_weapon_axis"];
                }
            
                self setClientCvar("ui_weapontab", "1");
                self openMenu(menu);
            }
            else
            {
                self setClientCvar("ui_weapontab", "0");
                self maps\mp\uox\_uox_respawns::menu_spawn("none");
            }
    
            self setClientCvar("g_scriptMainMenu", menu);
            break;

        case "spectator":
            if (level.lockteams)
                break;
            if(self.pers["team"] != "spectator")
            {
                if(isAlive(self))
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
    else if(menu == game["menu_weapon_allies"] || menu == game["menu_weapon_axis"])
    {
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
            
        weapon = self maps\mp\gametypes\_teams::restrict(response);

        if(weapon == "restricted")
        {
            self openMenu(menu);
            return;
        }

        self.pers["selectedweapon"] = weapon;

        if(isDefined(self.pers["weapon"]) && self.pers["weapon"] == weapon)
            return;

        maps\mp\uox\_uox_respawns::menu_spawn(weapon);
    }
    else if(menu == game["menu_viewmap"])
    {
        switch(response)
        {
        case "team":
            self openMenu(game["menu_team"]);
            break;

        case "weapon":
            if(self.pers["team"] == "allies")
                self openMenu(game["menu_weapon_allies"]);
            else if(self.pers["team"] == "axis")
                self openMenu(game["menu_weapon_axis"]);
            break;

        case "callvote":
            self openMenu(game["menu_callvote"]);
            break;
        }
    }
    else if(menu == game["menu_callvote"])
    {
        switch(response)
        {
        case "team":
            self openMenu(game["menu_team"]);
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
        }
    }
    else if(maps\mp\uox\_uox_debug::debug("info"))
        maps\mp\uox\_uox_debug::vsay_debug(menu, response);
    else if(menu == game["menu_quickcommands"])
        maps\mp\gametypes\_teams::quickcommands(response);
    else if(menu == game["menu_quickstatements"])
        maps\mp\gametypes\_teams::quickstatements(response);
    else if(menu == game["menu_quickresponses"])
        maps\mp\gametypes\_teams::quickresponses(response);
    else if(menu == game["menu_quickvehicles"])
        maps\mp\gametypes\_teams::quickvehicles(response);
    else if(menu == game["menu_quickrequests"])
        maps\mp\gametypes\_teams::quickrequests(response);
}

getAutoAssign()
{
	
	if(level.uox_teamplay)
	{
		numonteam["allies"] = 0;
		numonteam["axis"] = 0;

		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
		
			if(!isDefined(player.pers["team"]) || player.pers["team"] == "spectator" || player == self)
				continue;

			numonteam[player.pers["team"]]++;
		}
		
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
