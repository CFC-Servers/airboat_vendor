AirboatVendor = {}

include( "airboat_vendor/sh_config.lua" )

if SERVER then
    include( "airboat_vendor/server/sv_net.lua" )
    include( "airboat_vendor/server/sv_main.lua" )

    AddCSLuaFile( "airboat_vendor/client/cl_net.lua" )
    AddCSLuaFile( "airboat_vendor/client/cl_vgui.lua" )
else
    include( "airboat_vendor/client/cl_net.lua" )
    include( "airboat_vendor/client/cl_vgui.lua" )
end
