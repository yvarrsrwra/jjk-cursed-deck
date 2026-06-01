-- ============================================================
-- JJK MOD — BOSS BLINDS
-- ============================================================

SMODS.Blind({
    key = "sukuna_domain",
    loc_txt = {
        name = "Malevolent Shrine",
        text = {
            "Every {C:attention}3 hands{}: destroys the",
            "{C:red}lowest-chip card{} in your deck.",
        },
    },
    config = { mult = 2 },
    boss = { showdown = true },
    atlas = "jjk_bosses", pos = { x=0, y=0 },
    in_pool = function(self) return G.GAME.round_resets.ante >= 4 end,
    debuff_hand = function(self, hand, areas, before)
        if not before then return end
        if (G.GAME.current_round.hands_played or 0) % 3 == 0
          and G.GAME.current_round.hands_played > 0 then
            local lowest, lowest_val = nil, math.huge
            for _, c in ipairs(G.deck.cards) do
                local v = c.base and c.base.nominal or 0
                if v < lowest_val then lowest_val = v; lowest = c end
            end
            if lowest then
                G.E_MANAGER:add_event(Event({ func = function()
                    lowest:start_dissolve({ HEX("ff0000") }, true)
                    return true
                end }))
            end
        end
    end,
})

SMODS.Blind({
    key = "jjk_infinity",
    loc_txt = {
        name = "Infinity — Limitless",
        text = {
            "Cards ranked {C:attention}6 or lower{} give {C:red}0 Chips{}.",
            "{C:attention}Aces{} bypass Infinity.",
        },
    },
    config = { mult = 2 },
    boss = true,
    atlas = "jjk_bosses", pos = { x=1, y=0 },
    in_pool = function(self) return G.GAME.round_resets.ante >= 3 end,
    debuff_hand = function(self, hand, areas, before)
        if before then return end
        for _, c in ipairs(hand) do
            if c.base and c.base.id <= 6 and c.base.id ~= 14 then
                c:set_debuff(true)
            end
        end
    end,
    press_play = function(self)
        for _, c in ipairs(G.play.cards) do c:set_debuff(false) end
    end,
})

SMODS.Blind({
    key = "jjk_transfig",
    loc_txt = {
        name = "Idle Transfiguration",
        text = {
            "Start of each hand: one random card",
            "becomes {C:red}Stone{} (0 chips, debuffed).",
        },
    },
    config = { mult = 2 },
    boss = true,
    atlas = "jjk_bosses", pos = { x=2, y=0 },
    in_pool = function(self) return G.GAME.round_resets.ante >= 5 end,
    debuff_hand = function(self, hand, areas, before)
        if not before then return end
        if #G.hand.cards > 0 then
            local t = G.hand.cards[math.random(#G.hand.cards)]
            t.jjk_stoned = true
            t:set_debuff(true)
        end
    end,
    press_play = function(self)
        for _, c in ipairs(G.hand.cards) do
            if c.jjk_stoned then
                c.jjk_stoned = nil
                c:set_debuff(false)
            end
        end
    end,
})

SMODS.Blind({
    key = "jjk_zero_energy",
    loc_txt = {
        name = "Toji's Contract",
        text = {
            "{C:red}All Jokers disabled{} this blind.",
            "Score using cards alone.",
        },
    },
    config = { mult = 3 },
    boss = true,
    atlas = "jjk_bosses", pos = { x=3, y=0 },
    in_pool = function(self) return G.GAME.round_resets.ante >= 6 end,
    set_blind = function(self)
        for _, j in ipairs(G.jokers.cards) do j:set_debuff(true) end
    end,
    defeat = function(self)
        for _, j in ipairs(G.jokers.cards) do j:set_debuff(false) end
    end,
    skip = function(self)
        for _, j in ipairs(G.jokers.cards) do j:set_debuff(false) end
    end,
})

SMODS.Blind({
    key = "jjk_uzumaki",
    loc_txt = {
        name = "Maximum: Uzumaki",
        text = {
            "Each hand played: one random Joker",
            "loses {C:red}-1 Mult{}. At 0: {C:red}destroyed{}.",
        },
    },
    config = { mult = 2.5 },
    boss = true,
    atlas = "jjk_bosses", pos = { x=4, y=0 },
    in_pool = function(self) return G.GAME.round_resets.ante >= 5 end,
    debuff_hand = function(self, hand, areas, before)
        if not before then return end
        if #G.jokers.cards > 0 then
            local j = G.jokers.cards[math.random(#G.jokers.cards)]
            if j.ability then
                j.ability.mult = (j.ability.mult or 1) - 1
                if j.ability.mult <= 0 then
                    j:start_dissolve(nil, true)
                end
            end
        end
    end,
})

SMODS.Blind({
    key = "jjk_culling",
    loc_txt = {
        name = "The Culling Game",
        text = {
            "Required chips {C:red}double{} every 2 hands.",
            "{C:gold}+$10{} bonus on victory.",
        },
    },
    config = { mult = 1 },
    boss = { showdown = true },
    atlas = "jjk_bosses", pos = { x=5, y=0 },
    in_pool = function(self) return G.GAME.round_resets.ante >= 7 end,
    set_blind = function(self)
        self.jjk_hands = 0
    end,
    press_play = function(self)
        self.jjk_hands = (self.jjk_hands or 0) + 1
        if self.jjk_hands % 2 == 0 then
            G.GAME.blind.chips = math.floor(G.GAME.blind.chips * 2)
            attention_text({ text = "CHIPS DOUBLED!", scale = 1.2, hold = 1.5,
                colour = JJK.C.gold, offset = {x=0,y=-2} })
        end
    end,
    defeat = function(self)
        ease_dollars(10)
        card_eval_status_text(G.jokers.cards[1], "extra", nil, nil, nil,
            { message = "+$10", colour = G.C.MONEY })
    end,
})

print("[JJK] Boss blinds registered.")
