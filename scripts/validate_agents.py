#!/usr/bin/env python3
import sys,pathlib,yaml
ok=True
for f in pathlib.Path(sys.argv[1]).glob('*.md'):
 t=f.read_text(); e=t.find('\n---',4); fm=yaml.safe_load(t[4:e]) or {}
 if not t.startswith('---\n') or not fm.get('name') or not fm.get('description'): print(f'{f}: bad frontmatter',file=sys.stderr); ok=False
 if {'hooks','mcpServers','permissionMode'} & set(fm): print(f'{f}: unsupported field',file=sys.stderr); ok=False
sys.exit(0 if ok else 1)
