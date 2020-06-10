AirboatVendor = AirboatVendor or {}

net.Receive( "AirboatVendor_OpenMenu", function()
    AirboatVendor:makeMenu()
end )
