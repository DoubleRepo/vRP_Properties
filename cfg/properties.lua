
local cfg = {}

-- example of study transformer
local itemtr_study = {
  name="Bookcase", -- menu name
  r=0,g=255,b=0, -- color
  max_units=20,
  units_per_minute=10,
  x=0,y=0,z=0, -- pos (doesn't matter as home component)
  radius=1.1, height=1.5, -- area
  recipes = {
    ["Chemicals book"] = { -- action name
      description="Read a chemicals book", -- action description
      in_money=0, -- money taken per unit
      out_money=0, -- money earned per unit
      reagents={}, -- items taken per unit
      products={}, -- items given per unit
      aptitudes={ -- optional
        ["science.chemicals"] = 1 -- "group.aptitude", give 1 exp per unit
      }
    },
    ["Mathematics book"] = { -- action name
      description="Read a mathematics book", -- action description
      in_money=0, -- money taken per unit
      out_money=0, -- money earned per unit
      reagents={}, -- items taken per unit
      products={}, -- items given per unit
      aptitudes={ -- optional
        ["science.mathematics"] = 1 -- "group.aptitude", give 1 exp per unit
      }
    }
  }
}

-- example of radio stations
local radio_stations = {
  ["TechnoBase.FM"] = "http://mp3.stream.tb-group.fm:80/tt.ogg",
  ["Phate Radio"] = "http://phate.io/listen.ogg",
  ["RADIO 1 ROCK"] = "http://stream.radioreklama.bg:80/radio1rock.ogg",
  ["R 247drumandbass.com"] = "http://stream.247drumandbass.com:8000/256k.ogg"
}

-- default flats positions from https://github.com/Nadochima/HomeGTAV/blob/master/List

-- define the home slots (each entry coordinate should be unique for ALL types)
-- each slots is a list of home components
--- {component,x,y,z} (optional _config)
--- the entry component is required
cfg.slot_ptypes = {
  ["Club_1"] = {
    {
      {"entry",127.59546661377,-1295.9114990234,29.269533157349},
	  -- Boss Only
	  -- {"itemtr", _config = itemtr_study, -778.560241699219,333.439453125,211.197128295898},
      {"business",95.374404907227,-1293.4742431641,29.268745422363},
	  -- Employees only 
      {"chest",93.379821777344,-1291.6634521484,29.268747329712, _config = {weight=750}},
      {"wardrobe",105.13092041016,-1303.1324462891,28.768793106079},
	  {"radio", 121.59516143799,-1280.5037841797,29.480535507202, _config = { stations = radio_stations }},
	  -- Customers +
      {"shop",127.39650726318,-1283.712890625,29.278268814087},
      {"gametable",107.5002822876,-1286.7691650391,28.26095199585}
      --{"hookerpole",114.33921051025,-1285.0972900391,28.263967514038},
      --{"hookerlapdanceIN",118.89575958252,-1302.1402587891,29.269441604614},
      --{"hookerlapdanceOUT",120.59247589111,-1297.3101806641,29.662225723267},
    }
  },
  ["Market_1"] = {
    {
      {"entry",29.492937088013,-1347.6597900391,29.497026443481},
      -- Boss Only
      -- {"itemtr", _config = itemtr_study, -778.560241699219,333.439453125,211.197128295898},
      {"business",29.500717163086,-1339.6491699219,29.497045516968},
      -- Employees only 
      {"chest",30.991989135742,-1339.6326904297,29.497045516968, _config = {weight=100}},
      {"wardrobe",26.358654022217,-1341.0010986328,29.497045516968},
      --{"radio", 121.59516143799,-1280.5037841797,29.480535507202, _config = { stations = radio_stations }},
      -- Customers +
      {"shop",25.70975112915,-1345.3421630859,29.497041702271}
      --{"gametable",107.5002822876,-1286.7691650391,28.26095199585}
      --{"hookerpole",114.33921051025,-1285.0972900391,28.263967514038},
      --{"hookerlapdanceIN",118.89575958252,-1302.1402587891,29.269441604614},
      --{"hookerlapdanceOUT",120.59247589111,-1297.3101806641,29.662225723267},
    }
  },
  ["Market_2"] = {
    {
      {"entry",1964.4702148438,3741.53125,32.343742370605},
      -- Boss Only
      -- {"itemtr", _config = itemtr_study, -778.560241699219,333.439453125,211.197128295898},
      {"business",1960.3188476563,3749.1166992188,32.343746185303},
      -- Employees only 
      {"chest",1961.9190673828,3749.9846191406,32.347652435303, _config = {weight=100}},
      {"wardrobe",1958.5921630859,3746.5776367188,32.343746185303},
      --{"radio", 121.59516143799,-1280.5037841797,29.480535507202, _config = { stations = radio_stations }},
      -- Customers +
      {"shop",1960.6064453125,3741.6887207031,32.343738555908}
      --{"gametable",107.5002822876,-1286.7691650391,28.26095199585}
      --{"hookerpole",114.33921051025,-1285.0972900391,28.263967514038},
      --{"hookerlapdanceIN",118.89575958252,-1302.1402587891,29.269441604614},
      --{"hookerlapdanceOUT",120.59247589111,-1297.3101806641,29.662225723267},
    }
  },
  ["clothes_store_1"] = {
    {
      {"entry",126.43323516846,-213.36204528809,54.557834625244},
      -- Boss Only
      -- {"itemtr", _config = itemtr_study, -778.560241699219,333.439453125,211.197128295898},
      {"business",127.85315704346,-223.20654296875,54.557830810547},
      -- Employees only 
      {"chest",123.94325256348,-207.75189208984,54.557830810547, _config = {weight=50}},
      {"wardrobe",118.3793258667,-232.19825744629,54.557830810547},
      --{"radio", 121.59516143799,-1280.5037841797,29.480535507202, _config = { stations = radio_stations }},
      -- Customers +
      --{"shop",125.02968597412,-224.83961486816,54.55782699585}
	  {"skinshop",118.80840301514,-225.14518737793,54.557838439941},
	  {"cloakroom",123.02967071533,-228.80033874512,54.557838439941}

      --{"gametable",107.5002822876,-1286.7691650391,28.26095199585}
      --{"hookerpole",114.33921051025,-1285.0972900391,28.263967514038},
      --{"hookerlapdanceIN",118.89575958252,-1302.1402587891,29.269441604614},
      --{"hookerlapdanceOUT",120.59247589111,-1297.3101806641,29.662225723267},
    }
  },
  ["clothes_store_2"] = {
    {
      {"entry",0.02382655441761,6515.5625,31.889335632324},
      -- Boss Only
      -- {"itemtr", _config = itemtr_study, -778.560241699219,333.439453125,211.197128295898},
      {"business",6.4130511283875,6511.6787109375,31.877851486206},
      -- Employees only 
      {"chest",6.7352466583252,6508.7924804688,31.877851486206, _config = {weight=50}},
      {"wardrobe",3.7007031440735,6505.5971679688,31.877840042114},
      --{"radio", 121.59516143799,-1280.5037841797,29.480535507202, _config = { stations = radio_stations }},
      -- Customers +
      --{"shop",4.9452061653137,6512.6206054688,31.877853393555}--
	  {"skinshop",9.5607404708862,6512.63671875,31.877847671509},
	  {"cloakroom",11.552134513855,6514.3349609375,31.877847671509}
      --{"gametable",107.5002822876,-1286.7691650391,28.26095199585}

      --{"hookerpole",114.33921051025,-1285.0972900391,28.263967514038},
      --{"hookerlapdanceIN",118.89575958252,-1302.1402587891,29.269441604614},
      --{"hookerlapdanceOUT",120.59247589111,-1297.3101806641,29.662225723267},
    }
  },
  ["clothes stores_3"] = {
    {
      {"entry",1197.9752197266,2704.8227539063,38.234104156494},
      -- Boss Only
      -- {"itemtr", _config = itemtr_study, -778.560241699219,333.439453125,211.197128295898},
      {"business",1197.5627441406,2711.9963378906,38.222648620605},
      -- Employees only 
      {"chest",1197.6463623047,2713.9675292969,38.222644805908, _config = {weight=1000}},
      {"wardrobe",1199.1557617188,2713.4287109375,38.222618103027},
      --{"radio", 121.59516143799,-1280.5037841797,29.480535507202, _config = { stations = radio_stations }},
      -- Customers +
      --{"shop",1196.4488525391,2710.1528320313,38.222644805908}
	  {"skinshop",9.5607404708862,6512.63671875,31.877847671509}
      --{"gametable",107.5002822876,-1286.7691650391,28.26095199585}
      --{"hookerpole",114.33921051025,-1285.0972900391,28.263967514038},
      --{"hookerlapdanceIN",118.89575958252,-1302.1402587891,29.269441604614},
      --{"hookerlapdanceOUT",120.59247589111,-1297.3101806641,29.662225723267},
    }
  },
  ["gunshop_0"] = {
    {
      {"entry",18.045213699341,-1113.2196044922,29.797029495239},
	  {"TP",14.033089637756,-1106.1353759766,29.797025680542, _config = {x=13.430187225342,y=-1107.6280517578,z=29.797018051147}},
      -- Boss Only
      {"business",11.829648017883,-1108.6274414063,29.797012329102},
      -- Employees only 
      {"chest",24.762773513794,-1105.8198242188,29.797012329102, _config = {weight=500}},
      {"wardrobe",4.6607203483582,-1105.7377929688,29.79701423645},
      -- Customers +
	  {"gunshop",21.847332000732,-1107.1975097656,29.797025680542},
	  {"snacks",6.0988216400146,-1102.7489013672,29.797012329102},
	  {"sodas",8.0959024429321,-1109.9370117188,29.797012329102}
      --{"gametable",107.5002822876,-1286.7691650391,28.26095199585}

      --{"hookerpole",114.33921051025,-1285.0972900391,28.263967514038},
      --{"hookerlapdanceIN",118.89575958252,-1302.1402587891,29.269441604614},
      --{"hookerlapdanceOUT",120.59247589111,-1297.3101806641,29.662225723267},
    }
  },
  ["gunshop_1"] = {
    {
      {"entry",1698.2098388672,3753.4453125,34.705348968506},
	  --{"TP",14.033089637756,-1106.1353759766,29.797025680542, _config = {inside=13.430187225342,-1107.6280517578,29.797018051147}},
      -- Boss Only
      -- {"itemtr", _config = itemtr_study, -778.560241699219,333.439453125,211.197128295898},
      {"business",1695.8902587891,3761.0388183594,34.705341339111},
      -- Employees only 
      {"chest",1693.6297607422,3763.1906738281,34.7053565979, _config = {weight=500}},
      {"wardrobe",1698.6799316406,3758.8972167969,34.705326080322},
      --{"radio", 121.59516143799,-1280.5037841797,29.480535507202, _config = { stations = radio_stations }},
      -- Customers +
      --{"shop",1196.4488525391,2710.1528320313,38.222644805908}
	  --{"skinshop",9.5607404708862,6512.63671875,31.877847671509}
	  {"gunshop",1693.8508300781,3759.4924316406,34.705322265625}
      --{"gametable",107.5002822876,-1286.7691650391,28.26095199585}
      --{"hookerpole",114.33921051025,-1285.0972900391,28.263967514038},
      --{"hookerlapdanceIN",118.89575958252,-1302.1402587891,29.269441604614},
      --{"hookerlapdanceOUT",120.59247589111,-1297.3101806641,29.662225723267},
    }
  }  
}

-- define home clusters
cfg.propertys = {
  ["Club_1"] = {
    slot = "Club_1",
	nice_name = "Strip Club",
    entry_point = {130.1185760498,-1300.8355712891,29.23274230957},
    buy_price = 15000,
    sell_price = 10000,
    max = 1,
    blipid=375,
    blipcolor=7
  },
  ["Market_1"] = {
    slot = "Market_1",
	nice_name = "Food Store",
    entry_point = {29.182479858398,-1350.3502197266,29.332509994507},
    buy_price = 15000,
    sell_price = 10000,
    max = 1,
    blipid=375,
    blipcolor=7
  },
  ["Market_2"] = {
    slot = "Market_2",
	nice_name = "Food Store",
    entry_point = {1965.7312011719,3739.5102539063,32.316596984863},
    buy_price = 15000,
    sell_price = 10000,
    max = 1,
    blipid=375,
    blipcolor=7
  },
  ["clothes_store_1"] = {
    slot = "clothes_store_1",
	nice_name = "Clothing Store",
    entry_point = {127.59420013428,-209.76145935059,54.547676086426},
    buy_price = 15000,
    sell_price = 10000,
    max = 1,
    blipid=375,
    blipcolor=7
  },
  ["clothes_store_2"] = {
    slot = "clothes_store_2",
	nice_name = "Clothing Store",
    entry_point = {-1.9180542230606,6517.8735351563,31.481472015381},
    buy_price = 15000,
    sell_price = 10000,
    max = 1,
    blipid=375,
    blipcolor=7
  },
  ["clothes_store_3"] = {
    slot = "clothes_store_3",
	nice_name = "Clothing Store",
    entry_point = {1197.8951416016,2701.9067382813,38.156116485596},
    buy_price = 15000,
    sell_price = 10000,
    max = 1,
    blipid=375,
    blipcolor=7
  },
  ["gunshop_0"] = {
    slot = "gunshop_0",
	nice_name = "Gun Store",
    entry_point = {16.790309906006,-1116.6838378906,29.791179656982},
    buy_price = 15000,
    sell_price = 10000,
    max = 1,
    blipid=375,
    blipcolor=7
  },
  ["gunshop_1"] = {
    slot = "gunshop_1",
 	nice_name = "Gun Store",
	entry_point = {1699.6624755859,3751.8679199219,34.516696929932},
    buy_price = 15000,
    sell_price = 10000,
    max = 1,
    blipid=375,
    blipcolor=7
  }  
}

-- SHOPs
cfg.buyable_types = {
  ["food"] = {
    --_config = { hideme=false, blipid=52, blipcolor=2},

    -- list itemid => price
    -- Drinks
    ["milk"] = 12,
    ["water"] = 7,
    ["coffee"] = 15,
    ["tea"] = 12,
    ["icetea"] = 11,
    ["orangejuice"] = 14,
    ["cocacola"] = 9,
    ["redbull"] = 11,
    ["lemonade"] = 11,
    ["vodka"] = 18,

    --Food
    ["bread"] = 13,
    ["donut"] = 15,
    ["tacos"] = 17,
    ["sandwich"] = 11,
    ["kebab"] = 16,
    ["pdonut"] = 18,
	
	-- Others
	["filter"] = 20,
	["preservative"] = 34,
	--["hammer"] = 250,
	["pills"] = 2500,
	["lockpicking_kit"] = 2000,
	["croquettes"] = 4
	
  }
}

cfg.gunshops_listings = {
  ["LegalGuns"] = {
	--["ARMOR"] = {"Body Armor",10000,0,""},
	--["WEAPON_STUNGUN"] = {"Tazer",264,0,""},
    ["WEAPON_BAT"] = {"Bat",50,0,""},
    ["WEAPON_KNIFE"] = {"Knife",50,0,""},
    ["WEAPON_PISTOL"] = {"Pistol",2500,2,""},
    --["WEAPON_DAGGER"] = {"Dagger",100,0,""},
    --["WEAPON_HAMMER"] = {"Hammer",50,0,""},
    --["WEAPON_HATCHET"] = {"Hatchet",122,0,""},
    --["WEAPON_CROWBAR"] = {"Crowwbar",163,0,""},
    --["WEAPON_GOLFCLUB"] = {"Golf club",140,0,""},
    --["WEAPON_SWITCHBLADE"] = {"Blade",550,0,""},
    ["WEAPON_FLARE"] = {"Flare",10,10,""},
    --["WEAPON_SAWNOFFSHOTGUN"] = {"Saw Shotgun",30000,65,""},
    --["WEAPON_FIREWORK"] = {"Firework",20,0,""},
    --["WEAPON_SNOWBALL"] = {"SnowBall",3000000,0,""},
    ["WEAPON_FLASHLIGHT"] = {"FlashLight",20,0,""},
    --["WEAPON_FLAREGUN"] = {"Flaregun",35,0,""},
    --["WEAPON_PETROLCAN"] = {"Petrol",90,0,""},
    ["WEAPON_BALL"] = {"Dog Ball",2,0,""}
  }
}

-- Candy machines
cfg.soda_machine = {
  ["Soda"] = {
	["icetea"] = 11,
    ["orangejuice"] = 14,
    ["cocacola"] = 9,
    ["redbull"] = 11,
    ["lemonade"] = 11
  }
}
-- Candy machines
cfg.snack_machine = {
  ["Snack"] = {
    ["donut"] = 15,
    ["tacos"] = 17,
    ["sandwich"] = 11,
    ["kebab"] = 16,
    ["pdonut"] = 18
  }
}

-- Skin Shop

local surgery_male = { model = "mp_m_freemode_01" }
local surgery_female = { model = "mp_f_freemode_01" }

for i=0,19 do
  surgery_female[i] = {0,0}
  surgery_male[i] = {0,0}
end

cfg.cloakroom_property = {
  ["surgery"] = {
    _config = { not_uniform = true },
    ["Male"] = surgery_male,
    ["Female"] = surgery_female
  }
}


cfg.skinparts = {
  ["Face"] = 0,
  ["Hair"] = 2,
  ["Hand"] = 3,
  ["Legs"] = 4,
  ["Shirt"] = 8,
  ["Shoes"] = 6,
  ["Jacket"] = 11,
  ["Hats"] = "p0",
  ["Glasses"] = "p1",
  ["Ears"] = "p2",
  ["Watches"] = "p6",
  ["Extras 1"] = 9,
  ["Extras2"] = 10
}

-- changes prices (any change to the character parts add amount to the total price)
cfg.drawable_change_price = 20
cfg.texture_change_price = 10


return cfg
