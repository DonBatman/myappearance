-- Mod:         myappearance
-- File:        init.lua
-- License:     CC BY-NC-SA 4.0
-- Attribution: Don Michaud
-- Revision:    160813

myappearance = {}
local DATAFILE = "myappearance.dat"
local DATAPATH = minetest.get_worldpath() .. "/" .. DATAFILE

-- ===================================================================
-- Save/Read file functions

function read_myappearance()
    local f, err = io.open (DATAPATH, "r")
    if err then return end
    if f then
        local data = minetest.deserialize (f:read("*a"))
        f:close()
        return data
    end
end

function save_myappearance()
    local file = io.open (DATAPATH, "w")
    file:write (minetest.serialize (myappearance))
    file:close()
end

-- ===================================================================
-- Load appearance data.

local f, err = io.open (DATAPATH, "r")
if f then
    myappearance = read_myappearance()
    f:close()
end

-- ===================================================================
-- Base Textures

local APMALE   = "appearance_male_"
local APFEMALE = "appearance_female_"

local mskin    = APMALE .. "skin.png"
local mpants   = APMALE .. "pants.png"
local mshirt   = APMALE .. "shirt.png"
local mshoes   = APMALE .. "shoes.png"
local mface    = APMALE .. "face.png"
local meyes    = APMALE .. "eyes.png"
local mbelt    = APMALE .. "belt.png"
local moverlay = APMALE .. "overlay.png"
local mhair    = APMALE .. "hair.png"

local fskin    = APFEMALE .. "skin.png"
local fpants   = APFEMALE .. "pants.png"
local fshirt   = APFEMALE .. "shirt.png"
local fshoes   = APFEMALE .. "shoes.png"
local fface    = APFEMALE .. "face.png"
local feyes    = APFEMALE .. "eyes.png"
local fbelt    = APFEMALE .. "belt.png"
local foverlay = APFEMALE .. "overlay.png"
local fhair    = APFEMALE .. "hair.png"

-- ===================================================================
-- Function to set a player's appearance

function myappearance_update (name)
    local player = minetest.get_player_by_name (name)
    if myappearance and myappearance [name] then
        local apname     = myappearance [name]

        local skintex    = apname.skin
        local pantstex   = apname.pants
        local shirttex   = apname.shirt
        local shoestex   = apname.shoes
        local facetex    = apname.face
        local eyestex    = apname.eyes
        local belttex    = apname.belt
        local overlaytex = apname.overlay
        local hairtex    = apname.hair

        player:set_properties ({
            mesh = "myappearance_character.b3d" ,
            textures = {
skintex    .. pantstex   .. shirttex   .. shoestex   ..
facetex    .. eyestex    .. belttex    .. overlaytex ..
hairtex
            } ,
            visual = "mesh" ,
            visual_size = { x=1, y=1} ,
        })
    end
end

-- ===================================================================
-- Chat Commands

local colors_table = {
    { "black"     , "Black"      , "#000000b0" } ,
    { "blue"      , "Blue"       , "#015dbb70" } ,
    { "brown"     , "Brown"      , "#a78c4570" } ,
    { "cyan"      , "Cyan"       , "#01ffd870" } ,
    { "darkgreen" , "Dark Green" , "#005b0770" } ,
    { "darkgrey"  , "Dark Grey"  , "#303030b0" } ,
    { "green"     , "Green"      , "#61ff0170" } ,
    { "grey"      , "Grey"       , "#5b5b5bb0" } ,
    { "magenta"   , "Magenta"    , "#ff05bb70" } ,
    { "orange"    , "Orange"     , "#ff840170" } ,
    { "pink"      , "Pink"       , "#ff65b570" } ,
    { "red"       , "Red"        , "#ff000070" } ,
    { "violet"    , "Violet"     , "#2000c970" } ,
    { "white"     , "White"      , "#abababc0" } ,
    { "yellow"    , "Yellow"     , "#e3ff0070" } ,
}

-- ===================================================================

local function change_myappearance(name,fields)
    local f = minetest.serialize(fields)
    for i in ipairs(colors_table) do
        local col = colors_table[i][1]

        if string.find(f,"sex") ~= nil then
            if string.find(f, "female") ~= nil then
                    myappearance[name].sex = "female"
                    myappearance[name].skin = fskin.."^"
                    myappearance[name].pants = fpants.."^"
                    myappearance[name].shirt = fshirt.."^"
                    myappearance[name].shoes = fshoes.."^"
                    myappearance[name].face = fface.."^"
                    myappearance[name].eyes = "("..feyes.."^[colorize:blue:220)^"
                    myappearance[name].belt = "("..fbelt.."^[colorize:blue:220)^"
                    myappearance[name].overlay = foverlay.."^"
                    myappearance[name].hair = fhair
            else
                    myappearance[name].sex = "male"
                    myappearance[name].skin = mskin.."^"
                    myappearance[name].pants = mpants.."^"
                    myappearance[name].shirt = mshirt.."^"
                    myappearance[name].shoes = mshoes.."^"
                    myappearance[name].face = mface.."^"
                    myappearance[name].eyes = "("..meyes.."^[colorize:blue:220)^"
                    myappearance[name].belt = "("..mbelt.."^[colorize:blue:220)^"
                    myappearance[name].overlay = moverlay.."^"
                    myappearance[name].hair = mhair
            end
        elseif string.find(f,"skin") ~= nil then
            local b = string.find(f, "%d" )
            local c = tonumber(string.sub(f, b, b + 1))
            if c ~= nil then
                myappearance.skin_col = c
                if myappearance[name].sex == "male" then
                    myappearance[name].skin = "("..mskin.."^[colorize:#4b2700:"..tostring(c*20)..")^"
                else
                    myappearance[name].skin = "("..fskin.."^[colorize:#4b2700:"..tostring(c*20)..")^"
                end
                
            end
        elseif string.find(f,"eyes") ~= nil then
            if string.find(f, col) ~= nil then
                myappearance.eyes_col = col
                if myappearance[name].sex == "male" then
                    myappearance[name].eyes = "("..meyes.."^[colorize:"..col..":220)^"
                else
                    myappearance[name].eyes = "("..feyes.."^[colorize:"..col..":220)^"
                end
            end
        elseif string.find(f,"hair") ~= nil then
            if string.find(f, col) ~= nil then
                myappearance.hair_col = col
                if myappearance[name].sex == "male" then
                    myappearance[name].hair = "("..mhair.."^[colorize:"..col..":220)"
                else
                    myappearance[name].hair = "("..fhair.."^[colorize:"..col..":220)"
                end
            end
        elseif string.find(f,"shirt") ~= nil then
            if string.find(f, col) ~= nil then
                myappearance.shirt_col = col
                if myappearance[name].sex == "male" then
                    myappearance[name].shirt = "("..mshirt.."^[colorize:"..col..":200)^"
                else
                    myappearance[name].shirt = "("..fshirt.."^[colorize:"..col..":200)^"
                end
            end
        elseif string.find(f,"pants") ~= nil then
            if string.find(f, col) ~= nil then
                myappearance.pants_col = col
                if myappearance[name].sex == "male" then
                    myappearance[name].pants = "("..mpants.."^[colorize:"..col..":200)^"
                else
                    myappearance[name].pants = "("..fpants.."^[colorize:"..col..":200)^"
                end
            end
        elseif string.find(f,"shoes") ~= nil then
            if string.find(f, col) ~= nil then
                myappearance.shoes_col = col
                if myappearance[name].sex == "male" then
                    myappearance[name].shoes = "("..mshoes.."^[colorize:"..col..":150)^"
                else
                    myappearance[name].shoes = "("..fshoes.."^[colorize:"..col..":240)^"
                end
            end
        elseif string.find(f,"belt") ~= nil then
            if string.find(f, col) ~= nil then
            myappearance.belt_col = col
                if myappearance[name].sex == "male" then
                    myappearance[name].belt = "("..mbelt.."^[colorize:"..col..":220)^"
                else
                    myappearance[name].belt = "("..fbelt.."^[colorize:"..col..":220)^"
                end
            end
        else
            return
        end
    end
    myappearance_update(name)
    save_myappearance()
end

-- ===================================================================

local myappearance_form_mirror =
        "size[8.5,6;]"..
        --"bgcolor[#40a7dc;true]"..
        "background[0,0;8.5,6.25;appearance_form_background.png]"..

        --Sex
        "label[0.5,0.5;Male or Female]"..
        "image_button[2.5,0.5;1,1;appearance_male.png;sex_male;]"..
        "image_button[4,0.5;1,1;appearance_female.png;sex_female;]"..

        --Skin
        "label[0.5,1.5;Skin Color]"..
        "image_button[0.5,2;0.5,0.5;appearance_skin01.png;skin_01;]"..
        "image_button[1,2;0.5,0.5;appearance_skin02.png;skin_02;]"..
        "image_button[1.5,2;0.5,0.5;appearance_skin03.png;skin_03;]"..
        "image_button[2,2;0.5,0.5;appearance_skin04.png;skin_04;]"..
        "image_button[2.5,2;0.5,0.5;appearance_skin05.png;skin_05;]"..
        "image_button[3,2;0.5,0.5;appearance_skin06.png;skin_06;]"..
        "image_button[3.5,2;0.5,0.5;appearance_skin07.png;skin_07;]"..
        "image_button[4,2;0.5,0.5;appearance_skin08.png;skin_08;]"..
        "image_button[4.5,2;0.5,0.5;appearance_skin09.png;skin_09;]"..
        "image_button[5,2;0.5,0.5;appearance_skin10.png;skin_10;]"..

        --Eyes
        "label[0.5,2.5;Eye Color]"..
        "image_button[0.5,3;0.5,0.5;wool_black.png;eyes_black;]"..
        "image_button[1,3;0.5,0.5;wool_blue.png;eyes_blue;]"..
        "image_button[1.5,3;0.5,0.5;wool_brown.png;eyes_brown;]"..
        "image_button[2,3;0.5,0.5;wool_cyan.png;eyes_cyan;]"..
        "image_button[2.5,3;0.5,0.5;wool_dark_green.png;eyes_darkgreen;]"..
        "image_button[3,3;0.5,0.5;wool_dark_grey.png;eyes_darkgray;]"..
        "image_button[3.5,3;0.5,0.5;wool_green.png;eyes_green;]"..
        "image_button[4,3;0.5,0.5;wool_grey.png;eyes_gray;]"..
        "image_button[4.5,3;0.5,0.5;wool_magenta.png;eyes_magenta;]"..
        "image_button[5,3;0.5,0.5;wool_orange.png;eyes_orange;]"..
        "image_button[5.5,3;0.5,0.5;wool_pink.png;eyes_pink;]"..
        "image_button[6,3;0.5,0.5;wool_red.png;eyes_red;]"..
        "image_button[6.5,3;0.5,0.5;wool_violet.png;eyes_violet;]"..
        "image_button[7,3;0.5,0.5;wool_white.png;eyes_white;]"..
        "image_button[7.5,3;0.5,0.5;wool_yellow.png;eyes_yellow;]"..

        --Hair
        "label[0.5,3.5;Hair Color]"..
        "image_button[0.5,4;0.5,0.5;wool_black.png;hair_black;]"..
        "image_button[1,4;0.5,0.5;wool_blue.png;hair_blue;]"..
        "image_button[1.5,4;0.5,0.5;wool_brown.png;hair_brown;]"..
        "image_button[2,4;0.5,0.5;wool_cyan.png;hair_cyan;]"..
        "image_button[2.5,4;0.5,0.5;wool_dark_green.png;hair_darkgreen;]"..
        "image_button[3,4;0.5,0.5;wool_dark_grey.png;hair_darkgray;]"..
        "image_button[3.5,4;0.5,0.5;wool_green.png;hair_green;]"..
        "image_button[4,4;0.5,0.5;wool_grey.png;hair_gray;]"..
        "image_button[4.5,4;0.5,0.5;wool_magenta.png;hair_magenta;]"..
        "image_button[5,4;0.5,0.5;wool_orange.png;hair_orange;]"..
        "image_button[5.5,4;0.5,0.5;wool_pink.png;hair_pink;]"..
        "image_button[6,4;0.5,0.5;wool_red.png;hair_red;]"..
        "image_button[6.5,4;0.5,0.5;wool_violet.png;hair_violet;]"..
        "image_button[7,4;0.5,0.5;wool_white.png;hair_white;]"..
        "image_button[7.5,4;0.5,0.5;wool_yellow.png;hair_yellow;]"..

        "button_exit[6.5,5;1.5,1;exit;Exit]"

local myappearance_form_wardrobe =
        "size[8.5,6;]"..
        --"bgcolor[#0000;false]"..
        "background[0,0;8.5,6.25;appearance_form_background.png]"..

        --Shirt
        "label[0.5,0.5;Shirt Color]"..
        "image_button[0.5,1;0.5,0.5;wool_black.png;shirt_black;]"..
        "image_button[1,1;0.5,0.5;wool_blue.png;shirt_blue;]"..
        "image_button[1.5,1;0.5,0.5;wool_brown.png;shirt_brown;]"..
        "image_button[2,1;0.5,0.5;wool_cyan.png;shirt_cyan;]"..
        "image_button[2.5,1;0.5,0.5;wool_dark_green.png;shirt_darkgreen;]"..
        "image_button[3,1;0.5,0.5;wool_dark_grey.png;shirt_darkgray;]"..
        "image_button[3.5,1;0.5,0.5;wool_green.png;shirt_green;]"..
        "image_button[4,1;0.5,0.5;wool_grey.png;shirt_gray;]"..
        "image_button[4.5,1;0.5,0.5;wool_magenta.png;shirt_magenta;]"..
        "image_button[5,1;0.5,0.5;wool_orange.png;shirt_orange;]"..
        "image_button[5.5,1;0.5,0.5;wool_pink.png;shirt_pink;]"..
        "image_button[6,1;0.5,0.5;wool_red.png;shirt_red;]"..
        "image_button[6.5,1;0.5,0.5;wool_violet.png;shirt_violet;]"..
        "image_button[7,1;0.5,0.5;wool_white.png;shirt_white;]"..
        "image_button[7.5,1;0.5,0.5;wool_yellow.png;shirt_yellow;]"..

        --Pants
        "label[0.5,1.5;Pants Color]"..
        "image_button[0.5,2;0.5,0.5;wool_black.png;pants_black;]"..
        "image_button[1,2;0.5,0.5;wool_blue.png;pants_blue;]"..
        "image_button[1.5,2;0.5,0.5;wool_brown.png;pants_brown;]"..
        "image_button[2,2;0.5,0.5;wool_cyan.png;pants_cyan;]"..
        "image_button[2.5,2;0.5,0.5;wool_dark_green.png;pants_darkgreen;]"..
        "image_button[3,2;0.5,0.5;wool_dark_grey.png;pants_darkgray;]"..
        "image_button[3.5,2;0.5,0.5;wool_green.png;pants_green;]"..
        "image_button[4,2;0.5,0.5;wool_grey.png;pants_gray;]"..
        "image_button[4.5,2;0.5,0.5;wool_magenta.png;pants_magenta;]"..
        "image_button[5,2;0.5,0.5;wool_orange.png;pants_orange;]"..
        "image_button[5.5,2;0.5,0.5;wool_pink.png;pants_pink;]"..
        "image_button[6,2;0.5,0.5;wool_red.png;pants_red;]"..
        "image_button[6.5,2;0.5,0.5;wool_violet.png;pants_violet;]"..
        "image_button[7,2;0.5,0.5;wool_white.png;pants_white;]"..
        "image_button[7.5,2;0.5,0.5;wool_yellow.png;pants_yellow;]"..

        --Shoes
        "label[0.5,2.5;Shoes Color]"..
        "image_button[0.5,3;0.5,0.5;wool_black.png;shoes_black;]"..
        "image_button[1,3;0.5,0.5;wool_blue.png;shoes_blue;]"..
        "image_button[1.5,3;0.5,0.5;wool_brown.png;shoes_brown;]"..
        "image_button[2,3;0.5,0.5;wool_cyan.png;shoes_cyan;]"..
        "image_button[2.5,3;0.5,0.5;wool_dark_green.png;shoes_darkgreen;]"..
        "image_button[3,3;0.5,0.5;wool_dark_grey.png;shoes_darkgray;]"..
        "image_button[3.5,3;0.5,0.5;wool_green.png;shoes_green;]"..
        "image_button[4,3;0.5,0.5;wool_grey.png;shoes_gray;]"..
        "image_button[4.5,3;0.5,0.5;wool_magenta.png;shoes_magenta;]"..
        "image_button[5,3;0.5,0.5;wool_orange.png;shoes_orange;]"..
        "image_button[5.5,3;0.5,0.5;wool_pink.png;shoes_pink;]"..
        "image_button[6,3;0.5,0.5;wool_red.png;shoes_red;]"..
        "image_button[6.5,3;0.5,0.5;wool_violet.png;shoes_violet;]"..
        "image_button[7,3;0.5,0.5;wool_white.png;shoes_white;]"..
        "image_button[7.5,3;0.5,0.5;wool_yellow.png;shoes_yellow;]"..

        --Belt
        "label[0.5,3.5;Belt Color]"..
        "image_button[0.5,4;0.5,0.5;wool_black.png;belt_black;]"..
        "image_button[1,4;0.5,0.5;wool_blue.png;belt_blue;]"..
        "image_button[1.5,4;0.5,0.5;wool_brown.png;belt_brown;]"..
        "image_button[2,4;0.5,0.5;wool_cyan.png;belt_cyan;]"..
        "image_button[2.5,4;0.5,0.5;wool_dark_green.png;belt_darkgreen;]"..
        "image_button[3,4;0.5,0.5;wool_dark_grey.png;belt_darkgray;]"..
        "image_button[3.5,4;0.5,0.5;wool_green.png;belt_green;]"..
        "image_button[4,4;0.5,0.5;wool_grey.png;belt_gray;]"..
        "image_button[4.5,4;0.5,0.5;wool_magenta.png;belt_magenta;]"..
        "image_button[5,4;0.5,0.5;wool_orange.png;belt_orange;]"..
        "image_button[5.5,4;0.5,0.5;wool_pink.png;belt_pink;]"..
        "image_button[6,4;0.5,0.5;wool_red.png;belt_red;]"..
        "image_button[6.5,4;0.5,0.5;wool_violet.png;belt_violet;]"..
        "image_button[7,4;0.5,0.5;wool_white.png;belt_white;]"..
        "image_button[7.5,4;0.5,0.5;wool_yellow.png;belt_yellow;]"..

        "button_exit[6.5,5;1.5,1;exit;Exit]"

-- ===================================================================
-- Sets Player appearance on first join

-- minetest.register_on_newplayer (function (player)

local function newplayer (player)
    local name = player:get_player_name()
    myappearance [name] = {
        sex = "male",
        skin = mskin.."^",
        skin_col = "4",
        pants = mpants.."^",
        pants_col = "blue",
        shirt = mshirt.."^",
        shirt_col = "green",
        shoes = mshoes.."^",
        shoes_col = "black",
        belt = mbelt.."^",
        belt_col = "black",
        face = mface.."^",
        eyes = meyes.."^",
        eyes_col = "blue",
        overlay = moverlay.."^",
        hair = mhair,
        hair_col = "brown",
    }

    save_myappearance()
    default.player_register_model("myappearance_character.b3d", {
    animation_speed = 30,
    textures = {"character.png"},
    animations = {
            stand     = {x=0, y=79},
            lay       = {x=162, y=166},
            walk      = {x=168, y=187},
            mine      = {x=189, y=198},
            walk_mine = {x=200, y=219},
            sit       = {x=81, y=160},
            }

        })

    --minetest.show_formspec(name, "myappearance", myappearance_form)
    minetest.register_on_player_receive_fields(function(player, formname, fields)
        local name = player:get_player_name()
        if formname == "myappearance" then
            change_myappearance(name,fields)
        end
    end)
end

-- ===================================================================
-- Update appearance when the player joins

minetest.register_on_joinplayer (function (player)
    local name = player:get_player_name()

    if myappearance [name] then
        myappearance_update (name)
    else
        newplayer (player)
    end
end)

-- ===================================================================
--mirror and wardrobe nodes
minetest.register_node("myappearance:wardrobe",{
	description = "Wardrobe - Change clothes",
	drawtype = "normal",
	inventory_image = "appearance_wardrobe_inv.png",
	wield_image = "appearance_wardrobe_inv.png",
	paramtype = "light",
	paramtype2 = "facedir",
	tiles = {"appearance_wardrobe_top.png",
			"appearance_wardrobe_top.png",
			"appearance_wardrobe_top.png",
			"appearance_wardrobe_top.png",
			"appearance_wardrobe_top.png",
			"appearance_wardrobe_front.png",
			},
	groups = {cracky = 2},
	on_place = function(itemstack, placer, pointed_thing)
		local pos = pointed_thing.above
		local node = minetest.get_node(pos)
		local unode = minetest.get_node({x = pos.x, y = pos.y + 1, z = pos.z})
		local facedir = minetest.dir_to_facedir(placer:get_look_dir())
		if minetest.get_node(pointed_thing.under).name == "myappearance:wardrobe" then
				minetest.show_formspec(placer:get_player_name(), "myappearance_wardrobe", myappearance_form_wardrobe)
				minetest.register_on_player_receive_fields(function(player, formname, fields)
					local name = placer:get_player_name()
					if formname == "myappearance_wardrobe" then
						change_myappearance (name,fields)
					end
				end)
		elseif minetest.get_node(pointed_thing.under).name == "myappearance:mirror" then
				minetest.show_formspec(placer:get_player_name(), "myappearance_mirror", myappearance_form_mirror)
				minetest.register_on_player_receive_fields(function(player, formname, fields)
					local name = placer:get_player_name()
					if formname == "myappearance_mirror" then
						change_myappearance (name,fields)
					end
				end)
		elseif minetest.get_node(pointed_thing.under).name ~= "myappearance:wardrobe"
		or minetest.get_node(pointed_thing.under).name ~= "myappearance:mirror" then
			if unode.name == "air" then
				minetest.set_node(pos, {name = "myappearance:wardrobe", param2 = facedir})
				minetest.set_node({x = pos.x, y = pos.y + 1, z = pos.z}, {name = "myappearance:mirror", param2 = facedir})
			else
				minetest.chat_send_player(placer:get_player_name(), "Not enough room there!")
				return
			end
		end
	end,
	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		local unode = minetest.get_node({x = pos.x, y = pos.y + 1, z = pos.z})
		if unode.name == "myappearance:mirror" then
			minetest.set_node({x = pos.x, y = pos.y + 1, z = pos.z}, {name = "air"})
		end
	end,
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		minetest.show_formspec(player:get_player_name(), "myappearance_wardrobe", myappearance_form_wardrobe)
        minetest.register_on_player_receive_fields(function(player, formname, fields)
            local name = player:get_player_name()
            if formname == "myappearance_wardrobe" then
                change_myappearance (name,fields)
            end
        end)
	end,
})

minetest.register_node("myappearance:mirror",{
	description = "Mirror - Change appearance",
	drawtype = "nodebox",
	tiles = {"appearance_wardrobe_top.png",
			"appearance_wardrobe_top.png",
			"appearance_wardrobe_top.png",
			"appearance_wardrobe_top.png",
			"appearance_wardrobe_top.png",
			"appearance_wardrobe_mirror.png",
			
			},
	paramtype = "light",
	paramtype2 = "facedir",
	drops = "myappearance:wardrobe",
	groups = {cracky = 2, not_in_creative_inventory = 1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.4375, 0.5, 0.5, 0.5},
		}
	},
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		minetest.show_formspec(player:get_player_name(), "myappearance_mirror", myappearance_form_mirror)
        minetest.register_on_player_receive_fields(function(player, formname, fields)
            local name = player:get_player_name()
            if formname == "myappearance_mirror" then
                change_myappearance (name,fields)
            end
        end)
	end,
	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		local unode = minetest.get_node({x = pos.x, y = pos.y - 1, z = pos.z})
		if unode.name == "myappearance:wardrobe" then
			minetest.set_node({x = pos.x, y = pos.y - 1, z = pos.z}, {name = "air"})
		end
	end,
})

minetest.register_craft({
	output = "myappearance:wardrobe",
	recipe = {
		{"group:stick", "default:glass", "group:stick"},
		{"group:wood", "group:stick", "group:wood"},
		{"group:wood", "group:wood", "group:wood"}
	}
})
