import os
import zipfile
import shutil

repo_dir = r"C:\Users\pecof\.gemini\antigravity\scratch\ForeverTankGuide"
desktop_zip = r"C:\Users\pecof\Desktop\HeathensForeverGuide.zip"
repo_zip = os.path.join(repo_dir, "HeathensForeverGuide.zip")

exclude_dirs = {".git", ".github", "Tools", "Data", "__pycache__", "ReferencePolestar"}
exclude_extensions = {".py", ".wdb", ".json", ".ps1", ".tmp", ".bak"}
exclude_files = {"HeathensForeverGuide.zip"}

print("Creating clean zip archive...")
with zipfile.ZipFile(repo_zip, "w", zipfile.ZIP_DEFLATED) as zipf:
    for root, dirs, files in os.walk(repo_dir):
        # Exclude directories
        dirs[:] = [d for d in dirs if d not in exclude_dirs and not d.startswith(".")]
        
        rel_dir = os.path.relpath(root, repo_dir)
        for f in files:
            if f in exclude_files:
                continue
            ext = os.path.splitext(f)[1].lower()
            if ext in exclude_extensions:
                continue
            
            full_path = os.path.join(root, f)
            arcname = os.path.join("HeathensForeverGuide", os.path.relpath(full_path, repo_dir))
            zipf.write(full_path, arcname)

# Copy to Desktop
shutil.copy2(repo_zip, desktop_zip)
print(f"Archive written to {repo_zip} and {desktop_zip}")

# Verify archive contents
with zipfile.ZipFile(repo_zip, "r") as zipf:
    names = zipf.namelist()
    print(f"Total files in archive: {len(names)}")
    print("Sample entries:")
    for n in names[:10]:
        print("  ", n)
    for n in names[-10:]:
        print("  ", n)
    
    # Check that every single file starts with HeathensForeverGuide/
    non_conforming = [n for n in names if not n.startswith("HeathensForeverGuide/")]
    if non_conforming:
        print("ERROR: Found non-conforming entries:", non_conforming[:5])
    else:
        print("VERIFIED: All entries strictly enclosed within HeathensForeverGuide/")
