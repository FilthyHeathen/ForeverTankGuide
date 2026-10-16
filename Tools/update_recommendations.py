#!/usr/bin/env python3
"""
Heathen's Forever Guide - Quest & Loot Cross-Reference & Heuristic Evaluator
Cross-references discovered items and quests from Data/items.json and Data/quests.json,
evaluates heuristic roles ([TANK], [HEAL], [DPS]), and syncs them into Lua tables.

Outputs:
- Modules/Quests/QuestData.lua (shipped with in-game addon)
- Data/QuestData.lua (optional dev copy)
"""

import os
import sys
import json
import argparse
from typing import Dict, List, Any, Tuple

# Zone ID to Name mapping for common vanilla zones
ZONE_NAMES = {
    1: "Dun Morogh",
    3: "Badlands",
    4: "Blasted Lands",
    8: "Swamp of Sorrows",
    10: "Duskwood",
    11: "Wetlands",
    12: "Elwynn Forest",
    14: "Durotar",
    15: "Dustwallow Marsh",
    16: "Azshara",
    17: "The Barrens",
    28: "Western Plaguelands",
    33: "Stranglethorn Vale",
    36: "Alterac Mountains",
    38: "Loch Modan",
    40: "Westfall",
    41: "Deadwind Pass",
    44: "Redridge Mountains",
    45: "Arathi Highlands",
    46: "Burning Steppes",
    47: "The Hinterlands",
    51: "Searing Gorge",
    85: "Tirisfal Glades",
    130: "Silverpine Forest",
    139: "Eastern Plaguelands",
    141: "Sunken Temple / Swamp of Sorrows",
    148: "Darkshore",
    215: "Mulgore",
    267: "Hillsbrad Foothills",
    331: "Ashenvale",
    357: "Feralas",
    361: "Felwood",
    400: "Thousand Needles",
    405: "Desolace",
    406: "Stonetalon Mountains",
    440: "Tanaris",
    490: "Un'Goro Crater",
    493: "Moonglade",
    618: "Winterspring",
    1477: "Sunken Temple",
    1584: "Blackrock Mountain",
    2017: "Stratholme",
    2057: "Scholomance",
}

def evaluate_item_roles(item: Dict[str, Any]) -> Dict[str, Any]:
    """
    Evaluates heuristic scores and assigned roles for an item:
    [TANK], [HEAL], [DPS], or [ALL].
    """
    stats = item.get("stats", {})
    armor = item.get("armor", 0)
    slot_id = item.get("inventorySlot", 0)
    dps = item.get("dps", 0.0)
    class_id = item.get("classId", 0)
    subclass_id = item.get("subclassId", 0)

    # 1. TANK Score
    tank_score = 0.0
    # Defense, Dodge, Parry, Block ratings
    tank_score += stats.get("Defense Rating", 0) * 3.5
    tank_score += stats.get("Dodge Rating", 0) * 3.0
    tank_score += stats.get("Parry Rating", 0) * 3.0
    tank_score += stats.get("Block Rating", 0) * 2.5
    tank_score += stats.get("Stamina", 0) * 2.0
    tank_score += stats.get("Strength", 0) * 0.8
    tank_score += item.get("blockValue", 0) * 1.5

    # Armor contribution
    if armor > 0:
        tank_score += min(armor * 0.08, 40.0)

    # Shield slot bonus
    if slot_id == 14 or (class_id == 4 and subclass_id == 6):
        tank_score += 35.0

    # 2. HEAL Score
    heal_score = 0.0
    heal_score += stats.get("Healing Power", 0) * 3.5
    heal_score += stats.get("Mana Regeneration", 0) * 3.0
    heal_score += stats.get("Spirit", 0) * 2.0
    heal_score += stats.get("Intellect", 0) * 1.5
    heal_score += stats.get("Spell Power", 0) * 1.0

    # 3. DPS Score
    dps_score = 0.0
    dps_score += stats.get("Attack Power", 0) * 1.8
    dps_score += stats.get("Agility", 0) * 2.0
    dps_score += stats.get("Strength", 0) * 1.5
    dps_score += stats.get("Crit Melee", 0) * 3.0
    dps_score += stats.get("Crit Ranged", 0) * 3.0
    dps_score += stats.get("Crit Spell", 0) * 3.0
    dps_score += stats.get("Hit Melee", 0) * 3.0
    dps_score += stats.get("Hit Ranged", 0) * 3.0
    dps_score += stats.get("Hit Spell", 0) * 3.0
    dps_score += stats.get("Spell Power", 0) * 2.0
    dps_score += stats.get("Armor Penetration", 0) * 2.5
    if dps > 0:
        dps_score += dps * 1.5

    # Quality multiplier
    quality = item.get("quality", 1)
    q_mult = 1.0 + (quality * 0.15)
    tank_score *= q_mult
    heal_score *= q_mult
    dps_score *= q_mult

    # Determine primary and qualifying roles
    scores = {"TANK": round(tank_score, 1), "HEAL": round(heal_score, 1), "DPS": round(dps_score, 1)}
    max_score = max(scores.values())

    assigned_roles = []
    if max_score > 5.0:
        if scores["TANK"] >= max_score * 0.75:
            assigned_roles.append("[TANK]")
        if scores["HEAL"] >= max_score * 0.75:
            assigned_roles.append("[HEAL]")
        if scores["DPS"] >= max_score * 0.75:
            assigned_roles.append("[DPS]")

    if not assigned_roles:
        # Bags, consumables, or general quest items
        if slot_id == 18 or class_id == 1:
            primary_role = "[ALL]"
            assigned_roles = ["[ALL]"]
        else:
            primary_role = "[ALL]"
            assigned_roles = ["[ALL]"]
    elif len(assigned_roles) >= 3:
        primary_role = "[ALL]"
    else:
        # Highest score
        sorted_roles = sorted(scores.items(), key=lambda kv: kv[1], reverse=True)
        primary_role = f"[{sorted_roles[0][0]}]"

    return {
        "scores": scores,
        "primaryRole": primary_role,
        "assignedRoles": assigned_roles
    }


def evaluate_quest_recommendations(
    quest: Dict[str, Any],
    items_db: Dict[int, Dict[str, Any]]
) -> Dict[str, Any]:
    """
    Evaluates quest rewards and XP value to determine suitability and role recommendations.
    """
    q_level = quest.get("level", 1)
    rew_xp = quest.get("rewXP", 0)
    fixed_rewards = quest.get("fixedRewards", [])
    choice_rewards = quest.get("choiceRewards", [])

    # XP Score: Standard XP at level L in vanilla ~ L * 100 + 400
    expected_xp = max(200, (q_level * 95) + 350)
    xp_ratio = min(3.0, rew_xp / float(expected_xp)) if expected_xp > 0 else 1.0
    xp_score = round(xp_ratio * 25.0, 1)

    all_reward_items = []
    # Collect items
    for rew in fixed_rewards:
        item_id = rew["itemId"]
        if item_id in items_db:
            all_reward_items.append({"item": items_db[item_id], "choice": False, "count": rew.get("count", 1)})
    for rew in choice_rewards:
        item_id = rew["itemId"]
        if item_id in items_db:
            all_reward_items.append({"item": items_db[item_id], "choice": True, "count": rew.get("count", 1)})

    max_tank = 0.0
    max_heal = 0.0
    max_dps = 0.0
    loot_highlights = []

    for entry in all_reward_items:
        it = entry["item"]
        eval_data = it["evaluation"]
        scores = eval_data["scores"]
        max_tank = max(max_tank, scores["TANK"])
        max_heal = max(max_heal, scores["HEAL"])
        max_dps = max(max_dps, scores["DPS"])

        loot_highlights.append({
            "itemId": it["id"],
            "name": it["name"],
            "quality": it["quality"],
            "qualityName": it["qualityName"],
            "slotName": it["slotName"],
            "role": eval_data["primaryRole"],
            "isChoice": entry["choice"],
            "itemLevel": it["itemLevel"],
            "stats": it["stats"],
            "armor": it["armor"],
            "blockValue": it.get("blockValue", 0),
            "dps": it["dps"]
        })

    # Composite scores for the quest
    quest_scores = {
        "TANK": round(max_tank + (xp_score * 0.6), 1),
        "HEAL": round(max_heal + (xp_score * 0.6), 1),
        "DPS": round(max_dps + (xp_score * 0.6), 1),
        "XP": xp_score
    }

    # Recommended roles
    recommended_roles = []
    max_q_score = max(quest_scores["TANK"], quest_scores["HEAL"], quest_scores["DPS"])
    if max_q_score > 10.0:
        if quest_scores["TANK"] >= max_q_score * 0.7:
            recommended_roles.append("[TANK]")
        if quest_scores["HEAL"] >= max_q_score * 0.7:
            recommended_roles.append("[HEAL]")
        if quest_scores["DPS"] >= max_q_score * 0.7:
            recommended_roles.append("[DPS]")

    if not recommended_roles:
        recommended_roles = ["[ALL]"]

    zone_id = quest.get("zoneOrSort", 0)
    zone_name = ZONE_NAMES.get(zone_id, f"Zone #{zone_id}")

    return {
        "id": quest["id"],
        "title": quest["title"],
        "level": q_level,
        "minLevel": quest.get("minLevel", max(1, q_level - 5)),
        "zoneId": zone_id,
        "zoneName": zone_name,
        "xp": rew_xp,
        "money": quest.get("rewMoney", 0),
        "scores": quest_scores,
        "recommendedRoles": recommended_roles,
        "loot": loot_highlights,
        "objectives": quest.get("objectivesText", ""),
        "details": quest.get("detailsText", "")
    }


def serialize_to_lua(quests_data: List[Dict[str, Any]], items_data: Dict[int, Dict[str, Any]]) -> str:
    """
    Serializes evaluated quests and items into an optimized, valid Lua database script.
    """
    lines = [
        "--[[",
        "    Heathen's Forever Guide - Dynamic Quest & Loot Database",
        "    Auto-generated by Tools/update_recommendations.py",
        "    Cross-referenced from client WDB caches with heuristic role evaluations.",
        "--]]",
        "",
        "local ADDON_NAME, HFG = ...",
        "if not HFG then HFG = _G.HFG end",
        "if not HFG then return end",
        "",
        "HFG.QuestDB = HFG.QuestDB or {}",
        "HFG.QuestItemsDB = HFG.QuestItemsDB or {}",
        "",
        "-- Registered Quest Table",
    ]

    for q in quests_data:
        q_id = q["id"]
        safe_title = q["title"].replace("\\", "\\\\").replace('"', '\\"')
        safe_zone = q["zoneName"].replace("\\", "\\\\").replace('"', '\\"')
        safe_obj = q["objectives"].replace("\\", "\\\\").replace('"', '\\"').replace("\n", " ")

        lines.append(f"HFG.QuestDB[{q_id}] = {{")
        lines.append(f'    id = {q_id},')
        lines.append(f'    title = "{safe_title}",')
        lines.append(f'    level = {q["level"]},')
        lines.append(f'    minLevel = {q["minLevel"]},')
        lines.append(f'    zoneId = {q["zoneId"]},')
        lines.append(f'    zone = "{safe_zone}",')
        lines.append(f'    xp = {q["xp"]},')
        lines.append(f'    money = {q["money"]},')
        lines.append(f'    objectives = "{safe_obj}",')

        # Roles table
        roles_str = ", ".join([f'"{r}"' for r in q["recommendedRoles"]])
        lines.append(f'    recommendedRoles = {{ {roles_str} }},')
        lines.append(f'    scores = {{ TANK = {q["scores"]["TANK"]}, HEAL = {q["scores"]["HEAL"]}, DPS = {q["scores"]["DPS"]}, XP = {q["scores"]["XP"]} }},')

        # Loot table
        lines.append('    loot = {')
        for loot in q["loot"]:
            safe_name = loot["name"].replace("\\", "\\\\").replace('"', '\\"')
            safe_slot = loot["slotName"].replace("\\", "\\\\").replace('"', '\\"')
            is_choice = "true" if loot["isChoice"] else "false"

            # Format stats into lua subtable
            stats_entries = []
            for s_k, s_v in loot["stats"].items():
                safe_sk = s_k.replace('"', '\\"')
                stats_entries.append(f'["{safe_sk}"] = {s_v}')
            stats_lua = "{ " + ", ".join(stats_entries) + " }"

            lines.append(f'        {{')
            lines.append(f'            itemId = {loot["itemId"]},')
            lines.append(f'            name = "{safe_name}",')
            lines.append(f'            quality = {loot["quality"]},')
            lines.append(f'            qualityName = "{loot["qualityName"]}",')
            lines.append(f'            slot = "{safe_slot}",')
            lines.append(f'            role = "{loot["role"]}",')
            lines.append(f'            isChoice = {is_choice},')
            lines.append(f'            itemLevel = {loot["itemLevel"]},')
            lines.append(f'            armor = {loot["armor"]},')
            lines.append(f'            blockValue = {loot["blockValue"]},')
            lines.append(f'            dps = {loot["dps"]},')
            lines.append(f'            stats = {stats_lua}')
            lines.append(f'        }},')
        lines.append('    }')
        lines.append("}\n")

    lines.append("-- Standalone Quest Items Registry")
    for item_id, it in items_data.items():
        safe_name = it["name"].replace("\\", "\\\\").replace('"', '\\"')
        safe_slot = it["slotName"].replace("\\", "\\\\").replace('"', '\\"')
        role = it["evaluation"]["primaryRole"]

        stats_entries = []
        for s_k, s_v in it["stats"].items():
            safe_sk = s_k.replace('"', '\\"')
            stats_entries.append(f'["{safe_sk}"] = {s_v}')
        stats_lua = "{ " + ", ".join(stats_entries) + " }"

        lines.append(f"HFG.QuestItemsDB[{item_id}] = {{")
        lines.append(f'    id = {item_id},')
        lines.append(f'    name = "{safe_name}",')
        lines.append(f'    quality = {it["quality"]},')
        lines.append(f'    slot = "{safe_slot}",')
        lines.append(f'    role = "{role}",')
        lines.append(f'    itemLevel = {it["itemLevel"]},')
        lines.append(f'    armor = {it["armor"]},')
        lines.append(f'    blockValue = {it.get("blockValue", 0)},')
        lines.append(f'    dps = {it["dps"]},')
        lines.append(f'    stats = {stats_lua}')
        lines.append(f"}}")

    return "\n".join(lines) + "\n"


def main():
    parser = argparse.ArgumentParser(description="Cross-reference items and quests, evaluate heuristic roles, and generate Lua tables.")
    parser.add_argument("--items-json", default="Data/items.json", help="Path to items.json")
    parser.add_argument("--quests-json", default="Data/quests.json", help="Path to quests.json")
    parser.add_argument("--out-lua", default="Modules/Quests/QuestData.lua", help="Path to output QuestData.lua")
    parser.add_argument("--also-data-lua", default="Data/QuestData.lua", help="Optional second output in Data/")

    args = parser.parse_args()

    if not os.path.exists(args.items_json):
        print(f"Error: Items JSON not found at {args.items_json}. Run wdb_parser.py first.")
        sys.exit(1)
    if not os.path.exists(args.quests_json):
        print(f"Error: Quests JSON not found at {args.quests_json}. Run wdb_parser.py first.")
        sys.exit(1)

    with open(args.items_json, "r", encoding="utf-8") as f:
        raw_items = json.load(f)
    with open(args.quests_json, "r", encoding="utf-8") as f:
        raw_quests = json.load(f)

    # Convert items to integer keyed dict and evaluate roles
    evaluated_items = {}
    for k_str, item in raw_items.items():
        item_id = int(k_str)
        item["evaluation"] = evaluate_item_roles(item)
        evaluated_items[item_id] = item

    # Evaluate quests
    evaluated_quests = []
    for k_str, quest in raw_quests.items():
        q_eval = evaluate_quest_recommendations(quest, evaluated_items)
        evaluated_quests.append(q_eval)

    # Sort quests by level
    evaluated_quests.sort(key=lambda q: (q["level"], q["id"]))

    # Generate Lua
    lua_code = serialize_to_lua(evaluated_quests, evaluated_items)

    os.makedirs(os.path.dirname(args.out_lua), exist_ok=True)
    with open(args.out_lua, "w", encoding="utf-8") as f:
        f.write(lua_code)
    print(f"Successfully generated {args.out_lua} ({len(evaluated_quests)} quests, {len(evaluated_items)} items).")

    if args.also_data_lua:
        os.makedirs(os.path.dirname(args.also_data_lua), exist_ok=True)
        with open(args.also_data_lua, "w", encoding="utf-8") as f:
            f.write(lua_code)
        print(f"Synced secondary copy to {args.also_data_lua}")


if __name__ == "__main__":
    main()
