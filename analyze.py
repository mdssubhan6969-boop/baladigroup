import csv
from collections import defaultdict
import json

file_path = "C:\\Users\\sky\\.gemini\\antigravity\\scratch\\hypermarket-app\\carrefouruae (3).csv"

categories = defaultdict(int)

with open(file_path, "r", encoding="utf-8") as f:
    reader = csv.reader(f)
    header = next(reader)
    for row in reader:
        if len(row) < 8:
            continue
        url = row[0] or row[2]
        if not url:
            continue
        parts = url.split("/en/")
        if len(parts) > 1:
            category = parts[1].split("/")[0]
            categories[category] += 1

print("Categories found:")
for k, v in sorted(categories.items(), key=lambda x: -x[1]):
    print(f"{k}: {v}")

