--
-- Here we define a new panel table for the scoreboard. It basically consists 
-- of a header and a scrollpanel - into which the player lines are placed.
--
local PANEL = {}

hook.Add( "Initialize", "props_RegisterScoreboardArrow", function()
	timer.Simple(3, function()
		LocalPlayer().ScoreboardArrow = 1
	end)
end )


function PANEL:Init()
		-- 1440 x 900
	LocalPlayer().ScoreboardArrow = LocalPlayer().ScoreboardArrow or 1
	
	self:SetSize( 1300, 820 )
	self:SetPos( 70, 30 )
	self:MakePopup()
	self.Paint = function( self, w, h )
		--draw.RoundedBox( 0, 0, 0, w, h, Color( 5, 4, 17, 255 ) )
	end
	
	self.MainHeader = self:Add( "DPanel" )
	self.MainHeader:SetWide( 1300 )
	self.MainHeader:SetTall( 60 )
	self.MainHeader:Dock( TOP )
	self.MainHeader.Paint = function( self, w, h )
		--draw.RoundedBoxEx( 0, 0, 0, 1300, self:GetTall(), Color( 12, 17, 3, 255 ), true, true, true, true )
		--draw.RoundedBoxEx( 0, 1, 1, 1298, self:GetTall() - 2, Color( 53, 71, 51, 255 ), true, true, true, true )
		--draw.LinearGradient( 0, 0, self:GetWide(), self:GetTall(), color_white, color_black, GRADIENT_VERTICAL );
	end

	self.MainHeader.Text = self.MainHeader:Add( "DLabel" )
	self.MainHeader.Text:SetText( GetHostName() )
	self.MainHeader.Text:SetFont( "ScoreboardLarge" )
	self.MainHeader.Text:Dock( FILL )
	self.MainHeader.Text:SetTextColor( color_white )
	self.MainHeader.Text:SetContentAlignment( 5 )
	
	self.ContentGap = self:Add( "DPanel" )
	self.ContentGap:SetWide( 1300 )
	self.ContentGap:SetTall( 20 )
	self.ContentGap:Dock( TOP )
	self.ContentGap.Paint = function()
		--draw.RoundedBox( 0, 0, 0, 1300, 20, Color( 255, 0, 0, 20 ) )
	end
	
	self.ContentGap.ArrowLeft = self.ContentGap:Add( "DImageButton" )
	--self.ContentGap.ArrowLeft:SetText( "<==" )
	--self.ContentGap.ArrowLeft:SetFont( "ScoreboardLarge" )
	self.ContentGap.ArrowLeft:SetImage( "icon16/arrow_left.png" )
	self.ContentGap.ArrowLeft:SetWide( 24 )
	self.ContentGap.ArrowLeft:SetToolTip( "Select previous group of teams" )
	self.ContentGap.ArrowLeft:Dock( LEFT )
	self.ContentGap.ArrowLeft:SetTextColor( color_white )
	self.ContentGap.ArrowLeft.Paint = function() end
	self.ContentGap.ArrowLeft.DoClick = function()
		LocalPlayer().ScoreboardArrow = LocalPlayer().ScoreboardArrow - 1
		if not TeamsScoreboard[ LocalPlayer().ScoreboardArrow ] then
			LocalPlayer().ScoreboardArrow = #TeamsScoreboard
		end
		self:Update()
	end
	
	self.ContentGap.ArrowRight = self.ContentGap:Add( "DImageButton" )
	self.ContentGap.ArrowRight:SetImage( "icon16/arrow_right.png" )
	self.ContentGap.ArrowRight:SetWide( 24 )
	self.ContentGap.ArrowRight:SetToolTip( "Select next group of teams" )
	self.ContentGap.ArrowRight:Dock( RIGHT )
	self.ContentGap.ArrowRight:SetTextColor( color_white )
	self.ContentGap.ArrowRight.Paint = function() end
	self.ContentGap.ArrowRight.DoClick = function()
		LocalPlayer().ScoreboardArrow = LocalPlayer().ScoreboardArrow + 1
		if not TeamsScoreboard[ LocalPlayer().ScoreboardArrow ] then
			LocalPlayer().ScoreboardArrow = 1
		end
		self:Update()
	end
	
		-- This is where the scores will parent to
	self.Content = self:Add( "DPanel" )
	self.Content:SetWide( 1300 )
	self.Content:SetTall( 740 )
	self.Content:Dock( TOP )
	self.Content.Paint = function( self ) end
	
	self:Update()

end

function PANEL:Update()

	self.Content:Remove()
	
		-- This is where the scores will parent to
	self.Content = self:Add( "DPanel" )
	self.Content:SetWide( 1300 )
	self.Content:SetTall( 740 )
	self.Content:Dock( TOP )
	self.Content.Paint = function( self ) end

	local teamCount = #TeamsScoreboard[ LocalPlayer().ScoreboardArrow ]
	for i=1,#TeamsScoreboard[ LocalPlayer().ScoreboardArrow ] do
		local v = TeamsScoreboard[ LocalPlayer().ScoreboardArrow ][ i ]

		--PrintTable( v )
		
		--self.Content[ "Panel" .. team.GetName( v ) ] = self.Content:Add( "DPanel" )
		
			-- account for the padding between contents
		self.Content[ "Panel_" .. i ] = self.Content:Add( "DPanel" )
		self.Content[ "Panel_" .. i ]:SetWide( (1300 - (10 * (teamCount - 1))) / teamCount )
		self.Content[ "Panel_" .. i ]:SetTall( 740 )
		self.Content[ "Panel_" .. i ]:Dock( LEFT )
		self.Content[ "Panel_" .. i ].Paint = function( self )
			draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 31, 31, 31, 255 ) )--Color( 20, 20, 25, 255 ) )--5, 4, 17, 255 ) )
		end
		
		if teamCount != i then
			
			self.Content[ "Padding_" .. i ] = self.Content:Add( "DPanel" )
			self.Content[ "Padding_" .. i ]:SetWide( 10 )
			self.Content[ "Padding_" .. i ]:SetTall( 740 )
			self.Content[ "Padding_" .. i ]:Dock( LEFT )
			self.Content[ "Padding_" .. i ].Paint = function() end
			
		end
		
		self.Content[ "Panel_" .. i ].TeamHeader = self.Content[ "Panel_" .. i ]:Add( "DPanel" )
		self.Content[ "Panel_" .. i ].TeamHeader:SetWide( self.Content[ "Panel_" .. i ]:GetWide() )
		self.Content[ "Panel_" .. i ].TeamHeader:SetTall( 30 )
		self.Content[ "Panel_" .. i ].TeamHeader:Dock( TOP )
		self.Content[ "Panel_" .. i ].TeamHeader.Paint = function( self )
			--local col = team.GetColor( v )
			--col.a = 10
			--draw.LinearGradient( 0, 0, self:GetWide(), self:GetTall(), team.GetColor( v ), col, GRADIENT_VERTICAL )
			draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), team.GetColor( v ) )
		end
		
		local width = self.Content[ "Panel_" .. i ]:GetWide()
		for x=1,#InfoScoreboard do
			local y = InfoScoreboard[ x ]
		
			local id = y.id[ 1 ]
			
			if y.id[ 1 ] == "%team" then
				id = string.gsub( y.id[ 1 ], "%%team", string.upper( team.GetName( v ) .. " ( " .. #team.GetPlayers( v ) .. " )" ) )
			end
			
			surface.SetFont( "ScoreboardSmall" )
			if x == 1 then
				local scoresizew,scoresizeh = surface.GetTextSize( id )
				
				self.Content[ "Panel_" .. i ].TeamHeader[ x ] = self.Content[ "Panel_" .. i ].TeamHeader:Add( "DLabel" )
				self.Content[ "Panel_" .. i ].TeamHeader[ x ]:SetText( id )
				self.Content[ "Panel_" .. i ].TeamHeader[ x ]:SetFont( "ScoreboardSmall" )
				self.Content[ "Panel_" .. i ].TeamHeader[ x ]:SetTextColor( Color( 230, 230, 230, 255 ) )
				self.Content[ "Panel_" .. i ].TeamHeader[ x ]:SetPos( 5, self.Content[ "Panel_" .. i ].TeamHeader:GetTall() / 4 )
				self.Content[ "Panel_" .. i ].TeamHeader[ x ]:SetSize( width * y.space, scoresizeh )
			else
				local scoresizew,scoresizeh = surface.GetTextSize( id )
				local previousposx, previousposy = self.Content[ "Panel_" .. i ].TeamHeader[ x - 1 ]:GetPos()
				local previoussizew, previoussizeh = self.Content[ "Panel_" .. i ].TeamHeader[ x - 1 ]:GetSize()
				
				self.Content[ "Panel_" .. i ].TeamHeader[ x ] = self.Content[ "Panel_" .. i ].TeamHeader:Add( "DLabel" )
				self.Content[ "Panel_" .. i ].TeamHeader[ x ]:SetText( id )
				self.Content[ "Panel_" .. i ].TeamHeader[ x ]:SetFont( "ScoreboardSmall" )
				self.Content[ "Panel_" .. i ].TeamHeader[ x ]:SetTextColor( Color( 230, 230, 230, 255 ) )
				self.Content[ "Panel_" .. i ].TeamHeader[ x ]:SetPos( previoussizew + previousposx, self.Content[ "Panel_" .. i ].TeamHeader:GetTall() / 4 )
				self.Content[ "Panel_" .. i ].TeamHeader[ x ]:SetSize( width * y.space, scoresizeh )
				
					-- text wasn't centered below columns - now they will be.
				InfoScoreboard[ x ].text_sizew = scoresizew
				InfoScoreboard[ x ].text_posw = self.Content[ "Panel_" .. i ].TeamHeader[ x ]:GetPos()
			end
			
			--width = width - (width * y.size)
		end
			
			
		
		--[[self.Content[ "Panel_" .. i ].TeamHeader.Class = self.Content[ "Panel_" .. i ].TeamHeader:Add( "DLabel" )
		self.Content[ "Panel_" .. i ].TeamHeader.Class:SetText( string.upper( team.GetName( v ) ).. " ( " .. #team.GetPlayers( v ) .. " )" )
		self.Content[ "Panel_" .. i ].TeamHeader.Class:SetFont( "ScoreboardSmall" )
		self.Content[ "Panel_" .. i ].TeamHeader.Class:SetTextColor( Color( 230, 230, 230, 255 ) )
		self.Content[ "Panel_" .. i ].TeamHeader.Class:SetPos( 5, 5 )
		self.Content[ "Panel_" .. i ].TeamHeader.Class:SizeToContents()
		
		self.Content[ "Panel_" .. i ].TeamHeader.Kills = self.Content[ "Panel_" .. i ].TeamHeader:Add( "DLabel" )
		self.Content[ "Panel_" .. i ].TeamHeader.Kills:SetText( "Kills" )
		self.Content[ "Panel_" .. i ].TeamHeader.Kills:SetFont( "ScoreboardSmall" )
		self.Content[ "Panel_" .. i ].TeamHeader.Kills:SetTextColor( Color( 230, 230, 230, 255 ) )--color_white )
		self.Content[ "Panel_" .. i ].TeamHeader.Kills:SetPos( 240, 5 )
		self.Content[ "Panel_" .. i ].TeamHeader.Kills:SizeToContents()]]
		
		
			-- Content (player rows)
		self.Content[ "Panel_" .. i ].TeamContent = self.Content[ "Panel_" .. i ]:Add( "DPanelList" )
		self.Content[ "Panel_" .. i ].TeamContent:EnableVerticalScrollbar()
		self.Content[ "Panel_" .. i ].TeamContent:SetWide( self.Content[ "Panel_" .. i ]:GetWide() )
		self.Content[ "Panel_" .. i ].TeamContent:SetTall( self.Content[ "Panel_" .. i ]:GetTall() )
		self.Content[ "Panel_" .. i ].TeamContent:Dock( TOP )
		self.Content[ "Panel_" .. i ].TeamContent.Paint = function() end
		
		for a,b in pairs( team.GetPlayers( v ) ) do
			self.Content[ "Panel_" .. i ].TeamContent.PlayerRow = self.Content[ "Panel_" .. i ].TeamContent:Add( "props_playerrow" )
			self.Content[ "Panel_" .. i ].TeamContent.PlayerRow:Setup( b )
			self.Content[ "Panel_" .. i ].TeamContent.PlayerRow:SetWide( self.Content[ "Panel_" .. i ]:GetWide() )
			self.Content[ "Panel_" .. i ].TeamContent.PlayerRow:SetTall( 37 )
			self.Content[ "Panel_" .. i ].TeamContent:AddItem( self.Content[ "Panel_" .. i ].TeamContent.PlayerRow )
		end
		
		
		--print( self.Content[ "Panel_" .. i ]:GetWide() )
	end
end
	

function PANEL:Think()

end

vgui.Register( "props_scoreboard", PANEL )

--[[
function PANEL:Init()

		self.Header = self:Add( "Panel" )
		self.Header:Dock( TOP )
		self.Header:SetHeight( 110 )

		self.Name = self.Header:Add( "DLabel" )
		self.Name:SetFont( "ScoreboardDefaultTitle" )
		self.Name:SetTextColor( Color( 255, 255, 255, 255 ) )
		self.Name:Dock( TOP )
		self.Name:SetHeight( 40 )
		self.Name:SetContentAlignment( 5 )
		self.Name:SetExpensiveShadow( 2, Color( 0, 0, 0, 200 ) )
		
		self.Gamemode = self.Header:Add( "DLabel" )
		self.Gamemode:SetFont( "ScoreboardDefault")
		self.Gamemode:SetTextColor( Color( 255, 255, 255, 255 ) )
		self.Gamemode:Dock( TOP )
		self.Gamemode:SetHeight( 30 )
		self.Gamemode:SetContentAlignment( 5 )
		self.Gamemode:SetText( GAMEMODE.Name .. "; Created by " .. GAMEMODE.Author )
		
		self.PlayerName = self.Header:Add( "DLabel" )
		self.PlayerName:SetFont("ScoreboardText")
		self.PlayerName:SetPos( 60, 85 )
		self.PlayerName:SetHeight( 20 )
		self.PlayerName:SetContentAlignment( 5 )
		self.PlayerName:SetText( "Name" )
		
		self.PlayerKD = self.Header:Add( "DLabel" )
		self.PlayerKD:SetFont("ScoreboardText")
			-- 430
		self.PlayerKD:SetPos( 370, 85 )
		self.PlayerKD:SetHeight( 20 )
		self.PlayerKD:SetContentAlignment( 5 )
		self.PlayerKD:SetText( "K/D" )
		
		self.PlayerKills = self.Header:Add( "DLabel" )
		self.PlayerKills:SetFont("ScoreboardText")
			-- 495
		self.PlayerKills:SetPos( 455, 85 )
		self.PlayerKills:SetHeight( 20 )
		self.PlayerKills:SetContentAlignment( 5 )
		self.PlayerKills:SetText( "Kills" )
		
		self.PlayerDeaths = self.Header:Add( "DLabel" )
		self.PlayerDeaths:SetFont("ScoreboardText")
		self.PlayerDeaths:SetPos( 540, 85 )
		self.PlayerDeaths:SetHeight( 20 )
		self.PlayerDeaths:SetContentAlignment( 5 )
		self.PlayerDeaths:SetText( "Deaths" )
		
		self.PlayerPing = self.Header:Add( "DLabel" )
		self.PlayerPing:SetFont("ScoreboardText")
		self.PlayerPing:SetPos( 605, 85 )
		self.PlayerPing:SetHeight( 20 )
		self.PlayerPing:SetContentAlignment( 5 )
		self.PlayerPing:SetText( "Ping" )

		--self.NumPlayers = self.Header:Add( "DLabel" )
		--self.NumPlayers:SetFont( "ScoreboardDefault" )
		--self.NumPlayers:SetTextColor( Color( 255, 255, 255, 255 ) )
		--self.NumPlayers:SetPos( 0, 100 - 30 )
		--self.NumPlayers:SetSize( 300, 30 )
		--self.NumPlayers:SetContentAlignment( 4 )

		self.Scores = self:Add( "DScrollPanel" )
		self.Scores:Dock( FILL )

end

function PANEL:PerformLayout()
	
	self:SetSize( 700, ScrH() - 200 )
	self:SetPos( ScrW() / 2 - 350, 100 )

end

function PANEL:Paint( w, h )
	
	draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, 200 ) )

end
	
function PANEL:Think( w, h )
	
	self.Name:SetText( GetHostName() )

	--
	-- Loop through each player, and if one doesn't have a score entry - create it.
	--
	--local plyrs = player.GetAll()
	--for id, pl in pairs( plyrs ) do
	for id,pl in next, player.GetAll() do

		if ( IsValid( pl.ScoreEntry ) ) then continue end

		pl.ScoreEntry = vgui.Create( "props_playerrow", self )--vgui.CreateFromTable( PLAYER_LINE, pl.ScoreEntry )
		pl.ScoreEntry:Setup( pl )

		self.Scores:AddItem( pl.ScoreEntry )

	end		

end

vgui.Register( "props_scoreboard", PANEL )]]
