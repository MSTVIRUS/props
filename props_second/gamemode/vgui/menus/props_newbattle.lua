local PANEL = {}

function PANEL:Init()
	self:SetPos( 20, 20 )
	self:SetSize( self:GetParent():GetWide() - 20, self:GetParent():GetTall() - 40 )
	
		-- add arrows to navigate through the different battling types?
	self.BattleTypePanel = self:Add( "DPanel" )
	self.BattleTypePanel:SetPos( 2, 0 )
	self.BattleTypePanel:SetWide( self:GetWide() )
	self.BattleTypePanel:SetTall( 60 )
	--self.BattleTypePanel:Dock( TOP )
	
	self.BattleTypeText = self.BattleTypePanel:Add( "DLabel" )
	self.BattleTypeText:SetText( "1v1 Player Battling" )
	self.BattleTypeText:SetFont( "props_HUDTextLarge" )
	surface.SetFont( "props_HUDTextLarge" )
	local typetextsize_w, typetextsize_h = surface.GetTextSize( "1v1 Player Battling" )
	self.BattleTypeText:SetSize( typetextsize_w, typetextsize_h )
	self.BattleTypeText:SetPos( self.BattleTypePanel:GetWide() / 2 - typetextsize_w / 2, self.BattleTypePanel:GetTall() / 2 - typetextsize_h / 2 )
	
	local battletypepos_x, battletypepos_y = self.BattleTypePanel:GetPos()
	
	self.LeftPanel = self:Add( "DPanel" )
	self.LeftPanel:SetPos( 2, battletypepos_y + self.BattleTypePanel:GetTall() + 5 )
	self.LeftPanel:SetWide( 280 )
	self.LeftPanel:SetTall( self:GetTall() - (self.BattleTypePanel:GetTall() + battletypepos_y) )
	--self.LeftPanel:Dock( LEFT )
	
	self.LeftPanel.AvatarPanel = self.LeftPanel:Add( "DPanel" )
	self.LeftPanel.AvatarPanel:SetPos( 15, 4 )
	self.LeftPanel.AvatarPanel:SetWide( 88 )
	self.LeftPanel.AvatarPanel:SetTall( 88 )
	self.LeftPanel.AvatarPanel.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 90, 90, 90, 255 ) )
	end
	
	self.LeftPanel.AvatarPanel.Image = self.LeftPanel.AvatarPanel:Add( "AvatarImage" )
	self.LeftPanel.AvatarPanel.Image:SetSize( 84, 84 )
	self.LeftPanel.AvatarPanel.Image:SetPos( 2, 2 )
	self.LeftPanel.AvatarPanel.Image:SetPlayer( LocalPlayer(), 84 )
	
	local avatarpanelpos_x, avatarpanelpos_y = self.LeftPanel.AvatarPanel:GetPos()
	
	self.LeftPanel.ListView = self.LeftPanel:Add( "DListView" )
	self.LeftPanel.ListView:SetPos( 15, avatarpanelpos_y + self.LeftPanel.AvatarPanel:GetTall() + 5 )
	self.LeftPanel.ListView:SetWide( self.LeftPanel:GetWide() - 30 )
	self.LeftPanel.ListView:SetTall( self.LeftPanel:GetTall() - (self.LeftPanel.AvatarPanel:GetTall() + avatarpanelpos_y) - 60 )
	self.LeftPanel.ListView:SetMultiSelect( false )
	self.LeftPanel.ListView:AddColumn( "Player List" )
	self.LeftPanel.ListView:AddColumn( "SteamID" )
	self.LeftPanel.ListView.Columns[ 2 ]:SetFixedWidth( 0 )
	for k,v in pairs( player.GetAll() ) do
		--if v == LocalPlayer() then continue end
		
		self.LeftPanel.ListView:AddLine( v:Nick(), v:SteamID() )
	end
	self.LeftPanel.ListView.OnClickLine = function( pnl, line, selected )
		self.LeftPanel.ListView:ClearSelection()
		line:SetSelected( true )
		line.m_fClickTime = SysTime()
		self.LeftPanel.ListView:OnRowSelected( line:GetID(), line )

		self.LeftPanel.AvatarPanel.Image:SetSteamID( util.SteamIDTo64( line:GetValue( 2 ) ), 84 )
	end


	
	local listviewpos_x, listviewpos_y = self.LeftPanel.ListView:GetPos()
	
	-- for start battle button, Button:SetDisabled( true ) if no player is selected.
	
	self.LeftPanel.FragLimitPanel = self.LeftPanel:Add( "DPanel" )
	self.LeftPanel.FragLimitPanel:SetPos( 15, listviewpos_y + self.LeftPanel.ListView:GetTall() + 5 )
	self.LeftPanel.FragLimitPanel:SetWide( self.LeftPanel:GetWide() - 30 )
	self.LeftPanel.FragLimitPanel:SetTall( 20 )
	self.LeftPanel.FragLimitPanel.Paint = function( self, w, h )
		--draw.RoundedBox( 0, 0, 0, w, h, Color( 90, 90, 90, 255 ) )
	end
	
	local fraglimitpos_x, fraglimitpos_y = self.LeftPanel.FragLimitPanel:GetPos()
	
	self.LeftPanel.FragLimitPanel.Text = self.LeftPanel.FragLimitPanel:Add( "DLabel" )
	self.LeftPanel.FragLimitPanel.Text:SetPos( 0, 2 )
	self.LeftPanel.FragLimitPanel.Text:SetText( "Battle Amount" )
	self.LeftPanel.FragLimitPanel.Text:SetFont( "props_HUDTextTiny" )
	self.LeftPanel.FragLimitPanel.Text:SetTextColor( Color( 90, 90, 90, 255 ) ) --color_white )
	self.LeftPanel.FragLimitPanel.Text:SizeToContents()
	
	surface.SetFont( "props_HUDTextTiny" )
	local fraglimittextsize_w, fraglimittextsize_h = surface.GetTextSize( "Battle Amount" )
	
	self.LeftPanel.FragLimitPanel.Wang = self.LeftPanel.FragLimitPanel:Add( "DNumberWang" )
	self.LeftPanel.FragLimitPanel.Wang:SetWide( 70 )
	self.LeftPanel.FragLimitPanel.Wang:SetTall( 20 )
	self.LeftPanel.FragLimitPanel.Wang:SetPos( self.LeftPanel.FragLimitPanel:GetWide() - self.LeftPanel.FragLimitPanel.Wang:GetWide(), 0 )
	self.LeftPanel.FragLimitPanel.Wang:SetValue( 10 )
	self.LeftPanel.FragLimitPanel.Wang:SetMin( 5 )
	self.LeftPanel.FragLimitPanel.Wang:SetMax( PROPKILL.Config[ "battle_maxkills" ].default )
	self.LeftPanel.FragLimitPanel.Wang:SetDecimals( 0 )

	
	self.LeftPanel.TimePanel = self.LeftPanel:Add( "DPanel" )
	self.LeftPanel.TimePanel:SetPos( 15, fraglimitpos_y + self.LeftPanel.FragLimitPanel:GetTall() + 5 )
	self.LeftPanel.TimePanel:SetWide( self.LeftPanel:GetWide() - 30 )
	self.LeftPanel.TimePanel:SetTall( 20 )
	self.LeftPanel.TimePanel.Paint = function( self, w, h )
		--draw.RoundedBox( 0, 0, 0, w, h, Color( 90, 90, 90, 255 ) )
	end
	
	self.LeftPanel.TimePanel.Text = self.LeftPanel.TimePanel:Add( "DLabel" )
	self.LeftPanel.TimePanel.Text:SetPos( 0, 2 )
	self.LeftPanel.TimePanel.Text:SetText( "Time Limit" )
	self.LeftPanel.TimePanel.Text:SetFont( "props_HUDTextTiny" )
	self.LeftPanel.TimePanel.Text:SetTextColor( Color( 90, 90, 90, 255 ) ) --color_white )
	self.LeftPanel.TimePanel.Text:SizeToContents()
	
	surface.SetFont( "props_HUDTextTiny" )
	local timelimittextsize_w, timelimittextsize_h = surface.GetTextSize( "Time Limit" )

	self.LeftPanel.TimePanel.Wang = self.LeftPanel.TimePanel:Add( "DNumberWang" )
	self.LeftPanel.TimePanel.Wang:SetWide( 70 )
	self.LeftPanel.TimePanel.Wang:SetTall( 20 )
	self.LeftPanel.TimePanel.Wang:SetPos( self.LeftPanel.TimePanel:GetWide() - self.LeftPanel.TimePanel.Wang:GetWide(), 0 )
	self.LeftPanel.TimePanel.Wang:SetValue( 6 )
	self.LeftPanel.TimePanel.Wang:SetMin( 6 )
	self.LeftPanel.TimePanel.Wang:SetMax( 10 )
	self.LeftPanel.TimePanel.Wang:SetDisabled( true )
	
	--------------- RIGHT PANEL
	
	self.RightPanel = self:Add( "DPanel" )
	self.RightPanel:SetPos( self.LeftPanel:GetWide() + 2 + 5, battletypepos_y + self.BattleTypePanel:GetTall() + 5 )
	self.RightPanel:SetWide( self:GetWide() - ((self.LeftPanel:GetWide() + 2) + 5) + 2 )
	self.RightPanel:SetTall( self:GetTall() - (self.BattleTypePanel:GetTall() + battletypepos_y) )
	
	self.RightPanel.RecentHeaderPanel = self.RightPanel:Add( "DPanel" )
	self.RightPanel.RecentHeaderPanel:SetPos( 5, 5 )
	self.RightPanel.RecentHeaderPanel:SetWide( self.RightPanel:GetWide() - 10 )
	self.RightPanel.RecentHeaderPanel:SetTall( 40 )
	self.RightPanel.RecentHeaderPanel.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 180, 180, 180, 255 ) )
	end
	
	local headerpos_x, headerpos_y = self.RightPanel.RecentHeaderPanel:GetPos()
	
	self.RightPanel.RecentHeaderPanel.Text = self.RightPanel.RecentHeaderPanel:Add( "DLabel" )
	self.RightPanel.RecentHeaderPanel.Text:SetText( "Recent Battles" )
	self.RightPanel.RecentHeaderPanel.Text:SetFont( "props_HUDTextMedium" )
	self.RightPanel.RecentHeaderPanel.Text:SetTextColor( Color( 90, 90, 90, 255 ) )
	surface.SetFont( "props_HUDTextMedium" )
	local headertextsize_w, headertextsize_h = surface.GetTextSize( "Recent Battles" )
	self.RightPanel.RecentHeaderPanel.Text:SetSize( headertextsize_w, headertextsize_h )
	self.RightPanel.RecentHeaderPanel.Text:SetPos( self.RightPanel.RecentHeaderPanel:GetWide() / 2 - headertextsize_w / 2, self.RightPanel.RecentHeaderPanel:GetTall() / 2 - headertextsize_h / 2 )
	
	self.RightPanel.RecentLabelPanel = self.RightPanel:Add( "DPanel" )
	self.RightPanel.RecentLabelPanel:SetPos( headerpos_x, headerpos_y + self.RightPanel.RecentHeaderPanel:GetTall() )
	self.RightPanel.RecentLabelPanel:SetWide( self.RightPanel:GetWide() - 10 )
	self.RightPanel.RecentLabelPanel:SetTall( 20 )
	self.RightPanel.RecentLabelPanel.Paint = function( self, w, h )
			-- comment out later?
		draw.RoundedBox( 0, 0, 0, w, h, Color( 180, 180, 180, 255 ) )
	end
	
	self.RightPanel.RecentLabelPanel.ColumnName = self.RightPanel.RecentLabelPanel:Add( "DLabel" )
	self.RightPanel.RecentLabelPanel.ColumnName:SetText( "Names" )
	self.RightPanel.RecentLabelPanel.ColumnName:SetFont( "props_HUDTextSmall" )
	self.RightPanel.RecentLabelPanel.ColumnName:SetTextColor( Color( 90, 90, 90, 255 ) )
	surface.SetFont( "props_HUDTextSmall" )
	local columnnamesize_w, columnnamesize_h = surface.GetTextSize( "Names" )
	self.RightPanel.RecentLabelPanel.ColumnName:SetSize( columnnamesize_w, columnnamesize_h )
	self.RightPanel.RecentLabelPanel.ColumnName:SetPos( 10, self.RightPanel.RecentLabelPanel:GetTall() / 2 - columnnamesize_h / 2 )
	
	self.RightPanel.RecentLabelPanel.ColumnWinner = self.RightPanel.RecentLabelPanel:Add( "DLabel" )
	self.RightPanel.RecentLabelPanel.ColumnWinner:SetText( "Winner" )
	self.RightPanel.RecentLabelPanel.ColumnWinner:SetFont( "props_HUDTextSmall" )
	self.RightPanel.RecentLabelPanel.ColumnWinner:SetTextColor( Color( 90, 90, 90, 255 ) )
	surface.SetFont( "props_HUDTextSmall" )
	local columnwinnersize_w, columnwinnersize_h = surface.GetTextSize( "Winner" )
	self.RightPanel.RecentLabelPanel.ColumnWinner:SetSize( columnwinnersize_w, columnwinnersize_h )
	self.RightPanel.RecentLabelPanel.ColumnWinner:SetPos( (10 + columnnamesize_w) + 90 + columnwinnersize_w, self.RightPanel.RecentLabelPanel:GetTall() / 2 - columnwinnersize_h / 2 )
	
	self.RightPanel.RecentLabelPanel.ColumnScore = self.RightPanel.RecentLabelPanel:Add( "DLabel" )
	self.RightPanel.RecentLabelPanel.ColumnScore:SetText( "Score" )
	self.RightPanel.RecentLabelPanel.ColumnScore:SetFont( "props_HUDTextSmall" )
	self.RightPanel.RecentLabelPanel.ColumnScore:SetTextColor( Color( 90, 90, 90, 255 ) )
	surface.SetFont( "props_HUDTextSmall" )
	local columnscoresize_w, columnscoresize_h = surface.GetTextSize( "Score" )
	self.RightPanel.RecentLabelPanel.ColumnScore:SetSize( columnscoresize_w, columnscoresize_h )
	--local columnwinnerpos_x, columnwinnerpos_y = self.RightPanel.RecentLabelPanel.ColumnWinner:GetPos()
	self.RightPanel.RecentLabelPanel.ColumnScore:SetPos( (self.RightPanel.RecentLabelPanel:GetWide() - columnscoresize_w) - 10, self.RightPanel.RecentLabelPanel:GetTall() / 2 - columnscoresize_h / 2 )

	self.RightPanel.RecentContentPanel = self.RightPanel:Add( "DPanelList" )
	self.RightPanel.RecentContentPanel:SetWide( self.RightPanel.RecentHeaderPanel:GetWide() )
	local labelpanelpos_x, labelpanelpos_y = self.RightPanel.RecentLabelPanel:GetPos()
	self.RightPanel.RecentContentPanel:SetTall( self.RightPanel:GetTall() - ( headerpos_y + self.RightPanel.RecentHeaderPanel:GetTall() + self.RightPanel.RecentLabelPanel:GetTall() ) - (5 + 40) )
	self.RightPanel.RecentContentPanel:SetPos( headerpos_x, labelpanelpos_y + self.RightPanel.RecentLabelPanel:GetTall() )
	self.RightPanel.RecentContentPanel:SetSpacing( 5 )
	self.RightPanel.RecentContentPanel:EnableHorizontal( false )
	self.RightPanel.RecentContentPanel:EnableVerticalScrollbar( true )
	self.RightPanel.RecentContentPanel.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 200, 200, 200, 255 ) )
	end
	
	local contentpanelpos_x, contentpanelpos_y = self.RightPanel.RecentContentPanel:GetPos()
	
	local tblrecentscores = {}
	tblrecentscores[ #tblrecentscores + 1 ] = 
	{
		Names = "Shinycow : Bot01",
		Winner = "Shinycow",
		Score = "15 - 0",
	}
	--[[tblrecentscores[ #tblrecentscores + 1 ] =
	{
		Names = "Shinycow : SomePlayer",
		Winner = "SomePlayer",
		Score = "15 - 9",
	}]]
	
	for k,v in ipairs( tblrecentscores ) do
		
		self.RightPanel.RecentContentPanel[ "recent" .. k ] = self.RightPanel.RecentContentPanel:Add( "DPanel" )
		self.RightPanel.RecentContentPanel[ "recent" .. k ]:SetPos( 40, 0 )
		self.RightPanel.RecentContentPanel[ "recent" .. k ]:SetWide( self.RightPanel.RecentContentPanel:GetWide() )
		self.RightPanel.RecentContentPanel[ "recent" .. k ]:SetTall( 35 )
		self.RightPanel.RecentContentPanel[ "recent" .. k ].Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 80, 80, 80, 255 ) )
		end
		
		self.RightPanel.RecentContentPanel[ "recent" .. k ].ContentNames = self.RightPanel.RecentContentPanel[ "recent" .. k ]:Add( "DLabel" )
		self.RightPanel.RecentContentPanel[ "recent" .. k ].ContentNames:SetText( v.Names )
		self.RightPanel.RecentContentPanel[ "recent" .. k ].ContentNames:SetFont( "props_HUDTextTiny" )
		self.RightPanel.RecentContentPanel[ "recent" .. k ].ContentNames:SetTextColor( Color( 230, 230, 230, 255 ) )
		surface.SetFont( "props_HUDTextSmall" )
		local contentnamesize_w, contentnamesize_h = surface.GetTextSize( v.Names )
		self.RightPanel.RecentContentPanel[ "recent" .. k ].ContentNames:SetSize( contentnamesize_w, contentnamesize_h )
		self.RightPanel.RecentContentPanel[ "recent" .. k ].ContentNames:SetPos( 5, self.RightPanel.RecentContentPanel[ "recent" .. k ]:GetTall() / 2 - contentnamesize_h / 2 )
	
		self.RightPanel.RecentContentPanel[ "recent" .. k ].ContentWinner = self.RightPanel.RecentContentPanel[ "recent" .. k ]:Add( "DLabel" )
		self.RightPanel.RecentContentPanel[ "recent" .. k ].ContentWinner:SetText( v.Winner )
		self.RightPanel.RecentContentPanel[ "recent" .. k ].ContentWinner:SetFont( "props_HUDTextTiny" )
		self.RightPanel.RecentContentPanel[ "recent" .. k ].ContentWinner:SetTextColor( Color( 230, 230, 230, 255 ) )
		surface.SetFont( "props_HUDTextSmall" )
		local contentwinnersize_w, contentwinnersize_h = surface.GetTextSize( v.Winner )
		self.RightPanel.RecentContentPanel[ "recent" .. k ].ContentWinner:SetSize( contentwinnersize_w, contentwinnersize_h )
		self.RightPanel.RecentContentPanel[ "recent" .. k ].ContentWinner:SetPos( (10 + columnnamesize_w) + 90 + columnwinnersize_w, self.RightPanel.RecentContentPanel[ "recent" .. k ]:GetTall() / 2 - contentwinnersize_h / 2 )
		
		self.RightPanel.RecentContentPanel[ "recent" .. k ].ContentScore = self.RightPanel.RecentContentPanel[ "recent" .. k ]:Add( "DLabel" )
		self.RightPanel.RecentContentPanel[ "recent" .. k ].ContentScore:SetText( v.Score )
		self.RightPanel.RecentContentPanel[ "recent" .. k ].ContentScore:SetFont( "props_HUDTextTiny" )
		local contentscoresize_w, contentscoresize_h = surface.GetTextSize( v.Score )
		self.RightPanel.RecentContentPanel[ "recent" .. k ].ContentScore:SetSize( contentscoresize_w, contentscoresize_h )
		--self.RightPanel.RecentContentPanel[ "recent" .. k ].ContentScore:SetPos( (10 + columnnamesize_w) + 90 + columnwinnersize_w + columnscoresize_w + 113, self.RightPanel.RecentContentPanel[ "recent" .. k ]:GetTall() / 2 - contentscoresize_h / 2 ) 
		self.RightPanel.RecentContentPanel[ "recent" .. k ].ContentScore:SetPos( self.RightPanel.RecentContentPanel[ "recent" .. k ]:GetWide() - (contentscoresize_w - 2), self.RightPanel.RecentContentPanel[ "recent" .. k ]:GetTall() / 2 - contentscoresize_h / 2 ) 
		
		self.RightPanel.RecentContentPanel:AddItem( self.RightPanel.RecentContentPanel[ "recent" .. k ] )
	
	end
	
	self.RightPanel.StartButton = self.RightPanel:Add( "DButton" )
	self.RightPanel.StartButton:SetText( "START BATTLE" )
	self.RightPanel.StartButton:SetFont( "props_HUDTextSmall" )
	self.RightPanel.StartButton:SetWide( self.RightPanel.RecentContentPanel:GetWide() - 40 )
	--self.RightPanel:GetTall() - ( headerpos_y + self.RightPanel.RecentHeaderPanel:GetTall() + self.RightPanel.RecentLabelPanel:GetTall() ) - (5 + 55) )
	self.RightPanel.StartButton:SetTall( self.RightPanel:GetTall() - ( headerpos_y + self.RightPanel.RecentHeaderPanel:GetTall() + self.RightPanel.RecentLabelPanel:GetTall() + self.RightPanel.RecentContentPanel:GetTall() ) - 10 )
	self.RightPanel.StartButton:SetPos( headerpos_x + 20, contentpanelpos_y + self.RightPanel.RecentContentPanel:GetTall() + 5 )
	

	
	
end

vgui.Register( "props_BattleMenuNew", PANEL )