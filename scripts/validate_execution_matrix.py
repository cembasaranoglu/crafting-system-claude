#!/usr/bin/env python3
import sys,yaml,pathlib
data=yaml.safe_load(pathlib.Path(sys.argv[1]).read_text()) or {}; found={x.get('id') for x in data.get('execution_classes',[])}; req={'analyze_only','plan_only','create_files','modify_repo','run_commands','external_write','release_publish'}
missing=req-found
print('execution matrix valid' if not missing else 'missing '+','.join(missing)); sys.exit(1 if missing else 0)
