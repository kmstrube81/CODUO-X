/*
	Search and Destroy
	Attackers objective: Bomb one of 2 positions
	Defenders objective: Defend these 2 positions / Defuse planted bombs
	Round ends:	When one team is eliminated, bomb explodes, bomb is defused, or roundlength time is reached
	Map ends:	When one team reaches the score limit, or time limit or round limit is reached
	Respawning:	Players remain dead for the round and will respawn at the beginning of the next round

	Level requirements
	------------------
		Allied Spawnpoints:
			classname		mp_searchanddestroy_spawn_allied
			Allied players spawn from these. Place atleast 16 of these relatively close together.

		Axis Spawnpoints:
			classname		mp_searchanddestroy_spawn_axis
			Axis players spawn from these. Place atleast 16 of these relatively close together.

		Spectator Spawnpoints:
			classname		mp_searchanddestroy_intermission
			Spectators spawn from these and intermission is viewed from these positions.
			Atleast one is required, any more and they are randomly chosen between.

		Bombzone A:
			classname		trigger_multiple
			targetname		bombzone_A
			script_gameobjectname	bombzone
			This is a volume of space in which the bomb can planted. Must contain an origin brush.
		
		Bombzone B:
			classname		trigger_multiple
			targetname		bombzone_B
			script_gameobjectname	bombzone
			This is a volume of space in which the bomb can planted. Must contain an origin brush.
			
		Bomb:
			classname		trigger_lookat
			targetname		bombtrigger
			script_gameobjectname	bombzone
			This should be a 16x16 unit trigger with an origin brush placed so that it's center lies on the bottom plane of the trigger.
			Must be in the level somewhere. This is the trigger that is used when defusing a bomb.
			It gets moved to the position of the planted bomb model.
					
	Level script requirements
	-------------------------
		Team Definitions:
			game["allies"] = "american";
			game["axis"] = "german";
			This sets the nationalities of the teams. Allies can be american, british, or russian. Axis can be german.
	
			game["attackers"] = "allies";
			game["defenders"] = "axis";
			This sets which team is attacking and which team is defending. Attackers plant the bombs. Defenders protect the targets.

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

		Exploder Effects:
			Setting script_noteworthy on a bombzone trigger to an exploder group can be used to trigger additional effects.

	Note
	----
		Setting "script_gameobjectname" to "bombzone" on any entity in a level will cause that entity to be removed in any gametype that
		does not explicitly allow it. This is done to remove unused entities when playing a map in other gametypes that have no use for them.
*/

/*QUAKED mp_searchanddestroy_spawn_allied (0.0 1.0 0.0) (-16 -16 0) (16 16 72)
defaultmdl="xmodel/airborne"
Allied players spawn randomly at one of these positions at the beginning of a round.
*/

/*QUAKED mp_searchanddestroy_spawn_axis (1.0 0.0 0.0) (-16 -16 0) (16 16 72)
defaultmdl="xmodel/wehrmacht_soldier"
Axis players spawn randomly at one of these positions at the beginning of a round.
*/

/*QUAKED mp_searchanddestroy_intermission (1.0 0.0 1.0) (-16 -16 -16) (16 16 16)
Intermission is randomly viewed from one of these positions.
Spectators spawn randomly at one of these positions.
*/

UOX_Main()
{
	level.getVars = maps\mp\uox\_uox_vars::getVars;
	
	maps\mp\uox\_uox_vars::varDef("scr", "respawn_mode", "string", false, "obj", "", "", "Respawn Mode");
	maps\mp\uox\_uox_vars::varDef("scr", "spawn_type", "string", false,
											"random", "", "", "Respawn Type");
	maps\mp\uox\_uox_vars::varDef("scr", "spawnpoints", "string", false, "sd", "", "", "Spawnpoints");
	maps\mp\uox\_uox_vars::varDef("scr", "reinforcements", "int", false, 1, -1, 999, "Reinforcements");

	/* init spawns */
	if(!maps\mp\uox\_uox_respawns::initSpawns("sd"))
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

	allowed[0] = "sd";
	allowed[1] = "bombzone";
	allowed[2] = "blocker";
	maps\mp\gametypes\_gameobjects::main(allowed);
	maps\mp\gametypes\_secondary_gmi::Initialize();
	level.objective = "bomb";
}