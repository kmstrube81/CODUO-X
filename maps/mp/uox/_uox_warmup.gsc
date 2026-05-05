onPlayerConnect(entity)
{
	if(!level.doingReadyUp)
		return;
	
	self.readyState = "notready";
	self.doingReadyUp = true;
	
	self.statusicon = game["br_hudicons_allies_0"];
	self thread readyup(entity);
	
}

onPlayerDisconnect(entity)
{

	//level.readyQueue[entity].readyState = "disconnected";
	self.readyState = "disconnected";
	self.doingReadyUp = false;

	if(level.doingReadyUp)
		thread CheckServerReady();
}

doReadyUp(switchingSides)
{
	if(level.doingReadyUp)
		return;
		
	level.warmup = true;
	
	level.doingReadyUp = true; //mark the ready up as in progress
	
	level.playersready = false; //mark all players as not ready
	
	//create ready up hud
	maps\mp\uox\_uox_hud::createReadyUpHUD(switchingSides);
	//level.readyQueue = [];
	
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		lpselfnum = player getEntityNumber();
		player.statusicon = game["br_hudicons_allies_0"];
		
		//level.readyQueue[lpselfnum] = player;
		player.readyState = "notready";
		player.doingReadyUp = false;

		player thread readyup(lpselfnum, switchingSides);
	}
	
	waitUntilReady();
	
	//ready up finished
	maps\mp\uox\_uox_hud::deleteReadyUpHUD();
	
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if ([[level.getVars]]("scr_battlerank"))
			player.statusicon = maps\mp\gametypes\_rank_gmi::GetRankStatusIcon(player);
		else
			player.statusicon = "";
	}
	
	level.doingReadyUp = false;
	//level.warmup = false; //let round end reset warmup flag
}

doWarmUp(switchingSides)
{
	if(level.doingReadyUp)
		return;
	
	level.warmup = true;
	
	level.doingReadyUp = true; //mark the ready up as in progress
	
	level.playersready = false; //mark all players as not ready
	
	if(level.uox_teamplay)
		readycount = [[level.getVars]]("scr_autoreadycount") * 2;
	else
		readycount = [[level.getVars]]("scr_autoreadycount");
	
	//create ready up hud
	maps\mp\uox\_uox_hud::createWarmUpHUD(readycount, [[level.getVars]]("scr_autoreadytime"), switchingSides);
	//level.readyQueue = [];
	
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		lpselfnum = player getEntityNumber();
		player.statusicon = game["br_hudicons_allies_0"];
		
		//level.readyQueue[lpselfnum] = player;
		player.readyState = "notready";
		player.doingReadyUp = false;

		player thread readyup(lpselfnum, switchingSides);
	}
	
	waitUntilWarmup();
	
	//ready up finished
	maps\mp\uox\_uox_hud::deleteWarmUpHUD();

	level.doingReadyUp = false;
	
	//level.warmup = false; //let round reset reset warmup flag
}

waitUntilReady()
{
	wait 0;
	
	if([[level.getVars]]("scr_autoreadytime"))
	{
		maps\mp\uox\_uox_hud::updateHUDMainClock([[level.getVars]]("scr_autoreadytime"));
		startTime = getTime();
	}

	while(!level.playersready)
	{
		notready = 0;

		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			player = players[i];

			lpselfnum = player getEntityNumber();
			//if (level.readyQueue[lpselfnum].readyState == "notready")
			if(player.readyState == "notready")
			{
				notready++;
			}
		}

		level.notReadyHUD = maps\mp\uox\_uox_hud::updateHUDElement(level.notReadyHUD, "number", notready);

		wait 1;
		
		if([[level.getVars]]("scr_autoreadycount"))
		{
			if((level.exist["allies"] >= [[level.getVars]]("scr_autoreadycount") && level.exist["axis"] >= [[level.getVars]]("scr_autoreadycount")) || (level.exist["2players"] >= [[level.getVars]]("scr_autoreadycount")))
				level.playersready = 1;
		}
		if(isDefined(startTime))
		{
			if((getTime() - startTime) / 1000.0 > [[level.getVars]]("scr_autoreadytime"))
				level.playersready = 1;
		}
		
	}

	maps\mp\uox\_uox_hud::deleteReadyUpHUD();
}

waitUntilWarmup()
{
	wait 0;
	
	if([[level.getVars]]("scr_autoreadytime"))
	{	
		maps\mp\uox\_uox_hud::updateHUDMainClock([[level.getVars]]("scr_autoreadytime"));
		startTime = getTime();
	}

	while(!level.playersready)
	{
		if(level.uox_teamplay)
		{
			alliesLeftToReady = [[level.getVars]]("scr_autoreadycount") - level.exist["allies"];
			if(alliesLeftToReady < 0) alliesLeftToReady = 0;
			axisLeftToReady = [[level.getVars]]("scr_autoreadycount") - level.exist["axis"];
			if(axisLeftToReady < 0) axisLeftToReady = 0;
			players = alliesLeftToReady + axisLeftToReady;
		}
		else
			players = level.exist["2players"];
		
		level.notReadyHUD = maps\mp\uox\_uox_hud::updateHUDElement(level.notReadyHUD, "number", players);

		wait 1;
		
		if([[level.getVars]]("scr_autoreadycount"))
		{
			if((level.exist["allies"] >= [[level.getVars]]("scr_autoreadycount") && level.exist["axis"] >= [[level.getVars]]("scr_autoreadycount")) || (level.exist["2players"] >= [[level.getVars]]("scr_autoreadycount")))
				level.playersready = true;
		}
		if(isDefined(startTime))
		{
			if((getTime() - startTime) / 1000.0 > [[level.getVars]]("scr_autoreadytime"))
				level.playersready = true;
		}
		if(![[level.getVars]]("scr_autoreadycount") && [[level.getVars]]("scr_autoreadytime") <= 0)
			level.playersready = true;
	}

	maps\mp\uox\_uox_hud::deleteWarmUpHUD();
}

readyup(entity, switchingSides)
{
	wait 0; // required to let any notify happen before this happens
	
	if(!isDefined(switchingSides))
		switchingSides = false;
	
	if(isDefined(self.pers["isBot"]))
	{
		self.doingReadyUp = true;
		self.statusicon = game["br_hudicons_allies_4"];
		self.readyState = "ready";
		return;
	}
	
	if([[level.getVars]]("scr_warmupmode") == 2)
		self thread maps\mp\uox\_uox_hud::createPlayerReadyUpHUD(switchingSides);
	else
	{
		self thread maps\mp\uox\_uox_hud::createPlayerWarmUpHUD(switchingSides);
		return;
	}
	//playername = level.readyQueue[entity].name;
	playername = self.name;
	wait 1;
	
	while(!level.playersready)
	{
		self.doingReadyUp = true;
		if(self useButtonPressed() == true)
		{
			//if(level.readyQueue[entity].readyState == "notready")
			if(self.readyState == "notready")
			{
				//level.readyQueue[entity].readyState = "ready";
				self.readyState = "ready";
				self.statusicon = game["br_hudicons_allies_4"];
				iprintln(playername + "^2 is Ready");
				logPrint(playername + ";" + " is Ready Logfile;" + "\n");

				// change players hud to indicate player not ready
				self.readyHUD = maps\mp\uox\_uox_hud::updateHUDElementProperty(self.readyHUD, "color", (.73, .99, .73));
				self.readyHUD = maps\mp\uox\_uox_hud::updateHUDElement(self.readyHUD, "text", game["readyText"]);

				wait 1;
				thread CheckServerReady();
			}
			else
			{
				self.readyState = "ready";
				self.statusicon = game["br_hudicons_allies_0"];
				iprintln(playername + "^1 is Not Ready");
				logPrint(playername + ";" + " is Not Ready Logfile;" + "\n");

				// change players hud to indicate player not ready
				self.readyHUD = maps\mp\uox\_uox_hud::updateHUDElementProperty(self.readyHUD, "color", (1, .84, .84));
				self.readyHUD = maps\mp\uox\_uox_hud::updateHUDElement(self.readyHUD, "text", game["notReadyText"]);
				wait 1;
			}
			while (self useButtonPressed() == true)
				wait .05;
		}
		else
			wait .1;
	}
	
	self maps\mp\uox\_uox_hud::deletePlayerReadyUpHUD();
}

CheckServerReady()
{
	wait 0.1;
	
	checkready = true;
	
	//check if all players are doing ready
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		lpselfnum = player getEntityNumber();

		if (!isdefined(player.doingReadyUp) )
		{
			//level.readyQueue[lpselfnum] = player;
			player.readyState = "notready";
			player.doingReadyUp = false;
		}
			
		if (!player.doingReadyUp)
		{
			player thread readyup(lpselfnum);
			return;
		}

		//Player is looping, now see if he is ready
		//if (level.readyQueue[lpselfnum].readyState == "notready")
		if(player.readyState == "notready")
			checkready = false;
	}

	// See if checkready is still true
	if (checkready == true)
		level.playersready = true;
}