#!/usr/bin/env python3
import yaml,pathlib,sys
data=yaml.safe_load(pathlib.Path('prompt-system/prompt_manifest.yaml').read_text()) or {}; ids=[p.get('id') for p in data.get('prompts',[])]; dup={x for x in ids if ids.count(x)>1}
print('canonical prompt ids unique' if not dup else 'duplicate canonical prompt ids')
sys.exit(1 if dup else 0)
