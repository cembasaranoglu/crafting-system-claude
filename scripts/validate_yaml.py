#!/usr/bin/env python3
import sys,pathlib,yaml
ok=True
for arg in sys.argv[1:] or ['.']:
 p=pathlib.Path(arg); files=[p] if p.is_file() else list(p.rglob('*.yaml'))+list(p.rglob('*.yml'))
 for f in files:
  if '.git' in f.parts or '__MACOSX' in f.parts: continue
  try: yaml.safe_load(f.read_text(encoding='utf-8'))
  except Exception as e: print(f'{f}: {e}', file=sys.stderr); ok=False
sys.exit(0 if ok else 1)
