import csv
import json

file_path = "C:\\Users\\sky\\.gemini\\antigravity\\scratch\\hypermarket-app\\beverages.csv"

target_id = "1808893"
matches = []

with open(file_path, "r", encoding="utf-8") as f:
    reader = csv.DictReader(f)
    for row in reader:
        # Check if target_id is present in any field
        match = False
        for k, v in row.items():
            if v and target_id in v:
                match = True
                break
        if match:
            # Clean empty fields for readability
            clean_row = {k: v for k, v in row.items() if v and v.strip()}
            matches.append(clean_row)

print(f"Found {len(matches)} matching rows:")
print(json.dumps(matches, indent=2))
