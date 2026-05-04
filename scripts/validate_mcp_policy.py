#!/usr/bin/env python3
import sys,json,pathlib
json.loads(pathlib.Path(sys.argv[1]).read_text()); print('mcp example valid')
