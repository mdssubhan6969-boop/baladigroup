import csv
import json

file_path = "C:\\Users\\sky\\.gemini\\antigravity\\scratch\\hypermarket-app\\carrefouruae (3).csv"

# Mapping from Carrefour categories to our app's fresh-food subcategories
category_mapping = {
    # Dairy & Eggs > Cheese & Labneh
    'vegan-cheese': 'Dairy & Eggs > Cheese & Labneh',
    'spread-processed-cheese': 'Dairy & Eggs > Cheese & Labneh',
    'edam-slices': 'Dairy & Eggs > Cheese & Labneh',
    'shredded-grated-cheese': 'Dairy & Eggs > Cheese & Labneh',
    'italian-cheese': 'Dairy & Eggs > Cheese & Labneh',
    'burrata': 'Dairy & Eggs > Cheese & Labneh',
    'mozzarella-whey-cheese': 'Dairy & Eggs > Cheese & Labneh',
    'local-cheese': 'Dairy & Eggs > Cheese & Labneh',
    'french-cheese': 'Dairy & Eggs > Cheese & Labneh',
    'cheddar-cheese': 'Dairy & Eggs > Cheese & Labneh',
    'soft-cheese-cottage': 'Dairy & Eggs > Cheese & Labneh',
    'labneh': 'Dairy & Eggs > Cheese & Labneh',
    
    # Dairy & Eggs > Yoghurt
    'greek-yogurt': 'Dairy & Eggs > Yoghurt',
    'low-fat-yogurt': 'Dairy & Eggs > Yoghurt',
    'full-fat-yogurt': 'Dairy & Eggs > Yoghurt',
    'flavored-greek-yogurt': 'Dairy & Eggs > Yoghurt',
    'flavoured-yoghurt': 'Dairy & Eggs > Yoghurt',
    'probiotic-yoghurt': 'Dairy & Eggs > Yoghurt',
    'drinking-yogurt': 'Dairy & Eggs > Yoghurt',
    
    # Dairy & Eggs > Milk & Laban
    'flavored-laban': 'Dairy & Eggs > Milk & Laban',
    'plain-laban': 'Dairy & Eggs > Milk & Laban',
    'full-fat-milk': 'Dairy & Eggs > Milk & Laban',
    'uht-flavored-milk': 'Dairy & Eggs > Milk & Laban',
    'uht-milk-low-fat': 'Dairy & Eggs > Milk & Laban',
    
    # Dairy & Eggs > Eggs
    'brown-eggs': 'Dairy & Eggs > Eggs',
    'white-eggs': 'Dairy & Eggs > Eggs',
    'omega-3-eggs': 'Dairy & Eggs > Eggs',
    
    # Dairy & Eggs > Butter & Margarine
    'unsalted-butter': 'Dairy & Eggs > Butter & Margarine',
    'frozen-unsalted-butter': 'Dairy & Eggs > Butter & Margarine',
    
    # Dairy & Eggs > Cream
    'whipping-cream': 'Dairy & Eggs > Cream',
    
    # Meat & Poultry > Chicken
    'whole-chicken': 'Meat & Poultry > Chicken',
    'chicken-wings': 'Meat & Poultry > Chicken',
    'chicken': 'Meat & Poultry > Chicken',
    'chicken-leg': 'Meat & Poultry > Chicken',
    'chicken-thigh': 'Meat & Poultry > Chicken',
    'prepared-chicken': 'Meat & Poultry > Chicken',
    
    # Meat & Poultry > Beef
    'beef': 'Meat & Poultry > Beef',
    'minced-meat': 'Meat & Poultry > Beef',
    'australian-beef': 'Meat & Poultry > Beef',
    'brazilian-beef': 'Meat & Poultry > Beef',
    
    # Meat & Poultry > Lamb
    'australian-lamb': 'Meat & Poultry > Lamb',
    
    # Meat & Poultry > Veal
    'asian-veal': 'Meat & Poultry > Veal',
    
    # Meat & Poultry > Offals
    'poultry-offals': 'Meat & Poultry > Offals',
    'lamb-offals': 'Meat & Poultry > Offals',
    
    # Fish & Seafood > Fish
    'sea-foods': 'Fish & Seafood > Fish',
    'fish': 'Fish & Seafood > Fish',
    
    # Fish & Seafood > Seafood
    'crab': 'Fish & Seafood > Seafood',
    'fresh-shrimp': 'Fish & Seafood > Seafood',
    
    # Chilled Food Counter > Cold Cuts & Meat Snacks
    'smoked-roasted-turkey': 'Chilled Food Counter > Cold Cuts & Meat Snacks',
    'turkey': 'Chilled Food Counter > Cold Cuts & Meat Snacks',
    'smoked-roasted-beef': 'Chilled Food Counter > Cold Cuts & Meat Snacks',
    
    # Chilled Food Counter > Olives & Antipasti
    'olives': 'Chilled Food Counter > Olives & Antipasti',
    'pickles': 'Chilled Food Counter > Olives & Antipasti',
    'antipasti': 'Chilled Food Counter > Olives & Antipasti',
    
    # Food To Go > Appetizers & Bites
    'cakes-tarts-pastry': 'Food To Go > Appetizers & Bites',
}

products = []
seen_names = set()

with open(file_path, "r", encoding="utf-8") as f:
    reader = csv.reader(f)
    header = next(reader)
    count = 1
    for row in reader:
        if len(row) < 8:
            continue
        url = row[0] or row[2]
        if not url:
            continue
        
        parts = url.split("/en/")
        if len(parts) > 1:
            raw_category = parts[1].split("/")[0]
            if raw_category in category_mapping:
                name = row[3].strip()
                if name in seen_names:
                    continue
                seen_names.add(name)
                
                # Image
                image = row[1]
                if not image or not image.startswith("http"):
                    image = "🛒"
                
                # Price info
                unit_info = row[4].strip()
                if "per Kilo" in unit_info:
                    unit = "kg"
                elif "per Liter" in unit_info:
                    unit = "L"
                else:
                    unit = "pc"
                
                price_main = row[5].strip()
                price_fraction = row[6].strip()
                try:
                    price = float(f"{price_main}{price_fraction}")
                except:
                    continue
                
                # Only fresh food for this mapping
                products.append({
                    "id": f"csv-ff-{count}",
                    "name": name,
                    "category": "fresh-food",
                    "subcategory": category_mapping[raw_category],
                    "price": price,
                    "unit": unit,
                    "image": image,
                    "tag": "Fresh"
                })
                count += 1

# Output as JS
with open("C:\\Users\\sky\\.gemini\\antigravity\\scratch\\hypermarket-app\\js\\new_products.js", "w", encoding="utf-8") as out:
    out.write("const CSV_PRODUCTS = ")
    json.dump(products, out, indent=2)
    out.write(";")

print(f"Exported {len(products)} fresh food products.")
