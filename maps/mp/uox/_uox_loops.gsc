/* *************************************************************************************************
**** initServerLoop()
****
**** USAGE: call threaded from callback Start Gametype, add functions to level.fastLoop to check
**** every frame, level.mediumLoop to check every 5 frames, or level.slowLoop to check once a second 
****  
************************************************************************************************* */
initServerLoop()
{
	level endon("round_ended");
	
	level.fastLoop = [];
	level.mediumLoop = [];
	level.slowLoop = [];
	
	//start Loop
	for(frame = 0; true; frame++)
	{
		if(frame == 20)
			frame = 0;
		if(frame == 0)
		{
			for(i = 0; i < level.slowLoop.size; i++)
			{
				level thread [[level.slowLoop[i]]]();
			}
		}
		if(frame % 5 == 0)
		{
			for(i = 0; i < level.mediumLoop.size; i++)
			{
				level thread [[level.mediumLoop[i]]]();
			}
		}
		for(i = 0; i < level.fastLoop.size; i++)
		{
			level thread [[level.fastLoop[i]]]();
		}
		wait 0.05;
	}
}

/* *************************************************************************************************
**** initPlayerLoop()
****
**** USAGE: call threaded from callback Start Gametype, add functions to level.fastLoop to check
**** every frame, level.mediumLoop to check every 5 frames, or level.slowLoop to check once a second 
****  
************************************************************************************************* */
initPlayerLoop()
{
	self endon("disconnect");
	
	self.fastLoop = [];
	self.mediumLoop = [];
	self.slowLoop = [];
	
	//start Loop
	for(frame = 0; true; frame++)
	{
		if(frame == 20)
			frame = 0;
		if(frame == 0)
		{
			for(i = 0; i < self.slowLoop.size; i++)
			{
				self thread [[self.slowLoop[i]]]();
			}
		}
		if(frame % 5 == 0)
		{
			for(i = 0; i < self.mediumLoop.size; i++)
			{
				self thread [[self.mediumLoop[i]]]();
			}
		}
		for(i = 0; i < self.fastLoop.size; i++)
		{
			self thread [[self.fastLoop[i]]]();
		}
		wait 0.05;
	}
}