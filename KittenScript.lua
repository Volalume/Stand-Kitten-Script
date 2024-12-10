    --[[
        Developer: @volalume
        Original Developer: @icedoomfist / https://github.com/IceDoomfist
        MEOW
    ]]--
    --[[
    V5 변경사항:
        Updated -> GTAV Build b.3407 (Online 1.70)
    ]]--
--------

main_var = {
    SCRIPT_NAME = "Kitten",
    SCRIPT_VER = 4,

    delay_Type = 1,
    delay_sec = {
        delay_1 = 500,
        delay_2 = 11500
    },

    orbital_flag = {
        waiting_500 = false,
        waiting_11500 = false,
        turn_down = false
    },

    loop_flag = {
        is_loop_running = false,
        is_autoskip_running = false,
        is_debugtext_on = true
    },

    transaction_error_flag = { -- thx for jinx
        util.joaat("CTALERT_F"),
        util.joaat("CTALERT_F_1"),
        util.joaat("CTALERT_F_2"),
        util.joaat("CTALERT_F_3"),
        util.joaat("CTALERT_F_4"),
    },

    limit_flag = {
        limit_selection = 50000000,
        got = 0,
        is_limit = true,
    },

    fast_change = {
        rp_selection = 120
    },
}

labels = {
    main_root = "Meow",
        
    Money_labels = {
        money_div = "Make Money",

        money_tab = "Make Money",
        instant_tab = "Instant Money",
        safe_tab = "Safe Money",
        custom_tab = "Custom Money",

        orbital_menu = "[$] Earn Orbital Money",
        orbital_desc = "slowest but safest and stable method, not limited!!\nflag_500: delay1, flag_11500: delay4",

        ez680k_menu = "[$] Earn 680k",
        ez180k_menu = "[$] Earn 180k",
        ez50k_menu = "[$] Earn 50k",
        ez_desc = "standard method but limited\ndelay 1",
    },

    Misc_labels = {
        misc_tab = "Misc",

        misc_div = "Misc",

        trans_atskp_menu = "Auto Skip Transaction Error",
        trans_atskp_desc = "It won't prevent errors, but it will automatically skip the error screen.\nthanks to jinx",

        fast_unlock = "Fast Unlock All",
        fast_unlock_desc = ":)",

        fast_change_rp_div = "Fast Change RP",

        fast_rp_sel_name = "Rank: ",
        fast_rp_sel_desc = ":)",
        fast_do_rp = "Change RP",
        fast_do_rp_desc = "Max: 8,000",
        fast_do_rep = "Change LS Rep",
        fast_do_rep_desc = "Max: 1,000",

        limit_div = "Earn limit",
        
        limit_sel = "Limit: ",
        limit_sel_de = "Default: $50,000m",

        reset_earn = "Reset Earned",
        
        limit_enable = "Enable",
        limit_enable_desc = "The loop will automatically turn off when you reach the amount you set."
    },

    Setting_labels = {
        setting_tab = "Setting",
        
        delay_select_div = "Delay Selection",

        delay_type = "Delay Type",
        delay_type_desc = "Select Delay Methods for Money Loops\n\nTime: standard method\nBasket Detect: Auto Delay System\nRapid: cooked",
        delay_type_Time = "Time",
        delay_type_BasketDetection = "Basket Detecttion",
        delay_type_Rapid = "Rapid",
        new_delay_type_Time = "New delay Type: Time",
        new_delay_type_BasketDetection = "New delay Type: Basket Detect (This Method was patched by r*)",
        new_delay_type_Rapid = "New delay Type: Rapid",

        delay_set_tab = "Delay Setting",
        delay_set_div = "Delay Settings",

        delay_custom_select_1 = "Select Delay 1: ",
        delay_custom_select_1_desc = "Default: 500ms",
        delay_custom_select_2 = "Select Delay 2: ",
        delay_custom_select_2_desc = "Default: 1000ms",
        delay_custom_select_3 = "Select Delay 3: ",
        delay_custom_select_3_desc = "Default: 10000ms", 
        delay_custom_select_4 = "Select Delay 4: ",
        delay_custom_select_4_desc = "Default: 11500ms", 
        
        overlay_div = "Watermark Setting",

        dbgtext_menu = "Debug Text",
        dbgtext_desc = "Show Debug Text"
    },

    Watermark_label = {
        none = "",
        name = "Kitten Script".." v"..main_var.SCRIPT_VER,
        credit = "@volalume @icedoomfist",

        orbital_wlf = {
            flag_500 = "orbital_flag: waiting_delay_1",
            flag_11500 = "orbital_flag: waiting_delay_2",
            flag_turndown = "orbital_flag: turning down",
            flag_none = "orbital_flag: not running"
        },

        loop_wlf = {
            running_name = "",
            nothing_is_running = "Nothing is running",

            loop_flag_end_text = " is running",

            autoskip_on = "Error AutoSkip: on",
            autoskip_off = "Error AutoSkip: off"
        },   
        
       limit_wlf = {
            limited_earn = "Limited Earn: "..main_var.limit_flag.limit_selection,
            your_earned = "You Earned: "..main_var.limit_flag.got,
            is_limit_wlf = "Limit: "..main_var.limit_flag.is_limit
        },  
    },

    Flag_label = {
        done = "done"
    },
}

global_var = {
    
    instant = {
        ezmoney = 4537945, --3407
        orbital = 1962995, --3407
        chips = 1963515, --outdated (shit)
    },

    ezmoney_hash = {
        category = 1474183246,

        bet = 2896648878,
        obj = 0x615762F1,
        tiunk = 0x610F9AB4
    },

    safe_loop = {
        nightclub_safe = 262145, --outdated (detected?)
    }
}

---

util.require_natives(1681379138)

function set_global_i(global, value)
    memory.write_int(memory.script_global(global), value)
end

function set_stat_i(stat, value)
    STATS.STAT_SET_INT(util.joaat(ADD_MP_INDEX(stat)), value, true)
end

function add_mp_index(stat)
    local Exceptions = {
        "MP_CHAR_STAT_RALLY_ANIM",
        "MP_CHAR_ARMOUR_1_COUNT",
        "MP_CHAR_ARMOUR_2_COUNT",
        "MP_CHAR_ARMOUR_3_COUNT",
        "MP_CHAR_ARMOUR_4_COUNT",
        "MP_CHAR_ARMOUR_5_COUNT",
    }
    for _, exception in pairs(Exceptions) do
        if stat == exception then
            return "MP" .. util.get_char_slot() .. "_" .. stat
        end
    end

    if not string.contains(stat, "MP_") and not string.contains(stat, "MPPLY_") then
        return "MP" .. util.get_char_slot() .. "_" .. stat
    end
    return stat
end

function tp_coords(x, y, z)
    PED.SET_PED_COORDS_KEEP_toggle_loop1EHICLE(players.user_ped(), x, y, z)
end

function do_ezmoney(hash, amount)
    set_global_i(global_var.instant.ezmoney + 1, 2147483646)
    set_global_i(global_var.instant.ezmoney + 7, 2147483647)
    set_global_i(global_var.instant.ezmoney + 6, 0)
    set_global_i(global_var.instant.ezmoney + 5, 0)
    set_global_i(global_var.instant.ezmoney + 3, hash)
    set_global_i(global_var.instant.ezmoney + 2, amount)
    set_global_i(global_var.instant.ezmoney, 2)
end


menu.divider(menu.my_root(), labels.main_root)

---#Menu
Money = menu.list(menu.my_root(), labels.Money_labels.money_tab, {"makemoney"}, "", function(); end)

Misc = menu.list(menu.my_root(), labels.Misc_labels.misc_tab, {"misc"}, "", function(); end)

Setting = menu.list(menu.my_root(), labels.Setting_labels.setting_tab, {"setting"}, "", function(); end)
--Delay = menu.list(Setting, "Delay Setting", {"delaysetting"}, "", function(); end) / Line 133

---#Instant Money
menu.toggle_loop(Money, labels.Money_labels.orbital_menu, {"orbtloop"}, labels.Money_labels.orbital_desc, function() --TODO: Fixed on V3
    main_var.loop_flag.is_loop_running = true
    labels.Watermark_label.loop_wlf.running_name = labels.Money_labels.orbital_menu

    if(main_var.limit_flag.got >= main_var.limit_flag.limit_selection) then
        util.toast(labels.Flag_label.done)
        menu.trigger_commands("orbtloop off")
    else
        set_global_i(global_var.instant.orbital, 1)
    end
    main_var.orbital_flag.waiting_500 = true
    util.yield(main_var.delay_sec.delay_1)
    main_var.orbital_flag.waiting_500 = false

    if(main_var.limit_flag.got >= main_var.limit_flag.limit_selection) then
        util.toast(labels.Flag_label.done)
        menu.trigger_commands("orbtloop off")
    else
        set_global_i(global_var.instant.orbital, 0)
        main_var.limit_flag.got = main_var.limit_flag.got + 500000
    end
    main_var.orbital_flag.waiting_11500 = true;
    util.yield(main_var.delay_sec.delay_2)
    main_var.orbital_flag.waiting_11500 = false;

    if(main_var.limit_flag.got >= main_var.limit_flag.limit_selection) then
        util.toast(labels.Flag_label.done)
        menu.trigger_commands("orbtloop off")
    else
        set_global_i(global_var.instant.orbital, 2)
    end
    main_var.orbital_flag.waiting_500 = true
    util.yield(main_var.delay_sec.delay_1)
    main_var.orbital_flag.waiting_500 = false

    if(main_var.limit_flag.got >= main_var.limit_flag.limit_selection) then
        util.toast(labels.Flag_label.done)
        menu.trigger_commands("orbtloop off")
    else
        set_global_i(global_var.instant.orbital, 0)
        main_var.limit_flag.got = main_var.limit_flag.got + 750000
    end
    main_var.orbital_flag.waiting_11500 = true;
    util.yield(main_var.delay_sec.delay_2)
end, function()
    main_var.orbital_flag.waiting_500 = false
    main_var.orbital_flag.waiting_11500 = false;
    main_var.orbital_flag.turn_down = true;

    main_var.loop_flag.is_loop_running = false;
    labels.Watermark_label.loop_wlf.running_name = ""

    do_ezmoney(global_var.ezmoney_hash.tiunk, 0)
end)

menu.toggle_loop(Money, labels.Money_labels.ez680k_menu, {"680kloop"}, labels.Money_labels.ez_desc, function()
    main_var.loop_flag.is_loop_running = true
    labels.Watermark_label.loop_wlf.running_name = labels.Money_labels.ez680k_menu

    price = NETSHOPPING.NET_GAMESERVER_GET_PRICE(global_var.ezmoney_hash.bet, global_var.ezmoney_hash.category, true)
    if main_var.delay_Type == 1 then
        if(main_var.limit_flag.got >= main_var.limit_flag.limit_selection) then
            util.toast(labels.Flag_label.done)
            menu.trigger_commands("680kloop off")
        else
            do_ezmoney(global_var.ezmoney_hash.bet, price)
            main_var.limit_flag.got = main_var.limit_flag.got + price
        end
        util.yield(main_var.delay_sec.delay_1)
    elseif main_var.delay_Type == 2 then
        if(main_var.limit_flag.got >= main_var.limit_flag.limit_selection) then
            util.toast(labels.Flag_label.done)
            menu.trigger_commands("680kloop off")
        else
            do_ezmoney(global_var.ezmoney_hash.bet, price)
            main_var.limit_flag.got = main_var.limit_flag.got + price
        end
        util.yield(main_var.delay_sec.delay_1)
    else
        if(main_var.limit_flag.got >= main_var.limit_flag.limit_selection) then
            util.toast(labels.Flag_label.done)
            menu.trigger_commands("680kloop off")
        else
            do_ezmoney(global_var.ezmoney_hash.bet, price)
            main_var.limit_flag.got = main_var.limit_flag.got + price
        end
    end
end, function()
    main_var.loop_flag.is_loop_running = false;
    labels.Watermark_label.loop_wlf.running_name = ""
    do_ezmoney(global_var.ezmoney_hash.tiunk, 0)
end)

menu.toggle_loop(Money, labels.Money_labels.ez180k_menu, {"180kloop"}, labels.Money_labels.ez_desc, function()
    main_var.loop_flag.is_loop_running = true
    labels.Watermark_label.loop_wlf.running_name = labels.Money_labels.ez180k_menu

    price = NETSHOPPING.NET_GAMESERVER_GET_PRICE(global_var.ezmoney_hash.obj, global_var.ezmoney_hash.category, true)
    if main_var.delay_Type == 1 then
        if(main_var.limit_flag.got >= main_var.limit_flag.limit_selection) then
            util.toast(labels.Flag_label.done)
            menu.trigger_commands("180kloop off")
        else
            do_ezmoney(global_var.ezmoney_hash.obj, price)
            main_var.limit_flag.got = main_var.limit_flag.got + price
        end
        util.yield(main_var.delay_sec.delay_1)
    elseif main_var.delay_Type == 2 then
        if(main_var.limit_flag.got >= main_var.limit_flag.limit_selection) then
            util.toast(labels.Flag_label.done)
            menu.trigger_commands("180kloop off")
        else
            do_ezmoney(global_var.ezmoney_hash.obj, price)
            main_var.limit_flag.got = main_var.limit_flag.got + price
        end
        util.yield(main_var.delay_sec.delay_1)
    else
        if(main_var.limit_flag.got >= main_var.limit_flag.limit_selection) then
            util.toast(labels.Flag_label.done)
            menu.trigger_commands("180kloop off")
        else
            do_ezmoney(global_var.ezmoney_hash.obj, price)
            main_var.limit_flag.got = main_var.limit_flag.got + price
        end
    end
end, function()
    main_var.loop_flag.is_loop_running = false;
    labels.Watermark_label.loop_wlf.running_name = ""
    do_ezmoney(global_var.ezmoney_hash.tiunk, 0)
end)

menu.toggle_loop(Money, labels.Money_labels.ez50k_menu, {"50kloop"}, labels.Money_labels.ez_desc, function()
    main_var.loop_flag.is_loop_running = true
    labels.Watermark_label.loop_wlf.running_name = labels.Money_labels.ez50k_menu

    price = NETSHOPPING.NET_GAMESERVER_GET_PRICE(global_var.ezmoney_hash.tiunk, global_var.ezmoney_hash.category, true)
    if main_var.delay_Type == 1 then
        if(main_var.limit_flag.got >= main_var.limit_flag.limit_selection) then
            util.toast(labels.Flag_label.done)
            menu.trigger_commands("50kloop off")
        else
            do_ezmoney(global_var.ezmoney_hash.tiunk, price)
            main_var.limit_flag.got = main_var.limit_flag.got + price
        end
        util.yield(main_var.delay_sec.delay_1)
    elseif main_var.delay_Type == 2 then
        if(main_var.limit_flag.got >= main_var.limit_flag.limit_selection) then
            util.toast(labels.Flag_label.done)
            menu.trigger_commands("50kloop off")
        else
            do_ezmoney(global_var.ezmoney_hash.tiunk, price)
            main_var.limit_flag.got = main_var.limit_flag.got + price
        end
        util.yield(main_var.delay_sec.delay_1)
    else
        if(main_var.limit_flag.got >= main_var.limit_flag.limit_selection) then
            util.toast(labels.Flag_label.done)
            menu.trigger_commands("50kloop off")
        else
            do_ezmoney(global_var.ezmoney_hash.tiunk, price)
            main_var.limit_flag.got = main_var.limit_flag.got + price
        end
    end
end, function()
    main_var.loop_flag.is_loop_running = false;
    labels.Watermark_label.loop_wlf.running_name = ""
    do_ezmoney(global_var.ezmoney_hash.tiunk, 0)
end)

---#Safe Money


---#Misc
menu.divider(Misc, labels.Misc_labels.misc_div)

menu.toggle_loop(Misc, labels.Misc_labels.trans_atskp_menu, {"autoskiptans"}, labels.Misc_labels.trans_atskp_desc, function() --thx for jinx
    main_var.loop_flag.is_autoskip_running = true
    local msgHash = HUD.GET_WARNING_SCREEN_MESSAGE_HASH()
    for i, hash in ipairs(main_var.transaction_error_flag) do
        if msgHash == hash then
            PAD.SET_CONTROL_VALUE_NEXT_FRAME(2, 201, 1.0)
            util.yield()
        end
    end
    util.yield()
end, function()
    main_var.loop_flag.is_autoskip_running = false
end)

menu.action(Misc, labels.Misc_labels.fast_unlock, {"fastunlockall"}, labels.Misc_labels.fast_unlock_desc, function()
    menu.trigger_commands("unlockall")
    menu.trigger_commands("unlockprizeride")
end)

menu.divider(Misc, labels.Misc_labels.fast_change_rp_div)

fast_rp_selection = menu.slider(Misc, labels.Misc_labels.fast_rp_sel_name, {"selectfastrp"}, labels.Misc_labels.fast_rp_sel_desc, 0, 8000, 120, 1, function()
    main_var.fast_change.rp_selection = menu.get_value(fast_rp_selection)
end)

menu.action(Misc, labels.Misc_labels.fast_do_rp, {"fastchangerp"}, labels.Misc_labels.fast_do_rp_desc, function()
    menu.trigger_commands("setrank "..main_var.fast_change.rp_selection)
    util.yield(100)
    menu.trigger_commands("go solo")
end)

menu.action(Misc, labels.Misc_labels.fast_do_rep, {"fastchangels"}, labels.Misc_labels.fast_do_rep_desc, function()
    menu.trigger_commands("setlscarmeetreplevel "..main_var.fast_change.rp_selection)
end)

menu.divider(Misc, labels.Misc_labels.limit_div)

earn_limiter = menu.slider(Misc, labels.Misc_labels.limit_sel, {"selectearnlimit"}, labels.Misc_labels.limit_sel_de, 0, 2147483647, 50000000, 1000000, function()
    main_var.limit_flag.limit_selection = menu.get_value(earn_limiter)
end)

menu.action(Misc, labels.Misc_labels.reset_earn, {"resetearned"}, "", function()
    main_var.limit_flag.got = 0
end)

menu.toggle(Misc, labels.Misc_labels.limit_enable, {"earn limit"}, labels.Misc_labels.limit_enable_desc, function(on)
    main_var.limit_flag.is_limit = on
end, true)

---#Setting
menu.divider(Setting, labels.Setting_labels.delay_select_div)

menu.textslider_stateful(Setting, labels.Setting_labels.delay_type, {}, labels.Setting_labels.delay_type_desc, {
labels.Setting_labels.delay_type_Time,
labels.Setting_labels.delay_type_BasketDetection,
labels.Setting_labels.delay_type_Rapid,
}, function(index)
    if index == 1 then
        util.toast(labels.Setting_labels.new_delay_type_Time)
        main_var.delay_Type = 1
    elseif  index == 2 then
        util.toast(labels.Setting_labels.new_delay_type_BasketDetection)
        main_var.delay_Type = 2
    else
        util.toast(labels.Setting_labels.new_delay_type_Rapid)
        main_var.delay_Type = 3
    end
end)

Delay = menu.list(Setting, labels.Setting_labels.delay_set_tab, {"delaysetting"}, "", function(); end)

menu.divider(Delay, labels.Setting_labels.delay_set_div)

delay_1_selection = menu.slider(Delay, labels.Setting_labels.delay_custom_select_1, {"selectdelay1"}, labels.Setting_labels.delay_custom_select_1_desc, 0, 100000, 500, 50, function()
    --util.toast("New Delay 1: " ..main_var.delay_sec.delay_1)
    main_var.delay_sec.delay_1 = menu.get_value(delay_1_selection)
end)

delay_2_selection = menu.slider(Delay, labels.Setting_labels.delay_custom_select_4, {"selectdelay4"}, labels.Setting_labels.delay_custom_select_3_desc, 0, 100000000, 11500, 500, function()
    --util.toast("New Delay 3: " ..main_var.delay_sec.delay_3)
    main_var.delay_sec.delay_2 = menu.get_value(delay_2_selection)
end)

menu.divider(Setting, labels.Setting_labels.overlay_div)

menu.toggle(Setting, labels.Setting_labels.dbgtext_menu, {"dbgtext"}, labels.Setting_labels.dbgtext_desc, function(on)
    main_var.loop_flag.is_debugtext_on = on
end, true)

---#ends

util.show_corner_help(labels.Watermark_label.credit)
util.yield(1000)
util.show_corner_help(labels.Watermark_label.name)
util.yield(1000)

util.create_tick_handler(function()
    util.draw_debug_text(labels.Watermark_label.none)
    util.draw_debug_text(labels.Watermark_label.name)
    util.draw_debug_text(labels.Watermark_label.credit)
    util.draw_debug_text(labels.Watermark_label.none)
    
    if main_var.loop_flag.is_debugtext_on then
        if main_var.orbital_flag.waiting_500 then
            util.draw_debug_text(labels.Watermark_label.orbital_wlf.flag_500)
        elseif main_var.orbital_flag.waiting_11500 then
            util.draw_debug_text(labels.Watermark_label.orbital_wlf.flag_11500)
        elseif main_var.orbital_flag.turn_down then
            util.draw_debug_text(labels.Watermark_label.orbital_wlf.flag_turndown)
        else
            util.draw_debug_text(labels.Watermark_label.orbital_wlf.flag_none)
        end
    
        if main_var.loop_flag.is_loop_running then
            util.draw_debug_text(labels.Watermark_label.loop_wlf.running_name..labels.Watermark_label.loop_wlf.loop_flag_end_text)
        else
            util.draw_debug_text(labels.Watermark_label.loop_wlf.nothing_is_running)
        end
    
        if main_var.loop_flag.is_autoskip_running then
            util.draw_debug_text(labels.Watermark_label.loop_wlf.autoskip_on)
        else
            util.draw_debug_text(labels.Watermark_label.loop_wlf.autoskip_off)
        end

        util.draw_debug_text(labels.Watermark_label.none)

        util.draw_debug_text(labels.Watermark_label.limit_wlf.limited_earn)
        util.draw_debug_text(labels.Watermark_label.limit_wlf.your_earned)
        util.draw_debug_text(labels.Watermark_label.limit_wlf.is_limit_wlf)
    end
end)

