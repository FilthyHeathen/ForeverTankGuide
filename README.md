# Heathen's Forever Guide (v1.3.0)

**Heathen's Forever Guide** is an all-in-one in-game progression, leveling, dungeon, and profession assistant for **World of Warcraft: Forever** (`Interface: 16001`).

Featuring a **decoupled, registry-driven modular engine**, it automatically detects the player's active **Class**, **Specialization**, **Role** (`[TANK]`, `[HEAL]`, `[DPS]`), **Race & Faction** (including the cross-faction **Skyborne** race), and **Primary Profession**, while providing an in-game profile switcher allowing players to preview any combination on the fly.

---

## Directory Architecture

```
ForeverTankGuide/ (or HeathensForeverGuide/)
├── ForeverTankGuide.toc          # Load order orchestrator & saved variables
├── HeathensForeverGuide.toc      # Alternate TOC for HeathensForeverGuide folder name
├── Core.lua                      # Lifecycle, event router, level-up alerts, minimap button
├── UI.lua                        # Dynamic UI engine with profile switcher & tabs
├── Engine/
│   ├── Registry.lua              # Module registration API & profile stitcher
│   └── Profile.lua               # Dynamic character auto-detector & override manager
└── Modules/
    ├── Classes/
    │   ├── Paladin.lua           # Protection (Tank), Holy (Healer), Retribution (DPS)
    │   ├── Warrior.lua           # Protection (Tank), Arms (DPS), Fury (DPS)
    │   ├── Druid.lua             # Feral Bear (Tank), Feral Cat (DPS), Restoration (Healer), Balance (DPS)
    │   ├── Priest.lua            # Holy/Discipline (Healer), Shadow (DPS)
    │   ├── Shaman.lua            # Enhancement (Tank/Melee), Restoration (Healer), Elemental (DPS)
    │   ├── Mage.lua              # Frost (AoE/Control DPS), Fire (Ignite DPS), Arcane (Burst DPS)
    │   ├── Warlock.lua           # Metamorphosis (Tank), Affliction/Drain (Leveling), Destruction/DS-Ruin (DPS)
    │   ├── Rogue.lua             # Blade Dance (Tank), Combat (DPS), Assassination (Seal Fate DPS)
    │   └── Hunter.lua            # Beast Mastery (Pet/Leveling), Marksmanship (Raid DPS), Survival (Agility/Hybrid DPS)
    ├── Races/
    │   ├── Horde/
    │   │   ├── Undead.lua        # Deathknell -> Brill -> Sepulcher -> Horde 20-60 Hubs
    │   │   ├── Tauren.lua        # Camp Narache -> Bloodhoof -> Barrens -> Horde 20-60 Hubs
    │   │   ├── Orc.lua           # Valley of Trials -> Razor Hill -> Barrens -> Horde 20-60 Hubs
    │   │   ├── Troll.lua         # Valley of Trials -> Sen'jin -> Barrens -> Horde 20-60 Hubs
    │   │   └── SkyborneHorde.lua # Skyborne Horde Aerie -> Barrens/Silverpine -> Horde 20-60 Hubs
    │   └── Alliance/
    │       ├── Human.lua         # Northshire -> Goldshire -> Westfall/Redridge -> Alliance 20-60 Hubs
    │       ├── Dwarf.lua         # Coldridge -> Kharanos -> Loch Modan/Wetlands -> Alliance 20-60 Hubs
    │       ├── NightElf.lua      # Shadowglen -> Dolanaar -> Darkshore/Ashenvale -> Alliance 20-60 Hubs
    │       ├── Gnome.lua         # Coldridge -> Kharanos -> Loch Modan/Wetlands -> Alliance 20-60 Hubs
    │       └── SkyborneAlliance.lua # Skyborne Alliance Aerie -> Darkshore/Westfall -> Alliance 20-60 Hubs
    ├── Professions/
    │   ├── Engineering.lua       # Bombs, Sappers, Target Dummies, Force Reactive Disk
    │   ├── Blacksmithing.lua     # Shield Spikes, Sharpening Stones, Lionheart Helm, Plate
    │   ├── Alchemy.lua           # Greater Stoneshield, Mongoose, Greater Arcane, Mana Potions, Flasks
    │   ├── Leatherworking.lua    # Armor Kits, Devilsaur Set, Wicked Leather, Hide of the Wild
    │   └── Tailoring.lua         # Bags, Dreamweave, Robe of the Archmage, Truefaith, Bloodvine Set
    └── Dungeons/
        └── Encounters.lua        # Universal dungeon brackets, role-tagged loot drops ([TANK]/[HEAL]/[DPS]), checklists
```

---

## Key Features

1. **Automatic Character Detection & Dynamic Registration:**
   - Detects Class, active Specialization (via talent points or specialization API), Role, Race/Faction (including Horde vs. Alliance Skyborne), and Profession on login.
2. **Race- & Faction-Based Quest Routing:**
   - Recommended Leveling & Farming Zones dynamically populate based strictly on your character's Race and Faction across all 4 brackets (1–20, 20–40, 40–52, 52–60).
3. **In-UI Profile Switcher:**
   - Interactive dropdown buttons in the top header (`Class | Spec | Race | Profession | Detect Player`) let you preview any combination on the fly.
4. **Role-Tagged Dungeon & Loot Checklist:**
   - Persistent checkboxes stored per character in `FTG_CharDB.completedTasks` with `[TANK]`, `[HEAL]`, and `[DPS]` item tags.
5. **Categorized Macro Vault:**
   - Macros organized by **Defensive / Tank**, **Healing / Mouseover**, **Burst / DPS**, **Racial / Utility**, and **Profession / Utility** with one-click **"Save to WoW"** (`CreateMacro`).

---

## Installation & Commands

1. Place the addon folder in `Interface\AddOns\`:
   - Works as either `Interface\AddOns\ForeverTankGuide\` or `Interface\AddOns\HeathensForeverGuide\`.
2. In-game commands:
   - `/hfg`, `/foreverguide`, `/ftg`, or `/tankguide` : Toggle guide window.
   - `/hfg reset` : Re-center window on screen.
   - Left-click or drag the minimap button to toggle or reposition.
