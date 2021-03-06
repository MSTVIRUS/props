local PANEL = {}

function PANEL:Init()
	
	self:SetSize( 160, 80 )
	self:SetPos( 3, 3 )
	self:SetKeyboardInputEnabled( false )
	self:SetMouseInputEnabled(true)
	
	self.Countdown = nil
	self.Time = 15
	self.OriginalTime = CurTime()
	self.userid, self.name, self.killamt, self.propamt = nil, nil, nil, nil
	
	surface.SetFont( "props_HUDTextTiny" )
	local titlesizew, titlesizeh = surface.GetTextSize( "Battle Invitation ( " .. "15" .. " )" )
	
	self.Title = self:Add( "DLabel" )
	self.Title:SetText( "Battle Invitation ( " .. "15" .. " )" )
	self.Title:SetFont( "props_HUDTextTiny" )
	self.Title:SetPos( (self:GetWide() - titlesizew) / 2, 5 )
	self.Title:SizeToContents()
	
	self.Description = self:Add( "DLabel" )
	self.Description:SetText( [[Battler: nil
	Kill Limit: 0 
	Prop Limit: 0]] )
	self.Description:SetPos( 5, 21 )
	self.Description:SizeToContents()

	self.AcceptButton = self:Add( "DButton" )
	self.AcceptButton:SetColor( Color( 0, 0, 0, 255 ) )
	self.AcceptButton:SetText( "Accept" )
	self.AcceptButton:SetSize( 55, 16 )
	self.AcceptButton:SetPos( 5, self:GetTall() - 15 )
	self.AcceptButton.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 50, 230, 50, 255 ) )
	end
	self.AcceptButton.DoClick = function( pnl )
		--self:Remove()
		RunConsoleCommand( "props_acceptbattle", self.userid )
		self:Close()
	end
	
	self.DeclineButton = self:Add( "DButton" )
	self.DeclineButton:SetColor( Color( 0, 0, 0, 255 ) )
	self.DeclineButton:SetText( "Decline" )
	self.DeclineButton:SetSize( 55, 16 )
	self.DeclineButton:SetPos( ( self:GetWide() - self.DeclineButton:GetWide() ) - 5, self:GetTall() - 15 )
	self.DeclineButton.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 230, 50, 50, 255 ) )
	end
	self.DeclineButton.DoClick = function( pnl )
		--self:Remove()
		RunConsoleCommand( "props_declinebattle", self.userid )
		self:Close()
	end
	
end

function PANEL:SetInformation( userid, name, killamt, propamt, countdown )
	self.userid = userid
	self.name = name
	self.killamt = killamt
	self.propamt = propamt
	
	self.Description:SetText( [[Battler: ]] .. self.name .. [[ 
	Kill Limit: ]] .. self.killamt .. [[ 
	Prop Limit: ]] .. self.propamt )
	self.Description:SizeToContents()
	
	self.Time = countdown
end

function PANEL:Close()
	table.RemoveByValue( LocalPlayer().fightInvites, self )
	self:Remove()
end

function PANEL:Paint( w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 31, 31, 31, 230 ) )
end

function PANEL:Think()
	self.Countdown = math.Round( self.Time - (CurTime() - self.OriginalTime) )
	
	local titlesizew, titlesizeh = surface.GetTextSize( "Battle Invitation ( " .. self.Countdown .. " )" )

	self.Title:SetText( "Battle Invitation ( " .. self.Countdown .. " )" )
	--self.Title:SetPos( (self:GetWide() - titlesizew) / 2, 5 )
	self.Title:InvalidateLayout()
	self.Title:SetPos( self:GetWide() / 2 - (titlesizew / 2) + 15, 5 )
	self.Title:SetSize( self:GetWide(), titlesizeh )
	
	if self.Countdown < 0 then
		self:Close()
	end
	
	--print( self.propamt )
end

vgui.Register( "props_BattleInvitation", PANEL )