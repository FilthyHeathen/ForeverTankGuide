# Heathen's Forever Guide (v1.4.0)

**Heathen's Forever Guide** is an all-in-one in-game leveling, dungeon, specialization, and profession progression assistant for **World of Warcraft: Forever** (`Interface: 16001`), authored by **FilthyHeathen**.

Featuring a **decoupled, registry-driven modular engine** (`HFG`), it automatically detects the player's active **Class**, **Specialization** (via an intelligent Classic heuristic resolver checking active auras, equipped weapons/shields, and talent points), **Role** (`[TANK]`, `[HEAL]`, `[DPS]`), **Race & Faction** (including the cross-faction **Skyborne** race), and **Primary Profession**, while providing an in-game profile switcher to preview any combination on the fly.

---

## Directory Architecture

```
HeathensForeverGuide/
├── HeathensForeverGuide.toc      # Load order orchestrator & saved variables (HFG_CharDB)
├── Core.lua                      # Lifecycle, event router, level-up alerts, minimap button, slash commands
├── UI.lua                        # Dynamic UI engine with profile switcher, route viewer & tabs
├── Engine/
│   ├── Registry.lua              # Module registration API & profile stitcher
│   ├── Profile.lua               # Heuristic role/spec resolver & override manager
│   ├── QuestEngine.lua           # Dynamic quest recommender, native completion flag scanner
│   └── GuideEngine/
│       ├── GuideEngine.lua       # Step-by-step route runner, objective evaluation & auto-advancement
│       └── GuideHUD.lua          # Compact floating on-screen guide runner HUD
└── Modules/
    ├── Guides/
    │   ├── Horde/
    │   │   ├── OrcTroll_1_12.lua       # Valley of Trials & Durotar (1–12)
    │   │   └── SkyborneHorde_1_12.lua  # Skyborne Sanctuary & Kalimdor Descent (1–12)
    │   └── Alliance/
    │       ├── Human_1_12.lua          # Northshire Abbey & Elwynn Forest (1–12)
    │       └── SkyborneAlliance_1_12.lua # Skyborne Aerie & Darkshore Descent (1–12)
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
    ├── Dungeons/
    │   └── Encounters.lua        # Universal dungeon brackets, role-tagged loot drops ([TANK]/[HEAL]/[DPS]), checklists
    └── Quests/
        ├── QuestData.lua         # Cross-referenced quest metadata, heuristic role tags, and loot upgrades
        └── BagQuests.lua         # Essential inventory & bag upgrade quest progression (Levels 1–40)
```

---

## Key Features

1. **Interactive Step-by-Step Leveling Guide Engine (`HFG.GuideEngine`):**
   - Sequenced, linear quest and leveling routes tailored to your faction and starting race (e.g., Orc/Troll Durotar 1–12, Human Elwynn 1–12, Skyborne Horde 1–12, Skyborne Alliance 1–12).
   - High-density routing integrating early starter bag acquisition quests, class trainer visits, and optimal quest turn-in loops.
2. **Compact Floating On-Screen Guide Runner HUD (`HFG_GuideHUD`):**
   - A lightweight, draggable on-screen HUD that stays visible while questing.
   - Displays current step title, progress counter (`Step X/Y`), real-time objective checklist with status indicators (`[✓]` / `[ ]`), and fast step navigation (`<`, `Skip`, `>`).
   - Easily toggled via `/hfg hud` or the "Toggle HUD" button in the Leveling Route tab.
3. **Dynamic Objective Auto-Advancement:**
   - Real-time client API evaluation (`C_QuestLog` / `IsQuestFlaggedCompleted` / `PLAYER_LEVEL_UP`) auto-detects when quest objectives, acceptances, turn-ins, and level milestones are achieved, seamlessly auto-advancing to the next route step.
4. **Intelligent Classic Heuristic Role & Spec Resolver (`HFG:DetectPlayerRoleAndSpec`):**
   - Inspects equipped gear (`GetInventoryItemID` on slots 16 & 17 for 2H weapons vs. Shields), active buffs (`AuraUtil` for *Righteous Fury*, *Sanctity Aura*, *Bear/Cat/Moonkin Form*, *Shadowform*, *Metamorphosis*, *Way of Earth*), and talent tree points (`GetTalentTabInfo`).
   - Any manual selection in the top bar dropdowns overrides auto-detection until **"Detect Player"** is clicked.
5. **Dynamic Quest & Loot Recommendation Engine (`HFG.QuestEngine`):**
   - Scans completed quest flags via the native client API (`GetQuestsCompleted` / `IsQuestFlaggedCompleted`) and active quest log.
   - Evaluates unfinished quests and surfaces high-XP leveling opportunities and spec-appropriate gear upgrades (`[TANK]`, `[HEAL]`, `[DPS]`) tailored to your current level phase.
   - Interactive item tooltips, quality color coding, and role filter/sort toggles ("Spec Only", "All Roles", "Top Loot", "High XP").
6. **Race- & Faction-Based Quest Routing:**
   - Recommended Leveling & Farming Zones dynamically populate based strictly on your character's Race and Faction across all 4 brackets (1–20, 20–40, 40–52, 52–60), including full **Skyborne (Horde)** and **Skyborne (Alliance)** routes.
7. **Role-Tagged Dungeon & Loot Checklist:**
   - Persistent checkboxes stored per character in `HFG_CharDB.completedTasks` with `[TANK]`, `[HEAL]`, and `[DPS]` item tags.
8. **Categorized Macro Vault:**
   - Macros organized by **Defensive / Tank**, **Healing / Mouseover**, **Burst / DPS**, **Racial / Utility**, and **Profession / Utility** with one-click **"Save to WoW"** (`CreateMacro`).

---

## Developer Data Ingestion Pipeline

Heathen's Forever Guide features an offline binary ingestion and cross-referencing pipeline for processing raw game data caches:

1. **WDB Binary Cache Parser (`Tools/wdb_parser.py`):**
   - Ingests `itemcache.wdb` and `questcache.wdb` from the client cache directory.
   - Serializes extracted items and quests into structured, diffable JSON files stored in `Data/items.json` and `Data/quests.json`.
   ```bash
   python Tools/wdb_parser.py --items WDB/itemcache.wdb --quests WDB/questcache.wdb --out Data
   ```
2. **Heuristic Role Evaluator & Lua Sync (`Tools/update_recommendations.py`):**
   - Cross-references quest rewards with item definitions.
   - Evaluates heuristic role suitability (`[TANK]`, `[HEAL]`, `[DPS]`, `[ALL]`) based on armor, defense, stats, slot weights, and weapon speeds.
   - Generates production-ready Lua lookup tables into `Modules/Quests/QuestData.lua`.
   ```bash
   python Tools/update_recommendations.py
   ```
3. **Packaging Exclusions:**
   - `.pkgmeta` and `.gitignore` exclude `Tools/`, `Data/`, `*.py`, `*.wdb`, and `*.json` from addon distribution archives while preserving `Data/*.json` in version control.

---

## Official Downloads & Documentation

* **Direct Clean Zip Download (.zip without `-main`):** [Download HeathensForeverGuide.zip](https://github.com/FilthyHeathen/HeathensForeverGuide/raw/release-asset/HeathensForeverGuide.zip)
* **GitHub Releases:** [https://github.com/FilthyHeathen/HeathensForeverGuide/releases/latest](https://github.com/FilthyHeathen/HeathensForeverGuide/releases/latest)
* **CurseForge:** [https://www.curseforge.com/wow/addons/heathens-forever-guide](https://www.curseforge.com/wow/addons/heathens-forever-guide)
* **Wago.io:** [https://addons.wago.io/addons/heathensforeverguide](https://addons.wago.io/addons/heathensforeverguide)
* **Documentation Wiki:** [https://github.com/FilthyHeathen/HeathensForeverGuide/wiki](https://github.com/FilthyHeathen/HeathensForeverGuide/wiki)

---

## Installation & Slash Commands

> [!IMPORTANT]
> **Avoid GitHub's green "Code -> Download ZIP" button!** GitHub's source zip automatically appends `-main` (e.g. `HeathensForeverGuide-main`), which prevents World of Warcraft from recognizing the addon folder.
> 
> Always download the packaged **`HeathensForeverGuide.zip`** asset from **[GitHub Releases](https://github.com/FilthyHeathen/HeathensForeverGuide/releases/latest)** or the **[Direct Download Link](https://github.com/FilthyHeathen/HeathensForeverGuide/raw/release-asset/HeathensForeverGuide.zip)**.

1. Download **`HeathensForeverGuide.zip`** and extract it directly into your WoW AddOns folder:
   ```
   World of Warcraft\Interface\AddOns\HeathensForeverGuide\
   ```
   *(Ensure the inner folder is named `HeathensForeverGuide`, NOT `HeathensForeverGuide-main`)*.
2. In-game slash commands:
   - `/hfg` (or `/heathen`, `/foreverguide`) : Toggle **Heathen's Forever Guide** main window.
   - `/hfg hud` : Toggle compact on-screen floating Guide Runner HUD.
   - `/hfg route` : Open the interactive step-by-step leveling route tab.
   - `/hfg next` / `/hfg prev` / `/hfg skip` : Fast-forward or navigate guide steps.
   - `/hfg bags` : Scan and display available bag upgrade quests.
   - `/hfg scan` : Run completed quests scan via native API.
   - `/hfg reset` : Reset window position to the center of the screen.
   - Left-click or drag the minimap button to toggle or reposition.
