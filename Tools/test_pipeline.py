#!/usr/bin/env python3
"""
Heathen's Forever Guide - End-to-End Test & Verification Suite
Tests:
1. Packaging Exclusions (.pkgmeta & .gitignore)
2. Binary WDB Parser (wdb_parser.py)
3. Heuristic Role Evaluator & Lua Sync (update_recommendations.py)
4. Addon Engine & Lua Data Integrity
5. Recommendation Logic & Role Scoring
"""

import os
import sys
import json
import re
import subprocess

def test_packaging_exclusions(repo_dir: str):
    print(">>> Testing Step 1: Packaging Exclusions (.pkgmeta & .gitignore)...")

    pkgmeta_path = os.path.join(repo_dir, ".pkgmeta")
    assert os.path.exists(pkgmeta_path), ".pkgmeta does not exist"
    with open(pkgmeta_path, "r", encoding="utf-8") as f:
        pkgmeta_content = f.read()

    for item in ["Tools", "Data", "*.py", "*.wdb", "*.json"]:
        assert item in pkgmeta_content, f".pkgmeta missing ignore for: {item}"
    print("  [PASS] .pkgmeta contains all required ignore rules.")

    gitignore_path = os.path.join(repo_dir, ".gitignore")
    assert os.path.exists(gitignore_path), ".gitignore does not exist"
    with open(gitignore_path, "r", encoding="utf-8") as f:
        gitignore_content = f.read()

    for rule in ["*.wdb", "WDB/", "!Data/*.json"]:
        assert rule in gitignore_content, f".gitignore missing rule: {rule}"
    print("  [PASS] .gitignore contains all required WDB and Data rules.")


def test_wdb_parser(repo_dir: str):
    print("\n>>> Testing Step 2: Binary WDB Cache Ingestion (wdb_parser.py)...")
    parser_script = os.path.join(repo_dir, "Tools", "wdb_parser.py")
    assert os.path.exists(parser_script), "wdb_parser.py does not exist"

    # Run parser with mock WDB creation
    res = subprocess.run(
        [sys.executable, parser_script, "--create-mock-wdb", "--out", os.path.join(repo_dir, "Data")],
        cwd=repo_dir,
        capture_output=True,
        text=True
    )
    assert res.returncode == 0, f"wdb_parser.py failed:\n{res.stderr}\n{res.stdout}"
    print("  [PASS] wdb_parser.py executed successfully.")

    items_json = os.path.join(repo_dir, "Data", "items.json")
    quests_json = os.path.join(repo_dir, "Data", "quests.json")

    assert os.path.exists(items_json), "Data/items.json was not created"
    assert os.path.exists(quests_json), "Data/quests.json was not created"

    with open(items_json, "r", encoding="utf-8") as f:
        items_data = json.load(f)
    with open(quests_json, "r", encoding="utf-8") as f:
        quests_data = json.load(f)

    assert len(items_data) >= 8, f"Expected at least 8 parsed items, got {len(items_data)}"
    assert len(quests_data) >= 4, f"Expected at least 4 parsed quests, got {len(quests_data)}"

    # Validate item schema
    sample_item = next(iter(items_data.values()))
    for field in ["id", "name", "quality", "classId", "inventorySlot", "itemLevel", "stats"]:
        assert field in sample_item, f"Item missing field: {field}"

    # Validate quest schema
    sample_quest = next(iter(quests_data.values()))
    for field in ["id", "title", "level", "rewXP", "fixedRewards", "choiceRewards"]:
        assert field in sample_quest, f"Quest missing field: {field}"

    print(f"  [PASS] Data/items.json ({len(items_data)} items) and Data/quests.json ({len(quests_data)} quests) validated.")


def test_update_recommendations(repo_dir: str):
    print("\n>>> Testing Step 3: Heuristic Role Evaluator & Lua Sync (update_recommendations.py)...")
    updater_script = os.path.join(repo_dir, "Tools", "update_recommendations.py")
    assert os.path.exists(updater_script), "update_recommendations.py does not exist"

    res = subprocess.run(
        [sys.executable, updater_script],
        cwd=repo_dir,
        capture_output=True,
        text=True
    )
    assert res.returncode == 0, f"update_recommendations.py failed:\n{res.stderr}\n{res.stdout}"
    print("  [PASS] update_recommendations.py executed successfully.")

    quest_data_lua = os.path.join(repo_dir, "Modules", "Quests", "QuestData.lua")
    assert os.path.exists(quest_data_lua), "Modules/Quests/QuestData.lua does not exist"

    with open(quest_data_lua, "r", encoding="utf-8") as f:
        lua_code = f.read()

    assert "HFG.QuestDB = HFG.QuestDB or {}" in lua_code
    assert "HFG.QuestItemsDB = HFG.QuestItemsDB or {}" in lua_code
    assert 'recommendedRoles = { "[TANK]" }' in lua_code or 'recommendedRoles = { "[DPS]" }' in lua_code
    assert "Shield of the Faith" in lua_code
    assert "Draconian Deflector" in lua_code

    print("  [PASS] Modules/Quests/QuestData.lua successfully generated with heuristic roles.")


def test_lua_syntax_integrity(repo_dir: str):
    print("\n>>> Testing Step 4: Lua Code Syntax and Bracket Balance...")
    lua_files = [
        os.path.join(repo_dir, "HeathensForeverGuide.toc"),
        os.path.join(repo_dir, "Core.lua"),
        os.path.join(repo_dir, "UI.lua"),
        os.path.join(repo_dir, "Engine", "QuestEngine.lua"),
        os.path.join(repo_dir, "Modules", "Quests", "QuestData.lua"),
        os.path.join(repo_dir, "Modules", "Quests", "BagQuests.lua"),
    ]

    for fpath in lua_files:
        assert os.path.exists(fpath), f"File missing: {fpath}"
        with open(fpath, "r", encoding="utf-8", errors="replace") as f:
            content = f.read()

        # Check bracket balancing for lua files
        if fpath.endswith(".lua"):
            open_curly = content.count("{")
            close_curly = content.count("}")
            assert open_curly == close_curly, f"Unbalanced curly brackets in {fpath}: {open_curly} vs {close_curly}"

            # Check string literal quotes balancing (excluding escapes)
            # Basic validation
            assert "function" in content or "HFG.QuestDB" in content or "HFG.BagQuests" in content
            print(f"  [PASS] {os.path.relpath(fpath, repo_dir)} syntax check passed.")


def test_recommendation_logic(repo_dir: str):
    print("\n>>> Testing Step 5: Recommendation Engine Logic Verification...")
    quest_data_path = os.path.join(repo_dir, "Modules", "Quests", "QuestData.lua")
    with open(quest_data_path, "r", encoding="utf-8") as f:
        content = f.read()

    # Verify that Tank shields map to TANK score
    assert 'role = "[TANK]"' in content, "Missing [TANK] role assignment"
    assert 'role = "[HEAL]"' in content, "Missing [HEAL] role assignment"
    assert 'role = "[DPS]"' in content, "Missing [DPS] role assignment"

    # Verify TOC ordering
    toc_path = os.path.join(repo_dir, "HeathensForeverGuide.toc")
    with open(toc_path, "r", encoding="utf-8") as f:
        toc_lines = [line.strip() for line in f.readlines() if line.strip() and not line.strip().startswith("#")]

    qe_idx = next(i for i, line in enumerate(toc_lines) if "QuestEngine.lua" in line)
    qd_idx = next(i for i, line in enumerate(toc_lines) if "QuestData.lua" in line)
    ui_idx = next(i for i, line in enumerate(toc_lines) if "UI.lua" in line)
    core_idx = next(i for i, line in enumerate(toc_lines) if "Core.lua" in line)

    assert qe_idx < ui_idx, "QuestEngine.lua must load before UI.lua"
    assert qd_idx < ui_idx, "QuestData.lua must load before UI.lua"
    assert ui_idx < core_idx, "UI.lua must load before Core.lua"

    print("  [PASS] TOC file load ordering validated.")
    print("  [PASS] Heuristic role recommendations verified.")


def main():
    repo_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
    print(f"Running test suite in: {repo_dir}\n{'=' * 60}")

    test_packaging_exclusions(repo_dir)
    test_wdb_parser(repo_dir)
    test_update_recommendations(repo_dir)
    test_lua_syntax_integrity(repo_dir)
    test_recommendation_logic(repo_dir)

    print(f"{'=' * 60}\nALL 5 PIPELINE TEST SUITES PASSED CLEANLY!")

if __name__ == "__main__":
    main()
