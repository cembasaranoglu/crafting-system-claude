#!/usr/bin/env python3
import pathlib,argparse,sys
ap=argparse.ArgumentParser(); ap.add_argument('skills'); ap.add_argument('--max-lines',type=int,default=500); a=ap.parse_args(); ok=True
for f in pathlib.Path(a.skills).glob('*/SKILL.md'):
 if len(f.read_text().splitlines())>a.max_lines: print(str(f)+' too long',file=sys.stderr); ok=False
sys.exit(0 if ok else 1)
