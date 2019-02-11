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

--
local components = {}
--


-- Base functions to retrieve / save tables
--
function vRPps.SaveTables(property)
  if vRPps.property_Employeetables[property] ~= nil then
    local employees = vRPps.property_employees(property)
	MySQL.Async.execute('UPDATE vrp_user_properties SET employees = @employees WHERE property = @property', {['@employees'] = employees, ['@property'] = property})
  end
  if vRPps.property_Salarytables[property] ~= nil then
    local salary = vRPps.property_salary(property)
	MySQL.Async.execute('UPDATE vrp_user_properties SET salary = @salary WHERE property = @property', {['@salary'] = salary, ['@property'] = property})
  end
  if vRPps.property_locks[property] ~= nil then
    local locked = vRPps.propertyGetlock(property)
	MySQL.Async.execute('UPDATE vrp_user_properties SET locked = @locked WHERE property = @property', {['@locked'] = locked, ['@property'] = property})
  end
  if vRPps.property_adjustments[property] ~= nil then
    local price_adjustment = vRPps.propertyGetadjustments(property)
	MySQL.Async.execute('UPDATE vrp_user_properties SET price_adjustment = @price_adjustment WHERE property = @property', {['@price_adjustment'] = price_adjustment, ['@property'] = property})
  end
end
 
--
function vRPps.RetrieveTables(property)
  if vRPps.property_Employeetables[property] == nil then
	MySQL.Async.fetchAll('SELECT employees FROM vrp_user_properties WHERE property = @property', {['@property'] = property}, function(result)
	  local etable = json.decode(result[1].employees)
	  if type(etable) == "table" then 
	    vRPps.property_Employeetables[property] = etable
	  end
	end)
  end

  if vRPps.property_Salarytables[property] == nil then
	MySQL.Async.fetchAll('SELECT salary FROM vrp_user_properties WHERE property = @property', {['@property'] = property}, function(result)
	  local etable = json.decode(result[1].salary)
	  if type(etable) == "table" then 
	    vRPps.property_Salarytables[property] = etable
	  end
	end)
  end

  if vRPps.property_locks[property] == nil then
	MySQL.Async.fetchAll('SELECT locked FROM vrp_user_properties WHERE property = @property', {['@property'] = property}, function(result)
	  vRPps.property_locks[property] = result[1].locked
	end)
  end

  if vRPps.property_adjustments[property] == nil then
	MySQL.Async.fetchAll('SELECT price_adjustment FROM vrp_user_properties WHERE property = @property', {['@property'] = property}, function(result)
	  vRPps.property_adjustments[property] = result[1].price_adjustment
	end)
  end
  
end




-- property_Employeetables data tables (logger storage, saved to database) and their associated functions
--
vRPps.property_Employeetables = {}
--
function vRPps.property_employees(property)
  return vRPps.property_Employeetables[property]
end
--
function vRPps.setproperty_employees(property,value)
  if value == "0" then 
    vRPps.property_Employeetables[property] = nil
  else
	vRPps.property_Employeetables[property] = value
  end
end
--
function vRPps.isEmployee(property,user_id)
    local data = vRPps.property_employees(property)
	if type(data) == "table" then 
      for k,v in pairs(data.employee) do
	    if tonumber(k) == tonumber(user_id) then
	      return true
	    end
      end
	end
  return false
end
--
function vRPps.AddEmployee(user_id,property)
  if not vRPps.IsEmployee(property,user_id) then
    vRPps.setproperty_employees(property,"true")
	print("Employee Added")
  end
end
--
function vRPps.RemoveEmployee(user_id,property)
  if vRPps.IsEmployee(property,user_id) then
	vRPps.setproperty_employees(property,"0")
	print("Employee Removed")
  end
end





-- property_Salarytables data tables (logger storage, saved to database) and their associated functions
--
vRPps.property_Salarytables = {}
--
function vRPps.property_salary(property)
  return vRPps.property_Salarytables[property]
end






-- property_locks data tables (logger storage, saved to database) and their associated functions
--
vRPps.property_locks = {}
--
function vRPps.propertyGetlock(property)
  return vRPps.property_locks[property]
end
--
function vRPps.setPropertyLock(property,locked)
  vRPps.property_locks[property] = locked
end
--
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







-- price adjustments data tables (logger storage, saved to database) and their associated functions
--

vRPps.property_adjustments = {}
--
function vRPps.propertyGetadjustments(property)
  return vRPps.property_adjustments[property]
end
--
function vRPps.setPriceadjustment(property,price)
  vRPps.property_adjustments[property] = locked
  --MySQL.Async.execute('UPDATE vrp_user_properties SET price_adjustment = @price WHERE property = @property', {['@price'] = price, ['@property'] = property})
end





--
function vRPps.getPropertySales(property, cbr)
  local task = Task(cbr)
  MySQL.Async.fetchAll('SELECT sales FROM vrp_user_properties WHERE property = @property', {['@property'] = property}, function(result)
	task({result[1].sales})
  end)
end
--
function vRPps.getPropertyEarned(property, cbr)
  local task = Task(cbr)
  MySQL.Async.fetchAll('SELECT earned FROM vrp_user_properties WHERE property = @property', {['@property'] = property}, function(result)
	task({result[1].earned})
  end)
end
--
function vRPps.UpdatePropertyInfo(price,amount,stype)
  vRPps.getPropertyEarned(stype, function(earned)
    vRPps.getPropertySales(stype, function(sales)
	  local earned = earned+price
	  local sales = sales+amount
	  MySQL.Async.execute('UPDATE vrp_user_properties SET sales = @sales, earned = @earned WHERE property = @stype', {['@sales'] = sales, ['@earned'] = earned, ['@stype'] = stype})
    end)
  end)
end







--
function vRPps.getUserpAddress(user_id, cbr)
  local task = Task(cbr)
  MySQL.Async.fetchAll('SELECT property, number FROM vrp_user_properties WHERE user_id = @user_id', {['@user_id'] = user_id}, function(result)
    task({result[1]})
  end)
end
--
function vRPps.setUserpAddress(user_id,property,number)
  MySQL.Async.execute('REPLACE INTO vrp_user_properties(user_id,property,number) VALUES(@user_id,@property,@number)', {['@user_id'] = user_id, ['@property'] = property, ['@number'] = number})
end
--
function vRPps.removeUserpAddress(user_id)
  MySQL.Async.execute('DELETE FROM vrp_user_properties WHERE user_id = @user_id and property = @property', {['@user_id'] = user_id, ['@property'] = property})
end
--
function vRPps.sellPropertyToPlayer(user_id, oldUser, property, number)
  MySQL.Async.execute('UPDATE vrp_user_properties SET user_id = @user_id, property = @property, number = @number WHERE user_id = @oldUser, property = @property, number = @number',{['@user_id'] = user_id, ['@property'] = property, ['@number'] = number, ['@oldUser'] = oldUser})
end
--
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
--
function vRPps.findFreeNumber(property,max,cbr)
  local task = Task(cbr)

  local i = 1
  --local function search()
    vRPps.getUserBypAddress(property,function(user_id)
      if user_id == nil then -- found
        task({i})
      else -- not found
        --i = i+1
        --if i <= max then -- continue search
        --  search()
        --else -- global not found
          task()
        --end
      end
    end)
  --end

  --search()
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
  local menu = {name=property_name,css={top="75px",header_color="rgba(0,255,125,0.75)"}}

  menu["Enter: "..property.nice_name..""] = {function(player,choice)
      vRPps.getUserBypAddress(property_name,function(huser_id)
        if huser_id ~= nil then
		    if huser_id == user_id or vRPps.propertyGetlock(property) ~= "yes" or vRPps.isEmployee(property_name,user_id) then 
			  vRPps.accessProperty(user_id, property_name, function(ok)
				if not ok then
				  vRPclient.notify(player,{lang.property.intercom.not_available()})
				end
			  end)
		    else 
			  vRPclient.notify(player,{"Property is closed!"})
            end
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
						address2 = address2
						if address2 ~= nil then
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
			    vRP.giveMoney({user_id, property.sell_price})
			    vRPps.removeUserpAddress(user_id)
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
        if user_id ~= nil then
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


function task_save_datatables()
  TriggerEvent("vRP:save")

  Debug.pbegin("vRP save property datatables")
    for k,v in pairs(cfg.propertys) do
      vRPps.getUserBypAddress(k,function(var)
        if var ~= nil then
		  vRPps.SaveTables(k)
	    end
	  end)
    end

  Debug.pend()
  SetTimeout(60*1000, task_save_datatables)
end

function task_update_tables()
  MySQL.ready(function ()
    for k,v in pairs(cfg.propertys) do
      vRPps.getUserBypAddress(k,function(var)
        if var ~= nil then
		  vRPps.RetrieveTables(k)
	    end
	  end)
    end
  end)
  SetTimeout(config.save_interval*1000, task_save_datatables)
end
SetTimeout(5000, task_update_tables)




