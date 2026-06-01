
--------------------------------------------------------------
JJK = {}
JJK.CE_CAP = 100
JJK.state = { cursed_energy = 0, sukuna_fingers = 0, reversal_used = false }

function JJK.add_ce(n)
    JJK.state.cursed_energy = JJK.state.cursed_energy + (n or 0)
    if JJK.state.cursed_energy >= JJK.CE_CAP then
        JJK.state.cursed_energy = 0
        G.E_MANAGER:add_event(Event({ func = function()
            attention_text({ text = "DOMAIN EXPANSION!", scale = 1.4, hold = 2,
                colour = HEX("ca8a04"), backdrop_colour = HEX("0f0a1e"),
                offset = { x = 0, y = -2.7 } })
            G.GAME.chips = G.GAME.chips + 500
            G.GAME.mult  = G.GAME.mult  * 3
            return true
        end }))
    end
end

-- Atlases
SMODS.Atlas({ key = "jjk_jokers", path = "assets/sprites/jjk_jokers.png", px = 71, py = 95 })
SMODS.Atlas({ key = "jjk_packs",  path = "assets/sprites/jjk_packs.png",  px = 71, py = 95 })
SMODS.Atlas({ key = "jjk_decks",  path = "assets/sprites/jjk_decks.png",  px = 71, py = 95 })
SMODS.Atlas({ key = "jjk_bosses", path = "assets/sprites/jjk_bosses.png", px = 286, py = 180 })

-- Load modules
local function load(name)
    local path = SMODS.current_mod.path .. name .. ".lua"
    local ok, err = pcall(dofile, path)
    if not ok then sendWarnMessage("[JJK] Error in "..name..": "..tostring(err), "JJKCursedDeck") end
end

load("src/jokers/jokers")
load("src/decks/decks")
load("src/packs/packs")
load("src/bosses/bosses")
load("src/ui/collection_tab")

-- Mod catalog description
SMODS.current_mod.process_loc_text = function()
    G.localization.descriptions.Mod = G.localization.descriptions.Mod or {}
    G.localization.descriptions.Mod["JJKCursedDeck"] = {
        name = "JJK: Cursed Deck",
        text = {
            "{C:attention}Jujutsu Kaisen{} expansion for Balatro.",
            "{C:mult}20{} Jokers  {C:chips}5{} Decks  {C:gold}4{} Packs  {C:red}6{} Bosses",
            "New: {C:purple}Cursed Energy{} — fill to 100 → {C:gold}Domain Expansion{}!",
            "{s:0.8}{C:gold}Legendary:{} Gojo · Sukuna · Yuta · Kenjaku",
            "{s:0.8}Config tab: view collection + give all items.",
        },
    }
end

SMODS.current_mod.config_tab = function()
    return load_config_tab and load_config_tab() or {
        n = G.UIT.ROOT, config = { align = "cm", colour = G.C.BLACK },
        nodes = {{ n = G.UIT.T, config = { text = "Loading...", scale = 0.4, colour = G.C.WHITE } }}
    }
end

print("[JJK] Loaded!")
