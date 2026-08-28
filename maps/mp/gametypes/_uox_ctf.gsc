UOX_Main() // Starts when map is loaded.
{
    level.getVars = maps\mp\uox\_uox_vars::getVars;

    level.respawn_mode = maps\mp\uox\_uox_vars::varDef("scr", "respawn_mode", "string", false, "spawndelay", "", "", "Respawn Mode");
	maps\mp\uox\_uox_vars::varDef("scr", "spawn_type", "string", false,
											"near_team", "", "", "Respawn Type");
	maps\mp\uox\_uox_vars::varDef("scr", "spawnpoints", "string", false, "uo", "", "", "Spawnpoints");
	maps\mp\uox\_uox_vars::varDef("scr", "reinforcements", "int", false, -1, -1, 999, "Reinforcements");

    /* init spawns */
	if(!maps\mp\uox\_uox_respawns::initSpawns("ctf"))
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

	allowed[0] = "ctf";

    maps\mp\gametypes\_gameobjects::main(allowed);
	maps\mp\gametypes\_secondary_gmi::Initialize();
    level.objective = "ctf";

}
