import csv
import json
import os

csv_file = "C:\\Users\\sky\\.gemini\antigravity\\scratch\\hypermarket-app\\dairy & eggs.csv"

products = []
seen = set()

# Columns mappings
# format: (name_idx, image_idx, price_main_idx, price_frac_idx, link_idx)
mapping = [
    (4, 2, 5, 6, 1),      # Product 1
    (11, 9, 13, 14, 8),   # Product 2
    (19, 17, 20, 21, 16), # Product 3
    (28, 26, 29, 30, 25)  # Product 4
]

with open(csv_file, "r", encoding="utf-8") as f:
    reader = csv.reader(f)
    header = next(reader)
    count = 1
    for r_idx, row in enumerate(reader):
        for name_idx, img_idx, p_main_idx, p_frac_idx, link_idx in mapping:
            if name_idx >= len(row) or img_idx >= len(row) or p_main_idx >= len(row) or p_frac_idx >= len(row):
                continue
            
            name = row[name_idx].strip()
            image = row[img_idx].strip()
            p_main = row[p_main_idx].strip()
            p_frac = row[p_frac_idx].strip()
            
            # Skip if name is empty
            if not name:
                continue
                
            # Skip if duplicate name
            if name.lower() in seen:
                continue
                
            # Skip if image is empty or doesn't start with http
            if not image or not image.startswith("http"):
                continue
                
            # Try to parse price
            try:
                # Combine main and fraction (e.g. "11" and ".49" -> 11.49)
                price_str = f"{p_main}{p_frac}"
                if not price_str.startswith("."):
                    price_str = f"{p_main}{p_frac}"
                price = float(price_str.replace(" ", ""))
            except Exception as e:
                continue
                
            seen.add(name.lower())
            
            # Determine subcategory based on name or link
            subcategory = "Dairy & Eggs" # default
            link = row[link_idx].lower() if link_idx < len(row) else ""
            
            if "yoghurt" in name.lower() or "yogurt" in name.lower() or "yoghurt" in link or "yogurt" in link:
                subcategory = "Dairy & Eggs > Yoghurt"
            elif "milk" in name.lower() or "laban" in name.lower() or "milk" in link or "laban" in link:
                subcategory = "Dairy & Eggs > Milk & Laban"
            elif "cheese" in name.lower() or "labneh" in name.lower() or "cheese" in link or "labneh" in link:
                subcategory = "Dairy & Eggs > Cheese & Labneh"
            elif "butter" in name.lower() or "margarine" in name.lower() or "ghee" in name.lower() or "butter" in link:
                subcategory = "Dairy & Eggs > Butter & Margarine"
            elif "egg" in name.lower() or "eggs" in name.lower() or "egg" in link:
                subcategory = "Dairy & Eggs > Eggs"
            elif "cream" in name.lower() or "cream" in link:
                subcategory = "Dairy & Eggs > Cream"
                
            products.append({
                "id": f"p_de_{count}",
                "name": name,
                "category": "fresh-food",
                "subcategory": subcategory,
                "price": price,
                "unit": "pc",
                "image": image,
                "tag": "Fresh"
            })
            count += 1

# Output to JSON
json_out = "C:\\Users\\sky\\.gemini\\antigravity\\scratch\\hypermarket-app\\extracted_dairy.json"
with open(json_out, "w", encoding="utf-8") as out:
    json.dump(products, out, indent=2)

print(f"Extracted {len(products)} products and saved to extracted_dairy.json")
