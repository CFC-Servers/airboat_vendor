AirboatVendor = AirboatVendor or {}

util.AddNetworkString( "AirboatVendor_OpenMenu" )
util.AddNetworkString( "AirboatVendor_PurchaseAirboat" )

net.Receive( "AirboatVendor_PurchaseAirboat", function( _, ply )
    AirboatVendor:PurchaseAirboatFor( ply )
end )
