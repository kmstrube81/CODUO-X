/*
	Retrieval
	Attackers objective: Retrieve the specified object and return it to the specified goal
	Defenders objective: Defend the specified object
	Round ends:	When one team is eliminated, all objectives are retrieved and taken to the goal, or roundlength time is reached
	Map ends:	When one team reaches the score limit, or time limit or round limit is reached
	Respawning:	Players remain dead for the round and will respawn at the beginning of the next round

	Level requirements
	------------------
		Allied Spawnpoints:
			classname		mp_retrieval_spawn_allied
			Allied players spawn from these. Place atleast 16 of these relatively close together.

		Axis Spawnpoints:
			classname		mp_retrieval_spawn_axis
			Axis players spawn from these. Place atleast 16 of these relatively close together.

		Spectator Spawnpoints:
			classname		mp_retrieval_intermission
			Spectators spawn from these and intermission is viewed from these positions.
			Atleast one is required, any more and they are randomly chosen between.

		Objective Item(s):
			classname		script_model
			targetname		retrieval_objective
			target			<Each must target their own pick up trigger, their own goal trigger, and atleast one item spawn location.>
			script_gameobjectname	retrieval
			script_objective_name	"Artillery Map" (example)
			There can be more than one of these for multiple objectives.

		Item Pick Up Trigger(s):
			classname		trigger_use
			script_gameobjectname	retrieval
			This trigger is used to pick up an objective item. This should be a 16x16 unit trigger with an origin brush placed
			so that it's center lies on the bottom plane of the trigger. Must be in the level somewhere. It is automatically
			moved to the position of the objective item targeting it.

		Item Spawn Location(s):
			classname		mp_retrieval_objective
			script_gameobjectname	retrieval
			An objective item targeting this will spawn at this location. If an objective item targets more than one it will randomly choose between them.
		
		Goal(s):
			classname		trigger_multiple
			script_gameobjectname	retrieval
			This is the area the attacking team must return an objective item to. Must contain an origin brush.

	Level script requirements
	-------------------------
		Team Definitions:
			game["allies"] = "american";
			game["axis"] = "german";
			This sets the nationalities of the teams. Allies can be american, british, or russian. Axis can be german.
	
			game["re_attackers"] = "allies";
			game["re_defenders"] = "axis";
			This sets which team is attacking and which team is defending. Attackers retrieve the objective items. Defenders protect them.

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

		Objective Text:
			game["re_attackers_obj_text"] = "Capture the code book";
			game["re_defenders_obj_text"] = "Defend the code book";
			game["re_spectator_obj_text"] = "Allies: Capture the code book\nAxis: Defend the code book";
			These set custom objective text. Otherwise default text is used.

	Note
	----
		Setting "script_gameobjectname" to "retrieval" on any entity in a level will cause that entity to be removed in any gametype that
		does not explicitly allow it. This is done to remove unused entities when playing a map in other gametypes that have no use for them.
*/

/*QUAKED mp_retrieval_spawn_allied (0.5 0.0 1.0) (-16 -16 0) (16 16 72)
Allied players spawn randomly at one of these positions at the beginning of a round.
*/

/*QUAKED mp_retrieval_spawn_axis (1.0 0.0 0.5) (-16 -16 0) (16 16 72)
Axis players spawn randomly at one of these positions at the beginning of a round.
*/

/*QUAKED mp_retrieval_intermission (0.0 0.5 1.0) (-16 -16 -16) (16 16 16)
Intermission is randomly viewed from one of these positions.
Spectators spawn randomly at one of these positions.
*/

/*QUAKED mp_retrieval_objective (0.0 0.5 1.0) (-8 -8 -8) (8 8 8)
The objective item will spawn randomly at one of these if the objective item targets it.
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

	allowed[0] = "re";
	allowed[1] = "retrieval";
	maps\mp\gametypes\_gameobjects::main(allowed);
	maps\mp\gametypes\_secondary_gmi::Initialize();
	level.objective = "retrieval";

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
		players[i].objs_held = 0;

}

	
