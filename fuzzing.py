#!/usr/bin/env python

import argparse
import os

def args():
	parser = argparse.ArgumentParser(description="Fuzzing")
	parser.add_argument("--program", type=str, help="Program to run", required=False, default="./program")
	return parser.parse_args()

if __name__ == "__main__":
	args = args()
        pattern = os.popen("./pattern.py 10000").read()
        f = open("pattern.txt", "w")
	f.write(pattern)
        f.close()
	rbp = os.popen("echo 'r < pattern.txt' | gdb -q " + args.program).read()
        rbp = rbp.split("'")[1]
        offset = os.popen("./pattern.py " + rbp).read()
        offset = int(offset.split(" ")[6]) + 8
        os.system("rm pattern.txt")
	print offset
