#!/usr/bin/env python3
import pathlib,json
print(json.dumps({'scenario_count':len(list(pathlib.Path('prompt-system/prompt-tests/scenarios').glob('*.yaml'))),'model_outputs_evaluated':0,'status':'not_run_without_model_outputs'}))
