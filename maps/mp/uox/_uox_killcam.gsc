killcam(attackerNum, attackerGUID, attackerTeam, attackerName, delay)
{
	
	self endon("spawned");

	// killcam
	if(attackerNum < 0)
		return;
	
	if([[level.getVars]]("scr_final_killcam"))
	{
		level.finalKillcamTime = getTime();
		level.finalKillcamSpectatorClient = attackerNum;
		level.finalKillcamAttacker = attackerName;
		level.finalKillcamAttackerGUID = attackerGUID;
		level.finalKillcamAttackerTeam = attackerTeam;
		level.finalKillcamDelay = delay;
	}
	
	self.sessionstate = "spectator";
	self.spectatorclient = attackerNum;
	self.archivetime = delay + 7;
	
	// wait till the next server frame to allow code a chance to update archivetime if it needs trimming
	wait 0.05;

	if(self.archivetime <= delay)
	{
		self.spectatorclient = -1;
		self.archivetime = 0;
		self.sessionstate = "dead";
		
		self thread maps\mp\uox\_uox_respawns::respawn();
		return;
	}

	doKillCam(&"MPSCRIPT_KILLCAM", [[level.getVars]]("scr_forcerespawn") != 1,
		self.archivetime - delay);
	
	self.sessionstate = "dead";
	self thread maps\mp\uox\_uox_respawns::respawn();
}

doKillCam(kcTitle, doSkipText, kcTimer, extradelay)
{
	if(!isDefined(extradelay))
		extradelay = 0;
	options = [];
	options["archived"] = false;
	options["x"] = 0;
	options["y"] = 0;
	options["alpha"] = 0.5;
	options["width"] = 640;
	options["height"] = 112;
	maps\mp\uox\_uox_hud::updateClientHUDElement("kc_topbar", "shader",  "black", options);
	
	options["y"] = 368;
	maps\mp\uox\_uox_hud::updateClientHUDElement("kc_bottombar", "shader", "black", options);

	options = [];
	options["archived"] = false;
	options["x"] = 320;
	options["y"] = 40;
	options["alignX"] = "center";
	options["alignY"] = "middle";
	options["sort"] = 2;
	options["fontscale"] = 3.5;
	maps\mp\uox\_uox_hud::updateClientHUDElement("kc_title", "text", kcTitle, options);

	if ( doSkipText )
	{
		options["y"] = 70;
		options["fontscale"] = 1.0;
		options["sort"] = 1;
		maps\mp\uox\_uox_hud::updateClientHUDElement("kc_skiptext", "text",
			game["respawnText"], options);
	}
	
	options["y"] = 428;
	options["fontscale"] = 3.5;
	maps\mp\uox\_uox_hud::updateClientHUDElement("kc_timer", "tenthsTimer", kcTimer, options);
	
	self thread spawnedKillcamCleanup();
	self thread waitSkipKillcamButton();
	self thread waitKillcamTime(extradelay);
	self waittill("end_killcam");

	self removeKillcamElements();

	self.spectatorclient = -1;
	self.archivetime = 0;

}

waitKillcamTime(extradelay)
{
	self endon("end_killcam");

	wait(self.archivetime - extradelay - 0.05);
	self notify("end_killcam");
}

waitSkipKillcamButton()
{
	self endon("end_killcam");

	while(self useButtonPressed())
		wait .05;

	while(!(self useButtonPressed()))
		wait .05;

	self notify("end_killcam");
}

removeKillcamElements()
{
	maps\mp\uox\_uox_hud::deleteClientHUDElement("kc_topbar");
	maps\mp\uox\_uox_hud::deleteClientHUDElement("kc_bottombar");
	maps\mp\uox\_uox_hud::deleteClientHUDElement("kc_title");
	maps\mp\uox\_uox_hud::deleteClientHUDElement("kc_skiptext");
	maps\mp\uox\_uox_hud::deleteClientHUDElement("kc_timer");
}

spawnedKillcamCleanup()
{
	self endon("end_killcam");

	self waittill("spawned");
	self removeKillcamElements();
}

finalKillcamListener()
{
	level waittill("postround");
	level.didFinalKillcam = true;
	
	if(!isDefined(level.finalKillcamTime))
	{
		level notify("end_finalkillcam");
		return; //if no defined killcam data just abort
	}
	
	level.finalKillcamTime = (getTime() - level.finalKillcamTime) / 1000;
	
	logPrint("A;" + level.finalKillcamAttackerGUID + ";" + level.finalKillcamSpectatorClient + ";" +
		level.finalKillcamAttackerTeam + ";" + level.finalKillcamAttacker + ";" +
		"final_killcam" + "\n");

	// wait till the next server frame to allow code a chance to update archivetime if it needs trimming
	wait 0.05;
	
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{	
		player = players[i];
		
		player notify("end_killcam");
	
		if(player.sessionstate != "dead")
		{
			currentorigin = self.origin;
			currentangles = self.angles;
			level.specmode = "death";
			
			if(!isDefined(currentorigin) || !isDefined(currentangles))
				player thread maps\mp\uox\_uox_respawns::spawnSpectator();
			else
				player thread maps\mp\uox\_uox_respawns::spawnSpectator(currentorigin + (0, 0, 60),
				currentangles);
		}
		
		player thread doFinalKillcam();	
	}
	wait 9;
	level notify("end_finalkillcam");
}

doFinalKillcam()
{
	self endon("spawned");

	self.sessionstate = "spectator";
	self.spectatorclient = level.finalKillcamSpectatorClient;
	delay = level.finalKillcamDelay + level.finalKillcamTime;
	self.archivetime = delay + 7;
	extradelay = delay - 2;

	maps\mp\gametypes\_teams::SetKillcamSpectatePermissions();

	// wait till the next server frame to allow code a chance to update archivetime if it needs trimming
	wait 0.05;

	if(self.archivetime <= delay)
	{
		self.spectatorclient = -1;
		self.archivetime = 0;
	
		maps\mp\gametypes\_teams::SetSpectatePermissions();
		return;
	}
	doKillCam(game["finalKillcamText"], false, self.archivetime - delay, extradelay);
	
	maps\mp\gametypes\_teams::SetSpectatePermissions();
	
}