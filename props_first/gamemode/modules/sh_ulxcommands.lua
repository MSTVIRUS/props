--[[
				  _________.__    .__                                  
				 /   _____/|  |__ |__| ____ ___.__. ____  ______  _  __
				 \_____  \ |  |  \|  |/    <   |  |/ ___\/  _ \ \/ \/ /
				 /        \|   Y  \  |   |  \___  \  \__(  <_> )     / 
				/_______  /|___|  /__|___|  / ____|\___  >____/ \/\_/  
						\/      \/        \/\/         \/              

		Adds propkilling commands to ULX
]]--

if not ulx then return end

-- add ulx stopfight command for admins

-- add ulx forfeit command for battlers

-- add !putteam

local CATEGORY_NAME = "Propkill"

function ulx.pkCleanup( calling_ply )
	util.CleanUpMap( true )
	
	ulx.fancyLogAdmin( calling_ply, "#A cleaned up the map!" )
end
local pkCleanup = ulx.command( CATEGORY_NAME, "ulx pkcleanup", ulx.pkCleanup, "!cleanup" )
pkCleanup:defaultAccess( ULib.ACCESS_ADMIN )
pkCleanup:help( "Clean up the map." )

function ulx.pkStopFight( calling_ply )
	if not PROPKILL.Battling then return end

	PROPKILL.EndFight()
	
	ulx.fancyLogAdmin( calling_ply, "#A has stopped the fight!" )
end
local pkStopFight = ulx.command( CATEGORY_NAME, "ulx stopfight", ulx.pkStopFight, "!stopfight" )
pkStopFight:defaultAccess( ULib.ACCESS_ADMIN )
pkStopFight:help( "Stops the current fight" )

function ulx.pkForfeit( calling_ply )
	if not PROPKILL.Battling then return end
	
	PROPKILL.EndFight()
	
	ulx.fancyLogAdmin( calling_ply, "#A has forfeited the fight!" )
end
local pkForfeit = ulx.command( CATEGORY_NAME, "ulx forfeit", ulx.pkForfeit, "!forfeit" )
pkForfeit:defaultAccess( ULib.ACCESS_ALL )
pkForfeit:help( "Forfeits the current fight" )

if SERVER then
	util.AddNetworkString( "props_GrabIP" )
else
	net.Receive( "props_GrabIP", function()
		local ip = net.ReadString()
		
		SetClipboardText( ip )
	end )
end
function ulx.pkGrabIP( calling_ply, target_plys )
	if #target_plys == 0 then return end
	
	if #target_plys > 1 then
		calling_ply:PrintMessage( HUD_PRINTCONSOLE, "\n\n    PLAYER IPS HERE:::" )
		
		for i=1,#target_plys do
			calling_ply:PrintMessage( HUD_PRINTCONSOLE, target_plys[ i ]:Nick() .. " - " .. target_plys[ i ]:IPAddress() )
		end
		
		calling_ply:ChatPrint( "You grabbed the IP from more than one person.\nThe IPs have been printed to your console." )
	else
		net.Start( "props_GrabIP" )
			net.WriteString( target_plys[ 1 ]:IPAddress() )
		net.Send( calling_ply )
		calling_ply:Notify( NOTIFY_GENERIC, 6, target_plys[ 1 ]:Nick() .. "'s IP has been copied to your clipboard", true )
	end
	
	ulx.fancyLogAdmin( calling_ply, true, "#A copied the IP of #T", target_plys )
end
local pkGrabIP = ulx.command( CATEGORY_NAME, "ulx grabip", ulx.pkGrabIP, "!grabip" )
pkGrabIP:addParam{ type=ULib.cmds.PlayersArg }
pkGrabIP:defaultAccess( ULib.ACCESS_SUPERADMIN )
pkGrabIP:help( "Gets the IP of your target(s)" )

function ulx.pkRespawn( calling_ply, target_plys )
	for k,v in pairs( target_plys ) do
		v:Spawn()
	end
	
	ulx.fancyLogAdmin( calling_ply, "#A respawned #T", target_plys )
end
local pkRespawn = ulx.command( CATEGORY_NAME, "ulx respawn", ulx.pkRespawn, "!respawn" )
pkRespawn:addParam{ type=ULib.cmds.PlayersArg }
pkRespawn:defaultAccess( ULib.ACCESS_ADMIN )
pkRespawn:help( "Respawns specified target(s)" )


local teamList = { "spectator", "deathmatch", "red", "blue" }
function ulx.pkSetTeam( calling_ply, target_plys, team )
	if #target_plys == 0 then return end
	if not team or not PROPKILL.ValidTeams[ team ] then
		team = "spectator"
	end
	
	local oldteam = team
	team = PROPKILL.ValidTeams[ team ]
	
	for k,v in pairs( target_plys ) do
		v:SetTeam( team )
		v:Spawn()
	end
	
	ulx.fancyLogAdmin( calling_ply, "#A set the team of #T to #s", target_plys, oldteam )
end
local pkSetTeam = ulx.command( CATEGORY_NAME, "ulx setteam", ulx.pkSetTeam, "!setteam" )
pkSetTeam:addParam{ type=ULib.cmds.PlayersArg }
pkSetTeam:addParam{ type=ULib.cmds.StringArg, hint="team", completes=teamList, ULib.cmds.restrictToCompletes }
pkSetTeam:defaultAccess( ULib.ACCESS_ADMIN )
pkSetTeam:help( "Sets the target(s) to a certain team" )


function ulx.pkSetKills( calling_ply, target_plys, amount )
	-- set the permanent frags of the player(s)
	for k,v in pairs( target_plys ) do
		v:SetTotalFrags( amount, true )
	end
	
	ulx.fancyLogAdmin( calling_ply, "#A set the total kills of #T to #i", target_plys, amount )
end
local pkSetKills = ulx.command( CATEGORY_NAME, "ulx setkills", ulx.pkSetKills, "!setkills" )
pkSetKills:addParam{ type=ULib.cmds.PlayersArg }
pkSetKills:addParam{ type=ULib.cmds.NumArg, min=0, max=999999, hint="amount", ULib.cmds.round }
pkSetKills:defaultAccess( ULib.ACCESS_SUPERADMIN )
pkSetKills:help( "Sets the target(s) permanent kills" )

--[[function ulx.pkSetDeaths( calling_ply, target_plys )
	-- set the permanent deaths of the player(s)
end
]]