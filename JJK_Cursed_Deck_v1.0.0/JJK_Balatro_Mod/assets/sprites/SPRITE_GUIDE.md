# JJK Mod — Sprite Atlas Guide

All sprites use 1x and 2x versions. Place files in:
- `assets/sprites/` (used as-is by Steamodded)

## jjk_jokers.png  (710×380 total — 10 cols × 4 rows of 71×95)

Row 0 (y=0):
  [0,0] Gojo — Six Eyes
  [1,0] Sukuna — King of Curses
  [2,0] Yuta — Rika's Curse
  [3,0] Kenjaku — Brain Parasite
  [4,0] Megumi — Ten Shadows
  [5,0] Toji — Heavenly Restriction
  [6,0] Geto — Spirit Manipulation
  [7,0] Mahito — Transfiguration
  [8,0] Uraume — Reversed CT
  [9,0] Nobara — Straw Doll

Row 1 (y=95):
  [0,1] Nanami — 7:3 Ratio
  [1,1] Nanami — Overtime
  [2,1] Aoi Todo — Boogie Woogie
  [3,1] Jogo — Disaster Flames
  [4,1] Hanami — Flower Domain
  [5,1] Choso — Death Painting
  [6,1] Yuji — Divergent Fist
  [7,1] Naoya — Projection
  [8,1] Kashimo — Electric Tool
  [9,1] (reserved)

## jjk_decks.png  (355×95 total — 5 cols × 1 row of 71×95)
  [0,0] Tokyo Jujutsu High
  [1,0] Sorcerer's Path
  [2,0] Cursed Spirit Deck
  [3,0] Hollow Purple
  [4,0] Malevolent Shrine

## jjk_packs.png  (284×95 — 4 cols × 1 row of 71×95)
  [0,0] Cursed Technique Pack
  [1,0] Grade 1 Sorcerer Pack
  [2,0] Domain Expansion Pack
  [3,0] Binding Vow Pack

## jjk_bosses.png  (1716×360 — 6 cols × 2 rows of 286×180)
  [0,0] Malevolent Shrine
  [1,0] Infinity — Limitless
  [2,0] Idle Transfiguration
  [3,0] Toji's Contract
  [4,0] Maximum: Uzumaki
  [5,0] The Culling Game

## jjk_cards.png  (284×285 — 4 cols × 3 rows of 71×95)
Row 0: normal suit overlays (unused — use default)
Row 1: (unused)
Row 2: (unused)
Row 3: (unused)
Row 4 (y=380):
  [0,4] Cursed Spirit suit low-contrast
  [1,4] Cursed Spirit suit high-contrast
  [2,4] Sorcerer suit low-contrast
  [3,4] Sorcerer suit high-contrast
Row 5 (y=475):
  [0,5] Cursed enhancement
  [1,5] Reversed enhancement
  [2,5] Domain enhancement
  [3,5] Black Flash seal

## Color Palette Suggestions

- Cursed Spirit suit: purple #6b21a8 / dark #3b0764
- Sorcerer suit: blue #1d4ed8 / dark #1e3a8a
- Domain enhancement: gold #ca8a04 on black
- Reversed enhancement: white/teal on dark blue
- Cursed enhancement: purple gradient

## Animation Notes (for Aseprite)
For animated jokers (Gojo, Sukuna, Mahoraga), export as a sprite sheet:
- 8 frames per animation cycle
- Each frame: 71×95px
- Pack horizontally into the same atlas row (max 8 frames = 568px wide)
- Steamodded supports frame-based animation via `animation` config key
