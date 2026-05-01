import json, sys

sys.stdout.reconfigure(encoding='utf-8')

def remove_duplicate_keys(filepath):
    """Read JSON file, keep first occurrence of each key, rewrite file."""
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Parse to find duplicates — Python's json.loads uses last value for dups
    # We need to preserve first occurrence, so parse line by line
    lines = content.split('\n')
    seen_keys = {}
    result_lines = []
    removed = []
    
    for line in lines:
        stripped = line.strip()
        # Check if this line has a key (starts with " after optional spaces)
        if stripped.startswith('"') and '":' in stripped:
            # Extract key
            key = stripped.split('"')[1]
            if key in seen_keys:
                removed.append((key, line))
                # Skip this duplicate line
                # Also remove trailing comma from previous line if needed
                continue
            else:
                seen_keys[key] = True
        result_lines.append(line)
    
    # Fix any trailing commas before } (from removed lines)
    # Join and re-parse to validate
    new_content = '\n'.join(result_lines)
    
    # Validate
    try:
        json.loads(new_content)
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"SUCCESS: {filepath} cleaned. Removed {len(removed)} duplicate(s):")
        for k, l in removed:
            print(f"  - '{k}'")
    except json.JSONDecodeError as e:
        print(f"ERROR after cleanup: {e}")
        print("Trying to fix trailing comma...")
        import re
        new_content = re.sub(r',(\s*\n\s*})', r'\1', new_content)
        try:
            json.loads(new_content)
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(new_content)
            print(f"SUCCESS after trailing comma fix.")
        except json.JSONDecodeError as e2:
            print(f"STILL FAILED: {e2}")

remove_duplicate_keys('assets/translations/ar.json')
remove_duplicate_keys('assets/translations/en.json')
