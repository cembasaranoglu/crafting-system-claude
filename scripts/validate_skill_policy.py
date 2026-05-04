#!/usr/bin/env python3
import sys,pathlib,yaml
manual={'git-workflow','git-safety-automation','oss-ready-packager','risk-execution-control','secret-aware-runtime-credentials','mcp-permission-model','mcp-tooling-readiness','patch-diff-mode','readiness-aggregator','plugin-review','oss-release-readiness','readiness-gates','risk-gate'}; ok=True
for f in pathlib.Path(sys.argv[1]).glob('*/SKILL.md'):
 t=f.read_text(); fm=yaml.safe_load(t[4:t.find('\n---',4)]) or {}
 if fm.get('name')!=f.parent.name: print(f'{f}: name mismatch',file=sys.stderr); ok=False
 if f.parent.name in manual and not fm.get('disable-model-invocation'): print(f'{f}: should be manual-only',file=sys.stderr); ok=False
sys.exit(0 if ok else 1)
