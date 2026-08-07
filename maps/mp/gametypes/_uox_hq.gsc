/*
	HQ
	Objective: 	Set up HQ at a radio and run the other teams points down to 0 by not allowing them to have a HQ
	Map ends:	When one teams score reaches 0, or time limit is reached
	Respawning:	No wait / Near teammates

	Level requirements
	------------------
		Spawnpoints:
			classname		mp_teamdeathmatch_spawn
			All players spawn from these. The spawnpoint chosen is dependent on the current locations of teammates and enemies
			at the time of spawn. Players generally spawn behind their teammates relative to the direction of enemies. 

		Spectator Spawnpoints:
			classname		mp_teamdeathmatch_intermission
			Spectators spawn from these and intermission is viewed from these positions.
			Atleast one is required, any more and they are randomly chosen between.

	Level script requirements
	-------------------------
		Team Definitions:
			game["allies"] = "american";
			game["axis"] = "german";
			This sets the nationalities of the teams. Allies can be american, british, or russian. Axis can be german.
	
		If using minefields or exploders:
			maps\mp\_load::main();
		
		Radio Position information:
			You can place the radios in your map file using a script_model, and targetname of "hqradio"
			
			If you can't put the script_models into the map file (you only have the bsp) you can spawn the radios into the
			map in the level script (see the official level scripts). Here is how you spawn them into the map via the script...
			
			if (getcvar("g_gametype") == "hq")
			{
				//spawn radio 1
				radio = spawn ("script_model", (0,0,0));
				radio.origin = (-1167, -18611, 64);
				radio.angles = (0, 82, 0);
				radio.targetname = "hqradio";
				
				//spawn radio 2
				radio = spawn ("script_model", (0,0,0));
				radio.origin = (111, -16064, 29);
				radio.angles = (353, 47, 16);
				radio.targetname = "hqradio";
			}
			
			and so on...
		
	Optional level script settings
	------------------------------
		Soldier Type and Variation:
			game["american_soldiertype"] = "airborne";
			game["american_soldiervariation"] = "normal";
			game["german_soldiertype"] = "wehrmacht";
			game["german_soldiervariation"] = "normal";
			This sets what models are used for each nationality on a particular map.
			
			Valid settings:
				american_soldiertype		airborne
				american_soldiervariation	normal, winter
				
				british_soldiertype		airborne, commando
				british_soldiervariation	normal, winter
				
				russian_soldiertype		conscript, veteran
				russian_soldiervariation	normal, winter
				
				german_soldiertype		waffen, wehrmacht, fallschirmjagercamo, fallschirmjagergrey, kriegsmarine
				german_soldiervariation		normal, winter

		Layout Image:
			game["layoutimage"] = "yourlevelname";
			This sets the image that is displayed when players use the "View Map" button in game.
			Create an overhead image of your map and name it "hud@layout_yourlevelname".
			Then move it to main\levelshots\layouts. This is generally done by taking a screenshot in the game.
			Use the outsideMapEnts console command to keep models such as trees from vanishing when noclipping outside of the map.
*/

UOX_Main()
{
	level.getVars = maps\mp\uox\_uox_vars::getVars;

    level.respawn_mode = maps\mp\uox\_uox_vars::varDef("scr", "respawn_mode", "string", false, "hq", "", "", "Respawn Mode");
	maps\mp\uox\_uox_vars::varDef("scr", "spawn_type", "string", false,
											"hq", "", "", "Respawn Type");
	maps\mp\uox\_uox_vars::varDef("scr", "spawnpoints", "string", false, "tdm", "", "", "Spawnpoints");
	maps\mp\uox\_uox_vars::varDef("scr", "reinforcements", "int", false, -1, -1, 999, "Reinforcements");

	/* init spawns */
	if(!maps\mp\uox\_uox_respawns::initSpawns("tdm"))
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

	allowed[0] = "tdm";
	allowed[1] = "hq";
    maps\mp\gametypes\_gameobjects::main(allowed);
	maps\mp\gametypes\_secondary_gmi::Initialize();
    level.objective = "radios";
}
