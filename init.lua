myappearance = {}
local myappearance_world_path = nil
local myappearance_mod_path = core.get_modpath("myappearance")

function read_myappearance()
    myappearance_world_path = myappearance_world_path or core.get_worldpath()
    if not myappearance_world_path then
        return nil
    end
    local DATAPATH = myappearance_world_path .. "/myappearance.dat"
    local f = io.open(DATAPATH, "r")
    if not f then
        return nil
    end
    local raw_data = f:read("*a")
    f:close()
    local data = core.deserialize(raw_data)
    return data
end

function save_myappearance()
    myappearance_world_path = myappearance_world_path or core.get_worldpath()
    if not myappearance_world_path then
        return
    end
    local DATAPATH = myappearance_world_path .. "/myappearance.dat"
    local serialized_data = core.serialize(myappearance)
    local file = io.open(DATAPATH, "w")
    if file then
        file:write(serialized_data)
        file:close()
    end
end

local APMALE    = "appearance_male_"
local APFEMALE = "appearance_female_"

local mskin      = APMALE .. "skin.png"
local mpants     = APMALE .. "pants.png"
local mshirt     = APMALE .. "shirt.png"
local mshoes     = APMALE .. "shoes.png"
local mface      = APMALE .. "face.png"
local meyes      = APMALE .. "eyes.png"
local mbelt      = APMALE .. "belt.png"
local moverlay   = APMALE .. "overlay.png"
local mhair      = APMALE .. "hair.png"

local fskin      = APFEMALE .. "skin.png"
local fpants     = APFEMALE .. "pants.png"
local fshirt     = APFEMALE .. "shirt.png"
local fshoes     = APFEMALE .. "shoes.png"
local fface      = APFEMALE .. "face.png"
local feyes      = APFEMALE .. "eyes.png"
local fbelt      = APFEMALE .. "belt.png"
local foverlay   = APFEMALE .. "overlay.png"
local fhair      = APFEMALE .. "hair.png"

function myappearance_update(name)
    local player = core.get_player_by_name(name)
    if not player or not myappearance[name] then return end

    local ap = myappearance[name]
    
    local skin_texture = ap.skin .. ap.pants .. ap.shirt .. ap.shoes .. 
                         ap.face .. ap.eyes .. ap.belt .. ap.overlay .. ap.hair

    if string.sub(skin_texture, -1) == "^" then
        skin_texture = string.sub(skin_texture, 1, -2)
    end

    if core.global_exists("armor") then
        local armor_mod = _G["armor"]
        if armor_mod.textures[name] then
            armor_mod.textures[name].skin = skin_texture
            armor_mod:update_player_visuals(player)
        end
    else
        player:set_properties({
            visual = "mesh",
            mesh = "myappearance_character.b3d",
            textures = {skin_texture},
            visual_size = {x=1, y=1},
        })
    end
end

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

local function get_color_name_from_field(field_name, prefix)
    if string.sub(field_name, 1, string.len(prefix)) == prefix then
        return string.sub(field_name, string.len(prefix) + 1)
    end
    return nil
end

local function newplayer (player)
    local morf = math.random(1,2)
    local name = player:get_player_name()
    myappearance[name] = {
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
        eyes_col = "green",
        overlay = moverlay.."^",
        hair = mhair,
        hair_col = "brown",
    }
    if morf == 1 then
        myappearance[name] = {
            sex = "female",
            skin = fskin.."^",
            skin_col = "4",
            pants = fpants.."^",
            pants_col = "blue",
            shirt = fshirt.."^",
            shirt_col = "green",
            shoes = fshoes.."^",
            shoes_col = "black",
            belt = fbelt.."^",
            belt_col = "black",
            face = fface.."^",
            eyes = feyes.."^",
            eyes_col = "blue",
            overlay = moverlay.."^",
            hair = fhair,
            hair_col = "brown",
        }
    end

    save_myappearance()

    if default and default.player_register_model then
        default.player_register_model("myappearance_character.b3d", {
            animation_speed = 30,
            textures = {"character.png"},
            animations = {
                stand       = {x=0, y=79},
                lay         = {x=162, y=166},
                walk        = {x=168, y=187},
                mine        = {x=189, y=198},
                walk_mine   = {x=200, y=219},
                sit         = {x=81, y=160},
            }
        })
    end
end

core.register_on_joinplayer (function (player)
    local name = player:get_player_name()
    myappearance_world_path = core.get_worldpath()
    
    local loaded_data = read_myappearance()
    if loaded_data then
        for k, v in pairs(loaded_data) do
            myappearance[k] = v
        end
    end

    if not myappearance[name] then
        newplayer (player)
    end
    
    myappearance_update(name)
end)

core.register_on_leaveplayer(function(player)
    save_myappearance()
end)

core.register_node("myappearance:wardrobe",{
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
        local unode = core.get_node({x = pos.x, y = pos.y + 1, z = pos.z})
        local facedir = core.dir_to_facedir(placer:get_look_dir())
        if core.get_node(pointed_thing.under).name == "myappearance:wardrobe" or core.get_node(pointed_thing.under).name == "myappearance:mirror" then
            return itemstack
        end
        if unode.name == "air" then
            if core.get_node(pos).name == "air" then
                core.set_node(pos, {name = "myappearance:wardrobe", param2 = facedir})
                core.set_node({x = pos.x, y = pos.y + 1, z = pos.z}, {name = "myappearance:mirror", param2 = facedir})
                itemstack:take_item()
                return itemstack
            else
                 core.chat_send_player(placer:get_player_name(), "Cannot place here.")
                 return itemstack
            end
        else
            core.chat_send_player(placer:get_player_name(), "Not enough room there!")
            return itemstack
        end
    end,
    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        local unode_pos = {x = pos.x, y = pos.y + 1, z = pos.z}
        local unode = core.get_node(unode_pos)
        if unode.name == "myappearance:mirror" then
            core.remove_node(unode_pos)
        end
    end,
    on_rightclick = function(pos, node, player, itemstack, pointed_thing)
        local myappearance_form_wardrobe =
            "size[8.5,6;]"..
            "background[0,0;8.5,6.25;appearance_form_background.png]"..
            "label[0.5,0.5;Shirt Color]"..
            "image_button[0.5,1;0.5,0.5;wool_black.png;shirt_black;]"..
            "image_button[1,1;0.5,0.5;wool_blue.png;shirt_blue;]"..
            "image_button[1.5,1;0.5,0.5;wool_brown.png;shirt_brown;]"..
            "image_button[2,1;0.5,0.5;wool_cyan.png;shirt_cyan;]"..
            "image_button[2.5,1;0.5,0.5;wool_dark_green.png;shirt_darkgreen;]"..
            "image_button[3,1;0.5,0.5;wool_dark_grey.png;shirt_darkgrey;]"..
            "image_button[3.5,1;0.5,0.5;wool_green.png;shirt_green;]"..
            "image_button[4,1;0.5,0.5;wool_grey.png;shirt_grey;]"..
            "image_button[4.5,1;0.5,0.5;wool_magenta.png;shirt_magenta;]"..
            "image_button[5,1;0.5,0.5;wool_orange.png;shirt_orange;]"..
            "image_button[5.5,1;0.5,0.5;wool_pink.png;shirt_pink;]"..
            "image_button[6,1;0.5,0.5;wool_red.png;shirt_red;]"..
            "image_button[6.5,1;0.5,0.5;wool_violet.png;shirt_violet;]"..
            "image_button[7,1;0.5,0.5;wool_white.png;shirt_white;]"..
            "image_button[7.5,1;0.5,0.5;wool_yellow.png;shirt_yellow;]"..
            "label[0.5,1.5;Pants Color]"..
            "image_button[0.5,2;0.5,0.5;wool_black.png;pants_black;]"..
            "image_button[1,2;0.5,0.5;wool_blue.png;pants_blue;]"..
            "image_button[1.5,2;0.5,0.5;wool_brown.png;pants_brown;]"..
            "image_button[2,2;0.5,0.5;wool_cyan.png;pants_cyan;]"..
            "image_button[2.5,2;0.5,0.5;wool_dark_green.png;pants_darkgreen;]"..
            "image_button[3,2;0.5,0.5;wool_dark_grey.png;pants_darkgrey;]"..
            "image_button[3.5,2;0.5,0.5;wool_green.png;pants_green;]"..
            "image_button[4,2;0.5,0.5;wool_grey.png;pants_grey;]"..
            "image_button[4.5,2;0.5,0.5;wool_magenta.png;pants_magenta;]"..
            "image_button[5,2;0.5,0.5;wool_orange.png;pants_orange;]"..
            "image_button[5.5,2;0.5,0.5;wool_pink.png;pants_pink;]"..
            "image_button[6,2;0.5,0.5;wool_red.png;pants_red;]"..
            "image_button[6.5,2;0.5,0.5;wool_violet.png;pants_violet;]"..
            "image_button[7,2;0.5,0.5;wool_white.png;pants_white;]"..
            "image_button[7.5,2;0.5,0.5;wool_yellow.png;pants_yellow;]"..
            "label[0.5,2.5;Shoes Color]"..
            "image_button[0.5,3;0.5,0.5;wool_black.png;shoes_black;]"..
            "image_button[1,3;0.5,0.5;wool_blue.png;shoes_blue;]"..
            "image_button[1.5,3;0.5,0.5;wool_brown.png;shoes_brown;]"..
            "image_button[2,3;0.5,0.5;wool_cyan.png;shoes_cyan;]"..
            "image_button[2.5,3;0.5,0.5;wool_dark_green.png;shoes_darkgreen;]"..
            "image_button[3,3;0.5,0.5;wool_dark_grey.png;shoes_darkgrey;]"..
            "image_button[3.5,3;0.5,0.5;wool_green.png;shoes_green;]"..
            "image_button[4,3;0.5,0.5;wool_grey.png;shoes_grey;]"..
            "image_button[4.5,3;0.5,0.5;wool_magenta.png;shoes_magenta;]"..
            "image_button[5,3;0.5,0.5;wool_orange.png;shoes_orange;]"..
            "image_button[5.5,3;0.5,0.5;wool_pink.png;shoes_pink;]"..
            "image_button[6,3;0.5,0.5;wool_red.png;shoes_red;]"..
            "image_button[6.5,3;0.5,0.5;wool_violet.png;shoes_violet;]"..
            "image_button[7,3;0.5,0.5;wool_white.png;shoes_white;]"..
            "image_button[7.5,3;0.5,0.5;wool_yellow.png;shoes_yellow;]"..
            "label[0.5,3.5;Belt Color]"..
            "image_button[0.5,4;0.5,0.5;wool_black.png;belt_black;]"..
            "image_button[1,4;0.5,0.5;wool_blue.png;belt_blue;]"..
            "image_button[1.5,4;0.5,0.5;wool_brown.png;belt_brown;]"..
            "image_button[2,4;0.5,0.5;wool_cyan.png;belt_cyan;]"..
            "image_button[2.5,4;0.5,0.5;wool_dark_green.png;belt_darkgreen;]"..
            "image_button[3,4;0.5,0.5;wool_dark_grey.png;belt_darkgrey;]"..
            "image_button[3.5,4;0.5,0.5;wool_green.png;belt_green;]"..
            "image_button[4,4;0.5,0.5;wool_grey.png;belt_grey;]"..
            "image_button[4.5,4;0.5,0.5;wool_magenta.png;belt_magenta;]"..
            "image_button[5,4;0.5,0.5;wool_orange.png;belt_orange;]"..
            "image_button[5.5,4;0.5,0.5;wool_pink.png;belt_pink;]"..
            "image_button[6,4;0.5,0.5;wool_red.png;belt_red;]"..
            "image_button[6.5,4;0.5,0.5;wool_violet.png;belt_violet;]"..
            "image_button[7,4;0.5,0.5;wool_white.png;belt_white;]"..
            "image_button[7.5,4;0.5,0.5;wool_yellow.png;belt_yellow;]"..
            "button_exit[6.5,5;1.5,1;exit;Exit]"
        core.show_formspec(player:get_player_name(), "myappearance_wardrobe", myappearance_form_wardrobe)
        return itemstack
    end,
})

core.register_node("myappearance:mirror",{
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
        local myappearance_form_mirror =
            "size[8.5,6;]"..
            "background[0,0;8.5,6.25;appearance_form_background.png]"..
            "label[0.5,0.5;Male or Female]"..
            "image_button[2.5,0.5;1,1;appearance_male.png;sex_male;]"..
            "label[3,1;Male]"..
            "image_button[4,0.5;1,1;appearance_female.png;sex_female;]"..
            "label[4.5,1;Female]"..
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
            "label[0.5,2.5;Eye Color]"..
            "image_button[0.5,3;0.5,0.5;wool_black.png;eyes_black;]"..
            "image_button[1,3;0.5,0.5;wool_blue.png;eyes_blue;]"..
            "image_button[1.5,3;0.5,0.5;wool_brown.png;eyes_brown;]"..
            "image_button[2,3;0.5,0.5;wool_cyan.png;eyes_cyan;]"..
            "image_button[2.5,3;0.5,0.5;wool_dark_green.png;eyes_darkgreen;]"..
            "image_button[3,3;0.5,0.5;wool_dark_grey.png;eyes_darkgrey;]"..
            "image_button[3.5,3;0.5,0.5;wool_green.png;eyes_green;]"..
            "image_button[4,3;0.5,0.5;wool_grey.png;eyes_grey;]"..
            "image_button[4.5,3;0.5,0.5;wool_magenta.png;eyes_magenta;]"..
            "image_button[5,3;0.5,0.5;wool_orange.png;eyes_orange;]"..
            "image_button[5.5,3;0.5,0.5;wool_pink.png;eyes_pink;]"..
            "image_button[6,3;0.5,0.5;wool_red.png;eyes_red;]"..
            "image_button[6.5,3;0.5,0.5;wool_violet.png;eyes_violet;]"..
            "image_button[7,3;0.5,0.5;wool_white.png;eyes_white;]"..
            "image_button[7.5,3;0.5,0.5;wool_yellow.png;eyes_yellow;]"..
            "label[0.5,3.5;Hair Color]"..
            "image_button[0.5,4;0.5,0.5;wool_black.png;hair_black;]"..
            "image_button[1,4;0.5,0.5;wool_blue.png;hair_blue;]"..
            "image_button[1.5,4;0.5,0.5;wool_brown.png;hair_brown;]"..
            "image_button[2,4;0.5,0.5;wool_cyan.png;hair_cyan;]"..
            "image_button[2.5,4;0.5,0.5;wool_dark_green.png;hair_darkgreen;]"..
            "image_button[3,4;0.5,0.5;wool_dark_grey.png;hair_darkgrey;]"..
            "image_button[3.5,4;0.5,0.5;wool_green.png;hair_green;]"..
            "image_button[4,4;0.5,0.5;wool_grey.png;hair_grey;]"..
            "image_button[4.5,4;0.5,0.5;wool_magenta.png;hair_magenta;]"..
            "image_button[5,4;0.5,0.5;wool_orange.png;hair_orange;]"..
            "image_button[5.5,4;0.5,0.5;wool_pink.png;hair_pink;]"..
            "image_button[6,4;0.5,0.5;wool_red.png;hair_red;]"..
            "image_button[6.5,4;0.5,0.5;wool_violet.png;hair_violet;]"..
            "image_button[7,4;0.5,0.5;wool_white.png;eyes_white;]"..
            "image_button[7.5,4;0.5,0.5;wool_yellow.png;hair_yellow;]"..
            "button_exit[6.5,5;1.5,1;exit;Exit]"
        core.show_formspec(player:get_player_name(), "myappearance_mirror", myappearance_form_mirror)
        return itemstack
    end,
    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        local unode_pos = {x = pos.x, y = pos.y - 1, z = pos.z}
        local unode = core.get_node(unode_pos)
        if unode.name == "myappearance:wardrobe" then
            core.remove_node(unode_pos)
        end
    end,
})

core.register_craft({
    output = "myappearance:wardrobe",
    recipe = {
        {"group:stick", "default:glass", "group:stick"},
        {"group:wood", "group:stick", "group:wood"},
        {"group:wood", "group:wood", "group:wood"}
    }
})

core.register_on_player_receive_fields(function(player, formname, fields)
    local name = player:get_player_name()
    if not myappearance[name] then
        return
    end
    for field_name, value in pairs(fields) do
        if field_name ~= "quit" and field_name ~= "exit" and value == "" then
            if field_name == "sex_male" then
                myappearance[name].sex = "male"
                myappearance[name].skin = mskin .. "^"
                myappearance[name].pants = mpants .. "^"
                myappearance[name].shirt = mshirt .. "^"
                myappearance[name].shoes = mshoes .. "^"
                myappearance[name].face = mface .. "^"
                local eyes_col = myappearance[name].eyes_col or "blue"
                myappearance[name].eyes = "(" .. meyes .. "^[colorize:" .. eyes_col .. ":220)^"
                local belt_col = myappearance[name].belt_col or "black"
                myappearance[name].belt = "(" .. mbelt .. "^[colorize:" .. belt_col .. ":220)^"
                local hair_col = myappearance[name].hair_col or "brown"
                myappearance[name].hair = "(" .. mhair .. "^[colorize:" .. hair_col .. ":220)"
                myappearance[name].overlay = moverlay .. "^"
            elseif field_name == "sex_female" then
                myappearance[name].sex = "female"
                myappearance[name].skin = fskin .. "^"
                myappearance[name].pants = fpants .. "^"
                myappearance[name].shirt = fshirt .. "^"
                myappearance[name].shoes = fshoes .. "^"
                myappearance[name].face = fface .. "^"
                local eyes_col = myappearance[name].eyes_col or "blue"
                myappearance[name].eyes = "(" .. feyes .. "^[colorize:" .. eyes_col .. ":220)^"
                local belt_col = myappearance[name].belt_col or "black"
                myappearance[name].belt = "(" .. fbelt .. "^[colorize:" .. belt_col .. ":220)^"
                local hair_col = myappearance[name].hair_col or "brown"
                myappearance[name].hair = "(" .. fhair .. "^[colorize:" .. hair_col .. ":220)"
                myappearance[name].overlay = foverlay .. "^"
            elseif string.sub(field_name, 1, 5) == "skin_" then
                local skin_num_str = string.sub(field_name, 6)
                local skin_num = tonumber(skin_num_str)
                if skin_num then
                    myappearance[name].skin_col = skin_num_str
                    local intensity = tostring(skin_num * 20)
                    if myappearance[name].sex == "male" then
                        myappearance[name].skin = "(" .. mskin .. "^[colorize:#4b2700:" .. intensity .. ")^"
                    else
                        myappearance[name].skin = "(" .. fskin .. "^[colorize:#4b2700:" .. intensity .. ")^"
                    end
                elseif field_name == "skin_01" or field_name == "skin_02" or field_name == "skin_03" or field_name == "skin_04" or field_name == "skin_05" or
                       field_name == "skin_06" or field_name == "skin_07" or field_name == "skin_08" or field_name == "skin_09" or field_name == "skin_10" then
                    local skin_num_str_fallback = string.sub(field_name, 6)
                     local intensity = tostring(tonumber(skin_num_str_fallback) * 20) or "80"
                     myappearance[name].skin_col = skin_num_str_fallback
                     if myappearance[name].sex == "male" then
                         myappearance[name].skin = "(" .. mskin .. "^[colorize:#4b2700:" .. intensity .. ")^"
                     else
                         myappearance[name].skin = "(" .. fskin .. "^[colorize:#4b2700:" .. intensity .. ")^"
                     end
                end
            elseif string.sub(field_name, 1, 5) == "eyes_" then
                local col = get_color_name_from_field(field_name, "eyes_")
                if col then
                    myappearance[name].eyes_col = col
                    if myappearance[name].sex == "male" then
                        myappearance[name].eyes = "(" .. meyes .. "^[colorize:" .. col .. ":220)^"
                    else
                        myappearance[name].eyes = "(" .. feyes .. "^[colorize:" .. col .. ":220)^"
                    end
                end
            elseif string.sub(field_name, 1, 5) == "hair_" then
                local col = get_color_name_from_field(field_name, "hair_")
                 if col then
                    myappearance[name].hair_col = col
                    if myappearance[name].sex == "male" then
                        myappearance[name].hair = "(" .. mhair .. "^[colorize:" .. col .. ":220)"
                    else
                        myappearance[name].hair = "(" .. fhair .. "^[colorize:" .. col .. ":220)"
                    end
                end
            elseif string.sub(field_name, 1, 6) == "shirt_" then
                local col = get_color_name_from_field(field_name, "shirt_")
                 if col then
                    myappearance[name].shirt_col = col
                    if myappearance[name].sex == "male" then
                        myappearance[name].shirt = "(" .. mshirt .. "^[colorize:" .. col .. ":200)^"
                    else
                        myappearance[name].shirt = "(" .. fshirt .. "^[colorize:" .. col .. ":200)^"
                    end
                end
            elseif string.sub(field_name, 1, 6) == "pants_" then
                local col = get_color_name_from_field(field_name, "pants_")
                 if col then
                    myappearance[name].pants_col = col
                    if myappearance[name].sex == "male" then
                        myappearance[name].pants = "(" .. mpants .. "^[colorize:" .. col .. ":200)^"
                    else
                        myappearance[name].pants = "(" .. fpants .. "^[colorize:" .. col .. ":200)^"
                    end
                end
            elseif string.sub(field_name, 1, 6) == "shoes_" then
                local col = get_color_name_from_field(field_name, "shoes_")
                 if col then
                    myappearance[name].shoes_col = col
                    if myappearance[name].sex == "male" then
                        myappearance[name].shoes = "(" .. mshoes .. "^[colorize:" .. col .. ":150)^"
                    else
                        myappearance[name].shoes = "(" .. fshoes .. "^[colorize:" .. col .. ":240)^"
                    end
                end
            elseif string.sub(field_name, 1, 5) == "belt_" then
                local col = get_color_name_from_field(field_name, "belt_")
                 if col then
                    myappearance[name].belt_col = col
                    if myappearance[name].sex == "male" then
                        myappearance[name].belt = "(" .. mbelt .. "^[colorize:" .. col .. ":220)^"
                    else
                        myappearance[name].belt = "(" .. fbelt .. "^[colorize:" .. col .. ":220)^"
                    end
                end
            end
            myappearance_update(name)
            save_myappearance()
            return
        end
    end
end)

if core.get_modpath("lucky_block") then
    lucky_block:add_blocks({
        {"dro", {"myappearance:wardrobe"}, 1},
    })
end
