# ForeverTankGuide (Modular Registry Edition v1.1.0)

**ForeverTankGuide** is an in-game progression and tanking assistant for the **World of Warcraft: Forever** client. 

Originally created for Horde Forsaken Protection Paladins, this refactored edition features a **fully decoupled, registry-driven modular engine**. It automatically detects the player's active race, tank class, and primary tank profession, while providing an in-game profile switcher allowing players to preview any combination on the fly.

---

## Directory Architecture

```
ForeverTankGuide/
├── ForeverTankGuide.toc          # Load order orchestrator & saved variables
├── Core.lua                      # Lifecycle, event router, level-up alerts, minimap button
├── UI.lua                        # Dynamic UI engine with profile switcher & tabs
├── Engine/
│   ├── Registry.lua              # Module registration API & profile stitcher
│   └── Profile.lua               # Dynamic character auto-detector & override manager
└── Modules/
    ├── Classes/
    │   ├── Paladin.lua           # Holy Strike, Consecration, Holy Shield, Peel macros
    │   ├── Warrior.lua           # Defensive Stance, Shield Block, Sunder, Revenge
    │   ├── Druid.lua             # Dire Bear Form, Maul, Swipe, Faerie Fire
    │   ├── Shaman.lua            # Way of Earth, Rockbiter, Earth Shock interrupts
    │   ├── Rogue.lua             # Blade Dance, Evasion, Ghostly Strike, Riposte
    │   └── Warlock.lua           # Metamorphosis, Searing Pain threat, Soul Link
    ├── Races/
    │   ├── Horde/
    │   │   ├── Undead.lua        # Will of the Forsaken, Cannibalize, Shadow Resist
    │   │   ├── Tauren.lua        # War Stomp (5-mob stun), Endurance (+5% HP)
    │   │   ├── Orc.lua           # Hardiness (25% stun resist), Axe Spec, Blood Fury
    │   │   └── Troll.lua         # Berserking haste, Regeneration, Beast Slaying
    │   └── Alliance/
    │       ├── Human.lua         # Sword/Mace Spec (+5 skill), Perception stealth detect
    │       ├── Dwarf.lua         # Stoneform (Bleed/Poison/Disease immune + 10% armor)
    │       ├── NightElf.lua      # Quickness (+1% dodge), Shadowmeld pulls
    │       └── Gnome.lua         # Escape Artist root break, Engineering Spec (+15 skill)
    ├── Professions/
    │   ├── Engineering.lua       # Bombs, Sappers, Target Dummies, Force Reactive Disk
    │   ├── Blacksmithing.lua     # Shield Spikes (block threat), Sharpening Stones, Plate
    │   ├── Alchemy.lua           # Greater Stoneshield (+2000 Armor), Elixirs, Flasks
    │   └── Leatherworking.lua    # Armor Kits, Feral Bear sets, Devilsaur Threat gear
    └── Dungeons/
        └── Encounters.lua        # Universal dungeon brackets, loot drops, checkable tasks
```

---

## Key Features

1. **Automatic Character Detection & Dynamic Registration:**
   - Detects race, class, and profession using WoW API on login.
   - Any third-party module or custom tank spec can register itself via:
     - `FTG:RegisterClassModule(token, data)`
     - `FTG:RegisterRaceModule(token, data)`
     - `FTG:RegisterProfModule(token, data)`
     - `FTG:RegisterDungeonData(table)`

2. **In-UI Profile Switcher:**
   - Interactive dropdown buttons in the top header let you preview any class, race, or profession (e.g. *Alliance / Dwarf / Warrior / Blacksmithing*) with a single click.
   - Click **"Detect Player"** at any time to return to your character's live build.

3. **Level-Bracket Progression (Phases 1–4):**
   - **Phase 1 (1–20)**: Starting zones, initial survival mechanics, 30yd pulling, RFC/WC/Deadmines.
   - **Phase 2 (20–40)**: Mid-game tank abilities (Consecration, Dire Bear, Stance dancing), SFK, RFK, SM.
   - **Phase 3 (40–52)**: Specializations (Goblin Engineering, Armorsmithing), ZF pyramid, Maraudon.
   - **Phase 4 (52–60)**: Pre-raid BIS gear, 440 defense cap, BRD, Stratholme, Scholomance, UBRS.

4. **Interactive Dungeon & Loot Checklist:**
   - Persistent checkboxes stored per character in `FTG_CharDB.completedTasks`.

5. **Integrated Macro Vault:**
   - Class, race, and profession-specific macros with one-click **"Save to WoW"** (`CreateMacro`) or selectable copy editboxes.

---

## Installation & Commands

1. Move the `ForeverTankGuide` folder to:
   ```
   World of Warcraft\Interface\AddOns\ForeverTankGuide\
   ```
2. In-game commands:
   - `/ftg` or `/tankguide` : Toggle guide window.
   - `/ftg reset` : Re-center window on screen.
   - Click or drag the minimap button to toggle or reposition.
