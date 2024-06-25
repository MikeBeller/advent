#!/bin/env python
import sys
import shutil

year, num, prog, ext = sys.argv[1:]
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
