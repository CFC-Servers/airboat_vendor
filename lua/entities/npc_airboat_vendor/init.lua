AddCSLuaFile("cl_init.lua")
include( "shared.lua" )

ENT.Base = "base_ai" 
ENT.Type = "ai"
ENT.Model = "models/Eli.mdl"

function ENT:Initialize()
    self.NextUse = 0

    self:SetModel( self.Model )

    self:SetHullType( HULL_HUMAN )
	self:SetHullSizeNormal()
	self:SetNPCState( NPC_STATE_SCRIPT )
	self:SetSolid( SOLID_BBOX )
	self:CapabilitiesAdd( CAP_ANIMATEDFACE + CAP_TURN_HEAD )
	self:DropToFloor()

	self:SetMaxYawSpeed( 90 )

    self:SetUseType( SIMPLE_USE )
end

function ENT:AcceptInput(name, _, caller)
    if not IsValid( caller ) then return end
    if not caller:IsPlayer() then return end
    if name ~= "Use" then return end

    net.Start( "AirboatVendor_OpenMenu" )
    net.Send( caller )
end
