#!/usr/bin/env python3
import sys,yaml,pathlib
p=pathlib.Path(sys.argv[1]); root=p.parent; data=yaml.safe_load(p.read_text()) or {}; ids=set(); ok=True
for x in data.get('prompts',[]):
 if x.get('id') in ids: print('duplicate '+x.get('id',''), file=sys.stderr); ok=False
 ids.add(x.get('id'))
 if not (root/x.get('file','')).exists(): print('missing '+x.get('file',''), file=sys.stderr); ok=False
sys.exit(0 if ok else 1)
