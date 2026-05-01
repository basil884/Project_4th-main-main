import json

def check_json(filename):
    print(f"Checking {filename}...")
    try:
        with open(filename, 'r', encoding='utf-8') as f:
            data = f.read()
            # Try to parse with standard json
            json.loads(data)
            print(f"  Standard JSON check passed.")
            
            # Manual check for duplicate keys
            keys = []
            import re
            found_keys = re.findall(r'"([^"]+)":', data)
            seen = set()
            dups = []
            for k in found_keys:
                if k in seen:
                    dups.append(k)
                seen.add(k)
            if dups:
                print(f"  Duplicate keys found: {dups}")
            else:
                print(f"  No duplicate keys found.")
    except Exception as e:
        print(f"  Error: {e}")

check_json('assets/translations/ar.json')
check_json('assets/translations/en.json')
