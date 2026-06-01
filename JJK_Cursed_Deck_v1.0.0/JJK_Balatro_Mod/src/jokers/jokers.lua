-- JJK JOKERS — all 20, using verified Steamodded 1.0 API
-- context.joker_main = main scoring
-- context.before = before scoring loop
-- context.end_of_round = end of round
-- context.individual + context.cardarea == G.play = per scored card
-- return { mult, chips, xmult, dollars, message, colour }

-- 1. GOJO — Six Eyes
SMODS.Joker({
    key = "six_eyes",
    loc_txt = { name = "Gojo — Six Eyes", text = {
        "{C:mult}+4 Mult{} per hand played this round.",
        "{C:attention}Hands played: #1#{}",
    }},
    config = { extra = { mult_per_hand = 4, hands = 0 } },
    rarity = 4, cost = 10, blueprint_compat = true,
    atlas = "jjk_jokers", pos = { x=1, y=0 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.hands } }
    end,
    calculate = function(self, card, context)
        if context.before then
            card.ability.extra.hands = card.ability.extra.hands + 1
        end
        if context.joker_main then
            return { mult = card.ability.extra.mult_per_hand * card.ability.extra.hands,
                     colour = HEX("1d4ed8") }
        end
        if context.end_of_round then
            card.ability.extra.hands = 0
        end
    end,
})

-- 2. SUKUNA — King of Curses
SMODS.Joker({
    key = "sukuna",
    loc_txt = { name = "Sukuna — King of Curses", text = {
        "Gains a {C:attention}Finger{} each round.",
        "Every 4: {C:mult}xMult +0.5{}. At 20: {C:gold}x10{}!",
        "{C:red}Fingers: #1# / 20{}",
    }},
    config = { extra = { fingers = 0 } },
    rarity = 4, cost = 20, blueprint_compat = false,
    atlas = "jjk_jokers", pos = { x=0, y=0 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.fingers } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round then
            if card.ability.extra.fingers < 20 then
                card.ability.extra.fingers = card.ability.extra.fingers + 1
                return { message = "Finger! ("..card.ability.extra.fingers..")",
                         colour = HEX("991b1b") }
            end
        end
        if context.joker_main then
            local f = card.ability.extra.fingers
            if f >= 20 then
                JJK.add_ce(100)
                return { x_mult = 10, colour = HEX("991b1b") }
            elseif f >= 4 then
                return { x_mult = 1 + math.floor(f/4) * 0.5, colour = HEX("991b1b") }
            end
        end
    end,
})

-- 3. MEGUMI — Ten Shadows
SMODS.Joker({
    key = "ten_shadows",
    loc_txt = { name = "Megumi — Ten Shadows", text = {
        "Gain a {C:attention}Shadow{} per unique hand type played.",
        "Each Shadow: {C:chips}+30 Chips{}.",
        "10 Shadows: {C:gold}Mahoraga — x3 Mult{}.",
        "{C:attention}Shadows: #1# / 10{}",
    }},
    config = { extra = { shadows = 0, seen = {}, mahoraga = false } },
    rarity = 3, cost = 9, blueprint_compat = true,
    atlas = "jjk_jokers", pos = { x=3, y=0 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.shadows } }
    end,
    calculate = function(self, card, context)
        if context.before and context.poker_hands then
            for hand_name, cards in pairs(context.poker_hands) do
                if next(cards) and not card.ability.extra.seen[hand_name] then
                    card.ability.extra.seen[hand_name] = true
                    card.ability.extra.shadows = math.min(card.ability.extra.shadows + 1, 10)
                    if card.ability.extra.shadows >= 10 and not card.ability.extra.mahoraga then
                        card.ability.extra.mahoraga = true
                        attention_text({ text="MAHORAGA!", scale=1.3, hold=2,
                            colour=HEX("f5f3ff"), backdrop_colour=HEX("0f0a1e"), offset={x=0,y=-2.7} })
                    end
                    return { message = "Shadow! ("..card.ability.extra.shadows..")",
                             colour = HEX("f5f3ff") }
                end
            end
        end
        if context.joker_main then
            local c = card.ability.extra.shadows * 30
            if card.ability.extra.mahoraga then
                return { chips = c, x_mult = 3, colour = HEX("f5f3ff") }
            elseif c > 0 then
                return { chips = c, colour = HEX("f5f3ff") }
            end
        end
    end,
})

-- 4. NOBARA — Straw Doll
SMODS.Joker({
    key = "straw_doll",
    loc_txt = { name = "Nobara — Straw Doll", text = {
        "{C:mult}+2 Mult{} per odd-ranked card in hand.",
    }},
    config = { extra = { mult_per_nail = 2 } },
    rarity = 2, cost = 7, blueprint_compat = true,
    atlas = "jjk_jokers", pos = { x=0, y=1 },
    calculate = function(self, card, context)
        if context.joker_main then
            local nails = 0
            for _, c in ipairs(G.hand.cards) do
                if c.base and c.base.id % 2 == 1 then nails = nails + 1 end
            end
            if nails > 0 then
                return { mult = nails * card.ability.extra.mult_per_nail,
                         colour = HEX("991b1b") }
            end
        end
    end,
})

-- 5. NANAMI — 7:3 Ratio
SMODS.Joker({
    key = "ratio",
    loc_txt = { name = "Nanami — 7:3 Ratio", text = {
        "Exactly {C:attention}7 scoring cards{}: {C:mult}+5 Mult{}.",
        "Discard exactly {C:attention}3 cards{}: {C:gold}+$3{}.",
    }},
    config = { extra = { mult = 5 } },
    rarity = 2, cost = 6, blueprint_compat = true,
    atlas = "jjk_jokers", pos = { x=1, y=1 },
    calculate = function(self, card, context)
        if context.joker_main and context.scoring_hand
          and #context.scoring_hand == 7 then
            return { mult = card.ability.extra.mult, colour = HEX("92400e") }
        end
        if context.discard and #context.full_hand == 3 then
            ease_dollars(3)
            return { message = "+$3", colour = G.C.MONEY }
        end
    end,
})

-- 6. TOJI — Heavenly Restriction
SMODS.Joker({
    key = "heavenly_restriction",
    loc_txt = { name = "Toji — Heavenly Restriction", text = {
        "No Cursed Energy. Pure physical power.",
        "{C:chips}+150 Chips{} and {C:mult}+8 Mult{} per hand.",
    }},
    config = { extra = { chips = 150, mult = 8 } },
    rarity = 3, cost = 9, blueprint_compat = true,
    atlas = "jjk_jokers", pos = { x=6, y=0 },
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then JJK.CE_CAP = 999999 end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if not from_debuff then JJK.CE_CAP = 100 end
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return { chips = card.ability.extra.chips, mult = card.ability.extra.mult,
                     colour = HEX("374151") }
        end
    end,
})

-- 7. YUTA — Rika's Curse
SMODS.Joker({
    key = "rika",
    loc_txt = { name = "Yuta — Rika's Curse", text = {
        "{C:mult}x1.5 Mult{} for each other JJK Joker owned.",
        "{C:attention}JJK Jokers: #1#{}",
    }},
    config = {},
    rarity = 4, cost = 14, blueprint_compat = true,
    atlas = "jjk_jokers", pos = { x=5, y=0 },
    loc_vars = function(self, info_queue, card)
        local n = 0
        for _, j in ipairs(G.jokers.cards) do
            if j ~= card and j.config.center.key and j.config.center.key:find("jjk") then
                n = n + 1
            end
        end
        return { vars = { n } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local n = 0
            for _, j in ipairs(G.jokers.cards) do
                if j ~= card and j.config.center.key and j.config.center.key:find("jjk") then
                    n = n + 1
                end
            end
            if n > 0 then
                return { x_mult = 1 + n * 0.5, colour = HEX("ec4899") }
            end
        end
    end,
})

-- 8. TODO — Boogie Woogie
SMODS.Joker({
    key = "boogie_woogie",
    loc_txt = { name = "Todo — Boogie Woogie", text = {
        "Every {C:attention}2 hands{}: swap 2 random hand cards.",
        "{C:mult}+3 Mult{}.",
    }},
    config = { extra = { mult = 3, count = 0 } },
    rarity = 2, cost = 5, blueprint_compat = true,
    atlas = "jjk_jokers", pos = { x=2, y=1 },
    calculate = function(self, card, context)
        if context.before then
            card.ability.extra.count = card.ability.extra.count + 1
            if card.ability.extra.count % 2 == 0 and #G.hand.cards >= 2 then
                local i1 = math.random(#G.hand.cards)
                local i2 = i1
                while i2 == i1 do i2 = math.random(#G.hand.cards) end
                G.hand.cards[i1], G.hand.cards[i2] = G.hand.cards[i2], G.hand.cards[i1]
                return { message = "Boogie Woogie!", colour = HEX("f59e0b") }
            end
        end
        if context.joker_main then
            return { mult = card.ability.extra.mult, colour = HEX("f59e0b") }
        end
    end,
})

-- 9. MAHITO — Transfiguration
SMODS.Joker({
    key = "transfiguration",
    loc_txt = { name = "Mahito — Transfiguration", text = {
        "End of round: transfigure 1 hand card.",
        "{C:mult}+5 Mult{}. Destroys 1 card after 3 rounds.",
        "{C:attention}Rounds: #1# / 3{}",
    }},
    config = { extra = { mult = 5, rounds = 0 } },
    rarity = 3, cost = 8, blueprint_compat = false,
    atlas = "jjk_jokers", pos = { x=2, y=0 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.rounds } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round then
            card.ability.extra.rounds = card.ability.extra.rounds + 1
            local enhancements = { "m_bonus","m_mult","m_wild","m_glass","m_steel" }
            if #G.hand.cards > 0 then
                local target = G.hand.cards[math.random(#G.hand.cards)]
                target:set_ability(G.P_CENTERS[enhancements[math.random(#enhancements)]])
            end
            if card.ability.extra.rounds >= 3 then
                card.ability.extra.rounds = 0
                if #G.hand.cards > 0 then
                    G.hand.cards[math.random(#G.hand.cards)]:start_dissolve(nil, true)
                    return { message = "Transfigured!", colour = HEX("7c3aed") }
                end
            end
            return { message = "Transfigured!", colour = HEX("7c3aed") }
        end
        if context.joker_main then
            return { mult = card.ability.extra.mult, colour = HEX("7c3aed") }
        end
    end,
})

-- 10. GETO — Spirit Manipulation
SMODS.Joker({
    key = "spirit_manipulation",
    loc_txt = { name = "Geto — Spirit Manipulation", text = {
        "{C:mult}+2 Mult{} and {C:chips}+10 Chips{} per Joker owned.",
        "{C:attention}Jokers: #1#{}",
    }},
    config = {},
    rarity = 3, cost = 9, blueprint_compat = true,
    atlas = "jjk_jokers", pos = { x=7, y=0 },
    loc_vars = function(self, info_queue, card)
        return { vars = { #G.jokers.cards } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local n = #G.jokers.cards
            if n > 0 then
                return { mult = n * 2, chips = n * 10, colour = HEX("6b21a8") }
            end
        end
    end,
})

-- 11. JOGO — Disaster Flames
SMODS.Joker({
    key = "disaster_flames",
    loc_txt = { name = "Jogo — Disaster Flames", text = {
        "Scored {C:attention}Diamonds{}: {C:chips}+80 Chips{}",
        "and {C:purple}+15 Cursed Energy{}.",
    }},
    config = { extra = { chips = 80, ce = 15 } },
    rarity = 2, cost = 7, blueprint_compat = true,
    atlas = "jjk_jokers", pos = { x=3, y=1 },
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local c = context.other_card
            if c and c.base and c.base.suit == "Diamonds" then
                JJK.add_ce(card.ability.extra.ce)
                return { chips = card.ability.extra.chips,
                         colour = HEX("ef4444"), card = c }
            end
        end
    end,
})

-- 12. CHOSO — Death Painting
SMODS.Joker({
    key = "death_painting",
    loc_txt = { name = "Choso — Death Painting", text = {
        "Permanently gains {C:mult}+1 Mult{} and {C:chips}+10 Chips{}",
        "when a playing card is destroyed.",
        "{C:attention}Current: +#1# Mult, +#2# Chips{}",
    }},
    config = { extra = { mult = 0, chips = 0 } },
    rarity = 2, cost = 7, blueprint_compat = false,
    atlas = "jjk_jokers", pos = { x=8, y=0 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.remove_playing_cards and context.removed then
            for _ = 1, #context.removed do
                card.ability.extra.mult  = card.ability.extra.mult  + 1
                card.ability.extra.chips = card.ability.extra.chips + 10
            end
            return { message = "Blood Bond!", colour = HEX("991b1b") }
        end
        if context.joker_main and
          (card.ability.extra.mult > 0 or card.ability.extra.chips > 0) then
            return { mult  = card.ability.extra.mult,
                     chips = card.ability.extra.chips,
                     colour = HEX("991b1b") }
        end
    end,
})

-- 13. YUJI — Divergent Fist
SMODS.Joker({
    key = "divergent_fist",
    loc_txt = { name = "Yuji — Divergent Fist", text = {
        "{C:mult}+1 Mult{} per scoring card (max {C:attention}+8{}).",
        "5+ scoring cards: {C:gold}Chips x4{}.",
    }},
    config = { extra = { cap = 8 } },
    rarity = 1, cost = 5, blueprint_compat = true,
    atlas = "jjk_jokers", pos = { x=6, y=1 },
    calculate = function(self, card, context)
        if context.joker_main and context.scoring_hand then
            local n = #context.scoring_hand
            local bonus = math.min(n, card.ability.extra.cap)
            if n >= 5 then
                attention_text({ text="BLACK FLASH!", scale=1.2, hold=1.5,
                    colour=HEX("fbbf24"), offset={x=0,y=-2} })
                return { mult = bonus, x_mult = 4, colour = HEX("f97316") }
            elseif bonus > 0 then
                return { mult = bonus, colour = HEX("f97316") }
            end
        end
    end,
})

-- 14. NANAMI — Overtime
SMODS.Joker({
    key = "overtime",
    loc_txt = { name = "Nanami — Overtime", text = {
        "0 discards remaining: {C:mult}x2 Mult{}.",
        "{C:gold}+$5{} at end of round.",
    }},
    config = { extra = { money = 5 } },
    rarity = 2, cost = 6, blueprint_compat = true,
    atlas = "jjk_jokers", pos = { x=4, y=1 },
    calc_dollar_bonus = function(self, card)
        return card.ability.extra.money
    end,
    calculate = function(self, card, context)
        if context.joker_main
          and G.GAME.current_round.discards_used >= G.GAME.round_resets.discards then
            return { x_mult = 2, colour = HEX("92400e") }
        end
    end,
})

-- 15. URAUME — Reversed CT
SMODS.Joker({
    key = "reversed_ct",
    loc_txt = { name = "Uraume — Reversed CT", text = {
        "Once per ante: debuffed cards give",
        "{C:mult}+3 Mult{} and {C:chips}+20 Chips{} each.",
    }},
    config = {},
    rarity = 3, cost = 8, blueprint_compat = false,
    atlas = "jjk_jokers", pos = { x=9, y=0 },
    calculate = function(self, card, context)
        if context.joker_main and not JJK.state.reversal_used then
            local n = 0
            for _, c in ipairs(G.hand.cards) do
                if c.debuff then n = n + 1 end
            end
            if n > 0 then
                JJK.state.reversal_used = true
                return { mult = n * 3, chips = n * 20, colour = HEX("f5f3ff") }
            end
        end
        if context.new_ante then
            JJK.state.reversal_used = false
        end
    end,
})

-- 16. NAOYA — Projection Sorcery
SMODS.Joker({
    key = "projection",
    loc_txt = { name = "Naoya — Projection", text = {
        "First hand per round: {C:mult}x3 Mult{}.",
        "All other hands: {C:attention}x0.5 Mult{}.",
    }},
    config = { extra = { played = 0 } },
    rarity = 2, cost = 6, blueprint_compat = true,
    atlas = "jjk_jokers", pos = { x=7, y=1 },
    calculate = function(self, card, context)
        if context.before then
            card.ability.extra.played = card.ability.extra.played + 1
        end
        if context.joker_main then
            if card.ability.extra.played <= 1 then
                return { x_mult = 3, colour = HEX("f59e0b") }
            else
                return { x_mult = 0.5, colour = HEX("6b7280") }
            end
        end
        if context.end_of_round then
            card.ability.extra.played = 0
        end
    end,
})

-- 17. KASHIMO — Electric Tool
SMODS.Joker({
    key = "electric_tool",
    loc_txt = { name = "Kashimo — Electric Tool", text = {
        "Scored {C:attention}Aces{}: {C:chips}+100 Chips{}.",
        "Chain: next scored card also gets {C:chips}+100 Chips{}.",
    }},
    config = { extra = { chips = 100, chain = false } },
    rarity = 2, cost = 7, blueprint_compat = true,
    atlas = "jjk_jokers", pos = { x=8, y=1 },
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local c = context.other_card
            if c and c.base then
                if c.base.id == 14 then
                    card.ability.extra.chain = true
                    return { chips = card.ability.extra.chips,
                             colour = HEX("fbbf24"), card = c }
                elseif card.ability.extra.chain then
                    card.ability.extra.chain = false
                    return { chips = card.ability.extra.chips,
                             colour = HEX("fbbf24"), card = c }
                end
            end
        end
        if context.before then card.ability.extra.chain = false end
    end,
})

-- 18. MAKI — Anti-Gravity Tools
SMODS.Joker({
    key = "zenin_tools",
    loc_txt = { name = "Maki — Anti-Gravity Tools", text = {
        "Scored face cards: {C:chips}+50 Chips{} and {C:mult}+3 Mult{}.",
    }},
    config = { extra = { chips = 50, mult = 3 } },
    rarity = 2, cost = 6, blueprint_compat = true,
    atlas = "jjk_jokers", pos = { x=9, y=1 },
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local c = context.other_card
            if c and c:is_face() then
                return { chips = card.ability.extra.chips,
                         mult  = card.ability.extra.mult,
                         colour = HEX("6b7280"), card = c }
            end
        end
    end,
})

-- 19. HANAMI — Flower Domain
SMODS.Joker({
    key = "flower_domain",
    loc_txt = { name = "Hanami — Flower Domain", text = {
        "{C:mult}+2 Mult{} per unique rank in ♣ ♠ scoring hand.",
    }},
    config = { extra = { mult = 2 } },
    rarity = 2, cost = 6, blueprint_compat = true,
    atlas = "jjk_jokers", pos = { x=5, y=1 },
    calculate = function(self, card, context)
        if context.joker_main and context.scoring_hand then
            local ranks = {}
            for _, c in ipairs(context.scoring_hand) do
                if c.base and (c.base.suit == "Clubs" or c.base.suit == "Spades") then
                    ranks[c.base.id] = true
                end
            end
            local n = 0
            for _ in pairs(ranks) do n = n + 1 end
            if n > 0 then
                return { mult = n * card.ability.extra.mult, colour = HEX("16a34a") }
            end
        end
    end,
})

-- 20. KENJAKU — Brain Parasite
SMODS.Joker({
    key = "brain_parasite",
    loc_txt = { name = "Kenjaku — Brain Parasite", text = {
        "Sold Joker: steal its power.",
        "{C:mult}+5 Mult{} & {C:chips}+30 Chips{} per stolen (max 3).",
        "{C:attention}Stolen: #1# / 3{}",
    }},
    config = { extra = { stolen = 0, mult = 0, chips = 0 } },
    rarity = 4, cost = 15, blueprint_compat = false,
    atlas = "jjk_jokers", pos = { x=4, y=0 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.stolen } }
    end,
    calculate = function(self, card, context)
        if context.selling_card and context.selling_card ~= card
          and card.ability.extra.stolen < 3 then
            card.ability.extra.stolen = card.ability.extra.stolen + 1
            card.ability.extra.mult   = card.ability.extra.mult   + 5
            card.ability.extra.chips  = card.ability.extra.chips  + 30
            return { message = "Stolen!", colour = HEX("6b21a8") }
        end
        if context.joker_main and card.ability.extra.stolen > 0 then
            return { mult  = card.ability.extra.mult,
                     chips = card.ability.extra.chips,
                     colour = HEX("6b21a8") }
        end
    end,
})

print("[JJK] 20 Jokers registered.")
