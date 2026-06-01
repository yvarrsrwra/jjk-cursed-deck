-- ============================================================
-- JJK MOD — BOOSTER PACKS
-- ============================================================

SMODS.Booster({
    key = "jjk_ct_pack",
    loc_txt = {
        name = "Cursed Technique Pack",
        text = { "Choose {C:attention}1{} of {C:attention}3{} {C:purple}JJK Jokers{}." },
    },
    config = { extra = 3, choose = 1 },
    cost = 5, weight = 0.4, kind = "Joker",
    atlas = "jjk_packs", pos = { x=0, y=0 },
    create_card = function(self, pack, i)
        local keys = {}
        for k, v in pairs(G.P_CENTERS) do
            if k:find("j_jjk_") then table.insert(keys, k) end
        end
        if #keys > 0 then
            return create_card(nil, pack, nil, nil, nil, nil,
                keys[math.random(#keys)], "jjk_ct_pack")
        end
        return create_card("Joker", pack, nil, nil, nil, nil, nil, "jjk_ct_pack")
    end,
})

SMODS.Booster({
    key = "jjk_grade1_pack",
    loc_txt = {
        name = "Grade 1 Sorcerer Pack",
        text = { "Choose {C:attention}1{} of {C:attention}5{} enhanced cards." },
    },
    config = { extra = 5, choose = 1 },
    cost = 4, weight = 0.6, kind = "Standard",
    atlas = "jjk_packs", pos = { x=1, y=0 },
    create_card = function(self, pack, i)
        local c = create_card(nil, pack, nil, nil, nil, nil, nil, "jjk_grade1_pack")
        if c then
            local enhancements = { "m_bonus","m_mult","m_wild","m_glass","m_steel" }
            c:set_ability(G.P_CENTERS[enhancements[math.random(#enhancements)]])
        end
        return c
    end,
})

SMODS.Booster({
    key = "jjk_domain_pack",
    loc_txt = {
        name = "Domain Expansion Pack",
        text = { "{C:gold}Rare:{} Choose {C:attention}1{} of {C:attention}2{} Legendary JJK Jokers." },
    },
    config = { extra = 2, choose = 1 },
    cost = 12, weight = 0.1, kind = "Joker",
    atlas = "jjk_packs", pos = { x=2, y=0 },
    create_card = function(self, pack, i)
        local keys = { "j_jjk_sukuna","j_jjk_six_eyes","j_jjk_rika","j_jjk_brain_parasite" }
        return create_card(nil, pack, nil, nil, nil, nil,
            keys[math.random(#keys)], "jjk_domain_pack")
    end,
})

SMODS.Booster({
    key = "jjk_vow_pack",
    loc_txt = {
        name = "Binding Vow Pack",
        text = {
            "Choose {C:attention}1{} of {C:attention}3{} powerful JJK Jokers.",
            "{C:red}Free{} — but adds a {C:red}negative Joker{}.",
        },
    },
    config = { extra = 3, choose = 1 },
    cost = 0, weight = 0.15, kind = "Joker",
    atlas = "jjk_packs", pos = { x=3, y=0 },
    create_card = function(self, pack, i)
        local keys = { "j_jjk_six_eyes","j_jjk_ten_shadows","j_jjk_spirit_manipulation" }
        local key = keys[math.min(i, #keys)]
        return create_card(nil, pack, nil, nil, nil, nil, key, "jjk_vow_pack")
    end,
})

print("[JJK] Packs registered.")
