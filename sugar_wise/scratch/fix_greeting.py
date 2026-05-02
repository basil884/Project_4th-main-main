import sys

filepath = r'lib\features\doctor\doctor_home\view\doctor_home.dart'

with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

old = '                          "${\"hello\".tr()} ${profileViewModel.doctorName} ",'
new = '                          "greet_doctor".tr(\n                            args: [profileViewModel.doctorName]\n                          ),'

if old in content:
    content = content.replace(old, new, 1)
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)
    print("SUCCESS: replaced greeting line")
else:
    # Try alternate quoting
    print("NOT FOUND, trying alternate...")
    # Print the actual characters around line 232
    lines = content.split('\n')
    for i, line in enumerate(lines[228:235], start=229):
        print(f"{i}: {repr(line)}")
