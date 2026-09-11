/*
	Domination
	Objective: 	Each team needs to try and capture all of the flags.  Multiple people capturing a flag will make the capture
			happen quicker.
	Round ends:	When one team captures all of the flags, or roundlength time is reached
	Map ends:	When one team reaches the score limit, or time limit or round limit is reached
	Respawning:	Players will respawn in waves after a given time.  As flags are captured by a team they can open up new
			spawn points.  As flags are lost a team can lose spawn points.

	Level requirements
	------------------
		Allied Spawnpoints:
			classname		mp_uo_spawn_allies
			Allied players spawn from these. Place near the main allied base/side.

			classname		mp_uo_spawn_allies_secondary
			Allied players spawn from these as the related flags are captured. Place near the associated flags.
			The flag trigger that these are associated with should target the spawn.

		Axis Spawnpoints:
			classname		mp_uo_spawn_axis
			Axis players spawn from these. Place near the main allied base/side.

			classname		mp_uo_spawn_axis_secondary
			Axis players spawn from these as the related flags are captured. Place near the associated flags.
			The flag trigger that these are associated with should target the spawn.

		Spectator Spawnpoints:
			classname		mp_uo_intermission
			Spectators spawn from these and intermission is viewed from these positions.
			Atleast one is required, any more and they are randomly chosen between.

		Capture Area(s):
			classname		trigger_multiple
			targetname		flag# (where # is the number of the flag)
			target			Optionally can target spawn points.  When this flag is held then the spawn points will
						be available.
			script_gameobjectname	dom
			There should be one of these for each of the flags.

		Neutral Flag Model(s):
			classname		script_model
			script_gameobjectname	dom
			model			Model file for the neutral flag.
			targetname		flag#_neutral.  The number should be the same as the trigger_multiple it is associtated with

		Allies Flag Model(s):
			classname		script_model
			script_gameobjectname	dom
			model			Model file for the neutral flag.
			targetname		flag#_allies.  The number should be the same as the trigger_multiple it is associtated with

		Axis Flag Model(s):
			classname		script_model
			script_gameobjectname	dom
			model			Model file for the neutral flag.
			targetname		flag#_axis.  The number should be the same as the trigger_multiple it is associtated with

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
			game["dom_layoutimage"] = "yourlevelname";  (or use game["layoutimage"] if no special map for this gametype is needed)
			This sets the image that is displayed when players use the "View Map" button in game.
			Create an overhead image of your map and name it "hud@layout_yourlevelname".
			Then move it to main\levelshots\layouts. This is generally done by taking a screenshot in the game.
			Use the outsideMapEnts console command to keep models such as trees from vanishing when noclipping outside of the map.

		Objective Text:
			game["dom_allies_obj_text"] = "Defeate the axis.";
			game["dom_axis_obj_text"] = "Defeate the allies.";
			game["dom_spectator_obj_text"] = "Help a team defeat the other";
			These set custom objective text. Otherwise default text is used.

	Note
	----
		Setting "script_gameobjectname" to "dom" on any entity in a level will cause that entity to be removed in any gametype that
		does not explicitly allow it. This is done to remove unused entities when playing a map in other gametypes that have no use for them.
*/

/*QUAKED mp_uo_spawn_allies (0.0 1.0 0.0) (-16 -16 0) (16 16 72)
defaultmdl="xmodel/airborne"
Allied players spawn randomly at one of these positions at the beginning of a round.
*/

/*QUAKED mp_uo_spawn_allies_secondary (0.0 1.0 0.0) (-16 -16 0) (16 16 72)
defaultmdl="xmodel/airborne"
Allied players spawn randomly at one of these positions at the beginning of a round.
*/

/*QUAKED mp_uo_spawn_axis (1.0 0.0 0.0) (-16 -16 0) (16 16 72)
defaultmdl="xmodel/wehrmacht_soldier"
Axis players spawn randomly at one of these positions at the beginning of a round.
*/

/*QUAKED mp_uo_spawn_axis_secondary (1.0 0.0 0.0) (-16 -16 0) (16 16 72)
defaultmdl="xmodel/wehrmacht_soldier"
Axis players spawn randomly at one of these positions at the beginning of a round.
*/

/*QUAKED mp_dom_intermission (1.0 0.0 1.0) (-16 -16 -16) (16 16 16)
Intermission is randomly viewed from one of these positions.
Spectators spawn randomly at one of these positions.
*/

UOX_Main()
{


    level.getVars = maps\mp\uox\_uox_vars::getVars;

    level.respawn_mode = maps\mp\uox\_uox_vars::varDef("scr", "respawn_mode", "string", false, "wave", "", "", "Respawn Mode");
    maps\mp\uox\_uox_vars::varDef("scr", "spawn_type", "string", false,
                                            "near_team", "", "", "Respawn Type");
    maps\mp\uox\_uox_vars::varDef("scr", "spawnpoints", "string", false, "uo", "", "", "Spawnpoints");
    maps\mp\uox\_uox_vars::varDef("scr", "reinforcements", "int", false, -1, -1, 999, "Reinforcements");

    /* init spawns */
    if(!maps\mp\uox\_uox_respawns::initSpawns("dom"))
    {
        maps\mp\gametypes\_callbacksetup::AbortLevel();
        return;
    }

	level.callbackStartGameType = maps\mp\uox\_uox_callbacks::Callback_StartGameType;
	level.callbackPlayerConnect = maps\mp\uox\_uox_callbacks::Callback_PlayerConnect;
	level.callbackPlayerDisconnect = maps\mp\uox\_uox_callbacks::Callback_PlayerDisconnect;
	level.callbackPlayerDamage = maps\mp\uox\_uox_callbacks::Callback_PlayerDamage;
	level.callbackPlayerKilled = maps\mp\uox\_uox_callbacks::Callback_PlayerKilled;

	maps\mp\gametypes\_callbacksetup::SetupCallbacks(); // Run this script upon load.

	allowed[0] = "flag_cap"; 
	allowed[1] = "dom"; 	
	maps\mp\gametypes\_gameobjects::main(allowed); // Take the "allowed" array and apply it to this script. which just deletes all of the objects that do not have script_objectname set to any of the allowed arrays. Ex. allowed[0].
    maps\mp\gametypes\_secondary_gmi::Initialize();
	
	level.objective = "commandpost";

}

