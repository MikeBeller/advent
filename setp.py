#!/bin/env python
import sys
import shutil

args = sys.argv
year = args[1]
num = args[2]
prog = args[3] if len(args) > 3 else "python"
ext = args[4] if len(args) > 4 else ".py"
num = f"{int(num):02d}"
if "." not in ext:
  ext = "." + ext

toml = f"""
run = "cd {year}/{num}; {prog} {year}{num}{ext}"
entrypoint = "{year}/{num}/{year}{num}{ext}"

[env]
PYTHONPATH="/home/runner/advent/{year}/lib"
PATH="/home/runner/advent/bin"


[nix]
#channel = "stable-22_11"
channel = "stable-23_05"
"""

shutil.copy(".replit", ".replit.old")
open(".replit","w").write(toml)
