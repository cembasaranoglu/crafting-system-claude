#!/usr/bin/env python3
import yaml,pathlib,sys
data=yaml.safe_load(pathlib.Path('prompt-system/prompt_manifest.yaml').read_text()) or {}; ok=True
for p in data.get('prompts',[]):
 if not p.get('research_mode') or not p.get('execution_style'): print('missing contract '+p.get('id',''),file=sys.stderr); ok=False
sys.exit(0 if ok else 1)
