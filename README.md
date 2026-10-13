# Heathen's Forever Guide (v1.3.0)

**Heathen's Forever Guide** is an all-in-one in-game leveling, dungeon, specialization, and profession progression assistant for **World of Warcraft: Forever** (`Interface: 16001`), authored by **FilthyHeathen**.

Featuring a **decoupled, registry-driven modular engine** (`HFG`), it automatically detects the player's active **Class**, **Specialization** (via an intelligent Classic heuristic resolver checking active auras, equipped weapons/shields, and talent points), **Role** (`[TANK]`, `[HEAL]`, `[DPS]`), **Race & Faction** (including the cross-faction **Skyborne** race), and **Primary Profession**, while providing an in-game profile switcher to preview any combination on the fly.

---

## Directory Architecture

```
HeathensForeverGuide/
├── HeathensForeverGuide.toc      # Load order orchestrator & saved variables (HFG_CharDB)
├── Core.lua                      # Lifecycle, event router, level-up alerts, minimap button
├── UI.lua                        # Dynamic UI engine with profile switcher & tabs
├── Engine/
│   ├── Registry.lua              # Module registration API & profile stitcher
│   └── Profile.lua               # Heuristic role/spec resolver & override manager
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

1. **Intelligent Classic Heuristic Role & Spec Resolver (`HFG:DetectPlayerRoleAndSpec`):**
   - Inspects equipped gear (`GetInventoryItemID` on slots 16 & 17 for 2H weapons vs. Shields), active buffs (`AuraUtil` for *Righteous Fury*, *Sanctity Aura*, *Bear/Cat/Moonkin Form*, *Shadowform*, *Metamorphosis*, *Way of Earth*), and talent tree points (`GetTalentTabInfo`).
   - Any manual selection in the top bar dropdowns overrides auto-detection until **"Detect Player"** is clicked.
2. **Race- & Faction-Based Quest Routing:**
   - Recommended Leveling & Farming Zones dynamically populate based strictly on your character's Race and Faction across all 4 brackets (1–20, 20–40, 40–52, 52–60), including full **Skyborne (Horde)** and **Skyborne (Alliance)** routes.
3. **Role-Tagged Dungeon & Loot Checklist:**
   - Persistent checkboxes stored per character in `HFG_CharDB.completedTasks` with `[TANK]`, `[HEAL]`, and `[DPS]` item tags.
4. **Categorized Macro Vault:**
   - Macros organized by **Defensive / Tank**, **Healing / Mouseover**, **Burst / DPS**, **Racial / Utility**, and **Profession / Utility** with one-click **"Save to WoW"** (`CreateMacro`).

---

## Official Downloads & Documentation

* **CurseForge:** [https://www.curseforge.com/wow/addons/heathens-forever-guide](https://www.curseforge.com/wow/addons/heathens-forever-guide)
* **Wago.io:** [https://addons.wago.io/addons/heathensforeverguide](https://addons.wago.io/addons/heathensforeverguide)
* **GitHub Releases:** [https://github.com/FilthyHeathen/HeathensForeverGuide/releases/latest](https://github.com/FilthyHeathen/HeathensForeverGuide/releases/latest)
* **Documentation Wiki:** [https://github.com/FilthyHeathen/HeathensForeverGuide/wiki](https://github.com/FilthyHeathen/HeathensForeverGuide/wiki)

---

## Installation & Slash Commands

1. Install via **[CurseForge](https://www.curseforge.com/wow/addons/heathens-forever-guide)**, **[Wago.io](https://addons.wago.io/addons/heathensforeverguide)**, or download **`HeathensForeverGuide.zip`** from the latest **[GitHub Release](https://github.com/FilthyHeathen/HeathensForeverGuide/releases/latest)** and extract it directly into:
   ```
   World of Warcraft\Interface\AddOns\HeathensForeverGuide\
   ```
2. In-game slash commands:
   - `/hfg` (or `/heathen`, `/foreverguide`) : Toggle **Heathen's Forever Guide** window.
   - `/hfg reset` : Reset window position to the center of the screen.
   - Left-click or drag the minimap button to toggle or reposition.
