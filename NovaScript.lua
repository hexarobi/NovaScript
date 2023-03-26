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

function T(text)
    --get the current lang--
    local current_lang = lang.get_current()
    --gets the current lang out of the table--
    local lang_translations = trans.translations[current_lang]
    --if the lang exists in the lang table and the text that im trying to translate exist in the current lang table then--
    if lang_translations and lang_translations[text] then
        --return the translated text--
        return lang_translations[text]
    else
        --if the lang doesnt exist and the text in the lang doesnt exist then return the english translation of the word if that doesnt exist then you go over to the text i put at the option itself--
        return trans.translations["en"][text] or text
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
            notify(T("player_is_not_in_a_vehicle"), notif_off)
        end
        return false
    end
end

----------------
--LOCAL OPTONS--
----------------
local self_main = menu.my_root():list(T("self"))
local all_players_main = menu.my_root():list(T("all_players"))
local vehicle_main = menu.my_root():list(T("vehicle"))
local weapons_main = menu.my_root():list(T("weapons"))
local world_main = menu.my_root():list(T("world"))
local settings_main = menu.my_root():list(T("settings"))

-----------------
--SETTINGS LIST--
-----------------
--no notifications--
notif_off = false
settings_main:toggle(T("no_notif"), {}, "", function(on)
    notif_off = on
end)

settings_main:action(T("check_for_update"), {}, T("check_for_update_info"), function()
    auto_update_config.check_interval = 0
    if auto_updater.run_auto_update(auto_update_config) then
        notify(T("no_updates_found"))
    end
end)
settings_main:action(T("clean_reinstall"), {}, T("clean_reinstall_info"), function()
    auto_update_config.clean_reinstall = true
    auto_updater.run_auto_update(auto_update_config)
end)

--credits--
local credit_list = settings_main:list(T("credits"))
local translators_credit_list = credit_list:list(T("translators"))
--german--
translators_credit_list:action("! N0mbyy", {},  T("Tname1"), function()
end)
--spanish--
translators_credit_list:action("Rodri", {}, T("Tname2"), function()
end)
--french--
translators_credit_list:action("XenonMido", {}, T("Tname3"), function()
end)

--aaron--
credit_list:action("Aaron", {}, T("helping_me_in_programming"), function()
end)
--hexarobi--
credit_list:action("Hexarobi", {}, T("helping_me_with_started"), function()
end)
--acjoker--
credit_list:action("AcJoker", {}, T("helping_me_in_programming"), function()
end)
--well in that case--
credit_list:action("well in that case", {}, T("helping_me_in_programming"), function()
end)
--jaymontana--
credit_list:action("JayMontana", {}, T("helping_me_in_programming"), function()
end)
--not tonk--
credit_list:action("Not Tonk", {}, T("helping_me_in_programming"), function()
end)
--totaw annihiwation--
credit_list:action("Totaw Annihiwation", {}, T("helping_me_in_programming"), function()
end)
--mr. robot--
credit_list:action("Mr. Robot", {}, T("helping_me_in_programming"), function()
end)
--glidem8--
credit_list:action("GlideM8", {}, T("helping_me_in_programming"), function()
end)
--davus--
credit_list:action("Davus", {}, T("helping_me_in_programming"), function()
end)
--any missed--
credit_list:action(T("any_missed_credits"), {}, "", function()
end)

settings_main:hyperlink(T("join_the_discord"),"https://discord.gg/CNf6Y6Uw")

-------------
--SELF LIST--
-------------
--enter nearest vehicle--
self_main:action(T("enter_nearest_vehicle"), {}, "", function()
	if not PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
		local player_pos = players.get_position(players.user())
		local veh = ent_func.getClosestVehicle(player_pos)
		local ped = VEHICLE.GET_PED_IN_VEHICLE_SEAT(veh, -1, true)
		if PED.IS_PED_A_PLAYER(ped) then
			notify(T("an_player_is_in_the_nearest_vehicle"))
		else
		    entities.delete_by_handle(ped)
			PED.SET_PED_INTO_VEHICLE(players.user_ped(), veh, -1)
		end
	end
end)

--go to nearest player--
self_main:action(T("go_to_nearest_player"), {}, "", function()
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
self_main:action(T("hijack_random_players_vehicle"), {}, "", function()
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
local aura_list = self_main:list(T("auras"))

--aura radius--
local aura_radius = 10
aura_list:slider(T("aura_rad"), {}, "", 5, 50, 10, 1, function(count)
    aura_radius = count
end)

--explosion aura--
aura_list:toggle_loop(T("expl_aura"), {}, "", function()
    local vehicles = entities.get_all_vehicles_as_handles()
    local user_vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), true)
    for _, vehicle in pairs(vehicles) do
        if vehicle ~= user_vehicle then
            local vehicle_pos = ENTITY.GET_ENTITY_COORDS(vehicle)
            if ent_func.get_distance_between(players.user_ped(), vehicle_pos) <= aura_radius then
                if VEHICLE.GET_VEHICLE_ENGINE_HEALTH(vehicle) >= 0 then
                    FIRE.ADD_EXPLOSION(vehicle_pos.x, vehicle_pos.y, vehicle_pos.z, 1, 1, false, true, 0.0, false)
                end
            end
        end
    end
    local peds = entities.get_all_peds_as_handles()
	for _, ped in pairs(peds) do
        if ped ~= players.user_ped() then
            local ped_pos = ENTITY.GET_ENTITY_COORDS(ped, false)
		    if ent_func.get_distance_between(players.user_ped(), ped_pos) <= aura_radius then
                if not PED.IS_PED_DEAD_OR_DYING(ped, true) then
		    	    FIRE.ADD_EXPLOSION(ped_pos.x, ped_pos.y, ped_pos.z, 1, 1, false, true, 0.0, false)
                end
		    end
        end
	end
end)

--push aura--
--got this calculation from wiriscript--
aura_list:toggle_loop(T("push_aura"), {}, "", function()
    local vehicles = entities.get_all_vehicles_as_handles()
    local user_vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), true)
    for _, vehicle in pairs(vehicles) do
        if vehicle ~= user_vehicle then
            local vehicle_pos = ENTITY.GET_ENTITY_COORDS(vehicle)
            if ent_func.get_distance_between(players.user_ped(), vehicle_pos) <= aura_radius then
                local rel = v3.new(vehicle_pos)
                --subtract your pos from rel--
                rel:sub(players.get_position(players.user()))
                --scales the v3 to have a length of 1--
                rel:normalise()
                ENTITY.APPLY_FORCE_TO_ENTITY(vehicle, 3, rel.x, rel.y, rel.z, 0.0, 0.0, 1.0, 0, false, false, true, false, false)
            end
        end
    end
    local peds = entities.get_all_peds_as_handles()
	for _, ped in pairs(peds) do
        if ped ~= players.user_ped() then
            local ped_pos = ENTITY.GET_ENTITY_COORDS(ped, false)
		    if ent_func.get_distance_between(players.user_ped(), ped_pos) <= aura_radius then
                local rel = v3.new(ped_pos)
                --subtract your pos from rel--
                rel:sub(players.get_position(players.user()))
                --scales the v3 to have a length of 1--
                rel:normalise()
                PED.SET_PED_TO_RAGDOLL(ped, 2500, 0, 0, false, false, false)
		    	ENTITY.APPLY_FORCE_TO_ENTITY(ped, 3, rel.x, rel.y, rel.z, 0.0, 0.0, 1.0, 0, false, false, true, false, false)
		    end
        end
	end
end)

--pull aura--
--got this calculation from wiriscript--
aura_list:toggle_loop(T("pull_aura"), {}, "", function()
    local vehicles = entities.get_all_vehicles_as_handles()
    local user_vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), true)
    for _, vehicle in pairs(vehicles) do
        if vehicle ~= user_vehicle then
            local vehicle_pos = ENTITY.GET_ENTITY_COORDS(vehicle)
            if ent_func.get_distance_between(players.user_ped(), vehicle_pos) <= aura_radius then
                local rel = v3.new(vehicle_pos)
                --subtract your pos from rel--
                rel:sub(players.get_position(players.user()))
                --scales the v3 to have a length of 1--
                rel:normalise()
                ENTITY.APPLY_FORCE_TO_ENTITY(vehicle, 3, -rel.x, -rel.y, -rel.z, 0.0, 0.0, 1.0, 0, false, false, true, false, false)
            end
        end
    end
    local peds = entities.get_all_peds_as_handles()
	for _, ped in pairs(peds) do
        if ped ~= players.user_ped() then
            local ped_pos = ENTITY.GET_ENTITY_COORDS(ped, false)
		    if ent_func.get_distance_between(players.user_ped(), ped_pos) <= aura_radius then
                local rel = v3.new(ped_pos)
                --subtract your pos from rel--
                rel:sub(players.get_position(players.user()))
                --scales the v3 to have a length of 1--
                rel:normalise()
                PED.SET_PED_TO_RAGDOLL(ped, 2500, 0, 0, false, false, false)
		    	ENTITY.APPLY_FORCE_TO_ENTITY(ped, 3, -rel.x, -rel.y, -rel.z, 0.0, 0.0, 1.0, 0, false, false, true, false, false)
		    end
        end
	end
end)

--freeze aura--
aura_list:toggle_loop(T("freeze_aura"), {}, "", function()
    local vehicles = entities.get_all_vehicles_as_handles()
    local user_vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), true)
    for _, vehicle in pairs(vehicles) do
        if vehicle ~= user_vehicle then
            local vehicle_pos = ENTITY.GET_ENTITY_COORDS(vehicle)
            if ent_func.get_distance_between(players.user_ped(), vehicle_pos) <= aura_radius then
                ENTITY.FREEZE_ENTITY_POSITION(vehicle, true)
            else
                ENTITY.FREEZE_ENTITY_POSITION(vehicle, false)
            end
        end
    end
    local peds = entities.get_all_peds_as_handles()
	for _, ped in pairs(peds) do
        if ped ~= players.user_ped() then
            local ped_pos = ENTITY.GET_ENTITY_COORDS(ped, false)
		    if ent_func.get_distance_between(players.user_ped(), ped_pos) <= aura_radius then
                if not PED.IS_PED_IN_ANY_VEHICLE(ped, false) then
                    TASK.CLEAR_PED_TASKS_IMMEDIATELY(ped)
                end
                ENTITY.FREEZE_ENTITY_POSITION(ped, true)
            else
                ENTITY.FREEZE_ENTITY_POSITION(ped, false)
            end
        end
	end
end)

--boost aura--
aura_list:toggle_loop(T("boost_aura"), {}, "", function()
    local vehicles = entities.get_all_vehicles_as_handles()
    local user_vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), true)
    for _, vehicle in pairs(vehicles) do
        if vehicle ~= user_vehicle then
            local vehicle_pos = ENTITY.GET_ENTITY_COORDS(vehicle)
            if ent_func.get_distance_between(players.user_ped(), vehicle_pos) <= aura_radius then
                local rel = v3.new(vehicle_pos)
                --subtract your pos from rel--
                rel:sub(players.get_position(players.user()))
                --turn rel into a rot--
                local rot = rel:toRot()
                ENTITY.SET_ENTITY_ROTATION(vehicle, rot.x, rot.y, rot.z, 2, false)
                VEHICLE.SET_VEHICLE_FORWARD_SPEED(vehicle, 100)
            end
        end
    end
    local peds = entities.get_all_peds_as_handles()
	for _, ped in pairs(peds) do
        if ped ~= players.user_ped() then
            local ped_pos = ENTITY.GET_ENTITY_COORDS(ped, false)
		    if ent_func.get_distance_between(players.user_ped(), ped_pos) <= aura_radius then
                local rel = v3.new(ped_pos)
                --subtract your pos from rel--
                rel:sub(players.get_position(players.user()))
                --multiply rel with 100--
                rel:mul(100)
                PED.SET_PED_TO_RAGDOLL(ped, 2500, 0, 0, false, false, false)
		    	ENTITY.APPLY_FORCE_TO_ENTITY(ped, 3, rel.x, rel.y, rel.z, 0, 0, 1.0, 0, false, false, true, false, false)
            end
        end
	end
end)

--forward roll--
local i = 360
self_main:toggle_loop(T("forward_roll"), {}, "", function()
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
self_main:toggle_loop(T("breakdance"), {}, "", function()
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
    util.yield(100)
    TASK.STOP_ANIM_TASK(players.user_ped(), dict, name, 1)
end)

--delete police--
self_main:toggle_loop(T("delete_police"), {}, "", function()
    local my_pos = players.get_position(players.user())
    MISC.CLEAR_AREA_OF_COPS(my_pos.x, my_pos.y, my_pos.z, 40000, 0)
    util.yield(500)
end)

--error screens--
local error_list = self_main:list(T("error_screen"))
local custom_error = ""
error_list:text_input(T("custom_error"), {"custom_error_text"}, "", function(input)
    custom_error = input
end)

local error_types = {"Banned", "Altered Version", "Error With Session", "Suspended", "Could Not Download Files", "Custom"}
local error_number = 1
error_list:list_select(T("error_type"), {}, "",  error_types, 1, function(index)
    error_number = index
end)

--got help from this website "https://vespura.com/fivem/scaleform/#POPUP_WARNING" helps alot if anyone needs it--
error_list:toggle(T("error_screen"), {}, "", function(on)
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
local explode_all_players_list = all_players_main:list(T("explosions"))

--explosion type--
local explosion_type = 0
explode_all_players_list:list_action(T("explosion_type"), {}, T("all_explosions"), tables.explosion_types_name, function(index)
  explosion_type = tables.explosion_types[index]
end)

--explode all-
explode_all_players_list:action(T("explode_all"), {}, "", function()
  for i, pid in pairs(players.list(false, true, true)) do
    local pos = players.get_position(pid)
    pos.z = pos.z - 1.0
    FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, explosion_type, 1, true, false, 0.0, false)
  end
end)

--explode all no damage--
explode_all_players_list:action(T("explode_all_no_damage"), {}, "", function()
  for i, pid in pairs(players.list(false, true, true)) do
    local pos = players.get_position(pid)
    pos.z = pos.z - 1.0
    FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, explosion_type, 1, true, false, 0.0, true)
  end
end)

--explode loop delay--
local expl_speed = 200
explode_all_players_list:slider(T("explode_loop_delay"), {}, "", 20, 2000, 200, 10, function(count)
	expl_speed = count
end)

--explode all loop--
explode_all_players_list:toggle_loop(T("explode_all_loop"), {}, "", function()
  for i, pid in pairs(players.list(false, true, true)) do
    local pos = players.get_position(pid)
    pos.z = pos.z - 1.0
    FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, explosion_type, 1, true, false, 0.0, false)
  end
  util.yield(expl_speed)
end)

--explode all loop no damage--
explode_all_players_list:toggle_loop(T("explode_all_no_damage_loop"), {}, "", function()
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
local horn_opt_list = vehicle_main:list(T("horn_options"))

--horn explosion type--
local explosion_type = 0
horn_opt_list:list_action(T("explosion_type"), {}, T("all_explosions"), tables.explosion_types_name, function(index)
  explosion_type = tables.explosion_types[index]
end)

--horn explosion--
horn_explosions_opt = horn_opt_list:toggle_loop(T("horn_explosion"), {}, "", function()
	if PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
	    local vehicle = entities.get_user_vehicle_as_handle(players.user())
	    if AUDIO.IS_HORN_ACTIVE(vehicle) then
            local rand_num = math.random(20, 80)
            local veh_coords_offset = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, 0.0, rand_num, 1)
            FIRE.ADD_EXPLOSION(veh_coords_offset.x, veh_coords_offset.y, veh_coords_offset.z, explosion_type, 1.0, true, false, 0.4, false)
            util.yield(100)
        end
    else
		notify(T("not_in_vehicle"), notif_off)
        menu.set_value(horn_explosions_opt, false)
    end
end)

--horn boost speed--
local horn_boost_speed = 100
horn_opt_list:slider(T("boost_speed"), {}, "", 10, 400, 100, 10, function(count)
	horn_boost_speed = count
end)

--horn boost--
horn_boost_opt = horn_opt_list:toggle_loop(T("horn_boost"), {}, "", function()
	if PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
	    local vehicle = entities.get_user_vehicle_as_handle(players.user())
        if AUDIO.IS_HORN_ACTIVE(vehicle) then
	        local speed = horn_boost_speed
	    	VEHICLE.SET_VEHICLE_FORWARD_SPEED(vehicle, speed)
	    	local velocity = ENTITY.GET_ENTITY_VELOCITY(vehicle)
            ENTITY.SET_ENTITY_VELOCITY(vehicle, velocity.x, velocity.y, velocity.z)
        end
    else
        notify(T("not_in_vehicle"), notif_off)
        menu.set_value(horn_boost_opt, false)
    end
end)

--auto repair--
auto_repair_opt = vehicle_main:toggle_loop(T("auto_repair"), {}, T("auto_repair_msg"), function()
    if PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
        local vehicle = entities.get_user_vehicle_as_handle(players.user())
        local vehicle_health = ENTITY.GET_ENTITY_HEALTH(vehicle)
        if vehicle_health <= 500 then
            VEHICLE.SET_VEHICLE_FIXED(vehicle)
        end
    else
        notify(T("not_in_vehicle"), notif_off)
        menu.set_value(auto_repair_opt, false)
    end
end)

--spawn ramp vehicle--
vehicle_main:action(T("spawn_big_ramp_vehicle"), {}, "", function()
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
vehicle_drift = vehicle_main:toggle_loop(T("drift"), {},  T("while_holding_shift_u_drift"), function()
    user_vehicle = ent_func.get_vehicle_from_ped(players.user_ped())
    if user_vehicle ~= 0 then
        if PAD.IS_DISABLED_CONTROL_PRESSED(0, 61) then
            VEHICLE.SET_VEHICLE_REDUCE_GRIP(user_vehicle, true)
        else
            VEHICLE.SET_VEHICLE_REDUCE_GRIP(user_vehicle, false)
        end
    else
        notify(T("not_in_vehicle"), notif_off)
        menu.set_value(vehicle_drift, false)
    end
end, function()
    VEHICLE.SET_VEHICLE_REDUCE_GRIP(user_vehicle, false)
end)

--vehicle rpm flames list--
local rpm_flames_list = vehicle_main:list(T("rpm_flames"))

--sets the min value of the rpm--
local rpm_min_value = 150
rpm_flames_list:slider(T("flames_speed"), {} , "", 100, 1000, 150, 5, function(value)
    rpm_min_value = value
end)

--sets the rpm of the vehicle when the rpm of the vehicle is less then x value--
rpm_flames = rpm_flames_list:toggle_loop(T("rpm_flames"), {}, "", function()
    local user_vehicle = ent_func.get_vehicle_from_ped(players.user_ped())
    if user_vehicle ~= 0 then
        local user_vehicle_pointer = entities.handle_to_pointer(user_vehicle)
        entities.set_rpm(user_vehicle_pointer, 2.0)
    else
        notify(T("not_in_vehicle"), notif_off)
        menu.set_value(rpm_flames, false)
    end
    util.yield(rpm_min_value)
end)

--indicator lights--
local indicator_lights_list = vehicle_main:list(T("indicator_lights"))

--all lights--
all_lights_opt = indicator_lights_list:toggle(T("all_lights"), {}, "", function(on)
    if on then
        if PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
            local vehicle = entities.get_user_vehicle_as_handle(players.user())
            VEHICLE.SET_VEHICLE_INDICATOR_LIGHTS(vehicle, 0, true)
            VEHICLE.SET_VEHICLE_INDICATOR_LIGHTS(vehicle, 1, true)
        else
            notify(T("not_in_vehicle"), notif_off)
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
right_lights_opt = indicator_lights_list:toggle(T("right_side"), {}, "", function(on)
    if on then
        if PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
            local vehicle = entities.get_user_vehicle_as_handle(players.user())
            VEHICLE.SET_VEHICLE_INDICATOR_LIGHTS(vehicle, 0, true)
        else
            notify(T("not_in_vehicle"), notif_off)
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
left_lights_opt = indicator_lights_list:toggle(T("left_side"), {}, "", function(on)
    if on then
        if PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
            local vehicle = entities.get_user_vehicle_as_handle(players.user())
            VEHICLE.SET_VEHICLE_INDICATOR_LIGHTS(vehicle, 1, true)
        else
            notify(T("not_in_vehicle"), notif_off)
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
local door_control = vehicle_main:list(T("door_control"))

--open all doors--
doors_open_opt = door_control:action(T("open_all_doors"), {}, "", function()
    if PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
        local vehicle = entities.get_user_vehicle_as_handle(players.user())
        local doors = VEHICLE.GET_NUMBER_OF_VEHICLE_DOORS(vehicle)
        for i= 0, doors do
            VEHICLE.SET_VEHICLE_DOOR_OPEN(vehicle, i, false, true)
        end
    else
        notify(T("not_in_vehicle"), notif_off)
        menu.set_value(doors_open_opt, false)
    end
end)

--close all doors--
doors_close_opt = door_control:action(T("close_all_doors"), {}, "", function()
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
doors_break_opt = door_control:action(T("break_all_doors"), {}, "", function()
    if PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
        local vehicle = entities.get_user_vehicle_as_handle(players.user())
        local doors = VEHICLE.GET_NUMBER_OF_VEHICLE_DOORS(vehicle)
        for i= 0, doors do
            VEHICLE.SET_VEHICLE_DOOR_BROKEN(vehicle, i, false)
        end
    else
        notify(T("not_in_vehicle"), notif_off)
        menu.set_value(doors_break_opt, false)
    end
end)
---------------
--WEAPON LIST--
---------------
--vehicle gun--
local vehicle_gun_list = weapons_main:list(T("vehicle_gun"))

--vehicles for vehicle gun--
local vehhash = util.joaat("italigtb2")
local veh_hashes = {util.joaat("italigtb2"), util.joaat("terbyte"), util.joaat("speedo2"), util.joaat("trash2"), util.joaat("vigilante"), util.joaat("lazer"), util.joaat("insurgent2"), util.joaat("cutter"), util.joaat("phantom2")}
local veh_options = {"Itali GTB Custom", "Terrorbyte", "Clown Van", "Trashmaster", "Vigilante", "Lazer", "Insurgent", "Cutter", "Phantom Wedge"}
vehicle_gun_list:list_action(T("vehicles"), {}, "", veh_options, function(index)
  vehhash = veh_hashes[index]
end)

--vehicle gun--
vehicle_gun_list:toggle_loop(T("vehicle_gun"), {}, "", function()
    if PED.IS_PED_SHOOTING(players.user_ped()) then
        local hash = vehhash
        ent_func.request_model(hash)
        local player_pos = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0.0, 5.0, 3.0)
        local vehicle = VEHICLE.CREATE_VEHICLE(hash, player_pos.x, player_pos.y, player_pos.z, 5,true, true, false)
        ENTITY.SET_ENTITY_NO_COLLISION_ENTITY(vehicle, players.user_ped(), true)
        local cam_rot = CAM.GET_GAMEPLAY_CAM_ROT(0)
        ENTITY.SET_ENTITY_ROTATION(vehicle, cam_rot.x, cam_rot.y, cam_rot.z, 0, true)
        VEHICLE.SET_VEHICLE_CUSTOM_PRIMARY_COLOUR(vehicle, math.random(0, 255), math.random(0, 255), math.random(0, 255))
        VEHICLE.SET_VEHICLE_CUSTOM_SECONDARY_COLOUR(vehicle, math.random(0, 255), math.random(0, 255), math.random(0, 255))
        VEHICLE.SET_VEHICLE_FORWARD_SPEED(vehicle, 200)
        if set_in_vehicle then
            PED.SET_PED_INTO_VEHICLE(players.user_ped(), vehicle, -1)
        end
    end
end)

--spawn inside vehicle shot by vehicle gun--
set_in_vehicle = false
vehicle_gun_list:toggle(T("set_in_vehicle"), {}, "", function(on)
    set_in_vehicle = on
end)

--bullet reactions--
local bullet_reactions_list = weapons_main:list(T("bullet_reactions"))

--bullet reaction boost--
bullet_reactions_list:toggle_loop(T("boost_vehicle"), {}, "", function()
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
bullet_reactions_list:toggle_loop(T("explode_entity"), {}, "", function()
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
bullet_reactions_list:toggle_loop(T("freeze_entity"), {}, "", function()
    if PED.IS_PED_SHOOTING(players.user_ped()) then
        local entity = ent_func.get_entity_player_is_aiming_at(players.user())
        if entity ~= 0 then
            ENTITY.FREEZE_ENTITY_POSITION(entity, true)
        end
    end
end)

--bullet reaction gravity off--
bullet_reactions_list:toggle_loop(T("gravity_off_entity"), {}, "", function()
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
weapons_main:slider(T("multiplier_amount"), {} , T("zero_change"), 10, 200, 10, 5, function(value)
	size_multiplier = value
end)

--size multiplier, taken--
weapons_main:toggle_loop(T("size_multiplier"), {}, "", function()
    local weapon = WEAPON.GET_SELECTED_PED_WEAPON(players.user_ped())
	WEAPON.SET_WEAPON_AOE_MODIFIER(weapon, size_multiplier / 10) --the / 10 is needed bc im doing *10 for every thing in the slider to have more size option--
	util.yield(10)
end, function()
    local weapon = WEAPON.GET_SELECTED_PED_WEAPON(players.user_ped())
	WEAPON.SET_WEAPON_AOE_MODIFIER(weapon, 1.0)
end)

--explosion type for inpact gun--
local explosion_type = 0
weapons_main:list_action(T("explosion_type"), {}, T("all_explosions"), tables.explosion_types_name, function(index)
  explosion_type = tables.explosion_types[index]
end)

--explosion inpact gun--
weapons_main:toggle_loop(T("impact_gun"), {}, "", function()
	local hitCoords = v3.new()
	WEAPON.GET_PED_LAST_WEAPON_IMPACT_COORD(players.user_ped(), hitCoords)
	FIRE.ADD_EXPLOSION(hitCoords.x, hitCoords.y, hitCoords.z, explosion_type, 1, true, false, 0.5, false)
end)

--custom c4 list--
local custom_c4_list = weapons_main:list(T("custom_c4_list"))

--trows the c4 when you shoot--
custom_c4_list:toggle_loop(T("custom_c4_gun"), {}, "", function()
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
local custom_c4_explosions = {T("orbital_expl"), T("nuke_expl")}
custom_c4_list:textslider(T("custom_c4_list"), {}, "", custom_c4_explosions, function(index, name)
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
weapons_main:toggle_loop(T("orbital_gun"), {}, "", function()
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
weapons_main:toggle_loop(T("nuke_gun"), {}, "", function()
	if PED.IS_PED_SHOOTING(players.user_ped()) then
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
weapons_main:toggle_loop(T("shooting_effect"), {}, "", function()
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
local all_vehicles = world_main:list(T("all_vehicles"))

--explode all vehicles--
all_vehicles:toggle_loop(T("explode_all_vehicles"), {}, "", function()
local vehicles = entities.get_all_vehicles_as_handles()
local user_vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), true)
    for _, vehicle in pairs(vehicles) do
        if vehicle ~= user_vehicle then
            VEHICLE.EXPLODE_VEHICLE(vehicle, true, false)
        end
    end
    util.yield(2000)
end)

--freeze all vehicles--
all_vehicles:toggle_loop(T("freeze_all_vehicles"), {}, "", function()
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
all_vehicles:toggle_loop(T("turn_off_gravity_all_vehicles"), {}, "", function()
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
all_vehicles:toggle_loop(T("jumping_vehicles"), {}, "", function()
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
all_vehicles:toggle_loop(T("vehicle_chaos"), {}, "", function()
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
all_vehicles:toggle_loop(T("turn_vehicles_on_back"), {}, "", function()
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
all_vehicles:toggle_loop(T("delete_all_vehicles"), {}, "", function()
local my_pos = players.get_position(players.user())
    MISC.CLEAR_AREA_OF_VEHICLES(my_pos.x, my_pos.y, my_pos.z, 10000, false, false, false, false, false, false, false)
    util.yield(1000)
end)

--water bounce height--
local bounce_height = 15
world_main:slider(T("bounce_height"), {}, "", 1, 100, 15, 1, function(count)
	bounce_height = count
end)

--bouncy water, taken from "my" meteor so taken no credits--
world_main:toggle_loop(T("bouncy_water"), {}, "", function()
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
local player_trolling = menu.player_root(pid):list(T("trolling"))
local player_vehicle = menu.player_root(pid):list(T("vehicle"))

-----------------
--Trolling list--
-----------------
--teleport list--
local tp_player_list = player_trolling:list(T("tp_player"))

local teleports = {
  maze_bank = {name=T("tp_maze_bank_helipad"),pos=v3.new(-75.261375,-818.674,326.17517)},
  mt_chiliad = {name=T("tp_mt_chiliad"),pos=v3.new(492.30,5589.44,794.28)},
  deep_underwater = {name=T("tp_deep_underwater"),pos=v3.new(4497.2207,8028.3086,-32.635174)},
  water_surface = {name=T("tp_water_surface"),pos=v3.new(1503.0942,8746.0700,0)},
  large_cell = {name=T("tp_into_large_cell"),pos=v3.new(1737.1896,2634.897,45.56497)},
  lsia = {name=T("tp_lsia"),pos=v3.new(-1335.6514,-3044.2737,13.944447)},
  space = {name=T("tp_space"),pos=v3.new(-191.53212,-897.53015,2600.00000)},
}
for _,data in pairs(teleports) do
    tp_player_list:action(data.name, {}, "", function()
        local vehicle = control_vehicle(pid, false, function(vehicle)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(vehicle, data.pos.x, data.pos.y, data.pos.z, false, false, false)
            notify(T("success"), notif_off)
        end)
        
        if not vehicle then
            local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local is_spectating = menu.ref_by_command_name("spectate" .. players.get_name(pid):lower()).value
            util.trigger_script_event(1 << pid, {891653640, PLAYER.PLAYER_ID(), 1, 32, NETWORK.NETWORK_HASH_FROM_PLAYER_HANDLE(pid), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1})
            util.yield(1000)

            if not is_spectating then
                menu.trigger_commands("spectate" .. players.get_name(pid) .. " on")
                util.toast("Spectating")
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
                notify(T("success"), notif_off)
            end

            util.yield(2000)
            if not is_spectating then
                menu.trigger_commands("spectate" .. players.get_name(pid) .. " off")
            end
        end
    end)
end

--explode player--
local player_explode_list = player_trolling:list(T("explode"))

--explosion type--
local explosion_type = 0
player_explode_list:list_action(T("explosion_type"), {}, T("all_explosions"), tables.explosion_types_name, function(index)
  explosion_type = tables.explosion_types[index]
end)

--explode--
player_explode_list:action(T("explode"), {}, "", function()
  local pos = players.get_position(pid)
  pos.z = pos.z - 1.0
  FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, explosion_type, 1, true, false, 0.0, false)
end)

--explode no damage--
player_explode_list:action(T("explode_no_damage"), {}, "", function()
  local pos = players.get_position(pid)
  pos.z = pos.z - 1.0
  FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, explosion_type, 1, true, false, 0.0, true)
end)

--explode loop delay--
local expl_speed = 200
player_explode_list:slider(T("explode_loop_delay"), {}, "", 20, 2000, 200, 10, function(count)
    expl_speed = count
end)

--explode loop--
player_explode_list:toggle_loop(T("explode_loop"), {}, "", function()
  local pos = players.get_position(pid)
  pos.z = pos.z - 1.0
  FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, explosion_type, 1, true, false, 0.0, false)
  util.yield(expl_speed)
end)

--explode loop no damage--
player_explode_list:toggle_loop(T("explode_no_damage_loop"), {}, "", function()
  local pos = players.get_position(pid)
  pos.z = pos.z - 1.0
  FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, explosion_type, 1, true, false, 0.0, true)
  util.yield(expl_speed)
end)

--ptfx lags--
local ptfx_lags_list = player_trolling:list(T("lags"))

local PTFX_lags = {
    smoke = {name="Smoke",asset="scr_agencyheistb",particle="scr_agency3b_elec_box"},
    clown_death = {name="Clown Death",asset="scr_rcbarry2",particle="scr_clown_death"},
    clown_appears = {name="Clown Appears",asset="scr_rcbarry2",particle="scr_clown_appears"},
    wheel_burnout = {name="Wheel Burnout",asset="scr_recartheft",particle="scr_wheel_burnout"},
    orbital_blast = {name="Orbital Blast",asset="scr_xm_orbital",particle="scr_xm_orbital_blast"},
    sparks_point = {name="Sparks Point",asset="des_smash2",particle="ent_ray_fbi4_sparks_point"},
    truck_slam = {name="Truck Slam",asset="des_smash2",particle="ent_ray_fbi4_truck_slam"},
    tanker = {name="Tanker",asset="des_tanker_crash",particle="ent_ray_tanker_exp_sp"},
    fire_work_fountain = {name="Fire Work Fountain",asset="scr_indep_fireworks",particle="scr_indep_firework_fountain"},
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
player_trolling:action(T("ragdoll"), {}, "", function()
    local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
	PED.SET_PED_TO_RAGDOLL(ped, 2500, 0, 0, false, false, false)
end)

--spawn 25 asteroids on the player--
player_trolling:action(T("asteroids"), {}, "", function()
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
local player_weapon_list = player_trolling:list(T("weapon"))

--remove weapons when shooting--
player_weapon_list:toggle_loop(T("remove_weapon_shooting"), {""}, "", function()
    local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    if PED.IS_PED_SHOOTING(targetPed) then
        local weaponhash = WEAPON.GET_SELECTED_PED_WEAPON(targetPed)
        WEAPON.REMOVE_WEAPON_FROM_PED(targetPed, weaponhash)
    end
end)

--spawns nuke above player--
player_weapon_list:action(T("nuke_player"), {}, "", function()
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
player_weapon_list:action(T("set_nuke_expl_on_player"), {}, "", function()
    local pos = players.get_position(pid)
    ent_func.create_nuke_explosion(pos)
end)

----------------
--vehicle list--
----------------
--rotation list--
local rotation_list = player_vehicle:list(T("rotate_vehicle"))

--freeze vehicle after rotated--
local freeze_vehicle_after_rotated = false
rotation_list:toggle(T("freeze_vehicle_after_rotate"), {}, T("cant_remove_freeze"), function(on)
    freeze_vehicle_after_rotated = on
end)

--rotate 180 degrees y axis--
rotation_list:action(180 .. T("degrees"), {}, "", function()
  control_vehicle(pid, true, function(vehicle)
      local rotation = ENTITY.GET_ENTITY_ROTATION(vehicle, 0)
      ENTITY.SET_ENTITY_ROTATION(vehicle, rotation.x, rotation.y, rotation.z+180, 0, true)
      if freeze_vehicle_after_rotated then
        ENTITY.FREEZE_ENTITY_POSITION(vehicle, true)
      end
  end)
end)

--rotate 90 degrees z axis--
rotation_list:action(90 .. T("degrees"), {}, "", function()
  control_vehicle(pid, true, function(vehicle)
      local rotation = ENTITY.GET_ENTITY_ROTATION(vehicle, 0)
      ENTITY.SET_ENTITY_ROTATION(vehicle, rotation.x, rotation.y, rotation.z-90, 0, true)
      if freeze_vehicle_after_rotated then
        ENTITY.FREEZE_ENTITY_POSITION(vehicle, true)
      end
  end)
end)

--rotate 270 degrees z axis--
rotation_list:action(270 .. T("degrees"), {}, "", function()
  control_vehicle(pid, true, function(vehicle)
      local rotation = ENTITY.GET_ENTITY_ROTATION(vehicle, 0)
      ENTITY.SET_ENTITY_ROTATION(vehicle, rotation.x, rotation.y, rotation.z+90, 0, true)
      if freeze_vehicle_after_rotated then
        ENTITY.FREEZE_ENTITY_POSITION(vehicle, true)
      end
  end)
end)

--rotate 180 degrees x axis--
rotation_list:action(T("upsidedown"), {}, "", function()
  control_vehicle(pid, true, function(vehicle)
      local rotation = ENTITY.GET_ENTITY_ROTATION(vehicle, 0)
      ENTITY.SET_ENTITY_ROTATION(vehicle, rotation.x, 180, rotation.z, 0, true)
      if freeze_vehicle_after_rotated then
        ENTITY.FREEZE_ENTITY_POSITION(vehicle, true)
      end
  end)
end)

--rotate 90 degrees x axis--
rotation_list:action(T("right_side"), {}, "", function()
  control_vehicle(pid, true, function(vehicle)
      local rotation = ENTITY.GET_ENTITY_ROTATION(vehicle, 0)
      ENTITY.SET_ENTITY_ROTATION(vehicle, rotation.x, 90, rotation.z, 0, true)
      if freeze_vehicle_after_rotated then
        ENTITY.FREEZE_ENTITY_POSITION(vehicle, true)
      end
  end)
end)

--rotate 270 degrees x axis--
rotation_list:action(T("left_side"), {}, "", function()
  control_vehicle(pid, true, function(vehicle)
      local rotation = ENTITY.GET_ENTITY_ROTATION(vehicle, 0)
      ENTITY.SET_ENTITY_ROTATION(vehicle, rotation.x, -90, rotation.z, 0, true)
      if freeze_vehicle_after_rotated then
        ENTITY.FREEZE_ENTITY_POSITION(vehicle, true)
      end
    end)
end)

--rotate 270 degrees y axis--
rotation_list:action(T("front_of_car"), {}, "", function()
  control_vehicle(pid, true, function(vehicle)
      local rotation = ENTITY.GET_ENTITY_ROTATION(vehicle, 0)
      ENTITY.SET_ENTITY_ROTATION(vehicle, -90, rotation.y, rotation.z, 0, true)
      if freeze_vehicle_after_rotated then
        ENTITY.FREEZE_ENTITY_POSITION(vehicle, true)
      end
  end)
end)

--rotate 90 degrees y axis--
rotation_list:action(T("back_of_car"), {}, "", function()
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
local ramps_names = {"Ramp 1", "Jetski Ramp"}
player_vehicle:list_action(T("spawn_ramp_in_front_player"), {}, "", ramps_names, function(ramps)
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
local movement_list = player_vehicle:list(T("movement"))

--boost speed--
local vehicle_boost_speed = 100
movement_list:slider(T("boost_speed"), {}, "", 10, 400, 100, 10, function(speed)
	vehicle_boost_speed = speed
end)

--boost players vehicle--
movement_list:action(T("boost"), {}, "", function()
    control_vehicle(pid, true, function(vehicle)
		    local speed = vehicle_boost_speed
		    VEHICLE.SET_VEHICLE_FORWARD_SPEED(vehicle, speed)
    end)
end)

--launch players vehicle--
movement_list:action(T("launch_vehicle"), {}, "", function()
    control_vehicle(pid, true, function(vehicle)
        ENTITY.APPLY_FORCE_TO_ENTITY(vehicle, 3, math.random(20, 100), math.random(20, 100), math.random(20, 100), 0.0, 0.0, 0.0, 0, true, false, true, false, true)
    end)
end)

--launches the vehicle super high--
movement_list:action(T("to_the_moon"), {}, "", function()
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
player_vehicle:action(T("explode_vehicle"), {}, "", function()
    control_vehicle(pid, true, function(vehicle)
        local vehicle_pos = ENTITY.GET_ENTITY_COORDS(vehicle, false)
        FIRE.ADD_EXPLOSION(vehicle_pos.x, vehicle_pos.y, vehicle_pos.z, 1, 1, true, false, 0.0, false)
    end)
end)

--repair players vehicle--
player_vehicle:action(T("repair_vehicle"), {}, "", function()
    control_vehicle(pid, true, function(vehicle)
        VEHICLE.SET_VEHICLE_FIXED(vehicle)
    end)
end)

--kick player out of vehicle--
player_vehicle:action(T("kick_out_of_vehicle"), {}, "", function()
    local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    TASK.CLEAR_PED_TASKS_IMMEDIATELY(ped)
end)

--detact everything from the players vehilce (wheels, doors and windscreen)--
player_vehicle:action(T("detach_everything_from_vehicle"), {}, "", function()
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
player_vehicle:action(T("delete_vehicle"), {}, "", function()
    control_vehicle(pid, true, function(vehicle)
        entities.delete_by_handle(vehicle)
    end)
end)

--freeze the players vehicle--
player_vehicle:toggle(T("freeze_vehicle"), {}, "", function(on)
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
player_vehicle:toggle(T("turn_off_gravity"), {}, "", function(on)
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