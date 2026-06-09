/*
	Behind Enemy Lines
	Number of Allies: The more people playing in the round the more Allies there will be. Currently the Allied:Axis radio is about 1:3-4
	Allied Objective: Kill as many German players as possible before being overrun. You gain more points the longer you stay alive
	Axis objective: Hunt down Allied players
	Map ends:	When a player reaches the score limit, or time limit is reached
	Respawning: 	Axis respawn as Axis when they die, and Allied players respawn as Axis when they die
			An Axis who kills an Allied player will take that Allied players spot on the Allied team
			Uses TDM spawnpoints so all TDM maps automatically support this gametype

	Level requirements
	------------------
		Spawnpoints:
			classname		mp_teamdeathmatch_spawn
			All players spawn from these. The spawnpoint chosen one is dependent on the current locations of teammates and enemies
			at the time of spawn. Players generally spawn away from enemies.

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

    respawn_mode = maps\mp\uox\_uox_vars::varDef("scr", "respawn_mode", "string", false, "bel", "", "", "Respawn Mode");
	maps\mp\uox\_uox_vars::varDef("scr", "spawn_type", "string", false,
											"middle", "", "", "Respawn Type");
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

	allowed[0] = "bel";
    maps\mp\gametypes\_gameobjects::main(allowed);
	maps\mp\gametypes\_secondary_gmi::Initialize();
    level.objective = "bel";
}
