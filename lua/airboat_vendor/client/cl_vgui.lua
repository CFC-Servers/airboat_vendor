AirboatVendor = AirboatVendor or {}

function AirboatVendor:getCanAfford()
    return LocalPlayer():getDarkRPVar( "money" ) >= self.Config.price
end

function AirboatVendor:purchaseVehicle()
    -- TODO: Send net message or something?
    net.Start( "AirboatVendor_PurchaseAirboat" )
    net.SendToServer()
end

function AirboatVendor:makeMenu()
    local this = self
    local w, h = ScrW() * 0.5, ScrH() * 0.5
    
    local headerHeightMul = 0.08

    local frame = vgui.Create( "DFrame" )
    frame:SetSize( w, h )
    frame:Center()
    frame:MakePopup()
    frame:ShowCloseButton( false )
    frame:SetTitle( "" )
    function frame:Paint( w, h )
        draw.RoundedBox( 0, 0, 0, w, h * headerHeightMul, Color( 61, 80, 182 ) )
        draw.RoundedBox( 0, 0, h * headerHeightMul, w, h * ( 1 - headerHeightMul ), Color( 255, 255, 255 ) )
    end

    local titleText = vgui.Create( "DLabel", frame )
    titleText:SetText( "Airboat Dealer" )
    titleText:SetFont( "TCBDealer_24" )
    titleText:SetTextColor( Color( 255, 255, 255 ) )
    titleText:SizeToContents()
    titleText:SetPos( 15, h * 0.5 * headerHeightMul - titleText:GetTall() * 0.5 )

    local closeButton = vgui.Create( "DButton", frame )
    closeButton:SetPos( w * 0.92 - h * 0.005, h * 0.005 )
    closeButton:SetSize( w * 0.08, h * ( headerHeightMul - 0.01 ) )
    closeButton:SetFont( "TCBDealer_24" )
    closeButton:SetText( "X" )
    closeButton:SetTextColor( Color( 255, 255, 255 ) )
    function closeButton:DoClick()
        frame:Close()
    end
    function closeButton:Paint( w, h )
        draw.RoundedBox( 5, 0, 0, w, h, Color( 244, 65, 51 ) )
    end

    local text = vgui.Create( "DLabel", frame )
    text:SetText( "Would you like to buy an airboat for $" .. self.Config.price .. "?" )
    text:SetFont( "TCBDealer_24" )
    text:SizeToContents()
    text:SetTextColor( Color( 0, 0, 0 ) )
    text:SetPos( 0, h * 0.1 )
    text:CenterHorizontal()

	local iconContainer = vgui.Create( "DPanel", frame )
    iconContainer:SetSize( w * 0.6, h * 0.63 )
    iconContainer:SetPos( w * 0.2, h * 0.17 )
    function iconContainer:Paint( w, h )
    	draw.RoundedBox( 5, 0, 0, w, h, Color( 200, 200, 200 ) )
	end

    local icon = vgui.Create( "DModelPanel", iconContainer )
    icon:Dock( FILL )
    icon:SetModel( "models/airboat.mdl" )
    icon:SetCamPos( Vector( 200, 0, 60 ) )

    local noButton = vgui.Create( "DButton", frame )
    noButton:SetSize( w * 0.15, h * 0.1 )
    noButton:SetPos( w * 0.225, h * 0.85 )
    noButton:SetFont( "TCBDealer_20" )
    noButton:SetText( "Nope!" )
    noButton:SetTextColor( Color( 255, 255, 255 ) )
    function noButton:DoClick()
        frame:Close()
    end
    function noButton:Paint( w, h )
        draw.RoundedBox( 5, 0, 0, w, h, Color( 244, 65, 51 ) )
    end

    local canAfford = self:getCanAfford()

    local yesColor = canAfford and Color( 42, 205, 113 ) or Color( 100, 100, 100 )

    local yesButton = vgui.Create( "DButton", frame )
    yesButton:SetSize( w * 0.15, h * 0.1 )
    yesButton:SetPos( w * 0.625, h * 0.85 )
    yesButton:SetFont( "TCBDealer_20" )
    yesButton:SetText( canAfford and "Yep!" or "Can't afford" )
    yesButton:SetTextColor( Color( 255, 255, 255 ) )
    yesButton:SetCursor( canAfford and "hand" or "no" )
    function yesButton:DoClick()
        if canAfford then
            this:purchaseVehicle()
            frame:Close()
            surface.PlaySound( "buttons/button5.wav" )
        else
            surface.PlaySound( "buttons/button16.wav" )
        end
    end
    function yesButton:Paint( w, h )
        draw.RoundedBox( 5, 0, 0, w, h, yesColor )
    end
end
