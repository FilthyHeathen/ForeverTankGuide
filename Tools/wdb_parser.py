#!/usr/bin/env python3
"""
Heathen's Forever Guide - WDB Binary Cache Parser
Parses client WDB binary caches (itemcache.wdb and questcache.wdb) into diffable,
structured JSON files stored in Data/.

Supports:
- Client version 1.12.1 / Turtle WoW / WoW Forever (Interface 16001 / 11200)
- Backward / forward compatible variable header detection (16/20/24 byte headers)
- Mock WDB generator for test pipelines and fixture creation
"""

import os
import sys
import json
import struct
import argparse
from typing import Dict, List, Any, Optional, Tuple

# Stat Type ID to Name mapping (WoW 1.12 / Classic)
STAT_TYPES = {
    0: "Mana",
    1: "Health",
    3: "Agility",
    4: "Strength",
    5: "Intellect",
    6: "Spirit",
    7: "Stamina",
    12: "Defense Rating",
    13: "Dodge Rating",
    14: "Parry Rating",
    15: "Block Rating",
    18: "Hit Melee",
    19: "Hit Ranged",
    20: "Hit Spell",
    21: "Crit Melee",
    22: "Crit Ranged",
    23: "Crit Spell",
    32: "Attack Power",
    35: "Spell Power",
    36: "Healing Power",
    37: "Mana Regeneration",
    38: "Armor Penetration",
}

QUALITY_NAMES = {
    0: "Poor",
    1: "Common",
    2: "Uncommon",
    3: "Rare",
    4: "Epic",
    5: "Legendary",
    6: "Artifact",
}

INVENTORY_SLOTS = {
    0: "Non-Equipable",
    1: "Head",
    2: "Neck",
    3: "Shoulders",
    4: "Shirt",
    5: "Chest",
    6: "Waist",
    7: "Legs",
    8: "Feet",
    9: "Wrists",
    10: "Hands",
    11: "Finger",
    12: "Trinket",
    13: "One-Hand",
    14: "Shield",
    15: "Ranged",
    16: "Back",
    17: "Two-Hand",
    18: "Bag",
    19: "Tabard",
    20: "Robe",
    21: "Main Hand",
    22: "Off Hand",
    23: "Holdable",
    25: "Thrown",
    26: "Ranged (Gun/Bow/Crossbow)",
    28: "Relic",
}

ITEM_CLASSES = {
    0: "Consumable",
    1: "Container",
    2: "Weapon",
    3: "Jewelry",
    4: "Armor",
    5: "Reagent",
    6: "Projectile",
    7: "Trade Goods",
    9: "Recipe",
    11: "Quiver",
    12: "Quest",
    13: "Key",
    14: "Permanent",
    15: "Junk",
}

def read_cstring(data: bytes, offset: int) -> Tuple[str, int]:
    """Reads a null-terminated string from bytes starting at offset."""
    null_pos = data.find(b"\x00", offset)
    if null_pos == -1:
        # Fallback to rest of string
        text = data[offset:].decode("utf-8", errors="replace")
        return text, len(data)
    text = data[offset:null_pos].decode("utf-8", errors="replace")
    return text, null_pos + 1


def detect_header(data: bytes) -> Tuple[str, int, str, int]:
    """
    Detects WDB header signature, build, locale, and total header size (16, 20, or 24 bytes).
    Returns (signature_str, build, locale_str, header_size).
    """
    if len(data) < 16:
        raise ValueError("Data too short for valid WDB header")

    sig_raw = data[0:4]
    # Check little-endian vs big-endian signature
    sig_str = sig_raw.decode("ascii", errors="replace")
    # Standard WDB signatures reversed:
    # 'BDIW' -> 'WIDB' (ItemCache)
    # 'TSQW' -> 'WQST' (QuestCache)
    # Some tools or files write 'WIDB' / 'WQST' directly
    normalized_sig = sig_str
    if sig_str in ("BDIW", "WIDB"):
        normalized_sig = "WIDB"
    elif sig_str in ("TSQW", "WQST"):
        normalized_sig = "WQST"

    build = struct.unpack_from("<I", data, 4)[0]
    locale_raw = data[8:12]
    # Locale is often reversed (e.g. 'SUne' -> 'enUS')
    try:
        loc_str = locale_raw.decode("ascii")
        if loc_str in ("SUne", "BGeu", "URru", "NCzh"):
            loc_str = loc_str[::-1]
    except Exception:
        loc_str = "enUS"

    header_size = 16
    if len(data) >= 20:
        rec_size, rec_ver = struct.unpack_from("<II", data, 12)
        # Check if 20-byte or 24-byte header
        if len(data) >= 24:
            # If offset 24 starts with a valid record ID or 20 starts with record ID
            header_size = 20
        else:
            header_size = 20

    return normalized_sig, build, loc_str, header_size


class ItemCacheParser:
    """Parses itemcache.wdb into structured dictionary."""

    def __init__(self, filepath: str):
        self.filepath = filepath
        self.items: Dict[int, Dict[str, Any]] = {}

    def parse(self) -> Dict[int, Dict[str, Any]]:
        if not os.path.exists(self.filepath):
            raise FileNotFoundError(f"File not found: {self.filepath}")

        with open(self.filepath, "rb") as f:
            data = f.read()

        if len(data) < 16:
            return self.items

        sig, build, locale, header_size = detect_header(data)
        offset = header_size

        while offset + 8 <= len(data):
            item_id, entry_len = struct.unpack_from("<II", data, offset)
            offset += 8

            if item_id == 0 and entry_len == 0:
                break
            if offset + entry_len > len(data):
                # End of file or truncated record
                break

            record_bytes = data[offset : offset + entry_len]
            offset += entry_len

            try:
                item_data = self._parse_item_record(item_id, record_bytes)
                if item_data:
                    self.items[item_id] = item_data
            except Exception as e:
                # Corrupted record, skip gracefully
                continue

        return self.items

    def _parse_item_record(self, item_id: int, payload: bytes) -> Optional[Dict[str, Any]]:
        # Payload format for 1.12.1 ItemCache
        # Starts with:
        # class_id (I), subclass_id (I), unk (I - build 6022+ optional)
        # 4 null-terminated name strings (name1, name2, name3, name4)
        if len(payload) < 20:
            return None

        # Check if first 8 bytes or 12 bytes precede names
        p_offset = 0
        class_id, subclass_id = struct.unpack_from("<II", payload, p_offset)
        p_offset += 8

        # In some client builds (e.g. 6022+), an extra 4-byte int exists before the name strings.
        # Check if the next byte is non-ASCII (e.g. < 32 or > 126), indicating an int field
        first_b = payload[p_offset]
        if first_b < 32 or first_b > 126:
            p_offset += 4

        # Read 4 name strings
        names = []
        for _ in range(4):
            if p_offset < len(payload):
                name, p_offset = read_cstring(payload, p_offset)
                names.append(name)
            else:
                names.append("")

        primary_name = names[0] if names and names[0] else f"Unknown Item #{item_id}"

        # Numerical attributes block:
        # display_id(I), quality(I), flags(I), buy_price(I), sell_price(I), inventory_slot(I),
        # allowable_class(i), allowable_race(i), item_level(I), required_level(I),
        # required_skill(I), required_skill_level(I), required_spell(I), required_rank(I),
        # required_unknown_rank(I), required_faction(I), required_faction_level(I),
        # max_count(I), stackable(I), container_slots(I)
        num_header_fmt = "<IIIIIIiiIIIIIIIIIIII"
        header_len = struct.calcsize(num_header_fmt)

        if p_offset + header_len > len(payload):
            # Partial record fallback
            return {
                "id": item_id,
                "name": primary_name,
                "classId": class_id,
                "subclassId": subclass_id,
                "quality": 1,
                "qualityName": QUALITY_NAMES.get(1, "Common"),
                "inventorySlot": 0,
                "slotName": INVENTORY_SLOTS.get(0, "Unknown"),
                "itemLevel": 1,
                "requiredLevel": 1,
                "stats": {},
                "armor": 0,
                "resists": {},
                "buyPrice": 0,
                "sellPrice": 0,
            }

        (
            display_id, quality, flags, buy_price, sell_price, inventory_slot,
            allowable_class, allowable_race, item_level, required_level,
            req_skill, req_skill_level, req_spell, req_rank, req_unk_rank,
            req_faction, req_faction_level, max_count, stackable, container_slots
        ) = struct.unpack_from(num_header_fmt, payload, p_offset)
        p_offset += header_len

        # 10 Stat pairs: (stat_id, stat_value)
        stats_dict = {}
        if p_offset + (10 * 8) <= len(payload):
            for _ in range(10):
                stat_id, stat_val = struct.unpack_from("<ii", payload, p_offset)
                p_offset += 8
                if stat_id > 0 and stat_val != 0:
                    stat_name = STAT_TYPES.get(stat_id, f"Stat_{stat_id}")
                    stats_dict[stat_name] = stats_dict.get(stat_name, 0) + stat_val

        # 5 Damage blocks: (min_dmg: float, max_dmg: float, type: int)
        damages = []
        if p_offset + (5 * 12) <= len(payload):
            for _ in range(5):
                d_min, d_max, d_type = struct.unpack_from("<ffi", payload, p_offset)
                p_offset += 12
                if d_max > 0:
                    damages.append({
                        "min": round(d_min, 1),
                        "max": round(d_max, 1),
                        "type": d_type
                    })

        # 7 Resistances: physical (armor), holy, fire, nature, frost, shadow, arcane
        armor = 0
        resists = {}
        if p_offset + 28 <= len(payload):
            res_vals = struct.unpack_from("<7i", payload, p_offset)
            p_offset += 28
            armor = max(0, res_vals[0])
            res_names = ["Holy", "Fire", "Nature", "Frost", "Shadow", "Arcane"]
            for i, r_val in enumerate(res_vals[1:]):
                if r_val != 0:
                    resists[res_names[i]] = r_val

        # Weapon Delay & Range
        speed_sec = 0.0
        dps = 0.0
        if p_offset + 12 <= len(payload):
            delay_ms, ammo_type, range_mod = struct.unpack_from("<iif", payload, p_offset)
            p_offset += 12
            if delay_ms > 0:
                speed_sec = round(delay_ms / 1000.0, 2)
                if damages:
                    avg_dmg = (damages[0]["min"] + damages[0]["max"]) / 2.0
                    dps = round(avg_dmg / speed_sec, 1)

        # 5 Spell blocks: (spell_id, trigger, charges, cooldown, category, category_cooldown)
        spells = []
        if p_offset + (5 * 24) <= len(payload):
            for _ in range(5):
                s_id, s_trig, s_chg, s_cd, s_cat, s_cat_cd = struct.unpack_from("<6i", payload, p_offset)
                p_offset += 24
                if s_id > 0:
                    spells.append({
                        "spellId": s_id,
                        "trigger": s_trig,
                        "cooldown": s_cd
                    })

        # Bonding
        bonding = 0
        if p_offset + 4 <= len(payload):
            bonding = struct.unpack_from("<i", payload, p_offset)[0]
            p_offset += 4

        # Description string
        desc = ""
        if p_offset < len(payload):
            desc, p_offset = read_cstring(payload, p_offset)

        # Block value for shields (at offset + 36 after desc, or if shield)
        block_value = 0
        if inventory_slot == 14 and p_offset + 40 <= len(payload):
            # blockValue is around index 116 in schema
            try:
                block_val_check = struct.unpack_from("<i", payload, p_offset + 36)[0]
                if 0 < block_val_check < 1000:
                    block_value = block_val_check
            except Exception:
                pass

        return {
            "id": item_id,
            "name": primary_name,
            "quality": quality,
            "qualityName": QUALITY_NAMES.get(quality, "Common"),
            "classId": class_id,
            "className": ITEM_CLASSES.get(class_id, "Misc"),
            "subclassId": subclass_id,
            "inventorySlot": inventory_slot,
            "slotName": INVENTORY_SLOTS.get(inventory_slot, "None"),
            "itemLevel": item_level,
            "requiredLevel": required_level,
            "allowableClass": allowable_class,
            "allowableRace": allowable_race,
            "armor": armor,
            "blockValue": block_value,
            "stats": stats_dict,
            "resists": resists,
            "speed": speed_sec,
            "dps": dps,
            "damages": damages,
            "spells": spells,
            "bonding": bonding,
            "buyPrice": buy_price,
            "sellPrice": sell_price,
            "description": desc
        }


class QuestCacheParser:
    """Parses questcache.wdb into structured dictionary."""

    def __init__(self, filepath: str):
        self.filepath = filepath
        self.quests: Dict[int, Dict[str, Any]] = {}

    def parse(self) -> Dict[int, Dict[str, Any]]:
        if not os.path.exists(self.filepath):
            raise FileNotFoundError(f"File not found: {self.filepath}")

        with open(self.filepath, "rb") as f:
            data = f.read()

        if len(data) < 16:
            return self.quests

        sig, build, locale, header_size = detect_header(data)
        offset = header_size

        while offset + 8 <= len(data):
            quest_id, entry_len = struct.unpack_from("<II", data, offset)
            offset += 8

            if quest_id == 0 and entry_len == 0:
                break
            if offset + entry_len > len(data):
                break

            record_bytes = data[offset : offset + entry_len]
            offset += entry_len

            try:
                quest_data = self._parse_quest_record(quest_id, record_bytes)
                if quest_data:
                    self.quests[quest_id] = quest_data
            except Exception as e:
                continue

        return self.quests

    def _parse_quest_record(self, quest_id: int, payload: bytes) -> Optional[Dict[str, Any]]:
        # Payload layout for 1.12.1 QuestCache:
        # duplicatedQuestId(I), questType(I), questLevel(i), zoneOrSort(i), infoId(I),
        # suggestedPlayers(I), factionId(I), factionAmount(I), unk1(I), unk2(I),
        # nextQuestId(I), rewMoney(I), rewXP(I), rewSpellId(I), effectOnPlayer(I),
        # startItemId(I), questFlags(I)
        # 4 Fixed Items: (item_id, count) * 4 -> 32 bytes
        # 6 Choice Items: (item_id, count) * 6 -> 48 bytes
        # 4 Unknown ints -> 16 bytes
        # Total numerical prefix: 17 * 4 + 32 + 48 + 16 = 164 bytes
        if len(payload) < 100:
            return None

        p_offset = 0
        (
            dup_id, q_type, q_level, zone_or_sort, info_id,
            sugg_players, fact_id, fact_amt, unk1, unk2,
            next_q_id, rew_money, rew_xp, rew_spell_id, eff_player,
            start_item_id, q_flags
        ) = struct.unpack_from("<IiiIIIIIIIIIIIIII", payload, p_offset)
        p_offset += 68

        # 4 Fixed item rewards
        fixed_rewards = []
        for _ in range(4):
            f_item, f_count = struct.unpack_from("<II", payload, p_offset)
            p_offset += 8
            if f_item > 0 and f_count > 0:
                fixed_rewards.append({"itemId": f_item, "count": f_count})

        # 6 Choice item rewards
        choice_rewards = []
        for _ in range(6):
            c_item, c_count = struct.unpack_from("<II", payload, p_offset)
            p_offset += 8
            if c_item > 0 and c_count > 0:
                choice_rewards.append({"itemId": c_item, "count": c_count})

        # Skip 4 unknown ints (16 bytes)
        p_offset += 16

        # Strings: Title, Objectives, Details, Completion
        title, p_offset = read_cstring(payload, p_offset)
        objectives, p_offset = read_cstring(payload, p_offset)
        details, p_offset = read_cstring(payload, p_offset)
        completion, p_offset = read_cstring(payload, p_offset)

        if not title:
            title = f"Quest #{quest_id}"

        # Calculate estimated minLevel if not explicitly stored
        min_level = max(1, q_level - 5) if q_level > 5 else 1

        return {
            "id": quest_id,
            "title": title,
            "level": q_level,
            "minLevel": min_level,
            "zoneOrSort": zone_or_sort,
            "suggestedPlayers": sugg_players,
            "nextQuestId": next_q_id if next_q_id > 0 else None,
            "rewMoney": rew_money,
            "rewXP": rew_xp,
            "rewSpellId": rew_spell_id if rew_spell_id > 0 else None,
            "startItemId": start_item_id if start_item_id > 0 else None,
            "flags": q_flags,
            "fixedRewards": fixed_rewards,
            "choiceRewards": choice_rewards,
            "objectivesText": objectives,
            "detailsText": details
        }


def create_sample_wdb_caches(out_dir: str):
    """
    Creates high-fidelity sample binary WDB cache files (itemcache.wdb and questcache.wdb)
    representing standard WoW Forever items and quests for automated testing and ingestion.
    """
    os.makedirs(out_dir, exist_ok=True)
    item_cache_path = os.path.join(out_dir, "itemcache.wdb")
    quest_cache_path = os.path.join(out_dir, "questcache.wdb")

    # Sample Items across Roles: TANK, HEAL, DPS
    sample_items = [
        {
            "id": 13340, "name": "Cape of the Black Baron", "quality": 3, "classId": 4, "subclassId": 1,
            "slot": 16, "ilvl": 63, "reqLvl": 58, "armor": 45, "stats": {3: 15, 32: 20}, # Agility, AP -> DPS
            "desc": "Baron Rivendare's regal cloak."
        },
        {
            "id": 12602, "name": "Draconian Deflector", "quality": 3, "classId": 4, "subclassId": 6,
            "slot": 14, "ilvl": 61, "reqLvl": 56, "armor": 2153, "block": 40, "stats": {7: 16, 12: 10}, # Stamina, Defense -> TANK
            "desc": "Heavy spiked dragon-scale shield."
        },
        {
            "id": 13170, "name": "Skystriker Bow", "quality": 3, "classId": 2, "subclassId": 2,
            "slot": 15, "ilvl": 60, "reqLvl": 55, "armor": 0, "stats": {3: 8, 7: 4}, # Agi, Stam -> DPS
            "dmg": (52.0, 97.0, 0), "speed": 2600,
            "desc": "Crafted by elven fletchers."
        },
        {
            "id": 11923, "name": "Haunting Specter Leggings", "quality": 3, "classId": 4, "subclassId": 1,
            "slot": 7, "ilvl": 57, "reqLvl": 52, "armor": 72, "stats": {5: 18, 6: 18, 36: 22}, # Int, Spirit, Healing -> HEAL
            "desc": "Woven with ghostly ethereal silk."
        },
        {
            "id": 6802, "name": "Shield of the Faith", "quality": 2, "classId": 4, "subclassId": 6,
            "slot": 14, "ilvl": 25, "reqLvl": 20, "armor": 580, "block": 15, "stats": {7: 5, 4: 4}, # Stamina, Strength -> TANK
            "desc": "Emblazoned with a protective sigil."
        },
        {
            "id": 2042, "name": "Staff of the Blessed", "quality": 2, "classId": 2, "subclassId": 10,
            "slot": 17, "ilvl": 24, "reqLvl": 19, "armor": 0, "stats": {5: 7, 6: 6, 36: 9}, # Int, Spirit, Healing -> HEAL
            "dmg": (34.0, 52.0, 0), "speed": 2900,
            "desc": "Blessed by the clergy."
        },
        {
            "id": 1928, "name": "Westfall Dagger", "quality": 2, "classId": 2, "subclassId": 15,
            "slot": 13, "ilvl": 18, "reqLvl": 13, "armor": 0, "stats": {3: 4, 7: 2}, # Agi, Stam -> DPS
            "dmg": (12.0, 24.0, 0), "speed": 1500,
            "desc": "Sharp Defias steel."
        },
        {
            "id": 10080, "name": "Deviate Hide Pack", "quality": 2, "classId": 1, "subclassId": 0,
            "slot": 18, "ilvl": 20, "reqLvl": 15, "armor": 0, "stats": {},
            "desc": "A 10-slot bag fashioned from cured deviate hides."
        }
    ]

    # Sample Quests
    sample_quests = [
        {
            "id": 1024, "title": "In Search of the Temple", "level": 52, "zone": 141, # Sunken Temple
            "money": 4500, "xp": 6800,
            "fixed": [(11923, 1)], # Haunting Specter Leggings (HEAL)
            "choices": [(12602, 1), (13170, 1)], # Draconian Deflector (TANK), Skystriker Bow (DPS)
            "objectives": "Investigate the submerged temple in the Swamp of Sorrows.",
            "details": "Fallen scholars speak of an ancient dragonkin stronghold deep within the mire."
        },
        {
            "id": 5144, "title": "Baron Rivendare's Demise", "level": 60, "zone": 2017, # Stratholme
            "money": 8200, "xp": 10200,
            "fixed": [(13340, 1)], # Cape of the Black Baron (DPS)
            "choices": [(12602, 1)],
            "objectives": "Slay Baron Rivendare within the Slaughter Square of Stratholme.",
            "details": "Break through the ziggurats and cleanse the undead presence once and for all."
        },
        {
            "id": 148, "title": "The People's Militia", "level": 14, "zone": 44, # Redridge / Westfall
            "money": 350, "xp": 1250,
            "fixed": [(1928, 1)], # Westfall Dagger (DPS)
            "choices": [(6802, 1)], # Shield of the Faith (TANK)
            "objectives": "Defeat the Defias Brigands and protect the Sentinel Hill outpost.",
            "details": "Gryan Stoutmantle demands proof of the bandits' defeat."
        },
        {
            "id": 1010, "title": "Deviate Hides", "level": 17, "zone": 17, # The Barrens
            "money": 450, "xp": 1800,
            "fixed": [(10080, 1)], # Deviate Hide Pack (10-slot Bag)
            "choices": [(2042, 1)], # Staff of the Blessed (HEAL)
            "objectives": "Collect 10 Deviate Hides from beasts in Wailing Caverns.",
            "details": "Nalpak requires fresh hides to craft durable pouches."
        }
    ]

    # Write itemcache.wdb
    with open(item_cache_path, "wb") as f:
        # Header: 'BDIW' (4 bytes), build=5875 (4 bytes), locale='SUne' (4 bytes), rec_size=0, rec_ver=1
        header = struct.pack("<4sI4sII", b"BDIW", 5875, b"SUne", 0, 1)
        f.write(header)

        for item in sample_items:
            payload = bytearray()
            # class_id, subclass_id, unk (-1)
            payload.extend(struct.pack("<III", item["classId"], item["subclassId"], 0xFFFFFFFF))
            # 4 names: primary name + 3 null bytes
            payload.extend(item["name"].encode("utf-8") + b"\x00")
            payload.extend(b"\x00\x00\x00")

            # 20 ints: display_id(1), quality, flags(0), buy(100), sell(25), slot
            # allow_class(-1), allow_race(-1), ilvl, reqLvl, req_skill(0), req_skill_lvl(0),
            # req_spell(0), req_rank(0), req_unk(0), req_faction(0), req_fac_lvl(0),
            # max_count(0), stackable(1), container_slots(0)
            payload.extend(struct.pack(
                "<IIIIIIiiIIIIIIIIIIII",
                100, item["quality"], 0, 1000, 250, item["slot"],
                -1, -1, item["ilvl"], item["reqLvl"], 0, 0,
                0, 0, 0, 0, 0, 0, 1, 0
            ))

            # 10 stat pairs
            stats_list = list(item.get("stats", {}).items())
            for i in range(10):
                if i < len(stats_list):
                    payload.extend(struct.pack("<ii", stats_list[i][0], stats_list[i][1]))
                else:
                    payload.extend(struct.pack("<ii", 0, 0))

            # 5 damage sets
            dmg = item.get("dmg", (0.0, 0.0, 0))
            payload.extend(struct.pack("<ffi", float(dmg[0]), float(dmg[1]), int(dmg[2])))
            for _ in range(4):
                payload.extend(struct.pack("<ffi", 0.0, 0.0, 0))

            # 7 Resistances: physical armor, 6 schools
            payload.extend(struct.pack("<7i", item.get("armor", 0), 0, 0, 0, 0, 0, 0))

            # Weapon delay, ammo_type, range_mod
            payload.extend(struct.pack("<iif", item.get("speed", 0), 0, 0.0))

            # 5 Spells (6 ints each = 24 bytes each)
            for _ in range(5):
                payload.extend(struct.pack("<6i", 0, 0, 0, 0, 0, 0))

            # Bonding (1 = BoP, 2 = BoE)
            payload.extend(struct.pack("<i", 1))

            # Description string
            payload.extend(item.get("desc", "").encode("utf-8") + b"\x00")

            # Block value padding if shield
            if item["slot"] == 14:
                # 36 bytes padding then block value
                payload.extend(b"\x00" * 36)
                payload.extend(struct.pack("<i", item.get("block", 25)))

            # Write record header: item_id, length
            rec_hdr = struct.pack("<II", item["id"], len(payload))
            f.write(rec_hdr)
            f.write(payload)

        # EOF marker: 8 null bytes
        f.write(b"\x00" * 8)

    # Write questcache.wdb
    with open(quest_cache_path, "wb") as f:
        # Header: 'TSQW' (reversed 'WQST')
        header = struct.pack("<4sI4sII", b"TSQW", 5875, b"SUne", 0, 1)
        f.write(header)

        for q in sample_quests:
            payload = bytearray()
            # dup_id, q_type, q_level, zone_or_sort, info_id, sugg_players, fact_id, fact_amt, unk1, unk2,
            # next_q, rew_money, rew_xp, rew_spell, eff_player, start_item, flags
            payload.extend(struct.pack(
                "<IiiIIIIIIIIIIIIII",
                q["id"], 2, q["level"], q["zone"], 0,
                1, 0, 0, 0, 0,
                0, q["money"], q["xp"], 0, 0,
                0, 0
            ))

            # 4 Fixed Items
            fixed = q.get("fixed", [])
            for i in range(4):
                if i < len(fixed):
                    payload.extend(struct.pack("<II", fixed[i][0], fixed[i][1]))
                else:
                    payload.extend(struct.pack("<II", 0, 0))

            # 6 Choice Items
            choices = q.get("choices", [])
            for i in range(6):
                if i < len(choices):
                    payload.extend(struct.pack("<II", choices[i][0], choices[i][1]))
                else:
                    payload.extend(struct.pack("<II", 0, 0))

            # 4 unknown ints (16 bytes)
            payload.extend(struct.pack("<4I", 0, 0, 0, 0))

            # Strings
            payload.extend(q["title"].encode("utf-8") + b"\x00")
            payload.extend(q.get("objectives", "").encode("utf-8") + b"\x00")
            payload.extend(q.get("details", "").encode("utf-8") + b"\x00")
            payload.extend(b"\x00") # completion string

            rec_hdr = struct.pack("<II", q["id"], len(payload))
            f.write(rec_hdr)
            f.write(payload)

        # EOF marker
        f.write(b"\x00" * 8)

    print(f"Created sample mock caches at: {item_cache_path} and {quest_cache_path}")


def main():
    parser = argparse.ArgumentParser(description="Parse WoW client WDB binary caches into diffable JSON files.")
    parser.add_argument("--items", default="WDB/itemcache.wdb", help="Path to itemcache.wdb")
    parser.add_argument("--quests", default="WDB/questcache.wdb", help="Path to questcache.wdb")
    parser.add_argument("--out", default="Data", help="Output directory for JSON files")
    parser.add_argument("--create-mock-wdb", action="store_true", help="Generate sample mock WDB caches for testing")

    args = parser.parse_args()

    if args.create_mock_wdb:
        wdb_dir = os.path.dirname(args.items) or "WDB"
        create_sample_wdb_caches(wdb_dir)

    os.makedirs(args.out, exist_ok=True)
    items_out = os.path.join(args.out, "items.json")
    quests_out = os.path.join(args.out, "quests.json")

    # Parse items if present
    if os.path.exists(args.items):
        print(f"Parsing items from {args.items}...")
        item_parser = ItemCacheParser(args.items)
        items_data = item_parser.parse()
        with open(items_out, "w", encoding="utf-8") as f:
            json.dump(items_data, f, indent=2, sort_keys=True)
        print(f"Saved {len(items_data)} items to {items_out}")
    else:
        print(f"Notice: Item cache not found at {args.items}. Skipping items.")

    # Parse quests if present
    if os.path.exists(args.quests):
        print(f"Parsing quests from {args.quests}...")
        quest_parser = QuestCacheParser(args.quests)
        quests_data = quest_parser.parse()
        with open(quests_out, "w", encoding="utf-8") as f:
            json.dump(quests_data, f, indent=2, sort_keys=True)
        print(f"Saved {len(quests_data)} quests to {quests_out}")
    else:
        print(f"Notice: Quest cache not found at {args.quests}. Skipping quests.")


if __name__ == "__main__":
    main()
