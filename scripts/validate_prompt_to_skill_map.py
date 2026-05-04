#!/usr/bin/env python3
import sys,pathlib,yaml
p=pathlib.Path(sys.argv[1]); root=p.parents[1]; data=yaml.safe_load(p.read_text()) or {}; ok=True
for i in data.get('prompt_to_skill_map',[]):
 skill=i.get('skill')
 if not (root/'plugin/crafting-system/skills'/skill/'SKILL.md').exists(): print('missing skill '+str(skill), file=sys.stderr); ok=False
 for pr in i.get('prompts',[]):
  if not (root/'prompt-system/prompts'/pr).exists(): print(f'missing prompt {pr}', file=sys.stderr); ok=False
sys.exit(0 if ok else 1)
