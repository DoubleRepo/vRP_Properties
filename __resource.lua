resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description "vRP_properties"

-- vRP_properties By DoubleRepo/MrSuicideSheep/MrSuicideSnail/TheFlyingDutchMan/TheHighFlyingDutchMan AKA Justin.

-- Based on the Home, Gunshop, Skinshop modules and other functionallities from the default vRP/dRP Pack.
-- Completely replaces the Gunshop's, Skinshop's and Business Modules on vRP/dRP.


dependency "vrp"
dependency "mysql-async"

client_scripts{ 
  "@vrp/client/Tunnel.lua",
  "@vrp/client/Proxy.lua"
}

server_scripts{ 
  "@vrp/lib/utils.lua",
  "@mysql-async/lib/MySQL.lua",
  "base.lua",
  "modules/property_components.lua"
}
