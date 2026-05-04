#!/usr/bin/env python3
import yaml,pathlib,sys
check='--check' in sys.argv; root=pathlib.Path('prompt-system'); data=yaml.safe_load((root/'prompt_manifest.yaml').read_text()) or {}
lines=['# Prompt Index','', 'Generated from `prompt-system/prompt_manifest.yaml`.', '', '| ID | Stage | File | Status |','|---|---|---|---|']+[f"| `{p['id']}` | {p['stage']} | `{p['file']}` | {p['status']} |" for p in data.get('prompts',[])]
c='\n'.join(lines)+'\n'
if check and (root/'PROMPT_INDEX.md').read_text()!=c: print('PROMPT_INDEX.md stale',file=sys.stderr); sys.exit(1)
(root/'PROMPT_INDEX.md').write_text(c)
