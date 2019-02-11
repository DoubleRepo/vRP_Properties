local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local Lang = module("vrp", "lib/Lang")
local htmlEntities = module("vrp", "lib/htmlEntities")

Debug = module("vrp", "lib/Debug")

local config = module("vrp", "cfg/base")
local cfg = module("vRP_properties", "cfg/properties")

Debug.active = config.debug

vRPps = {}
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_properties")
--vRPpc = Tunnel.getInterface("vRP_properties","vRP_properties")
Tunnel.bindInterface("vRP_properties",vRPps)

-- load language 
local lang = Lang.new(module("vrp", "cfg/lang/"..config.lang) or {})


-- sql

--MySQL.createCommand("vRP/property_tables", [[
--CREATE TABLE IF NOT EXISTS vrp_user_properties(
--  user_id INTEGER,
--  property VARCHAR(100),
--  number INTEGER,
--	sales INT,
--	earned INT,
--	employees INT,
--  CONSTRAINT pk_user_homes PRIMARY KEY(user_id),
--  CONSTRAINT fk_user_homes_users FOREIGN KEY(user_id) REFERENCES vrp_users(id) ON DELETE CASCADE,
--  UNIQUE(property,number)
--);
--]])

--MySQL.createCommand("vRP/get_paddress","")
--MySQL.createCommand("vRP/get_property_owner","")
--MySQL.createCommand("vRP/rm_paddress","DELETE FROM vrp_user_properties WHERE user_id = @user_id")
--MySQL.createCommand("vRP/set_paddress","REPLACE INTO vrp_user_properties(user_id,property,number) VALUES(@user_id,@property,@number)")
--MySQL.createCommand("vRP/sell_property","UPDATE vrp_user_properties SET user_id = @user_id, property = @property, number = @number WHERE user_id = @oldUser, property = @property, number = @number")


--MySQL.createCommand("vRP/get_property_sales","")
--MySQL.createCommand("vRP/get_property_earned","")
--MySQL.createCommand("vRP/set_property_info","")



-- api
local components = {}

vRPps.property_Etables = {} -- property_Etables data tables (logger storage, saved to database)

function vRPps.property_employees(property)
  return vRPps.property_Etables[property]
end

---- property_Salarytables data tables (logger storage, saved to database) ----
vRPps.property_Salarytables = {} 

function vRPps.property_salary(property)
  return vRPps.property_Salarytables[property]
end

vRPps.property_locks = {} -- property_Etables data tables (logger storage, saved to database)

function vRPps.propertyGetlock(property)
  return vRPps.property_locks[property]
end

function vRPps.propertyGetlockStatus(property)
  if vRPps.property_locks[property] == "yes" then 
	current = "closed"
	option = "open"
	new = "no"
	numberrr = 0
  else 
	current = "opened"
	option = "close"
	new = "yes"
	numberrr = 1
  end
  return current,option,new,numberrr
end

--------------------- business options -------------------
--------------------- business options -------------------
-- cbreturn property info (sales or earned) or nil
function vRPps.getPriceadjustment(property, cbr) --,cbr)
  local task = Task(cbr)
  MySQL.Async.fetchAll('SELECT price_adjustment FROM vrp_user_properties WHERE property = @property', {['@property'] = property}, function(result)
	task({result[1].price_adjustment})
  end)
end

-- set property info (sales and earned)
function vRPps.setPriceadjustment(property,price)
  MySQL.Async.execute('UPDATE vrp_user_properties SET price_adjustment = @price WHERE property = @property', {['@price'] = price, ['@property'] = property})
end


-- cbreturn property info (sales or earned) or nil
function vRPps.getPropertyLock(property)
  if vRPps.property_locks[property] == nil then
	vRPps.property_locks[property] = {}
	MySQL.Async.fetchAll('SELECT locked FROM vrp_user_properties WHERE property = @property', {['@property'] = property}, function(result)
	  vRPps.property_locks[property] = result[1].locked
	end)
  end
end

-- set property info (sales and earned)
function vRPps.setPropertyLock(property,locked)
  vRPps.property_locks[property] = locked
  MySQL.Async.execute('UPDATE vrp_user_properties SET locked = @locked WHERE property = @property', {['@locked'] = locked, ['@property'] = property})
end

-- Get Employees from property
function vRPps.getEmployees(property)
  if vRPps.property_Etables[property] == nil then
	vRPps.property_Etables[property] = {}
	MySQL.Async.fetchAll('SELECT employees FROM vrp_user_properties WHERE property = @property', {['@property'] = property}, function(result)
	  local etable = json.decode(result[1].employees)
	  if type(etable) == "table" then 
	    vRPps.property_Etables[property] = etable
	  end
	end)
  end
end

-- Get salary data from Employees @ property
function vRPps.getSalary(property)
  if vRPps.property_Salarytables[property] == nil then
	vRPps.property_Salarytables[property] = {}
	MySQL.Async.fetchAll('SELECT salary FROM vrp_user_properties WHERE property = @property', {['@property'] = property}, function(result)
	  local etable = json.decode(result[1].salary)
	  if type(etable) == "table" then 
	    vRPps.property_Salarytables[property] = etable
	  end
	end)
  end
end
-- check if the user has a specific group
function vRPps.isEmployee(property,user_id)
  if vRPps.property_Etables[property] == nil then
	vRPps.getEmployees(property)
  end
    local data = vRPps.property_Etables[property]
	if type(data) == "table" then 
      for k,v in pairs(data.employee) do
	    if tonumber(k) == tonumber(user_id) then
	      return true
	    end
      end
	end
  return false
end


-- add a employee to a property
function vRPps.AddEmployee(user_id,property)
  if not vRPps.IsEmployee(property,user_id) then
    local employees = vRPps.property_employees(property)
      -- add employee
      employees[user_id] = true
		print("Employee Added")
	  --vRPps.SetBusinessEmployees(property,employees)
  end
end

-- remove a employee from x property
function vRPps.RemoveEmployee(user_id,property)
  if vRPps.IsEmployee(property,user_id) then
    local employees = vRPps.property_employees(property)
      -- add employee
      employees[user_id] = nil
		print("Employee Removed")

	  --vRPps.SetBusinessEmployees(property,employees)
  end
end


---------------- business ----------------
---------------- business ----------------

-- cbreturn property info (sales or earned) or nil
function vRPps.getPropertySales(property, cbr)
  local task = Task(cbr)

  MySQL.Async.fetchAll('SELECT sales FROM vrp_user_properties WHERE property = @property', {['@property'] = property}, function(result)
	task({result[1].sales})
  end)
end

-- cbreturn property info (sales or earned) or nil
function vRPps.getPropertyEarned(property, cbr)
  local task = Task(cbr)
  MySQL.Async.fetchAll('SELECT earned FROM vrp_user_properties WHERE property = @property', {['@property'] = property}, function(result)
	task({result[1].earned})
  end)
end

function vRPps.UpdatePropertyInfo(price,amount,stype)
  print("UpdatePropertyInfo 0 "..price.." "..amount.." "..stype)
  vRPps.getPropertyEarned(stype, function(earned)
    vRPps.getPropertySales(stype, function(sales)
	print("UpdatePropertyInfo 1 "..earned.." "..sales.." "..stype)

	  local earned = earned+price
	  local sales = sales+amount
	  print("UpdatePropertyInfo 2 "..earned.." "..sales.." "..stype)

	  --vRPps.setPropertyInfo(sales,earned,stype)
	    MySQL.Async.execute('UPDATE vrp_user_properties SET sales = @sales, earned = @earned WHERE property = @stype', {['@sales'] = sales, ['@earned'] = earned, ['@stype'] = stype})

	print("UpdatePropertyInfo 3 "..earned.." "..sales.." "..stype.." Done")
    end)
  end)
end

---------------- business ----------------
---------------- business ----------------

-- cbreturn user address (property and number) or nil
function vRPps.getUserpAddress(user_id, cbr)
  local task = Task(cbr)
  MySQL.Async.fetchAll('SELECT property, number FROM vrp_user_properties WHERE user_id = @user_id', {['@user_id'] = user_id}, function(result)
    task({result[1]})
  end)
end

-- set user address
function vRPps.setUserpAddress(user_id,property,number)
  MySQL.execute("vRP/set_paddress", {user_id = user_id, property = property, number = number})
end

-- remove user address
function vRPps.removeUserpAddress(user_id)
  MySQL.execute("vRP/rm_paddress", {user_id = user_id})
end

function vRPps.sellPropertyToPlayer(user_id, oldUser, property, number)
	MySQL.execute("vRP/sell_property", {user_id = user_id, oldUser = oldUser, property = property, number = number})
end

-- cbreturn user_id or nil
function vRPps.getUserBypAddress(property,cbr)
  local task = Task(cbr)

  MySQL.Async.fetchAll('SELECT user_id FROM vrp_user_properties WHERE property = @property', {['@property'] = property}, function(result)
    if #result > 0 then
	  task({result[1].user_id})
    else
      task()
    end  
  end)
end

-- find a free address number to buy
-- cbreturn number or nil if no numbers availables
function vRPps.findFreeNumber(property,max,cbr)
  local task = Task(cbr)

  local i = 1
  local function search()
    vRPps.getUserBypAddress(property,function(user_id)
      if user_id == nil then -- found
        task({i})
      else -- not found
        i = i+1
        if i <= max then -- continue search
          search()
        else -- global not found
          task()
        end
      end
    end)
  end

  search()
end

-- define property component (oncreate and ondestroy are called for each player entering/leaving a slot)
-- name: unique component id
-- oncreate(owner_id, slot_type, slot_id, cid, config, data, x, y, z, player)
-- ondestroy(owner_id, slot_type, slot_id, cid, config, data, x, y, z, player)
--- owner_id: user_id of house owner
--- slot_type: slot type name
--- slot_id: slot id for a specific type
--- cid: component id (for this slot)
--- config: component config
--- data: component datatable
--- x,y,z: component position
--- player: player joining/leaving the slot
function vRPps.defPropertyComponent(name, oncreate, ondestroy)
  components[name] = {oncreate,ondestroy}
end


-- SLOTS

-- used (or not) slots
local uslots = {}
for k,v in pairs(cfg.slot_ptypes) do
  uslots[k] = {}
  for l,w in pairs(v) do
    uslots[k][l] = {used=false}
  end
end

-- get players in the specified property slot
-- return map of user_id -> player source or nil if the slot is unavailable
function vRPps.getPropertySlotPlayers(stype, sid)
  local slot = uslots[stype][sid]
  if slot and slot.used then
    return slot.players
  end
end

-- return slot id or nil if no slot available
local function allocateSlot(stype)
  local slots = cfg.slot_ptypes[stype]
  if slots then
    local _uslots = uslots[stype]
    -- search the first unused slot
    for k,v in pairs(slots) do
      if _uslots[k] and not _uslots[k].used then
        _uslots[k].used = true -- set as used
        return k  -- return slot id
      end
    end
  end

  return nil
end

-- free a slot
local function freeSlot(stype, id)
  local slots = cfg.slot_ptypes[stype]
  if slots then
    uslots[stype][id] = {used = false} -- reset as unused
  end
end

-- get in use address slot (not very optimized yet)
-- return slot_type, slot_id or nil,nil
local function getpAddressSlot(property_name)
  for k,v in pairs(uslots) do
    for l,w in pairs(v) do
      if w.property_name == property_name then
        return k,l
      end
    end
  end

  return nil,nil
end

-- builds

local function is_empty(table)
  for k,v in pairs(table) do
    return false
  end

  return true
end

-- leave slot
local function leave_slot(user_id,player,stype,sid) -- called when a player leave a slot
  print(user_id.." leave slot "..stype.." "..sid)
  local slot = uslots[stype][sid]
  local property = cfg.propertys[slot.property_name]

  -- record if inside a property slot
  local tmp = vRP.getUserTmpTable({user_id})
  if tmp then
    tmp.property_stype = nil
    tmp.property_sid = nil
  end

  -- teleport to property entry point (outside)
  vRPclient.teleport(player, property.entry_point) -- already an array of params (x,y,z)

  -- uncount player
  slot.players[user_id] = nil

  -- destroy loaded components and special entry component
  for k,v in pairs(cfg.slot_ptypes[stype][sid]) do
    local name,x,y,z = table.unpack(v)

    if name == "entry" then
      -- remove marker/area
      local nid = "vRP:property:slot"..stype..sid
      vRPclient.removeNamedMarker(player,{nid})
      vRP.removeArea({player,nid})
    else
      local component = components[v[1]]
      if component then
        local data = slot.components[k]
        if not data then
          data = {}
          slot.components[k] = data
        end

        -- ondestroy(owner_id, slot_type, slot_id, cid, config, data, x, y, z, player)
        component[2](slot.owner_id, stype, sid, k, v._config or {}, data, x, y, z, player)
      end
    end
  end

  if is_empty(slot.players) then -- free the slot
    print("free slot "..stype.." "..sid)
    freeSlot(stype,sid)
  end
end

-- enter slot
local function enter_slot(user_id,player,stype,sid) -- called when a player enter a slot
  print(user_id.." enter slot "..stype.." "..sid)
  local slot = uslots[stype][sid]
  local property = cfg.propertys[slot.property_name]

  -- record inside a property slot
  local tmp = vRP.getUserTmpTable({user_id})
  if tmp then
    tmp.property_stype = stype
    tmp.property_sid = sid
  end

  -- count
  slot.players[user_id] = player

  -- build the slot entry menu
  local menu = {name=slot.property_name,css={top="75px",header_color="rgba(0,255,125,0.75)"}}
  menu[lang.property.slot.leave.title()] = {function(player,choice) -- add leave choice
    leave_slot(user_id,player,stype,sid)
  end}

  vRPps.getUserpAddress(user_id, function(address)
    -- check if owner
    if address ~= nil and address.property == slot.property_name and tostring(address.number) == slot.property_number then
      menu[lang.property.slot.ejectall.title()] = {function(player,choice) -- add eject all choice
        -- copy players before calling leave for each (iteration while removing)
        local copy = {}
        for k,v in pairs(slot.players) do
          copy[k] = v
        end

        for k,v in pairs(copy) do
          leave_slot(k,v,stype,sid)
        end
      end,lang.property.slot.ejectall.description()}
    end

    -- build the slot entry menu marker/area

    local function entry_enter(player,area)
      vRP.openMenu({player,menu})
    end

    local function entry_leave(player,area)
      vRP.closeMenu({player})
    end

    -- build components and special entry component
    for k,v in pairs(cfg.slot_ptypes[stype][sid]) do
      local name,x,y,z = table.unpack(v)

      if name == "entry" then
        -- teleport to the slot entry point
        vRPclient.teleport(player, {x,y,z}) -- already an array of params (x,y,z)

        local nid = "vRP:property:slot"..stype..sid
        vRPclient.setNamedMarker(player,{nid,x,y,z-1,0.7,0.7,0.5,0,255,125,125,150})
        vRP.setArea({player,nid,x,y,z,1,1.5,entry_enter,entry_leave})
      else -- load regular component
        local component = components[v[1]]
        if component then
        local data = slot.components[k]
        if not data then
          data = {}
          slot.components[k] = data
        end
          -- oncreate(owner_id, slot_type, slot_id, cid, config, data, x, y, z, player)
          component[1](slot.owner_id, stype, sid, k, v._config or {}, data, x, y, z, player)
        end
      end
    end
  end)
end

-- access a property by address
-- cbreturn true on success
function vRPps.accessProperty(user_id, property, cbr)
  local task = Task(cbr)

  local _property = cfg.propertys[property]
  local stype,slotid = getpAddressSlot(property) -- get current address slot
  local player = vRP.getUserSource({user_id})

  vRPps.getUserBypAddress(property, function(owner_id)
    if property ~= nil and player ~= nil then
      if stype == nil then -- allocate a new slot
        stype = _property.slot
        slotid = allocateSlot(_property.slot)

        if slotid ~= nil then -- allocated, set slot property infos
          local slot = uslots[stype][slotid]
          slot.property_name = property
          slot.owner_id = owner_id
          slot.players = {} -- map user_id => player
		  slot.components = {} -- components data
        end
      end

      if slotid ~= nil then -- slot available
        enter_slot(user_id,player,stype,slotid)
        task({true})
      end
    end
  end)
end

-- build the property entry menu
local function build_entry_menu(user_id, property_name)
  local property = cfg.propertys[property_name]
  local nicename = property.nice_name
  local menu = {name=property_name,css={top="75px",header_color="rgba(0,255,125,0.75)"}}

  -- intercom, used to enter in a property
  menu["Enter: "..nicename..""] = {function(player,choice)
      vRPps.getUserBypAddress(property_name,function(huser_id)
        if huser_id ~= nil then
		   --vRPps.getPropertyLock1(property_name, function(locked)
		    if vRPps.propertyGetlock(property) ~= "yes" then --  or vRPps.isEmployee(property_name,user_id)huser_id == user_id or  
			  vRPps.accessProperty(user_id, property_name, function(ok)
				if not ok then
				  vRPclient.notify(player,{lang.property.intercom.not_available()})
				end
			  end)
		    else 
			  vRPclient.notify(player,{"Property is closed!"})
            end
		  --end)
        else
          vRPclient.notify(player,{"Property is not owned yet!"})
        end
      end)
  end,lang.property.intercom.description()}

  menu[lang.property.buy.title()] = {function(player,choice)
    vRPps.getUserpAddress(user_id, function(address)
      if address == nil then -- check if not already have a property
        vRPps.findFreeNumber(property_name, property.max, function(number)
          if number ~= nil then
		     vRP.request({player,"Do you want to buy this property?",15,function(player,ok)
				if ok then

					if vRP.tryPayment({user_id, property.buy_price}) then
					  -- bought, set address
					  vRPps.setUserpAddress(user_id, property_name, number)

					  vRPclient.notify(player,{lang.property.buy.bought()})
					else
					  vRPclient.notify(player,{lang.money.not_enough()})
					end

				else
				  vRPclient.notify(player,{lang.common.request_refused()})
				end
			  end})
	
          else
            vRPclient.notify(player,{lang.property.buy.full()})
          end
        end)
      else
        vRPclient.notify(player,{lang.property.buy.have_property()})
      end
    end)
  end, lang.property.buy.description({property.buy_price})}

  menu[lang.property.sell.title()] = {function(player,choice)
	if player ~= nil then
		vRPclient.getNearestPlayers(player,{15},function(nplayers)
			vRPps.getUserpAddress(user_id, function(address)
				if address ~= nil and address.property == property_name then
					usrList = ""
					for k,v in pairs(nplayers) do
						usrList = usrList .. "[" .. vRP.getUserId({k}) .. "]" .. GetPlayerName(k) .. " | "
					end
					if usrList ~= "" then
						vRP.prompt({player,"Players Nearby: " .. usrList .. "","",function(player,buyerID) 
							buyerID = buyerID
							if buyerID ~= nil and buyerID ~= "" then
								local target = vRP.getUserSource({tonumber(buyerID)})
								if target ~= nil then
									vRP.prompt({player,"Price $: ","",function(player,amount)
										if (tonumber(amount)) then
											vRPps.getUserpAddress(buyerID, function(address2)
												--if address2 == nil and address2.property ~= nil then
												address2 = address2
												print(address2)
												--print(property_name)		
												if address2 ~= nil then --and address2.property ~= property_name
														print(address2)
														--print(address2.property)
														--print(property_name)
													vRPclient.notify(player,{"~r~The player already has a house."})
												else
													vRP.request({target,GetPlayerName(player).." wants to sell: " ..address.property.. " Price: $"..amount, 10, function(target,ok)
														if ok then
															local oldUser = vRP.getUserId({player})
															local NewUser = vRP.getUserId({target})
															local money = vRP.getMoney({NewUser})
															if (tonumber(money) >= tonumber(amount)) then
																vRPps.sellPropertyToPlayer(buyerID, oldUser, address.property, address.number)
																vRP.giveMoney({oldUser, amount})
																vRP.setMoney({NewUser,money-amount})
																vRPclient.notify(player,{"~g~You have successfully sold the house to ".. GetPlayerName(target).." for $"..amount.."!"})
																vRPclient.notify(target,{"~g~"..GetPlayerName(player).." has successfully sold you the house for $"..amount.."!"})
															else
																vRPclient.notify(player,{"~r~".. GetPlayerName(target).." doesn't have enough money!"})
																vRPclient.notify(target,{"~r~You don't have enough money!"})
															end
														else
															vRPclient.notify(player,{"~r~"..GetPlayerName(target).." has refused to buy the house."})
															vRPclient.notify(target,{"~r~You have refused to buy "..GetPlayerName(player).."'s house."})
														end
													end})
													vRP.closeMenu({player})
												end	
											end)
										else
											vRPclient.notify(player,{"~r~The price of the house has to be a number."})
										end
									end})
								else
									vRPclient.notify(player,{"~r~That ID seems invalid."})
								end
							else
								vRPclient.notify(player,{"~r~No player ID selected."})
							end
						end})
					else
						--vRPclient.notify(player,{"~r~No player nearby."})
						
						-- sold, give sell price, remove address
						vRP.giveMoney({user_id, property.sell_price})
						vRPps.removeUserpAddress(user_id)
						--vRPclient.notify(player,{lang.property.sell.sold()})
						vRPclient.notify(player,{"~r~"..lang.property.sell.sold().."+$"..property.sell_price.."!"})
					end
				else
					vRPclient.notify(player,{lang.property.sell.no_property()})
				end
			end)
		end)
	end
end, lang.property.sell.description({property.sell_price})}

  return menu
end


-- build propertys entry points
local function build_client_propertys(source)
  local user_id = vRP.getUserId({source})
  if user_id ~= nil then
    for k,v in pairs(cfg.propertys) do
      local x,y,z = table.unpack(v.entry_point)

      local function entry_enter(player,area)
        local user_id = vRP.getUserId({player})
        if user_id ~= nil and vRP.hasPermissions({user_id,v.permissions or {}}) then
          vRP.openMenu({source,build_entry_menu(user_id, k)})
        end
      end

      local function entry_leave(player,area)
        vRP.closeMenu({player})
      end

      vRPclient.addBlip(source,{x,y,z,v.blipid,v.blipcolor,k})
      vRPclient.addMarker(source,{x,y,z-1,0.7,0.7,0.5,0,255,125,125,150})

      vRP.setArea({source,"vRP:property"..k,x,y,z,1,1.5,entry_enter,entry_leave})
    end
  end
end

AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
  if first_spawn then -- first spawn, build propertys
    build_client_propertys(source)
  else -- death, leave property if inside one
    -- leave slot if inside one
    local tmp = vRP.getUserTmpTable({user_id})
    if tmp and tmp.property_stype then
      leave_slot(user_id, source, tmp.property_stype, tmp.property_sid)
    end
  end
end)

AddEventHandler("vRP:playerLeave",function(user_id, player) 
  -- leave slot if inside one
  local tmp = vRP.getUserTmpTable({user_id})
  if tmp and tmp.property_stype then
    leave_slot(user_id, player, tmp.property_stype, tmp.property_sid)
  end
end)



function task_update_tables()
print("Run Table Task Update")
  MySQL.ready(function ()
    for k,v in pairs(cfg.propertys) do
      vRPps.getUserBypAddress(k,function(huser_id)
        if huser_id ~= nil then
		  vRPps.getEmployees(k)
		  vRPps.getPropertyLock(k)
		  vRPps.getSalary(k)
		  print("updating property data "..k.." tables")
	    end
	  end)
    end
  end)
end
SetTimeout(12000, task_update_tables)