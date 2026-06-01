# JJK: Cursed Deck — Balatro Mod v1.0.0

A full Jujutsu Kaisen expansion for Balatro. Requires **Steamodded 1.0+**.

---

## 📦 Installation

1. Make sure **Steamodded** is installed (get it at [Steamodded GitHub](https://github.com/Steamopollys/Steamodded))
2. Copy the `JJK_Balatro_Mod/` folder into your Balatro mods directory:
   - **Windows:** `%AppData%\Balatro\Mods\`
   - **Mac:** `~/Library/Application Support/Balatro/Mods/`
   - **Linux:** `~/.local/share/Balatro/Mods/`
3. Launch Balatro — JJK mod will appear in the Mods menu

> **Note:** The sprite PNG files in `assets/sprites/` are placeholder references.
> Replace them with actual pixel art (71×95px per frame for jokers/packs/decks,
> 286×180px per frame for bosses). See `assets/sprites/SPRITE_GUIDE.md` for layout.

---

## 🃏 Content Overview

### New Jokers (20 total)

| Joker | Rarity | Cost | Key Mechanic |
|-------|--------|------|--------------|
| Gojo — Six Eyes | Legendary | $10 | +4 Mult per hand played this round; reveals Boss scores; +10% Black Flash |
| Sukuna — King of Curses | Legendary | $20 | Collect 20 Fingers → Malevolent Shrine (x10 Mult) |
| Yuta — Rika's Curse | Legendary | $14 | Copies last JJK joker effect (x1.5 if cursed type) |
| Kenjaku — Brain Parasite | Legendary | $15 | Steals sold joker effects (up to 3) |
| Megumi — Ten Shadows | Rare | $9 | Summon Shadows per hand type; 10 Shadows → Mahoraga (x3 Mult) |
| Toji — Heavenly Restriction | Rare | $9 | Disables CE; +150 Chips +8 Mult flat |
| Geto — Spirit Manipulation | Rare | $9 | Mult/Chips scale with Joker count |
| Mahito — Transfiguration | Rare | $8 | Transfigures cards each round; destroys 1 after 3 rounds |
| Uraume — Reversed CT | Rare | $8 | Once per ante: flip debuffs to +Mult |
| Nanami — Overtime | Uncommon | $6 | x2 Mult if 0 discards left; +$5 per round |
| Nanami — 7:3 Ratio | Uncommon | $6 | +5 Mult if exactly 7 scoring cards; 3-discard = +$3 |
| Nobara — Straw Doll | Uncommon | $7 | Odd-rank = Nails (+2 Mult each); suits cross-count |
| Aoi Todo — Boogie Woogie | Uncommon | $5 | Swaps 2 hand cards every 2 hands |
| Jogo — Disaster Flames | Uncommon | $7 | Diamonds: +80 Chips, +15 CE each |
| Hanami — Flower Domain | Uncommon | $6 | +2 Mult per unique rank in Clubs/Spades; retrigger 1 |
| Choso — Death Painting | Uncommon | $7 | +1 Mult +10 Chips per destroyed card (permanent) |
| Yuji — Divergent Fist | Common | $5 | +1 Mult per scoring card; 5+ cards = auto Black Flash |
| Naoya — Projection | Uncommon | $6 | First hand x3 Mult; subsequent x0.5 |
| Kashimo — Electric Tool | Uncommon | $7 | Ace chains: +100 Chips to Ace + next card |
| Naoya — Projection Sorcery | Uncommon | $6 | Speed bonuses based on hand order |

---

### New Suits (2)

| Suit | Symbol | Bonus |
|------|--------|-------|
| Cursed Spirit | 👁 | +1 Mult per Joker in deck |
| Sorcerer | ⚡ | Counts as 2 cards for chip scoring |

---

### New Card Enhancements (3)

| Enhancement | Effect |
|-------------|--------|
| **Cursed** | +10 Cursed Energy when scored; Chips x2 |
| **Reversed** | Negates debuffs; flips -Mult to +Mult |
| **Domain** | Guaranteed x1.5 Mult; 25% Domain Expansion trigger |

### New Seal (1)

| Seal | Effect |
|------|--------|
| **Black Flash** | 15% chance: Chips x4 on score |

---

### Custom Decks (5)

| Deck | Key Feature |
|------|-------------|
| Tokyo Jujutsu High | +1 Hand size; JJK joker always in shop |
| Sorcerer's Path | CE cap 50; Domain gives x5 Mult |
| Cursed Spirit Deck | All cards are Cursed Spirit/Sorcerer suit |
| Hollow Purple | -4 cards; all chips x2; +25% Black Flash |
| Malevolent Shrine | Start with 1 Finger; -1 Hand |

---

### Booster Packs (4)

| Pack | Contents | Cost |
|------|----------|------|
| Cursed Technique Pack | 3 JJK jokers, pick 1 | $5 |
| Grade 1 Sorcerer Pack | 5 enhanced cards, pick 1 | $4 |
| Domain Expansion Pack | 2 Legendary JJK jokers, pick 1 | $12 |
| Binding Vow Pack | High-value joker + drawback joker | Free |

---

### Boss Blinds (6)

| Boss | Mechanic | Ante |
|------|----------|------|
| Malevolent Shrine | Destroys lowest-chip card every 3 hands | 4+ |
| Infinity | Cards below rank 7 give 0 chips | 3+ |
| Idle Transfiguration | One Stone card (0 chips) per hand | 5+ |
| Toji's Contract | All Jokers disabled this blind | 6+ |
| Maximum: Uzumaki | Jokers lose 1 Mult per hand played | 5+ |
| The Culling Game | Required chips double every 2 hands | 7+ |

---

## 🔧 Cursed Energy System

A new meter visible in the HUD (top-right).

- Accumulates from **Cursed-enhanced cards**, **Jogo's joker**, **Domain-enhanced cards**, and more
- When it reaches **100**, **Domain Expansion** triggers:
  - `+500 Chips` immediately
  - Current `Mult x3` for that hand
  - Resets the meter to 0
- **Toji's Heavenly Restriction** disables the CE system entirely
- **Sorcerer's Path** deck reduces the cap to 50

---

## 🎨 Sprite Guide

See `assets/sprites/SPRITE_GUIDE.md` for the full atlas layout.
Each joker needs a **71×95px** sprite in the `jjk_jokers.png` atlas (10 per row).

Suggested tools: **Aseprite**, **Libresprite**, or **Piskel** (browser-based).

---

## 🐛 Known Issues / TODO

- [ ] Boss blind entry animations (placeholder sounds used)
- [ ] Binding Vow Pack drawback joker is currently a stand-in (`j_mr_bones`)
- [ ] Sprite PNGs need real pixel art
- [ ] Mahoraga visual summon animation
- [ ] Sound effects (add `jjk_domain.ogg`, `jjk_black_flash.ogg`, `jjk_clap.ogg` to `assets/sounds/`)
- [ ] Achievement unlock hooks

---

## 📜 License

Fan mod. JJK characters/names © Gege Akutami / Shueisha.
Balatro © LocalThunk. Mod code free to use and fork.
