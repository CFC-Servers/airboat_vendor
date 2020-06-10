AirboatVendor = AirboatVendor or {}

AirboatVendor.saveDir = "airboat_vendor"
AirboatVendor.saveFile = AirboatVendor.saveDir .. "/" .. game.GetMap() .. ".json"
AirboatVendor.vendorClass = "npc_airboat_vendor"
AirboatVendor.vendorData = {}
AirboatVendor.logPrefix = "[AirboatVendor] "

function AirboatVendor:log( ... )
    print( self.logPrefix, ... )
end

function AirboatVendor:LoadVendorData()
    if file.Exists( self.saveFile, "DATA" ) then
        local data = file.Read( self.saveFile, "DATA" )
        data = util.JSONToTable( data )

        self.vendorData = data
    else
        file.CreateDir( self.saveDir )
        file.Write( self.saveFile, "[]" )
    end
end

function AirboatVendor:DeleteVendors()
    for _, v in pairs( ents.GetAll() ) do
        if v:IsValid() and v:GetClass() == self.vendorClass then
            v:Remove()
        end
    end
end

function AirboatVendor:SpawnVendors()
    self:DeleteVendors()

    for _, data in pairs( self.vendorData ) do
        local pos = data.pos
        local ang = data.ang

        local ent = ents.Create( self.vendorClass )

        ent:SetPos( pos )
        ent:SetAngles( ang )
        ent:Spawn()

        self:log( "Spawned vendor at [" .. tostring( pos ) .. "]")
    end
end

function AirboatVendor:GetAirboatSpawnPos()
    return Vector( 0, 0, 0 )
end

function AirboatVendor:PurchaseAirboatFor( ply )
    if not IsValid( ply ) then return end

    local currentAirboat = ply:GetNWEntity( "currentAirboat", nil )
    if IsValid( currentAirboat ) then
        DarkRP.notify( ply, 1, 5, "You already have an airboat!" )
        return
    end

    local canAfford = ply:getDarkRPVar( "money" ) >= self.Config.price
    if not canAfford then
        DarkRP.notify( ply, 1, 5, "You can't afford that!" )
        return
    end

    local spawnPos, spawnAng = self.GetAirboatSpawnPos()
    local airboat = ents.Create( "prop_vehicle_airboat" )
    airboat:SetPos( spawnPos )
    airboat:SetAngles( spawnAng )
    airboat:Spawn()

    airboat:keysOwn( ply )
    airboat:keysLock()
    airboat.airboatOwner = ply

    airboat:CallOnRemove( "AirboatVendor_UnsetAirboatOwner", function()
        local owner = airboat.airboatOwner
        if not IsValid( owner ) then return end

        owner:SetNWEntity( "currentAirboat", nil )
    end )

    ply:SetNWEntity( "currentAirboat", airboat )

    ply:addMoney( -self.Config.price )
    DarkRP.notify( ply, 0, 5, "Enjoy your new airboat!" )
end

hook.Add( "InitPostEntity", "AirboatVendorSpawnNPCs", function()
    AirboatVendor:LoadVendorData()
    AirboatVendor:SpawnVendors()
end )

hook.Add( "PostCleanupMap", "AirboatVendorSpawnNPCs", function()
    AirboatVendor:SpawnVendors()
end )

hook.Add( "PlayerDisconnected", "AirboatVendor_CleanUpAirboats", function( ply )
    local currentAirboat = ply:GetNWEntity( "currentAirboat", nil )
    if not IsValid( currentAirboat ) then return end

    currentAirboat:Remove()
end )
