#!/usr/bin/env python3
import sys,pathlib,yaml
ok=True
for arg in sys.argv[1:]:
 for f in pathlib.Path(arg).rglob('*.md'):
  t=f.read_text(encoding='utf-8')
  if not t.startswith('---\n'): print(f'{f}: missing frontmatter delimiter', file=sys.stderr); ok=False; continue
  e=t.find('\n---',4)
  if e<0: print(f'{f}: missing closing delimiter', file=sys.stderr); ok=False; continue
  try: fm=yaml.safe_load(t[4:e]) or {}
  except Exception as ex: print(f'{f}: {ex}', file=sys.stderr); ok=False; continue
  if not fm.get('name') or not fm.get('description'): print(f'{f}: missing name/description', file=sys.stderr); ok=False
sys.exit(0 if ok else 1)
