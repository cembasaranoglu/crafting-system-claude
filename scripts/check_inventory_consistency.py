#!/usr/bin/env python3
import sys,pathlib,json
root=pathlib.Path(sys.argv[sys.argv.index('--root')+1] if '--root' in sys.argv else '.')
json.loads((root/'artifact_inventory.json').read_text())
missing=[p for p in ['artifact_inventory.md','artifact_inventory.json','prompt-system/prompt_inventory.txt','run_summary.md'] if not (root/p).exists()]
print('inventory consistency check passed' if not missing else 'missing '+','.join(missing)); sys.exit(1 if missing else 0)
