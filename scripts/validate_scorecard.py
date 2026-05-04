#!/usr/bin/env python3
import sys,pathlib,yaml
ok=True
for a in sys.argv[1:]:
 p=pathlib.Path(a); files=list(p.glob('*.yaml')) if p.is_dir() else [p]
 for f in files:
  d=yaml.safe_load(f.read_text()) or {}; ok=ok and all(k in d for k in ['overall','scores','evidence'])
print('scorecards valid' if ok else 'scorecard error'); sys.exit(0 if ok else 1)
