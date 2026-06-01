-- JJK CONFIG TAB — Give All + Collection list

local JOKERS = {
    { key="j_jjk_six_eyes",            name="Gojo — Six Eyes",             rarity="Legendary" },
    { key="j_jjk_sukuna",              name="Sukuna — King of Curses",     rarity="Legendary" },
    { key="j_jjk_rika",                name="Yuta — Rika's Curse",         rarity="Legendary" },
    { key="j_jjk_brain_parasite",      name="Kenjaku — Brain Parasite",    rarity="Legendary" },
    { key="j_jjk_ten_shadows",         name="Megumi — Ten Shadows",        rarity="Rare"      },
    { key="j_jjk_heavenly_restriction",name="Toji — Heavenly Restriction", rarity="Rare"      },
    { key="j_jjk_spirit_manipulation", name="Geto — Spirit Manipulation",  rarity="Rare"      },
    { key="j_jjk_transfiguration",     name="Mahito — Transfiguration",    rarity="Rare"      },
    { key="j_jjk_reversed_ct",         name="Uraume — Reversed CT",        rarity="Rare"      },
    { key="j_jjk_ratio",               name="Nanami — 7:3 Ratio",          rarity="Uncommon"  },
    { key="j_jjk_overtime",            name="Nanami — Overtime",           rarity="Uncommon"  },
    { key="j_jjk_straw_doll",          name="Nobara — Straw Doll",         rarity="Uncommon"  },
    { key="j_jjk_boogie_woogie",       name="Todo — Boogie Woogie",        rarity="Uncommon"  },
    { key="j_jjk_disaster_flames",     name="Jogo — Disaster Flames",      rarity="Uncommon"  },
    { key="j_jjk_flower_domain",       name="Hanami — Flower Domain",      rarity="Uncommon"  },
    { key="j_jjk_death_painting",      name="Choso — Death Painting",      rarity="Uncommon"  },
    { key="j_jjk_divergent_fist",      name="Yuji — Divergent Fist",       rarity="Common"    },
    { key="j_jjk_projection",          name="Naoya — Projection",          rarity="Uncommon"  },
    { key="j_jjk_electric_tool",       name="Kashimo — Electric Tool",     rarity="Uncommon"  },
    { key="j_jjk_zenin_tools",         name="Maki — Anti-Gravity Tools",   rarity="Uncommon"  },
}

local DECKS = {
    "Tokyo Jujutsu High", "Sorcerer's Path",
    "Cursed Spirit Deck", "Hollow Purple", "Malevolent Shrine",
}

local RCOL = {
    Legendary = HEX("ca8a04"), Rare = HEX("c2410c"),
    Uncommon  = HEX("0e7490"), Common = HEX("6b7280"),
}

local function give_joker(key)
    if not (G.GAME and G.GAME.round_resets) then return end
    if #G.jokers.cards >= (G.GAME.joker_buffer or 0) + (G.GAME.joker_limit or 5) then
        return
    end
    local c = create_card(nil, G.jokers, nil, nil, nil, nil, key, "jjk")
    if c then
        c:add_to_deck()
        G.jokers:emplace(c)
        c:start_materialize()
    end
end

-- Register G.FUNCS
G.FUNCS.jjk_give_all = function(e)
    if not (G.GAME and G.GAME.round_resets) then return end
    for _, j in ipairs(JOKERS) do give_joker(j.key) end
    ease_dollars(999)
    attention_text({ text="ALL JJK ITEMS!", scale=1.4, hold=2.5,
        colour=HEX("ca8a04"), backdrop_colour=HEX("0f0a1e"), offset={x=0,y=-2.7} })
end

for i, j in ipairs(JOKERS) do
    local k = j.key
    G.FUNCS["jjk_get_"..i] = function(e) give_joker(k) end
end

-- Build the tab
function load_config_tab()
    local in_run = G.GAME and G.GAME.round_resets ~= nil
    local nodes = {}

    -- Title
    nodes[#nodes+1] = { n=G.UIT.R,
        config={ align="cm", padding=0.06, colour={0.1,0.03,0.25,1}, r=0.06 },
        nodes={{ n=G.UIT.T, config={ text="JJK: Cursed Deck — Collection",
            scale=0.38, colour=HEX("ca8a04"), shadow=true } }}
    }

    -- CE status
    nodes[#nodes+1] = { n=G.UIT.R, config={ align="cm", padding=0.03 },
        nodes={{ n=G.UIT.T, config={ scale=0.24, colour=HEX("c4b5fd"),
            text=("CE: %d/%d  |  Fingers: %d/20"):format(
                JJK.state.cursed_energy, JJK.CE_CAP, JJK.state.sukuna_fingers) } }}
    }

    -- Give All button
    if in_run then
        nodes[#nodes+1] = { n=G.UIT.R, config={ align="cm", padding=0.06 },
            nodes={{ n=G.UIT.O, config={ object=Moveable(), button="jjk_give_all",
                hover=true, colour=HEX("7c1d1d"), r=0.06, padding=0.07, shadow=true },
                nodes={{ n=G.UIT.T, config={ text="  Give All JJK Jokers + $999  ",
                    scale=0.32, colour=HEX("fecaca"), shadow=true } }}
            }}
        }
    else
        nodes[#nodes+1] = { n=G.UIT.R, config={ align="cm", padding=0.04 },
            nodes={{ n=G.UIT.T, config={ text="Start a run to use Give All",
                scale=0.26, colour=HEX("6b7280") } }}
        }
    end

    -- Divider
    nodes[#nodes+1] = { n=G.UIT.R, config={ align="cm", padding=0.02 },
        nodes={{ n=G.UIT.T, config={ text="─────────────────────────────",
            scale=0.25, colour=HEX("4c1d95") } }}
    }

    -- Column headers
    nodes[#nodes+1] = { n=G.UIT.R,
        config={ align="cl", padding=0.03, colour={0.1,0.04,0.26,0.9} },
        nodes={
            { n=G.UIT.C, config={align="cl",minw=2.8}, nodes={{n=G.UIT.T,
                config={text="Joker",scale=0.23,colour=HEX("9ca3af")}}} },
            { n=G.UIT.C, config={align="cm",minw=0.85}, nodes={{n=G.UIT.T,
                config={text="Rarity",scale=0.23,colour=HEX("9ca3af")}}} },
            in_run and
            { n=G.UIT.C, config={align="cr",minw=0.65}, nodes={{n=G.UIT.T,
                config={text="Give",scale=0.23,colour=HEX("9ca3af")}}} }
            or { n=G.UIT.C, config={minw=0.65}, nodes={} },
        }
    }

    -- Joker rows
    for i, j in ipairs(JOKERS) do
        local bg = (i%2==0) and {0.11,0.05,0.20,0.5} or {0.07,0.02,0.13,0.5}
        local row = {
            { n=G.UIT.C, config={align="cl",minw=2.8,padding=0.025}, nodes={{n=G.UIT.T,
                config={text=j.name, scale=0.25, colour=HEX("e9d5ff")}}} },
            { n=G.UIT.C, config={align="cm",minw=0.85,padding=0.025}, nodes={{n=G.UIT.T,
                config={text=j.rarity, scale=0.20, colour=RCOL[j.rarity] or G.C.WHITE}}} },
        }
        if in_run then
            row[#row+1] = { n=G.UIT.C, config={align="cr",minw=0.65,padding=0.025},
                nodes={{ n=G.UIT.O, config={ object=Moveable(),
                    button="jjk_get_"..i, hover=true,
                    colour=HEX("1e3a8a"), r=0.04, padding=0.04 },
                    nodes={{n=G.UIT.T, config={text="Get",scale=0.21,colour=HEX("bfdbfe")}}}
                }}
            }
        end
        nodes[#nodes+1] = { n=G.UIT.R, config={align="cl",padding=0.025,colour=bg},
            nodes=row }
    end

    -- Decks header
    nodes[#nodes+1] = { n=G.UIT.R, config={align="cm",padding=0.04},
        nodes={{n=G.UIT.T, config={text="── Decks ──", scale=0.28,
            colour=HEX("ca8a04"), shadow=true}}}
    }
    for i, name in ipairs(DECKS) do
        local bg = (i%2==0) and {0.11,0.05,0.20,0.5} or {0.07,0.02,0.13,0.5}
        nodes[#nodes+1] = { n=G.UIT.R, config={align="cl",padding=0.03,colour=bg},
            nodes={{ n=G.UIT.C, config={align="cl",minw=4,padding=0.03},
                nodes={{n=G.UIT.T, config={text=name,scale=0.26,colour=HEX("e9d5ff")}}}}}
        }
    end

    return {
        n=G.UIT.ROOT,
        config={ align="tm", colour={0.06,0.02,0.14,0.98},
                 padding=0.08, r=0.08, minw=5.2 },
        nodes=nodes,
    }
end

-- Wire into SMODS.current_mod
SMODS.current_mod.config_tab = function()
    return load_config_tab()
end

print("[JJK] Config tab registered.")
