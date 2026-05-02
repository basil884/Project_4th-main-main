import json, sys

sys.stdout.reconfigure(encoding='utf-8')

for fname in ['assets/translations/ar.json', 'assets/translations/en.json']:
    lines = open(fname, encoding='utf-8').readlines()
    for i, l in enumerate(lines, 1):
        if 'phone_number_label' in l:
            print(f'{fname} line {i}: {l.rstrip()}')

# Also check if easy_localization can see a BOM or encoding issue
for fname in ['assets/translations/ar.json', 'assets/translations/en.json']:
    raw = open(fname, 'rb').read(4)
    print(f'{fname} BOM bytes: {raw[:4].hex()}')
