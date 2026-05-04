#!/usr/bin/env python3
import sys,yaml,pathlib
ok=True
for a in sys.argv[1:]:
 data=yaml.safe_load(pathlib.Path(a).read_text()) or {}
 if not isinstance(data.get('stages'),list): print(f'{a}: missing stages', file=sys.stderr); ok=False
 for st in data.get('stages',[]):
  if not st.get('id') or not any(k in st for k in ('prompt','prompts','path')): print(f'{a}: invalid {st}', file=sys.stderr); ok=False
sys.exit(0 if ok else 1)
