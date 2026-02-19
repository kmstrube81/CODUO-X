/* THIS FILE IS USED TO SUPPORT DYNAMIC MOD LOADING PER GAMETYPE
   TO CHANGE WHAT MOD LOADS FOR EACH GAMETYPE, ADD THE PATH TO
   THE MAIN FUNC OF THE GAMETYPE GSC. AUDIO VISUAL MODS SUCH AS
   NEW SKINS OR SOUND EFFECTS WILL STILL LOAD OF COURSE */
modtype(gt)
{
	switch(gt)
	{
		//UOX DEATHMATCH
		case "dm":
			return maps\mp\gametypes\_uox_dm::UOX_Main;
		case "tdm":
			return;
		case "bel":
			return;
		case "re":
			return;
		case "sd":
			return;
		case "hq":
			return;
		case "dom":
			return;
		case "ctf":
			return;
		case "bas":
			return;
		default:
			return;
	}

}