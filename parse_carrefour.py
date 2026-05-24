import csv
import json
import os

# Path to the CSV file
csv_path = r"C:/Users/sky/.gemini/antigravity/scratch/hypermarket-app/carrefouruae (3).csv"

items = []
seen = set()

with open(csv_path, newline='', encoding='utf-8') as csvfile:
    reader = csv.reader(csvfile)
    for row in reader:
        if len(row) < 5:
            continue
        # Expected columns based on snippet: url, image_url, product_url, name, price, quantity?, ...
        name = row[3].strip()
        image_url = row[1].strip()
        # Use placeholder emoji if image_url is empty
        img = image_url if image_url else "🛒"
        # Deduplicate by name
        key = name.lower()
        if key in seen:
            continue
        seen.add(key)
        items.append({"name": name, "image": img, "price": row[4].strip() if len(row) > 4 else ""})

# Output as markdown list
md_lines = ["# Carrefour Items (Deduplicated)\n"]
for item in items:
    md_lines.append(f"- **{item['name']}**  
  - Image: {item['image']}  
  - Price: {item['price']}")

output_path = os.path.join(os.path.dirname(csv_path), "carrefour_items.md")
with open(output_path, "w", encoding="utf-8") as f:
    f.write("\n".join(md_lines))

print(f"Generated {output_path} with {len(items)} items.")
