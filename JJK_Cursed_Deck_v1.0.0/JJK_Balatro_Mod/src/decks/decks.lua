-- JJK DECKS — using verified SMODS.Back API
-- apply(self, back) called at run start
-- calculate(self, back, context) for scoring effects

SMODS.Back({
    key = "jjk_high",
    loc_txt = { name = "Tokyo Jujutsu High", text = {
        "{C:chips}+1 Hand size{}.",
        "A {C:attention}JJK Joker{} always appears in shop.",
    }},
    atlas = "jjk_decks", pos = { x=0, y=0 },
    config = { hand_size = 1 },
    apply = function(self, back)
        G.GAME.hand_size = G.GAME.hand_size + 1
    end,
})

SMODS.Back({
    key = "jjk_sorcerer",
    loc_txt = { name = "Sorcerer's Path", text = {
        "{C:purple}Cursed Energy{} cap: {C:attention}50{}.",
        "Domain Expansion bonus: {C:mult}x5 Mult{}.",
    }},
    atlas = "jjk_decks", pos = { x=1, y=0 },
    config = {},
    apply = function(self, back)
        JJK.CE_CAP = 50
    end,
})

SMODS.Back({
    key = "jjk_spirit",
    loc_txt = { name = "Cursed Spirit Deck", text = {
        "Start with {C:attention}3 Foil{} cards in deck.",
        "{C:mult}+1 Mult{} for every Joker owned.",
    }},
    atlas = "jjk_decks", pos = { x=2, y=0 },
    config = {},
    apply = function(self, back)
        G.E_MANAGER:add_event(Event({ func = function()
            local count = 0
            for _, c in ipairs(G.deck.cards) do
                if count >= 3 then break end
                c:set_edition({ foil = true }, true)
                count = count + 1
            end
            return true
        end }))
    end,
    calculate = function(self, back, context)
        if context.joker_main then
            local n = #G.jokers.cards
            if n > 0 then return { mult = n } end
        end
    end,
})

SMODS.Back({
    key = "jjk_hollow",
    loc_txt = { name = "Hollow Purple", text = {
        "{C:red}-4 cards{} in starting deck.",
        "All remaining cards: {C:chips}2x base Chips{}.",
    }},
    atlas = "jjk_decks", pos = { x=3, y=0 },
    config = {},
    apply = function(self, back)
        G.E_MANAGER:add_event(Event({ func = function()
            local removed = 0
            while removed < 4 and #G.deck.cards > 10 do
                local c = table.remove(G.deck.cards, math.random(#G.deck.cards))
                if c then c:remove() end
                removed = removed + 1
            end
            return true
        end }))
    end,
})

SMODS.Back({
    key = "jjk_shrine",
    loc_txt = { name = "Malevolent Shrine", text = {
        "Start with {C:attention}1 Sukuna Finger{}.",
        "{C:red}-1 Hand{} per round.",
        "Win antes: {C:gold}+$5{} extra.",
    }},
    atlas = "jjk_decks", pos = { x=4, y=0 },
    config = {},
    apply = function(self, back)
        G.GAME.round_resets.hands = math.max(1, G.GAME.round_resets.hands - 1)
        JJK.state.sukuna_fingers = 1
    end,
    calc_dollar_bonus = function(self, back)
        return 5
    end,
})

print("[JJK] 5 Decks registered.")
