    --[[
        Developer: @volalume
        Original Developer: @icedoomfist / https://github.com/IceDoomfist
        MEOW
    ]]--

    --[[
    TODO: 오비탈 / 기타 등등 글로벌 변수화
          SKR 기능 이전
          설정저장
          돈추가 카운터 (오류발생시 추가 X 포함? - Errorhash이용)
          메뉴 div 추가 및 탭 이름들 바꾸기
          번역기능 추가
    ]]--

    --[[
    V3 변경사항:
    Earn Orbital - 루프 오류 해결
    ]]--
--------

main_var = {
    SCRIPT_NAME = "Mewo",
    SCRIPT_VER = 3,

    delay_Type = 1,
    delay_sec = {
        delay_1 = 500,
        delay_2 = 1000,
        delay_3 = 10000
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
        orbital_desc = "slowest but safest and stable method, not limited!!\nflag_500: delay 1\nflag_11500: delay 1 + delay2 + delay3",

        ez680k_menu = "[$] Earn 680k",
        ez180k_menu = "[$] Earn 180k",
        ez50k_menu = "[$] Earn 50k",
        ez_desc = "standard method but limited\ndelay 1",
    },

    Misc_labels = {
        misc_tab = "Misc",

        misc_div = "Misc",

        trans_atskp_menu = "Auto Skip Transaction Error",
        trans_atskp_desc = "It won't prevent errors, but it will automatically skip the error screen.\nthanks to jinx"
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
        
        overlay_div = "Watermark Setting",

        dbgtext_menu = "Debug Text",
        dbgtext_desc = "Show Debug Text"
    },

    Watermark_label = {
        none = "",
        name = "Kitten Script".." v"..main_var.SCRIPT_VER,
        credit = "@volalume @icedoomfist",

        orbital_wlf = {
            flag_500 = "orbital_flag: waiting_"..main_var.delay_sec.delay_1.."ms",
            flag_11500 = "orbital_flag: waiting_"..main_var.delay_sec.delay_1 + main_var.delay_sec.delay_2 + main_var.delay_sec.delay_3.."ms",
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

        
    },

    System_label = {
        --loopblock = "Only one loop can be active"
    }
}

global_var = {
    
    instant = {
        ezmoney = 4537311,
        orbital = 1962237,
        chips = 1963515,
    },

    ezmoney_hash = {
        category = 1474183246,

        bet = 2896648878,
        obj = 0x615762F1,
        tiunk = 0x610F9AB4
    },

    safe_loop = {
        nightclub_safe = 262145,
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

menu.divider(Money, labels.Money_labels.money_div)
Money_instant = menu.list(Money, labels.Money_labels.instant_tab, {"instantmoney"}, "", function(); end)
Money_safe = menu.list(Money, labels.Money_labels.safe_tab, {"safemoney"}, "", function(); end)
Money_custom = menu.list(Money, labels.Money_labels.custom_tab, {"custommoney"}, "", function(); end)

Misc = menu.list(menu.my_root(), labels.Misc_labels.misc_tab, {"misc"}, "", function(); end)

Setting = menu.list(menu.my_root(), labels.Setting_labels.setting_tab, {"setting"}, "", function(); end)
--Delay = menu.list(Setting, "Delay Setting", {"delaysetting"}, "", function(); end) / Line 133

---#Instant Money
menu.toggle_loop(Money_instant, labels.Money_labels.orbital_menu, {"orbtloop"}, labels.Money_labels.orbital_desc, function() --TODO: Fixed on V3
    main_var.loop_flag.is_loop_running = true
    labels.Watermark_label.loop_wlf.running_name = labels.Money_labels.orbital_menu

    set_global_i(global_var.instant.orbital, 1)
    main_var.orbital_flag.waiting_500 = true
    util.yield(main_var.delay_sec.delay_1)
    main_var.orbital_flag.waiting_500 = false

    set_global_i(global_var.instant.orbital, 0)
    main_var.orbital_flag.waiting_11500 = true;
    util.yield(main_var.delay_sec.delay_1 + main_var.delay_sec.delay_2 + main_var.delay_sec.delay_3)
    main_var.orbital_flag.waiting_11500 = false;

    set_global_i(global_var.instant.orbital, 2)
    main_var.orbital_flag.waiting_500 = true
    util.yield(main_var.delay_sec.delay_1)
    main_var.orbital_flag.waiting_500 = false

    set_global_i(global_var.instant.orbital, 0)
    main_var.orbital_flag.waiting_11500 = true;
    util.yield(main_var.delay_sec.delay_1 + main_var.delay_sec.delay_2 + main_var.delay_sec.delay_3)
    main_var.orbital_flag.waiting_11500 = false;
end, function()
    main_var.orbital_flag.waiting_500 = false
    main_var.orbital_flag.waiting_11500 = false;
    main_var.orbital_flag.turn_down = true;

    main_var.loop_flag.is_loop_running = false;
    labels.Watermark_label.loop_wlf.running_name = ""

    do_ezmoney(global_var.ezmoney_hash.tiunk, 0)
end)

menu.toggle_loop(Money_instant, labels.Money_labels.ez680k_menu, {"680kloop"}, labels.Money_labels.ez_desc, function()
    main_var.loop_flag.is_loop_running = true
    labels.Watermark_label.loop_wlf.running_name = labels.Money_labels.ez680k_menu

    price = NETSHOPPING.NET_GAMESERVER_GET_PRICE(global_var.ezmoney_hash.bet, global_var.ezmoney_hash.category, true)
    if main_var.delay_Type == 1 then
        do_ezmoney(global_var.ezmoney_hash.bet, price)
        util.yield(main_var.delay_sec.delay_1)
    elseif main_var.delay_Type == 2 then
        do_ezmoney(global_var.ezmoney_hash.bet, price)
        util.yield(main_var.delay_sec.delay_1)
    else
        do_ezmoney(global_var.ezmoney_hash.bet, price)
    end
end, function()
    main_var.loop_flag.is_loop_running = false;
    labels.Watermark_label.loop_wlf.running_name = ""
    do_ezmoney(global_var.ezmoney_hash.tiunk, 0)
end)

menu.toggle_loop(Money_instant, labels.Money_labels.ez180k_menu, {"180kloop"}, labels.Money_labels.ez_desc, function()
    main_var.loop_flag.is_loop_running = true
    labels.Watermark_label.loop_wlf.running_name = labels.Money_labels.ez180k_menu

    price = NETSHOPPING.NET_GAMESERVER_GET_PRICE(global_var.ezmoney_hash.obj, global_var.ezmoney_hash.category, true)
    if main_var.delay_Type == 1 then
        do_ezmoney(global_var.ezmoney_hash.obj, price)
        util.yield(main_var.delay_sec.delay_1)
    elseif main_var.delay_Type == 2 then
        do_ezmoney(global_var.ezmoney_hash.obj, price)
        util.yield(main_var.delay_sec.delay_1)
    else
        do_ezmoney(global_var.ezmoney_hash.obj, price)
    end
end, function()
    main_var.loop_flag.is_loop_running = false;
    labels.Watermark_label.loop_wlf.running_name = ""
    do_ezmoney(global_var.ezmoney_hash.tiunk, 0)
end)

menu.toggle_loop(Money_instant, labels.Money_labels.ez50k_menu, {"50kloop"}, labels.Money_labels.ez_desc, function()
    main_var.loop_flag.is_loop_running = true
    labels.Watermark_label.loop_wlf.running_name = labels.Money_labels.ez50k_menu

    price = NETSHOPPING.NET_GAMESERVER_GET_PRICE(global_var.ezmoney_hash.tiunk, global_var.ezmoney_hash.category, true)
    if main_var.delay_Type == 1 then
        do_ezmoney(global_var.ezmoney_hash.tiunk, price)
        util.yield(main_var.delay_sec.delay_1)
    elseif main_var.delay_Type == 2 then
        do_ezmoney(global_var.ezmoney_hash.tiunk, price)
        util.yield(main_var.delay_sec.delay_1)
    else
        do_ezmoney(global_var.ezmoney_hash.tiunk, price)
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

delay_2_selection = menu.slider(Delay, labels.Setting_labels.delay_custom_select_2, {"selectdelay2"}, labels.Setting_labels.delay_custom_select_2_desc, 0, 10000000, 1000, 100, function()
    --util.toast("New Delay 2: " ..main_var.delay_sec.delay_2)
    main_var.delay_sec.delay_2 = menu.get_value(delay_2_selection)
end)

delay_3_selection = menu.slider(Delay, labels.Setting_labels.delay_custom_select_3, {"selectdelay3"}, labels.Setting_labels.delay_custom_select_3_desc, 0, 100000000, 10000, 500, function()
    --util.toast("New Delay 3: " ..main_var.delay_sec.delay_3)
    main_var.delay_sec.delay_3 = menu.get_value(delay_3_selection)
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
    end
end)

