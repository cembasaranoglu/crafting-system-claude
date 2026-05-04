#!/usr/bin/env python3
import sys, json, yaml, pathlib
root=pathlib.Path('.').resolve(); ok=True
def fail(msg):
    global ok; print(msg, file=sys.stderr); ok=False
# YAML parse
for f in list(root.rglob('*.yaml'))+list(root.rglob('*.yml')):
    if '.git' in f.parts or '__MACOSX' in f.parts: continue
    try: yaml.safe_load(f.read_text(encoding='utf-8'))
    except Exception as e: fail(f'{f}: YAML parse error {e}')
# JSON parse
for f in [root/'plugin/crafting-system/.claude-plugin/plugin.json', root/'plugin/crafting-system/.mcp.example.json', root/'plugin/crafting-system/hooks/hooks.json.example']:
    try: json.loads(f.read_text())
    except Exception as e: fail(f'{f}: JSON parse error {e}')
# Frontmatter
def fm(path):
    t=path.read_text(encoding='utf-8')
    if not t.startswith('---\n'): fail(f'{path}: missing frontmatter delimiter'); return {}
    e=t.find('\n---',4)
    if e<0: fail(f'{path}: missing closing frontmatter'); return {}
    try: return yaml.safe_load(t[4:e]) or {}
    except Exception as ex: fail(f'{path}: frontmatter parse error {ex}'); return {}
manual={'git-workflow','git-safety-automation','oss-ready-packager','risk-execution-control','secret-aware-runtime-credentials','mcp-permission-model','mcp-tooling-readiness','patch-diff-mode','readiness-aggregator','plugin-review','oss-release-readiness','readiness-gates','risk-gate'}
for f in (root/'plugin/crafting-system/skills').glob('*/SKILL.md'):
    data=fm(f)
    if data.get('name')!=f.parent.name: fail(f'{f}: skill name mismatch')
    if not data.get('description'): fail(f'{f}: missing description')
    if f.parent.name in manual and not data.get('disable-model-invocation'): fail(f'{f}: expected disable-model-invocation')
    if len(f.read_text().splitlines())>500: fail(f'{f}: too long')
for f in (root/'plugin/crafting-system/agents').glob('*.md'):
    data=fm(f)
    if not data.get('name') or not data.get('description'): fail(f'{f}: missing name/description')
    if {'hooks','mcpServers','permissionMode'} & set(data): fail(f'{f}: unsupported fields')
# prompt manifest
pm=yaml.safe_load((root/'prompt-system/prompt_manifest.yaml').read_text()) or {}; ids=[]
for p in pm.get('prompts',[]):
    ids.append(p.get('id'))
    if not (root/'prompt-system'/p.get('file','')).exists(): fail('missing prompt file '+str(p.get('file')))
    if not p.get('research_mode') or not p.get('execution_style'): fail('missing prompt contract '+str(p.get('id')))
if len(ids)!=len(set(ids)): fail('duplicate canonical prompt ids')
# prompt-to-skill map
ptsm=yaml.safe_load((root/'prompt-system/prompt_to_skill_map.yaml').read_text()) or {}
for item in ptsm.get('prompt_to_skill_map',[]):
    skill=item.get('skill')
    if not (root/'plugin/crafting-system/skills'/skill/'SKILL.md').exists(): fail('missing skill '+str(skill))
    for pr in item.get('prompts',[]):
        if not (root/'prompt-system/prompts'/pr).exists(): fail('missing mapped prompt '+str(pr))
# stage manifests
for f in [root/'stage_manifest.yaml', root/'prompt-system/stage_manifest.yaml']:
    data=yaml.safe_load(f.read_text()) or {}
    if not isinstance(data.get('stages'), list): fail(f'{f}: missing stages')
# execution matrix
em=yaml.safe_load((root/'prompt-system/policies/execution_class_matrix.yaml').read_text()) or {}
required={'analyze_only','plan_only','create_files','modify_repo','run_commands','external_write','release_publish'}
found={x.get('id') for x in em.get('execution_classes',[])}
if required-found: fail('execution matrix missing '+','.join(sorted(required-found)))
# evals and scorecards
sc=list((root/'prompt-system/prompt-tests/scenarios').glob('*.yaml'))
if len(sc)<30: fail('expected at least 30 scenarios')
for f in sc:
    d=yaml.safe_load(f.read_text()) or {}
    for k in ['id','title','category','expected_outcome','status']:
        if k not in d: fail(f'{f}: missing {k}')
for base in [root/'examples/scorecards', root/'scorecards']:
    for f in base.glob('*.yaml'):
        d=yaml.safe_load(f.read_text()) or {}
        if not all(k in d for k in ['overall','scores','evidence']): fail(f'{f}: invalid scorecard')
print('validate_all.py passed' if ok else 'validate_all.py failed')
sys.exit(0 if ok else 1)
