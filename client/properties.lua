vRPpc = {}
Tunnel.bindInterface("vRP_properties",vRPpc)
vRP = Tunnel.getInterface("vRP","vRP_properties")
--HKserver = Tunnel.getInterface("vrp_hotkeys","vRP_properties")
vRPps = Tunnel.getInterface("vRP_properties","vRP_properties")
local vRPclient = Proxy.getInterface("vRP")