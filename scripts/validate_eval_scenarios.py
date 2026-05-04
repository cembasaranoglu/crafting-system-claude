#!/usr/bin/env python3
import sys,pathlib,yaml
files=list(pathlib.Path(sys.argv[1]).glob('*.yaml')); ok=len(files)>=30
for f in files:
 d=yaml.safe_load(f.read_text()) or {}
 ok=ok and all(k in d for k in ['id','title','category','expected_outcome','status'])
print('eval scenarios valid' if ok else 'eval scenario error'); sys.exit(0 if ok else 1)
