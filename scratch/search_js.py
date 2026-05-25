import re

js_path = r"C:\Users\sky\.gemini\antigravity\scratch\hypermarket-app\js\cart.js"

with open(js_path, "r", encoding="utf-8") as f:
    lines = f.readlines()

patterns = ["live-deals-rows-container", "flash-deal", "Flash Deal", "carousel", "deals-row"]

for i, line in enumerate(lines):
    for pattern in patterns:
        if pattern in line:
            print(f"Line {i+1}: {line.strip()[:120]}")
            break
