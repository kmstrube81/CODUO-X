/* THIS FILE IS USED TO SUPPORT DYNAMIC MOD LOADING PER GAMETYPE
   TO CHANGE WHAT MOD LOADS FOR EACH GAMETYPE, ADD THE PATH TO
   THE MAIN FUNC OF THE GAMETYPE GSC. AUDIO VISUAL MODS SUCH AS
   NEW SKINS OR SOUND EFFECTS WILL STILL LOAD OF COURSE */
modtype(gt)
{

    game["mods"] = maps\mp\uox\_uox_arrays::superArray();

	switch(gt)
	{
		//UOX DEATHMATCH
        case "dm":
            //register gametype logic here
			registerGametype( maps\mp\gametypes\_uox_dm::UOX_Main );
            //register mods here - first agurement is mod init function, second argument is name - can not be "main"
            registerMod( );
            break;
		//UOX TEAM DEATHMATCH
		case "tdm":
			//register gametype logic here
			registerGametype( maps\mp\gametypes\_uox_tdm::UOX_Main );
            //register mods here - first agurement is mod init function, second argument is name - can not be "main"
            registerMod( );
            break;
        //UOX BEHIND ENEMY LINES
        case "bel":
            //register gametype logic here
			registerGametype( maps\mp\gametypes\_uox_bel::UOX_Main );
            //register mods here - first agurement is mod init function, second argument is name - can not be "main" 
            registerMod( );
            break;
        //UOX RETRIEVAL
		case "re":
			//register gametype logic here
			registerGametype( maps\mp\gametypes\_uox_re::UOX_Main );
            //register mods here - first agurement is mod init function, second argument is name - can not be "main" 
            registerMod( );
            break;
        //UOX SEARCH AND DESTROY
		case "sd":
			//register gametype logic here
			registerGametype( maps\mp\gametypes\_uox_sd::UOX_Main );
            //register mods here - first agurement is mod init function, second argument is name - can not be "main" 
            registerMod( );
            break;
        //UOX HEADQUARTERS
		case "hq":
			//register gametype logic here
			registerGametype( maps\mp\gametypes\_uox_hq::UOX_Main );
            //register mods here - first agurement is mod init function, second argument is name - can not be "main" 
            registerMod( );
            break;
        //UOX DOMINATION
		case "dom":
			//register gametype logic here
			registerGametype( maps\mp\gametypes\_uox_dom::UOX_Main );
            //register mods here - first agurement is mod init function, second argument is name - can not be "main"
            registerMod( );
            break;
        //UOX CAPTURE THE FLAG
		case "ctf":
			//register gametype logic here
			registerGametype( maps\mp\gametypes\_uox_dm::UOX_Main );
            //register mods here - first agurement is mod init function, second argument is name - can not be "main"
            registerMod();
            break;
        case "bas":
            //register gametype logic here
			registerGametype( );
            //register mods here - first agurement is mod init function, second argument is name - can not be "main"
            registerMod( );
            break;
		default:
			//register gametype logic here
			registerGametype( maps\mp\gametypes\_uox_dm::UOX_Main );
            //register mods here - first agurement is mod init function, second argument is name - can not be "main" 
            registerMod( );
	}

}

registerGametype(main)
{
    if(!isDefined(main))
    {
        return;
    }

    game["mods"] = arrayPush( game["mods"], main, "main" );
}

registerMod(mod, name)
{
    if(!isDefined(mod))
        return;

    game["mods"] = arrayPush( game["mods"], mod, name );
}

