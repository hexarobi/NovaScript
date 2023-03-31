--script made by Nova_plays#9126 if you need any help join my discord server https://discord.gg/CNf6Y6Uw--
--credits to all the people that helped me :D--

--auto updater from hexarobi--
local status, auto_updater = pcall(require, "auto-updater")
if not status then
    local auto_update_complete = nil util.toast("Installing auto-updater...", TOAST_ALL)
    async_http.init("raw.githubusercontent.com", "/hexarobi/stand-lua-auto-updater/main/auto-updater.lua",
        function(result, headers, status_code)
            local function parse_auto_update_result(result, headers, status_code)
                local error_prefix = "Error downloading auto-updater: "
                if status_code ~= 200 then util.toast(error_prefix..status_code, TOAST_ALL) return false end
                if not result or result == "" then util.toast(error_prefix.."Found empty file.", TOAST_ALL) return false end
                filesystem.mkdir(filesystem.scripts_dir() .. "lib")
                local file = io.open(filesystem.scripts_dir() .. "lib\\auto-updater.lua", "wb")
                if file == nil then util.toast(error_prefix.."Could not open file for writing.", TOAST_ALL) return false end
                file:write(result) file:close() util.toast("Successfully installed auto-updater lib", TOAST_ALL) return true
            end
            auto_update_complete = parse_auto_update_result(result, headers, status_code)
        end, function() util.toast("Error downloading auto-updater lib. Update failed to download.", TOAST_ALL) end)
    async_http.dispatch() local i = 1 while (auto_update_complete == nil and i < 40) do util.yield(250) i = i + 1 end
    if auto_update_complete == nil then error("Error downloading auto-updater lib. HTTP Request timeout") end
    auto_updater = require("auto-updater")
end
if auto_updater == true then error("Invalid auto-updater lib. Please delete your Stand/Lua Scripts/lib/auto-updater.lua and try again") end

local default_check_interval = 604800
local auto_update_config = {
    source_url="https://raw.githubusercontent.com/NovaPlays134/NovaScript/main/NovaScript.lua",
    script_relpath=SCRIPT_RELPATH,
    switch_to_branch=selected_branch,
    verify_file_begins_with="--",
    check_interval=86400,
    silent_updates=true,
    dependencies={
        {
            name="ent_func",
            source_url="https://raw.githubusercontent.com/NovaPlays134/NovaScript/main/lib/NovaScript/ent_func.lua",
            script_relpath="lib/NovaScript/ent_func.lua",
            check_interval=default_check_interval,
        },

        {
            name="translations",
            source_url="https://raw.githubusercontent.com/NovaPlays134/NovaScript/main/lib/NovaScript/NovaS_translations.lua",
            script_relpath="lib/NovaScript/NovaS_translations.lua",
            check_interval=default_check_interval,
        },

        {
            name="logo",
            source_url="https://raw.githubusercontent.com/NovaPlays134/NovaScript/main/lib/NovaScript/NovaScript_logo.png",
            script_relpath="lib/NovaScript/NovaScript_logo.png",
            check_interval=default_check_interval,
        },

		{
            name="tables",
            source_url="https://raw.githubusercontent.com/NovaPlays134/NovaScript/main/lib/NovaScript/tables.lua",
            script_relpath="lib/NovaScript/tables.lua",
            check_interval=default_check_interval,
        },

        {
            name="quaternionLib",
            source_url="https://raw.githubusercontent.com/NovaPlays134/NovaScript/main/lib/quaternionLib.lua",
            script_relpath="lib/quaternionLib.lua",
            check_interval=default_check_interval,
        },
    }
}
auto_updater.run_auto_update(auto_update_config)

util.keep_running()
util.require_natives(1663599433)
-------------------
--REQUIRING FILES--
-------------------
local ent_func = require "NovaScript.ent_func"
local tables = require "NovaScript.tables"
local trans = require "NovaScript.NovaS_translations"
local string_not_found = "/!\\ STRING NOT FOUND /!\\"

function T(text)
    if text == nil or text == string_not_found then
        return "String Not Found Contact Nova_Plays."
    else
        local current_lang = lang.get_current()
        if current_lang ~= "en" and current_lang ~= "en-us" then
            local lang_translations = trans.translations[current_lang]
            if lang_translations and lang_translations[text] then
                return lang_translations[text]
            else
                return text
            end
        else
            return text
        end
    end
end

function notify(text, bool)
    if bool then
        return
    else
        util.toast(text)
    end
end

--based from how jacks does it--
function control_vehicle(pid, output_toast, callback, opts)
    local vehicle = ent_func.get_player_vehicle_in_control(pid, opts)
    if vehicle ~= 0 then
        callback(vehicle)
        return true
    else
        if output_toast then
            notify(T("Player is not in a vehicle."), notif_off)
        end
        return false
    end
end

--translates the explosion type names table--
for i, name in ipairs(tables.explosion_types_name) do
    tables.explosion_types_name[i] = T(name)
end

----------------
--LOCAL OPTONS--
----------------
local self_main = menu.my_root():list(T("Self"))
local all_players_main = menu.my_root():list(T("All Players"))
local vehicle_main = menu.my_root():list(T("Vehicle"))
local weapons_main = menu.my_root():list(T("Weapons"))
local world_main = menu.my_root():list(T("World"))
local settings_main = menu.my_root():list(T("Settings"))

-----------------
--SETTINGS LIST--
-----------------
--no notifications--
notif_off = false
settings_main:toggle(T("No Notifications"), {}, "", function(on)
    notif_off = on
end)

settings_main:action(T("Check for Update"), {}, T("The script will automatically check for updates at most daily, but you can manually check using this option anytime."), function()
    auto_update_config.check_interval = 0
    if auto_updater.run_auto_update(auto_update_config) then
        notify(T("No updates found"), notif_off)
    end
end)
settings_main:action(T("Clean Reinstall"), {}, T("Force an update to the latest version, regardless of current version."), function()
    auto_update_config.clean_reinstall = true
    auto_updater.run_auto_update(auto_update_config)
end)

--credits--
local credit_list = settings_main:list(T("Credits"))
local translators_credit_list = credit_list:list(T("Translators"))
--german--
translators_credit_list:action("! N0mbyy", {},  T("For translating to german."), function()
end)
--spanish--
translators_credit_list:action("Rodri", {}, T("For translating to spanish."), function()
end)
--french--
translators_credit_list:action("XenonMido", {}, T("For translating to french."), function()
end)
--chinese--
translators_credit_list:action("lu_zi", {}, T("For translating to chinese."), function()
end)
--portuguese--
translators_credit_list:action("Erstarisk", {}, T("For translating to portuguese."), function()
end)
--korean--
translators_credit_list:action("Арена", {}, T("For translating to korean."), function()
end)

--aaron--
credit_list:action("Aaron", {}, T("For helping me in the #programming channel with stuff i didn't understand."), function()
end)
--hexarobi--
credit_list:action("Hexarobi", {}, T("For helping me getting started with making scripts."), function()
end)
--acjoker--
credit_list:action("AcJoker", {}, T("For helping me in the #programming channel with stuff i didn't understand."), function()
end)
--well in that case--
credit_list:action("well in that case", {}, T("For helping me in the #programming channel with stuff i didn't understand."), function()
end)
--jaymontana--
credit_list:action("JayMontana", {}, T("For helping me in the #programming channel with stuff i didn't understand."), function()
end)
--not tonk--
credit_list:action("Not Tonk", {}, T("For helping me in the #programming channel with stuff i didn't understand."), function()
end)
--totaw annihiwation--
credit_list:action("Totaw Annihiwation", {}, T("For helping me in the #programming channel with stuff i didn't understand."), function()
end)
--mr. robot--
credit_list:action("Mr. Robot", {}, T("For helping me in the #programming channel with stuff i didn't understand."), function()
end)
--glidem8--
credit_list:action("GlideM8", {}, T("For helping me in the #programming channel with stuff i didn't understand."), function()
end)
--davus--
credit_list:action("Davus", {}, T("For helping me in the #programming channel with stuff i didn't understand."), function()
end)
--any missed--
credit_list:action(T("And anyone that i missed"), {}, "", function()
end)

settings_main:hyperlink(T("Join The Discord Server"),"https://discord.gg/CNf6Y6Uw")

-------------
--SELF LIST--
-------------
--enter nearest vehicle--
self_main:action(T("Enter Nearest Vehicle"), {}, "", function()
	if not PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
		local player_pos = players.get_position(players.user())
		local veh = ent_func.getClosestVehicle(player_pos)
		local ped = VEHICLE.GET_PED_IN_VEHICLE_SEAT(veh, -1, true)
		if PED.IS_PED_A_PLAYER(ped) then
			notify(T("An player is in the nearest vehicle."), notif_off)
		else
		    entities.delete_by_handle(ped)
			PED.SET_PED_INTO_VEHICLE(players.user_ped(), veh, -1)
		end
	end
end)

--go to nearest player--
self_main:action(T("Go To Nearest Player"), {}, "", function()
	local user_pos = players.get_position(players.user())
	local player = ent_func.getClosestPlayer(user_pos)
    if player ~= nil then
        if not PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
            local player_pos = players.get_position(player)
            ENTITY.SET_ENTITY_COORDS(players.user_ped(), player_pos.x, player_pos.y, player_pos.z, false, false, false, false)
        else
            local player_pos = players.get_position(player)
            local user_vehicle = ent_func.get_vehicle_from_ped(players.user_ped())
            if user_vehicle ~= 0 then
                ENTITY.SET_ENTITY_COORDS(user_vehicle, player_pos.x, player_pos.y, player_pos.z, false, false, false, false)
            end
        end
    end
end)

--hijack random players vehicle--
self_main:action(T("Hijack Random Players Vehicle"), {}, "", function()
    if util.is_session_started() then
        local pids = players.list(false, true, true)
        local pid = pids[math.random(#pids)]
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local loops = 0
        if pid ~= players.user() then
            if not PED.IS_PED_IN_ANY_VEHICLE(ped, true) then
                repeat
                    pid = pids[math.random(#pids)]
                    ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                    loops = loops + 1
                    util.yield(0)
                until(PED.IS_PED_IN_ANY_VEHICLE(ped, true) or loops == 31)
            end
            TASK.CLEAR_PED_TASKS_IMMEDIATELY(ped)
            control_vehicle(pid, true, function(vehicle)
                PED.SET_PED_INTO_VEHICLE(players.user_ped(), vehicle, -1)
            end)
        end
    end
end)

--auras--
local aura_list = self_main:list(T("Aura's"))

--aura radius--
local aura_radius = 10
aura_list:slider(T("Aura Radius"), {}, "", 5, 50, 10, 1, function(count)
    aura_radius = count
end)

--explosion aura--
aura_list:toggle_loop(T("Explosive Aura"), {}, "", function()
    local vehicles = entities.get_all_vehicles_as_pointers()
    local user_vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), true)
    for _, vehicle in pairs(vehicles) do
        local vehicle_handle = entities.pointer_to_handle(vehicle)
        if vehicle_handle ~= user_vehicle then
            local vehicle_pos = ENTITY.GET_ENTITY_COORDS(vehicle_handle)
            if ent_func.get_distance_between(players.user_ped(), vehicle_pos) <= aura_radius then
                if VEHICLE.GET_VEHICLE_ENGINE_HEALTH(vehicle_handle) >= 0 then
                    FIRE.ADD_EXPLOSION(vehicle_pos.x, vehicle_pos.y, vehicle_pos.z, 1, 1, false, true, 0.0, false)
                end
            end
        end
    end
    local peds = entities.get_all_peds_as_pointers()
	for _, ped in pairs(peds) do
        local ped_handle = entities.pointer_to_handle(ped)
        if ped_handle ~= players.user_ped() then
            local ped_pos = ENTITY.GET_ENTITY_COORDS(ped_handle, false)
		    if ent_func.get_distance_between(players.user_ped(), ped_pos) <= aura_radius then
                if not PED.IS_PED_DEAD_OR_DYING(ped_handle, true) then
		    	    FIRE.ADD_EXPLOSION(ped_pos.x, ped_pos.y, ped_pos.z, 1, 1, false, true, 0.0, false)
                end
		    end
        end
	end
end)

--push aura--
--got this calculation from wiriscript--
aura_list:toggle_loop(T("Push Aura"), {}, "", function()
    local vehicles = entities.get_all_vehicles_as_pointers()
    local user_vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), true)
    for _, vehicle in pairs(vehicles) do
        local vehicle_handle = entities.pointer_to_handle(vehicle)
        if vehicle_handle ~= user_vehicle then
            local vehicle_pos = ENTITY.GET_ENTITY_COORDS(vehicle_handle)
            if ent_func.get_distance_between(players.user_ped(), vehicle_pos) <= aura_radius then
                local rel = v3.new(vehicle_pos)
                --subtract your pos from rel--
                rel:sub(players.get_position(players.user()))
                --scales the v3 to have a length of 1--
                rel:normalise()
                ENTITY.APPLY_FORCE_TO_ENTITY(vehicle_handle, 3, rel.x, rel.y, rel.z, 0.0, 0.0, 1.0, 0, false, false, true, false, false)
            end
        end
    end
    local peds = entities.get_all_peds_as_pointers()
	for _, ped in pairs(peds) do
        local ped_handle = entities.pointer_to_handle(ped)
        if ped_handle ~= players.user_ped() then
            local ped_pos = ENTITY.GET_ENTITY_COORDS(ped_handle, false)
		    if ent_func.get_distance_between(players.user_ped(), ped_pos) <= aura_radius then
                local rel = v3.new(ped_pos)
                --subtract your pos from rel--
                rel:sub(players.get_position(players.user()))
                --scales the v3 to have a length of 1--
                rel:normalise()
                PED.SET_PED_TO_RAGDOLL(ped_handle, 2500, 0, 0, false, false, false)
		    	ENTITY.APPLY_FORCE_TO_ENTITY(ped_handle, 3, rel.x, rel.y, rel.z, 0.0, 0.0, 1.0, 0, false, false, true, false, false)
		    end
        end
	end
end)

--pull aura--
--got this calculation from wiriscript--
aura_list:toggle_loop(T("Pull Aura"), {}, "", function()
    local vehicles = entities.get_all_vehicles_as_pointers()
    local user_vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), true)
    for _, vehicle in pairs(vehicles) do
        local vehicle_handle = entities.pointer_to_handle(vehicle)
        if vehicle_handle ~= user_vehicle then
            local vehicle_pos = ENTITY.GET_ENTITY_COORDS(vehicle_handle)
            if ent_func.get_distance_between(players.user_ped(), vehicle_pos) <= aura_radius then
                local rel = v3.new(vehicle_pos)
                --subtract your pos from rel--
                rel:sub(players.get_position(players.user()))
                --scales the v3 to have a length of 1--
                rel:normalise()
                ENTITY.APPLY_FORCE_TO_ENTITY(vehicle_handle, 3, -rel.x, -rel.y, -rel.z, 0.0, 0.0, 1.0, 0, false, false, true, false, false)
            end
        end
    end
    local peds = entities.get_all_peds_as_pointers()
	for _, ped in pairs(peds) do
        local ped_handle = entities.pointer_to_handle(ped)
        if ped_handle ~= players.user_ped() then
            local ped_pos = ENTITY.GET_ENTITY_COORDS(ped_handle, false)
		    if ent_func.get_distance_between(players.user_ped(), ped_pos) <= aura_radius then
                local rel = v3.new(ped_pos)
                --subtract your pos from rel--
                rel:sub(players.get_position(players.user()))
                --scales the v3 to have a length of 1--
                rel:normalise()
                PED.SET_PED_TO_RAGDOLL(ped_handle, 2500, 0, 0, false, false, false)
		    	ENTITY.APPLY_FORCE_TO_ENTITY(ped_handle, 3, -rel.x, -rel.y, -rel.z, 0.0, 0.0, 1.0, 0, false, false, true, false, false)
		    end
        end
	end
end)

--freeze aura--
aura_list:toggle_loop(T("Freeze Aura"), {}, "", function()
    local vehicles = entities.get_all_vehicles_as_pointers()
    local user_vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), true)
    for _, vehicle in pairs(vehicles) do
        local vehicle_handle = entities.pointer_to_handle(vehicle)
        if vehicle_handle ~= user_vehicle then
            local vehicle_pos = ENTITY.GET_ENTITY_COORDS(vehicle_handle)
            if ent_func.get_distance_between(players.user_ped(), vehicle_pos) <= aura_radius then
                ENTITY.FREEZE_ENTITY_POSITION(vehicle_handle, true)
            else
                ENTITY.FREEZE_ENTITY_POSITION(vehicle_handle, false)
            end
        end
    end
    local peds = entities.get_all_peds_as_pointers()
	for _, ped in pairs(peds) do
        local ped_handle = entities.pointer_to_handle(ped)
        if ped_handle ~= players.user_ped() then
            local ped_pos = ENTITY.GET_ENTITY_COORDS(ped_handle, false)
		    if ent_func.get_distance_between(players.user_ped(), ped_pos) <= aura_radius then
                if not PED.IS_PED_IN_ANY_VEHICLE(ped_handle, false) then
                    TASK.CLEAR_PED_TASKS_IMMEDIATELY(ped_handle)
                end
                ENTITY.FREEZE_ENTITY_POSITION(ped_handle, true)
            else
                ENTITY.FREEZE_ENTITY_POSITION(ped_handle, false)
            end
        end
	end
end)

--boost aura--
aura_list:toggle_loop(T("Boost Aura"), {}, "", function()
    local vehicles = entities.get_all_vehicles_as_pointers()
    local user_vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), true)
    for _, vehicle in pairs(vehicles) do
        local vehicle_handle = entities.pointer_to_handle(vehicle)
        if vehicle_handle ~= user_vehicle then
            local vehicle_pos = ENTITY.GET_ENTITY_COORDS(vehicle_handle)
            if ent_func.get_distance_between(players.user_ped(), vehicle_pos) <= aura_radius then
                local rel = v3.new(vehicle_pos)
                --subtract your pos from rel--
                rel:sub(players.get_position(players.user()))
                --turn rel into a rot--
                local rot = rel:toRot()
                ENTITY.SET_ENTITY_ROTATION(vehicle_handle, rot.x, rot.y, rot.z, 2, false)
                VEHICLE.SET_VEHICLE_FORWARD_SPEED(vehicle_handle, 100)
            end
        end
    end
    local peds = entities.get_all_peds_as_pointers()
	for _, ped in pairs(peds) do
        local ped_handle = entities.pointer_to_handle(ped)
        if ped_handle ~= players.user_ped() then
            local ped_pos = ENTITY.GET_ENTITY_COORDS(ped_handle, false)
		    if ent_func.get_distance_between(players.user_ped(), ped_pos) <= aura_radius then
                local rel = v3.new(ped_pos)
                --subtract your pos from rel--
                rel:sub(players.get_position(players.user()))
                --multiply rel with 100--
                rel:mul(100)
                PED.SET_PED_TO_RAGDOLL(ped_handle, 2500, 0, 0, false, false, false)
		    	ENTITY.APPLY_FORCE_TO_ENTITY(ped_handle, 3, rel.x, rel.y, rel.z, 0, 0, 1.0, 0, false, false, true, false, false)
            end
        end
	end
end)

--forward roll--
local i = 360
self_main:toggle_loop(T("Forward Roll"), {}, "", function()
    ent_func.has_anim_dict_loaded("misschinese2_crystalmaze")
    TASK.TASK_PLAY_ANIM(players.user_ped(), "misschinese2_crystalmaze", "2int_loop_a_taotranslator", 8.0, 8.0, -1, 0, 0.0, 0, 0, 0)
    local cam_rot = CAM.GET_GAMEPLAY_CAM_ROT(0)
    local user_rot = ENTITY.GET_ENTITY_ROTATION(players.user_ped(), 0)
    local fwd_vect = ENTITY.GET_ENTITY_FORWARD_VECTOR(players.user_ped())
    local speed = ENTITY.GET_ENTITY_SPEED(players.user_ped()) * 2.236936
    PED.SET_PED_CAN_RAGDOLL(players.user_ped(), false)
    ENTITY.SET_ENTITY_ROTATION(players.user_ped(), i, user_rot.y, cam_rot.z, 2, true)
    if speed <= 70 then
        ENTITY.APPLY_FORCE_TO_ENTITY(players.user_ped(), 3, fwd_vect.x, fwd_vect.y, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, true, false, false)
    end
    if i <= 0 then i = 360 else i = i - 6 end
end, function()
    util.yield(100)
    PED.SET_PED_CAN_RAGDOLL(players.user_ped(), true)
    TASK.STOP_ANIM_TASK(players.user_ped(), "misschinese2_crystalmaze", "2int_loop_a_taotranslator", 1)
end)

--breakdance--
local rotation = 0
local loop_count = 0
local dict, name
self_main:toggle_loop(T("Break Dance"), {}, "", function()
    if loop_count <= 200 then
        dict = "missfbi5ig_20b"
        name = "hands_up_scientist"
    elseif loop_count <= 400 then
        dict = "nm@hands"
        name = "hands_up"
    elseif loop_count <= 600 then
        dict = "missheist_agency2ahands_up"
        name = "handsup_anxious"
    elseif loop_count <= 800 then
        dict = "missheist_agency2ahands_up"
        name = "handsup_loop"
    end

    ENTITY.SET_ENTITY_ROTATION(players.user_ped(), 180, 0, rotation, 1, true)
    ent_func.has_anim_dict_loaded(dict)
    TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 0, -1, 0, 0.0, 0, 0, 0)
 
    rotation = rotation + 5
    if loop_count < 1000 then
        loop_count = loop_count + 1
    else
        loop_count = 0
    end
end, function()
    TASK.CLEAR_PED_TASKS_IMMEDIATELY(players.user_ped())
end)

--delete police--
self_main:toggle_loop(T("Delete Police"), {}, "", function()
    local my_pos = players.get_position(players.user())
    MISC.CLEAR_AREA_OF_COPS(my_pos.x, my_pos.y, my_pos.z, 40000, 0)
    util.yield(500)
end)

--error screens--
local error_list = self_main:list(T("Error Screen"))
local custom_error = ""
error_list:text_input(T("Custom Error"), {"custom_error_text"}, "", function(input)
    custom_error = input
end)

local error_types = {"Banned", "Altered Version", "Error With Session", "Suspended", "Could Not Download Files", "Custom"}
local error_number = 1
error_list:list_select(T("Error Type"), {}, "",  error_types, 1, function(index)
    error_number = index
end)

--got help from this website "https://vespura.com/fivem/scaleform/#POPUP_WARNING" helps alot if anyone needs it--
error_list:toggle(T("Error Screen"), {}, "", function(on)
    local errors = {
        "You have been banned from Grand Theft Auto Online permanently.",
        "You're attempting to access GTA Online servers with an altered version of the game.",
        "There has been an error with this session.",
        "You have been suspended from Grand Theft Auto Online Online until ".. os.date("%m/%d/%Y", os.time() + 2700000) ..". \nIn addition, your Grand Theft Auto Online characters(s) will be reset.",
        "Could not download files from the Rockstar Games Service required to play GTA Online",
        custom_error
    }

    local error_screen = GRAPHICS.REQUEST_SCALEFORM_MOVIE("POPUP_WARNING")
    while on do
        GRAPHICS.BEGIN_SCALEFORM_MOVIE_METHOD(error_screen, "SHOW_POPUP_WARNING")
        GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_FLOAT(1)
        GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_TEXTURE_NAME_STRING("alert")
        GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_LITERAL_STRING(errors[error_number])
        GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_LITERAL_STRING("Return to Grand Theft Auto V.")
        GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_BOOL(true)
        GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_INT(0)
        GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_TEXTURE_NAME_STRING("NovaScript")
        GRAPHICS.END_SCALEFORM_MOVIE_METHOD(error_screen)
        GRAPHICS.DRAW_SCALEFORM_MOVIE_FULLSCREEN(error_screen, 255, 255, 255, 255, 0)
        util.yield(0)
    end

    if not on then
        local delete = memory.alloc_int()
		memory.write_int(delete, error_screen)
        GRAPHICS.SET_SCALEFORM_MOVIE_AS_NO_LONGER_NEEDED(delete)
    end
end)

--------------------
--ALL PLAYERS LIST--
--------------------
--explode all--
local explode_all_players_list = all_players_main:list(T("Explosions"))

--explosion type--
local explosion_type = 0
explode_all_players_list:list_action(T("Explosion Type"), {}, T("All explosion types in the game."), tables.explosion_types_name, function(index)
  explosion_type = tables.explosion_types[index]
end)

--explode all-
explode_all_players_list:action(T("Explode all"), {}, "", function()
  for i, pid in pairs(players.list(false, true, true)) do
    local pos = players.get_position(pid)
    pos.z = pos.z - 1.0
    FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, explosion_type, 1, true, false, 0.0, false)
  end
end)

--explode all no damage--
explode_all_players_list:action(T("Explode All No Damage"), {}, "", function()
  for i, pid in pairs(players.list(false, true, true)) do
    local pos = players.get_position(pid)
    pos.z = pos.z - 1.0
    FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, explosion_type, 1, true, false, 0.0, true)
  end
end)

--explode loop delay--
local expl_speed = 200
explode_all_players_list:slider(T("Explode Loop Delay"), {}, "", 20, 2000, 200, 10, function(count)
	expl_speed = count
end)

--explode all loop--
explode_all_players_list:toggle_loop(T("Explode All Loop"), {}, "", function()
  for i, pid in pairs(players.list(false, true, true)) do
    local pos = players.get_position(pid)
    pos.z = pos.z - 1.0
    FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, explosion_type, 1, true, false, 0.0, false)
  end
  util.yield(expl_speed)
end)

--explode all loop no damage--
explode_all_players_list:toggle_loop(T("Explode All No Damage Loop"), {}, "", function()
  for i, pid in pairs(players.list(false, true, true)) do
    local pos = players.get_position(pid)
    pos.z = pos.z - 1.0
    FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, explosion_type, 1, true, false, 0.0, true)
  end
  util.yield(expl_speed)
end)

----------------
--VEHICLE LIST--
----------------
--horn options--
local horn_opt_list = vehicle_main:list(T("Horn Options"))

--horn explosion type--
local explosion_type = 0
horn_opt_list:list_action(T("Explosion Type"), {}, T("All explosion types in the game."), tables.explosion_types_name, function(index)
  explosion_type = tables.explosion_types[index]
end)

--horn explosion--
horn_explosions_opt = horn_opt_list:toggle_loop(T("Horn Explosion"), {}, "", function()
	if PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
	    local vehicle = entities.get_user_vehicle_as_handle(players.user())
	    if AUDIO.IS_HORN_ACTIVE(vehicle) then
            local rand_num = math.random(20, 80)
            local veh_coords_offset = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, 0.0, rand_num, 1)
            FIRE.ADD_EXPLOSION(veh_coords_offset.x, veh_coords_offset.y, veh_coords_offset.z, explosion_type, 1.0, true, false, 0.4, false)
            util.yield(100)
        end
    else
		notify(T("Your not in any vehicle."), notif_off)
        menu.set_value(horn_explosions_opt, false)
    end
end)

--horn boost speed--
local horn_boost_speed = 100
horn_opt_list:slider(T("Boost speed"), {}, "", 10, 400, 100, 10, function(count)
	horn_boost_speed = count
end)

--horn boost--
horn_boost_opt = horn_opt_list:toggle_loop(T("Horn Boost"), {}, "", function()
	if PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
	    local vehicle = entities.get_user_vehicle_as_handle(players.user())
        if AUDIO.IS_HORN_ACTIVE(vehicle) then
	        local speed = horn_boost_speed
	    	VEHICLE.SET_VEHICLE_FORWARD_SPEED(vehicle, speed)
	    	local velocity = ENTITY.GET_ENTITY_VELOCITY(vehicle)
            ENTITY.SET_ENTITY_VELOCITY(vehicle, velocity.x, velocity.y, velocity.z)
        end
    else
        notify(T("Your not in any vehicle."), notif_off)
        menu.set_value(horn_boost_opt, false)
    end
end)

--auto repair--
auto_repair_opt = vehicle_main:toggle_loop(T("Auto Repair"), {}, T("Will repair your vehicle when its health is halfway to distroyed."), function()
    if PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
        local vehicle = entities.get_user_vehicle_as_handle(players.user())
        local vehicle_health = ENTITY.GET_ENTITY_HEALTH(vehicle)
        if vehicle_health <= 500 then
            VEHICLE.SET_VEHICLE_FIXED(vehicle)
        end
    else
        notify(T("Your not in any vehicle."), notif_off)
        menu.set_value(auto_repair_opt, false)
    end
end)

--spawn ramp vehicle--
vehicle_main:action(T("Spawn Big Ramp Vehicle"), {}, "", function()
    local pos = players.get_position(players.user())
    local hash = util.joaat("dune4")
    ent_func.request_model(hash)
    local vehicle = VEHICLE.CREATE_VEHICLE(hash, pos.x ,pos.y ,pos.z, 0, true, false, true)
    PED.SET_PED_INTO_VEHICLE(players.user_ped(), vehicle, -1)
    for i = 1, 2 do
        local vehicle_model = ENTITY.GET_ENTITY_MODEL(vehicle)
        local left_vehicle = VEHICLE.CREATE_VEHICLE(vehicle_model, pos.x ,pos.y ,pos.z, ENTITY.GET_ENTITY_HEADING(vehicle), true, false, true)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(left_vehicle, vehicle, 0, -2*i, 0.0, 0.0, 0.0, 0.0, 0.0, true, false, false, false, 0, true)
        local right_vehicle = VEHICLE.CREATE_VEHICLE(vehicle_model, pos.x ,pos.y ,pos.z, ENTITY.GET_ENTITY_HEADING(vehicle), true, false, true)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(right_vehicle, vehicle, 0, 2*i, 0.0, 0.0, 0.0, 0.0, 0.0, true, false, false, false, 0, true)
        ENTITY.SET_ENTITY_COLLISION(left_vehicle, true, true)
        ENTITY.SET_ENTITY_COLLISION(right_vehicle, true, true)
    end
end)

--drift--
vehicle_drift = vehicle_main:toggle_loop(T("Drift"), {},  T("While holding down shift, you drift."), function()
    user_vehicle = ent_func.get_vehicle_from_ped(players.user_ped())
    if user_vehicle ~= 0 then
        if PAD.IS_DISABLED_CONTROL_PRESSED(0, 61) then
            VEHICLE.SET_VEHICLE_REDUCE_GRIP(user_vehicle, true)
        else
            VEHICLE.SET_VEHICLE_REDUCE_GRIP(user_vehicle, false)
        end
    else
        notify(T("Your not in any vehicle."), notif_off)
        menu.set_value(vehicle_drift, false)
    end
end, function()
    VEHICLE.SET_VEHICLE_REDUCE_GRIP(user_vehicle, false)
end)

--vehicle rpm flames list--
local rpm_flames_list = vehicle_main:list(T("Rpm Flames"))

--sets the min value of the rpm--
local rpm_min_value = 150
rpm_flames_list:slider(T("Flames Speed"), {} , "", 100, 1000, 150, 5, function(value)
    rpm_min_value = value
end)

--sets the rpm of the vehicle when the rpm of the vehicle is less then x value--
rpm_flames = rpm_flames_list:toggle_loop(T("Rpm Flames"), {}, "", function()
    local user_vehicle = ent_func.get_vehicle_from_ped(players.user_ped())
    if user_vehicle ~= 0 then
        local user_vehicle_pointer = entities.handle_to_pointer(user_vehicle)
        entities.set_rpm(user_vehicle_pointer, 2.0)
    else
        notify(T("Your not in any vehicle."), notif_off)
        menu.set_value(rpm_flames, false)
    end
    util.yield(rpm_min_value)
end)

--setting the speed the vehicle should move to the cam rotation--
local rotation_speed = 50
vehicle_main:slider(T("Rotation Speed"), {} , "", 50, 1000, 50, 50, function(value)
    rotation_speed = value
end)

--thanks to not thonk for making the quaternionLib and for helping me with this also thanks to AIねこ for helping me--
local quaternionLib = require("quaternionLib")
local vehicle_rotation = nil
--sets the vehicle rotation to the cam rotation with looking like you are manually setting it--
set_vehicle_to_cam_rot = vehicle_main:toggle_loop(T("Set Vehicle To Cam Rotation While Airborne"), {}, "", function()
    if PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
        local vehicle = entities.get_user_vehicle_as_handle(players.user())
        local hight = ENTITY.GET_ENTITY_HEIGHT_ABOVE_GROUND(vehicle)
        if hight >= 2.0 and not ENTITY.IS_ENTITY_IN_WATER(vehicle) then
            local cam_rot = CAM.GET_GAMEPLAY_CAM_ROT(0)
            local desired_rotation = quaternionLib.from_euler(cam_rot.x, cam_rot.y, cam_rot.z)
            if vehicle_rotation == nil then
                vehicle_rotation = desired_rotation
            else
                vehicle_rotation = ent_func.slerp(vehicle_rotation, desired_rotation, rotation_speed/1000)
                ENTITY.SET_ENTITY_QUATERNION(vehicle, vehicle_rotation.x, vehicle_rotation.y, vehicle_rotation.z, vehicle_rotation.w)
            end
        end
    else
        vehicle_rotation = nil
        notify(T("You are not in a vehicle."), notif_off)
        menu.set_value(set_vehicle_to_cam_rot, false)
    end
end)

--indicator lights--
local indicator_lights_list = vehicle_main:list(T("Indicator Lights"))

--all lights--
all_lights_opt = indicator_lights_list:toggle(T("All Lights"), {}, "", function(on)
    if on then
        if PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
            local vehicle = entities.get_user_vehicle_as_handle(players.user())
            VEHICLE.SET_VEHICLE_INDICATOR_LIGHTS(vehicle, 0, true)
            VEHICLE.SET_VEHICLE_INDICATOR_LIGHTS(vehicle, 1, true)
        else
            notify(T("Your not in any vehicle."), notif_off)
            menu.set_value(all_lights_opt, false)
        end
    end
    if not on then
        if PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
            local vehicle = entities.get_user_vehicle_as_handle(players.user())
            VEHICLE.SET_VEHICLE_INDICATOR_LIGHTS(vehicle, 0, false)
            VEHICLE.SET_VEHICLE_INDICATOR_LIGHTS(vehicle, 1, false)
        end
    end
end)

--right lights--
right_lights_opt = indicator_lights_list:toggle(T("Right Side"), {}, "", function(on)
    if on then
        if PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
            local vehicle = entities.get_user_vehicle_as_handle(players.user())
            VEHICLE.SET_VEHICLE_INDICATOR_LIGHTS(vehicle, 0, true)
        else
            notify(T("Your not in any vehicle."), notif_off)
            menu.set_value(right_lights_opt, false)
        end
    end
    if not on then
        if PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
            local vehicle = entities.get_user_vehicle_as_handle(players.user())
            VEHICLE.SET_VEHICLE_INDICATOR_LIGHTS(vehicle, 0, false)
        end
    end
end)

--left lights--
left_lights_opt = indicator_lights_list:toggle(T("Left Side"), {}, "", function(on)
    if on then
        if PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
            local vehicle = entities.get_user_vehicle_as_handle(players.user())
            VEHICLE.SET_VEHICLE_INDICATOR_LIGHTS(vehicle, 1, true)
        else
            notify(T("Your not in any vehicle."), notif_off)
            menu.set_value(left_lights_opt, false)
        end
    end
    if not on then
        if PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
            local vehicle = entities.get_user_vehicle_as_handle(players.user())
            VEHICLE.SET_VEHICLE_INDICATOR_LIGHTS(vehicle, 1, false)
        end
    end
end)

--door control--
local door_control = vehicle_main:list(T("Door Control"))

--open all doors--
doors_open_opt = door_control:action(T("Open All Vehicle Doors"), {}, "", function()
    if PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
        local vehicle = entities.get_user_vehicle_as_handle(players.user())
        local doors = VEHICLE.GET_NUMBER_OF_VEHICLE_DOORS(vehicle)
        for i= 0, doors do
            VEHICLE.SET_VEHICLE_DOOR_OPEN(vehicle, i, false, true)
        end
    else
        notify(T("Your not in any vehicle."), notif_off)
        menu.set_value(doors_open_opt, false)
    end
end)

--close all doors--
doors_close_opt = door_control:action(T("Close All Vehicle Doors"), {}, "", function()
    if PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
        local vehicle = entities.get_user_vehicle_as_handle(players.user())
        local doors = VEHICLE.GET_NUMBER_OF_VEHICLE_DOORS(vehicle)
        for i= 0, doors do
            VEHICLE.SET_VEHICLE_DOOR_SHUT(vehicle, i, true)
        end
    else
        notify(T("door_control"), notif_off)
        menu.set_value(doors_close_opt, false)
    end
end)

--break all doors--
doors_break_opt = door_control:action(T("Break All Vehicle Doors"), {}, "", function()
    if PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
        local vehicle = entities.get_user_vehicle_as_handle(players.user())
        local doors = VEHICLE.GET_NUMBER_OF_VEHICLE_DOORS(vehicle)
        for i= 0, doors do
            VEHICLE.SET_VEHICLE_DOOR_BROKEN(vehicle, i, false)
        end
    else
        notify(T("Your not in any vehicle."), notif_off)
        menu.set_value(doors_break_opt, false)
    end
end)
---------------
--WEAPON LIST--
---------------
--vehicle gun--
local vehicle_gun_list = weapons_main:list(T("Vehicle Gun"))

--vehicles for vehicle gun--
local vehhash = util.joaat("italigtb2")
local veh_hashes = {util.joaat("italigtb2"), util.joaat("terbyte"), util.joaat("speedo2"), util.joaat("trash2"), util.joaat("vigilante"), util.joaat("lazer"), util.joaat("insurgent2"), util.joaat("cutter"), util.joaat("phantom2")}
local veh_options = {T("Itali GTB Custom"), T("Terrorbyte"), T("Clown Van"), T("Trashmaster"), T("Vigilante"), T("Lazer"), T("Insurgent"), T("Cutter"), T("Phantom Wedge")}
vehicle_gun_list:list_action(T("Vehicle Type"), {}, "", veh_options, function(index)
  vehhash = veh_hashes[index]
end)

--vehicle gun--
vehicle_gun_list:toggle_loop(T("Vehicle Gun"), {}, "", function()
    if PED.IS_PED_SHOOTING(players.user_ped()) and not PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
        local hash = vehhash
        ent_func.request_model(hash)
        local player_pos = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0.0, 5.0, 3.0)
        local vehicle = VEHICLE.CREATE_VEHICLE(hash, player_pos.x, player_pos.y, player_pos.z, 5,true, true, false)
        ENTITY.SET_ENTITY_NO_COLLISION_ENTITY(vehicle, players.user_ped(), true)
        local cam_rot = CAM.GET_GAMEPLAY_CAM_ROT(0)
        ENTITY.SET_ENTITY_ROTATION(vehicle, cam_rot.x, cam_rot.y, cam_rot.z, 0, true)
        VEHICLE.SET_VEHICLE_CUSTOM_PRIMARY_COLOUR(vehicle, math.random(0, 255), math.random(0, 255), math.random(0, 255))
        VEHICLE.SET_VEHICLE_CUSTOM_SECONDARY_COLOUR(vehicle, math.random(0, 255), math.random(0, 255), math.random(0, 255))
        VEHICLE.SET_VEHICLE_GRAVITY(vehicle, true)
        if set_in_vehicle then
            PED.SET_PED_INTO_VEHICLE(players.user_ped(), vehicle, -1)
        end
        VEHICLE.SET_VEHICLE_FORWARD_SPEED(vehicle, 200)
    end
end)

--spawn inside vehicle shot by vehicle gun--
set_in_vehicle = false
vehicle_gun_list:toggle(T("Set In Vehicle"), {}, "", function(on)
    set_in_vehicle = on
end)

--bullet reactions--
local bullet_reactions_list = weapons_main:list(T("Bullet Reactions"))

--bullet reaction boost--
bullet_reactions_list:toggle_loop(T("Boost Vehicle"), {}, "", function()
    if PED.IS_PED_SHOOTING(players.user_ped()) then
        local entity = ent_func.get_entity_player_is_aiming_at(players.user())
        if entity ~= 0 then
            if ENTITY.IS_ENTITY_A_VEHICLE(entity) then
                VEHICLE.SET_VEHICLE_FORWARD_SPEED(entity, 100)
            end
        end
    end
end)

--bullet reaction explode--
bullet_reactions_list:toggle_loop(T("Explode Entity"), {}, "", function()
    if PED.IS_PED_SHOOTING(players.user_ped()) then
        local entity = ent_func.get_entity_player_is_aiming_at(players.user())
        if entity ~= 0 then
            if ENTITY.IS_ENTITY_A_VEHICLE(entity) then
                VEHICLE.EXPLODE_VEHICLE(entity, true, false)
            elseif ENTITY.IS_ENTITY_A_PED(entity) then
                local Position = ENTITY.GET_ENTITY_COORDS(entity, false)
                FIRE.ADD_EXPLOSION(Position.x, Position.y, Position.z, 1, 1.0, true, false, 1.0, false)
            end
        end
    end
end)

--bullet reaction freeze--
bullet_reactions_list:toggle_loop(T("Freeze Entity"), {}, "", function()
    if PED.IS_PED_SHOOTING(players.user_ped()) then
        local entity = ent_func.get_entity_player_is_aiming_at(players.user())
        if entity ~= 0 then
            ENTITY.FREEZE_ENTITY_POSITION(entity, true)
        end
    end
end)

--bullet reaction gravity off--
bullet_reactions_list:toggle_loop(T("Turn Entity Gravity Off"), {}, "", function()
    if PED.IS_PED_SHOOTING(players.user_ped()) then
        local entity = ent_func.get_entity_player_is_aiming_at(players.user())
        if entity ~= 0 then
            if ENTITY.IS_ENTITY_A_VEHICLE(entity) then
                VEHICLE.SET_VEHICLE_GRAVITY(entity, false)
            else
                ENTITY.SET_ENTITY_HAS_GRAVITY(entity, false)
            end
        end
    end
end)

--some options came from "my" Meteor script, the ones that are taken or not my ideas so i will not take any credit from them--
--this is to clarify to acjoker and the rest that is reading this right now--

--size multiplier size, taken--
local size_multiplier = 10
weapons_main:slider(T("Multiplier Amount"), {} , T("10 means default size"), 10, 200, 10, 5, function(value)
	size_multiplier = value
end)

--size multiplier, taken--
weapons_main:toggle_loop(T("Size Multiplier"), {}, "", function()
    local weapon = WEAPON.GET_SELECTED_PED_WEAPON(players.user_ped())
	WEAPON.SET_WEAPON_AOE_MODIFIER(weapon, size_multiplier / 10) --the / 10 is needed bc im doing *10 for every thing in the slider to have more size option--
	util.yield(10)
end, function()
    local weapon = WEAPON.GET_SELECTED_PED_WEAPON(players.user_ped())
	WEAPON.SET_WEAPON_AOE_MODIFIER(weapon, 1.0)
end)

--explosion type for inpact gun--
local explosion_type = 0
weapons_main:list_action(T("Explosion Type"), {}, T("All explosion types in the game."), tables.explosion_types_name, function(index)
  explosion_type = tables.explosion_types[index]
end)

--explosion inpact gun--
weapons_main:toggle_loop(T("Explosion Impact Gun"), {}, "", function()
	local hitCoords = v3.new()
	WEAPON.GET_PED_LAST_WEAPON_IMPACT_COORD(players.user_ped(), hitCoords)
	FIRE.ADD_EXPLOSION(hitCoords.x, hitCoords.y, hitCoords.z, explosion_type, 1, true, false, 0.5, false)
end)

--custom c4 list--
local custom_c4_list = weapons_main:list(T("Custom c4"))

--trows the c4 when you shoot--
custom_c4_list:toggle_loop(T("Custom c4 Gun"), {}, "", function()
	if PED.IS_PED_SHOOTING(players.user_ped()) and not ENTITY.DOES_ENTITY_EXIST(c4) then
		local hash = util.joaat("prop_bomb_01_s")
		ent_func.request_model(hash)
        local player_pos = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0.0, 0.5, 0.5)
		local dir = {}
		local c2 = {}
		c2 = ent_func.get_offset_from_gameplay_camera(50)
		dir.x = (c2.x - player_pos.x) * 50
		dir.y = (c2.y - player_pos.y) * 50
		dir.z = (c2.z - player_pos.z) * 50

		c4 = OBJECT.CREATE_OBJECT_NO_OFFSET(hash, player_pos.x, player_pos.y, player_pos.z, true, false, false)
		ENTITY.SET_ENTITY_NO_COLLISION_ENTITY(c4, players.user_ped(), false)
		ENTITY.APPLY_FORCE_TO_ENTITY(c4, 0, dir.x, dir.y, dir.z, 0.0, 0.0, 0.0, 0, true, false, true, false, true)
		ENTITY.SET_ENTITY_HAS_GRAVITY(c4, true)
	end
end)

--executes the c4 you trew with custom explosion--
local custom_c4_explosions = {T("Orbital Explosion"), T("Nuke Explosion")}
custom_c4_list:textslider(T("Execute c4"), {}, "", custom_c4_explosions, function(index, name)
    if ENTITY.DOES_ENTITY_EXIST(c4) then
        local c4_pos = ENTITY.GET_ENTITY_COORDS(c4, true)
        entities.delete_by_handle(c4)
	    if index == 1 then
            ent_func.use_fx_asset("scr_xm_orbital")
            GRAPHICS.USE_PARTICLE_FX_ASSET("scr_xm_orbital")
            FIRE.ADD_EXPLOSION(c4_pos.x, c4_pos.y, c4_pos.z, 59, 1, true, false, 1.0, false)
            GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD("scr_xm_orbital_blast", c4_pos.x, c4_pos.y, c4_pos.z, 0, 180, 0, 1.0, true, true, true)
        elseif index == 2 then
	    	ent_func.create_nuke_explosion(c4_pos)
        end
        for i = 1, 4 do
            AUDIO.PLAY_SOUND_FROM_ENTITY(-1, "DLC_XM_Explosions_Orbital_Cannon", players.user_ped(), 0, true, false)
        end
    end
end)

--orbital strike gun, taken--
weapons_main:toggle_loop(T("Orbital Strike Gun"), {}, "", function()
	local last_hit_coords = v3.new()
	if WEAPON.GET_PED_LAST_WEAPON_IMPACT_COORD(players.user_ped(), last_hit_coords) then
        ent_func.use_fx_asset("scr_xm_orbital")
        GRAPHICS.USE_PARTICLE_FX_ASSET("scr_xm_orbital")
        FIRE.ADD_EXPLOSION(last_hit_coords.x, last_hit_coords.y, last_hit_coords.z, 59, 1, true, false, 1.0, false)
        GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD("scr_xm_orbital_blast", last_hit_coords.x, last_hit_coords.y, last_hit_coords.z, 0, 180, 0, 1.0, true, true, true)
        for i = 1, 4 do
            AUDIO.PLAY_SOUND_FROM_ENTITY(-1, "DLC_XM_Explosions_Orbital_Cannon", players.user_ped(), 0, true, false)
        end
	end
end)

--nuke gun, taken but edited alot--
weapons_main:toggle_loop(T("Nuke Gun"), {}, "", function()
	if PED.IS_PED_SHOOTING(players.user_ped()) and not PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
		local hash = util.joaat("prop_military_pickup_01")
		ent_func.request_model(hash)
		local player_pos = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0.0, 5.0, 3.0)
		local dir = {}
		local c2 = {}
		c2 = ent_func.get_offset_from_gameplay_camera(1000)
		dir.x = (c2.x - player_pos.x) * 1000
		dir.y = (c2.y - player_pos.y) * 1000
		dir.z = (c2.z - player_pos.z) * 1000

		local nuke = OBJECT.CREATE_OBJECT_NO_OFFSET(hash, player_pos.x, player_pos.y, player_pos.z, true, false, false)
		ENTITY.SET_ENTITY_NO_COLLISION_ENTITY(nuke, players.user_ped(), false)
		ENTITY.APPLY_FORCE_TO_ENTITY(nuke, 0, dir.x, dir.y, dir.z, 0.0, 0.0, 0.0, 0, true, false, true, false, true)
		ENTITY.SET_ENTITY_HAS_GRAVITY(nuke, true)

		while not ENTITY.HAS_ENTITY_COLLIDED_WITH_ANYTHING(nuke) and not ENTITY.IS_ENTITY_IN_WATER(nuke) do
			util.yield(0)
		end
		local nukePos = ENTITY.GET_ENTITY_COORDS(nuke, true)
		entities.delete_by_handle(nuke)
        ent_func.create_nuke_explosion(nukePos)
	end
end)

--[[ i dont have any effects that are cool to use this with if i get any i will add this
--shooting affect--
weapons_main:toggle_loop(T("Shooting Effect"), {}, "", function()
	if PED.IS_PED_SHOOTING(players.user_ped()) then
        local weapon =  WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(players.user_ped(), 0) --i tried using "WEAPON.GET_SELECTED_PED_WEAPON(players.user_ped())" but didnt work bc its not an entity--
        local bone_index = ENTITY.GET_ENTITY_BONE_INDEX_BY_NAME(weapon, "gun_barrels")
        ent_func.use_fx_asset("core")
        GRAPHICS.START_PARTICLE_FX_NON_LOOPED_ON_ENTITY_BONE("blood_mist", weapon, 0.0, 0.0, 0.0, 90, 0.0, 0.0, bone_index, 1, false, false, false)
    end
end)
--]]

--------------
--WORLD LIST--
--------------
--all vehicle options--
local all_vehicles = world_main:list(T("All Vehicles"))

--explode all vehicles--
all_vehicles:toggle_loop(T("Explode All Vehicles"), {}, "", function()
    local vehicles = entities.get_all_vehicles_as_handles()
    local user_vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), true)
    for _, vehicle in pairs(vehicles) do
        if vehicle ~= user_vehicle then
            local vehicle_pos = ENTITY.GET_ENTITY_COORDS(vehicle, true)
            FIRE.ADD_EXPLOSION(vehicle_pos.x, vehicle_pos.y, vehicle_pos.z, 1, 1.0, true, false, 0.0, false)
        end
    end
end)

--freeze all vehicles--
all_vehicles:toggle_loop(T("Freeze All Vehicles"), {}, "", function()
    local vehicles = entities.get_all_vehicles_as_handles()
    local user_vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), true)
    for _, vehicle in pairs(vehicles) do
        if vehicle ~= user_vehicle then
            ENTITY.FREEZE_ENTITY_POSITION(vehicle, true)
        end
    end
end, function()
    local vehicles = entities.get_all_vehicles_as_handles()
    for _, vehicle in pairs(vehicles) do
        ENTITY.FREEZE_ENTITY_POSITION(vehicle, false)
    end
end)

--no gravity for all vehicles--
all_vehicles:toggle_loop(T("Turn Off Gravity For All Vehicles"), {}, "", function()
    local vehicles = entities.get_all_vehicles_as_handles()
    local user_vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), true)
    for _, vehicle in pairs(vehicles) do
        if vehicle ~= user_vehicle then
            VEHICLE.SET_VEHICLE_GRAVITY(vehicle, false)
        end
    end
end, function()
    local vehicles = entities.get_all_vehicles_as_handles()
    for _, vehicle in pairs(vehicles) do
        VEHICLE.SET_VEHICLE_GRAVITY(vehicle, true)
    end
end)

--let all vehicles jump--
all_vehicles:toggle_loop(T("Jumping Vehicles"), {}, "", function()
    local vehicles = entities.get_all_vehicles_as_handles()
    local user_vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), true)
    for _, vehicle in pairs(vehicles) do
        if vehicle ~= user_vehicle then
            ENTITY.APPLY_FORCE_TO_ENTITY(vehicle, 3, 0, 0, 10, 0.0, 0.0, 0.0, 0, true, false, true, false, true)
        end
    end
    util.yield(2000)
end)

--vehicle chaos, trows vehicles everywere--
all_vehicles:toggle_loop(T("Vehicle Chaos"), {}, "", function()
    local vehicles = entities.get_all_vehicles_as_handles()
    local user_vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), true)
    for _, vehicle in pairs(vehicles) do
        if vehicle ~= user_vehicle then
            ENTITY.APPLY_FORCE_TO_ENTITY(vehicle, 3, math.random(20, 100), math.random(20, 100), math.random(20, 100), 0.0, 0.0, 0.0, 0, true, false, true, false, true)
        end
    end
    util.yield(2000)
end)

--turns all the vehicles 180 in the x axis--
all_vehicles:toggle_loop(T("Turn all Vehicles on Their back"), {}, "", function()
    local vehicles = entities.get_all_vehicles_as_handles()
    local user_vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), true)
    for _, vehicle in pairs(vehicles) do
        if vehicle ~= user_vehicle then
            ENTITY.SET_ENTITY_ROTATION(vehicle, 0, 180, 0, 1, true)
        end
    end
end, function()
    local vehicles = entities.get_all_vehicles_as_handles()
    local user_vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), true)
    for _, vehicle in pairs(vehicles) do
        if vehicle ~= user_vehicle then
            ENTITY.SET_ENTITY_ROTATION(vehicle, 0, 0, 0, 1, true)
        end
    end
end)

--delete all vehicles with a range of 10000--
all_vehicles:toggle_loop(T("Delete All Vehicles"), {}, "", function()
    local my_pos = players.get_position(players.user())
    MISC.CLEAR_AREA_OF_VEHICLES(my_pos.x, my_pos.y, my_pos.z, 10000, false, false, false, false, false, false, false)
    util.yield(1000)
end)

--firework list--
local firework_list = world_main:list(T("Firework"))

--kind of fire work--
local effect_name = "scr_mich4_firework_trailburst"
local asset_name = "scr_rcpaparazzo1"
firework_list:slider(T("Kind"), {}, "", 1, 12, 1, 1, function(count)
    local effects = {
        "scr_mich4_firework_trailburst",
        "scr_indep_firework_air_burst",
        "scr_indep_firework_starburst",
        "scr_indep_firework_trailburst_spawn",
        "scr_firework_indep_burst_rwb",
        "scr_firework_indep_spiral_burst_rwb",
        "scr_firework_indep_ring_burst_rwb",
        "scr_xmas_firework_burst_fizzle",
        "scr_firework_indep_repeat_burst_rwb",
        "scr_firework_xmas_ring_burst_rgw",
        "scr_firework_xmas_repeat_burst_rgw",
        "scr_firework_xmas_spiral_burst_rgw",
    }
    local assets = {
        "scr_rcpaparazzo1",
        "proj_indep_firework",
        "scr_indep_fireworks",
        "scr_indep_fireworks",
        "proj_indep_firework_v2",
        "proj_indep_firework_v2",
        "proj_indep_firework_v2",
        "proj_indep_firework_v2",
        "proj_indep_firework_v2",
        "proj_xmas_firework",
        "proj_xmas_firework",
        "proj_xmas_firework",
    }
    effect_name = effects[count]
    asset_name = assets[count]
end)

--activate fire works----
firework_list:toggle(T("Firework"), {}, "", function(on)
    if on then
        shooting = true
        local user_pos = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0.0, 5.0, 0.0)
        local weap = util.joaat('weapon_firework')
        WEAPON.REQUEST_WEAPON_ASSET(weap)
        while shooting do
            MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(user_pos.x, user_pos.y, user_pos.z, user_pos.x, user_pos.y, user_pos.z + 1, 200, 0, weap, 0, false, false, 1000)
            util.yield(250)
            ent_func.use_fx_asset(asset_name)
            local fx = GRAPHICS.START_PARTICLE_FX_LOOPED_AT_COORD(effect_name, user_pos.x, user_pos.y, user_pos.z+math.random(10, 40), 0.0, 0.0, 0.0, 1.0, false, false, false, false)
            util.yield(1000)
            GRAPHICS.STOP_PARTICLE_FX_LOOPED(fx, false)
        end
    end
    if not on then
        shooting = false
    end
end)

--water bounce height--
local bounce_height = 15
world_main:slider(T("Bounce Height"), {}, "", 1, 100, 15, 1, function(count)
	bounce_height = count
end)

--bouncy water, taken from "my" meteor so taken no credits--
world_main:toggle_loop(T("Bouncy Water"), {}, "", function()
	if PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
		if ENTITY.IS_ENTITY_IN_WATER(entities.get_user_vehicle_as_handle(false)) then
			local vel = v3.new(ENTITY.GET_ENTITY_VELOCITY(entities.get_user_vehicle_as_handle(false)))
			ENTITY.SET_ENTITY_VELOCITY(entities.get_user_vehicle_as_handle(false), vel.x, vel.y, bounce_height)
		end
	else
		if ENTITY.IS_ENTITY_IN_WATER(players.user_ped()) then
			local vel = v3.new(ENTITY.GET_ENTITY_VELOCITY(entities.get_user_vehicle_as_handle(false)))
			ENTITY.SET_ENTITY_VELOCITY(players.user_ped(), vel.x, vel.y, bounce_height)
		end
	end
end)

------------------
--player options--
------------------
player_menu_actions = function(pid)
menu.player_root(pid):divider("NovaScript")
local player_trolling = menu.player_root(pid):list(T("Trolling"))
local player_vehicle = menu.player_root(pid):list(T("Vehicle"))

-----------------
--Trolling list--
-----------------
--teleport list--
local tp_player_list = player_trolling:list(T("Tp Player"))

local teleports = {
  maze_bank = {name=T("Teleport To Maze Bank Helipad"),pos=v3.new(-75.261375,-818.674,326.17517)},
  mt_chiliad = {name=T("Teleport To Mt.Chiliad"),pos=v3.new(492.30,5589.44,794.28)},
  deep_underwater = {name=T("Teleport Deep Underwater"),pos=v3.new(4497.2207,8028.3086,-32.635174)},
  water_surface = {name=T("Teleport On Water Surface"),pos=v3.new(1503.0942,8746.0700,0)},
  large_cell = {name=T("Teleport Into Large Cell"),pos=v3.new(1737.1896,2634.897,45.56497)},
  lsia = {name=T("Teleport To LSIA"),pos=v3.new(-1335.6514,-3044.2737,13.944447)},
  space = {name=T("Teleport To Space"),pos=v3.new(-191.53212,-897.53015,2600.00000)},
}
for _,data in pairs(teleports) do
    tp_player_list:action(data.name, {}, "", function()
        local vehicle = control_vehicle(pid, false, function(vehicle)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(vehicle, data.pos.x, data.pos.y, data.pos.z, false, false, false)
            notify(T("Success"), notif_off)
        end)
        
        if not vehicle then
            local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local is_spectating = menu.ref_by_command_name("spectate" .. players.get_name(pid):lower()).value
            util.trigger_script_event(1 << pid, {891653640, PLAYER.PLAYER_ID(), 1, 32, NETWORK.NETWORK_HASH_FROM_PLAYER_HANDLE(pid), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1})
            util.yield(1000)

            if not is_spectating then
                menu.trigger_commands("spectate" .. players.get_name(pid) .. " on")
                notify(T("Spectating"), notif_off)
            end
            util.yield(8000)

            local mc_bike = ent_func.get_vehicle_from_ped(target_ped)
            local loop = 30
            while mc_bike == 0 and loop > 0 do
                util.yield(100)
                mc_bike = ent_func.get_vehicle_from_ped(target_ped)
                loop = loop - 1
            end

            if mc_bike > 0 then
                ent_func.get_entity_control(mc_bike)
                ENTITY.SET_ENTITY_COORDS_NO_OFFSET(mc_bike, data.pos.x, data.pos.y, data.pos.z, false, false, false)
                notify(T("Success"), notif_off)
            end

            util.yield(2000)
            if not is_spectating then
                menu.trigger_commands("spectate" .. players.get_name(pid) .. " off")
            end
        end
    end)
end

--auras--
local player_aura_list = player_trolling:list(T("Aura's"))

--aura radius--
local player_aura_radius = 10
player_aura_list:slider(T("Aura Radius"), {}, "", 5, 50, 10, 1, function(count)
    player_aura_radius = count
end)

--explosion aura--
player_aura_list:toggle_loop(T("Explosive Aura"), {}, "", function()
    local vehicles = entities.get_all_vehicles_as_pointers()
    local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local player_vehicle = ent_func.get_vehicle_from_ped(player_ped)
    for _, vehicle in pairs(vehicles) do
        local vehicle_handle = entities.pointer_to_handle(vehicle)
        if vehicle_handle ~= player_vehicle then
            local vehicle_pos = ENTITY.GET_ENTITY_COORDS(vehicle_handle)
            if ent_func.get_distance_between(player_ped, vehicle_pos) <= player_aura_radius then
                if VEHICLE.GET_VEHICLE_ENGINE_HEALTH(vehicle_handle) >= 0 then
                    FIRE.ADD_EXPLOSION(vehicle_pos.x, vehicle_pos.y, vehicle_pos.z, 1, 1, false, true, 0.0, false)
                end
            end
        end
    end
    local peds = entities.get_all_peds_as_pointers()
	for _, ped in pairs(peds) do
        local ped_handle = entities.pointer_to_handle(ped)
        if ped_handle ~= player_ped then
            local ped_pos = ENTITY.GET_ENTITY_COORDS(ped_handle, false)
		    if ent_func.get_distance_between(player_ped, ped_pos) <= player_aura_radius then
                if not PED.IS_PED_DEAD_OR_DYING(ped_handle, true) then
		    	    FIRE.ADD_EXPLOSION(ped_pos.x, ped_pos.y, ped_pos.z, 1, 1, false, true, 0.0, false)
                end
		    end
        end
	end
end)

--push aura--
--got this calculation from wiriscript--
player_aura_list:toggle_loop(T("Push Aura"), {}, "", function()
    local vehicles = entities.get_all_vehicles_as_pointers()
    local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local player_vehicle = ent_func.get_vehicle_from_ped(player_ped)
    for _, vehicle in pairs(vehicles) do
        local vehicle_handle = entities.pointer_to_handle(vehicle)
        if vehicle_handle ~= player_vehicle then
            local vehicle_pos = ENTITY.GET_ENTITY_COORDS(vehicle_handle)
            if ent_func.get_distance_between(player_ped, vehicle_pos) <= player_aura_radius then
                local rel = v3.new(vehicle_pos)
                --subtract your pos from rel--
                rel:sub(players.get_position(pid))
                --scales the v3 to have a length of 1--
                rel:normalise()
                if ent_func.get_entity_control_onces(vehicle_handle) then
                    ENTITY.APPLY_FORCE_TO_ENTITY(vehicle_handle, 3, rel.x, rel.y, rel.z, 0.0, 0.0, 1.0, 0, false, false, true, false, false)
                end
            end
        end
    end
    local peds = entities.get_all_peds_as_pointers()
	for _, ped in pairs(peds) do
        local ped_handle = entities.pointer_to_handle(ped)
        if ped_handle ~= player_ped then
            local ped_pos = ENTITY.GET_ENTITY_COORDS(ped_handle, false)
		    if ent_func.get_distance_between(player_ped, ped_pos) <= player_aura_radius then
                local rel = v3.new(ped_pos)
                --subtract your pos from rel--
                rel:sub(players.get_position(pid))
                --scales the v3 to have a length of 1--
                rel:normalise()
                if ent_func.get_entity_control_onces(ped_handle) then
                    PED.SET_PED_TO_RAGDOLL(ped_handle, 2500, 0, 0, false, false, false)
		    	    ENTITY.APPLY_FORCE_TO_ENTITY(ped_handle, 3, rel.x, rel.y, rel.z, 0.0, 0.0, 1.0, 0, false, false, true, false, false)
                end
		    end
        end
	end
end)

--pull aura--
--got this calculation from wiriscript--
player_aura_list:toggle_loop(T("Pull Aura"), {}, "", function()
    local vehicles = entities.get_all_vehicles_as_pointers()
    local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local player_vehicle = ent_func.get_vehicle_from_ped(player_ped)
    for _, vehicle in pairs(vehicles) do
        local vehicle_handle = entities.pointer_to_handle(vehicle)
        if vehicle_handle ~= player_vehicle then
            local vehicle_pos = ENTITY.GET_ENTITY_COORDS(vehicle_handle)
            if ent_func.get_distance_between(player_ped, vehicle_pos) <= player_aura_radius then
                local rel = v3.new(vehicle_pos)
                --subtract your pos from rel--
                rel:sub(players.get_position(pid))
                --scales the v3 to have a length of 1--
                rel:normalise()
                if ent_func.get_entity_control_onces(vehicle_handle) then
                    ENTITY.APPLY_FORCE_TO_ENTITY(vehicle_handle, 3, -rel.x, -rel.y, -rel.z, 0.0, 0.0, 1.0, 0, false, false, true, false, false)
                end
            end
        end
    end
    local peds = entities.get_all_peds_as_pointers()
	for _, ped in pairs(peds) do
        local ped_handle = entities.pointer_to_handle(ped)
        if ped_handle ~= player_ped then
            local ped_pos = ENTITY.GET_ENTITY_COORDS(ped_handle, false)
		    if ent_func.get_distance_between(player_ped, ped_pos) <= player_aura_radius then
                local rel = v3.new(ped_pos)
                --subtract your pos from rel--
                rel:sub(players.get_position(pid))
                --scales the v3 to have a length of 1--
                rel:normalise()
                if ent_func.get_entity_control_onces(ped_handle) then
                    PED.SET_PED_TO_RAGDOLL(ped_handle, 2500, 0, 0, false, false, false)
		    	    ENTITY.APPLY_FORCE_TO_ENTITY(ped_handle, 3, -rel.x, -rel.y, -rel.z, 0.0, 0.0, 1.0, 0, false, false, true, false, false)
                end
		    end
        end
	end
end)

--freeze aura--
player_aura_list:toggle_loop(T("Freeze Aura"), {}, "", function()
    local vehicles = entities.get_all_vehicles_as_pointers()
    local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local player_vehicle = ent_func.get_vehicle_from_ped(player_ped)
    for _, vehicle in pairs(vehicles) do
        local vehicle_handle = entities.pointer_to_handle(vehicle)
        if vehicle_handle ~= player_vehicle then
            local vehicle_pos = ENTITY.GET_ENTITY_COORDS(vehicle_handle)
            if ent_func.get_distance_between(player_ped, vehicle_pos) <= player_aura_radius then
                if ent_func.get_entity_control_onces(vehicle_handle) then
                    ENTITY.FREEZE_ENTITY_POSITION(vehicle_handle, true)
                end
            else
                ENTITY.FREEZE_ENTITY_POSITION(vehicle_handle, false)
            end
        end
    end
    local peds = entities.get_all_peds_as_pointers()
	for _, ped in pairs(peds) do
        local ped_handle = entities.pointer_to_handle(ped)
        if ped_handle ~= player_ped then
            local ped_pos = ENTITY.GET_ENTITY_COORDS(ped_handle, false)
		    if ent_func.get_distance_between(player_ped, ped_pos) <= player_aura_radius then
                if not PED.IS_PED_IN_ANY_VEHICLE(ped_handle, false) then
                    TASK.CLEAR_PED_TASKS_IMMEDIATELY(ped_handle)
                end
                if ent_func.get_entity_control_onces(ped_handle) then
                    ENTITY.FREEZE_ENTITY_POSITION(ped_handle, true)
                end
            else
                ENTITY.FREEZE_ENTITY_POSITION(ped_handle, false)
            end
        end
	end
end)

--boost aura--
player_aura_list:toggle_loop(T("Boost Aura"), {}, "", function()
    local vehicles = entities.get_all_vehicles_as_pointers()
    local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local player_vehicle = ent_func.get_vehicle_from_ped(player_ped)
    for _, vehicle in pairs(vehicles) do
        local vehicle_handle = entities.pointer_to_handle(vehicle)
        if vehicle_handle ~= player_vehicle then
            local vehicle_pos = ENTITY.GET_ENTITY_COORDS(vehicle_handle)
            if ent_func.get_distance_between(player_ped, vehicle_pos) <= player_aura_radius then
                local rel = v3.new(vehicle_pos)
                --subtract your pos from rel--
                rel:sub(players.get_position(players.user()))
                --turn rel into a rot--
                local rot = rel:toRot()
                if ent_func.get_entity_control_onces(vehicle_handle) then
                    ENTITY.SET_ENTITY_ROTATION(vehicle_handle, rot.x, rot.y, rot.z, 2, false)
                    VEHICLE.SET_VEHICLE_FORWARD_SPEED(vehicle_handle, 100)
                end
            end
        end
    end
    local peds = entities.get_all_peds_as_pointers()
	for _, ped in pairs(peds) do
        local ped_handle = entities.pointer_to_handle(ped)
        if ped_handle ~= player_ped then
            local ped_pos = ENTITY.GET_ENTITY_COORDS(ped_handle, false)
		    if ent_func.get_distance_between(player_ped, ped_pos) <= player_aura_radius then
                local rel = v3.new(ped_pos)
                --subtract your pos from rel--
                rel:sub(players.get_position(players.user()))
                --multiply rel with 100--
                rel:mul(100)
                if ent_func.get_entity_control_onces(ped_handle) then
                    PED.SET_PED_TO_RAGDOLL(ped_handle, 2500, 0, 0, false, false, false)
		    	    ENTITY.APPLY_FORCE_TO_ENTITY(ped_handle, 3, rel.x, rel.y, rel.z, 0, 0, 1.0, 0, false, false, true, false, false)
                end
            end
        end
	end
end)

--explode player--
local player_explode_list = player_trolling:list(T("Explode"))

--explosion type--
local explosion_type = 0
player_explode_list:list_action(T("Explosion Type"), {}, T("All explosion types in the game."), tables.explosion_types_name, function(index)
  explosion_type = tables.explosion_types[index]
end)

--explode--
player_explode_list:action(T("Explode"), {}, "", function()
  local pos = players.get_position(pid)
  pos.z = pos.z - 1.0
  FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, explosion_type, 1, true, false, 0.0, false)
end)

--explode no damage--
player_explode_list:action(T("Explode No Damage"), {}, "", function()
  local pos = players.get_position(pid)
  pos.z = pos.z - 1.0
  FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, explosion_type, 1, true, false, 0.0, true)
end)

--explode loop delay--
local expl_speed = 200
player_explode_list:slider(T("Explode Loop Delay"), {}, "", 20, 2000, 200, 10, function(count)
    expl_speed = count
end)

--explode loop--
player_explode_list:toggle_loop(T("Explode Loop"), {}, "", function()
  local pos = players.get_position(pid)
  pos.z = pos.z - 1.0
  FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, explosion_type, 1, true, false, 0.0, false)
  util.yield(expl_speed)
end)

--explode loop no damage--
player_explode_list:toggle_loop(T("Explode No Damage Loop"), {}, "", function()
  local pos = players.get_position(pid)
  pos.z = pos.z - 1.0
  FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, explosion_type, 1, true, false, 0.0, true)
  util.yield(expl_speed)
end)

--ptfx lags--
local ptfx_lags_list = player_trolling:list(T("PTFX Lags"))

local PTFX_lags = {
    smoke = {name=T("Smoke"),asset="scr_agencyheistb",particle="scr_agency3b_elec_box"},
    clown_death = {name=T("Clown Death"),asset="scr_rcbarry2",particle="scr_clown_death"},
    clown_appears = {name=T("Clown Appears"),asset="scr_rcbarry2",particle="scr_clown_appears"},
    wheel_burnout = {name=T("Wheel Burnout"),asset="scr_recartheft",particle="scr_wheel_burnout"},
    orbital_blast = {name=T("Orbital Blast"),asset="scr_xm_orbital",particle="scr_xm_orbital_blast"},
    sparks_point = {name=T("Sparks Point"),asset="des_smash2",particle="ent_ray_fbi4_sparks_point"},
    truck_slam = {name=T("Truck Slam"),asset="des_smash2",particle="ent_ray_fbi4_truck_slam"},
    tanker = {name=T("Tanker"),asset="des_tanker_crash",particle="ent_ray_tanker_exp_sp"},
    fire_work_fountain = {name=T("Fire Work Fountain"),asset="scr_indep_fireworks",particle="scr_indep_firework_fountain"},
}
for _,data in pairs(PTFX_lags) do
    ptfx_lags_list:toggle_loop(data.name, {}, "", function()
        ent_func.use_fx_asset(data.asset)
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        TASK.CLEAR_PED_TASKS_IMMEDIATELY(pid)
        GRAPHICS.START_PARTICLE_FX_NON_LOOPED_ON_ENTITY(data.particle, ped, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5, false, false, false)
    end, function()
        STREAMING.REMOVE_NAMED_PTFX_ASSET(data.asset)
    end)
end

--ragdoll player--
player_trolling:action(T("Ragdoll"), {}, "", function()
    local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
	PED.SET_PED_TO_RAGDOLL(ped, 2500, 0, 0, false, false, false)
end)

--spawn 25 asteroids on the player--
player_trolling:action(T("Asteroids"), {}, "", function()
    for i = 1, 25 do
        local player_coords = players.get_position(pid)
        player_coords.x = math.random(math.floor(player_coords.x - 80), math.floor(player_coords.x + 80))
        player_coords.y = math.random(math.floor(player_coords.y - 80), math.floor(player_coords.y + 80))
        player_coords.z = player_coords.z + math.random(45,90)
        local hash = util.joaat("prop_asteroid_01")
        ent_func.request_model(hash)
        local rand =math.random(-125, 25)
        obj = OBJECT.CREATE_OBJECT(hash, player_coords.x, player_coords.y, player_coords.z, true, false, true)
        ENTITY.APPLY_FORCE_TO_ENTITY(obj, 3, 0.0, 0.0, rand, 0.0, 0.0, 0.0, 0, true, false, true, false, true)
    end
end)

--weapon list--
local player_weapon_list = player_trolling:list(T("Weapon"))

--remove weapons when shooting--
player_weapon_list:toggle_loop(T("Remove Weapon When Shooting"), {""}, "", function()
    local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    if PED.IS_PED_SHOOTING(targetPed) then
        local weaponhash = WEAPON.GET_SELECTED_PED_WEAPON(targetPed)
        WEAPON.REMOVE_WEAPON_FROM_PED(targetPed, weaponhash)
    end
end)

--spawns nuke above player--
player_weapon_list:action(T("Nuke Player"), {}, "", function()
		local hash = util.joaat("prop_military_pickup_01")
		ent_func.request_model(hash)
        local pos = players.get_position(pid)
		local nuke = OBJECT.CREATE_OBJECT_NO_OFFSET(hash, pos.x, pos.y, pos.z + 20, true, false, true)
        ENTITY.APPLY_FORCE_TO_ENTITY(nuke, 3, 0.0, 0.0, -50, 0.0, 0.0, 0.0, 0, true, false, true, false, true)
        ENTITY.SET_ENTITY_HAS_GRAVITY(nuke, true)

		while not ENTITY.HAS_ENTITY_COLLIDED_WITH_ANYTHING(nuke) and not ENTITY.IS_ENTITY_IN_WATER(nuke) do
		    util.yield(0)
		end
		local nukePos = ENTITY.GET_ENTITY_COORDS(nuke, true)
		entities.delete_by_handle(nuke)
		ent_func.create_nuke_explosion(nukePos)
end)

--puts the nuke explosion only on the player--
player_weapon_list:action(T("Set Nuke Explosion On Player"), {}, "", function()
    local pos = players.get_position(pid)
    ent_func.create_nuke_explosion(pos)
end)

----------------
--vehicle list--
----------------
--rotation list--
local rotation_list = player_vehicle:list(T("Rotate Vehicle"))

--freeze vehicle after rotated--
local freeze_vehicle_after_rotated = false
rotation_list:toggle(T("Freeze Vehicle After Rotate"), {}, T("You can not remove the freeze from the vehicle"), function(on)
    freeze_vehicle_after_rotated = on
end)

--rotate 180 degrees y axis--
rotation_list:action(180 .. T(" Degrees"), {}, "", function()
  control_vehicle(pid, true, function(vehicle)
      local rotation = ENTITY.GET_ENTITY_ROTATION(vehicle, 0)
      ENTITY.SET_ENTITY_ROTATION(vehicle, rotation.x, rotation.y, rotation.z+180, 0, true)
      if freeze_vehicle_after_rotated then
        ENTITY.FREEZE_ENTITY_POSITION(vehicle, true)
      end
  end)
end)

--rotate 90 degrees z axis--
rotation_list:action(90 .. T(" Degrees"), {}, "", function()
  control_vehicle(pid, true, function(vehicle)
      local rotation = ENTITY.GET_ENTITY_ROTATION(vehicle, 0)
      ENTITY.SET_ENTITY_ROTATION(vehicle, rotation.x, rotation.y, rotation.z-90, 0, true)
      if freeze_vehicle_after_rotated then
        ENTITY.FREEZE_ENTITY_POSITION(vehicle, true)
      end
  end)
end)

--rotate 270 degrees z axis--
rotation_list:action(270 .. T(" Degrees"), {}, "", function()
  control_vehicle(pid, true, function(vehicle)
      local rotation = ENTITY.GET_ENTITY_ROTATION(vehicle, 0)
      ENTITY.SET_ENTITY_ROTATION(vehicle, rotation.x, rotation.y, rotation.z+90, 0, true)
      if freeze_vehicle_after_rotated then
        ENTITY.FREEZE_ENTITY_POSITION(vehicle, true)
      end
  end)
end)

--rotate 180 degrees x axis--
rotation_list:action(T("Upsidedown"), {}, "", function()
  control_vehicle(pid, true, function(vehicle)
      local rotation = ENTITY.GET_ENTITY_ROTATION(vehicle, 0)
      ENTITY.SET_ENTITY_ROTATION(vehicle, rotation.x, 180, rotation.z, 0, true)
      if freeze_vehicle_after_rotated then
        ENTITY.FREEZE_ENTITY_POSITION(vehicle, true)
      end
  end)
end)

--rotate 90 degrees x axis--
rotation_list:action(T("Right Side"), {}, "", function()
  control_vehicle(pid, true, function(vehicle)
      local rotation = ENTITY.GET_ENTITY_ROTATION(vehicle, 0)
      ENTITY.SET_ENTITY_ROTATION(vehicle, rotation.x, 90, rotation.z, 0, true)
      if freeze_vehicle_after_rotated then
        ENTITY.FREEZE_ENTITY_POSITION(vehicle, true)
      end
  end)
end)

--rotate 270 degrees x axis--
rotation_list:action(T("Left Side"), {}, "", function()
  control_vehicle(pid, true, function(vehicle)
      local rotation = ENTITY.GET_ENTITY_ROTATION(vehicle, 0)
      ENTITY.SET_ENTITY_ROTATION(vehicle, rotation.x, -90, rotation.z, 0, true)
      if freeze_vehicle_after_rotated then
        ENTITY.FREEZE_ENTITY_POSITION(vehicle, true)
      end
    end)
end)

--rotate 270 degrees y axis--
rotation_list:action(T("Front Off The Car"), {}, "", function()
  control_vehicle(pid, true, function(vehicle)
      local rotation = ENTITY.GET_ENTITY_ROTATION(vehicle, 0)
      ENTITY.SET_ENTITY_ROTATION(vehicle, -90, rotation.y, rotation.z, 0, true)
      if freeze_vehicle_after_rotated then
        ENTITY.FREEZE_ENTITY_POSITION(vehicle, true)
      end
  end)
end)

--rotate 90 degrees y axis--
rotation_list:action(T("Back Off The Car"), {}, "", function()
  control_vehicle(pid, true, function(vehicle)
      local rotation = ENTITY.GET_ENTITY_ROTATION(vehicle, 0)
      ENTITY.SET_ENTITY_ROTATION(vehicle, 90, rotation.y, rotation.z, 0, true)
      if freeze_vehicle_after_rotated then
        ENTITY.FREEZE_ENTITY_POSITION(vehicle, true)
      end
  end)
end)

--spawn ramp infont of player--
local ramps_hashes = {util.joaat("prop_mp_ramp_02_tu"), util.joaat("prop_jetski_ramp_01")}
local ramps_names = {T("Ramp 1"), T("Jetski Ramp")}
player_vehicle:list_action(T("Spawn Ramp In_front Of Players Vehicle"), {}, "", ramps_names, function(ramps)
	  local ramp = (ramps_hashes[ramps])
    ent_func.request_model(ramp)
      control_vehicle(pid, true, function(vehicle)
          local veh_coords_offset = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, 0.0, 5, 0.0)
          local heading = ENTITY.GET_ENTITY_HEADING(vehicle)
          local ramp = entities.create_object(ramp, veh_coords_offset)
          ENTITY.SET_ENTITY_HEADING(ramp, heading)
      end)
end)

--movement list--
local movement_list = player_vehicle:list(T("Movement"))

--boost speed--
local vehicle_boost_speed = 100
movement_list:slider(T("Boost speed"), {}, "", 10, 400, 100, 10, function(speed)
	vehicle_boost_speed = speed
end)

--boost players vehicle--
movement_list:action(T("Boost"), {}, "", function()
    control_vehicle(pid, true, function(vehicle)
		    local speed = vehicle_boost_speed
		    VEHICLE.SET_VEHICLE_FORWARD_SPEED(vehicle, speed)
    end)
end)

--launch players vehicle--
movement_list:action(T("Launch Vehicle"), {}, "", function()
    control_vehicle(pid, true, function(vehicle)
        ENTITY.APPLY_FORCE_TO_ENTITY(vehicle, 3, math.random(20, 100), math.random(20, 100), math.random(20, 100), 0.0, 0.0, 0.0, 0, true, false, true, false, true)
    end)
end)

--launches the vehicle super high--
movement_list:action(T("To The Moon"), {}, "", function()
    control_vehicle(pid, true, function(vehicle)
        local i = 0
        repeat
            local rotation = ENTITY.GET_ENTITY_ROTATION(vehicle, 0)
            ENTITY.SET_ENTITY_ROTATION(vehicle, 0, 0, rotation.z, 0, true)
            ENTITY.APPLY_FORCE_TO_ENTITY(vehicle, 3, 0, 0, 500, 0.0, 0.0, 0.0, 0, true, false, true, false, true)
            util.yield(5000)
            i = i + 1
        until(i == 5)
    end)
end)

--explode players vehicle--
player_vehicle:action(T("Explode Vehicle"), {}, "", function()
    control_vehicle(pid, true, function(vehicle)
        local vehicle_pos = ENTITY.GET_ENTITY_COORDS(vehicle, false)
        FIRE.ADD_EXPLOSION(vehicle_pos.x, vehicle_pos.y, vehicle_pos.z, 1, 1, true, false, 0.0, false)
    end)
end)

--repair players vehicle--
player_vehicle:action(T("Repair Vehicle"), {}, "", function()
    control_vehicle(pid, true, function(vehicle)
        VEHICLE.SET_VEHICLE_FIXED(vehicle)
    end)
end)

--kick player out of vehicle--
player_vehicle:action(T("Kick Out Of Vehicle"), {}, "", function()
    local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    TASK.CLEAR_PED_TASKS_IMMEDIATELY(ped)
end)

--detact everything from the players vehilce (wheels, doors and windscreen)--
player_vehicle:action(T("Detach Everything from Vehicle"), {}, "", function()
    control_vehicle(pid, true, function(vehicle)
        local doors = VEHICLE.GET_NUMBER_OF_VEHICLE_DOORS(vehicle)
        VEHICLE.POP_OUT_VEHICLE_WINDSCREEN(vehicle)
        for i= 0, doors do
            VEHICLE.SET_VEHICLE_DOOR_BROKEN(vehicle, i, false)
        end
        menu.trigger_commands("detachwheel" ..  players.get_name(pid))
    end)
end)

--deletes the players vehicle--
player_vehicle:action(T("Delete Vehicle"), {}, "", function()
    control_vehicle(pid, true, function(vehicle)
        entities.delete_by_handle(vehicle)
    end)
end)

--freeze the players vehicle--
player_vehicle:toggle(T("Freeze Vehicle"), {}, "", function(on)
    if on then
        control_vehicle(pid, true, function(vehicle)
            ENTITY.FREEZE_ENTITY_POSITION(vehicle, true)
        end)
    end
    if not on then
        control_vehicle(pid, true, function(vehicle)
            ENTITY.FREEZE_ENTITY_POSITION(vehicle, false)
        end)
    end
end)

--turn gravity off for players vehicle--
player_vehicle:toggle(T("Turn Off Gravity"), {}, "", function(on)
    if on then
        control_vehicle(pid, true, function(vehicle)
             VEHICLE.SET_VEHICLE_GRAVITY(vehicle, false)
        end)
    end
    if not on then
        control_vehicle(pid, true, function(vehicle)
            VEHICLE.SET_VEHICLE_GRAVITY(vehicle, true)
        end)
    end
end)

end
players.on_join(player_menu_actions)
players.dispatch_on_join()

--------
--LOGO--
--------
--logo loading when script starts--
if SCRIPT_MANUAL_START and not SCRIPT_SILENT_START then
    util.create_thread(function()
        local logo = directx.create_texture(filesystem.scripts_dir() .. "lib/NovaScript/NovaScript_logo.png")

        local l = -100
        while l <= 90 do
            for j = 1, 195, 5 do
                directx.draw_texture(logo, 0.10, 0.10, 0.5, 0.5, l/1000, 0.73, 0, {r = 1, g = 1, b = 1, a = j/255})
                util.yield(0)
                l = l + 5
            end
        end

        for i = 1, 220 do
            directx.draw_texture(logo, 0.10, 0.10, 0.5, 0.5, 0.09, 0.73, 0, {r = 1, g = 1, b = 1, a = 255})
            util.yield(0)
        end

        local k = 90
        while k >= -10 do
            for j = 195, 1, -5 do
                directx.draw_texture(logo, 0.10, 0.10, 0.5, 0.5, k/1000, 0.73, 0, {r = 1, g = 1, b = 1, a = j/255})
                util.yield(0)
                k = k - 5
            end
        end
    end)
end