#!/usr/bin/env python3
"""
Heathen's Forever Guide - Open-Source External Database Importer
Imports quest and item datasets from open-source repositories (e.g., QuestieDB Forever dataset)
to automatically capture custom WoW: Forever quests, items, and rewards without manual authoring.

Usage:
    python Tools/import_external_db.py [--source questie] [--sync-lua]
"""

import os
import sys
import json
import re
import argparse
import urllib.request
from typing import Dict, List, Any, Tuple

# Base repository URLs for QuestieDB Forever dataset
QUESTIE_FOREVER_QUEST_URL = "https://raw.githubusercontent.com/Questie/QuestieDB/master/data/Forever/foreverQuestDB.lua"
QUESTIE_FOREVER_ITEM_URL = "https://raw.githubusercontent.com/Questie/QuestieDB/master/data/Forever/foreverItemDB.lua"

# Zone ID mapping (AreaTable.dbc)
ZONE_NAMES = {
    1: "Dun Morogh", 3: "Badlands", 4: "Blasted Lands", 8: "Swamp of Sorrows",
    10: "Duskwood", 11: "Wetlands", 12: "Elwynn Forest", 14: "Durotar",
    15: "Dustwallow Marsh", 16: "Azshara", 17: "The Barrens", 28: "Western Plaguelands",
    33: "Stranglethorn Vale", 36: "Alterac Mountains", 38: "Loch Modan", 40: "Westfall",
    41: "Deadwind Pass", 44: "Redridge Mountains", 45: "Arathi Highlands",
    46: "Burning Steppes", 47: "The Hinterlands", 51: "Searing Gorge",
    85: "Tirisfal Glades", 130: "Silverpine Forest", 139: "Eastern Plaguelands",
    141: "Sunken Temple / Swamp of Sorrows", 148: "Darkshore", 215: "Mulgore",
    267: "Hillsbrad Foothills", 331: "Ashenvale", 357: "Feralas", 361: "Felwood",
    400: "Thousand Needles", 405: "Desolace", 406: "Stonetalon Mountains",
    440: "Tanaris", 490: "Un'Goro Crater", 493: "Moonglade", 618: "Winterspring",
    1477: "Sunken Temple", 1584: "Blackrock Mountain"
}

ITEM_SLOT_MAP = {
    1: "Head", 2: "Neck", 3: "Shoulder", 4: "Shirt", 5: "Chest",
    6: "Waist", 7: "Legs", 8: "Feet", 9: "Wrist", 10: "Hands",
    11: "Finger", 12: "Trinket", 13: "One-Hand", 14: "Shield",
    15: "Ranged", 16: "Back", 17: "Two-Hand", 18: "Bag", 19: "Tabard",
    20: "Chest", 21: "Main Hand", 22: "Off Hand", 23: "Held In Off-hand",
    25: "Thrown", 26: "Ranged", 28: "Relic"
}

def fetch_or_read(url: str, local_file: str = None) -> str:
    """Fetches data from URL or reads from a local file if provided."""
    if local_file and os.path.exists(local_file):
        print(f"Reading from local file: {local_file}")
        with open(local_file, "r", encoding="utf-8", errors="ignore") as f:
            return f.read()
    
    print(f"Fetching from remote URL: {url} ...")
    req = urllib.request.Request(url, headers={"User-Agent": "HFG-ExternalDB-Importer/1.5"})
    with urllib.request.urlopen(req, timeout=30) as resp:
        return resp.read().decode("utf-8", errors="ignore")

def parse_lua_array_values(raw_line: str) -> List[str]:
    """Tokenizes comma-separated values inside a Lua array while preserving nested braces and strings."""
    tokens = []
    current = []
    brace_depth = 0
    in_str = None
    escaped = False

    for c in raw_line:
        if escaped:
            current.append(c)
            escaped = False
            continue

        if c == '\\':
            escaped = True
            current.append(c)
            continue

        if in_str:
            current.append(c)
            if c == in_str:
                in_str = None
            continue

        if c in ('"', "'"):
            in_str = c
            current.append(c)
            continue

        if c == '{':
            brace_depth += 1
            current.append(c)
        elif c == '}':
            brace_depth -= 1
            current.append(c)
        elif c == ',' and brace_depth == 0:
            tokens.append("".join(current).strip())
            current = []
        else:
            current.append(c)

    if current:
        tokens.append("".join(current).strip())

    return tokens

def clean_lua_str(s: str) -> str:
    """Cleans up raw Lua string escaping and produces a safe double-quoted string."""
    s = s.strip("'\"").replace("\\'", "'").replace('\\"', '"')
    return s.replace('\\', '\\\\').replace('"', '\\"')

def parse_quest_db(content: str) -> Dict[int, Dict[str, Any]]:
    """Parses QuestieDB foreverQuestDB.lua format into dictionary of quests."""
    quests = {}
    pattern = re.compile(r'\[(\d+)\]\s*=\s*\{(.+?)\},?\s*$', re.MULTILINE)
    
    for match in pattern.finditer(content):
        qid_str, body = match.groups()
        qid = int(qid_str)
        tokens = parse_lua_array_values(body)
        if not tokens:
            continue
        
        # token 0: name
        name = clean_lua_str(tokens[0])
        
        # token 3: requiredLevel
        req_lvl = 1
        if len(tokens) > 3 and tokens[3].isdigit():
            req_lvl = int(tokens[3])
            
        # token 4: questLevel
        q_lvl = req_lvl
        if len(tokens) > 4 and tokens[4].lstrip('-').isdigit():
            val = int(tokens[4])
            if val > 0:
                q_lvl = val
            else:
                q_lvl = max(1, req_lvl)
            
        # token 5: requiredRaces (bitmask)
        race_mask = 0
        if len(tokens) > 5 and tokens[5].isdigit():
            race_mask = int(tokens[5])

        # token 7: objectivesText
        obj_text = ""
        if len(tokens) > 7 and tokens[7].startswith('{') and tokens[7].endswith('}'):
            inner = tokens[7][1:-1].strip()
            obj_text = inner.strip("'\"")
            
        # token 16: zoneOrSort
        zone_id = 0
        if len(tokens) > 16 and tokens[16].lstrip('-').isdigit():
            zone_id = int(tokens[16])
            
        zone_name = ZONE_NAMES.get(zone_id, f"Zone {zone_id}" if zone_id > 0 else "Azeroth")

        # Determine faction from race bitmask:
        faction = "Both"
        if race_mask > 0:
            has_alliance = bool(race_mask & (1 | 4 | 8 | 64))
            has_horde = bool(race_mask & (2 | 16 | 32 | 128))
            if has_alliance and not has_horde:
                faction = "Alliance"
            elif has_horde and not has_alliance:
                faction = "Horde"

        quests[qid] = {
            "id": qid,
            "title": name,
            "level": q_lvl,
            "minLevel": req_lvl,
            "zone": zone_name,
            "zoneId": zone_id,
            "faction": faction,
            "objectives": obj_text or "Complete the objectives and report back for your reward.",
            "xp": max(200, q_lvl * 115 + 350),
            "money": max(50, q_lvl * 35),
            "loot": []
        }
        
    print(f"Parsed {len(quests)} quests from external database.")
    return quests

def parse_item_db(content: str) -> Tuple[Dict[int, Dict[str, Any]], Dict[int, List[int]]]:
    """
    Parses QuestieDB foreverItemDB.lua format.
    Returns:
    - items: Dict[itemID, itemData]
    - quest_rewards_map: Dict[questID, List[itemID]]
    """
    items = {}
    quest_rewards_map = {}
    pattern = re.compile(r'\[(\d+)\]\s*=\s*\{(.+?)\},?\s*$', re.MULTILINE)

    for match in pattern.finditer(content):
        item_id_str, body = match.groups()
        item_id = int(item_id_str)
        tokens = parse_lua_array_values(body)
        if not tokens:
            continue

        # token 0: name
        name = clean_lua_str(tokens[0])
        
        # token 5: questRewards (e.g. {1653, 1654} or nil)
        quest_ids = []
        if len(tokens) > 5 and tokens[5].startswith('{') and tokens[5].endswith('}'):
            inner = tokens[5][1:-1].strip()
            if inner:
                for q in inner.split(','):
                    q = q.strip()
                    if q.isdigit():
                        quest_ids.append(int(q))

        # token 8: itemLevel
        ilvl = 1
        if len(tokens) > 8 and tokens[8].isdigit():
            ilvl = int(tokens[8])

        # token 9: requiredLevel
        req_lvl = 0
        if len(tokens) > 9 and tokens[9].isdigit():
            req_lvl = int(tokens[9])

        # token 11: class
        class_id = 0
        if len(tokens) > 11 and tokens[11].isdigit():
            class_id = int(tokens[11])

        # token 12: subClass
        subclass_id = 0
        if len(tokens) > 12 and tokens[12].isdigit():
            subclass_id = int(tokens[12])

        # Determine slot string
        slot = "One-Hand"
        if class_id == 2:
            if subclass_id in (1, 5, 6, 8, 10):
                slot = "Two-Hand"
            elif subclass_id in (2, 3, 18):
                slot = "Ranged"
            else:
                slot = "One-Hand"
        elif class_id == 4:
            if subclass_id == 6:
                slot = "Shield"
            else:
                slot = "Chest"

        # Quality inference from item level vs req level
        quality = 2 if ilvl >= req_lvl + 5 else 1
        if ilvl >= req_lvl + 12:
            quality = 3

        item_entry = {
            "itemId": item_id,
            "name": name,
            "itemLevel": ilvl,
            "reqLevel": req_lvl,
            "classId": class_id,
            "subClassId": subclass_id,
            "slot": slot,
            "quality": quality,
            "qualityName": "Rare" if quality == 3 else ("Uncommon" if quality == 2 else "Common"),
            "isChoice": True,
            "armor": ilvl * 4 if class_id == 4 else 0,
            "blockValue": (ilvl * 2) if (class_id == 4 and subclass_id == 6) else 0,
            "dps": round(ilvl * 0.85, 1) if class_id == 2 else 0.0,
            "stats": {}
        }
        items[item_id] = item_entry

        for qid in quest_ids:
            if qid not in quest_rewards_map:
                quest_rewards_map[qid] = []
            quest_rewards_map[qid].append(item_id)

    print(f"Parsed {len(items)} items and mapped rewards for {len(quest_rewards_map)} quests.")
    return items, quest_rewards_map

def heuristic_score_item(item: Dict[str, Any]) -> Tuple[str, Dict[str, float]]:
    """Assigns heuristic role ([TANK], [HEAL], [DPS]) and power scores based on item metadata."""
    class_id = item.get("classId", 0)
    subclass_id = item.get("subClassId", 0)
    ilvl = item.get("itemLevel", 1)
    name = item.get("name", "").lower()

    tank_score = 0.0
    heal_score = 0.0
    dps_score = 0.0

    # Weapons (class 2)
    if class_id == 2:
        dps_score = ilvl * 2.5
        tank_score = ilvl * 1.5
        heal_score = ilvl * 1.2
    # Armor (class 4)
    elif class_id == 4:
        # Shields
        if subclass_id == 6 or "shield" in name or "buckler" in name:
            tank_score = ilvl * 3.5 + 40.0
            item["slot"] = "Shield"
        elif any(w in name for w in ("wall", "ward", "fortress", "iron", "stone", "protection", "bulwark")):
            tank_score = ilvl * 2.8 + 15.0
            dps_score = ilvl * 1.5
        elif any(w in name for w in ("robe", "mantle", "blessed", "spirit", "prayer", "radiant", "heal")):
            heal_score = ilvl * 2.8 + 15.0
            dps_score = ilvl * 1.8
        else:
            dps_score = ilvl * 2.2 + 5.0
            tank_score = ilvl * 1.8
            heal_score = ilvl * 1.5
    else:
        tank_score = ilvl * 1.0
        heal_score = ilvl * 1.0
        dps_score = ilvl * 1.0

    scores = {"TANK": round(tank_score, 1), "HEAL": round(heal_score, 1), "DPS": round(dps_score, 1)}
    sorted_roles = sorted(scores.items(), key=lambda kv: kv[1], reverse=True)
    primary_role = f"[{sorted_roles[0][0]}]"

    return primary_role, scores

def main():
    parser = argparse.ArgumentParser(description="Import external open-source databases for WoW Forever")
    parser.add_argument("--source", default="questie", choices=["questie"], help="External DB source")
    parser.add_argument("--local-quest-file", help="Path to local quest DB file")
    parser.add_argument("--local-item-file", help="Path to local item DB file")
    parser.add_argument("--sync-lua", action="store_true", help="Sync output directly into Modules/Quests/QuestData.lua")
    args = parser.parse_args()

    repo_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    data_dir = os.path.join(repo_root, "Data")
    os.makedirs(data_dir, exist_ok=True)

    print(f"=== Heathen's Forever Guide: Open-Source Database Importer ===")
    print(f"Target dataset: {args.source.upper()} (WoW Forever Branch)")

    # 1. Fetch & Parse Quests
    quest_raw = fetch_or_read(QUESTIE_FOREVER_QUEST_URL, args.local_quest_file)
    quests = parse_quest_db(quest_raw)

    # 2. Fetch & Parse Items
    item_raw = fetch_or_read(QUESTIE_FOREVER_ITEM_URL, args.local_item_file)
    items, quest_rewards_map = parse_item_db(item_raw)

    # 3. Associate Rewards with Quests & Run Heuristic Scoring
    enriched_quests = []
    for qid, q in quests.items():
        reward_item_ids = quest_rewards_map.get(qid, [])
        scored_loot = []
        q_tank, q_heal, q_dps = 0.0, 0.0, 0.0

        for iid in reward_item_ids:
            it = items.get(iid)
            if it:
                role, scores = heuristic_score_item(it)
                it["role"] = role
                scored_loot.append(it)
                q_tank = max(q_tank, scores["TANK"])
                q_heal = max(q_heal, scores["HEAL"])
                q_dps = max(q_dps, scores["DPS"])

        q["loot"] = scored_loot
        scores = {
            "TANK": round(q_tank, 1),
            "HEAL": round(q_heal, 1),
            "DPS": round(q_dps, 1),
            "XP": round(q["level"] * 1.5, 1)
        }
        q["scores"] = scores

        # Primary Role assignment
        if scored_loot:
            best_role = scored_loot[0]["role"]
            q["recommendedRoles"] = [best_role]
        else:
            q["recommendedRoles"] = ["[ALL]"]

        enriched_quests.append(q)

    # 4. Save merged JSON
    json_path = os.path.join(data_dir, "external_quests_forever.json")
    with open(json_path, "w", encoding="utf-8") as f:
        json.dump(enriched_quests, f, indent=2)
    print(f"Saved {len(enriched_quests)} enriched Forever quests to {json_path}")

    # 5. If --sync-lua requested, update Modules/Quests/QuestData.lua
    if args.sync_lua:
        print("\nIntegrating imported external database into Modules/Quests/QuestData.lua...")
        lua_path = os.path.join(repo_root, "Modules", "Quests", "QuestData.lua")
        
        # Categorize by level bracket
        brackets = {1: [], 2: [], 3: [], 4: []}
        for q in enriched_quests:
            if not q.get("loot"):
                continue  # Only include quests that offer equipment upgrades
            lvl = q["level"]
            if lvl <= 20:
                brackets[1].append(q)
            elif lvl <= 40:
                brackets[2].append(q)
            elif lvl <= 52:
                brackets[3].append(q)
            else:
                brackets[4].append(q)

        # Sort each bracket by highest loot score
        for b in brackets:
            brackets[b].sort(key=lambda x: max(x["scores"]["TANK"], x["scores"]["HEAL"], x["scores"]["DPS"]), reverse=True)
            # Keep top 35 upgrade quests per bracket
            brackets[b] = brackets[b][:35]

        print(f"Bracket 1 (1-20):  {len(brackets[1])} top reward quests")
        print(f"Bracket 2 (20-40): {len(brackets[2])} top reward quests")
        print(f"Bracket 3 (40-52): {len(brackets[3])} top reward quests")
        print(f"Bracket 4 (52-60): {len(brackets[4])} top reward quests")

        # Format full Lua QuestData.lua
        lua_lines = [
            "--[[",
            "    Heathen's Forever Guide - Dynamic Quest & Loot Database",
            "    Auto-generated by Tools/import_external_db.py",
            "    Synchronized from open-source QuestieDB Forever dataset with heuristic role evaluations.",
            "--]]",
            "",
            "local ADDON_NAME, HFG = ...",
            "if not HFG then HFG = _G.HFG end",
            "if not HFG then return end",
            "",
            "HFG.QuestDB = HFG.QuestDB or {}",
            "HFG.QuestItemsDB = HFG.QuestItemsDB or {}",
            "",
            "-- Registered Quest Table (Bracket 1: 1-20, Bracket 2: 20-40, Bracket 3: 40-52, Bracket 4: 52-60)",
        ]

        for b_id in (1, 2, 3, 4):
            lua_lines.append(f"-- ========================================================")
            lua_lines.append(f"-- BRACKET {b_id} (Level Range: {1 if b_id==1 else (20 if b_id==2 else (40 if b_id==3 else 52))} to {20 if b_id==1 else (40 if b_id==2 else (52 if b_id==3 else 60))})")
            lua_lines.append(f"-- ========================================================")
            for q in brackets[b_id]:
                safe_title = clean_lua_str(q["title"])
                safe_zone = clean_lua_str(q["zone"])
                safe_obj = clean_lua_str(q["objectives"])
                roles_str = "{" + ", ".join(f'"{r}"' for r in q["recommendedRoles"]) + "}"

                lua_lines.append(f"HFG.QuestDB[{q['id']}] = {{")
                lua_lines.append(f"    id = {q['id']},")
                lua_lines.append(f'    title = "{safe_title}",')
                lua_lines.append(f"    level = {q['level']},")
                lua_lines.append(f"    minLevel = {q['minLevel']},")
                lua_lines.append(f"    zoneId = {q['zoneId']},")
                lua_lines.append(f'    zone = "{safe_zone}",')
                lua_lines.append(f"    xp = {q['xp']},")
                lua_lines.append(f"    money = {q['money']},")
                lua_lines.append(f'    objectives = "{safe_obj}",')
                lua_lines.append(f"    recommendedRoles = {roles_str},")
                lua_lines.append(f"    scores = {{ TANK = {q['scores']['TANK']}, HEAL = {q['scores']['HEAL']}, DPS = {q['scores']['DPS']}, XP = {q['scores']['XP']} }},")
                lua_lines.append("    loot = {")
                for it in q.get("loot", [])[:4]:
                    safe_iname = clean_lua_str(it["name"])
                    lua_lines.append("        {")
                    lua_lines.append(f"            itemId = {it['itemId']},")
                    lua_lines.append(f'            name = "{safe_iname}",')
                    lua_lines.append(f"            quality = {it['quality']},")
                    lua_lines.append(f'            qualityName = "{it["qualityName"]}",')
                    lua_lines.append(f'            slot = "{it["slot"]}",')
                    lua_lines.append(f'            role = "{it["role"]}",')
                    lua_lines.append(f"            isChoice = {str(it['isChoice']).lower()},")
                    lua_lines.append(f"            itemLevel = {it['itemLevel']},")
                    lua_lines.append(f"            armor = {it['armor']},")
                    lua_lines.append(f"            blockValue = {it['blockValue']},")
                    lua_lines.append(f"            dps = {it['dps']},")
                    lua_lines.append("            stats = {}")
                    lua_lines.append("        },")
                lua_lines.append("    }")
                lua_lines.append("}\n")

        with open(lua_path, "w", encoding="utf-8") as f:
            f.write("\n".join(lua_lines))
        print(f"Successfully synchronized {lua_path}!")

    print("\nImport pipeline complete!")

if __name__ == "__main__":
    main()
