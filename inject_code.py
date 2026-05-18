import re
import glob
import os

md_path = r"C:\Users\User\OneDrive - London Metropolitan University\Documents\advance\SlotSync_Section4_Java_Classes_and_Methods_for_Antigravity.md"
java_base_dir = r"C:\Users\User\OneDrive - London Metropolitan University\Documents\GitHub\Slotsync\src\main\java"

with open(md_path, 'r', encoding='utf-8') as f:
    lines = f.readlines()

new_lines = []

java_files = {}
for root, dirs, files in os.walk(java_base_dir):
    for file in files:
        if file.endswith('.java'):
            java_files[file[:-5]] = os.path.join(root, file)

def extract_method(class_name, method_name):
    if class_name not in java_files:
        return f"// Error: Class {class_name} not found"
    
    with open(java_files[class_name], 'r', encoding='utf-8') as f:
        content = f.read()
    
    lines = content.split('\n')
    start_idx = -1
    for i, line in enumerate(lines):
        pattern = r'\b(public|private|protected)\b.*?\b' + re.escape(method_name) + r'\s*\('
        if re.search(pattern, line):
            start_idx = i
            # Look backwards for annotations or javadocs? Just grab the method signature is fine.
            break
            
    if start_idx == -1:
        return f"// Error: Method {method_name} not found in {class_name}"
        
    method_lines = []
    brace_count = 0
    started = False
    
    # backtrack one line if it has an annotation like @Override
    if start_idx > 0 and '@' in lines[start_idx-1]:
        start_idx -= 1
        
    for i in range(start_idx, len(lines)):
        line = lines[i]
        method_lines.append(line)
        brace_count += line.count('{') - line.count('}')
        if '{' in line:
            started = True
        if started and brace_count == 0:
            break
            
    return '\n'.join(method_lines)

i = 0
while i < len(lines):
    line = lines[i]
    match = re.search(r'\[CODE:\s*\*\*([A-Za-z0-9_]+)\.([A-Za-z0-9_]+)\*\*\]', line)
    if match and line.strip().startswith('|'):
        class_name = match.group(1)
        method_name = match.group(2)
        code = extract_method(class_name, method_name)
        new_lines.append(f"```java\n{code}\n```\n")
        
        # skip the next line which is `| --- |`
        if i + 1 < len(lines) and lines[i+1].strip() == '| --- |':
            i += 1
    else:
        new_lines.append(line)
    i += 1

out_path = md_path.replace('.md', '_completed.md')
with open(out_path, 'w', encoding='utf-8') as f:
    f.writelines(new_lines)

print(f"Completed processing. Saved to {out_path}")
